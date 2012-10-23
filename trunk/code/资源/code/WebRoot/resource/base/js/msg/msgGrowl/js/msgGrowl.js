(function ($) {
    $.msgGrowl = function (config) {
        var defaults, options, container, msgGrowl, content, title, text, close;
        defaults = {
            type: '',
            title: '',
            text: '',
            lifetime: 6500,
            sticky: false,
            position: 'bottom-right',
            closeTrigger: true,
            onOpen: function () {},
            onClose: function () {}
        };
        options = $.extend(defaults, config);
        container = $('.msgGrowl-container.' + options.position);
        if (!container.length) {
            container = $('<div>', {
                'class': 'msgGrowl-container ' + options.position
            }).appendTo('body')
        }
        msgGrowl = $('<div>', {
            'class': 'msgGrowl ' + options.type
        });
        content = $('<div>', {
            'class': 'msgGrowl-content'
        }).appendTo(msgGrowl);
        text = $('<span>', {
            html: options.text
        }).appendTo(content);
        if (options.closeTrigger) {
            close = $('<div>', {
                'class': 'msgGrowl-close',
                'click': function (e) {
                    e.preventDefault();
                    $(this).parent().fadeOut('medium', function () {
                        $(this).remove();
                        if (typeof options.onClose === 'function') {
                            options.onClose()
                        }
                    })
                }
            }).appendTo(msgGrowl)
        }
        if (options.title != '') {
            title = $('<h4>', {
                text: options.title
            }).prependTo(content)
        }
        if (options.lifetime > 0 && !options.sticky) {
            setTimeout(function () {
                if (typeof options.onClose === 'function') {
                    options.onClose()
                }
                msgGrowl.fadeOut('medium', function () {
                    $(this).remove()
                })
            }, options.lifetime)
        }
        container.addClass(options.position);
        if (options.position.split('-')[0] == 'top' || options.position.split('-')[0] == 'center') {
            msgGrowl.prependTo(container).hide().fadeIn('slow')
        } else {
            msgGrowl.appendTo(container).hide().fadeIn('slow')
        }
        if (typeof options.onOpen === 'function') {
            options.onOpen()
        }
    }
})(jQuery);
var ZtreeBasePath = (function() {
		var strFullPath = window.document.location.href;
		var strPath = window.document.location.pathname;
		var pos = strFullPath.indexOf(strPath);
		var prePath = strFullPath.substring(0, pos);
		var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
		return prePath + postPath;
	})()+"/";
document.write("<link rel='stylesheet' type='text/css' href='"+ZtreeBasePath+"/resource/base/js/msg/msgGrowl/css/msgGrowl.css'/>");