var webFXTreeConfigTemp = (function() {
		var strFullPath = window.document.location.href;
		var strPath = window.document.location.pathname;
		var pos = strFullPath.indexOf(strPath);
		var prePath = strFullPath.substring(0, pos);
		var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
		return prePath + postPath;
	})()+"/";
var webFXTreeConfig = {
    rootIcon        : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/folder.png',
	openRootIcon    : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/folderopen.png',
	folderIcon      : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/folder.png',
	openFolderIcon  : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/folderopen.png',
	fileIcon        : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/page.png',
	iIcon           : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/line.gif',
	lIcon           : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/joinbottom.gif',
	lMinusIcon      : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/minusbottom.gif',
	lPlusIcon       : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/plusbottom.gif',
	tIcon           : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/join.gif',
	tMinusIcon      : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/minus.gif',
	tPlusIcon       : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/plus.gif',
	blankIcon       : webFXTreeConfigTemp + 'resource/base/theme/public/img/tree/empty.gif',
	defaultText     : 'Tree Item',
	defaultAction   : '',
	defaultBehavior : 'classic',
	usePersistence	: true
};

var webFXTreeHandler = {
	idCounter : 0,
	idPrefix  : "webfx-tree-object-",
	all       : {},
	behavior  : null,
	selected  : null,
	onSelect  : null, /* should be part of tree, not handler */
	getId     : function() { return this.idPrefix + this.idCounter++; },
	toggle    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggle(); },
	select    : function (oItem) { this.all[oItem.id.replace('-icon','')].select(); },
	focus     : function (oItem) { this.all[oItem.id.replace('-anchor','')].focus(); },
	blur      : function (oItem) { this.all[oItem.id.replace('-anchor','')].blur(); },
	keydown   : function (oItem, e) { return this.all[oItem.id].keydown(e.keyCode); },
	cookies   : new WebFXCookie(),
	insertHTMLBeforeEnd	:	function (oElement, sHTML) {
		if (oElement.insertAdjacentHTML != null) {
			oElement.insertAdjacentHTML("BeforeEnd", sHTML)
			return;
		}
		var df;	// DocumentFragment
		var r = oElement.ownerDocument.createRange();
		r.selectNodeContents(oElement);
		r.collapse(false);
		df = r.createContextualFragment(sHTML);
		oElement.appendChild(df);
	}
};

/*
 * WebFXCookie class
 */
function WebFXCookie() {
    this.cookies="";
	if (document.cookie.length) { this.cookies = RequestCookies("FXTREEITEMSTATE");}
}

WebFXCookie.prototype.setCookie = function (key, value) {
    if(this.cookies==null){
       this.cookies = key + "#" + value;
    }else{
       if(this.cookies.indexOf(key)>=0){
          if(this.cookies.indexOf(","+key)>=0)
            this.cookies=this.cookies.replace((","+key + "#1"),"");
          else
          if(this.cookies.indexOf(key+",")>=0)
            this.cookies=this.cookies.replace((key + "#1,"),"");
          else
            this.cookies=this.cookies.replace((key + "#1"),"");
       }
       else
          this.cookies += ","+key + "#" + value;
    }
    if(this.cookies.length>3000){
       this.cookies=this.cookies.replace(this.cookies.split(",")[0]+",","");
    }
	document.cookie=" FXTREEITEMSTATE="+escape(this.cookies);
}

WebFXCookie.prototype.getCookie = function (key) {
	if (this.cookies) {
		var start = this.cookies.indexOf(key + '#');
		if (start == -1) { return null; }
		var end = this.cookies.indexOf(",", start);
		if (end == -1) { end = this.cookies.length; }
		end -= start;
		var cookie = this.cookies.substr(start,end);
		return unescape(cookie.substr(cookie.indexOf('#') + 1, cookie.length - cookie.indexOf('#') + 1));
	}
	else { return null; }
}

