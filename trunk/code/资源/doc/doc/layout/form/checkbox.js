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
	$(".render input:checkbox[class='']").custCheckBox();
	$(".render input:radio[class='']").custCheckBox()
}); (function(a) {
	a.fn.custCheckBox = function(b) {
		var d = {
			disable_all: false,
			hover: true,
			wrapperclass: "group",
			callback: function() {}
		};
		var c = a.extend(d, b);
		return this.each(function() {
			var e = a(this);
			a.fn.buildbox = function(f) {
				if (broswerFlag == "IE6" || broswerFlag == "IE7" || broswerFlag == "IE8" || broswerFlag == "IE9") {
					a(f).css({
						display: "none"
					}).before('<span class="cust_checkbox">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>')
				} else {
					a(f).css({
						display: "none"
					}).before('<span class="cust_checkbox">&nbsp;&nbsp;&nbsp;</span>')
				}
				var i = a(f).attr("checked");
				var g = a(f).attr("type");
				var h = a(f).attr("disabled");
				if (g === "checkbox") {
					a(f).prev("span").addClass("checkbox");
					if (h || c.disable_all) {
						g = "checkbox_disabled"
					}
				} else {
					a(f).prev("span").addClass("radio");
					if (h || c.disable_all) {
						g = "radio_disabled"
					}
				}
				if (i) {
					a(f).prev("span").addClass("cust_" + g + "_on")
				} else {
					a(f).prev("span").addClass("cust_" + g + "_off")
				}
				if (c.disable_all) {
					a(f).attr("disabled", "disabled")
				}
				a(f).prev("span").prev("label").css({
					cursor: "pointer"
				});
				a(f).prev("span").prev("label").unbind().click(function() {
					if (a(f).attr("onclick") != null) {
						a(a(f).attr("onclick"))
					}
					if (!c.disable_all) {
						var l = a(this).next("span");
						var j = a(l).next("input").attr("type");
						var k = a(l).next("input").attr("disabled");
						if (a(l).hasClass("checkbox")) {
							if (a(l).hasClass("cust_" + j + "_off") && !k) {
								if (broswerFlag == "IE6" || broswerFlag == "IE7" || broswerFlag == "IE8" || broswerFlag == "IE9") {
									a(l).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").attr("checked", "checked")
								} else {
									a(l).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").removeAttr("checked")
								}
							} else {
								if (!k) {
									if (broswerFlag == "IE6" || broswerFlag == "IE7" || broswerFlag == "IE8" || broswerFlag == "IE9") {
										a(l).removeClass("cust_" + j + "_on").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_off").next("input").removeAttr("checked")
									} else {
										a(l).removeClass("cust_" + j + "_on").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_off").next("input").attr("checked", "checked")
									}
									a(l).removeClass("cust_" + j + "_hvr")
								}
							}
						} else {
							if (!k) {
								a(l).parent().find(".cust_checkbox").removeClass("cust_" + j + "_on").addClass("cust_" + j + "_off").next("input").removeAttr("checked");
								a(l).removeClass("cust_" + j + "_off").addClass("cust_" + j + "_on").next("input").attr("checked", "checked");
								a(l).removeClass("cust_" + j + "_hvr")
							}
						}
						c.callback.call(this)
					}
				}).hover(function() {
					var j = a(this).next("span");
					if (a(j).hasClass("cust_checkbox_off") && c.hover) {
						a(j).addClass("cust_checkbox_hvr")
					} else {
						if (a(j).hasClass("cust_radio_off") && c.hover) {
							a(j).addClass("cust_radio_hvr")
						}
					}
				},
				function() {
					var j = a(this).next("span");
					if (a(j).hasClass("cust_checkbox_off") && c.hover) {
						a(j).removeClass("cust_checkbox_hvr")
					} else {
						if (a(j).hasClass("cust_radio_off") && c.hover) {
							a(j).removeClass("cust_radio_hvr")
						}
					}
				});
				a(f).prev("span").unbind().click(function() {
					if (a(f).attr("onclick") != null) {
						a(a(f).attr("onclick"))
					}
					if (!c.disable_all) {
						var j = a(this).next("input").attr("type");
						var k = a(this).next("input").attr("disabled");
						if (a(this).hasClass("checkbox")) {
							if (a(this).hasClass("cust_" + j + "_off") && !k) {
								a(this).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").attr("checked", "checked")
							} else {
								if (!k) {
									a(this).removeClass("cust_" + j + "_on").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_off").next("input").removeAttr("checked");
									a(this).removeClass("cust_" + j + "_hvr")
								}
							}
						} else {
							if (!k) {
								a(this).parent().find(".cust_checkbox").removeClass("cust_" + j + "_on").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_off").next("input").removeAttr("checked");
								a(this).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").attr("checked", "checked")
							}
						}
						c.callback.call(this)
					}
				}).hover(function() {
					if (a(this).hasClass("cust_checkbox_off") && c.hover) {
						a(this).addClass("cust_checkbox_hvr")
					} else {
						if (a(this).hasClass("cust_radio_off") && c.hover) {
							a(this).addClass("cust_radio_hvr")
						}
					}
				},
				function() {
					if (a(this).hasClass("cust_checkbox_off") && c.hover) {
						a(this).removeClass("cust_checkbox_hvr")
					} else {
						if (a(this).hasClass("cust_radio_off") && c.hover) {
							a(this).removeClass("cust_radio_hvr")
						}
					}
				})
			};
			a.fn.buildbox(a(e))
		})
	}
})(jQuery);
function radioRefresh(a) {
	var b;
	if (typeof(a) == "object") {
		b = a
	} else {
		b = $("#" + a)
	}
	b.find("span").remove();
	b.find("input:radio[class='']").custCheckBox()
}
function checkRefresh(a) {
	var b;
	if (typeof(a) == "object") {
		b = a
	} else {
		b = $("#" + a)
	}
	b.find("span").remove();
	b.find("input:checkbox[class='']").custCheckBox()
};