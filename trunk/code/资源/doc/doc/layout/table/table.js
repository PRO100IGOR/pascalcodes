$(function() {
	$(".tableStyle").tableRenderer();
	$(".cusTreeTable").each(function() {
		$(this).find("tr").filter(":has(table)").hide();
		var b = false;
		var c;
		var a;
		if ($(this).attr("ajaxMode") == "true") {
			b = true
		}
			
		if ($(this).attr("trClick") == "true") {
			$(this).find("tr").eq(0).nextAll().not(":has(table)").each(function() {
				$(this).addClass("hand");
				$(this).hover(function() {
					$(this).addClass("highlight")
				},
				function() {
					$(this).removeClass("highlight")
				});
				$(this).click(function() {
					if ($(this).next().css("display") == "none") {
						if ($(this).parents("table").attr("ohterClose") != "false") {
							$(this).parents("table").find(".img_remove2").attr("title", "点击展开");
							$(this).parents("table").find(".img_remove2").addClass("img_add2");
							$(this).parents("table").find(".img_remove2").removeClass("img_remove2");
							$(this).next().nextAll().filter(":has(table)").hide();
							$(this).next().prevAll().filter(":has(table)").hide()
						}
						if (b == true) {
							a = $(this).find(".img_add2");
							a.each(function() {
								$(this).removeClass("img_add2");
								$(this).addClass("img_loading")
							});
							c = a.attr("url");
							window.setTimeout(function() {
								cusTreeTableLoadLater(a, c)
							},
							200)
						} else {
							$(this).next().show();
							$(this).find(".img_add2").each(function() {
								$(this).attr("title", "点击收缩");
								$(this).removeClass("img_add2");
								$(this).addClass("img_remove2")
							})
						}
					} else {
						$(this).next().hide();
						$(this).find(".img_remove2").each(function() {
							$(this).removeClass("img_remove2");
							$(this).addClass("img_add2");
							$(this).attr("title", "点击展开")
						})
					}
					try {
						hideTooltip();
						enableTooltips()
					} catch(d) {}
				})
			})
		} else {
			$(this).find(".img_add2").click(function() {
				
				c = $(this).attr("url");
				if ($(this).parents("tr").next().css("display") == "none") {
					if ($(this).parents("table").attr("ohterClose") != "false") {
						$(this).parents("table").find(".img_remove2").attr("title", "点击展开");
						$(this).parents("table").find(".img_remove2").addClass("img_add2");
						$(this).parents("table").find(".img_remove2").removeClass("img_remove2");
						$(this).parents("tr").next().nextAll().filter(":has(table)").hide();
						$(this).parents("tr").next().prevAll().filter(":has(table)").hide()
					}
					$(this).removeClass("img_add2");
					if (b == true) {
						$(this).addClass("img_loading");
						a = $(this);
						window.setTimeout(function() {
							cusTreeTableLoadLater(a, c)
						},
						200)
					} else {
						$(this).attr("title", "点击收缩");
						$(this).addClass("img_remove2");
						$(this).parents("tr").next().show()
					}
				} else {
					$(this).parents("tr").next().hide();
					$(this).removeClass("img_remove2");
					$(this).addClass("img_add2");
					$(this).attr("title", "点击展开")
				}
				try {
					hideTooltip();
					enableTooltips()
				} catch(d) {}
			})
		}
	})
});
function cusTreeTableLoadLater(b, a) {
	$.ajax({
		url: a,
		error: function() {
			try {
				top.Dialog.alert("数据加载失败，请检查dataPath是否正确")
			} catch(c) {
				alert("数据加载失败，请检查dataPath是否正确")
			}
		},
		success: function(d) {
			var c = b.parents("tr").next().find("table").parents("td");
			c.html("");
			var f = $(d);
			f.appendTo(c);
			tableRefresh(f);
			b.removeClass("img_loading");
			b.addClass("img_remove2");
			b.attr("title", "点击收缩");
			try {
				hideTooltip();
				enableTooltips()
			} catch(g) {}
			b.parents("tr").next().show()
		}
	})
} (function(a) {
	a.fn.tableRenderer = function() {
		return this.each(function() {
			a(this).find("th").addClass("th");
			if (a(this).find("tr").eq(1).find("td").eq(0).find('input[type="checkbox"]').length == 1) {
				if (a(this).attr("useCheckBox") != "false") {
					a(this).attr("useCheckBox", "true")
				}
				if (a(this).attr("useMultColor") != "false") {
					a(this).attr("useMultColor", "true")
				}
			}
			if (a(this).find("tr").eq(1).find("td").eq(0).find('input[type="radio"]').length == 1) {
				if (a(this).attr("useRadio") != "false") {
					a(this).attr("useRadio", "true")
				}
			}
			if (a(this).attr("formMode") == "true") {
				a(this).attr("useColor", "false");
				a(this).attr("useHover", "false");
				a(this).attr("useClick", "false");
				a(this).find("th").css({
					fontWeight: "bold",
					"text-align": "center"
				});
				a(this).find("tr").not("tr:last").find("td:even").css("text-align", "right");
				if (a(this).attr("footer") != null) {
					if (a(this).attr("footer") == "left") {
						a(this).find("tr:last").find("td").css("text-align", "left")
					} else {
						if (a(this).attr("footer") == "right") {
							a(this).find("tr:last").find("td").css("text-align", "right")
						} else {
							if (a(this).attr("footer") == "center") {
								a(this).find("tr:last").find("td").css("text-align", "center")
							} else {
								if (a(this).attr("footer") == "normal") {
									a(this).find("tr:last").find("td:even").css("text-align", "right")
								}
							}
						}
					}
				} else {
					a(this).find("tr:last").find("td").css("text-align", "center")
				}
				a(this).find("td").css({
					paddingTop: "3px",
					paddingBottom: "3px"
				})
			}
			if (a(this).attr("transMode") == "true") {
				a(this).attr("useColor", "false");
				a(this).attr("useHover", "false");
				a(this).attr("useClick", "false");
				a(this).find("th").css({
					fontWeight: "bold",
					"text-align": "center"
				});
				a(this).css({
					border: "none",
					backgroundColor: "transparent"
				});
				a(this).find("tr").css({
					border: "none",
					backgroundColor: "transparent"
				});
				a(this).find("tr").not("tr:last").find("td:even").css("text-align", "right");
				if (a(this).attr("footer") != null) {
					if (a(this).attr("footer") == "left") {
						a(this).find("tr:last").find("td").css("text-align", "left")
					} else {
						if (a(this).attr("footer") == "right") {
							a(this).find("tr:last").find("td").css("text-align", "right")
						} else {
							if (a(this).attr("footer") == "center") {
								a(this).find("tr:last").find("td").css("text-align", "center")
							} else {
								if (a(this).attr("footer") == "normal") {
									a(this).find("tr:last").find("td:even").css("text-align", "right")
								}
							}
						}
					}
				} else {
					a(this).find("tr:last").find("td").css("text-align", "center")
				}
				a(this).find("td").css({
					paddingTop: "3px",
					paddingBottom: "3px",
					border: "none"
				})
			}
			if (a(this).attr("useColor") != "false") {
				a(this).find("tr:even").addClass("odd")
			}
			if (a(this).attr("useHover") != "false") {
				a(this).find("tr").hover(function() {
					a(this).addClass("highlight")
				},
				function() {
					a(this).removeClass("highlight")
				})
			}
			if (a(this).attr("sortMode") == "true") {
				a(this).find("th").filter(":has(span)").hover(function() {
					a(this).removeClass("th");
					a(this).addClass("th_over")
				},
				function() {
					a(this).removeClass("th_over");
					a(this).addClass("th")
				});
				a(this).find("th span").addClass("sort_off");
				a(this).find("th").click(function() {})
			}
			if (a(this).attr("useClick") != "false") {
				a(this).attr("useClick", "true")
			}
			if (a(this).attr("useClick") == "true" && a(this).attr("useMultColor") == "true") {
				a(this).attr("useClick", "false")
			}
			if (a(this).attr("useRadio") != "true") {
				a(this).attr("useRadio", "false")
			}
			if (a(this).attr("useCheckBox") != "true") {
				a(this).attr("useCheckBox", "false")
			}
			if (a(this).attr("useClick") != "false") {
				if (a(this).attr("useRadio") == "false") {
					a(this).find("tr").click(function() {
						a(this).siblings().removeClass("selected");
						a(this).addClass("selected")
					})
				} else {
					a(this).find('input[type="radio"]:checked').parents("tr").addClass("selected");
					a(this).find("tr").click(function() {
						a(this).siblings().removeClass("selected");
						a(this).addClass("selected");
						a(this).find('input[type="radio"]').attr("checked", "checked")
					})
				}
			}
			if (a(this).attr("useMultColor") == "true") {
				if (a(this).attr("useCheckBox") == "false") {
					a(this).find("tr").click(function() {
						a(this).toggleClass("selected")
					})
				} else {
					a(this).find('input[type="checkbox"]:checked').parents("tr").addClass("selected");
					if (a(this).find("th").length > 0) {
						var b = a('<span class="img_checkAllOff" title="点击全选"></span>');
						a(this).find("th").eq(0).html("");
						a(this).find("th").eq(0).append(b);
						try {
							enableTooltips()
						} catch(c) {}
						if (a(this).attr("headFixMode") == "true") {
							b.toggle(function() {
								a("table:[class=tableStyle]").find("tr").each(function() {
									a(this).addClass("selected");
									a(this).find('input[type="checkbox"]').attr("checked", "checked")
								});
								a(this).removeClass("img_checkAllOff");
								a(this).addClass("img_checkAllOn");
								a(this).attr("title", "取消全选");
								try {
									hideTooltip();
									enableTooltips()
								} catch(d) {}
							},
							function() {
								a("table:[class=tableStyle]").find("tr").each(function() {
									if (a(this).hasClass("selected")) {
										a(this).removeClass("selected");
										a(this).find('input[type="checkbox"]').removeAttr("checked")
									}
								});
								a(this).removeClass("img_checkAllOn");
								a(this).addClass("img_checkAllOff");
								a(this).attr("title", "点击全选");
								try {
									hideTooltip();
									enableTooltips()
								} catch(d) {}
							})
						} else {
							b.toggle(function() {
								a(this).parents("table").find("tr").each(function() {
									a(this).addClass("selected");
									a(this).find('input[type="checkbox"]').attr("checked", "checked")
								});
								a(this).removeClass("img_checkAllOff");
								a(this).addClass("img_checkAllOn");
								a(this).attr("title", "取消全选");
								try {
									hideTooltip();
									enableTooltips()
								} catch(d) {}
							},
							function() {
								a(this).parents("table").find("tr").each(function() {
									if (a(this).hasClass("selected")) {
										a(this).removeClass("selected");
										a(this).find('input[type="checkbox"]').removeAttr("checked")
									}
								});
								a(this).removeClass("img_checkAllOn");
								a(this).addClass("img_checkAllOff");
								a(this).attr("title", "点击全选");
								try {
									hideTooltip();
									enableTooltips()
								} catch(d) {}
							})
						}
					}
					a(this).find("tr:has(td)").find('input[type="checkbox"]').unbind("click");
					a(this).find("tr:has(td)").find('input[type="checkbox"]').bind("click",
					function() {
						if (a(this).parents("tr").hasClass("selected")) {
							a(this).parents("tr").removeClass("selected")
						} else {
							a(this).parents("tr").addClass("selected")
						}
					})
				}
			}
		})
	}
})(jQuery);
function tableRefresh(b) {
	var a;
	if (typeof(b) == "object") {
		a = b
	} else {
		a = $("#" + b)
	}
	a.tableRenderer()
};