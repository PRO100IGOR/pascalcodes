(function ($) {
	$.closeBar = function(bar){
	    bar.slideUp('medium', function () {
		$(this).remove()
	    })
    };
    $.msgBar = function (config) {
        var defaults, options, bar, icon, close,container;
        defaults = {
            type: '',
            title: '',
            text: '',
            lifetime: 0,
            position: 'center-center',
            closeTrigger: true
        };
        options = $.extend(defaults, config);
        container = $('.msgBar-container.' + options.position);
        if (!container.length) {
            container = $('<div>', {
                'class': 'msgBar-container ' + options.position
            }).appendTo('body')
        }
        bar = $('<div>', {
            'class': 'msgBar ' + options.type,
            'html': options.text
        });
        icon = $('<div>', {
            'class': 'icon'
        }).appendTo(bar);
        if (options.closeTrigger) {
            close = $('<div>', {
                'class': 'close',
                'text': 'x',
                'click': closeBar
            }).appendTo(bar)
        }
        if (options.lifetime > 0) {
            setTimeout(function () {
                closeBar()
            }, options.lifetime)
        }
        function closeBar() {
            bar.slideUp('medium', function () {
                $(this).remove()
            })
        }
        if (options.position.split('-')[0] == 'top' || options.position.split('-')[0] == 'center') {
            bar.prependTo(container).hide().fadeIn('slow')
        } else {
            bar.appendTo(container).hide().fadeIn('slow')
        }
        return bar
    };
    
    function getcookiemsgbar(cookiename){
    	var arrStr = document.cookie.split("; "),strIn;
	    for (var i = 0; i < arrStr.length; i++) {
	        var temp = arrStr[i].split("=");
	        if (temp[0] == cookiename) strIn = temp[1];
	    }
	    return strIn;
    }
    $.cmoxhide = function(cookiename,types){
    	if(getcookiemsgbar(cookiename + "flag")) return;
    	var strIn = getcookiemsgbar(cookiename);
	    if(strIn){
			var intLen = strIn.length;
			var strOut = "";
			var strTemp;
			for(var i=0; i<intLen; i++)
			{
				strTemp = strIn.charAt(i);
				switch (strTemp)
				{
					case "~":{
						strTemp = strIn.substring(i+1, i+3);
						strTemp = parseInt(strTemp, 16);
						strTemp = String.fromCharCode(strTemp);
						strOut = strOut+strTemp;
						i += 2;
						break;
					}
					case "^":{
						strTemp = strIn.substring(i+1, i+5);
						strTemp = parseInt(strTemp,16);
						strTemp = String.fromCharCode(strTemp);
						strOut = strOut+strTemp;
						i += 4;
						break;
					}
					default:{
						strOut = strOut+strTemp;
						break;
					}
				}
		
			}
			$.msgBar ({
				type: types, 
				text: strOut,
				position: 'center-center', 
				lifetime: 2000
			});
			var date = new Date();
			var domain = window.document.location.href.match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/i);
			document.cookie = cookiename + "flag" + "=1; path=/; domain="+domain+";";
	    }
    };
    
    
(function(){
	var jss = $("script");
	for(var i = 0;i<jss.length;i++){
		if(jss[i].src.indexOf("msgBar.js") > -1){
			var basePath = jss[i].src.match(/http:\/*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\/*\w*\/*/i);
			document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\""+basePath+"/resource/base/js/msg/msgBar/css/msgBar.css\" charset=\"UTF-8\"/>");
		}
	}
})();
$(window).load(function(){
	$.cmoxhide("oxhidemsg","success");
	$.cmoxhide("oxhideerror","error");
});
})(jQuery);




