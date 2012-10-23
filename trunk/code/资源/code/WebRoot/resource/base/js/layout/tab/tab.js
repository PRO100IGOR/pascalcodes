
(function ($) {
    var getBasePath = (function() {
            var strFullPath = window.document.location.href;
            var strPath = window.document.location.pathname;
            var pos = strFullPath.indexOf(strPath);
            var prePath = strFullPath.substring(0, pos);
            var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
            return prePath + postPath;
    })()+"/";
	function Tab(obj){
		$.extend(this,obj);
		$.tabs = $.tabs || [];
		this.index = $.tabs.length;
		$.tabs.push(this);
		this.show = function(){
			if($.nowIndex>=0)$.tabs[$.nowIndex].hide();
			$("#"+this.index+"_ccli").addClass("current");
			$("#"+this.index+"_ccdiv").slideDown(function(){
				var temp = $(this);
				if(temp.attr("src")){
					temp.append(
						$("<iframe/>").attr({
							frameBorder : "no",
							src : temp.attr("src"),
							name : this.id.split("_")[0]+"_ccframe",
							width  : "100%",
							allowTransparency:true
						}).css("height",temp.height())
					)
				}
				temp.removeAttr("src");
			});
			$.nowIndex = this.index;
			return this;
		};
		this.hide = function(){
			$("#"+this.index+"_ccli").removeClass("current");
			$("#"+this.index+"_ccdiv").slideUp();
			return this;
		};
		this.getWindow = function(){
			return frames[this.index+"_ccframe"];
		};
	}
	$.fn.tab = function (obj,time) {
		var temp = this;
		if(typeof(obj) == "object"){
			var ul = temp.children("ul");
			if (!ul.length) {
				temp.addClass("simpleTab").append($("<ul/>").addClass("simpleTab_top")).css("width","100%");
				$("body").css("overflow","hidden");
				ul = temp.children("ul");
			}
			if (obj.length) {
				for (var i = 0; i < obj.length; i++) {
					addTab(obj[i],temp,ul);
				}
			}else{
				addTab(obj,temp,ul);
			}
			return temp;
		}else if(typeof(obj) == "string"){
			if(obj == "now"){
				if($.nowIndex >= 0) return $.tabs[$.nowIndex];
			}else if(obj == "next"){
				var tempindex = $.nowIndex;
				if($.nowIndex == $.tabs.length - 1 ) tempindex = -1;
				tempindex = tempindex - 0 + 1;
				return $.tabs[tempindex].show();
			}else if(obj == "prev"){
				var tempindex = $.nowIndex;
				if($.nowIndex == 0 ) tempindex = $.tabs.length ;
				tempindex = tempindex - 1;
				return $.tabs[tempindex].show();
			}else if(obj == "window"){
				if($.nowIndex >= 0) return $.tabs[$.nowIndex].getWindow();
			}else if(obj == "start"){
				$.tabs[$.nowIndex].show();
				if($.tabTime) return temp;
				time = time || 2000;
				var id = temp.attr("id");
				if(!id){
					temp.attr("id","cctab");
					id = "cctab";
				}
				$.tabTime = setInterval("$('#cctab').tab('next')",time);
				return temp;
			}else if(obj == "stop"){
				if(!$.tabTime) return temp;
				clearInterval($.tabTime);
				delete $.tabTime;
				return temp;
			}else if(obj == "now"){
				return $.nowIndex;
			}
			return temp;
		}else if(typeof(obj) == "number"){
			if(obj < $.tabs.length && obj >= 0 && obj != $.nowIndex){
				$.tabs[obj].show();
				return temp;
			}
		}else{
				$.tabs[0].show();
				return temp;
		}
	};

	var addTab = function (obj,divsrc,ulsrc) {
		obj = new Tab(obj);
		ulsrc.append(
			$("<li/>").append(
				$("<a/>").attr("href", "javascript:;").attr("id", obj.index + "_cca").append(
					$("<span/>").html(obj.title).attr("id", obj.index + "_ccspan").click(function(){
						if(($.nowIndex - this.id.split("_")[0]) != 0){
							$.tabs[this.id.split("_")[0]].show();	
						}
					})
				)
			).attr("id",obj.index + "_ccli")
		);
		var div = $("<div/>").attr("id", obj.index + "_ccdiv").hide().addClass("simpleTab_con").css("height",divsrc.height()-40);
		if (obj.html) {
			if (typeof (obj.html) == "string") {
				div.html(obj.html);
			} else if(obj.html.length){
				div.append(obj.html);
			}else{
				div.append($(obj.html));
			}
		} else {
			if (obj.url) {
				if (obj.url) {
					obj.url = getBasePath + "/core/tool/load.jsp?url=" + encodeURIComponent(obj.url);
					
				}
				div.attr("src",obj.url);
			}
		}
		divsrc.append(div);
		
	};
    document.write("<link href=\"" + getBasePath + "resource/base/js/layout/tab/tab.css" + "\" rel=\"stylesheet\" type=\"text/css\">");
})(jQuery);

