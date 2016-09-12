package Billy::Model::Clients;

use strict;
#use Dancer2::Plugin::Database;
use Data::Dumper;

sub new {
  my $class = shift; 
  my $self = shift;
  
  if ( $self->{id} ){
    my $query = "select * from clients where id = ?";
    my $sth = database->prepare($query);
    $sth->execute($self->{id});
    $self = $sth->fetchrow_hashref();
    bless($self, $class);
    return $self;
  } else {
    # create the client 
    # check required fields.
    my $fields = $self;
    my $field_check = check_required_fields($fields);
    
    if (  $field_check->{status_code} == 1) { 	
     
      my $company_name    =  $self->{company_name};
      my $contact_fname   =  $self->{contact_fname};
      my $contact_lname   =  $self->{contact_lname};
      my $address_1       =  $self->{address_1};
      my $address_2       =  $self->{address_2};
      my $city            =  $self->{city};
      my $state           =  $self->{state};
      my $phone           =  $self->{phone};
      my $zip_code        =  $self->{zip_code};
      my $website         =  $self->{website};
       
      # use qq to put sql in double quote 
      my $client_dbh = database();
      my $sth = database->prepare(qq{ INSERT INTO clients (company_name,address_1,address_2,city,state,phone,website,zip_code,contact_fname, contact_lname) VALUES ( ?,?,?,?,?,?,?,?,?,?)} );
      $sth->execute($company_name, $address_1, $address_2, $city, $state, $phone, $website, $zip_code,$contact_fname,$contact_lname);
      $self->{id} = $client_dbh->last_insert_id("","","clients","id");
    };
    bless($self, $class);
    return $self;
  };      
};

sub fetchall {
  my $query = "SELECT * from clients";
  my $sth = database->prepare($query);
  $sth->execute;
  return $sth->fetchall_hashref('id');
};

sub invoice_client {
  my $self = shift;
  my $invoice_num = shift;
  my $query = "SELECT * from clients where id = (select client_id from invoices where invoice_number = ?)";
  my $sth = database->prepare($query);
  $sth->execute($invoice_num);
    
  return $sth->fetchrow_hashref();

};

sub check_required_fields {
  my $self = shift;
  my $fields = shift;

  my $status = {};

  
  for my $key ( keys( %$fields ) ) {	
    # only field that is optional is address2
    my $value = $fields->{$key};	
    if ( $key eq "address_2" ) {
	  next;
    } 
    
    if( $value  eq "") {
      $status->{status_code} = 0;
      $status->{status_text} = "Field: $key  is empty.";
      return $status;
    } else {
	  next;	
    }
  };
  $status->{status_code} = 1;
  $status->{status_text} = "ok";
  return $status;
};

sub save_client {
  my $self = shift; 
  my $params = shift;
  # check required fields.
  my $field_check = check_required_fields($params);
  if (  $field_check->{status_code} == 1) { 	
      my $company_name    =  $params->{company_name};
      my $contact_fname   =  $params->{contact_fname};
      my $contact_lname   =  $params->{contact_lname};
      my $address_1       =  $params->{address_1};
      my $address_2       =  $params->{address_2};
      my $city            =  $params->{city};
      my $state           =  $params->{state};
      my $phone           =  $params->{phone};
      my $zip_code        =  $params->{zip_code};
      my $website         =  $params->{website};
      my $client_id       =  $params->{client_id};
    
    # update client information
    my $sth = database->prepare( qq{
        UPDATE clients SET company_name= ?, address_1 = ?, address_2 = ?, city = ?, state = ?, phone = ?, website = ?, zip_code = ?, contact_fname = ?, contact_lname = ? where id = ? });
    # TODO:write code to capture error in sql execute and return 0  
      $sth->execute( $company_name, $address_1, $address_2, $city, $state, $phone, $website, $zip_code, $contact_fname, $contact_lname, $client_id );
    return 1; 
  } else {
    return 0;    
  }; 
	
}

1;