function RequestCookies(cookieName)
{
    var lowerCookieName = cookieName.toLowerCase();
    var cookieStr = document.cookie;
    var cookieArr = cookieStr.split("; ");
    var pos = -1;
    for (var i=0; i<cookieArr.length; i++)
    {
        pos = cookieArr[i].indexOf("=");
        if (pos > 0)
        {
            if (cookieArr[i].substring(0, pos).toLowerCase() == lowerCookieName)
            {
                return unescape(cookieArr[i].substring(pos+1, cookieArr[i].length));
            }
        }
    }
    return null;
}


var $selectWebFXTreeItem$=webFXTreeHandler.cookies.getCookie("$selectWebFXTreeItem$");

/*function addFxTreeNode(pid,id,title,type,url,sIcon,sOpenIcon){
   newAddFxTreeNode=new WebFXTreeItem(title, url, '', sIcon, sOpenIcon,type,'false','true','false',("T_"+id),'false');
   var pNode=eval("T_"+pid);
   pNode.rendered=true;
   pNode.add(newAddFxTreeNode);
}*/
/*
 * WebFXTreeAbstractNode class
 */
function WebFXTreeAbstractNode(sText, sAction,stype,schecked,sselected,sdisabled,id) {
	this.childNodes  = [];
	this.id     = id;//webFXTreeHandler.getId();
	this.text   = sText || webFXTreeConfig.defaultText;
	this.action = sAction || webFXTreeConfig.defaultAction;
	this._last  = false;
	webFXTreeHandler.all[this.id] = this;
	this.stype=stype;
	this.schecked=schecked;
	this.sselected=sselected;
	this.sdisabled=sdisabled;
}

/*
 * To speed thing up if you're adding multiple nodes at once (after load)
 * use the bNoIdent parameter to prevent automatic re-indentation and call
 * the obj.ident() method manually once all nodes has been added.
 */

WebFXTreeAbstractNode.prototype.add = function (node, bNoIdent) {
	node.parentNode = this;
	this.childNodes[this.childNodes.length] = node;
	var root = this;
	if (this.childNodes.length >= 2) {
		this.childNodes[this.childNodes.length - 2]._last = false;
	}
	while (root.parentNode) { root = root.parentNode; }
	if (root.rendered) {
		if (this.childNodes.length >= 2) {
			document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-plus').src = ((this.childNodes[this.childNodes.length -2].folder)?((this.childNodes[this.childNodes.length -2].open)?webFXTreeConfig.tMinusIcon:webFXTreeConfig.tPlusIcon):webFXTreeConfig.tIcon);
			this.childNodes[this.childNodes.length - 2].plusIcon = webFXTreeConfig.tPlusIcon;
			this.childNodes[this.childNodes.length - 2].minusIcon = webFXTreeConfig.tMinusIcon;
			this.childNodes[this.childNodes.length - 2]._last = false;
		}
		this._last = true;
		var foo = this;
		while (foo.parentNode) {
			for (var i = 0; i < foo.parentNode.childNodes.length; i++) {
				if (foo.id == foo.parentNode.childNodes[i].id) { break; }
			}
			if (i == foo.parentNode.childNodes.length - 1) { foo.parentNode._last = true; }
			else { foo.parentNode._last = false; }
			foo = foo.parentNode;
		}
		webFXTreeHandler.insertHTMLBeforeEnd(document.getElementById(this.id + '-cont'), node.toString());
		if ((!this.folder) && (!this.openIcon)) {
			this.icon = webFXTreeConfig.folderIcon;
			this.openIcon = webFXTreeConfig.openFolderIcon;
		}
		if (!this.folder) { this.folder = true; this.collapse(true); }
		if (!bNoIdent) { this.indent(); }
	}
	return node;
}

WebFXTreeAbstractNode.prototype.toggle = function() {
	if (this.folder) {
		if (this.open) { this.collapse();}
		else { this.expand();}
    }	
}

WebFXTreeAbstractNode.prototype.select = function() {
	document.getElementById(this.id + '-anchor').focus();
}

WebFXTreeAbstractNode.prototype.deSelect = function() {
	document.getElementById(this.id + '-anchor').className = '';
	webFXTreeHandler.selected = null;
}

