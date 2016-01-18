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

    $('#therapy-form').submit(function() {
        ajaxPostRequest($(this), function(data) {
            if (data.status == "success") {
                $('#therapy-status')
                    .attr('class','text-success')
                    .html('Thank you! We have received your appointment request, we will get back to you shortly.')
            } else if (data.status == "error") {
                $('#therapy-status')
                    .attr('class','text-warning')
                    .html('Error: ' + data.message);
            } else if (data.status == "fatal") {
                $('#therapy-status')
                    .attr('class', 'text-danger')
                    .html('There was an error processing your request. Please email us or give us a call if the error persists.');
            }
        });
        return false;
    });

    $('#workshop-form').submit(function() {
        ajaxPostRequest($(this), function(data) {
            if (data.status == "success") {
                $('#workshop-status')
                    .attr('class','text-success')
                    .html('Thank you! We have received your workshop requirement, we will get back to you shortly.')
            } else if (data.status == "error") {
                $('#workshop-status')
                    .attr('class','text-warning')
                    .html('Error: ' + data.message);
            } else if (data.status == "fatal") {
                $('#workshop-status')
                    .attr('class', 'text-danger')
                    .html('There was an error processing your request. Please email us or give us a call if the error persists.');
            }
        });
        return false;
    });

    $('#contact-form').submit(function() {
        ajaxPostRequest($(this), function(data) {
            if (data.status == "success") {
                $('#contact-status')
                    .attr('class','text-success')
                    .html('Thank you! We have received your message and will get back to you shortly.')
            } else if (data.status == "error") {
                $('#contact-status')
                    .attr('class','text-warning')
                    .html('Error: ' + data.message);
            } else if (data.status == "fatal") {
                $('#contact-status')
                    .attr('class', 'text-danger')
                    .html('There was an error processing your request. Please email us or give us a call if the error persists.');
            }
        });
        return false;
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

function ajaxPostRequest(form, callback) {
    $.post(form.data('action'), form.serialize(), callback, "json");
}
