$(document).ready( function() {
    $('.add_client').click( function(){
         $.ajax({
                url: '/clients/create',
                type: 'POST',
                data:$("#client-add-form form").serialize(),
                dataType: "html",
                success: function(message) {
                            alert(message);
                            ClearForm();
                },
                error: function(){
                        alert( 'An error occured');
                }
         });
    });
    
    $('.save_client').click( function(){
         $.ajax({
                url: '/clients/save',
                type: 'POST',
                data:$("#client-edit-form form").serialize(),
                dataType: "html",
                success: function(message) {
                            alert(message);
                            ClearForm();
                },
                error: function(){
                        alert( 'An error occured');
                }
         });
    });
    
    $('.update_client').click( function(){
         $.ajax({
                url: '/clients/update',
                type: 'POST',
                data:$("#client-edit-form form").serialize(),
                dataType: "html",
                success: function(message) {
                            alert(message);
                            ClearForm();
                },
                error: function(){
                        alert( 'An error occured');
                }
         });
    });
});

function ClearForm() {
    $("#client-add-form form :input").not(":hidden").val('');
    window.location.reload();
}