WebFXTreeAbstractNode.prototype.focus = function() {
	if ((webFXTreeHandler.selected) && (webFXTreeHandler.selected != this)) { webFXTreeHandler.selected.deSelect(); }
	webFXTreeHandler.selected = this;
	//if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.openIcon; }
	document.getElementById(this.id + '-anchor').className = 'selected';
	document.getElementById(this.id + '-anchor').focus();
	if (webFXTreeHandler.onSelect) { webFXTreeHandler.onSelect(this); }
}

WebFXTreeAbstractNode.prototype.blur = function() {
	//if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected-inactive';
}

WebFXTreeAbstractNode.prototype.doExpand = function() {
	if (this.childNodes.length) {  
		document.getElementById(this.id + '-cont').style.display = 'block'; 
	}
	else{
		showRoles(this.id + '-cont',this,false);
	 //  if(window.event.srcElement.src.indexOf("expands.gif")<0)
	   //   showRoles(this.id + '-cont',this,false);
	   //else{
	  //    return false;
	  // }
	}
	document.getElementById(this.id + '-icon').src = this.openIcon;
	this.open = true;
	if (webFXTreeConfig.usePersistence) {
		//webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '1');
		webFXTreeHandler.cookies.setCookie(this.id, '1');
    }	
}

WebFXTreeAbstractNode.prototype.doReplaceExpand = function() {
    document.getElementById(this.id + '-icon').src = this.openIcon; 
    //document.getElementById(this.id + '-cont').style.display = 'block';
    this.childNodes=new Array();
	showRoles((this.id + '-cont'),this,true);
	this.open = true;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id, '1');
    }
}

function reLoadChilder(id){
   try{
   eval("T_"+id).doReplaceExpand();
   }catch(e){}
}

function deleteFxTreeNode(id){
   document.getElementById("T_"+id).outerHTML="";
}

WebFXTreeAbstractNode.prototype.doCollapse = function() {
	//if (webFXTreeHandler.behavior == 'classic') 
	{ document.getElementById(this.id + '-icon').src = this.icon; }
	if (this.childNodes.length) { document.getElementById(this.id + '-cont').style.display = 'none'; }
	this.open = false;
	if (webFXTreeConfig.usePersistence) {
		//webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '0');
		webFXTreeHandler.cookies.setCookie(this.id, '0');
}	}

WebFXTreeAbstractNode.prototype.expandAll = function() {
	this.expandChildren();
	if ((this.folder) && (!this.open)) { this.expand(); }
}

WebFXTreeAbstractNode.prototype.expandChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].expandAll();
} }

WebFXTreeAbstractNode.prototype.collapseAll = function() {
	this.collapseChildren();
	if (this.childNodes.length>0&&(this.folder) && (this.open)) { this.collapse(true);}
}
function expandAll_(root){
	root.expandAll();
}
function collapseAll_(root){
	 var childs=root.getChild();
	 for(var i=0;i<childs.length;i++)
	    childs[i].collapseAll();
}

WebFXTreeAbstractNode.prototype.collapseChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].collapseAll();
} }

WebFXTreeAbstractNode.prototype.indent = function(lvl, del, last, level, nodesLeft) {
	/*
	 * Since we only want to modify items one level below ourself,
	 * and since the rightmost indentation position is occupied by
	 * the plus icon we set this to -2
	 */
	if (lvl == null) { lvl = -2; }
	var state = 0;
	for (var i = this.childNodes.length - 1; i >= 0 ; i--) {
		state = this.childNodes[i].indent(lvl + 1, del, last, level);
		if (state) { return; }
	}
	if (del) {
		if ((level >= this._level) && (document.getElementById(this.id + '-plus'))) {
			if (this.folder) {
				document.getElementById(this.id + '-plus').src = (this.open)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.lPlusIcon;
				this.plusIcon = webFXTreeConfig.lPlusIcon;
				this.minusIcon = webFXTreeConfig.lMinusIcon;
			}
			else if (nodesLeft) { document.getElementById(this.id + '-plus').src = webFXTreeConfig.lIcon; }
			return 1;
	}	}
	var foo = document.getElementById(this.id + '-indent-' + lvl);
	if (foo) {
		if ((foo._last) || ((del) && (last))) { foo.src =  webFXTreeConfig.blankIcon; }
		else { foo.src =  webFXTreeConfig.iIcon; }
	}
	return 0;
}

