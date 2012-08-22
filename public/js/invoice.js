$(document).ready( function() {
    $('.add_item').click( function(){
        var $list =  $('#invoice-description table tr').length;
        var $item_num = $list++;
        $('#invoice-description table').append('<tr class="item"><td><button type="button" id="confirm_item">confirm</button></td><td><input type="text" size="10" id="item_quantity" name="item_'+$item_num+'_quantity" /></td><td><textarea type="text" cols="75" rows="2" name="item_'+$item_num+'_description" id="item_description"></textarea></td><td><input type="text" name="item_'+$item_num+'_price" id="item_price"/></td><td><input id="item_total" readonly="readonly" /></td></tr> '); 
        add_events();
    });

    
    $('.save_invoice').click( function(){
        console.log($('#invoice-description').find(':hidden, :text, textarea').serialize());
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

    add_events();
    

});

function add_events() {
    $('.item #confirm_item').on("click",function(){
        console.log($(this).parents('.item').find('input[type="text"], textarea') );
        $(this).parents('.item').find(':text, textarea').attr('readonly', 'readonly');
        
    });
    
    $('.item #item_quantity').keyup( function() {
        $item_quantity = $(this).val();
        console.log("Item Quantity: " + $item_quantity);
	$item_price = $(this).parents('.item').find('#item_price').val();
        console.log("Item Price: " + $item_price);
               
	if( $item_price < 0 ) {
            console.log("Nothing is calculated");
	} else if ($item_price >= 1 ) {
            $total_amount = $item_price * $item_quantity;
            $(this).parents('.item').find('#item_total').val($total_amount);
            invoice_total();
	};
    });
    
    
        $('.item #item_price').keyup( function() {
        $item_price = $(this).val();
	$item_quantity = $(this).parents('.item').find('#item_quantity').val();
         console.log("Item Price: " + $item_price);
         console.log("Item Quantity: " + $item_quantity);
	if( $item_quantity < 0 ) {
            console.log("Nothing is calculated");
	} else if ($item_quantity >= 1 ) {
            $total_amount = $item_price * $item_quantity;
            $(this).parents('.item').find('#item_total').val($total_amount);
            invoice_total();
	};
        
    });
}
 
function invoice_total(){
    var $invoice=0;
    $('table .item #item_total').each(function() {

        if ( !isNaN(this.value) && this.value.length != 0 ) {
            $invoice += parseFloat(this.value);  
        }
    });
    $('#invoice_total').val($invoice);
    $invoice = 0;
}
