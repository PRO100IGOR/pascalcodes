$(function() {
	var a;
	$("input:text[class=''],input:password[class=''],input:text[class*=validate],input:password[class*=validate]").each(function() {
		$(this).addClass("textinput");
		$(this).hover(function() {
			if (a != $(this)[0]) {
				$(this).removeClass("textinput");
				$(this).addClass("textinput_hover")
			}
		},
		function() {
			if (a != $(this)[0]) {
				$(this).removeClass("textinput_hover");
				$(this).addClass("textinput")
			}
		});
		$(this).focus(function() {
			a = $(this)[0];
			$(this).removeClass("textinput");
			$(this).removeClass("textinput_hover");
			$(this).addClass("textinput_click")
		});
		$(this).blur(function() {
			a = null;
			$(this).removeClass("textinput_click");
			$(this).addClass("textinput")
		});
		if ($(this).attr("clearable") == "true") {
			$(this).clearableTextField()
		}
		if ($(this).attr("selectable") == "true") {
			$(this).selectTextField()
		}
		if ($(this).attr("maxNum") != null) {
			$(this).maxlength()
		}
		if ($(this).attr("checkStrength") == "true") {
			$(this).password_strength()
		}
		if ($(this).attr("watermark") != null) {
			$(this).watermark("watermark", $(this).attr("watermark"))
		}
	});
	$("input:password[class='textinput'],input:password[class*=validate]").each(function() {
		$(this).caps(function(b) {
			if (jQuery.browser.safari) {
				return
			}
			if (b) {
				$.cursorMessage("注意：大写键开启了")
			} else {}
		})
	});
	$("textarea").each(function() {
		if ($(this).attr("class") == "") {
			$(this).addClass("textarea")
		}
		if ($(this).attr("maxNum") != null) {
			$(this).maxlength({
				maxCharacters: parseInt($(this).attr("maxNum"))
			})
		}
		if ($(this).attr("resize") == "true") {
			$(this).TextAreaResizer()
		}
		if ($(this).attr("autoHeight") == "true") {
			$(this).css({
				height: "auto"
			});
			$(this).attr("rows", 5);
			$(this).autoGrow()
		}
		if ($(this).attr("watermark") != null) {
			$(this).watermark("watermark", $(this).attr("watermark"))
		}
	});
	$("textarea[class='textarea'],textarea[class*='textarea'],textarea[class*=validate]").each(function() {
		$(this).hover(function() {
			if (a != $(this)[0]) {
				$(this).removeClass("textarea");
				$(this).addClass("textarea_hover")
			}
		},
		function() {
			if (a != $(this)[0]) {
				$(this).removeClass("textarea_hover");
				$(this).addClass("textarea")
			}
		});
		$(this).focus(function() {
			a = $(this)[0];
			$(this).removeClass("textarea");
			$(this).removeClass("textarea_hover");
			$(this).addClass("textarea_click")
		});
		$(this).blur(function() {
			a = null;
			$(this).removeClass("textarea_click");
			$(this).addClass("textarea")
		})
	})
}); (function(c) {
	var h,
	i;
	var d = 0;
	var a = 32;
	var e;
	c.fn.TextAreaResizer = function() {
		return this.each(function() {
			h = c(this).addClass("processed"),
			i = null;
			c(this).wrap('<div class="resizable-textarea"><span></span></div>').parent().append(c('<div class="grippie"></div>').bind("mousedown", {
				el: this
			},
			b));
			var k = c("div.grippie", c(this).parent())[0];
			k.style.marginRight = (k.offsetWidth - c(this)[0].offsetWidth) + "px"
		})
	};
	function b(k) {
		h = c(k.data.el);
		h.blur();
		d = j(k).y;
		i = h.height() - d;
		h.css("opacity", 0.25);
		c(document).mousemove(g).mouseup(f);
		return false
	}
	function g(m) {
		var k = j(m).y;
		var l = i + k;
		if (d >= (k)) {
			l -= 5
		}
		d = k;
		l = Math.max(a, l);
		h.height(l + "px");
		if (l < a) {
			f(m)
		}
		return false
	}
	function f(k) {
		c(document).unbind("mousemove", g).unbind("mouseup", f);
		h.css("opacity", 1);
		h.focus();
		h = null;
		i = null;
		d = 0
	}
	function j(k) {
		return {
			x: k.clientX + document.documentElement.scrollLeft,
			y: k.clientY + document.documentElement.scrollTop
		}
	}
})(jQuery); (function(a) {
	a.fn.watermark = function(b, c) {
		return this.each(function() {
			var e = a(this),
			d;
			e.focus(function() {
				d && !(d = 0) && e.removeClass(b).data("w", 0).val("");
				a(this).val("")
			}).blur(function() { ! e.val() && (d = 1) && e.addClass(b).data("w", 1).val(c);
				a(this).addClass(b)
			}).closest("form").submit(function() {
				d && e.val("")
			});
			e.blur()
		})
	};
	a.fn.removeWatermark = function() {
		return this.each(function() {
			a(this).data("w") && a(this).val("")
		})
	}
})(jQuery);
if (jQuery) { (function(a) {
		a.cursorMessageData = {};
		a(window).ready(function(b) {
			if (a("#cursorMessageDiv").length == 0) {
				a("body").append('<div id="cursorMessageDiv">&nbsp;</div>');
				a("#cursorMessageDiv").hide()
			}
			a("body").mousemove(function(c) {
				a.cursorMessageData.mouseX = c.pageX;
				a.cursorMessageData.mouseY = c.pageY;
				if (a.cursorMessageData.options != undefined) {
					a._showCursorMessage()
				}
			})
		});
		a.extend({
			cursorMessage: function(c, b) {
				if (b == undefined) {
					b = {}
				}
				if (b.offsetX == undefined) {
					b.offsetX = 5
				}
				if (b.offsetY == undefined) {
					b.offsetY = 5
				}
				if (b.hideTimeout == undefined) {
					b.hideTimeout = 1000
				}
				a("#cursorMessageDiv").html(c).fadeIn("slow");
				if (jQuery.cursorMessageData.hideTimeoutId != undefined) {
					clearTimeout(jQuery.cursorMessageData.hideTimeoutId)
				}
				if (b.hideTimeout > 0) {
					jQuery.cursorMessageData.hideTimeoutId = setTimeout(a.hideCursorMessage, b.hideTimeout)
				}
				jQuery.cursorMessageData.options = b;
				a._showCursorMessage()
			},
			hideCursorMessage: function() {
				a("#cursorMessageDiv").fadeOut("slow")
			},
			_showCursorMessage: function() {
				a("#cursorMessageDiv").css({
					top: (a.cursorMessageData.mouseY + a.cursorMessageData.options.offsetY) + "px",
					left: (a.cursorMessageData.mouseX + a.cursorMessageData.options.offsetX)
				})
			}
		})
	})(jQuery)
}
jQuery.fn.caps = function(a) {
	return this.keypress(function(f) {
		var b = f.which ? f.which: (f.keyCode ? f.keyCode: -1);
		var d = f.shiftKey ? f.shiftKey: (f.modifiers ? !!(f.modifiers & 4) : false);
		var g = ((b >= 65 && b <= 90) && !d) || ((b >= 97 && b <= 122) && d);
		a.call(this, g)
	})
}; 

