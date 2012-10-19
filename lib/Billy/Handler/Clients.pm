package Billy::Handler::Clients;
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

any ['get', 'post'] => '/save' => sub {
	my $params = params();

    # update client row.
    
    # return confirmation message.	
	
};


ajax '/create' => sub {
  my $params = params(); 
  # makes more sense to do field validation here
  my $field_check = Billy::Model::Clients->check_required_fields($params);
  
  if ( $field_check->{status_code} == 1 ) {

    my $client = Billy::Model::Clients->new($params);
    return "$client->{company_name} is now a new client";

  } else {
     return to_xml( $field_check->{status_text});
  };

};

any ['get', 'post'] => '/edit' => sub {
    my $client = Billy::Model::Clients->new({ id => params->{client_id} } );
        
    template 'client_edit.tt', { client_info => $client};
    
};

any ['get', 'post'] => '/update' => sub {
    #TODO: Fetch current values and then compare with passed parameters.
    # once you know which values are different construct your sql update statement
    # with the updated params.
     
    my $update_params = params();
    
    my $query = "update client set ";
    my $sth = database->prepare($query);
    $sth->execute(params->{client_id});
    
    template 'client_update_sucess.tt', { client_info =>};
    
};
any ['get', 'post'] => '/delete' => sub {
    my $client_id = params->{client_id};
    my $delete_param = params->{delete} || 0;
    if ( $delete_param == 1 ) { 
      print STDERR " params " . Dumper(params());
      my $delete_query = "delete from clients where id = $client_id";
      my $delete_sth = database->do($delete_query); 
      template 'client_delete.tt', {client_id => $client_id};
    } else { 
      my $client_sql = "select * from clients where id = ?";
      my $sth_client_info =  database->prepare($client_sql);
      $sth_client_info->execute($client_id);
      template 'confirm_client_delete.tt', { client_info => $sth_client_info->fetchrow_hashref() };  
   }
};


true;
