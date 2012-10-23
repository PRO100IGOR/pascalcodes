var jsPlay = {
    flash: null,
    loaded: false,
    url: "",
    load: function() {
		var paths = (function() {
				var strFullPath = window.document.location.href;
				var strPath = window.document.location.pathname;
				var pos = strFullPath.indexOf(strPath);
				var prePath = strFullPath.substring(0, pos);
				var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
				return prePath + postPath;
		})()+"/resource/base/js/sound/fmp.swf";
        var B = /msie/i.test(navigator.userAgent);
        var D = false;
        try {
            D = external.max_version
        } catch(C) {}
        var A = paths + "?v=090105a";
        if (D) {
            A += "&r=" + Math.random()
        }
		$("<div/>").attr("id","dictALaF").appendTo($("body"))
        if (B) {
            document.getElementById("dictALaF").innerHTML = '<object id="fmp_flash" width="1" height="1" classid=clsid:d27cdb6e-ae6d-11cf-96b8-444553540000 align=middle ><param name="FlashVars" value="_instanceName=jsPlay"><param name="Movie" value="'+paths+'?v=090105a"><param name="Src" value="' + A + '"><param name="WMode" value="Window"><param name="AllowScriptAccess" value="always"><param name="AllowNetworking" value="all"></object>'
        } else {
            document.getElementById("dictALaF").innerHTML = '<embed  width="1" height="1" align="middle" salign="lt" scale="noscale" wmode="window" pluginspage="http://www.adobe.com/go/getflashplayer" type="application/x-shockwave-flash" flashvars="_instanceName=jsPlay" allownetworking="all" allowscriptaccess="always" src="' + A + '" id="fmp_flash"/>'
        }
    },
    _onLoad: function() {
        this.loaded = true;
        this.flash = document.getElementById("fmp_flash");
        if (this.loaded) {
            this.onLoad()
        }
    },
    _onPlayStateChange: function(A) {
        if (this.onPlayStateChange) {
            this.onPlayStateChange(A)
        }
    },
    play: function() {
        this.flash._play()
    },
    stop: function() {
        this.flash._stop()
    },
    setUrl: function(A) {
        this.flash._setVar("url", A)
    },
    flashPlay: function(A) {
        this.url = A;
        if (this.loaded) {
            this.stop();
            this.setUrl(A);
            this.play()
        } else {
            this.load()
        }
    },
    onLoad: function() {
        this.setUrl(this.url);
        this.play()
    }
};