package Billy::Invoice;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;

our $VERSION = '0.1';

prefix '/invoice';



any ['get', 'post'] => '/new' => sub {
    # IF client_id is passed then we render invoice page.
    
    if (params->{client_id}){
	my  $client_id = params->{client_id};
	
        my $query = "select * from clients where id = ?";
        my $sth = database->prepare($query);
        $sth->execute($client_id);
        my $client_info = $sth->fetchrow_hashref();
	
       	my $ship_query = "select * from company_ship where active = 1";
	my $ship_sth = database->prepare($ship_query);
	$ship_sth->execute;
	my $ship_info =  $ship_sth->fetchrow_hashref();
	
	my $company_query = "select * from company_info where active = 1";
	my $company_sth = database->prepare($company_query);
	$company_sth->execute;
	my $company_info = $company_sth->fetchrow_hashref();
	
	### Create an invoice record and return the invoice number ###
	### TODO: Add the active address and ship information ###
	
	my $invoice_sql = "INSERT INTO invoices (client_id) VALUES (?)";
	my $invoice_dbh= database();
	my $invoice_sth= $invoice_dbh->prepare($invoice_sql);
	$invoice_sth->execute($client_id);
        my $invoice_id =  $invoice_dbh->last_insert_id("","","invoices","id");
	
        template 'invoice.tt' , {
		    client_info 	=> 	$client_info,
		    ship_info		=>	$ship_info,
		    company_info	=>	$company_info,
		    invoice_id		=>	$invoice_id
		    };
        
    } else {
        my $query = "SELECT * from clients";
	my $sth = database->prepare($query);
        $sth->execute;
    	my $client_list = $sth->fetchall_hashref('id');
	

        template 'invoice.tt', {
		client_list	=>	$client_list,
	};
    };
};

any ['get', 'post'] => '/list' => sub {
   my $query = "select * from invoices inner join clients on invoices.client_id = clients.id";
   my $sth = database->prepare($query);
   $sth->execute;
   
   template 'invoice_list.tt', { invoice_list => $sth->fetchall_hashref('invoice_number')}
};

ajax '/create' => sub {
	
	my $invoice_id = params->{'invoice_id'};
	
	# here I need to write sql to create an invoice and add items to that invoice.
	my %args = params();
	my %item_group;
	
	foreach my $param_name ( keys(%args)) {
		    # Regex to filter out params that are not item specific.
			unless( $param_name =~ m/^item_(\d*)_(description|quantity|price)$/ ){
				next;
			}
			my $item_order = $1;
			$item_group{$item_order}{$param_name} = $args{$param_name};
	};
	my $items_sql = "INSERT INTO invoice_items (invoice_number, description, order_num, quantity, price) values (?,?,?,?,?)";
	
	foreach my $order ( keys(%item_group) ){
		 my $sth_inv = database->prepare($items_sql);
		 my $description = $item_group{$order}->{"item_".$order."_description"};
		 my $quantity = $item_group{$order}->{"item_".$order."_quantity"};
		 my $price = $item_group{$order}->{"item_".$order."_price"};
		 
		 $sth_inv->execute($invoice_id,$description,$order,$quantity,$price);
	};
    
};

any ['get'] => '/edit' => sub {
    my $invoice_id = params->{invoice_id};
    my $invoice_query = "select * from invoice_items where invoice_number = ?";
    
    my $sth_inv = database->prepare($invoice_query);
    $sth_inv->execute($invoice_id);
    
    my $invoice_items = $sth_inv->fetchall_hashref('order_num');
    template 'invoice_edit.tt' , { invoice_items => $invoice_items };
};

true;
