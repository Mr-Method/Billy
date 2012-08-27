package Billy::Config;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

our $VERSION = '0.1';

prefix '/config';

# Code blocks for company information settings
any ['get', 'post'] => '/company_info' => sub { 
    
    # display form to update company_info table
    
    template 'company_info.tt';
    
};

any ['get','post'] => '/add_info' => sub {
        # take params and store data in company_ship table
        my $modify_date = localtime();
        my $active = params->{active};
        
        my @sql_args = ( 
            params->{company_name},
            params->{address},
            params->{address2},
            params->{phone},
            params->{fax},
            params->{city},
            params->{state},
            params->{zipcode},
            params->{country},
            $active,
            $modify_date
        );
        if ( $active == 1) {
				# write some sql to update all active company_info records.
				my $update_active_query = qq{ update company_info set active = 0 where active = 1; };
				my $ua_sth = database->prepare($update_active_query);
				$ua_sth->execute();
		};
		
        my $query = qq{ INSERT INTO company_info (company_name,address,address2,phone,fax,city,state,zipcode,country,active,modify_date) VALUES (?,?,?,?,?,?,?,?,?,?,?) };
        my $sth = database->prepare($query);

        $sth->execute(@sql_args);
        
        
        template 'company_add_info.tt';
};


# code blocks for company shipment information

any ['get','post'] => '/company_ship' => sub{
    # display form to update/edit company_ship table
        my $query = "select * from company_ship where active = '1'";
        my $sth = database->prepare($query);
        $sth->execute();
        
        template 'company_ship.tt', { company_ship => $sth->fetchrow_hashref() };
};

any ['get','post'] => '/add_ship' => sub{
    # take params and store data in company_ship table
        my $modify_date = localtime();
        my $active = params->{active};
        
        my @sql_args = ( 
            params->{company_name},
            params->{contact_name},
            params->{address},
            params->{address2},
            params->{city},
            params->{state},
            params->{zipcode},
            params->{country},
            $active,
            $modify_date
        );
        
         if ( $active == 1) {
				# write some sql to update all active company_ship records.
				my $update_active_query = qq{ update company_ship set active = 0 where active = 1; };
				my $ua_sth = database->prepare($update_active_query);
				$ua_sth->execute();
		};
        my $query =
        "INSERT INTO company_ship
        (company_name,contact_name,address,address2,city,state,zipcode,country,active,modify_date)
         VALUES (?,?,?,?,?,?,?,?,?,?)
        ";
        my $sth = database->prepare($query);
        $sth->execute(@sql_args);
        template 'company_add_ship.tt';    
};
true;
