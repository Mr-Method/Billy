package Billy::Model::Clients;

use strict;
use Dancer::Plugin::Database;

sub new {
  my $class = shift; 
  my $self = {
    id => shift || '',
    client_list => '',
  };
  
  if ( $self->{id} ){
    
    my $query = "select * from clients where id = ?";
    my $sth = database->prepare($query);
    $sth->execute($self->{id});
    $self = $sth->fetchrow_hashref();
  }
 
        
   bless($self, $class);
   return $self;
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

1;