/*
 * WebFXTree class
 */

function WebFXTree(sText, sAction, sBehavior, sIcon, sOpenIcon,stype,schecked,sselected,sdisabled,id) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction,stype,schecked,sselected,sdisabled,id);
	this.icon      = sIcon || webFXTreeConfig.rootIcon;
	this.openIcon  = sOpenIcon || webFXTreeConfig.openRootIcon;
	/* Defaults to open */
	if (webFXTreeConfig.usePersistence) {
		//this.open  = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '0')?false:true;
		this.open  = (webFXTreeHandler.cookies.getCookie(this.id) == '0')?false:true;
	} else { this.open  = true; }
	this.folder    = true;
	this.rendered  = false;
	this.onSelect  = null;
	if (!webFXTreeHandler.behavior) {  webFXTreeHandler.behavior = sBehavior || webFXTreeConfig.defaultBehavior; }
}

WebFXTree.prototype = new WebFXTreeAbstractNode;

WebFXTree.prototype.setBehavior = function (sBehavior) {
	webFXTreeHandler.behavior =  sBehavior;
};

WebFXTree.prototype.getBehavior = function (sBehavior) {
	return webFXTreeHandler.behavior;
};

WebFXTree.prototype.getSelected = function() {
	if (webFXTreeHandler.selected) { return webFXTreeHandler.selected; }
	else { return null; }
}

WebFXTree.prototype.remove = function() { }

WebFXTree.prototype.expand = function() {
	return this.doExpand();
}

WebFXTree.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
}

WebFXTree.prototype.getFirst = function() {
	return null;
}

WebFXTree.prototype.getLast = function() {
	return null;
}

WebFXTree.prototype.getNextSibling = function() {
	return null;
}

WebFXTree.prototype.getPreviousSibling = function() {
	return null;
}

WebFXTree.prototype.keydown = function(key) {
	if (key == 39) {
		if (!this.open) { this.expand(); }
		else if (this.childNodes.length) { this.childNodes[0].select(); }
		return false;
	}
	if (key == 37) { this.collapse(); return false; }
	if ((key == 40) && (this.open) && (this.childNodes.length)) { this.childNodes[0].select(); return false; }
	return true;
}

WebFXTree.prototype.toString = function() {
	var str = "<div id=\"" + this.id + "\" style=\"vertical-align:middle;\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\">" +//onclick=\"webFXTreeHandler.select(this);\"
		//"<a href=\"javascript:nodeClickFun('" + this.action + "','"+this.id+"','"+this.text+"','"+this.stype+"','1')\" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		//(this.target ? " target=\"" + this.target + "\"" : "") +
		//">" + 
		((menu$_checkboxmode!="default"&&menu$_cked=="true") ? ("<input type=\"checkbox\" style=\"vertical-align:middle;\"  name=\"S_$menuCheckBoxRoot\" onclick=\"checkedFun(this.checked,'"+this.id+"');\">" ): "")+"<a href=\"javascript:nodeClickFunHander('','','"+this.text+"','','0')\" "+($selectWebFXTreeItem$=="Root"?"class=\"selected-inactive\"":"class=\"selected\"")+">"+this.text + "</a>"+
		//"</a>" +
		"</div><div id=\"" + this.id + "-cont\" style=\"vertical-align:middle;\"  class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	return str + sb.join("") + "</div>";
};

/*
 * WebFXTreeItem class
 */

