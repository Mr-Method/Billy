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

1;

