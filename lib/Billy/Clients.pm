package Billy::Clients;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

our $VERSION = '0.1';

prefix '/clients';


any ['get', 'post'] => '/list' => sub{
    my $clients_sql = qq{ SELECT * from clients};
    my $sth = database->prepare( $clients_sql );
    $sth->execute();
     
    template 'clients_list.tt' , { client_list => $sth->fetchall_hashref('id') };
     
};


any ['get', 'post'] => '/add' => sub{
    template 'clients_add.tt';
};

any ['get', 'post'] => '/create' => sub {
    my $company_name    =  params->{'company_name'};
    my $contact_fname   =  params->{'contact_fname'};
    my $contact_lname   =  params->{'contact_lname'};
    my $address_1       =  params->{'address_1'};
    my $address_2       =  params->{'address_2'};
    my $city            =  params->{'city'};
    my $state           =  params->{'state'};
    my $phone           =  params->{'phone'};
    my $zip_code        =  params->{'zip_code'};
    my $website         =  params->{'website'};
    my $params = params(); 
    # use qq to put sql in double quote 
    my $sth = database->prepare(qq{ INSERT INTO clients (company_name,address_1,address_2,city,state,phone,website,zip_code,contact_fname, contact_lname) VALUES ( ?,?,?,?,?,?,?,?,?,?)} );
    $sth->execute($company_name, $address_1, $address_2, $city, $state, $phone, $website, $zip_code,$contact_fname,$contact_lname);
      template "create_success.tt" , { company_name =>  $company_name };
};

any ['get', 'post'] => '/edit' => sub {
    my $query = "select * from clients where id = ?";
    my $sth = database->prepare($query);
    $sth->execute(params->{client_id});
    
    template 'client_edit.tt', { client_info =>$sth->fetchrow_hashref(),};
    
};

true;
