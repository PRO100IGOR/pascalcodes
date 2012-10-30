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
	var jss = $("script");
	for(var i = 0;i<jss.length;i++){
		if(jss[i].src.indexOf("noteTree.js") > -1){
			var basePath = jss[i].src.match(/http:\/*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\/*\w*\/*/i);
			document.write("<link rel='stylesheet' type='text/css' href='"+basePath+"/resource/base/js/tree/noteTree/style.css'/>");
		}
	}
})();