function WebFXTreeItem(sText, sAction, eParent, sIcon, sOpenIcon,stype,schecked,sselected,sdisabled,id,childed) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction,stype,schecked,sselected,sdisabled,id);
	/* Defaults to close */
	if (webFXTreeConfig.usePersistence) {
		//this.open = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '1')?true:false;
		this.open = (webFXTreeHandler.cookies.getCookie(this.id) == '1')?true:false;
	} else { this.open = false; }
	this.folder    = true;
	if(childed=="false")
	   this.folder=false;
	if (sIcon) { this.icon = sIcon; }
	if (sOpenIcon) { this.openIcon = sOpenIcon; }
	if (eParent) { eParent.add(this); }
}

WebFXTreeItem.prototype = new WebFXTreeAbstractNode;

WebFXTreeItem.prototype.remove = function() {
	var iconSrc = document.getElementById(this.id + '-plus').src;
	var parentNode = this.parentNode;
	var prevSibling = this.getPreviousSibling(true);
	var nextSibling = this.getNextSibling(true);
	var folder = this.parentNode.folder;
	var last = ((nextSibling) && (nextSibling.parentNode) && (nextSibling.parentNode.id == parentNode.id))?false:true;
	this.getPreviousSibling().focus();
	this._remove();
	if (parentNode.childNodes.length == 0) {
		document.getElementById(parentNode.id + '-cont').style.display = 'none';
		parentNode.doCollapse();
		parentNode.folder = false;
		parentNode.open = false;
	}
	if (!nextSibling || last) { parentNode.indent(null, true, last, this._level, parentNode.childNodes.length); }
	if ((prevSibling == parentNode) && !(parentNode.childNodes.length)) {
		prevSibling.folder = false;
		prevSibling.open = false;
		iconSrc = document.getElementById(prevSibling.id + '-plus').src;
		iconSrc = iconSrc.replace('minus', '').replace('plus', '');
		document.getElementById(prevSibling.id + '-plus').src = iconSrc;
		//document.getElementById(prevSibling.id + '-icon').src = webFXTreeConfig.fileIcon;
	}
	if (document.getElementById(prevSibling.id + '-plus')) {
		if (parentNode == prevSibling.parentNode) {
			iconSrc = iconSrc.replace('minus', '').replace('plus', '');
			document.getElementById(prevSibling.id + '-plus').src = iconSrc;
}	}	}

WebFXTreeItem.prototype._remove = function() {
	for (var i = this.childNodes.length - 1; i >= 0; i--) {
		this.childNodes[i]._remove();
 	}
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) {
			for (var j = i; j < this.parentNode.childNodes.length; j++) {
				this.parentNode.childNodes[j] = this.parentNode.childNodes[j+1];
			}
			this.parentNode.childNodes.length -= 1;
			if (i + 1 == this.parentNode.childNodes.length) { this.parentNode._last = true; }
			break;
	}	}
	webFXTreeHandler.all[this.id] = null;
	var tmp = document.getElementById(this.id);
	if (tmp) { tmp.parentNode.removeChild(tmp); }
	tmp = document.getElementById(this.id + '-cont');
	if (tmp) { tmp.parentNode.removeChild(tmp); }
}

WebFXTreeItem.prototype.expand = function() {
	b=this.doExpand();
	if(b!=false)
	document.getElementById(this.id + '-plus').src = this.minusIcon;
}

WebFXTreeItem.prototype.collapse = function(b) {
	//if (!b) { this.focus(); }
	this.doCollapse();
	document.getElementById(this.id + '-plus').src = this.plusIcon;
}

WebFXTreeItem.prototype.getFirst = function() {
	return this.childNodes[0];
}

WebFXTreeItem.prototype.getLast = function() {
	if (this.childNodes[this.childNodes.length - 1].open) { return this.childNodes[this.childNodes.length - 1].getLast(); }
	else { return this.childNodes[this.childNodes.length - 1]; }
}

WebFXTreeItem.prototype.getNextSibling = function() {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (++i == this.parentNode.childNodes.length) { return this.parentNode.getNextSibling(); }
	else { return this.parentNode.childNodes[i]; }
}

WebFXTreeItem.prototype.getPreviousSibling = function(b) {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (i == 0) { return this.parentNode; }
	else {
		if ((this.parentNode.childNodes[--i].open) || (b && this.parentNode.childNodes[i].folder)) { return this.parentNode.childNodes[i].getLast(); }
		else { return this.parentNode.childNodes[i]; }
} }