(function(d) {

	d.fn.selectTextField = function() {
		if (d(this).length > 0) {
			d(this).bind("keyup change paste cut", e);
			for (var f = 0; f < d(this).length; f++) {
				c(d(d(this)[f]))
			}
		}
	};

	function e() {
		c(d(this))
	}
	function c(f) {
		if (f.val().length > 0) {
			b(f)
		} else {
			a(f)
		}
	}
	function b(i) {
		if (!i.next().hasClass("text_select_button")) {
			i.after("<div class='text_select_button'></div>");
			var f = i.next();
			var g = f.outerHeight(),
			k = f.outerHeight();
			i.css("padding-right", parseInt(i.css("padding-right")) + g + 1);
			i.width(i.width() - g - 1);
			var m = i.position();
			var j = {};
			j.left = m.left + i.outerWidth(false) - (g + 2);
			var l = Math.round((i.outerHeight(true) - k) / 2);
			j.top = m.top + d("#scrollContent").scrollTop() + l;
			f.css(j);

			f.click(function() {
				eval(i.attr("onselectable"));
				c(i)
			})
		}
	}
	function a(h) {
		var f = h.next();
		if (f.hasClass("text_clear_button")) {
			f.remove();
			var g = f.width();
			h.css("padding-right", parseInt(h.css("padding-right")) - g - 1);
			h.width(h.width() + g + 1)
		}
	}
})(jQuery);


