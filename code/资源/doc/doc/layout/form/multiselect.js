(function(a) {
	a.fn.extend({
		rgbmultiselect: function(b) {
			if (typeof b != "undefined") {
				if (typeof b.fieldTextFormatOnBlurIfLTENumToShow == "undefined" && typeof b.fieldTextFormatOnBlurNumToShow != "undefined" && b.fieldTextFormatOnBlurNumToShow > -1 && typeof b.fieldTextFormatOnBlur != "undefined") {
					b.fieldTextFormatOnBlurIfLTENumToShow = b.fieldTextFormatOnBlur
				}
				if (typeof b.helpText != "undefined" && typeof b.maxSelections != "undefined" && typeof b.helpTextMaxSelectionsReached == "undefined") {
					b.helpTextMaxSelectionsReached = b.helpText
				}
			}
			b = a.extend({},
			a.rgbmultiselector.defaults, b);
			return this.each(function() {
				var c = a.extend({},
				b);
				if (!a(this).attr("multiple")) {
					c.allOptionsExclusive = true
				}
				new a.rgbmultiselector(this, c)
			})
		},
		rgbms_reparse: function() {
			return this.trigger("rgbms_reparse")
		},
		rgbms_close: function() {
			return this.trigger("rgbms_close")
		},
		rgbms_change: function(b) {
			return this.bind("rgbms_change", b)
		},
		rgbms_toggle: function(c, b) {
			return this.trigger("rgbms_toggle", [c, b])
		},
		rgbms_enter: function(b) {
			return this.bind("rgbms_enter", b)
		},
		rgbms_preleave: function(b) {
			return this.bind("rgbms_preleave", b)
		},
		rgbms_postleave: function(b) {
			return this.bind("rgbms_postleave", b)
		}
	});
	a.rgbmultiselector = function(aP, ad) {
		var aQ = {
			UP: 38,
			DOWN: 40,
			DEL: 46,
			TAB: 9,
			RETURN: 13,
			ESC: 27,
			COMMA: 188,
			PAGEUP: 33,
			PAGEDOWN: 34,
			BACKSPACE: 8
		};
		var C;
		var w = a(aP);
		var e = w.attr("id");
		var M = e + "_rgbmultiselect";
		var aU = M + "_container";
		var an = M + "_iframe";
		var aC = aU + "_checkbox";
		var ax;
		if (w.attr("autoWidth") != null) {
			if (w.attr("autoWidth") == "true") {
				C = true
			} else {
				C = false
			}
		}
		if (C == true) {
			ax = parseInt(w.outerWidth(), 10)
		} else {
			ax = 120
		}
		if (ax == 0) {
			ax = 120
		}
		var aV = null;
		var E = false;
		var p = 0;
		var ay = false;
		var b = null;
		var aT = 0,
		u = null,
		ao = "";
		var ah = null,
		ac = null;
		var I = true;
		var D = null;
		var U = (new Date()).valueOf();
		var h = 0;
		var S = 0;
		var aF = 0;
		var Z = d();
		w.hide();
		var aD = Y();
		if (a("#scrollContent").length > 0) {
			a("#scrollContent").append(aD)
		} else {
			a(document.body).append(aD)
		}
		var v = H();
		var G = z();
		aO();
		w.bind("rgbms_reparse",
		function() {
			af()
		}).bind("rgbms_close",
		function() {
			aA()
		}).bind("rgbms_toggle",
		function(aX, aY, aW) {
			if (typeof G["_" + aY] != "undefined") {
				ab("_" + aY, null, aW)
			}
		});
		if (ad.buildOptionsInBackground) {
			a(document).ready(function() {
				setTimeout(function() {
					az()
				},
				10)
			})
		}
		if (a.browser.opera) {
			a(aP.form).bind("submit.rgbmultiselect",
			function() {
				if (E) {
					E = false;
					return false
				}
				return true
			})
		}
		Z.focus(function() {
			if (!ay) {
				w.trigger("rgbms_enter");
				ay = true
			}
			p++;
			if (aV) {
				clearTimeout(aV);
				aV = null
			}
			az();
			B();
			a(this).removeClass("jquery_rgbmultiselect_blurred");
			if (I) {
				I = false;
				a(this).val("")
			}
		});
		Z.click(function() {
			p++;
			if (p > 1 && !aD.is(":visible")) {
				B()
			}
		});
		Z.blur(function() {
			if (p > 0) {
				p = 0;
				aV = setTimeout(function() {
					aA()
				},
				200)
			}
		});
		Z.bind((a.browser.opera ? "keypress": "keydown") + ".rgbmultiselect",
		function(aW) {
			p = 1;
			switch (aW.keyCode) {
			case aQ.ESC:
				aJ();
				break;
			case aQ.RETURN:
				aW.preventDefault();
				E = true;
				R();
				return false;
			case aQ.TAB:
				if (ad.tabKeySelectsSingleFilteredUnselectedItem && aT == 1) {
					R()
				}
				p = 0;
				aA();
				break;
			case aQ.UP:
				if (!aD.is(":visible")) {
					B()
				} else {
					ag( - 1)
				}
				break;
			case aQ.DOWN:
				if (!aD.is(":visible")) {
					B()
				} else {
					ag(1)
				}
				break;
			case aQ.PAGEUP:
				if (!aD.is(":visible")) {
					B()
				} else {
					ag(ad.pageUpDownDistance * -1)
				}
				break;
			case aQ.PAGEDOWN:
				if (!aD.is(":visible")) {
					B()
				} else {
					ag(ad.pageUpDownDistance)
				}
				break;
			default:
				if (!aD.is(":visible")) {
					B()
				}
				if (b) {
					clearTimeout(b)
				}
				b = setTimeout(function() {
					k(a.trim(Z.val()));
					aH();
					am()
				},
				10);
				break
			}
		});
		a(window).bind("resize.rgbmultiselect",
		function() {
			am()
		});
		a(document).bind("mousedown.rgbmultiselect",
		function(aW) {
			if (aD.is(":visible") && l(aD, aW)) {
				setTimeout(function() {
					Z.focus()
				},
				10)
			}
		});
		if (ad.runTests) {
			x()
		}
		function af() {
			G = z();
			aD.removeClass("jquery_rgbmultiselect_optionsbuilt").html("");
			az();
			aO()
		}
		function L() {
			if (ah !== null) {
				a("#" + aC + "_" + ac + ah).parent().removeClass("jquery_rgbmultiselect_options_item_arrownav_selected");
				ah = ac = null
			}
			if (arguments.length == 2) {
				ah = arguments[0];
				ac = arguments[1]
			}
		}
		function ag(aX) {
			var aW = aw();
			if (ah === null || (ac != "clearlist" && G[ah].filtered)) {
				L(aW[0].id, aW[0].type)
			} else {
				var aY = m(aW) + aX;
				while (aY < 0) {
					aY += aW.length
				}
				if (aY >= aW.length) {
					aY = aY % aW.length
				}
				L(aW[aY].id, aW[aY].type)
			}
			var a0 = a("#" + aC + "_" + ac + ah);
			var aZ = a0.parent();
			aZ.addClass("jquery_rgbmultiselect_options_item_arrownav_selected");
			g(aZ, aW)
		}
		function m(aX) {
			var aZ = 0;
			var aW = aX.length;
			for (var aY = 0; aY < aW; aY++) {
				if (aX[aY].id == ah) {
					aZ = aY
				}
			}
			return aZ
		}
		function g(a0, aX) {
			var a1 = aN(aX);
			var aZ = 0;
			if (a1 != "") {
				aZ = a("#" + aC + "_unselected" + a1).parent().position().top
			}
			var aW = aD.children(".jquery_rgbmultiselect_options_unselected");
			var aY = a0.position().top - aZ - (aW.height() / 2);
			if (aY < 0 || ac != "unselected") {
				aY = 0
			}
			aW.scrollTop(aY)
		}
		function aN(aX) {
			var aW = aX.length;
			for (var aY = 0; aY < aW; aY++) {
				if (aX[aY].type == "unselected") {
					return aX[aY].id
				}
			}
			return ""
		}
		function A(aX) {
			var aZ = "";
			var aW = aX.length;
			for (var aY = 0; aY < aW; aY++) {
				if (aX[aY].type == "unselected") {
					aZ = aX[aY].id
				}
			}
			return aZ
		}
		function aw() {
			var aX = [];
			if (ad.clearAllSelectNoneAvailable) {
				aX.push({
					id: "",
					type: "clearlist"
				})
			}
			var aW = [];
			var a0 = [];
			var aY = [];
			for (var aZ in G) {
				if (typeof aZ == "string" && X(aZ, "hidden") && !G[aZ].filtered) {
					if (N(aZ, "sticky")) {
						aW.push({
							id: aZ,
							type: "sticky"
						})
					} else {
						if (ad.keepSelectedItemsInPlace || !G[aZ].selected) {
							aY.push({
								id: aZ,
								type: "unselected"
							})
						} else {
							if (G[aZ].selected) {
								a0.push({
									id: aZ,
									type: "selected"
								})
							}
						}
					}
				}
			}
			return aX.concat(aW, a0, aY)
		}
		function k(a1) {
			a1 += "";
			var aY = a1.split(/ +/);
			if (aT == 1) {
				u.parent().removeClass("jquery_rgbmultiselect_options_item_singlefiltered");
				var a3;
				try {
					a3 = j(u, ao);
					G[a3].filtered = false
				} catch(aZ) {}
			}
			aT = 0;
			for (var aX in G) {
				if (typeof aX == "string") {
					var a2 = "unselected";
					if (N(aX, "sticky")) {
						a2 = "sticky"
					}
					var a4 = a("#" + aC + "_" + a2 + aX);
					var a5 = a4.siblings("SPAN");
					var aW = a4.parent();
					if (X(aX, "hidden") && (!G[aX].selected || ad.keepSelectedItemsInPlace) && !aW.hasClass("jquery_rgbmultiselect_options_item_is_selected")) {
						var a0 = (a1 == "" || c(G[aX].text.toLowerCase(), aY));
						if (a0) {
							if (a1 == "") {
								aI(a5, aX)
							} else {
								a5.html(ai(G[aX].text, aY))
							}
							aT++;
							u = a4;
							ao = a2;
							aW.show()
						} else {
							aI(a5, aX);
							aW.removeClass("jquery_rgbmultiselect_options_item_singlefiltered").hide();
							if (ah == aX) {
								L()
							}
						}
						G[aX].filtered = !a0
					}
				}
			}
			if (aT == 1) {
				u.parent().addClass("jquery_rgbmultiselect_options_item_singlefiltered")
			}
		}
		function aI(aX, aW) {
			if (a.trim(aX.html()) != G[aW].text) {
				aX.html(G[aW].text)
			}
		}
		function c(aZ, aY) {
			var aW = aY.length;
			for (var aX = 0; aX < aW; aX++) {
				if (aZ.indexOf(aY[aX].toLowerCase()) == -1) {
					return false
				}
			}
			return true
		}
		function ai(aY, aZ) {
			var aW = aZ.length;
			if (aW == 0 || (aW == 1 && aZ[0] == "")) {
				return aY
			}
			for (var aX = 0; aX < aW; aX++) {
				aY = r(aY + "", aZ[aX] + "")
			}
			return aY
		}
		function r(a2, a6) {
			var a0 = a2.length;
			var a1 = a6.length;
			var aZ = 0;
			var a3;
			while (true) {
				a3 = a2.toLowerCase().indexOf(a6.toLowerCase(), aZ);
				if (a3 == -1) {
					break
				}
				var a4 = a2.substr(0, a3);
				var aY = a4 + '<span class="jquery_rgbmultiselect_options_text_filtermatch">';
				var aX = a2.substr(a3, a1);
				var aW = a2.substr(a3 + a1);
				var a5 = "</span>" + aW;
				if (((a4.lastIndexOf("<") < a4.lastIndexOf(">")) || (a4.lastIndexOf("<") == -1 && a4.lastIndexOf(">") == -1)) && ((aW.indexOf("<") < aW.indexOf(">")) || (aW.indexOf("<") == -1 && aW.indexOf(">") == -1))) {
					a2 = aY + aX + a5;
					aZ = aY.length + aX.length + "</span>".length
				} else {
					aZ = a3 + a1
				}
			}
			return a2
		}
		function aK() {
			var aX = u.siblings("SPAN");
			var aW = j(u, ao);
			if (P() >= ad.maxSelections && ad.maxSelections > -1 && !G[aW].selected && !Q(aW)) {
				return
			}
			aT = 0;
			u.parent().removeClass("jquery_rgbmultiselect_options_item_singlefiltered");
			aI(aX, aW);
			G[aW].filtered = false;
			ab(aW, ao, true);
			Z.focus().val("");
			k("");
			aH()
		}
		function R() {
			if (aT == 1) {
				aK()
			} else {
				if (ah !== null && (ac == "clearlist" || !G[ah].filtered)) {
					if (P() >= ad.maxSelections && ad.maxSelections > -1 && ac != "clearlist" && !G[ah].selected && !Q(ah)) {
						return
					}
					var aW = ah;
					var aX = ac;
					if (!ad.keepSelectedItemsInPlace) {
						if (aX == "clearlist" || Q(aW)) {
							L()
						} else {
							ag(1)
						}
					}
					ab(aW, aX, true);
					Z.focus()
				}
			}
		}
		function ab(aY, aX, aW) {
			if (typeof aW == "undefined" || aW == null) {
				aW = true
			}
			if (typeof aX == "undefined" || aX == null) {
				if (N(aY, "sticky")) {
					aX = "sticky"
				} else {
					aX = "unselected"
				}
			}
			if (aX == "clearlist") {
				K()
			} else {
				if (aX == "sticky") {
					if (G[aY].selected) {
						aG(aY)
					} else {
						o(aY)
					}
				} else {
					if (G[aY].selected) {
						W(aY, aW)
					} else {
						au(aY, aW)
					}
				}
			}
		}
		function ap(aX) {
			var aW = ad.helpText;
			if ((ad.maxSelections > -1 && aX >= ad.maxSelections) || (aX == 1 && ad.allOptionsExclusive)) {
				aW = ad.helpTextMaxSelectionsReached
			}
			return aW
		}
		function az() {
			if (aD.hasClass("jquery_rgbmultiselect_optionsbuilt")) {
				return
			}
			aD.addClass("jquery_rgbmultiselect_optionsbuilt");
			var a0 = P();
			var aZ = ap(a0);
			var aX = al("div").addClass("jquery_rgbmultiselect_options_helptext").text(aZ).appendTo(aD);
			if (ad.clearAllSelectNoneAvailable) {
				var aW = n();
				aW.appendTo(aD);
				if (a0 === 0) {
					aW.find(".jquery_rgbmultiselect_options_clearlist_checkbox").attr("checked", "checked").parent().addClass("jquery_rgbmultiselect_options_cleartext_selected")
				}
			}
			var aY = al("div").addClass("jquery_rgbmultiselect_options_sticky");
			q(aY).appendTo(aD);
			if (!ad.keepSelectedItemsInPlace) {
				var a2 = al("div").addClass("jquery_rgbmultiselect_options_selected");
				i(a2, "selected").appendTo(aD)
			}
			var a1 = al("div").addClass("jquery_rgbmultiselect_options_unselected");
			i(a1, "unselected").appendTo(aD);
			aD.hover(function() {},
			function() {
				a(this).find(".jquery_rgbmultiselect_options_item_hovered").removeClass("jquery_rgbmultiselect_options_item_hovered")
			});
			if (a.browser.msie) {
				aD.find(".jquery_rgbmultiselect_options_selected_item .jquery_rgbmultiselect_options_item_checkbox").attr("checked", "checked")
			}
		}
		function q(a0) {
			for (var aZ in G) {
				if (typeof aZ == "string" && N(aZ, "sticky")) {
					var aX = al("div").addClass("jquery_rgbmultiselect_options_item").addClass("jquery_rgbmultiselect_options_sticky_item");
					if (N(aZ, "headernocb")) {
						aX.addClass("jquery_rgbmultiselect_options_headernocb")
					}
					if (N(aZ, "child")) {
						aX.addClass("jquery_rgbmultiselect_options_child_sticky")
					}
					var aY = al("input").addClass("jquery_rgbmultiselect_options_sticky_checkbox").attr({
						type: "checkbox",
						id: aC + "_sticky" + aZ,
						name: aC + "_sticky" + aZ
					});
					aY.click(function() {
						Z.focus()
					}).appendTo(aX);
					if (N(aZ, "headernocb")) {
						aY.hide()
					}
					var aW = al("span").text(G[aZ].text);
					aW.appendTo(aX);
					aX.appendTo(a0);
					aX.click(function(a3) {
						var a2 = a(this).find(".jquery_rgbmultiselect_options_sticky_checkbox");
						var a1 = j(a2, "sticky");
						if (G[a1].selected) {
							aG(a1)
						} else {
							o(a1)
						}
						Z.focus()
					});
					if (X(aZ, "headernocb")) {
						aM(aX)
					}
					if (G[aZ].selected) {
						aX.addClass("jquery_rgbmultiselect_options_selected_item");
						aY.attr("checked", "checked")
					}
				}
			}
			return a0
		}
		function n() {
			var aW = al("div").addClass("jquery_rgbmultiselect_options_cleartext");
			var aX = al("div").addClass("jquery_rgbmultiselect_options_item").addClass("jquery_rgbmultiselect_options_cleartext_item");
			var aY = al("input").addClass("jquery_rgbmultiselect_options_clearlist_checkbox").attr({
				type: "checkbox",
				id: aC + "_clearlist",
				name: aC + "_clearlist"
			});
			aY.click(function() {
				Z.focus()
			}).appendTo(aX);
			var aZ = al("span").text(ad.clearAllSelectNoneText).appendTo(aX);
			aX.appendTo(aW);
			aW.click(function(a0) {
				K();
				Z.focus()
			});
			aM(aX);
			return aW
		}
		function K() {
			y();
			aH();
			a("#" + aC + "_clearlist").attr("checked", "checked").parent().addClass("jquery_rgbmultiselect_options_cleartext_selected")
		}
		function aR(aX, aW) {
			if (ad.keepSelectedItemsInPlace) {
				return true
			}
			return (G[aX].selected && aW == "selected") || (!G[aX].selected && aW == "unselected")
		}
		function av(aX, aY) {
			var aZ = aC + "_" + aX + aY;
			var aW = al("input").attr({
				type: "checkbox",
				id: aZ,
				name: aZ
			}).addClass("jquery_rgbmultiselect_options_item_checkbox").addClass("jquery_rgbmultiselect_options_" + aX + "_item_checkbox");
			if (aX == "selected" || (ad.keepSelectedItemsInPlace && G[aY].selected)) {
				aW.attr("checked", "checked")
			}
			aW.click(function(a0) {
				Z.focus()
			});
			return aW
		}
		function i(aY, a0) {
			for (var a2 in G) {
				if (typeof a2 == "string" && X(a2, "hidden") && X(a2, "sticky")) {
					var a1 = al("div").addClass("jquery_rgbmultiselect_options_item").addClass("jquery_rgbmultiselect_options_" + a0 + "_item").attr("id", aU + "_item" + a2);
					if (N(a2, "headernocb")) {
						a1.addClass("jquery_rgbmultiselect_options_headernocb")
					}
					if (N(a2, "child")) {
						a1.addClass("jquery_rgbmultiselect_options_child_" + a0)
					}
					var aZ = aR(a2, a0);
					if (!aZ && a0 == "unselected" && !ad.keepSelectedItemsInPlace) {
						a1.addClass("jquery_rgbmultiselect_options_item_is_selected")
					}
					if (ad.keepSelectedItemsInPlace && G[a2].selected) {
						a1.addClass("jquery_rgbmultiselect_options_selected_item")
					}
					a1.css("display", (aZ ? "block": "none"));
					var aW = av(a0, a2);
					aW.appendTo(a1);
					if (N(a2, "headernocb")) {
						aW.hide()
					}
					var aX = al("span").text(G[a2].text).appendTo(a1);
					a1.click(function(a5) {
						var a4 = a(this).find(".jquery_rgbmultiselect_options_item_checkbox");
						var a3 = j(a4, a0);
						if (G[a3].selected) {
							W(a3, true)
						} else {
							au(a3, true)
						}
						Z.focus()
					});
					if (X(a2, "headernocb")) {
						aM(a1)
					}
					a1.appendTo(aY)
				}
			}
			return aY
		}
		function j(aX, aW) {
			return aX.attr("id").substr((aC + "_" + aW).length)
		}
		function aM(aW) {
			aW.hover(function() {
				a(this).addClass("jquery_rgbmultiselect_options_item_hovered")
			},
			function() {
				a(this).removeClass("jquery_rgbmultiselect_options_item_hovered")
			})
		}
		function au(aX, aW) {
			if (N(aX, "headernocb")) {
				return
			}
			if (P() >= ad.maxSelections && ad.maxSelections > -1) {
				a("#" + aC + "_unselected" + aX).removeAttr("checked");
				return
			}
			ae(aX);
			var aZ = a("#" + aC + "_selected" + aX);
			var aY = a("#" + aC + "_unselected" + aX);
			if (ad.keepSelectedItemsInPlace) {
				aY.attr("checked", "checked");
				aY.parent().addClass("jquery_rgbmultiselect_options_selected_item")
			} else {
				aZ.attr("checked", "checked").parent().show();
				aY.removeAttr("checked");
				aY.parent().addClass("jquery_rgbmultiselect_options_item_is_selected").hide()
			}
			ar(aX, aW);
			aH()
		}
		function W(aX, aW) {
			if (N(aX, "headernocb")) {
				return
			}
			w.find("OPTION[value='" + aX.substr(1) + "']").removeAttr("selected");
			var aZ = a("#" + aC + "_selected" + aX);
			var aY = a("#" + aC + "_unselected" + aX);
			if (ad.keepSelectedItemsInPlace) {
				aY.removeAttr("checked");
				aY.parent().removeClass("jquery_rgbmultiselect_options_selected_item")
			} else {
				aZ.attr("checked", "checked").parent().hide();
				aY.removeAttr("checked");
				aY.parent().removeClass("jquery_rgbmultiselect_options_item_is_selected").show()
			}
			V(aX, aW);
			aH()
		}
		function o(aX) {
			if (N(aX, "headernocb")) {
				return
			}
			if (P() >= ad.maxSelections && ad.maxSelections > -1) {
				a("#" + aC + "_sticky" + aX).removeAttr("checked");
				return
			}
			ae(aX);
			var aW = a("#" + aC + "_sticky" + aX);
			aW.attr("checked", "checked").parent().addClass("jquery_rgbmultiselect_options_selected_item");
			var aY = aW.siblings("SPAN");
			aI(aY, aX);
			ar(aX)
		}
		function aG(aW) {
			if (N(aW, "headernocb")) {
				return
			}
			a("#" + aC + "_sticky" + aW).removeAttr("checked").parent().removeClass("jquery_rgbmultiselect_options_selected_item");
			V(aW)
		}
		function ae(aW) {
			if (Q(aW)) {
				y()
			} else {
				F()
			}
		}
		function ar(aY, aX) {
			G[aY].selected = true;
			w.find("OPTION[value='" + aY.substr(1) + "']").attr("selected", "selected");
			if (aX) {
				if (N(aY, "headercb") && ad.selectingHeaderSelectsChildren && !f(aY)) {
					var aW = G[aY].nextItem;
					while (aW != null && N(aW, "child")) {
						if (N(aW, "sticky")) {
							o(aW)
						} else {
							au(aW, false)
						}
						aW = G[aW].nextItem
					}
				}
				if (N(aY, "child") && N(G[aY].parent, "headercb") && ad.selectingHeaderSelectsChildren && f(G[aY].parent)) {
					if (N(G[aY].parent, "sticky")) {
						o(G[aY].parent)
					} else {
						au(G[aY].parent, false)
					}
				}
			}
			if (ad.clearAllSelectNoneAvailable) {
				a("#" + aC + "_clearlist").removeAttr("checked").parent().removeClass("jquery_rgbmultiselect_options_cleartext_selected")
			}
			am();
			aD.children(".jquery_rgbmultiselect_options_helptext").text(ap(P()));
			w.trigger("rgbms_change", [G[aY]])
		}
		function V(aY, aX) {
			G[aY].selected = false;
			w.find("OPTION[value='" + aY.substr(1) + "']").removeAttr("selected");
			if (aX) {
				if (N(aY, "headercb") && ad.selectingHeaderSelectsChildren && f(aY)) {
					var aW = G[aY].nextItem;
					while (aW != null && N(aW, "child")) {
						if (N(aW, "sticky")) {
							aG(aW)
						} else {
							W(aW, false)
						}
						aW = G[aW].nextItem
					}
				}
				if (N(aY, "child") && N(G[aY].parent, "headercb") && ad.selectingHeaderSelectsChildren) {
					if (N(aY, "sticky")) {
						aG(G[aY].parent)
					} else {
						W(G[aY].parent, false)
					}
				}
			}
			if (ad.clearAllSelectNoneAvailable && P() === 0) {
				a("#" + aC + "_clearlist").attr("checked", "checked").parent().addClass("jquery_rgbmultiselect_options_cleartext_selected")
			}
			am();
			aD.children(".jquery_rgbmultiselect_options_helptext").text(ap(P()));
			w.trigger("rgbms_change", [G[aY]])
		}
		function f(aW) {
			return aE(aW, false)
		}
		function aB(aW) {
			return aE(aW, true)
		}
		function aE(aZ, aX) {
			var aY = G[aZ];
			var aW = G[aZ].nextItem;
			while (aW != null && N(aW, "child")) {
				if (G[aW].selected == aX) {
					return false
				}
				aW = G[aW].nextItem
			}
			return true
		}
		function y() {
			for (var aW in G) {
				if (typeof aW == "string") {
					if (X(aW, "hidden") && G[aW].selected) {
						if (N(aW, "sticky")) {
							aG(aW)
						} else {
							W(aW, true)
						}
					}
				}
			}
		}
		function F() {
			for (var aW in G) {
				if (typeof aW == "string") {
					if (X(aW, "hidden") && N(aW, "exclusive") && G[aW].selected) {
						if (N(aW, "sticky")) {
							aG(aW)
						} else {
							W(aW, true)
						}
					}
				}
			}
		}
		function B() {
			am();
			if (!aD.is(":visible")) {
				aD.css({
					width: parseInt(Z.width(), 10) + "px"
				}).show()
			}
			if (D === null) {
				D = aD.children(".jquery_rgbmultiselect_options_unselected").height()
			}
			aH();
			am()
		}
		function aH() {
			if (!aD.is(":visible")) {
				return
			}
			var aX = aD.children(".jquery_rgbmultiselect_options_unselected");
			var aW = aq();
			if (aW >= D) {
				aX.css("height", "")
			} else {
				aX.css("height", (aW + 2) + "px")
			}
			ak(true)
		}
		function aq() {
			var aX = aw();
			var a0 = aN(aX);
			var aY = A(aX);
			if (aX.length === 0 || a0 === "" || aY === "") {
				return 0
			}
			var aZ = a("#" + aC + "_unselected" + a0).parent();
			var aW = a("#" + aC + "_unselected" + aY).parent();
			return aW.position().top + aW.height() - aZ.position().top
		}
		function aJ() {
			ak(false);
			aD.hide()
		}
		function aA() {
			w.trigger("rgbms_preleave");
			aJ();
			I = true;
			L();
			aO();
			ay = false;
			w.trigger("rgbms_postleave");
			a(w.attr("onchange"));
			w.focus()
		}
		function Y() {
			var aW = a("#" + aU);
			if (aW.size() == 0) {
				var aX = al("div");
				aX.hide().addClass("jquery_rgbmultiselect_options_container").attr("id", aU);
				return aX
			} else {
				return aW
			}
		}
		function am() {
			if (!aD.is(":visible")) {
				return
			}
			offset = Z.offset();
			var aZ;
			if (a("#scrollContent").length > 0) {
				aZ = parseInt(offset.top + a("#scrollContent").scrollTop(), 10)
			} else {
				aZ = parseInt(offset.top, 10)
			}
			var aY = parseInt(offset.left, 10);
			var aX = aZ + Z.outerHeight();
			var aW = aY;
			aD.css({
				top: aX + "px",
				left: aW + "px"
			});
			ak(true)
		}
		function aO() {
			Z.val("").removeClass("jquery_rgbmultiselect_blurred");
			k("");
			var aX = J();
			if (aX[0] != "") {
				Z.addClass(aX[0])
			}
			Z.val(aX[1]);
			try {
				var aW = "";
				if (aX[1] != "点击进行多选") {
					aW = aX[1]
				} else {
					aW = "点击进行多选"
				}
				Z.attr("title", aW);
				enableTooltips()
			} catch(aY) {}
		}
		function J() {
			var aY = new Array(2);
			aY[0] = "";
			var a0 = "";
			var a2 = 0;
			var aW = 0;
			var aZ = 0;
			for (var a1 in G) {
				if (typeof a1 == "string") {
					if (G[a1].selected) {
						a2++;
						if (ad.fieldTextFormatOnBlurNumToShow == -1 || (ad.fieldTextFormatOnBlurNumToShow > 0 && ad.fieldTextFormatOnBlurNumToShow > aZ)) {
							a0 += G[a1].text + ", ";
							aZ++
						}
					}
				}
			}
			a0 = a0.substr(0, a0.length - 2);
			if (ad.fieldTextFormatOnBlurNumToShow > -1) {
				aW = a2 - ad.fieldTextFormatOnBlurNumToShow
			}
			if (a2 == 0) {
				if (ad.clearAllSelectNoneAvailable && ad.clearAllSelectNoneTextShowOnBlur && aD.hasClass("jquery_rgbmultiselect_optionsbuilt")) {
					aY[1] = ad.clearAllSelectNoneText
				} else {
					aY[0] = "jquery_rgbmultiselect_blurred";
					aY[1] = ad.inputDefaultText
				}
			} else {
				var aX = ad.fieldTextFormatOnBlur + "";
				if (ad.fieldTextFormatOnBlurNumToShow > -1 && aW <= 0) {
					aX = ad.fieldTextFormatOnBlurIfLTENumToShow + ""
				}
				aX = aX.replace(/%o/, a0);
				aX = aX.replace(/%c/, a2);
				aX = aX.replace(/%a/, aW);
				aY[1] = aX
			}
			return aY
		}
		function aS() {
			for (var aW in G) {
				if (typeof aW == "string" && N(aW, "sticky")) {
					return true
				}
			}
			return false
		}
		function aa() {
			for (var aW in G) {
				if (typeof aW == "string" && X(aW, "sticky") && G[aW].selected) {
					return true
				}
			}
			return false
		}
		function P() {
			var aX = 0;
			for (var aW in G) {
				if (typeof aW == "string") {
					if (G[aW].selected) {
						aX++
					}
				}
			}
			return aX
		}
		function z() {
			var aX = {};
			var aW = null;
			var aY = null;
			w.find("OPTION").each(function() {
				var a2 = a(this).val();
				var a1 = a(this).attr(ad.optionPropertiesField);
				var a3 = a(this).text();
				var a0 = a(this).is(":selected");
				var aZ = null;
				if (typeof a1 == "string") {
					if (a1.indexOf("child") > -1) {
						aZ = aW
					} else {
						if (a1.indexOf("headercb") > -1 || a1.indexOf("headernocb") > -1) {
							aW = "_" + a2
						} else {
							aW = null
						}
					}
				}
				aX["_" + a2] = {
					nextItem: null,
					prevItem: aY,
					parent: aZ,
					props: a1,
					text: a3,
					selected: a0,
					filtered: false,
					obj: a(this),
					val: a2
				};
				if (aY !== null) {
					aX[aY].nextItem = "_" + a2
				}
				aY = "_" + a2
			});
			return aX
		}
		function d() {
			var aX = a("#" + M);
			var aW;
			if (aX.size() == 1) {
				aW = aX
			} else {
				aW = al("input");
				aW.attr({
					type: "text",
					id: M,
					name: M
				}).css({
					width: ax + "px"
				});
				w.after(aW)
			}
			aW.addClass("jquery_rgbmultiselect_input").attr("autocomplete", "off").val(ad.inputDefaultText);
			return aW
		}
		function ak(a1) {
			if (a.browser.msie && a.browser.version == 6 && v && aD.is(":visible")) {
				if (a1) {
					var aX = aD.outerWidth();
					var aZ = aD.outerHeight();
					var a0 = aD.offset();
					var aY = a0.top;
					var aW = a0.left;
					v.css({
						display: "block",
						top: aY,
						left: aW,
						height: aZ,
						width: aX
					})
				} else {
					v.css({
						display: "none"
					})
				}
			}
		}
		function H() {
			return null
		}
		function Q(aW) {
			return N(aW, "exclusive") || ad.allOptionsExclusive
		}
		function N(aX, aW) {
			return G[aX].props && G[aX].props.indexOf(aW) > -1
		}
		function X(aX, aW) {
			return ! G[aX].props || G[aX].props.indexOf(aW) == -1
		}
		function t(aX) {
			if (window.console && window.console.log) {
				window.console.log(aX)
			} else {
				if (a("#console").size() === 0) {
					a(document.body).append('<div style="margin:20px;border:1px solid black;width:400px;height:400px;overflow:auto" id="console"></div>')
				}
				var aW = (new Date()).valueOf();
				a("#console").html(a("#console").html() + (aW - U) + "ms: " + aX + "<br>");
				U = aW
			}
		}
		function al(aW) {
			return a(document.createElement(aW))
		}
		function O(aY, aW, aX) {
			return (aY >= aW && aY <= aX)
		}
		function l(a1, aX) {
			a1 = a(a1);
			var aZ = aX.pageX;
			var aY = aX.pageY;
			var a2 = a1.offset();
			var a3 = a2.top;
			var a0 = a2.left;
			var aW = a3 + a1.outerHeight();
			var a4 = a0 + a1.outerWidth();
			return O(aZ, a0, a4) && O(aY, a3, aW)
		}
		function x() {
			aj(O(1, 2, 3), "1 is not between 2 and 3");
			aL(O(2, 1, 3), "2 is between 1 and 3");
			aL(l(a("#picknumbers"), {
				pageX: 15,
				pageY: 15
			}), "mouse is over input box");
			aj(l(a("#picknumbers"), {
				pageX: 150,
				pageY: 150
			}), "mouse is not over input box");
			var aX = J();
			s("Start typing to search", aX[1], "default field value is 'Start typing to search'");
			a("#picknumbers OPTION").slice(1, 3).attr("selected", "selected");
			af();
			aX = J();
			s("2: Zero, One", aX[1], "new field value is '2: Zero, One'");
			a("#picknumbers OPTION").slice(1, 6).attr("selected", "selected");
			af();
			aX = J();
			s("5: Zero, One, Two + 2 more", aX[1], "new field value is '5: Zero, One, Two + 2 more'");
			aj(Q("_0"), "option 0 is not exclusive");
			aL(Q("_10"), "option 10 is exclusive");
			aL(N("_0", "sticky"), "option 0 is sticky (objTypeIs)");
			aj(X("_0", "sticky"), "option 0 is sticky (objTypeNot)");
			aj(N("_1", "sticky"), "option 1 is not sticky (objTypeIs)");
			aL(X("_1", "sticky"), "option 1 is not sticky (objTypeNot)");
			s(1, a("#picknumbers_rgbmultiselect").size(), "input field exists");
			s("off", a("#picknumbers_rgbmultiselect").attr("autocomplete"), "input field has autocomplete turned off");
			var aY = z();
			aj(aY._0.filtered, "0 is not filtered");
			aL(aY._0.selected, "0 is selected");
			s("sticky", aY._0.props, "0 has sticky as a property");
			s(null, aY._selectafew.prevItem, "first element has no previous element");
			s("_0", aY._selectafew.nextItem, "first element has _0 as next element");
			s("_selectafew", aY._0.prevItem, "second element has _selectafew as previous element");
			s("_1", aY._0.nextItem, "second element has _1 as next element");
			s("_9", aY._10.prevItem, "last element has _9 as previous element");
			s(null, aY._10.nextItem, "last element has no as next element");
			s("_fivesixseven", aY._5.parent, "_5 has fivesixseven as a parent");
			s(null, aY._4.parent, "_4 has no parent");
			s(5, P(), "5 options are selected");
			aL(aS(), "at least one option is sticky");
			aL(aa(), "nonsticky options are selected");
			s("_0", j(a("#picknumbers_rgbmultiselect_container_checkbox_sticky_0"), "sticky"), "_0 is the item id");
			s("_1", j(a("#picknumbers_rgbmultiselect_container_checkbox_unselected_1"), "unselected"), "_1 is the item id");
			aL(aR("_0", "sticky"), "_0 is displayed when keepSelectedItemsInPlace is on");
			aL(aR("_8", "unselected"), "_8 is displayed when keepSelectedItemsInPlace is on");
			s("Select options", ap(0), "help text is Select options");
			aj(f("_fivesixseven"), "all children of _fivesixseven are not selected");
			aL(aB("_fivesixseven"), "all children of _fivesixseven are unselected");
			au("_fivesixseven", true);
			aL(f("_fivesixseven"), "all children of _fivesixseven are now selected");
			aj(aB("_fivesixseven"), "all children of _fivesixseven are now not unselected");
			W("_5", true);
			aj(f("_fivesixseven"), "all children of _fivesixseven are now not selected");
			aj(aB("_fivesixseven"), "all children of _fivesixseven are now not unselected");
			W("_6", true);
			W("_7", true);
			af();
			s("abc", r("abc", "d"), "test replace without match");
			s('a<span class="jquery_rgbmultiselect_options_text_filtermatch">b</span>c', r("abc", "b"), "test replace with one match");
			s('a<span class="jquery_rgbmultiselect_options_text_filtermatch">b</span>a<span class="jquery_rgbmultiselect_options_text_filtermatch">b</span>c', r("ababc", "b"), "test replace with two matches");
			s('a<span class="jquery_rgbmultiselect_options_text_filtermatch">match</span>c', r("amatchc", "match"), "test replace with complicated match");
			s('a<span class="jquery_rgbmultiselect_options_text_filtermatch">b</span>a<span class="jquery_rgbmultiselect_options_text_filtermatch">d</span>c', ai("abadc", ["b", "d"]), "test replace with two matches");
			aL(c("woot", ["woot"]), "single term successful 'and' match");
			aL(c("woot ness hoo ray", ["ness", "ray"]), "successful 'and' match");
			aj(c("woot ness hoo ray", ["ness", "ray", "ski"]), "failed 'and' match");
			var aW = aw();
			s(12, aW.length, "visible options length is 12");
			s("_1", aN(aW), "first unselected is _1");
			s("_10", A(aW), "last unselected is _10");
			at()
		}
		function T(aW, aX) {
			var aY = "";
			h++;
			if (aW) {
				S++;
				aY = "green"
			} else {
				aF++;
				aY = "red";
				a("#testsuiteresults").append('<span style="color:' + aY + '">' + new Date().toLocaleString() + ": " + aX + "</span><br/>")
			}
		}
		function at() {
			var aW = "gray";
			if (aF > 0) {
				aW = "red";
				a("#testsuiteresults").append("<br/>")
			}
			a("#testsuiteresults").append('<span style="color:' + aW + '">' + new Date().toLocaleString() + ": " + h + " tests were run, " + S + " tests passed, " + aF + " tests failed.</span>")
		}
		function s(aX, aY, aW) {
			T(aX == aY, aW)
		}
		function aL(aX, aW) {
			T(aX, aW)
		}
		function aj(aX, aW) {
			T(!aX, aW)
		}
	};
	a.rgbmultiselector.defaults = {
		runTests: false,
		helpText: "选择项目",
		helpTextMaxSelectionsReached: "达到选择的最大项",
		inputDefaultText: "点击进行多选",
		maxSelections: -1,
		clearAllSelectNoneAvailable: false,
		clearAllSelectNoneText: "",
		clearAllSelectNoneTextShowOnBlur: false,
		allOptionsExclusive: false,
		buildOptionsInBackground: true,
		pageUpDownDistance: 10,
		fieldTextFormatOnBlur: "%o",
		fieldTextFormatOnBlurNumToShow: -1,
		fieldTextFormatOnBlurIfLTENumToShow: "%o",
		optionPropertiesField: "rel",
		tabKeySelectsSingleFilteredUnselectedItem: false,
		keepSelectedItemsInPlace: false,
		selectingHeaderSelectsChildren: false
	}
})(jQuery);
$(function() {
	$("select[multiple]").each(function() {
		if ($(this).attr("class") == "" && $(this).attr("maxSelection")) {
			$(this).rgbmultiselect({
				maxSelections: $(this).attr("maxSelection")
			})
		} else {
			if ($(this).attr("class") == "") {
				$(this).rgbmultiselect()
			}
		}
	});
	$("select[multiple]").filter("[class*=validate]").each(function() {
		if ($(this).attr("maxSelection")) {
			$(this).rgbmultiselect({
				maxSelections: $(this).attr("maxSelection")
			})
		} else {
			$(this).rgbmultiselect()
		}
	})
});
function multiSelRefresh(b) {
	var c;
	if (typeof(b) == "object") {
		var a = c.attr("id");
		c = b;
		$("#" + a + "_rgbmultiselect").remove();
		$("#" + a + "_rgbmultiselect_container").remove();
		c.rgbmultiselect()
	} else {
		c = $("#" + b);
		$("#" + b + "_rgbmultiselect").remove();
		$("#" + b + "_rgbmultiselect_container").remove();
		c.rgbmultiselect()
	}
};