WebFXTreeItem.prototype.keydown = function(key) {
	if ((key == 39) && (this.folder)) {
		if (!this.open) { this.expand(); }
		else { this.getFirst().select(); }
		return false;
	}
	else if (key == 37) {
		if (this.open) { this.collapse(); }
		else { this.parentNode.select(); }
		return false;
	}
	else if (key == 40) {
		if (this.open) { this.getFirst().select(); }
		else {
			var sib = this.getNextSibling();
			if (sib) { sib.select(); }
		}
		return false;
	}
	else if (key == 38) { this.getPreviousSibling().select(); return false; }
	return true;
}

function checkedFun(checked,id){
   if(checked){
       var foo = document.getElementById(id).parentNode;
       while(foo!=null){
      // alert(id+","+foo.id);
           var foo2=document.getElementById(foo.id.replace('-cont', '-anchor'));
           if(foo2==null)
             break;
          checkOb=foo2.childNodes[0];
          if(checkOb!=null&&checkOb.type=="checkbox"&&!checkOb.disabled){
             checkOb.checked=checked;
          }
          foo = foo.parentNode;
       }
       checeChildSelect(document.getElementById(id+"-cont"),true);
   }else{
       checeChildSelect(document.getElementById(id+"-cont"),false);
   }
}

function checeChildSelect(parentOb,checked){
    var checkChildObs=parentOb.childNodes;
       if(checkChildObs!=null&&checkChildObs.length!=0){
           for(var i=0;i<checkChildObs.length;i++){
               var anchor=document.getElementById(checkChildObs[i].id+"-anchor");
               if(anchor==null||anchor.childNodes.length==0)
                 continue;
               checkOb=anchor.childNodes[0];
               if(checkOb==null)
                 continue;
                if(checkOb.type=="checkbox"&&!checkOb.disabled){
                   checkOb.checked=checked;
                }else{
                   continue;
                }
                var childs=document.getElementById(checkChildObs[i].id+"-cont");
                if(childs!=null)
                  checeChildSelect(childs,checked);
           }
       }
}
WebFXTreeAbstractNode.prototype.getId=function(){
   return replaceAll3(this.id.replace("T_",""));
}
WebFXTreeAbstractNode.prototype.getUrl=function(){
   return this.action;
}
WebFXTreeAbstractNode.prototype.getTitle=function(){
   return this.text;
}
WebFXTreeAbstractNode.prototype.getType=function(){
   return this.stype;
}
WebFXTreeAbstractNode.prototype.getLevel=function(){
   return this._level+1;
}
WebFXTreeAbstractNode.prototype.getParent=function(){
   return this.parentNode;
}

WebFXTreeAbstractNode.prototype.getChild=function(){
   return this.childNodes;
}

//WebFXTreeItem.prototype.addChildNode=function(id,title,type,url){
//   newAddNode=new WebFXTreeItem(title, url, '', this.icon, this.openIcon,type,'false','true','false',id,'true');
//   this.add(newAddNode);
//}

