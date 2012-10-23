(function($) {
	$(window).load(function() {
		$(".box1").each(function() {
			var t = $(this), e = t.clone(true);
			t.html("");
			if (t.attr("whiteBg") == "true") {
				$("<div class='box1_topcenter2'><div class='box1_topleft2'><div class='box1_topright2'></div></div></div>").appendTo(t);
				$("<div class='box1_middlecenter'><div class='box1_middleleft2'><div class='box1_middleright2'><div class='boxContent'></div></div></div></div>").appendTo(t);
				$("<div class='box1_bottomcenter2'><div class='box1_bottomleft2'><div class='box1_bottomright2'></div></div></div>").appendTo(t)
			} else {
				$("<div class='box1_topcenter'><div class='box1_topleft'><div class='box1_topright'></div></div></div>").appendTo(t);
				$("<div class='box1_middlecenter'><div class='box1_middleleft'><div class='box1_middleright'><div class='boxContent'></div></div></div></div>").appendTo(t);
				$("<div class='box1_bottomcenter'><div class='box1_bottomleft'><div class='box1_bottomright'></div></div></div>").appendTo(t)
			}
			if (t.attr("panelWidth")) {
				var v = t.attr("panelWidth");
				var u = v.substr(v.length - 1, 1);
				if (u == "%") {
					t.width(v)
				} else {
					var w = Number(t.attr("panelWidth"));
					t.width(w)
				}
			}
			if (t.attr("panelHeight")) {
				t.find(".box1_topcenter").height(20);
				t.find(".box1_bottomcenter").height(22);
				var o = Number(t.attr("panelHeight")) - t.find(".box1_topcenter").outerHeight() - t.find(".box1_bottomcenter").outerHeight();
				t.find(".boxContent").height(o)
			}
			e.removeAttr("panelWidth").removeAttr("panelHeight").removeAttr("class").removeAttr("style").removeAttr("panelTitle").removeAttr("overflow").removeAttr("roller").removeAttr("showStatus").removeAttr("statusText").removeAttr("panelUrl").removeAttr("panelTarget").removeAttr("id").appendTo(t.find(".boxContent"));
			if (t.attr("overflow")) {
				t.find(".boxContent").css({
					overflow : t.attr("overflow")
				})
			}
		})
		$(".box2").each(function() {

			var t = $(this), v = t.clone(true);
			t.html("");
			$("<div class='box4_topcenter'><div class='box2_topleft'><div class='box2_topright'><div class='title'></div><div class='status'><span class='ss'><a></a></span></div><div class='clear'></div></div></div></div>").appendTo(t);
			$("<div class='box2_middlecenter'><div class='box2_middleleft'><div class='box2_middleright'><div class='boxContent'></div></div></div></div>").appendTo(t);
			var A = $("<div class='box2_bottomcenter' id='box2_bottomcenter'><div class='box2_bottomleft'><div class='box2_bottomright'></div></div></div>");
			var z = $("<div class='box2_bottomcenter2' id='box2_bottomcenter'><div class='box2_bottomleft2'><div class='box2_bottomright2'></div></div></div>");
			if (t.attr("roller") == "false") {
				A.appendTo(t)
			} else {
				z.appendTo(t)
			}
			if (t.attr("panelTitle")) {
				t.find(".title").append(t.attr("panelTitle"))
			}
			if (t.attr("panelWidth")) {
				var o = t.attr("panelWidth");
				var C = o.substr(o.length - 1, 1);
				if (C == "%") {
					t.width(o)
				} else {
					var e = Number(t.attr("panelWidth"));
					t.width(e)
				}
			}
			if (t.attr("panelHeight")) {
				var D = Number(t.attr("panelHeight")) - t.find(".box4_topcenter").outerHeight() - t.find("#box2_bottomcenter").outerHeight();
				t.find(".boxContent").height(D)
			}
			v.removeAttr("panelWidth").removeAttr("panelHeight").removeAttr("class").removeAttr("style").removeAttr("panelTitle").removeAttr("overflow").removeAttr("roller").removeAttr("showStatus").removeAttr("statusText").removeAttr("panelUrl").removeAttr("panelTarget").removeAttr("id").appendTo(t.find(".boxContent"));

			if (t.attr("overflow")) {
				t.find(".boxContent").css({
					overflow : t.attr("overflow")
				})
			}
			var w = "true";
			if (t.attr("showStatus")) {
				w = t.attr("showStatus")
			}
			var B = "#";
			if (t.attr("panelUrl")) {
				B = t.attr("panelUrl")
			}
			var y = "_self";
			if (t.attr("panelTarget")) {
				y = t.attr("panelTarget")
			}
			var u = "收缩";
			if (t.attr("statusText")) {
				u = t.attr("statusText")
			}
			var E;
			if (u == "收缩" && w == "true") {
				t.find(".ss").text(u);
				t.find(".ss").toggle(function() {
					var t = $(this), F = t.parents(".box2").find(".boxContent");
					F.slideUp(300);
					t.text("展开")
				}, function() {
					var t = $(this), F = t.parents(".box2").find(".boxContent");
					F.slideDown(300);
					t.text("收缩")
				})
			} else {
				if (u == "展开" && w == "true") {
					t.find(".ss").text(u);
					var x = t.find(".boxContent").hide();
					t.find(".ss").toggle(function() {
						var t = $(this), F = t.parents(".box2").find(".boxContent");
						F.slideDown(300);
						t.text("收缩");
					}, function() {
						var t = $(this), F = t.parents(".box2").find(".boxContent");
						F.slideUp(300)
						t.text("展开")
					})
				} else {
					if (w == "true" || t.attr("statusText")) {
						t.find(".ss").find("a").attr("href", B);
						t.find(".ss").find("a").attr("target", y);
						t.find(".ss").find("a").text(u)
					} else {
						t.find(".ss").hide()
					}
				}

			}
		})
	});
})(jQuery); 