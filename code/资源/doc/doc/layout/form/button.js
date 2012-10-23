var broswerFlag;
$(function() {
	if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
		var b = window.navigator.userAgent.substring(30, 33);
		if (b == "6.0") {
			broswerFlag = "IE6"
		} else {
			if (b == "7.0") {
				broswerFlag = "IE7"
			} else {
				if (b == "8.0") {
					broswerFlag = "IE8"
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
	var a;
	$("button").each(function() {
		
		if (!$(this).attr("class")) {
			
			$(this).addClass("button");
			var d = _getStrLength($(this).text());
			if (d < 5) {
				$(this).width(60)
			}
			var c = 0;
			var e = 50;
			c = _getStrLength($(this).filter(":has(span)").find("span").text());
			if (c != 0) {
				e = 20 + 7 * c + 10
			}
			if (broswerFlag == "Firefox" || broswerFlag == "Opera" || broswerFlag == "Safari") {
				$(this).filter(":has(span)").css({
					paddingLeft: "5px",
					width: e + 8 + "px"
				})
			} else {
				$(this).filter(":has(span)").css({
					paddingLeft: "5px",
					width: e + "px"
				})
			}
			$(this).filter(":has(span)").find("span").css({
				cursor: "default"
			})
		}
	});
	$("input:button[class=''],input:submit[class=''],input:reset[class='']").each(function() {
		$(this).addClass("button");
		var c = _getStrLength($(this).val());
		if (c < 5) {
			$(this).width(60)
		}
	});
	$("input:button[class='button'],input:submit[class='button'],input:reset[class='button'],button[class='button']").each(function() {
		$(this).hover(function() {
			
			if (a != $(this)[0]) {
				$(this).removeClass("button");
				$(this).addClass("button_hover")
			}
		},
		function() {
			if (a != $(this)[0]) {
				$(this).removeClass("button_hover");
				$(this).addClass("button")
			}
		});
		$(this).focus(function() {
			$(this).removeClass("button");
			$(this).addClass("button_hover")
		});
		$(this).blur(function() {
			$(this).removeClass("button_hover");
			$(this).addClass("button")
		})
	})
});
function _getStrLength(c) {
	var b;
	var a;
	for (b = 0, a = 0; b < c.length; b++) {
		if (c.charCodeAt(b) < 128) {
			a++
		} else {
			a = a + 2
		}
	}
	return a
};