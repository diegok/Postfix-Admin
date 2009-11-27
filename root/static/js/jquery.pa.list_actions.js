$().ready(function() {
    // toggle check-boxes list
    $('input.toggle').each(function() {
        var cb   = $(this);
        var name = cb.attr('id');
        cb.change(function(){
            //$('input[name=' + name + ']').attr('checked', cb.attr('checked'));
            $('input[name=' + name + ']').each(function() {
                var item = $(this);
                item.attr('checked', cb.attr('checked'));
                item.change(function() {
                    if ( ! item.attr('checked') ) {
                        cb.attr( 'checked', false );
                    }  
                });
            });
        });
    });
});
