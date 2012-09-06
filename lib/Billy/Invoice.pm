package Billy::Invoice;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

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

	# TODO: Need a way to inform user about inactive company shipment information
	
       	my $ship_query = "select * from company_ship where active = 1";
	    my $ship_sth = database->prepare($ship_query);
	    $ship_sth->execute;
	    my $ship_info =  $ship_sth->fetchrow_hashref();
	
	# TODO: Need a way to inform user about missing company  information

	    my $company_query = "select * from company_info where active = 1";
	    my $company_sth = database->prepare($company_query);
	    $company_sth->execute;
	    my $company_info = $company_sth->fetchrow_hashref();
	
	### Create an invoice record and return the invoice number ###
		    
	    my $invoice_sql = "INSERT INTO invoices (client_id,company_info_id,company_ship_id) VALUES (?,?,?)";
	    my $invoice_dbh= database();
	    my $invoice_sth= $invoice_dbh->prepare($invoice_sql);
	    $invoice_sth->execute($client_id,$company_info->{company_info_id}, $ship_info->{company_ship_id});
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
    
    # Fetch company_info and company_shipping information
    my $comp_info_query = "select * from  company_info where company_info.company_info_id = ( select company_info_id  from invoices where invoice_id = ? )";
    my $sth_comp_info = database->prepare($comp_info_query);
    $sth_comp_info->execute($invoice_id);
    my $comp_info = $sth_comp_info->fetchrow_hashref();
    
    
    my $ship_info_query = "select * from company_ship where company_ship.company_ship_id = ( select company_ship_id from invoices where invoice_id = ? )";
    my $sth_ship_info = database->prepare( $ship_info_query );
    $sth_ship_info->execute($invoice_id);
    my $ship_info = $sth_ship_info->fetchrow_hashref();
    
    template 'invoice_edit.tt' , { invoice_items => $invoice_items, ship_info => $ship_info, company_info => $comp_info };
};

any ['get'] => '/delete' => sub { 
    my $invoice_id = params->{invoice_id};
    my $delete_param = params->{delete} || 0;
    
    if ( $delete_param == 0 ) { 
	# render a page that will display invoice information and request to confirm deletion 

    } elsif ( $delete_param == 1 ) {
        # delete the invoice completely. Gotta fix this query 
	
	my $delete_sql = "Delete a.*, b* from invoices a left join invoice_items b on a.invoice_id = b.invoice_number  where a.invoice_id = $invoice_id";
	my $sth_delete = database->do($delete_sql);
        template 'invoice_deleted.tt' , { invoice_id => $invoice_id };	
    }
		
};


true;
