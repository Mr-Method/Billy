$(document).ready( function() {
    $('.add_client').click( function(){
         console.log($("#client-add-form form").serialize());
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
});

function ClearForm() {
    $("#client-add-form form :input").not(":hidden").val('');
    window.location.reload();
}