(function(d) {

	d.fn.clearableTextField = function() {
		if (d(this).length > 0) {
			d(this).bind("keyup change paste cut", e);
			for (var f = 0; f < d(this).length; f++) {
				c(d(d(this)[f]))
			}
		}
	};
	function e() {
		c(d(this))
	}
	function c(f) {
		if (f.val().length > 0) {
			b(f)
		} else {
			a(f)
		}
	}
	function b(i) {
		if (!i.next().hasClass("text_clear_button")) {
			i.after("<div class='text_clear_button'></div>");
			var f = i.next();
			var g = f.outerHeight(),
			k = f.outerHeight();
			i.css("padding-right", parseInt(i.css("padding-right")) + g + 1);
			i.width(i.width() - g - 1);
			var m = i.position();
			var j = {};
			j.left = m.left + i.outerWidth(false) - (g + 2);
			var l = Math.round((i.outerHeight(true) - k) / 2);
			j.top = m.top + d("#scrollContent").scrollTop() + l;
			f.css(j);
			f.click(function() {
				i.val("");
				c(i)
			})
		}
	}
	function a(h) {
		var f = h.next();
		if (f.hasClass("text_clear_button")) {
			f.remove();
			var g = f.width();
			h.css("padding-right", parseInt(h.css("padding-right")) - g - 1);
			h.width(h.width() + g + 1)
		}
	}
})(jQuery); (function(a) {
	a.fn.maxlength = function(b) {
		var c = jQuery.extend({
			events: [],
			maxCharacters: 10,
			status: true,
			statusClass: "maxNum",
			statusText: "剩余字数",
			notificationClass: "notification",
			showAlert: false,
			alertText: "输入字符超出限制.",
			slider: true
		},
		b);
		a.merge(c.events, ["keyup"]);
		return this.each(function() {
			var g = a(this);
			var j = a(this).val().length;
			function d() {
				var k = c.maxCharacters - j;
				if (k < 0) {
					k = 0
				}
				g.next("div").html(c.statusText + " :" + k)
			}
			function e() {
				var k = true;
				if (j >= c.maxCharacters) {
					k = false;
					g.addClass(c.notificationClass);
					g.val(g.val().substr(0, c.maxCharacters));
					i()
				} else {
					if (g.hasClass(c.notificationClass)) {
						g.removeClass(c.notificationClass)
					}
				}
				if (c.status) {
					d()
				}
			}
			function i() {
				if (c.showAlert) {
					alert(c.alertText)
				}
			}
			function f() {
				var k = false;
				if (g.is("textarea")) {
					k = true
				} else {
					if (g.filter("input[type=text]")) {
						k = true
					} else {
						if (g.filter("input[type=password]")) {
							k = true
						}
					}
				}
				return k
			}
			if (!f()) {
				return false
			}
			a.each(c.events,
			function(k, l) {
				g.bind(l,
				function(m) {
					j = g.val().length;
					e()
				})
			});
			if (c.status) {
				g.after(a("<div/>").addClass(c.statusClass).html("-"));
				d()
			}
			if (!c.status) {
				var h = g.next("div." + c.statusClass);
				if (h) {
					h.remove()
				}
			}
			if (c.slider) {
				g.next().hide();
				g.focus(function() {
					g.next().slideDown("fast")
				});
				g.blur(function() {
					g.next().slideUp("fast")
				})
			}
		})
	}
})(jQuery);
var colsDefault = 0;
var rowsDefault = 5;
function setDefaultValues(a) {
	colsDefault = a.cols;
	rowsDefault = $(a).attr("rows")
}
function bindEvents(a) {
	a.onkeyup = function() {
		grow(a)
	}
}
function grow(d) {
	var c = 0;
	var a = d.value.split("\n");
	for (var b = a.length - 1; b >= 0; --b) {
		c += Math.floor((a[b].length / colsDefault) + 1)
	}
	if (c >= rowsDefault) {
		d.rows = c + 1
	} else {
		d.rows = rowsDefault
	}
}
jQuery.fn.autoGrow = function() {
	return this.each(function() {
		setDefaultValues(this);
		bindEvents(this)
	})
}; (function(b) {
	var a = new
	function() {
		this.countRegexp = function(d, e) {
			var c = d.match(e);
			return c ? c.length: 0
		};
		this.getStrength = function(i, e) {
			var c = i.length;
			if (c < e) {
				return 0
			}
			var g = this.countRegexp(i, /\d/g),
			j = this.countRegexp(i, /[a-z]/g),
			f = this.countRegexp(i, /[A-Z]/g),
			d = c - g - j - f;
			if (g == c || j == c || f == c || d == c) {
				return 1
			}
			var h = 0;
			if (g) {
				h += 2
			}
			if (j) {
				h += f ? 4: 3
			}
			if (f) {
				h += j ? 4: 3
			}
			if (d) {
				h += 5
			}
			if (c > 10) {
				h += 1
			}
			return h
		};
		this.getStrengthLevel = function(e, c) {
			var d = this.getStrength(e, c);
			switch (true) {
			case(d <= 0) : return 1;
				break;
			case (d > 0 && d <= 4) : return 2;
				break;
			case (d > 4 && d <= 8) : return 3;
				break;
			case (d > 8 && d <= 12) : return 4;
				break;
			case (d > 12) : return 5;
				break
			}
			return 1
		}
	};
	b.fn.password_strength = function(c) {
		var d = b.extend({
			container: null,
			minLength: 6,
			texts: {
				1: "非常弱",
				2: "弱密码",
				3: "强度一般",
				4: "强密码",
				5: "非常强"
			}
		},
		c);
		return this.each(function() {
			if (d.container) {
				var e = b(d.container)
			} else {
				var e = b("<span/>").attr("class", "password_strength");
				b(this).after(e)
			}
			b(this).keyup(function() {
				var g = b(this).val();
				if (g.length > 0) {
					var h = a.getStrengthLevel(g, d.minLength);
					var f = "password_strength_" + h;
					if (!e.hasClass(f) && h in d.texts) {
						e.text(d.texts[h]).attr("class", "password_strength " + f)
					}
				} else {
					e.text("").attr("class", "password_strength")
				}
			})
		})
	}
})(jQuery);