function getCurrentSelectFXTreeItem(){
  if(currentSelectFXTreeId==null)
     return null;
  else{
  try{
    return eval(currentSelectFXTreeId);
    }catch(e){return null;}
   }
}
var currentSelectFXTreeId=$selectWebFXTreeItem$;
var selectFxTreeCheckBoxIds=new Array();
function childToParentNodeCheckBoxeSelectFun(){
   if(selectFxTreeCheckBoxIds.length>0){
      for(i=0;i<selectFxTreeCheckBoxIds.length;i++){
          var foo = document.getElementById(selectFxTreeCheckBoxIds[i]).parentNode;
          while(foo!=null){
             var foo2=document.getElementById(foo.id.replace('-cont', '-anchor'));
             if(foo2==null)
               break;
              checkOb=foo2.childNodes[0];
              if(checkOb!=null&&checkOb.type=="checkbox"){
                  if(checkOb.checked)
                    break;
                  checkOb.checked=true;
              }
             foo = foo.parentNode;
          }
      }
   }
}
WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = "<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + ((foo._last)?webFXTreeConfig.blankIcon:webFXTreeConfig.iIcon) + "\">" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else 
	if(menu$_grad=="false"){
	   this.folder=false;
	   this.open = false;
	   if(this.sselected=="true")
        selectFxTreeCheckBoxIds.push(this.id);
	}
	else {this.open = false;}
	//if ((this.folder) || (webFXTreeHandler.behavior != 'classic')) {
	//	if (!this.icon) { this.icon = webFXTreeConfig.folderIcon; }
	//	if (!this.openIcon) { this.openIcon = webFXTreeConfig.openFolderIcon; }
	//}
	//else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	//if(menu$_leafed=="false") webFXTreeConfig.fileIcon=this.icon;
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	var str = "<div id=\"" + this.id + "\" style=\"vertical-align:middle;\"  class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
		indent +
		"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" "+(this.folder?("onclick=\"webFXTreeHandler.toggle(this);\""):"")+">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + this.icon + "\" "+(this.folder?("onclick=\"webFXTreeHandler.toggle(document.getElementById('"+this.id+"-plus'));\""):"")+">" +//webFXTreeHandler.select(this)
		"<a href=\"javascript:nodeClickFunHander('" + this.action + "','"+this.id.replace("T_","")+"','"+this.text+"','"+this.stype+"','"+(this._level+1)+"')\" "+($selectWebFXTreeItem$==this.id?"class=\"selected-inactive\"":"class=\"selected\"")+" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" +((menu$_cked=="true"&&this.schecked=="true") ? ("<input style=\"vertical-align:middle;\"  type=\"checkbox\" value=\""+this.id.replace("T_","")+"\" name=\"S_$menuCheckBox\" "+(this.sdisabled=="true"?"disabled":"")+" "+(this.sselected=="true"?"checked":"")+" "+(menu$_checkboxmode!="default"?"onclick=\"checkedFun(this.checked,'"+this.id+"');\")":"")+">" ): "")+ label+"</a></div>" +
		"<div id=\"" + this.id + "-cont\" level='"+(this._level+1)+"' class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
	}
	this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
	this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
	return str + sb.join("") + "</div>";
}
function nodeClickFunHander(url,id,title,type,level){
        if(id=="")
		  id=="Root";
		//webFXTreeHandler.cookies.setCookie("$selectWebFXTreeItem$", "T_"+id);
		currentSelectFXTreeId="T_"+id;
		nodeClickFun(url,replaceAll3(id),title,type,level);	
}
   var http_request = false;
   var currentPos = null;
   var currentNode=null;
   var menu$_service=null;
   var menu$_serviceEx=null;
   var menu$_type=null;
   var menu$_checkboxmode="default";
   var menu$_cked="false";
   var menu$_grad="true";
   var base$_path="oxhide";
   var menu$_leafed="true";
   var menu$_selectnodeids="";
   var menu$_fiterId="";
   var menu$_grad_cache=true;

	function send_request(url) {
		http_request = false;
		if(window.XMLHttpRequest) { 
			http_request = new XMLHttpRequest();
			if (http_request.overrideMimeType) {
				http_request.overrideMimeType('text/xml');
			}
		}
		else if (window.ActiveXObject) {
			try {
				http_request = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					http_request = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {}
			}
		}
		if (!http_request) {
			window.alert("can't create XMLHttpRequest standance.");
			return false;
		}
		http_request.onreadystatechange = processRequest;
		http_request.open("GET", url, true);
		http_request.send(null);
	}
    function getCheckIds(){
        returns=new Array();
        var res="";
        checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"&&checks[i].checked==true){
              if(res=="")
                 res=checks[i].value;
              else
                res+=","+checks[i].value;
           }
        }
        returns=res.split(",");
        return returns;
    }
    function setCheckStat(ids){
    	checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"){
           	  if((","+ids+",").indexOf(","+checks[i].value+",")>=0)
                  checks[i].checked=true;
              else
                  checks[i].checked=false;
           }
        }
    }
    function getCheckNodes(){
        returns=new Array();
        var res="";
        checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"&&checks[i].checked==true){
              returns.push(eval(checks[i].parentNode.id.replace("-anchor","")));
           }
        }
        return returns;
    }
    function checkAutoExapll(){
    	checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"&&checks[i].checked==true){
              var node=eval(checks[i].parentNode.id.replace("-anchor",""));
              var nodeDiv=document.getElementById(node.id+"-cont").parentNode;
              var nodes=eval(node.id).parentNode;
              while(nodes&&nodeDiv&&nodeDiv.style.display=="none"){
              	nodes.expand();
              	nodes=nodes.parentNode;
              	nodeDiv=nodeDiv.parentNode;
              }
           }
        }
    }
    function getNoCheckNodes(){
        returns=new Array();
        var res="";
        checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"&&checks[i].checked==false){
              returns.push(eval(checks[i].parentNode.id.replace("-anchor","")));
           }
        }
        return returns;
    }
    function getNoCheckIds(){
        returns=new Array();
        var res="";
        checks=document.getElementsByTagName("input");
        if(checks==null)
           return null;
        for(i=0;i<checks.length;i++){
           if(checks[i].name=="S_$menuCheckBox"&&checks[i].checked==false){
              if(res=="")
                res=checks[i].value;
              else
                res+=","+checks[i].value;
           }
        }
        returns=res.split(",");
        return returns;
    }
    function replaceAll3(str){
       var newStr="";
       while(str.indexOf("$")>=0){
          str=str.replace("$", "-");
       }
       return str;
    }
    
    function replaceAll2(str){
       var newStr="";
       while(str.indexOf("-")>=0){
          str=str.replace("-", "$");
       }
       return str;
    }
    function processRequest() {
        if (http_request.readyState == 4) {
            if (http_request.status == 200) {
            try{
               var evalStr=http_request.responseText;
               if(evalStr.indexOf("webFXTreeConfig.tIcon")<0)
                 evalStr=replaceAll2(evalStr);
               	 eval(evalStr);
                }catch(e){
                	alert("name: " + e.name + "\n\rmessage: " + e.message + "\n\rlineNumber: " + e.lineNumber + 
			          "\n\rfileName: " + e.fileName + "\n\rstack: " + e.stack);
                }
                document.onmousedown="";
            } else {
                alert("request error!");
            }
        }
    }
    function All$Click(){
      alert("¼ÓÔØÖÐ,ÇëÉÔºó..");
    }
    
    function getStuff(n){
      var s="";
      for(i=0;i<n;i++)
        s+="&nbsp;&nbsp;&nbsp;";
      return s;
    }
    function showRoles(obj,node,isReLoad) {
	        if(menu$_service==""&&menu$_serviceEx=="")
	           return;
	        var demp=document.getElementById(obj);
			demp.innerHTML = getStuff(node.getLevel())+"load...";
			demp.style.display = "block";
			currentPos = obj;
			currentNode=node;
			document.onmousedown=All$Click;
			if(isReLoad||!menu$_grad_cache){
			  send_request(base$_path+"/core/menu/menuhander.jsp?playPos="+obj.replace('-cont', '').replace('T_', '')+"&service="+menu$_service+"&type="+menu$_type+"&parentType="+node.stype+"&serviceEx="+menu$_serviceEx+"&selectnodeids="+menu$_selectnodeids+"&fiterId="+menu$_fiterId+"&action="+menu$_action+"&jshand="+Math.random());
			}
			else{
			  send_request(base$_path+"/core/menu/menuhander.jsp?playPos="+obj.replace('-cont', '').replace('T_', '')+"&service="+menu$_service+"&type="+menu$_type+"&parentType="+node.stype+"&serviceEx="+menu$_serviceEx+"&selectnodeids="+menu$_selectnodeids+"&fiterId="+menu$_fiterId+"&action="+menu$_action);
			}
		}
		
		
		