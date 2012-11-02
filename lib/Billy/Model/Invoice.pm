package Billy::Model::Invoice;

use strict;
use Dancer::Plugin::Database;
use Data::Dumper;

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
   my $class = shift;

   my $query = "select * from invoices inner join clients on invoices.client_id = clients.id";
    
   my $sth = database->prepare($query);
   $sth->execute;
   return $sth->fetchall_hashref('invoice_number');
};

sub update {
   my $class = shift; 
   my $args = shift;
   my %item_group;
   my $invoice_number = $args->{invoice_id};
   my $current_invoice_items = fetch_items($invoice_number);
   
    foreach my $param_name ( keys(%$args)) {
       # Regex to filter out params that are not item specific.
	unless( $param_name =~ m/^item_(\d*)_(description|quantity|price)$/ ){
	    next;
	}
        my $item_order = $1;
	$item_group{$item_order}{$param_name} = $args->{$param_name};
    };
    my $insert_items_sql = qq{INSERT INTO invoice_items (invoice_number, description, order_num, quantity, price) values (?,?,?,?,?)};
    my $update_items_sql =  qq{UPDATE invoice_items set description = ?  , quantity = ? ,  price= ? where invoice_number = ? and order_num = ?};

    
    foreach my $order ( keys(%item_group) ){
	
	 my $description = $item_group{$order}->{"item_".$order."_description"};
	 my $quantity = $item_group{$order}->{"item_".$order."_quantity"};
	 my $price = $item_group{$order}->{"item_".$order."_price"};
	 
	 #  If invoice item exist in current_invoice_items hash if so just  update.
	 if  (  exists ($current_invoice_items->{$order} ) ) {
	     my $sth_inv = database->prepare($update_items_sql);
	     $sth_inv->execute($description,$quantity,$price,$invoice_number,$order);
	 } else {
	 #  If invoice item doesn't exist then insert.
	     my $sth_inv = database->prepare($insert_items_sql);
	      $sth_inv->execute($invoice_number,$description,$order,$quantity,$price);
	 }
    };
      return 1;
};

sub fetch_items {
    my  $invoice_number  =  shift;
    my $items_sql  = "Select *  from invoice_items  where invoice_number = ? ";
     
     my $sth_invoice_items = database->prepare($items_sql);
     $sth_invoice_items->execute($invoice_number);
     return $sth_invoice_items->fetchall_hashref('order_num');
};

1;
