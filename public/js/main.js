$(document).ready(function() {
    $('[data-toggle="tab"]').tooltip()

    $('#accordion .panel-heading').click(function() {
        $(this).parent().find('.collapse').collapse('toggle');
    });

    // collapse all other collapsibles when a collapsible is shown
    $('.collapse').on('show.bs.collapse', function() {
        var showing = $(this).attr('id');

        $('.collapse').each(function() {
            //if (showing != $(this).attr('id')) {
                $(this).collapse('hide');
            //}
        });
    });
});

function makeid() {
    var text = "";
    var possible = "abcdefghijklmnopqrstuvwxyz";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

function captchaCallback() {
    $('.g-recaptcha').each(function() {
        $(this).attr('id', makeid());
        grecaptcha.render($(this).attr('id'), {'sitekey': '6Lcn8BITAAAAAM-OFAx5x1GoZLT__SCoLM8_ZmoQ'});
    });
}
