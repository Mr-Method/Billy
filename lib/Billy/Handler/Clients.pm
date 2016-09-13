package Billy::Handler::Clients;
use Dancer2 appname => 'Billy';
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Ajax;
use Data::Dumper;

our $VERSION = '0.1';

prefix '/clients' => sub {


    get '/list' => sub{
        my $clients_sql = qq{ SELECT * from clients};
        my $sth = database->prepare( $clients_sql );
        $sth->execute();
         
        template 'clients_list.tt' , { client_list => $sth->fetchall_hashref('id') };
         
    };
    
    
    get '/add' => sub{
        template 'clients_add.tt';
    };
    
    post '/save' => sub {
        my $params = params();
        my $client_save = Billy::Model::Clients->save_client($params);
    
        if ( $client_save == 1) {
          error "client saved:" . to_dumper($params);
          return "Client $params->{company_name} was saved.";
        } else {
          error "There is a problem saving client:" . to_dumper($params);
          return "Sorry, There was a problem saving $params->{company_name}.";
        }
        
    };
    
    
    post '/create' => sub {
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
    
    get '/edit' => sub {
        my $client = Billy::Model::Clients->new({ id => params->{client_id} } );
            
        template 'client_edit.tt', { client_info => $client};
        
    };
    
    post '/update' => sub {
        #TODO: Fetch current values and then compare with passed parameters.
        # once you know which values are different construct your sql update statement
        # with the updated params.
         
        my $update_params = params();
        
        my $query = "update client set ";
        my $sth = database->prepare($query);
        $sth->execute(params->{client_id});
        
        template 'client_update_sucess.tt', { client_info =>};
        
    };
    
    post '/delete' => sub {
        my $client_id = params->{client_id};
        my $delete_param = params->{delete} || 0;
        if ( $delete_param == 1 ) { 
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

};

true;
