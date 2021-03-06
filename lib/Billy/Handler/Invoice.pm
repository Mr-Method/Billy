package Billy::Handler::Invoice;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

use Billy::Model::Invoice;
use Billy::Model::Clients;

our $VERSION = '0.1';

prefix '/invoice';



any ['get', 'post'] => '/new' => sub {
    # IF client_id is passed then we render invoice page.
    
    if (params->{client_id}){
        my  $client_id = params->{client_id};
	
        my $client_info = Billy::Model::Clients->new( {id =>$client_id});

    	# TODO: Need a way to inform user about inactive company shipment information
    	# TODO: Need a way to inform user about missing company  information
    	my $ship_info = Billy::Model::Settings->active_company_ship_info;	
    	my $company_info = Billy::Model::Settings->active_company_info;	
        my $invoice = Billy::Model::Invoice->new({
            client_id => $client_id,
            company_info_id => $company_info->{company_info_id},
            company_ship_id => $ship_info->{company_ship_id}
        });
    
    	my $invoice_id = $invoice->invoice_number;
 
        template 'invoice.tt' , {
		    client_info 	=> 	$client_info,
		    ship_info		=>	$ship_info,
		    company_info	=>	$company_info,
		    invoice_id		=>	$invoice_id
		};
        
    } else {
    	my $client_list = Billy::Model::Clients->fetchall;
	

        template 'invoice.tt', {
		    client_list	=>	$client_list,
	    };
    };
};

any ['get', 'post'] => '/list' => sub {
   my $invoice_list = Billy::Model::Invoice->invoice_list(); 
   template 'invoice_list.tt', { invoice_list => $invoice_list}; 
};

any ['get','post'] => '/create' => sub {
    my $params = params();
    my $invoice_id = params->{'invoice_id'};
    my $invoice_update = Billy::Model::Invoice->update($params);
    if  ($invoice_update == 1) {
        return "Invoice#  $invoice_id  has been saved";
    } else {
        error  "Failed to update invoice# $invoice_id";
    }
};

any ['get'] => '/edit' => sub {
    my $invoice_id = params->{invoice_id};
    my $invoice_query = "select * from invoice_items where invoice_number = ?";
    
    my $sth_inv = database->prepare($invoice_query);
    $sth_inv->execute($invoice_id);
    my $invoice_items = $sth_inv->fetchall_hashref('order_num');
    my $invoice_total = Billy::Model::Invoice::total($invoice_id); 

    my $comp_info = Billy::Model::Settings->invoice_company_info($invoice_id);
    my $ship_info = Billy::Model::Settings->invoice_ship_info($invoice_id);
    my $client_info = Billy::Model::Clients->invoice_client($invoice_id);
    template 'invoice_edit.tt' , { 
        invoice_items => $invoice_items,
        ship_info => $ship_info, 
        company_info => $comp_info,
        client_info => $client_info,
        invoice_id => $invoice_id,
        invoice_total => $invoice_total 
    };
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
