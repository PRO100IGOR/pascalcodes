var parentTopHeight = 0;
var broswerFlag;
$(function() {
	if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
		var a = window.navigator.userAgent.substring(30, 33);
		if (a == "6.0") {
			broswerFlag = "IE6"
		} else {
			if (a == "7.0") {
				broswerFlag = "IE7"
			} else {
				if (a == "8.0") {
					broswerFlag = "IE8"
				} else {
					if (a == "9.0") {
						broswerFlag = "IE9"
					}
				}
			}
		}
	} else {
		if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
			broswerFlag = "Firefox"
		} else {
			if (window.navigator.userAgent.indexOf("Opera") >= 0) {
				broswerFlag = "Opera"
			} else {
				if (window.navigator.userAgent.indexOf("Safari") >= 1) {
					broswerFlag = "Safari"
				} else {
					broswerFlag = "Other"
				}
			}
		}
	}
	$("select").each(function() {
		if (!$(this).attr("class")&& !$(this).attr("multiple")) {
			$(this).selectbox();
		}
	});
	$("select[class*=validate]").not("[multiple]").selectbox();
	setTimeout(function() {
		$("body").addClass("zDialogCon")
	},
	500)
});
jQuery.fn.extend({
	selectbox: function(a) {
		return this.each(function() {
			new jQuery.SelectBox(this, a)
		})
	}
});
if (!window.console) {
	var console = {
		log: function(a) {}
	}
}
var depth = 500;
var elm_id = 1;
jQuery.SelectBox = function(G, g) {
	var c = g || {};
	c.inputClass = c.inputClass || "selectbox";
	c.containerClass = c.containerClass || "selectbox-wrapper";
	c.hoverClass = c.hoverClass || "current";
	c.currentClass = c.selectedClass || "selected";
	c.debug = c.debug || false;
	elm_id++;
	var i = 0;
	var e = false;
	var E = 0;
	var B = $(G);
	var y = k(c);
	var p = C();
	var d = q(c);
	var x = false;
	var w = false;
	var j = 1;
	var F;
	var D;
	var H = 0;
	var r = 0;
	if (window.navigator.userAgent.indexOf("Windows") > -1) {
		H = 1
	}
	D = B.width();
	if (D == "0") {
		D = 116
	}
	var n;
	if (H == 1) {
		if (broswerFlag == "Safari") {
			n = $("<input type='button' value=' ' class='selBtn_safari'/>")
		}
		if (broswerFlag == "IE9") {
			n = $("<input type='button' value=' ' class='selBtn selBtn_ie9'/>")
		} else {
			n = $("<input type='button' value=' ' class='selBtn'/>")
		}
	} else {
		n = $("<input type='button' value=' ' class='selBtn_linux'/>")
	}
	if (B.attr("disabled") == true) {
		n.attr("disabled", true);
		n.addClass("selBtn_disabled")
	}
	var v = $("<div class='loader'>数据加载中...</div>");
	if (B.attr("autoWidth") != null) {
		if (B.attr("autoWidth") == "true") {
			x = true
		} else {
			x = false
		}
	}
	if (B.attr("colNum") != null) {
		j = parseInt(B.attr("colNum"))
	}
	if (B.attr("colWidth") != null) {
		F = Number(B.attr("colWidth"))
	}
	if (j != 1) {
		if (x) {
			d.width(D - 20)
		} else {
			d.width(96)
		}
		if (F != null) {
			y.width(F * j + 40)
		} else {
			var b = Number(D);
			y.width(b * j + 40)
		}
	} else {
		if (x) {
			d.width(D - 20);
			y.width(D + 6)
		} else {
			d.width(96);
			var f = 96 + 4 + 22;
			var b = Number(D);
			y.width(Math.max(f, b))
		}
	}
	B.hide().before(p);
	p.append(d);
	p.append(n);
	p.append(y);
	p.append(v);
	v.hide();
	z();
	if (B.attr("editable") != null) {
		if (B.attr("editable") == "true") {
			w = true
		} else {
			w = false
		}
	}
	if (!w) {
		d.css({
			cursor: "pointer"
		});
		d.click(function() {
			var M;
			var K = y.find("li").length;
			if (j == 1) {
				M = K * 26
			} else {
				if (K % j == 0) {
					M = K * 26 / j
				} else {
					M = (K - K % j) * 26 / j + 26
				}
			}
			y.height(M);
			var I = 200;
			if (parentTopHeight > 0) {
				var L = window.top.document.documentElement.clientHeight;
				I = L - parentTopHeight - parentBottomHeight - p.offset().top - 30
			} else {
				I = window.document.documentElement.clientHeight - (p.offset().top - $(window).scrollTop()) - 30
			}
			if (I < y.height()) {
				if (p.offset().top > y.height()) {
					if (broswerFlag == "IE8" || broswerFlag == "IE9") {
						y.css({
							top: -y.height() - 17
						})
					} else {
						if ($.browser.msie) {
							y.css({
								top: -y.height()
							})
						} else {
							y.css({
								top: -y.height() - 7
							})
						}
					}
				} else {
					if (I < 100 && p.offset().top > I) {
						y.height(p.offset().top);
						y.css({
							overflow: "auto"
						});
						if (broswerFlag == "IE8" || broswerFlag == "IE9") {
							y.css({
								top: -y.height() - 17
							})
						} else {
							if ($.browser.msie) {
								y.css({
									top: -y.height()
								})
							} else {
								y.css({
									top: -y.height() - 7
								})
							}
						}
					} else {
						y.css({
							overflow: "auto"
						});
						if (broswerFlag == "IE8" || broswerFlag == "IE9") {
							y.css({
								top: 8
							})
						} else {
							if ($.browser.msie) {
								y.css({
									top: 25
								})
							} else {
								y.css({
									top: 18
								})
							}
						}
						y.height(I)
					}
				}
			} else {
				if (broswerFlag == "IE8" || broswerFlag == "IE9") {
					y.css({
						top: 8
					})
				} else {
					if ($.browser.msie) {
						y.css({
							top: 25
						})
					} else {
						y.css({
							top: 18
						})
					}
				}
			}
			if (!e) {
				depth++;
				p.css({
					zIndex: depth
				});
				setTimeout(J, 100)
			}
			function J() {
				y.toggle()
			}
		}).focus(function() {
			if (y.not(":visible")) {
				depth++;
				p.css({
					zIndex: depth
				});
				e = true;
				setTimeout(I, 100)
			}
			function I() {
				y.show()
			}
		}).keydown(function(I) {
			switch (I.keyCode) {
			case 38:
				I.preventDefault();
				o( - 1);
				break;
			case 40:
				I.preventDefault();
				o(1);
				break;
			case 13:
				I.preventDefault();
				$("li." + c.hoverClass).trigger("click");
				break;
			case 27:
				l();
				break
			}
		}).blur(function() {
			if (y.is(":visible") && E > 0) {
				if (c.debug) {
					console.log("container visible and has focus")
				}
			} else {
				if (r == 1) {} else {
					l()
				}
			}
		})
	} else {
		d.css({
			cursor: "text"
		});
		d.change(function() {
			B.attr("editValue", $(this).val())
		})
	}
	n.click(function() {
		var M;
		var K = y.find("li").length;
		if (j == 1) {
			M = K * 26
		} else {
			if (K % j == 0) {
				M = K * 26 / j
			} else {
				M = (K - K % j) * 26 / j + 26
			}
		}
		y.height(M);
		var J = 200;
		if (parentTopHeight > 0) {
			var L = window.top.document.documentElement.clientHeight;
			J = L - parentTopHeight - parentBottomHeight - p.offset().top - 30
		} else {
			J = window.document.documentElement.clientHeight - (p.offset().top - $(window).scrollTop()) - 30
		}
		if (J < y.height()) {
			if (p.offset().top > y.height()) {
				if (broswerFlag == "IE8" || broswerFlag == "IE9") {
					y.css({
						top: -y.height() - 17
					})
				} else {
					if ($.browser.msie) {
						y.css({
							top: -y.height()
						})
					} else {
						y.css({
							top: -y.height() - 7
						})
					}
				}
			} else {
				if (J < 100 & p.offset().top > J) {
					y.height(p.offset().top);
					y.css({
						overflow: "auto"
					});
					if (broswerFlag == "IE8" || broswerFlag == "IE9") {
						y.css({
							top: -y.height() - 17
						})
					} else {
						if ($.browser.msie) {
							y.css({
								top: -y.height()
							})
						} else {
							y.css({
								top: -y.height() - 7
							})
						}
					}
				} else {
					y.css({
						overflow: "auto"
					});
					if (broswerFlag == "IE8" || broswerFlag == "IE9") {
						y.css({
							top: 8
						})
					} else {
						if ($.browser.msie) {
							y.css({
								top: 25
							})
						} else {
							y.css({
								top: 18
							})
						}
					}
					y.height(J)
				}
			}
		} else {
			if (broswerFlag == "IE8" || broswerFlag == "IE9") {
				y.css({
					top: 8
				})
			} else {
				if ($.browser.msie) {
					y.css({
						top: 25
					})
				} else {
					y.css({
						top: 18
					})
				}
			}
		}
		if (!e) {
			depth++;
			p.css({
				zIndex: depth
			});
			setTimeout(I, 100)
		}
		function I() {
			y.toggle()
		}
	}).focus(function() {
		if (y.not(":visible")) {
			depth++;
			p.css({
				zIndex: depth
			});
			e = true;
			setTimeout(I, 100)
		}
		function I() {
			y.show()
		}
	}).keydown(function(I) {
		switch (I.keyCode) {
		case 38:
			I.preventDefault();
			o( - 1);
			break;
		case 40:
			I.preventDefault();
			o(1);
			break;
		case 13:
			I.preventDefault();
			$("li." + c.hoverClass).trigger("click");
			break;
		case 27:
			l();
			break
		}
	}).blur(function() {
		if (y.is(":visible") && E > 0) {
			if (c.debug) {
				console.log("container visible and has focus")
			}
		} else {
			if (r == 1) {} else {
				l()
			}
		}
	});
	function l() {
		E = 0;
		y.hide();
		r = 0
	}
	function z() {
		y.append(s(d.attr("id"))).hide();
		var I = d.css("width")
	}
	function C() {
		var I = $("<div></div>");
		I.addClass("mainCon");
		return I
	}
	function k(I) {
		var J = $("<div></div>");
		J.attr("id", elm_id + "_container");
		J.addClass(I.containerClass);
		J.css({});
		J.mouseover(function() {
			r = 1
		});
		J.mouseout(function() {
			r = 0
		});
		return J
	}
	function q(J) {
		var I = document.createElement("input");
		var L = $(I);
		L.attr("id", elm_id + "_input");
		L.attr("type", "text");
		L.addClass(J.inputClass);
		if (broswerFlag == "IE8") {
			L.addClass("selectboxFont")
		}
		L.attr("autocomplete", "off");
		var K = false;
		if (B.attr("editable") != null) {
			if (B.attr("editable") == "true") {
				K = true
			} else {
				K = false
			}
		}
		if (!K) {
			L.attr("readonly", "readonly")
		} else {
			L.attr("readonly", false)
		}
		L.attr("tabIndex", B.attr("tabindex"));
		if (B.attr("disabled") == true) {
			L.attr("disabled", true);
			L.addClass("inputDisabled")
		}
		return L
	}
	function o(J) {
		var I = $("li", y);
		if (!I || I.length == 0) {
			return false
		}
		i += J;
		if (i < 0) {
			i = I.size()
		} else {
			if (i > I.size()) {
				i = 0
			}
		}
		a(I, i);
		I.removeClass(c.hoverClass);
		$(I[i]).addClass(c.hoverClass)
	}
	function a(J, K) {
		var I = $(J[K]).get(0);
		var J = y.get(0);
		if (I.offsetTop + I.offsetHeight > J.scrollTop + J.clientHeight) {
			J.scrollTop = I.offsetTop + I.offsetHeight - J.clientHeight
		} else {
			if (I.offsetTop < J.scrollTop) {
				J.scrollTop = I.offsetTop
			}
		}
	}
	function h() {
		var I = $("li." + c.currentClass, y).get(0);
		var J = (I.id).split("_");
		var L = J[0].length + J[1].length + 2;
		var M = I.id;
		var K = M.substr(L, M.length);
		B.val(K);
		B.attr("relText", $(I).text());
		var M = $(I).html().trim();
		d.val(M);
		if (w == true) {
			B.attr("editValue", d.val())
		}
		B.focus();
		return true
	}
	function t() {
		return B.val()
	}
	function m() {
		return d.val()
	}
	function s(O) {
		var P = new Array();
		var L = document.createElement("ul");
		var N = [];
		var J = 0;
		var I;
		if (B.attr("childId") != null) {
			I = true
		}
		var K = 1;
		var M;
		if (B.attr("colNum") != null) {
			K = parseInt(B.attr("colNum"))
		}
		if (B.attr("colWidth") != null) {
			M = Number(B.attr("colWidth"))
		}
		B.find("option").each(function() {
			N.push($(this)[0]);
			var Q = document.createElement("li");
			Q.setAttribute("id", O + "_" + $(this).val());
			Q.innerHTML = $(this).html();
			if ($(this).is(":selected")) {
				var R;
				if (B.attr("editable") != null) {
					if (B.attr("editable") == "true") {
						R = true
					} else {
						R = false
					}
				}
				if (R == true) {
					d.val($(this).html());
					$(Q).addClass(c.currentClass)
				} else {
					var T = $(this).html().trim();
					d.val(T);
					$(Q).addClass(c.currentClass)
				}
			}
			if (K != 1) {
				$(Q).addClass("li_left");
				if (M != null) {
					$(Q).width(M)
				} else {
					var S = Number(D);
					$(Q).width(S)
				}
			}
			L.appendChild(Q);
			$(Q).mouseover(function(U) {
				E = 1;
				if (c.debug) {
					console.log("over on : " + this.id)
				}
				jQuery(U.target, y).addClass(c.hoverClass)
			}).mouseout(function(U) {
				E = -1;
				if (c.debug) {
					console.log("out on : " + this.id)
				}
				jQuery(U.target, y).removeClass(c.hoverClass)
			}).click(function(V) {
				var W = $("li." + c.hoverClass, y).get(0);
				if (c.debug) {
					console.log("click on :" + this.id)
				}
				var U = $(this).attr("id").split("_");
				$("#" + U[0] + "_container li." + c.currentClass).removeClass(c.currentClass);
				$(this).addClass(c.currentClass);
				h();
				B.get(0).blur();
				l();
				if (B.attr("onchange") != null) {
					$(B.attr("onchange"))
				}
				d.removeClass("tipColor");
				if (I) {
					u(B, B.val())
				}
			})
		});
		B.find("optgroup").each(function() {
			var R = getPosition($(this).children("option").eq(0)[0], N);
			var Q = $(this).attr("label");
			$(L).find("li").eq(R + J).before("<li class='group'>" + Q + "</li>");
			J++
		});
		return L
	}
	function u(K, J) {
		if (J != "") {
			var L = K.attr("childId");
			var I = $("#" + L).prev().find("div[class=loader]");
			I.show();
			window.setTimeout(function() {
				A(K, J)
			},
			200)
		}
	}
	function A(K, J) {
		var I;
		if (K.attr("childDataType") == null) {
			I = K.attr("childDataPath") + J
		} else {
			if (K.attr("childDataType") == "url") {
				I = K.attr("childDataPath") + J
			} else {
				I = K.attr("childDataPath") + J + "." + K.attr("childDataType")
			}
		}
		$.ajax({
			url: I,
			error: function() {
				try {
					top.Dialog.alert("数据加载失败，请检查childDataPath是否正确")
				} catch(L) {
					alert("数据加载失败，请检查childDataPath是否正确")
				}
			},
			success: function(O) {
				var L = K.attr("childId");
				var T = $("#" + L).prev().find("div[class=loader]");
				T.hide();
				var R = $("#" + L).prev().find("ul");
				var N = $("#" + L).prev().find(">div").attr("id").split("_")[0];
				var M = $("#" + L).prev().find("input:text");
				var P = $("#" + L)[0];
				R.html("");
				P.options.length = 0;
				$(O).find("node").each(function() {
					var W = $(this).attr("text");
					var V = $(this).attr("value");
					var U = document.createElement("li");
					$(U).text(W);
					$(U).attr("relValue", V);
					R.append($(U));
					P.options[P.options.length] = new Option(W, V);
					$(U).mouseover(function(X) {
						jQuery(X.target).addClass(c.hoverClass)
					});
					$(U).mouseout(function(X) {
						jQuery(X.target).removeClass(c.hoverClass)
					});
					$(U).mousedown(function(Y) {
						$("#" + N + "_container li." + c.currentClass).removeClass(c.currentClass);
						$(this).addClass(c.currentClass);
						$("#" + L).attr("relText", $(this).text());
						$("#" + L).val($(this).attr("relValue"));
						M.val($(this).html());
						$("#" + L).prev().find(">div").hide();
						$("#" + L).focus();
						if ($("#" + L).attr("onchange") != null) {
							$($("#" + L).attr("onchange"))
						}
						var X;
						if ($("#" + L).attr("childId") != null) {
							X = true
						}
						if (X) {
							u($("#" + L), $("#" + L).val())
						}
					})
				});
				if ($(O).find("node").length == 0) {
					var S = document.createElement("li");
					$(S).text("无内容");
					R.append($(S))
				}
				var Q = R.find("li").eq(0);
				M.val(Q.text());
				Q.addClass(c.currentClass);
				$("#" + L).attr("relValue", Q.attr("relValue"));
				$("#" + L).attr("relText", Q.text())
			}
		})
	}
};
function selRefresh(a) {
	var b;
	if (typeof(a) == "object") {
		b = a
	} else {
		b = $("#" + a)
	}
	b.prev(".mainCon").remove();
	b.selectbox()
}
function getPosition(b, c) {
	for (var a = 0; a < c.length; a++) {
		if (b == c[a]) {
			return a;
			break
		}
	}
}
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "")
};