/**
 * jQuery custom checkboxes
 * 
 * Copyright (c) 2008 Khavilo Dmitry (http://widowmaker.kiev.ua/checkbox/)
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * @version 1.3.0 Beta 1
 * @author Khavilo Dmitry
 * @mailto wm.morgun@gmail.com
**/

(function($){
	/* Little trick to remove event bubbling that causes events recursion */
	var jss = $("script"),basePath;
	for(var i = 0;i<jss.length;i++){
		if(jss[i].src.indexOf("jquery.switch.js") > -1){
			basePath = jss[i].src.match(/http:\/*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\/*\w*\/*/i) + "/resource/base/js/layout/switch/";
		}
	}
	var CB = function(e)
	{
		if (!e) var e = window.event;
		e.cancelBubble = true;
		if (e.stopPropagation) e.stopPropagation();
	};
	document.write("<link rel='stylesheet' type='text/css' href='"+basePath+"/jquery.checkbox.css'/>");
	$.fn.switchBox = function(options) {
		/* IE6 background flicker fix */
		try	{ document.execCommand('BackgroundImageCache', false, true);	} catch (e) {}
		
		/* Default settings */
		var settings = {
			cls: 'jquery-checkbox',  /* checkbox  */
			sls: 'jquery-switchbox',
			empty: basePath + 'empty.png'  /* checkbox  */
		};
		
		/* Processing settings */
		settings = $.extend(settings, options || {});
		
		/* Adds check/uncheck & disable/enable events */
		var addEvents = function(object)
		{
			var attrs =  object.nodeName == "SELECT" ? "value" : "checked";
			var checked = object[attrs];
			var disabled = object.disabled;
			var $object = $(object);
			
			if ( object.stateInterval )
				clearInterval(object.stateInterval);
			
			object.stateInterval = setInterval(
				function() 
				{
					if ( object.disabled != disabled )
						$object.trigger( (disabled = !!object.disabled) ? 'disable' : 'enable');
					if ( object[attrs] != checked ){
				
						$object.trigger( (checked = !!object[attrs]) ? 'check' : 'uncheck');
					}
						
				}, 
				10 /* in miliseconds. Low numbers this can decrease performance on slow computers, high will increase responce time */
			);
			return $object;
		};
		//try { console.log(this); } catch(e) {}
		
		/* Wrapping all passed elements */
		return this.each(function() 
		{
			var ch = this; /* Reference to DOM Element*/
			var $ch = addEvents(ch); /* Adds custom events and returns, jQuery enclosed object */
			var attrs =  ch.nodeName == "SELECT" ? "value" : "checked";
			/* Removing wrapper if already applied  */
			if (ch.wrapper) ch.wrapper.remove();
			
			/* Creating wrapper for checkbox and assigning "hover" event */
			var c =  ch.nodeName == "SELECT" ? "sls" : "cls";
			ch.wrapper = $('<span class="' + settings[c] + '"><span class="mark"><img src="' + settings.empty + '" /></span></span>');
			ch.wrapperInner = ch.wrapper.children('span:eq(0)');
			ch.wrapper.hover(
				function(e) { ch.wrapperInner.addClass(settings[c] + '-hover');CB(e); },
				function(e) { ch.wrapperInner.removeClass(settings[c] + '-hover');CB(e); }
			);
			
			/* Wrapping checkbox */
			$ch.css({position: 'absolute', zIndex: -1, visibility: 'hidden'}).after(ch.wrapper);
			
			/* Ttying to find "our" label */
		
			ch.wrapper.click(function(e) {
				if(ch.disabled) return;
				if(ch.nodeName == "SELECT") {
					+$ch.val() ? $ch.val(0) : $ch.val(1) ; 
					+$ch.val() ? ch.wrapper.addClass(settings.sls+'-checked' ) : ch.wrapper.removeClass(settings.sls+'-checked' );
				}
				$ch.trigger('click',[e]);
				$ch.trigger('change',[e]);
				CB(e); return false;}
			);


			$ch.click(function(e) { CB(e); });
			$ch.bind('disable', function() { ch.wrapperInner.addClass(settings[c]+'-disabled');}).bind('enable', function() { ch.wrapperInner.removeClass(settings[c]+'-disabled');});
			$ch.bind('check', function() { ch.wrapper.addClass(settings.cls+'-checked' );}).bind('uncheck', function() { ch.wrapper.removeClass(settings.cls+'-checked' );});
			
			/* Disable image drag-n-drop for IE */
			$('img', ch.wrapper).bind('dragstart', function () {return false;}).bind('mousedown', function () {return false;});
			
			/* Firefox antiselection hack */
			if ( window.getSelection )
				ch.wrapper.css('MozUserSelect', 'none');
			
			/* Applying checkbox state */
			if ( ch.nodeName == "SELECT" ){
				if(+ch.value)ch.wrapper.addClass(settings[c] + '-checked');
			}else if(ch.checked)
				ch.wrapper.addClass(settings[c] + '-checked');

			if ( ch.disabled )
				ch.wrapperInner.addClass(settings[c] + '-disabled');			
		});
	}
})(jQuery);


$(window).load(function(){
	$("input:checkbox[switch=true],input:radio[switch=true],select[switch=true]").switchBox();
});