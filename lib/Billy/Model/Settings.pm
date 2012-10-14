package Billy::Model::Settings;

use Dancer::Plugin::Database;


sub new {
    my $class = shift;
    my $self = {
        active_company_info => {},
        active_company_ship_info => {}
    };
    bless($self, $class);
    return $self;
};

sub active_company_ship_info {
    my $self = shift;
    my $query = "select * from company_ship where active = '1'";
    my $sth = database->prepare($query);
    $sth->execute();
    $self->{active_company_ship_info}  = $sth->fetchrow_hashref();
    return $self->{active_company_ship_info};
};

sub active_company_info {
    my $self = shift;
    my $query = "select * from company_info where active = '1'";
    my $sth = database->prepare($query);
    $sth->execute();
    $self->{active_company_info}  = $sth->fetchrow_hashref();
    return $self->{active_company_info};
};

sub invoice_company_info {
    my $self = shift;
    my $invoice_id = shift;
    
    my $query = "select * from  company_info where company_info.company_info_id = ( select company_info_id  from invoices where invoice_number= ? )";
    my $sth_comp_info = database->prepare($query);
    $sth_comp_info->execute($invoice_id);
    $self->{invoice_comp_info} = $sth_comp_info->fetchrow_hashref();
    return $self->{invoice_comp_info};

};

sub invoice_ship_info {
    my $self = shift;
    my $invoice_id = shift;
    
    my $query = "select * from company_ship where company_ship.company_ship_id = ( select company_ship_id from invoices where invoice_number = ? )";
    my $sth_ship_info = database->prepare($query);
    $sth_ship_info->execute($invoice_id);
    $self->{invoice_ship_info} = $sth_ship_info->fetchrow_hashref();
    return $self->{invoice_ship_info};

};

sub clear_active_company_ship_info {
    my $self = shift;
    
    # Check if active company_info exists.
    if ( $self->{active_company_info} ) {
	# if so update that single row.

    } else { 
	my $update_active_query = qq{ update company_ship set active = 0 where active = 1; };
	my $ua_sth = database->prepare($update_active_query);
	$ua_sth->execute();
    

    };
  $self->{active_company_ship_info} ={};
};

1;
