$(document).ready( function() {
       events();

});

function events() {
    
    $('.item #item_quantity').keyup( function() {
        $item_quantity = $(this).val();
	$item_price = $(this).parents('.item').find('#item_price').val();
               
	if( $item_price < 0 ) {
            // console.log("Nothing is calculated");
           // Add code to display zero 
	} else if ($item_price >= 1 ) {
            $total_amount = $item_price * $item_quantity;
            $(this).parents('.item').find('#item_total').val($total_amount);
            invoice_total();
	};
    });
    
    
        $('.item #item_price').keyup( function() {
            $item_price = $(this).val();
            $item_quantity = $(this).parents('.item').find('#item_quantity').val();
	if( $item_quantity < 0 ) {
            console.log("Nothing is calculated");
           // Add code to display zero 
	} else if ($item_quantity >= 1 ) {
            $total_amount = $item_price * $item_quantity;
            $(this).parents('.item').find('#item_total').val($total_amount.toFixed(2));
            invoice_total();
	};
        
    });


     $('.add_item').click( function(){
            var $list =  $('#invoice-description table tr').length;
            var $item_num = $list++;
            $('#invoice-description table').append('<tr class="item"><td><button type="button" id="confirm_item">confirm</button></td><td><input type="text" size="10" id="item_quantity" name="item_'+$item_num+'_quantity" /></td><td><textarea type="text" cols="75" rows="2" name="item_'+$item_num+'_description" id="item_description"></textarea></td><td><input type="text" name="item_'+$item_num+'_price" id="item_price"/></td><td><input id="item_total" readonly="readonly" /></td></tr> '); 
            add_events();
     });
    
        
     $('.save_invoice').click( function(){
        // console.log($('#invoice-description').find(':hidden, :text, textarea').serialize());
         $.ajax({
             url:'/invoice/create',
             type:'POST',
             data:$('#invoice-description').find(':hidden, :text, textarea').serialize(),
             dataType:"html",
             success: function(message) {
                 alert(message);
             },
             error: function(){
               alert( 'An error occured');
             }
             
         })
     });


}
 
function invoice_total(){
    var $invoice=0;
    $('table .item #item_total').each(function() {

        if ( !isNaN(this.value) && this.value.length != 0 ) {
            $invoice += parseFloat(this.value);  
        }
    });
    $('#invoice_total').val($invoice.toFixed(2));
    $invoice = 0;
}

