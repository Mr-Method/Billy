package Billy::Model::Invoice;

use strict;
use Dancer::Plugin::Database;


sub new {
    my $class = shift;
    my $self = shift;
    my $invoice_sql = "INSERT INTO invoices (client_id,company_info_id,company_ship_id) VALUES (?,?,?)";
    my $invoice_dbh= database();
    my $invoice_sth= $invoice_dbh->prepare($invoice_sql);
    $invoice_sth->execute($self->{client_id},$self->{company_info_id}, $self->{company_ship_id});
    $self->{invoice_id} =  $invoice_dbh->last_insert_id("","","invoices","id");
    
    bless($self, $class );
    return $self;

};

sub invoice_number {
     my $self = shift; 
     return $self->{invoice_id};
};

sub invoice_list {
   my $self = shift;

   my $query = "select * from invoices inner join clients on invoices.client_id = clients.id";
    
   my $sth = database->prepare($query);
   $sth->execute;
   return $sth->fetchall_hashref('invoice_number');
};

1;
