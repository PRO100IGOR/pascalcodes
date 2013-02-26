/*!
 * lhgcore Dialog Plugin v3.5.2
 * Date : 2011-07-03 11:03:11
 * Copyright (c) 2009 - 2011 By Li Hui Gang
 */

(function(J){

var jhopath = (function() {
			var strFullPath = window.document.location.href;
			var strPath = window.document.location.pathname;
			var pos = strFullPath.indexOf(strPath);
			var prePath = strFullPath.substring(0, pos);
			var postPath = strPath.substring(0,
			strPath.substr(1).indexOf('/') + 1);
			return prePath + postPath;
})();
/*消息*/
window.info = function(pa){
	if( $('#lhgdlg_info',doc)[0] ){
		    return ;
	}
	var message = "<table width='100%' height='100%' align='left' border=0 cellspacing=0 cellpadding=0>"
				+"<tr><td valign='middle' style='padding-left:10px;'><img src='"+jhopath+"/resource/base/js/dialog/skins/ico/info.gif'  /></td>"
				+"<td valign='middle' style='padding-left:6px;'>"+pa.message+"</td></tr></table>";
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp =  DG ? DG.curWin.$.dialog :$.dialog;
	var tempdg = new temp({
					id:'info',
					autoPos:true,
					html:message,
					title:'提示',
					lockScroll:true,
					iconTitle:false,
					xButton:false,
					cancelBtn:false,
					cover:true,
					resize:false,
					parent:DG,
					rang:true,
					width:pa.width||300,
					height:pa.height||200,
					bgcolor:'#000',
					opacity:pa.opacity || 0.7,
					maxBtn:false,
					parent:DG
				});
	if(!tempdg)return;
	var dg = tempdg;
	dg.ShowDialog();
	dg.SetIndex();
	dg.addBtn('ok','确定',
		function(event){
			event.stopImmediatePropagation();
			if(pa.fn){
				pa.fn();
			}
			dg.cancel();
		},
		'right'
	);
	return dg;
};
window.error = function(pa){
	if( $('#lhgdlg_error',doc)[0] ){
		    return ;
	}
	var message = "<table width='100%' height='100%' align='left' border=0 cellspacing=0 cellpadding=0>"
				+"<tr><td valign='middle' style='padding-left:10px;'><img src='"+jhopath+"/resource/base/js/dialog/skins/ico/err.gif'  /></td>"
				+"<td valign='middle' style='padding-left:6px;'>"+pa.message+"</td></tr></table>";
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp =  DG ? DG.curWin.$.dialog :$.dialog;
	var dg = new temp({
					id:'error',
					autoPos:true,
					html:message,
					title:'提示',
					lockScroll:true,
					iconTitle:false,
					xButton:false,
					cancelBtn:false,
					cover:true,
					resize:false,
					parent:DG,
					rang:true,
					width:pa.width||300,
					height:pa.height||200,
					bgcolor:'#000',
					opacity:pa.opacity || 0.7,
					maxBtn:false,
					parent:DG
				});
	dg.ShowDialog();dg.SetIndex();
	dg.addBtn('ok','确定',
		function(event){
			event.stopImmediatePropagation();
			if(pa.fn){
				pa.fn();
			}
			dg.cancel();
		},
		'right'
	);
	return dg;
};
window.right = function(pa){
	if( $('#lhgdlg_right',doc)[0] ){
		    return ;
	}
	var message = "<table width='100%' height='100%' align='left' border=0 cellspacing=0 cellpadding=0>"
				+"<tr><td valign='middle' style='padding-left:10px;'><img src='"+jhopath+"/resource/base/js/dialog/skins/ico/right.gif'  /></td>"
				+"<td valign='middle' style='padding-left:6px;'>"+pa.message+"</td></tr></table>";
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp =  DG ? DG.curWin.$.dialog :$.dialog;
	var dg = new temp({
					id:'right',
					autoPos:true,
					html:message,
					title:'提示',
					lockScroll:true,
					iconTitle:false,
					xButton:false,
					cancelBtn:false,
					parent:DG,
					cover:true,
					resize:false,
					rang:true,
					width:pa.width||300,
					height:pa.height||200,
					bgcolor:'#000',
					opacity:pa.opacity || 0.7,
					maxBtn:false,
					parent:DG
				});
	dg.ShowDialog();dg.SetIndex();
	dg.addBtn('ok','确定',
		function(event){
			event.stopImmediatePropagation();
			if(pa.fn){
				pa.fn();
			}
			dg.cancel();
		},
		'right'
	);
	return dg;
};
window.ask = function(pa){
	if( $('#lhgdlg_ask',doc)[0] ){
		    return ;
	}
	var message = "<table width='100%' height='100%' align='left' border=0 cellspacing=0 cellpadding=0>"
				+"<tr><td valign='middle' style='padding-left:10px;'><img src='"+jhopath+"/resource/base/js/dialog/skins/ico/ask.gif'  /></td>"
				+"<td valign='middle' style='padding-left:6px;'>"+pa.message+"</td></tr></table>";
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp =  DG ? DG.curWin.$.dialog :$.dialog;
	var dg = new temp({
					id:'ask',
					autoPos:true,
					parent:DG,
					html:message,
					title:'提示',
					lockScroll:true,
					iconTitle:false,
					xButton:false,
					cover:true,
					resize:false,
					rang:true,
					width:pa.width||300,
					height:pa.height||200,
					bgcolor:'#000',
					opacity:pa.opacity || 0.7,
					maxBtn:false,
					onCancel:function(){pa.fn('no')}
				});
	dg.ShowDialog();
	dg.SetIndex();
	dg.addBtn('ok','确定',
		function(event){
			event.stopImmediatePropagation();
			pa.fn('yes');
			dg.cancel();
		},
		'left'
	);
	return dg;
};
window.addWin = function(pa){
	var id = pa.id || makePY( pa.title || "增加");
	if( $('#lhgdlg_'+id,doc)[0] ){
		    return ;
	}

	
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp = DG ? DG.curWin.$.dialog :$.dialog;
	
	pa.autoSize = pa.autoSize || "no";
	pa.xButton = pa.xButton || "no";
	pa.cover = pa.cover || "yes";
	if(pa.autoSize === "yes"){
		var dg = new temp({
						id:id,
						page:pa.url,
						parent:DG,
						lockScroll:true,
						title:pa.title || "增加",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						autoPos:true,
						iconTitle:false,
						resize:false,
						rang:true,
						autoSize:true,
						link:pa.link=="yes",
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes'
					});
	}else{
		var dg = new temp({
						id:id,
						page:pa.url,
						width:pa.width||600,
						height:pa.height||300,
						parent:DG,
						lockScroll:true,
						title:pa.title || "增加",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						autoPos:true,
						iconTitle:false,
						link:pa.link=="yes",
						resize:false,
						rang:true,
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes'
					});
	}
	dg.ShowDialog();
	dg.SetIndex();
	try{
		dg.dgWin.father = DG ? DG.dgWin : window;
		dg.dgWin.dg = dg;
		dg.father = dg.dgWin.father;
	}catch(e){

	}
	window.lhgBackCall = pa.fn;
	dg.SetCancelBtn('关闭',function(){
		try{
			var temp = dg.dgDoc.getElementById("isSaveAndAdd");
			if(temp){
				if(temp.value == "true"){
					pa.fn();
				}
			}
		}catch(e){
			var temp = [];
			for(var i in e){
				temp.push(i+"="+e[i]);
			}
			alert("发生异常："+temp.join(" "));
		}
		dg.cancel();
	});
	dg.addBtn('saveAndClose','保存&关闭',
		function(){
			try{
				var temp = dg.dgDoc.getElementById("isSaveAndAdd");
				if(temp){
					temp.value = "false";
				}
				dg.dgWin.save();
			}catch(e){
				var temp = [];
				for(var i in e){
					temp.push(i+"="+e[i]);
				}
				alert("发生异常："+temp.join(" "));
				dg.cancel();
			}
		},
		'left'
	);
	if(!pa.saveAndAdd){
		dg.addBtn('saveAndAdd','保存&增加',
			function(){
				try{
					var temp = dg.dgDoc.getElementById("isSaveAndAdd");
					if(temp){
						temp.value = "true";
					}
					dg.dgWin.save();
				}catch(e){
					var temp = [];
					for(var i in e){
						temp.push(i+"="+e[i]);
					}
					alert("发生异常："+temp.join(" "));
					dg.cancel();
				}
			},
			'left'
		);
	}
	return dg;
};
window.updateWin = function(pa){
	var id = makePY(pa.title || "增加");
	if( $('#lhgdlg_'+id,doc)[0] ){
		    return ;
	}
	var DG;
	try{
		//DG = parent&&parent.frameElement ? (parent.frameElement.lhgDG || frameElement.lhgDG) : frameElement.lhgDG;
		DG = frameElement.lhgDG;
	}catch(e){
	}
	pa.autoSize = pa.autoSize || "no";
	pa.xButton = pa.xButton || "no";
	pa.cover = pa.cover || "yes";
	var temp = DG ? DG.curWin.$.dialog :$.dialog;
	if(pa.autoSize == "yes"){
		var dg = new temp({
						id:id,
						page:pa.url,
						lockScroll:true,
						parent:DG,
						title:pa.title||"修改",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						link:pa.link=="yes",
						autoPos:true,
						iconTitle:false,
						resize:false,
						rang:true,
						autoSize:true,
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes'
					});
	}else{
		var dg = new temp({
						id:id,
						page:pa.url,
						lockScroll:true,
						width:pa.width||600,
						height:pa.height||300,
						parent:DG,
						title:pa.title||"修改",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						link:pa.link=="yes",
						autoPos:true,
						iconTitle:false,
						resize:false,
						rang:true,
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes'
					});
	}
	dg.ShowDialog();
	dg.SetIndex();
	try{
		dg.dgWin.father = DG ? DG.dgWin : window;
		dg.dgWin.dg = dg;
		dg.father = dg.dgWin.father;
	}catch(e){
	}
	window.lhgBackCall = pa.fn;
	dg.SetCancelBtn('关闭',function(){
		try{
			var temp = dg.dgDoc.getElementById("isSaveAndAdd");
			if(temp){
				if(temp.value == "true"){
					pa.fn();
				}
			}
		}catch(e){
			var temp = [];
			for(var i in e){
				temp.push(i+"="+e[i]);
			}
			alert("发生异常："+temp.join(" "));
		}
		dg.cancel();
	});
	dg.addBtn('saveAndClose','保存&关闭',
		function(){
			try{
				var temp = dg.dgDoc.getElementById("isSaveAndAdd");
				if(temp){
					temp.value = "false";
				}
				dg.dgWin.save();
			}catch(e){
				var temp = [];
				for(var i in e){
					temp.push(i+"="+e[i]);
				}
				alert("发生异常："+temp.join(" "));
				dg.cancel();
			}
		},
		'left'
	);
	return dg;
};
window.viewWin = function(pa){
	var id = makePY(pa.title || "增加");
	if( $('#lhgdlg_'+id,doc)[0] ){
		    return ;
	}
	var cover = pa.cover || 'yes';
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	pa.autoSize = pa.autoSize || "no";
	pa.xButton = pa.xButton || "no";
	pa.cover = pa.cover || "yes";
	pa.btnBar = pa.btnBar  || "yes";
	var temp = DG ? DG.curWin.$.dialog :$.dialog;
	if(pa.autoSize == "yes"){
		var dg = new temp({
						id:id,
						page:pa.url,
						lockScroll:true,
						parent:DG,
						title:pa.title||"查看",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						link:pa.link=="yes",
						autoPos:true,
						iconTitle:false,
						resize:false,
						rang:true,
						autoSize:true,
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes',
						btnBar:pa.btnBar == "yes"
					});
	}else{
		var dg = new temp({
						id:id,
						page:pa.url,
						width:pa.width||600,
						height:pa.height||300,
						parent:DG,
						title:pa.title||"查看",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						lockScroll:true,
						link:pa.link=="yes",
						autoPos:true,
						iconTitle:false,
						resize:false,
						rang:true,
						maxBtn:false,
						xButton:pa.xButton == 'yes',
						cover:pa.cover == 'yes',
						btnBar:pa.btnBar == "yes"
					});
	}
	dg.ShowDialog();dg.SetIndex();
	try{
		dg.dgWin.father = DG ? DG.dgWin : window;
		dg.dgWin.dg = dg;
		dg.father = dg.dgWin.father;
	}catch(e){

	}
	dg.SetCancelBtn('关闭',function(){
		dg.cancel();
	});

	return dg;
};
window.win = function(pa){
	var id = pa.id || makePY(pa.title);
	if( $('#lhgdlg_'+id,doc)[0] ){
		    return ;
	}
	var cover = pa.cover || 'yes';
	var DG;
	try{
		DG = frameElement.lhgDG;
	}catch(e){
	}
	var temp = DG ? DG.curWin.$.dialog :$.dialog;
	var autoSize = pa.autoSize || 'no';
	var btnBar = pa.btnBar || 'yes';
	var cancel = pa.cancel || 'yes';
	if(autoSize == "yes"){
		var dg = new temp({
						id:id,
						page:pa.url,
						lockScroll:true,
						parent:DG,
						autoPos:true,
						left:pa.left || "center",
						top:pa.top||"center",
						title:pa.title,
						iconTitle:false,
						autoSize:true,
						cover:cover == 'yes',
						resize:pa.resize=="yes",
						rang:true,
						link:pa.link=="yes",
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						xButton:pa.xBtn=="yes",
						maxBtn:pa.maxBtn=="yes",
						link:pa.link=="yes",
						minBtn:pa.minBtn == "yes",
						btnBar:btnBar == 'yes',
						cancelBtn:cancel=='yes',
						cancelBtnTxt:pa.canelBtnTxt||'取消',
						MAXSIZE:pa.MAXSIZE,
						MAXXY:pa.MAXXY,
						onMinSize:pa.onMinSize,
						onCancel:pa.onCancel
					});
	}else{
		var dg = new temp({
						id:id,
						page:pa.url,
						autoPos:true,
						parent:DG,
						width:pa.width||600,
						height:pa.height||300,
						title:pa.title,
						iconTitle:false,
						left:pa.left || "center",
						top:pa.top||"center",
						xButton:pa.xBtn=="yes",
						cover:cover == 'yes',
						resize:pa.resize=="yes",
						rang:true,
						fixed:true,
						lockScroll:true,
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						link:pa.link=="yes",
						maxBtn:pa.maxBtn=="yes",
						link:pa.link=="yes",
						minBtn:pa.minBtn == "yes",
						btnBar:btnBar == 'yes',
						cancelBtn:cancel=='yes',
						cancelBtnTxt:pa.canelBtnTxt||'取消',
						MAXSIZE:pa.MAXSIZE,
						MAXXY:pa.MAXXY,
						onMinSize:pa.onMinSize,
						onCancel:pa.onCancel
					});
	}
	dg.ShowDialog();dg.SetIndex();
	try{
		dg.dgWin.father = DG ? DG.dgWin : window;
		dg.dgWin.dg = dg;
		dg.father = dg.dgWin.father;
	}catch(e){

	}
	//if(btnBar == 'yes'){
		if(pa.fns){
			for(var i = 0;i<pa.fns.length;i++){
				dg.addBtn(pa.fns[i].id||pa.fns[i].name,pa.fns[i].name,pa.fns[i].fn,'left');
			}
		}
	//}
	pa.canelBtnTxt && dg.SetCancelBtn(pa.canelBtnTxt);
	window.lhgBackCall = pa.onCancel || dg.cancel;
	return dg;
};

window.htmlWin = function(pa){
	var id = pa.id || makePY(pa.title);
	if( $('#lhgdlg_'+id,doc)[0] ){
		    return ;
	}
	var cover = pa.cover || 'yes';
	var temp = $.dialog;
	var autoSize = pa.autoSize || 'no';
	var btnBar = pa.btnBar || 'yes';
	var cancel = pa.cancel || 'yes';
	pa.xButton = pa.xButton || "yes";
	if(autoSize == "yes"){
		var dssg = new temp({
						id:id,
						html:pa.html,
						autoPos:true,
						title:pa.title,
						lockScroll:true,
						iconTitle:false,
						autoSize:true,
						left:pa.left || "center",
						top:pa.top||"center",
						xButton:pa.xButton=="yes",
						cover:cover == 'yes',
						resize:false,
						rang:true,
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						maxBtn:false,
						btnBar:btnBar == 'yes',
						cancelBtn:cancel=='yes',
						cancelBtnTxt:pa.canelBtnTxt||'取消'
					});
	}else{
		var dssg = new temp({
						id:id,
						html:pa.html,
						autoPos:true,
						width:pa.width||600,
						height:pa.height||300,
						title:pa.title,
						iconTitle:false,
						xButton:pa.xButton=="yes",
						cover:cover == 'yes',
						resize:false,
						rang:true,
						left:pa.left || "center",
						top:pa.top||"center",
						lockScroll:true,
						bgcolor:'#000',
						opacity:pa.opacity || 0.7,
						maxBtn:false,
						btnBar:btnBar == 'yes',
						cancelBtn:cancel=='yes',
						cancelBtnTxt:pa.canelBtnTxt||'取消'
					});
	}
	dssg.ShowDialog();dssg.SetIndex();
	document.titleSelf = pa.title;
	document.getBtnById = function(id){
			var a = document.getElementById("lhgdg_"+document.titleSelf+"_"+id).getElementsByTagName("em");
			return a[0].innerHTML;
	};
	document.setBtnById = function(id,value){
			var a = document.getElementById("lhgdg_"+document.titleSelf+"_"+id).getElementsByTagName("em");
			a[0].innerHTML = value;
	};
	//if(btnBar == 'yes'){
		if(pa.fns){
			for(var i = 0;i<pa.fns.length;i++){
				dssg.addBtn(pa.fns[i].id||pa.fns[i].name,pa.fns[i].name,pa.fns[i].fn,'left');
			}
		}
	//}
	if(pa.cancelFn){
		dssg.SetCancelBtn(pa.canelBtnTxt||"取消",function(){
			pa.cancelFn();
			dssg.cancel();
		});
	}
	return dssg;
}

var top = window, doc, cover, ZIndex,
    ie6 = (J.browser.msie && J.browser.version < 7) ? true : false,

iframeTpl = ie6 ? '<iframe hideFocus="true" ' +
	'frameborder="0" src="about:blank" style="position:absolute;' +
	'z-index:-1;width:100%;height:100%;top:0px;left:0px;filter:' +
	'progid:DXImageTransform.Microsoft.Alpha(opacity=0);><\/iframe>' : '',

compat = function( doc )
{
    doc = doc || document;
	return doc.compatMode == 'CSS1Compat' ? doc.documentElement : doc.body;
},

getZIndex = function()
{
    if( !ZIndex ) ZIndex = 1976;

	return ++ZIndex;
},

getScrSize = function()
{
	if( 'pageXOffset' in top )
	{
	    return {
		    x: top.pageXOffset || 0,
			y: top.pageYOffset || 0
		};
	}
	else
	{
	    var d = compat( doc );
		return {
		    x: d.scrollLeft || 0,
			y: d.scrollTop || 0
		};
	}
},

getDocSize = function()
{
	var d = compat( doc );

	return {
	    w: d.clientWidth || 0,
		h: d.clientHeight || 0
	};
},

getUrl = (function()
{
    var sc = document.getElementsByTagName('script'), bp = '',
	    i = 0, l = sc.length, re = /lhgdialog(?:\.min)?\.js/i;

	for( ; i < l; i++ )
	{
	    if( re.test(sc[i].src) )
		{
		    bp = !!document.querySelector ?
			    sc[i].src : sc[i].getAttribute('src',4);
			break;
		}
	}

	return bp.split('?');
})(),

getPath = getUrl[0].substr( 0, getUrl[0].lastIndexOf('/') + 1 ),

getArgs = function( name )
{
    if( getUrl[1] )
	{
	    var param = getUrl[1].split('&'), i = 0, l = param.length, aParam;

		for( ; i < l; i++ )
		{
		    aParam = param[i].split('=');

			if( name === aParam[0] ) return aParam[1];
		}
	}

	return null;
},

dgSkin = getArgs('s') || 'default',

reSizeHdl = function()
{
    var rel = compat( doc );

	J(cover).css({
	    width: Math.max( rel.scrollWidth, rel.clientWidth || 0 ) - 1 + 'px',
		height: Math.max( rel.scrollHeight, rel.clientHeight || 0 ) - 1 + 'px'
	});
};

while( top.parent && top.parent != top )
{
    try{
	    if( top.parent.document.domain != document.domain ) break;
	}catch(e){ break; }

	top = top.parent;
}

if( getArgs('t') === 'self' || top.document.getElementsByTagName('frameset').length > 0 )
    top = window;	

doc = top.document;

try{
	doc.execCommand( 'BackgroundImageCache', false, true );
}catch(e){}

dgSkin = dgSkin.split(',');

for( var i = 0, l = dgSkin.length; i < l; i++ )
    J('head',doc).append( '<link href="' + getPath + 'skins/' + dgSkin[i] + '.css" rel="stylesheet" type="text/css"/>' );

J.fn.fixie6png = function()
{
    var els = J('*',this), bgIMG, pngPath;

	for( var i = 0, l = els.length; i < l; i++ )
	{
	    bgIMG = J(els[i]).css('ie6png');
		pngPath = getPath + 'skins/' + bgIMG;

		if( bgIMG )
		{
			els[i].style.backgroundImage = 'none';
			els[i].runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + pngPath + "',sizingMethod='scale')";
		}
	}
};

J.fn.dialog = function( opts )
{
    var dialog = false;

	if( this[0] )
	{
	    dialog = new J.dialog( opts );
		this.bind( 'click', dialog.ShowDialog );
	}

	return dialog;
};

J.dialog = function( opts )
{
    var S = this, loadObj, inboxObj, xbtnObj, dragObj, dropObj,
    	bodyObj, btnBarObj, regWindow, timer,

	opt = J.extend({
		title: 'lhgdialog \u5F39\u51FA\u7A97\u53E3',
		cover: false,
		titleBar: true,
		btnBar: true,
		xButton: true,
		maxBtn: true,
		minBtn: false, // 暂时只提供个接口
		cancelBtn: true,
		width: 400,
		height: 20,
		id: 'lhgdgId',
		link: false,
		html: null,
		page: null,
		parent: null,
		dgOnLoad: null,
		onXclick: null,
		onCancel: null,
		onMinSize: null, // 暂时只提供这个最小化的接口
		fixed: false,
		top: 'center',
		left: 'center',
		drag: true,
		MAXXY:null,
		MAXSIZE:null,
		skin: dgSkin[0],
		resize: true,
		autoSize: false,
		rang: false,
		timer: null,
		iconTitle: true,
		bgcolor: '#fff',
		opacity: 0.5,
		args: null,
		lockScroll: false,
		autoPos: false,
		autoCloseFn: null,
		cancelBtnTxt: '\u53D6\u6D88',
		loadingText: '\u7A97\u53E3\u5185\u5BB9\u52A0\u8F7D\u4E2D\uFF0C\u8BF7\u7A0D\u7B49...'
	}, opts || {} ),

	maxBtnObj, max = {}, maxed = false,
	minBtnObj,

	SetFixed = function( elem )
	{
		var style = elem.style,
			dd = compat( doc ),
			left = parseInt(style.left) - dd.scrollLeft,
			top = parseInt(style.top) - dd.scrollTop;

		style.removeExpression('left');
		style.removeExpression('top');

		style.setExpression( 'left', 'this.ownerDocument.documentElement.scrollLeft' + left );
		style.setExpression( 'top', 'this.ownerDocument.documentElement.scrollTop + ' + top );
	},

	SetIFramePage = function()
	{
	    var innerDoc, dialogTpl;

		if( opt.html )
		{
		    if( typeof opt.html === 'string' )
				innerDoc = '<div id="lhgdg_inbox_' + opt.id + '" class="lhgdg_inbox_' + opt.skin + '" style="display:none">' + opt.html + '</div>';
			else
				innerDoc = '<div id="lhgdg_inbox_' + opt.id + '" class="lhgdg_inbox_' + opt.skin + '" style="display:none"></div>';
		}
		else if( opt.page )
		{
		    innerDoc = '<iframe id="lhgfrm_' + opt.id + '" frameborder="0" src="' + opt.page + '" ' +
				       'scrolling="auto" style="display:none;width:100%;height:100%;"><\/iframe>';
		}

		dialogTpl = [
		    '<div id="lhgdlg_', opt.id, '" class="lhgdialog_', opt.skin, '" style="width:', opt.width, 'px;height:', opt.height, 'px;">',
			    '<table border="0" cellspacing="0" cellpadding="0" width="100%">',
				'<tr>',
					'<td class="lhgdg_leftTop_', opt.skin, '"></td>',
					'<td id="lhgdg_drag_', opt.id, '" class="lhgdg_top_', opt.skin, '">', opt.titleBar ?
						('<div class="lhgdg_title_icon_' + opt.skin + '">' + (opt.iconTitle ? '<div class="lhgdg_icon_' + opt.skin + '"></div>' : '') +
						'<div class="lhgdg_title_' + opt.skin + '">' + opt.title + '</div>' +
						(opt.minBtn ? ('<a class="lhgdg_minbtn_' + opt.skin + '" id="lhgdg_minbtn_' + opt.id + '" href="javascript:void(0);" target="_self"></a>') : '') +
						(opt.maxBtn ? ('<a class="lhgdg_maxbtn_' + opt.skin + '" id="lhgdg_maxbtn_' + opt.id + '" href="javascript:void(0);" target="_self"></a>') : '') +
						(opt.xButton ? ('<a class="lhgdg_xbtn_' + opt.skin + '" id="lhgdg_xbtn_' + opt.id + '" href="javascript:void(0);" target="_self"></a>') : '') + '</div>') : '',
					'</td>',
					'<td class="lhgdg_rightTop_', opt.skin, '"></td>',
				'</tr>',
				'<tr>',
					'<td class="lhgdg_left_', opt.skin, '"></td>',
					'<td>',
						'<table border="0" cellspacing="0" cellpadding="0" width="100%">',
						'<tr>',
						    '<td id="lhgdg_content_', opt.id, '" style="background-color:#fff">',
							    innerDoc, '<div id="lhgdg_load_', opt.id, '" class="lhgdg_load_', opt.skin, '"><span>', opt.loadingText, '</span></div>',
							'</td>',
						'</tr>',
						opt.btnBar ? ('<tr id="lhgdg_trbtnBar_' + opt.id + '"><td id="lhgdg_btnBar_' + opt.id + '" class="lhgdg_btnBar_' + opt.skin + '"><div class="lhgdg_btn_div_' + opt.skin + '"></div></td></tr>') : ('<tr id="lhgdg_trbtnBar_' + opt.id + '" style="display:none;"><td id="lhgdg_btnBar_' + opt.id + '" class="lhgdg_btnBar_' + opt.skin + '"><div class="lhgdg_btn_div_' + opt.skin + '"></div></td></tr>'),
						'</table>',
					'</td>',
					'<td class="lhgdg_right_', opt.skin, '"></td>',
				'</tr>',
				'<tr>',
					'<td class="lhgdg_leftBottom_', opt.skin, '"></td>',
					'<td class="lhgdg_bottom_', opt.skin, '"></td>',
					'<td id="lhgdg_drop_', opt.id, '" class="lhgdg_rightBottom_', opt.skin, '"></td>',
				'</tr>',
				'</table>', iframeTpl,
			'</div>'
		].join('');
		return dialogTpl;
	},

	ShowCover = function()
	{
	    cover = J('#lhgdgCover',doc)[0];

		if( !cover )
		{
			var html = '<div id="lhgdgCover" style="position:absolute;top:0px;left:0px;' +
					'background-color:' + opt.bgcolor + ';">' + iframeTpl + '</div>';

			cover = J(html,doc).css('opacity',opt.opacity).appendTo(doc.body)[0];
		}

		if( opt.lockScroll )
		    J('html',doc).addClass('lhgdg_lockScroll');

		J(top).bind( 'resize', reSizeHdl );
		reSizeHdl();
		J(cover).css({ display: '', zIndex: getZIndex() });
	},

	iPos = function( dg, tp, lt, fix )
	{
	    var cS = getDocSize(),
		    sS = getScrSize(),
			dW = parseInt( dg.style.width, 10 ),
			dH = parseInt( dg.style.height, 10 ),
			x, y, lx, rx, cx, ty, by, cy;

		if( fix )
		{
			lx = ie6 ? sS.x : 0;
			rx = ie6 ? cS.w + sS.x - dW : cS.w - dW;
			cx = ie6 ? ( rx + sS.x - 20 ) / 2 : ( rx - 20 ) / 2;

			ty = ie6 ? sS.y : 0;
			by = ie6 ? cS.h + sS.y - dH : cS.h - dH;
			cy = ie6 ? ( by + sS.y - 20 ) / 2 : ( by - 20 ) / 2;
		}
		else
		{
			lx = sS.x;
			cx = sS.x + ( cS.w - dW - 20 ) / 2;
			rx = sS.x + cS.w - dW;

			ty = sS.y;
			cy = sS.y + ( cS.h - dH - 20 ) / 2;
			by = sS.y + cS.h - dH;
		}

		switch( lt )
		{
		    case 'center':
				x = cx;
				break;
			case 'left':
				x = lx;
				break;
			case 'right':
				x = rx;
				break;
			default:
			    if(fix && ie6) lt = lt + sS.x;
				x = lt; break;
		}

		switch( tp )
		{
		    case 'center':
				y = cy;
			    break;
			case 'top':
			    y = ty;
				break;
			case 'bottom':
			    y = by;
				break;
			default:
			    if(fix && ie6) tp = tp + sS.y;
				y = tp; break;
		}

		if( y < sS.y && !fix ) y = sS.y;

		J(dg).css({ top: y + 'px', left: x + 'px' });

		if( fix && ie6 ) SetFixed( dg );
	},

	SetDialog = function( dg )
	{
	    S.curWin = window;
		S.curDoc = document;

		J(dg).bind('contextmenu',function(ev){
		    ev.preventDefault();
		}).bind( 'mousedown', setIndex );

		if( opt.html && opt.html.nodeType )
		{
		    J(inboxObj).append( opt.html );
			opt.html.style.display = '';
		}

		regWindow = [window];

		if( top != window )
		    regWindow.push( top );

		if( opt.page )
		{
		    S.dgFrm = J('#lhgfrm_'+opt.id,doc)[0];

		    if( !opt.link )
			{
			    S.dgWin = S.dgFrm.contentWindow;
				S.dgFrm.lhgDG = S;
			}

			J(S.dgFrm).bind('load',function(){
				this.style.display = 'block';

				if( !opt.link )
				{
				    var indw = J.browser.msie ?
					    S.dgWin.document : S.dgWin;

					J(indw).bind( 'mousedown', setIndex );

					regWindow.push( S.dgWin );
				    S.dgDoc = S.dgWin.document;

				    if( opt.autoSize ) autoSize();
				    J.isFunction( opt.dgOnLoad ) && opt.dgOnLoad.call( S );
				}

				loadObj.style.display = 'none';
			});
		}
		if( opt.xButton && opt.titleBar )
		    J(xbtnObj).bind( 'click', opt.onXclick || closeDG );

		if( opt.maxBtn && opt.titleBar )
		{
		    J(maxBtnObj).bind( 'click', S.maxSize );
			J(dragObj).bind( 'dblclick', S.maxSize );
		}

		if( opt.minBtn && opt.titleBar  ){
			 J(minBtnObj).bind( 'click', J.isFunction(opt.onMinSize) ? opt.onMinSize : S.minSize );
		}

	},

	reContentSize = function( dg )
	{
	    var tH = dragObj.offsetHeight,
		    bH = dropObj.offsetHeight,
			nH = btnBarObj.offsetHeight,
			iH = parseInt(dg.style.height,10) - tH - bH - nH;

		if( iH < 0 ) iH = 20;

		loadObj.style.lineHeight = iH + 'px';
		bodyObj.style.height = iH + 'px';
	},

	autoSize = function()
	{
	    var tH = dragObj.offsetHeight,
		    bH = dropObj.offsetHeight,
			nH = btnBarObj.offsetHeight,
			bW = dropObj.offsetWidth * 2, sH, sW, comDoc;

		if( opt.html )
		{
			sH = Math.max( inboxObj.scrollHeight, inboxObj.clientHeight || 0 );
			sW = Math.max( inboxObj.scrollWidth, inboxObj.clientWidth || 0 );
		}
		else if( opt.page && !opt.link )
		{
		    if( !S.dgDoc ) return;
			comDoc = compat( S.dgDoc );

			sH = Math.max( comDoc.scrollHeight, comDoc.clientHeight || 0 );
			sW = Math.max( comDoc.scrollWidth, comDoc.clientWidth || 0 );
		}

		sH = sH + tH + bH + nH;
		sW = sW + bW;

		S.reDialogSize( sW, sH ); iPos( S.dg, 'center', 'center', opt.fixed );
	},

	initDrag = function( elem )
	{
	    var lacoor, maxX, maxY, curpos, regw = regWindow, cS, sS;

		function moveHandler(ev)
		{
			var curcoor = { x: ev.screenX, y: ev.screenY };
		    curpos =
		    {
		        x: curpos.x + ( curcoor.x - lacoor.x ),
			    y: curpos.y + ( curcoor.y - lacoor.y )
		    };
			lacoor = curcoor;

			if( opt.rang )
			{
			    if( curpos.x < sS.x ) curpos.x = sS.x;
				if( curpos.y < sS.y ) curpos.y = sS.y;
				if( curpos.x > maxX ) curpos.x = maxX;
				if( curpos.y > maxY ) curpos.y = maxY;
			}

			S.dg.style.top = opt.fixed && !ie6 ? curpos.y - sS.y + 'px' : curpos.y + 'px';
			S.dg.style.left = opt.fixed && !ie6 ? curpos.x - sS.x + 'px' : curpos.x + 'px';
		};

		function upHandler(ev)
		{
			for( var i = 0, l = regw.length; i < l; i++ )
			{
				J( regw[i].document ).unbind( 'mousemove', moveHandler );
				J( regw[i].document ).unbind( 'mouseup', upHandler );
			}

			lacoor = null; elem = null;

			if( curpos.y < sS.y ) S.dg.style.top = sS.y + 'px';

			if( opt.fixed && ie6 ) SetFixed( S.dg );
		    if( J.browser.msie ) S.dg.releaseCapture();
		};

		J(elem).bind( 'mousedown', function(ev){
		    if( ev.target.id === 'lhgdg_xbtn_'+opt.id ) return;

			cS = getDocSize();
			sS = getScrSize();

			var lt = S.dg.offsetLeft,
			    tp = S.dg.offsetTop,
			    dW = S.dg.clientWidth,
			    dH = S.dg.clientHeight;

			curpos = opt.fixed && !ie6 ?
			    { x: lt + sS.x, y: tp + sS.y } : { x: lt, y: tp };

			lacoor = { x: ev.screenX, y: ev.screenY };

			maxX = cS.w + sS.x - dW;
			maxY = cS.h + sS.y - dH;

			S.dg.style.zIndex = parseInt( ZIndex, 10 ) + 1;

			for( var i = 0, l = regw.length; i < l; i++ )
			{
				J( regw[i].document ).bind( 'mousemove', moveHandler );
				J( regw[i].document ).bind( 'mouseup', upHandler );
			}

			ev.preventDefault();

			if( J.browser.msie ) S.dg.setCapture();
		});
	},

	initSize = function( elem )
	{
	    var lacoor, dH, dW, curpos, regw = regWindow, dialog, cS, sS;

		function moveHandler(ev)
		{
		    var curcoor = { x : ev.screenX, y : ev.screenY };
			dialog = {
				w: curcoor.x - lacoor.x,
				h: curcoor.y - lacoor.y
			};

			if( dialog.w < 200 ) dialog.w = 200;
			if( dialog.h < 100 ) dialog.h = 100;

			S.dg.style.top = opt.fixed ? curpos.y - sS.y + 'px' : curpos.y + 'px';
			S.dg.style.left = opt.fixed ? curpos.x - sS.x + 'px' : curpos.x + 'px';

			S.reDialogSize( dialog.w, dialog.h );
		};

		function upHandler(ev)
		{
			for( var i = 0, l = regw.length; i < l; i++ )
			{
			    J( regw[i].document ).unbind( 'mousemove', moveHandler );
				J( regw[i].document ).unbind( 'mouseup', upHandler );
			}

			lacoor = null; elem = null;

		    if( J.browser.msie ) S.dg.releaseCapture();
		};

	    J(elem).bind( 'mousedown', function(ev){
			dW = S.dg.clientWidth;
			dH = S.dg.clientHeight;

			dialog = { w: dW, h: dH };

			cS = getDocSize();
			sS = getScrSize();

			var lt = S.dg.offsetLeft,
			    tp = S.dg.offsetTop;

			curpos = opt.fixed ?
			    { x: lt + sS.x, y: tp + sS.y } : { x: lt, y: tp };

			lacoor = { x: ev.screenX - dW, y: ev.screenY - dH };

			S.dg.style.zIndex = parseInt( ZIndex, 10 ) + 1;

			for( var i = 0, l = regw.length; i < l; i++ )
			{
			    J( regw[i].document ).bind( 'mousemove', moveHandler );
				J( regw[i].document ).bind( 'mouseup', upHandler );
			}

			ev.preventDefault();

			if( J.browser.msie ) S.dg.setCapture();
		});
	},

	setIndex = function(ev)
	{
		S.dg.style.zIndex = parseInt(ZIndex,10) + 1;
		ZIndex = parseInt( S.dg.style.zIndex, 10 );

		ev.stopPropagation();
	},

	dgAutoPos = function()
	{
		if( opt.autoPos === true )
		    opt.autoPos = { left: 'center', top: 'center' };

		iPos( S.dg, opt.autoPos.top, opt.autoPos.left, opt.fixed );
	},

	closeDG = function()
	{
	    if( J.isFunction(opt.onCancel) )
		    opt.onCancel.call( S );
		S.cancel();
	},

	removeDG = function()
	{
		if( S.dgFrm )
		{
			if( !opt.link )
				J(S.dgFrm).unbind( 'load' );

			S.dgFrm.src = 'about:blank';
			S.dgFrm = null;
		}

		if( opt.html && opt.html.nodeType )
		{
		    J(S.curDoc.body).append( opt.html );
			opt.html.style.display = 'none';
		}

		if( opt.autoPos )
			J(top).unbind( 'resize', dgAutoPos );

		regWindow = [];
		J(S.dg).remove();

		S.dg = null; maxed = false; max = {};
		loadObj = inboxObj = xbtnObj = dragObj = dropObj = btnBarObj = bodyObj = maxBtnObj = minBtnObj = null;
	};

	S.ShowDialog = function()
	{
		if( J('#lhgdlg_'+opt.id,doc)[0] ){
		    return S;
		}

		if( opt.cover )
		    ShowCover();

//		if( opt.fixed )
//		{
//		    opt.maxBtn = false;
//			opt.minBtn = false;
//		}

		var fixpos = opt.fixed && !ie6 ? 'fixed' : 'absolute',
		    html = SetIFramePage();

		S.dg = J(html,doc).css({
		    position: fixpos, zIndex: getZIndex()
		}).appendTo(doc.body)[0];

		loadObj = J('#lhgdg_load_'+opt.id,doc)[0];
		inboxObj = J('#lhgdg_inbox_'+opt.id,doc)[0];
		xbtnObj = J('#lhgdg_xbtn_'+opt.id,doc)[0];
		dragObj = J('#lhgdg_drag_'+opt.id,doc)[0];
		dropObj = J('#lhgdg_drop_'+opt.id,doc)[0];
		btnBarObj = J('#lhgdg_btnBar_'+opt.id,doc)[0];
		bodyObj = J('#lhgdg_content_'+opt.id,doc)[0];
		maxBtnObj = J('#lhgdg_maxbtn_'+opt.id,doc)[0];
		minBtnObj = J('#lhgdg_minbtn_'+opt.id,doc)[0];
		
		reContentSize( S.dg );
		iPos( S.dg, opt.top, opt.left, opt.fixed );
		SetDialog( S.dg );

	    if( opt.drag )
		    initDrag( dragObj );
		else
		    dragObj.style.cursor = 'default';

		if( opt.resize )
		    initSize( dropObj );
		else
		    dropObj.style.cursor = 'default';

		if( ie6 && J(dropObj).css('ie6png') )
			J(S.dg).fixie6png();

		if( opt.cancelBtn )
		    S.addBtn( 'dgcancelBtn', opt.cancelBtnTxt, closeDG );
		if( opt.html )
		{
		    loadObj.style.display = 'none';
			inboxObj.style.display = '';
			if( opt.autoSize ) autoSize();
		}

		if( opt.timer ) S.closeTime( opt.timer, opt.autoCloseFn );

		if( opt.html && J.isFunction(opt.dgOnLoad) ) opt.dgOnLoad.call( S );

		if( opt.autoPos ) J(top).bind( 'resize', dgAutoPos );
	};

	S.reDialogSize = function( width, height )
	{
		J(S.dg).css({
		    'width': width + 'px', 'height': height + 'px'
		});
		reContentSize( S.dg );
		dgAutoPos();
	};
	S.minSize = function(){
		J(S.dg).hide();
	};
	S.maxSize = function()
	{
	    var cS, sS;
		cS = opt.MAXSIZE || getDocSize();
		sS = opt.MAXXY||getScrSize();
		if( !maxed )
		{
		    max.dgW = S.dg.offsetWidth;
		    max.dgH = S.dg.offsetHeight;
		    max.dgT = S.dg.style.top;
		    max.dgL = S.dg.style.left;

			J(S.dg).css({ top: sS.y + 'px', left: sS.x + 'px' });
			S.reDialogSize( cS.w, cS.h );

			J(maxBtnObj).addClass('lhgdg_rebtn_'+opt.skin).removeClass('lhgdg_maxbtn_'+opt.skin);

			if( opt.drag )
			    J(dragObj).unbind('mousedown').css('cursor','default');

			if( opt.resize )
			    J(dropObj).unbind('mousedown').css('cursor','default');

			maxed = true;
		}
		else
		{
		    S.reDialogSize( max.dgW, max.dgH );
			J(S.dg).css({ top: max.dgT, left: max.dgL });

			J(maxBtnObj).addClass('lhgdg_maxbtn_'+opt.skin).removeClass('lhgdg_rebtn_'+opt.skin);

			if( opt.drag )
			{
			    initDrag( dragObj );
				dragObj.style.cursor = 'move';
			}

			if( opt.resize )
			{
			    initSize( dropObj );
				dropObj.style.cursor = 'nw-resize';
			}

			maxed = false;
		}
	};

	S.SetMinBtn = function( fn )
	{
	    if( opt.minBtn && opt.titleBar )
		{
		    if( J.isFunction(fn) )
			    J(minBtnObj).unbind( 'click' ).bind( 'click', fn );
		}
		return S;
	};

	S.addBtn = function( id, txt, fn, pos )
	{
	    pos = pos || 'left';
	    if(id!=="dgcancelBtn"){
			if(!S.btns)S.btns=[];
			S.btns.push(id);
		}
		if( J('#lhgdg_'+opt.id+'_'+id,doc)[0] )
			J('#lhgdg_'+opt.id+'_'+id,doc).html( '<em>' + txt + '</em>' ).unbind('click').bind('click',fn);
		else
		{
			var html = '<a id="lhgdg_' + opt.id + '_' + id + '" class="lhgdg_button_' + opt.skin + '" href="javascript:void(0);" target="_self"><em>' + txt + '</em></a>',
				btn = J(html,doc).bind( 'click', fn )[0];

			if( pos === 'left' )
			    J('.lhgdg_btn_div_' + opt.skin,btnBarObj).prepend(btn);
			else
			    J('.lhgdg_btn_div_' + opt.skin,btnBarObj).append(btn);
		}
		return S;
	};
	S.openBar = function(open){
		if(open)
			$(btnBarObj).parent().show();
		else
			$(btnBarObj).parent().hide();
	}
	S.removeBtn = function( id )
	{
	    if( J('#lhgdg_'+opt.id+'_'+id,doc)[0] )
		    J('#lhgdg_'+opt.id+'_'+id,doc).remove();
		return S;
	};
	S.changeBtn = function(id,value){
		if( J('#lhgdg_'+opt.id+'_'+id,doc)[0] ){
			J("lhgdg_'" + opt.id + "_" + id,doc).empty().append(J("<em>" + value + "</em>"));
		}
	};
	S.SetIndex = function()
	{
		if(!S.dg)return;
		S.dg.style.zIndex = parseInt(ZIndex,10) + 1;
		ZIndex = parseInt( S.dg.style.zIndex, 10 );
	};

	S.SetXbtn = function( fn, noShow )
	{
	    if( opt.xButton && opt.titleBar )
		{
		    if( J.isFunction(fn) )
			    J(xbtnObj).unbind( 'click' ).bind( 'click', fn );

			if( noShow )
			    xbtnObj.style.display = 'none';
			else
			    xbtnObj.style.display = '';
		}
	};

	S.SetTitle = function( txt )
	{
	    if( opt.titleBar && typeof txt === 'string' )
		    J('.lhgdg_title_'+opt.skin,S.dg).html( txt );
	};

	S.cancel = function()
	{
		removeDG();

		if( cover )
		{
		    if( opt.parent && opt.parent.isCover )
			{
			    var Index = opt.parent.dg.style.zIndex;
				cover.style.zIndex = parseInt(Index,10) - 1;
			}
			else
			    cover.style.display = 'none';

			if( opt.lockScroll )
			    J('html',doc).removeClass('lhgdg_lockScroll');
		}
	};

	S.cleanDialog = function()
	{
		if( S.dg )
		    removeDG();

		if( cover )
		{
		    J(cover).remove();
			cover = null;
		}
	};

	S.closeTime = function( second, bFn, aFn )
	{
	    if( timer ) clearTimeout(timer);

		if( bFn ) bFn.call( S );

		if( second )
		    timer = setTimeout(function(){
				if( aFn ) aFn.call( S );
				S.cancel();
				clearTimeout(timer);
			},1000 * second );
	};

	S.SetPosition = function( left, top )
	{
	    iPos( S.dg, top, left, opt.fixed );
	};

	S.iWin = function( id )
	{
		if( J('#lhgfrm_'+id,doc)[0] )
		    return J('#lhgfrm_'+id,doc)[0].contentWindow;

		return null;
	};

	S.iDoc = function( id )
	{
		if( J('#lhgfrm_'+id,doc)[0] )
		    return J('#lhgfrm_'+id,doc)[0].contentWindow.document;

		return null;
	};

	S.iDG = function( id )
	{
	    return doc.getElementById('lhgdlg_'+id) || null;
	};

	S.SetCancelBtn = function( txt, fn )
	{
		
		if( J('#lhgdg_'+opt.id+'_dgcancelBtn',doc)[0] ){
			var t = J('#lhgdg_'+opt.id+'_dgcancelBtn',doc).html( '<em>' + txt + '</em>' );
			if(fn)
				t.unbind('click').bind('click',fn);
		}
		    
	};
	S.getCancelBtn = function(){
		if( J('#lhgdg_'+opt.id+'_dgcancelBtn',doc)[0] ){
			var t = J('#lhgdg_'+opt.id+'_dgcancelBtn',doc);
			return t;
		}
	}
	S.setArgs = function( args )
	{
	    opt.args = args;
	};

	S.getArgs = function()
	{
	    return opt.args;
	};

	S.dialogId = opt.id; S.parent = opt.parent; S.isCover = opt.cover ? true : false;

	J(window).bind( 'unload', S.cleanDialog );
};

//J(function(){
////	var lhgDY = setTimeout(function(){
////	    new J.dialog({ id:'reLoadId', html:'lhgdialog', width:100, title:'reLoad', height:100, left:-9000, btnBar:false }).ShowDialog(); clearTimeout(lhgDY);
////	}, 150);
//});

})(window.lhgcore||window.jQuery);


 var makePY =  function(str) {
            var strChineseFirstPY = "YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNYLGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPBWKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJDXJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY";
            var oMultiDiff = {
                "19969": "DZ",
                "19975": "WM",
                "19988": "QJ",
                "20048": "YL",
                "20056": "SC",
                "20060": "NM",
                "20094": "QG",
                "20127": "QJ",
                "20167": "QC",
                "20193": "YG",
                "20250": "KH",
                "20256": "ZC",
                "20282": "SC",
                "20285": "QJG",
                "20291": "TD",
                "20314": "YD",
                "20340": "NE",
                "20375": "TD",
                "20389": "YJ",
                "20391": "CZ",
                "20415": "PB",
                "20446": "YS",
                "20447": "SQ",
                "20504": "TC",
                "20608": "KG",
                "20854": "QJ",
                "20857": "ZC",
                "20911": "PF",
                "20504": "TC",
                "20608": "KG",
                "20854": "QJ",
                "20857": "ZC",
                "20911": "PF",
                "20985": "AW",
                "21032": "PB",
                "21048": "XQ",
                "21049": "SC",
                "21089": "YS",
                "21119": "JC",
                "21242": "SB",
                "21273": "SC",
                "21305": "YP",
                "21306": "QO",
                "21330": "ZC",
                "21333": "SDC",
                "21345": "QK",
                "21378": "CA",
                "21397": "SC",
                "21414": "XS",
                "21442": "SC",
                "21477": "JG",
                "21480": "TD",
                "21484": "ZS",
                "21494": "YX",
                "21505": "YX",
                "21512": "HG",
                "21523": "XH",
                "21537": "PB",
                "21542": "PF",
                "21549": "KH",
                "21571": "E",
                "21574": "DA",
                "21588": "TD",
                "21589": "O",
                "21618": "ZC",
                "21621": "KHA",
                "21632": "ZJ",
                "21654": "KG",
                "21679": "LKG",
                "21683": "KH",
                "21710": "A",
                "21719": "YH",
                "21734": "WOE",
                "21769": "A",
                "21780": "WN",
                "21804": "XH",
                "21834": "A",
                "21899": "ZD",
                "21903": "RN",
                "21908": "WO",
                "21939": "ZC",
                "21956": "SA",
                "21964": "YA",
                "21970": "TD",
                "22003": "A",
                "22031": "JG",
                "22040": "XS",
                "22060": "ZC",
                "22066": "ZC",
                "22079": "MH",
                "22129": "XJ",
                "22179": "XA",
                "22237": "NJ",
                "22244": "TD",
                "22280": "JQ",
                "22300": "YH",
                "22313": "XW",
                "22331": "YQ",
                "22343": "YJ",
                "22351": "PH",
                "22395": "DC",
                "22412": "TD",
                "22484": "PB",
                "22500": "PB",
                "22534": "ZD",
                "22549": "DH",
                "22561": "PB",
                "22612": "TD",
                "22771": "KQ",
                "22831": "HB",
                "22841": "JG",
                "22855": "QJ",
                "22865": "XQ",
                "23013": "ML",
                "23081": "WM",
                "23487": "SX",
                "23558": "QJ",
                "23561": "YW",
                "23586": "YW",
                "23614": "YW",
                "23615": "SN",
                "23631": "PB",
                "23646": "ZS",
                "23663": "ZT",
                "23673": "YG",
                "23762": "TD",
                "23769": "ZS",
                "23780": "QJ",
                "23884": "QK",
                "24055": "XH",
                "24113": "DC",
                "24162": "ZC",
                "24191": "GA",
                "24273": "QJ",
                "24324": "NL",
                "24377": "TD",
                "24378": "QJ",
                "24439": "PF",
                "24554": "ZS",
                "24683": "TD",
                "24694": "WE",
                "24733": "LK",
                "24925": "TN",
                "25094": "ZG",
                "25100": "XQ",
                "25103": "XH",
                "25153": "PB",
                "25170": "PB",
                "25179": "KG",
                "25203": "PB",
                "25240": "ZS",
                "25282": "FB",
                "25303": "NA",
                "25324": "KG",
                "25341": "ZY",
                "25373": "WZ",
                "25375": "XJ",
                "25384": "A",
                "25457": "A",
                "25528": "SD",
                "25530": "SC",
                "25552": "TD",
                "25774": "ZC",
                "25874": "ZC",
                "26044": "YW",
                "26080": "WM",
                "26292": "PB",
                "26333": "PB",
                "26355": "ZY",
                "26366": "CZ",
                "26397": "ZC",
                "26399": "QJ",
                "26415": "ZS",
                "26451": "SB",
                "26526": "ZC",
                "26552": "JG",
                "26561": "TD",
                "26588": "JG",
                "26597": "CZ",
                "26629": "ZS",
                "26638": "YL",
                "26646": "XQ",
                "26653": "KG",
                "26657": "XJ",
                "26727": "HG",
                "26894": "ZC",
                "26937": "ZS",
                "26946": "ZC",
                "26999": "KJ",
                "27099": "KJ",
                "27449": "YQ",
                "27481": "XS",
                "27542": "ZS",
                "27663": "ZS",
                "27748": "TS",
                "27784": "SC",
                "27788": "ZD",
                "27795": "TD",
                "27812": "O",
                "27850": "PB",
                "27852": "MB",
                "27895": "SL",
                "27898": "PL",
                "27973": "QJ",
                "27981": "KH",
                "27986": "HX",
                "27994": "XJ",
                "28044": "YC",
                "28065": "WG",
                "28177": "SM",
                "28267": "QJ",
                "28291": "KH",
                "28337": "ZQ",
                "28463": "TL",
                "28548": "DC",
                "28601": "TD",
                "28689": "PB",
                "28805": "JG",
                "28820": "QG",
                "28846": "PB",
                "28952": "TD",
                "28975": "ZC",
                "29100": "A",
                "29325": "QJ",
                "29575": "SL",
                "29602": "FB",
                "30010": "TD",
                "30044": "CX",
                "30058": "PF",
                "30091": "YSP",
                "30111": "YN",
                "30229": "XJ",
                "30427": "SC",
                "30465": "SX",
                "30631": "YQ",
                "30655": "QJ",
                "30684": "QJG",
                "30707": "SD",
                "30729": "XH",
                "30796": "LG",
                "30917": "PB",
                "31074": "NM",
                "31085": "JZ",
                "31109": "SC",
                "31181": "ZC",
                "31192": "MLB",
                "31293": "JQ",
                "31400": "YX",
                "31584": "YJ",
                "31896": "ZN",
                "31909": "ZY",
                "31995": "XJ",
                "32321": "PF",
                "32327": "ZY",
                "32418": "HG",
                "32420": "XQ",
                "32421": "HG",
                "32438": "LG",
                "32473": "GJ",
                "32488": "TD",
                "32521": "QJ",
                "32527": "PB",
                "32562": "ZSQ",
                "32564": "JZ",
                "32735": "ZD",
                "32793": "PB",
                "33071": "PF",
                "33098": "XL",
                "33100": "YA",
                "33152": "PB",
                "33261": "CX",
                "33324": "BP",
                "33333": "TD",
                "33406": "YA",
                "33426": "WM",
                "33432": "PB",
                "33445": "JG",
                "33486": "ZN",
                "33493": "TS",
                "33507": "QJ",
                "33540": "QJ",
                "33544": "ZC",
                "33564": "XQ",
                "33617": "YT",
                "33632": "QJ",
                "33636": "XH",
                "33637": "YX",
                "33694": "WG",
                "33705": "PF",
                "33728": "YW",
                "33882": "SR",
                "34067": "WM",
                "34074": "YW",
                "34121": "QJ",
                "34255": "ZC",
                "34259": "XL",
                "34425": "JH",
                "34430": "XH",
                "34485": "KH",
                "34503": "YS",
                "34532": "HG",
                "34552": "XS",
                "34558": "YE",
                "34593": "ZL",
                "34660": "YQ",
                "34892": "XH",
                "34928": "SC",
                "34999": "QJ",
                "35048": "PB",
                "35059": "SC",
                "35098": "ZC",
                "35203": "TQ",
                "35265": "JX",
                "35299": "JX",
                "35782": "SZ",
                "35828": "YS",
                "35830": "E",
                "35843": "TD",
                "35895": "YG",
                "35977": "MH",
                "36158": "JG",
                "36228": "QJ",
                "36426": "XQ",
                "36466": "DC",
                "36710": "JC",
                "36711": "ZYG",
                "36767": "PB",
                "36866": "SK",
                "36951": "YW",
                "37034": "YX",
                "37063": "XH",
                "37218": "ZC",
                "37325": "ZC",
                "38063": "PB",
                "38079": "TD",
                "38085": "QY",
                "38107": "DC",
                "38116": "TD",
                "38123": "YD",
                "38224": "HG",
                "38241": "XTC",
                "38271": "ZC",
                "38415": "YE",
                "38426": "KH",
                "38461": "YD",
                "38463": "AE",
                "38466": "PB",
                "38477": "XJ",
                "38518": "YT",
                "38551": "WK",
                "38585": "ZC",
                "38704": "XS",
                "38739": "LJ",
                "38761": "GJ",
                "38808": "SQ",
                "39048": "JG",
                "39049": "XJ",
                "39052": "HG",
                "39076": "CZ",
                "39271": "XT",
                "39534": "TD",
                "39552": "TD",
                "39584": "PB",
                "39647": "SB",
                "39730": "LG",
                "39748": "TPB",
                "40109": "ZQ",
                "40479": "ND",
                "40516": "HG",
                "40536": "HG",
                "40583": "QJ",
                "40765": "YQ",
                "40784": "QJ",
                "40840": "YK",
                "40863": "QJG"
            };
            function checkCh(ch) {
                var uni = ch.charCodeAt(0);
                if (uni > 40869 || uni < 19968) {
                    return ch;
                }
                return (oMultiDiff[uni] ? oMultiDiff[uni] : (strChineseFirstPY.charAt(uni - 19968)));
            }
            function mkRslt(arr) {
                var arrRslt = [""];
                for (var i = 0,
                len = arr.length; i < len; i++) {
                    var str = arr[i];
                    var strlen = str.length;
                    if (strlen == 1) for (var k = 0; k < arrRslt.length; k++) arrRslt[k] += str;
                    else {
                        var tmpArr = arrRslt.slice(0);
                        arrRslt = [];
                        for (k = 0; k < strlen; k++) {
                            var tmp = tmpArr.slice(0);
                            for (var j = 0; j < tmp.length; j++) tmp[j] += str.charAt(k);
                            arrRslt = arrRslt.concat(tmp);
                        }
                    }
                }
                return arrRslt;
            }
            if (typeof(str) != "string") throw new Error( - 1, "\u51fd\u6570makePy\u9700\u8981\u5b57\u7b26\u4e32\u7c7b\u578b\u53c2\u6570!");
            var arrResult = new Array();
            for (var i = 0,
            len = str.length; i < len; i++) {
                var ch = str.charAt(i);
                arrResult.push(checkCh(ch));
            }
            return mkRslt(arrResult)[0];
 };