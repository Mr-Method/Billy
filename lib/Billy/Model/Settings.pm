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
