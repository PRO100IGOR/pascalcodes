(function(){
	$.fn.note = function(data,fn){
		var t = $(this);
		for(var i = 0;i<data.length;i++){
			t.append($(
				"<li/>",
				{
					id:data[i].id,
					html:data[i].title
				}
			));
		}
		t.addClass("treeOne");
		$(".treeOne>li").hover(function(){
			$(this).addClass("treeOne_hover");
		},function(){
			$(this).removeClass("treeOne_hover");
		}).bind("click",function(){
			$(this).siblings().removeClass("treeOne_selected").end().addClass("treeOne_selected");
			fn(this.id);
		});
	}
	$.fn.noteClick = function(id){
		$("#"+id).click();
	}
document.write("<link rel='stylesheet' type='text/css' href='"+(function() {
		var strFullPath = window.document.location.href;
		var strPath = window.document.location.pathname;
		var pos = strFullPath.indexOf(strPath);
		var prePath = strFullPath.substring(0, pos);
		var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
		return prePath + postPath;
	})()+"/resource/base/js/tree/noteTree/style.css'/>");
})();