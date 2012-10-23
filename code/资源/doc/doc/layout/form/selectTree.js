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
	$(".selectTree").each(function() {
		$(this).selectTreeBox()
	})
});
jQuery.fn.extend({
	selectTreeBox: function(a) {
		return this.each(function() {
			new jQuery.SelectTreeBox(this, a)
		})
	}
});
var depth = 500;
var elm_id = 1;
jQuery.SelectTreeBox = function(D, s) {
	var l = s || {};
	l.inputClass = l.inputClass || "selectbox";
	l.containerClass = l.containerClass || "selectbox-tree";
	l.hoverClass = l.hoverClass || "current";
	l.currentClass = l.selectedClass || "selected";

	l.debug = l.debug || false;
	elm_id++;
	var i = "0_input";
	var x = "0_button";
	var v = false;
	var G = $(D);
	var c = t(l);
	u = u.substr(0, 22);
	var p = f();
	var w = F(l);
	var C = false;
	var d = 0;

	if (window.navigator.userAgent.indexOf("Windows") > -1) {
		d = 1
	}
	var m;
	if (G.attr("boxWidth") != null) {
		m = Number(G.attr("boxWidth"))
	} else {
		m = 150
	}
	var r;
	if (d == 1) {
		if (broswerFlag == "Safari") {
			r = $("<input type='button' value=' ' class='selBtn_safari'/>")
		}
		if (broswerFlag == "IE9") {
			r = $("<input type='button' value=' ' class='selBtn selBtn_ie9'/>")
		} else {
			r = $("<input type='button' value=' ' class='selBtn'/>")
		}
	} else {
		r = $("<input type='button' value=' ' class='selBtn_linux'/>")
	}
	var a = false;
	if (G.attr("multiMode") != null) {
		if (G.attr("multiMode") == "true" || G.attr("multiMode") == true) {
			a = true;
			r.addClass("selBtnMuiti");
			var B = G.attr("relText");
			var k;
			if (B != "请选择") {
				setTimeout(function() {
					b()
				},
				500)
			}
		} else {
			a = false
		}
	}
	if (G.attr("disabled") == "true" || G.attr("disabled") == true) {
		r.attr("disabled", true);
		if (a == true) {
			r.addClass("selBtn_disabledMuiti")
		} else {
			r.addClass("selBtn_disabled")
		}
	}
	r.attr("id", elm_id + "_button");
	var j = 96;
	if (G.attr("selWidth") != null) {
		j = Number(G.attr("selWidth")) - 4 - 22
	}
	w.width(j);
	var H = 96 + 4 + 22;
	var A = Number(m);
	if (G.attr("boxWidth") != null) {
		c.width(Math.max(H, A))
	} else {}
	G.hide().before(p);
	p.append(w);
	p.append(r);
	p.append(c);
	var o = false;
	if (G.attr("editable") != null) {
		if (G.attr("editable") == "true") {
			o = true
		} else {
			o = false
		}
	}
	E();
	if (!o) {
		w.css({
			cursor: "pointer"
		});
		w.click(function(K) {
			i = $(K.target).attr("id");
			y();
			depth++;
			p.css({
				zIndex: depth
			});
			if (c.attr("hasfocus") == 0) {
				q()
			} else {
				b()
			}
		})
	} else {
		w.css({
			cursor: "text"
		});
		w.change(function() {
			G.attr("editValue", $(this).val())
		})
	}
	r.click(function(K) {
		x = $(K.target).attr("id");
		y();
		depth++;
		p.css({
			zIndex: depth
		});
		if (c.attr("hasfocus") == 0) {
			q()
		} else {
			b()
		}
	});
	function y() {
		var N;
		var L = c.find("li").length;
		N = 200;
		var K = 200;
		if (parentTopHeight > 0) {
			var M = window.top.document.documentElement.clientHeight;
			K = M - parentTopHeight - parentBottomHeight - p.offset().top - 30
		} else {
			K = window.document.documentElement.clientHeight - (p.offset().top - $(window).scrollTop()) - 30
		}
		if (K < c.height()) {
			if (p.offset().top > c.height()) {
				if (broswerFlag == "IE8" || broswerFlag == "IE9") {
					c.css({
						top: -c.height() - 17
					})
				} else {
					if ($.browser.msie) {
						c.css({
							top: -c.height()
						})
					} else {
						c.css({
							top: -c.height() - 7
						})
					}
				}
			} else {
				if (K < 100 && p.offset().top > K) {
					c.height(p.offset().top);
					c.css({
						overflowY: "auto",
						overflowX: "hidden"
					});
					if (broswerFlag == "IE8" || broswerFlag == "IE9") {
						c.css({
							top: -c.height() - 17
						})
					} else {
						if ($.browser.msie) {
							c.css({
								top: -c.height()
							})
						} else {
							c.css({
								top: -c.height() - 7
							})
						}
					}
				} else {
					c.css({
						overflowY: "auto",
						overflowX: "hidden"
					});
					if (broswerFlag == "IE8" || broswerFlag == "IE9") {
						c.css({
							top: 8
						})
					} else {
						if ($.browser.msie) {
							c.css({
								top: 25
							})
						} else {
							c.css({
								top: 18
							})
						}
					}
					c.height(K)
				}
			}
		} else {
			if (broswerFlag == "IE8" || broswerFlag == "IE9") {
				c.css({
					top: 8
				})
			} else {
				if ($.browser.msie) {
					c.css({
						top: 25
					})
				} else {
					c.css({
						top: 18
					})
				}
			}
		}
	}
	function E() {
		c.append(z(w.attr("id"))).hide();
		if (G.attr("treeType") == "dtree") {
			if (!a) {
				c.find("a:[class=node]").click(function() {
					h($(this).text(), $(this).attr("nodetruedata"));
					b()
				});
				c.find("a:[class=nodeSel]").click(function() {
					h($(this).text(), $(this).attr("nodetruedata"));
					b()
				});
				if (G.attr("relText") != "请选择") {
					c.find("a:[class=node]").each(function() {
						if ($(this).text() == G.attr("relText")) {
							h($(this).text(), $(this).attr("nodetruedata"))
						}
					});
					c.find("a:[class=nodeSel]").each(function() {
						if ($(this).text() == G.attr("relText")) {
							h($(this).text(), $(this).attr("nodetruedata"))
						}
					})
				}
			} else {}
		} else {
			if (G.attr("treeType") == "ztree") {
				try {
					initSelectTree(G.attr("id"))
				} catch(K) {}
				if (!a) {} else {}
			} else {
				c.find(".simpleTree").simpleTree({
					afterClick: function(L) {
						h($("span:first", L).text(), L.attr("id"));
						b()
					},
					animate: true
				});
				if (G.attr("relText") != "请选择") {
					c.find("li ").each(function() {
						if ($(this).find("span:first").text() == G.attr("relText")) {
							h($(this).find("span:first").text(), $(this).attr("id"))
						}
					})
				}
			}
		}
		if (G.attr("editValue") == null) {
			G.attr("editValue", G.attr("relText"))
		}
	}
	function n() {
		alert(111)
	}
	function f() {
		var K = $("<div></div>");
		K.addClass("mainCon");
		return K
	}
	function t(K) {
		var L = $("<div></div>");
		L.attr("id", elm_id + "_container");
		L.addClass(K.containerClass);
		L.attr("hasfocus", 0);
		return L
	}
	function F(L) {
		var K = document.createElement("input");
		var N = $(K);
		N.attr("id", elm_id + "_input");
		N.attr("type", "text");
		N.addClass(L.inputClass);
		if (broswerFlag == "IE8") {
			N.addClass("selectboxFont")
		}
		N.attr("autocomplete", "off");
		var M = false;
		if (G.attr("editable") != null) {
			if (G.attr("editable") == "true") {
				M = true
			} else {
				M = false
			}
		}
		if (!M) {
			N.attr("readonly", "readonly")
		} else {
			N.attr("readonly", false)
		}
		if (G.attr("disabled") == "true" || G.attr("disabled") == true) {
			N.attr("disabled", true);
			N.addClass("inputDisabled")
		}
		if (G.attr("relText") == null) {
			N.val("请选择");
			G.attr("relText", "请选择")
		}
		return N
	}
	function h(L, K) {
		G.attr("relText", L);
		G.attr("relValue", K);
		w.val(L);
		if (o == "true" || o == true) {
			G.attr("editValue", w.val())
		}
		G.focus();
		return true
	}
	function g() {
		alert(111)
	}
	function z(L) {
		var K = G.html();
		if (G.attr("relText") != null) {
			w.val(G.attr("relText"))
		}
		return K
	}
	function b() {
		c.attr("hasfocus", 0);
		c.hide();
		$("body").unbind("mousedown", I);
		if (G.attr("treeType") == "dtree") {
			if (a == true) {
				var Q = "";
				var P = "";
				c.find("input[type=checkbox]").each(function() {
					if ($(this).attr("checked")) {
						Q = Q + $(this).next("span").text() + ",";
						P = P + $(this).attr("nodeIdData") + ","
					}
				});
				if (Q.length > 0) {
					Q = Q.substring(0, Q.length - 1)
				}
				if (P.length > 0) {
					P = P.substring(0, P.length - 1)
				}
				if (Q == "") {
					Q = "请选择"
				}
				h(Q, P);
				if (Q == "请选择") {
					w.attr("title", " ")
				} else {
					w.attr("title", Q)
				}
				try {
					enableTooltips()
				} catch(R) {}
			}
		} else {
			if (G.attr("treeType") == "ztree") {
				if (a == true) {
					var L = $.fn.zTree.getZTreeObj(G.find("ul").eq(0).attr("id"));
					var K = L.getCheckedNodes(true);
					var O = "";
					var N = "";
					for (var M = 0; M < K.length; M++) {
						O = O + K[M].name + ",";
						N = N + K[M].id + ","
					}
					if (O.length > 0) {
						O = O.substring(0, O.length - 1)
					}
					if (N.length > 0) {
						N = N.substring(0, N.length - 1)
					}
					if (O == "") {
						O = "请选择"
					}
					h(O, N);
					if (O == "请选择") {
						w.attr("title", " ")
					} else {
						w.attr("title", O)
					}
					try {
						enableTooltips()
					} catch(R) {}
				}
			}
		}
		try {
			G.trigger("close")
		} catch(R) {}
	}
	function q() {
		c.attr("hasfocus", 1);
		depth++;
		p.css({
			zIndex: depth
		});
		c.show();
		$("body").bind("mousedown", I)
	}
	function I(K) {
		if (c.attr("hasfocus") == 0) {} else {
			if (G.attr("treeType") == "dtree") {
				if ($(K.target).attr("id") == i || $(K.target).attr("id") == x || $(K.target).parent().parent().attr("class") == "dTreeNode" || $(K.target).parent().attr("class") == "dTreeNode" || $(K.target).attr("class") == "dTreeNode" || $(K.target).parent().attr("class") == "selectbox-tree" || $(K.target).attr("class") == "selectbox-tree") {
					setTimeout(function() {
						y()
					},
					500)
				} else {
					b()
				}
			} else {
				if (G.attr("treeType") == "ztree") {
					if ($(K.target).attr("id") == i || $(K.target).attr("id") == x || $(K.target).parent().attr("class") == "ztree" || $(K.target).attr("class") == "ztree" || $(K.target).parents(".ztree").length > 0 || $(K.target).attr("class") == "selectbox-tree") {
						setTimeout(function() {
							y()
						},
						500)
					} else {
						b()
					}
				} else {
					if ($(K.target).attr("id") == i || $(K.target).attr("id") == x || $(K.target).parents(".simpleTree").length > 0 || $(K.target).attr("class") == "selectbox-tree") {
						setTimeout(function() {
							y()
						},
						500)
					} else {
						b()
					}
				}
			}
		}
	}
	function e() {
		return G.val()
	}
	function J() {
		return w.val()
	}
};
function selTreeRefresh(a) {
	var b;
	if (typeof(a) == "object") {
		b = a
	} else {
		b = $("#" + a)
	}
	b.prev(".mainCon").remove();
	b.selectTreeBox()
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
function zTreeSelectItemClick(c, f, d) {
	var b = $("#" + f).parents(".mainCon").next(".selectTree");
	var a = $.fn.zTree.getZTreeObj(f);
	if (b.attr("multiMode") == "true" || b.attr("multiMode") == true) {
		if (d.clickExpand == true || d.clickExpand == "true") {
			a.expandNode(d)
		} else {
			a.checkNode(d)
		}
	} else {
		if (d.clickExpand == true || d.clickExpand == "true") {
			a.expandNode(d)
		} else {
			var i;
			i = $("#" + f).parents(".mainCon").find("input[class*=selectbox]");
			i.val(d.name);
			b.attr("relText", d.name);
			b.attr("relValue", d.id);
			if (b.attr("editable") == "true" || b.attr("editable") == true) {
				b.attr("editValue", i.val())
			}
			b.focus();
			var h = $("#" + f).parents(".mainCon").find("div[class=selectbox-tree]");
			h.hide();
			h.attr("hasfocus", 0);
			try {
				b.trigger("close")
			} catch(g) {}
		}
	}
}
function zTreeSelectItemSelection(c) {
	var b = $.fn.zTree.getZTreeObj(c.find("ul").eq(0).attr("id"));
	var a = b.transformToArray(b.getNodes());
	for (var d = 0; d < a.length; d++) {
		if (a[d].id == Number(c.attr("relValue"))) {
			b.selectNode(a[d])
		}
	}
}
function zTreeSelectAddItem(e, c, g, d) {
	var b = $.fn.zTree.getZTreeObj(e.find("ul").eq(0).attr("id"));
	var a = b.transformToArray(b.getNodes());
	for (var f = 0; f < a.length; f++) {
		if (a[f].id == c) {
			b.addNodes(a[f], {
				id: g,
				pId: a[f].id,
				name: d
			})
		}
	}
}
function zTreeSelectRemoveItem(c, e) {
	var b = $.fn.zTree.getZTreeObj(c.find("ul").eq(0).attr("id"));
	var a = b.transformToArray(b.getNodes());
	for (var d = 0; d < a.length; d++) {
		if (a[d].id == e) {
			b.removeNode(a[d])
		}
	}
};