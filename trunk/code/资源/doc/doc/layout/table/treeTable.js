var options; 
(function(c) {
	var a = false;
	c.fn.acts_as_tree_table = function(d) {
		options = c.extend({},
		c.fn.acts_as_tree_table.defaults, d);
		return this.each(function() {
			var e = c(this);
			if (e.attr("mode") == "ajax") {
				a = true
			}
			e.addClass("acts_as_tree_table");
			if (a) {
				e.children("tbody").children("tbody tr").each(function() {
					var f = c(this);
					if (f.not(".parent") && f.attr("url") != null) {
						f.addClass("parent")
					}
					if (f.is(".parent")) {
						init_parent2(f)
					}
				})
			} else {
				e.children("tbody").children("tbody tr").each(function() {
					var f = c(this);
					if (f.not(".parent") && children_of(f).size() > 0) {
						f.addClass("parent")
					}
					if (f.is(".parent")) {
						b(f)
					}
				})
			}
		})
	};
	c.fn.acts_as_tree_table.defaults = {
		expandable: true,
		default_state: "expanded",
		indent: 19,
		tree_column: 0
	};
	c.fn.collapse = function() {
		collapse(this)
	};
	c.fn.expand = function() {
		expand(this)
	};
	c.fn.toggleBranch = function() {
		toggle(this)
	};
	function b(e) {
		var d = c(e.children("td")[options.tree_column]);
		var f = parseInt(d.css("padding-left")) + options.indent;
		children_of(e).each(function() {
			c(c(this).children("td")[options.tree_column]).css("padding-left", f + "px")
		});
		if (options.expandable) {
			d.prepend('<span style="margin-left:0px; padding-left: ' + options.indent + 'px" class="expander"></span>');
			var g = c(d[0].firstChild);
			g.click(function() {
				toggle(e)
			});
			if (! (e.is(".expanded") || e.is(".collapsed"))) {
				e.addClass(options.default_state)
			}
			if (e.is(".collapsed")) {
				collapse(e)
			} else {
				if (e.is(".expanded")) {
					expand(e)
				}
			}
		}
	}
})(jQuery);
function children_of(a) {
	return $("tr.child-of-" + a[0].id)
}
function init_parent2(b) {
	var a = $(b.children("td")[0]);
	a.prepend('<span style="margin-left:0px; padding-left: ' + options.indent + 'px" class="expander"></span>');
	var c = $(a[0].firstChild);
	b.addClass("collapsed");
	c.click(function() {
		var e = $(this);
		var d = b.attr("url");
		if (d != "") {
			b.removeClass("collapsed");
			b.addClass("loading");
			window.setTimeout(function() {
				treeTableLoadLater(e, d)
			},
			200)
		} else {
			toggle(b)
		}
	})
}
function toggle(a) {
	if (a.is(".collapsed")) {
		a.removeClass("collapsed");
		a.addClass("expanded");
		expand(a)
	} else {
		a.removeClass("expanded");
		a.addClass("collapsed");
		collapse(a)
	}
}
function collapse(a) {
	children_of(a).each(function() {
		var b = $(this);
		collapse(b);
		b.hide()
	})
}
function expand(a) {
	children_of(a).each(function() {
		var b = $(this);
		if (b.is(".expanded.parent")) {
			expand(b)
		}
		b.show()
	})
}
$(function() {
	$(".treeTable").each(function() {
		var b = true;
		var a = "expanded";
		if ($(this).attr("expandable") == "false") {
			b = false
		}
		if ($(this).attr("initState") == "collapsed") {
			a = "collapsed"
		}
		$(this).acts_as_tree_table({
			expandable: b,
			default_state: a
		})
	})
});
function treeTableLoadLater(b, a) {
	$.ajax({
		url: a,
		error: function() {
			try {
				top.Dialog.alert("数据加载失败，请检查dataPath是否正确")
			} catch(c) {
				alert("数据加载失败，请检查dataPath是否正确")
			}
		},
		success: function(e) {
			var d = b.parents("tr");
			var f = $(e);
			d.after(f);
			d.attr("url", "");
			d.removeClass("loading");
			d.addClass("expanded");
			var c = d.find("td").eq(0);
			var g = parseInt(c.css("padding-left")) + options.indent;
			children_of(d).each(function() {
				$($(this).children("td")[0]).css("padding-left", g + "px");
				var h = $(this);
				if (h.not(".parent") && h.attr("url") != null) {
					h.addClass("parent")
				}
				if (h.is(".parent")) {
					init_parent2(h)
				}
			})
		}
	})
};