var _beforeClickText;
var _afterClickText;
var _duration;
var _animatefirst;
var _width;
var _direction;
var _kDirection;
var _iframe;
var parentId;
var _depth = 700;
var _init;
var _topDistance;
var _mainCon;
$.fn.floatPanel = function(a) {
	_beforeClickText = "打开面板";
	_afterClickText = "关闭面板";
	_duration = 500;
	_animatefirst = true;
	_width = 400;
	_direction = "tc";
	_kDirection = "top";
	_iframe = false;
	_init = "hide";
	_topDistance = 30;
	_depth++;
	if (a) {
		if (a.beforeClickText) {
			_beforeClickText = a.beforeClickText
		}
		if (a.afterClickText) {
			_afterClickText = a.afterClickText
		}
		if (a.duration) {
			_duration = a.duration
		}
		if (a.animatefirst != null) {
			_animatefirst = a.animatefirst
		}
		if (a.width) {
			_width = a.width
		}
		if (a.direction) {
			_direction = a.direction
		}
		if (a.iframe != null) {
			_iframe = a.iframe
		}
		if (a.init) {
			_init = a.init
		}
		if (a.topDistance) {
			_topDistance = a.topDistance
		}
	}
	_mainCon = $("<div class='searchMain' style='visibility:hidden;'><div id='searchBtnCon2'><button id='searchBtn2'></button></div><div id='clear2'></div><div id='searchPan'><div class='searchPan_con'></div></div><div id='clear'></div><div id='searchBtnCon'><button id='searchBtn'></button></div></div>");
	_mainCon.prependTo($("body"));
	parentId = this.attr("id");
	$(".searchMain").eq(0).attr("id", parentId);
	if (a) {
		if (a.depth) {
			$(".searchMain").eq(0).css({
				zIndex: a.depth
			})
		} else {
			$(".searchMain").eq(0).css({
				zIndex: _depth
			})
		}
	}
	$("#" + parentId + " #searchBtn").attr("beforeClickText", _beforeClickText);
	$("#" + parentId + " #searchBtn").attr("afterClickText", _afterClickText);
	$("#" + parentId + " #searchBtn").attr("panelWidth", _width);
	$("#" + parentId + " #searchBtn").attr("panelDuration", _duration);
	$("#" + parentId + " #searchBtn2").attr("beforeClickText", _beforeClickText);
	$("#" + parentId + " #searchBtn2").attr("afterClickText", _afterClickText);
	$("#" + parentId + " #searchBtn2").attr("panelWidth", _width);
	$("#" + parentId + " #searchBtn2").attr("panelDuration", _duration);
	if (_direction == "tl") {
		$("#" + parentId + " #searchBtnCon2").css({
			display: "none"
		});
		$(".searchMain").filter("[id=" + parentId + "]").css({
			paddingLeft: "10px"
		})
	} else {
		if (_direction == "tc") {
			$(".searchMain").filter("[id=" + parentId + "]").css({
				textAlign: "center",
				width: "100%"
			});
			$("#" + parentId + " #searchPan").css({
				marginLeft: "auto",
				marginRight: "auto"
			});
			$("#" + parentId + " #searchBtnCon").css({
				textAlign: "center"
			});
			$("#" + parentId + " #searchBtnCon2").css({
				display: "none"
			})
		} else {
			if (_direction == "tr") {
				$(".searchMain").filter("[id=" + parentId + "]").css({
					textAlign: "right",
					right: 0,
					paddingRight: "10px"
				});
				if (!document.all) {
					$("#" + parentId + " #searchPan").css({
						"float": "right"
					})
				}
				$("#" + parentId + " #searchBtnCon").css({
					textAlign: "right"
				});
				$("#" + parentId + " #searchBtnCon2").css({
					display: "none"
				})
			} else {
				if (_direction == "ml") {
					$(".searchMain").filter("[id=" + parentId + "]").width(_width + 30);
					$("#" + parentId + " #searchPan").css({
						"float": "left"
					});
					$("#" + parentId + " #searchBtnCon").css({
						"float": "left"
					});
					$("#" + parentId + " #searchBtnCon2").css({
						display: "none"
					});
					_kDirection = "left"
				} else {
					if (_direction == "mr") {
						$(".searchMain").filter("[id=" + parentId + "]").width(_width + 30);
						$("#" + parentId + " #searchPan").css({
							"float": "left"
						});
						$("#" + parentId + " #searchBtnCon2").css({
							"float": "left"
						});
						$("#" + parentId + " #searchBtnCon").css({
							display: "none"
						});
						_kDirection = "right"
					} else {
						if (_direction == "bl") {
							$("#" + parentId + " #searchBtnCon").css({
								display: "none"
							});
							$(".searchMain").filter("[id=" + parentId + "]").css({
								left: "5"
							});
							_kDirection = "bottom"
						} else {
							if (_direction == "bc") {
								$(".searchMain").filter("[id=" + parentId + "]").css({
									textAlign: "center",
									width: "100%"
								});
								$("#" + parentId + " #searchPan").css({
									marginLeft: "auto",
									marginRight: "auto"
								});
								$("#" + parentId + " #searchBtnCon2").css({
									textAlign: "center"
								});
								$("#" + parentId + " #searchBtnCon").css({
									display: "none"
								});
								_kDirection = "bottom"
							} else {
								if (_direction == "br") {
									$(".searchMain").filter("[id=" + parentId + "]").css({
										textAlign: "right",
										right: 0,
										paddingRight: "10px"
									});
									if (!document.all) {
										$("#" + parentId + " #searchPan").css({
											"float": "right"
										})
									}
									$("#" + parentId + " #searchBtnCon2").css({
										textAlign: "right"
									});
									$("#" + parentId + " #searchBtnCon").css({
										display: "none"
									});
									_kDirection = "bottom"
								} else {
									alert("direction参数有误，只能是tl、tc、tr、ml、mr、bl、bc、br中的一个");
									return
								}
							}
						}
					}
				}
			}
		}
	}
	$("#" + parentId + " #searchPan").css({
		width: _width
	});
	var b;
	if (!_iframe) {
		$(".searchMain").filter("[id=" + parentId + "]").find("div[class='searchPan_con']").append(this);
		$(document).remove(this);
		b = $("#" + parentId + " .searchPan_con").height();
		buildBox(b);
		_mainCon[0].style.visibility = "visible"
	} else {
		$(document).remove(this);
		$(".searchMain").filter("[id=" + parentId + "]").find("div[class='searchPan_con']").append($("<IFRAME scrolling=no width=100%  frameBorder=0 onload=loadfrm() src=" + _iframe + " id=frmcontent name=frmcontent allowTransparency=true></IFRAME>"))
	}
};
function loadfrm() {
	if ($.browser.safari) {
		setTimeout("loadfrmLater()", 300)
	} else {
		loadfrmLater()
	}
}
function loadfrmLater() {
	var b = document.getElementById("frmcontent");
	var a = 150;
	try {
		if (b && !document.all) {
			b.style.height = b.contentDocument.body.scrollHeight + "px";
			b.contentDocument.body.style.backgroundColor = "transparent";
			b.contentDocument.body.style.backgroundImage = "none";
			a = b.contentDocument.body.scrollHeight
		} else {
			b.style.height = b.Document.body.scrollHeight + "px";
			b.Document.body.style.backgroundColor = "transparent";
			b.Document.body.style.backgroundImage = "none";
			a = b.Document.body.scrollHeight
		}
	} catch(c) {}
	buildBox(a);
	_mainCon[0].style.visibility = "visible"
}
function buildBox(a) {
	$("#" + parentId + " #searchBtn").attr("title", _beforeClickText);
	$("#" + parentId + " #searchBtn").text(_beforeClickText);
	$("#" + parentId + " #searchBtn2").attr("title", _beforeClickText);
	$("#" + parentId + " #searchBtn2").text(_beforeClickText);
	try {
		enableTooltips()
	} catch(b) {}
	if (_kDirection == "top") {
		$("#" + parentId + " #searchPan")[0].className = "searchPanTop";
		$("#" + parentId + " #searchBtn")[0].className = "searchBtnTop";
		$("#" + parentId + " #searchBtnCon")[0].className = "searchBtnConTop";
		$("#" + parentId + " #clear")[0].className = "clearTop";
		if (_init == "hide") {
			if (_animatefirst == true) {
				$(".searchMain").filter("[id=" + parentId + "]").animate({
					top: -a - 12
				},
				{
					duration: 1000
				})
			} else {
				$(".searchMain").filter("[id=" + parentId + "]").css({
					top: -a - 12
				})
			}
			$("#" + parentId + " #searchBtn").toggle(function() {
				$(this).parent().parent().animate({
					top: "0"
				},
				{
					duration: parseInt($(this).attr("panelDuration"))
				});
				$(this).attr("title", $(this).attr("afterClickText"));
				$(this).text($(this).attr("afterClickText"));
				try {
					enableTooltips()
				} catch(c) {}
				try {
					hideTooltip()
				} catch(c) {}
			},
			function() {
				$(this).parent().parent().animate({
					top: -a - 12
				},
				{
					duration: parseInt($(this).attr("panelDuration"))
				});
				$(this).attr("title", $(this).attr("beforeClickText"));
				$(this).text($(this).attr("beforeClickText"));
				try {
					enableTooltips()
				} catch(c) {}
				try {
					hideTooltip()
				} catch(c) {}
			})
		} else {
			if (_animatefirst == true) {
				$(".searchMain").filter("[id=" + parentId + "]").css({
					top: -a - 12
				});
				$(".searchMain").filter("[id=" + parentId + "]").animate({
					top: 0
				},
				{
					duration: 1000
				})
			} else {
				$(".searchMain").filter("[id=" + parentId + "]").css({
					top: 0
				})
			}
			$("#" + parentId + " #searchBtn").toggle(function() {
				$(this).parent().parent().animate({
					top: -a - 12
				},
				{
					duration: parseInt($(this).attr("panelDuration"))
				});
				$(this).attr("title", $(this).attr("afterClickText"));
				$(this).text($(this).attr("afterClickText"));
				try {
					enableTooltips()
				} catch(c) {}
				try {
					hideTooltip()
				} catch(c) {}
			},
			function() {
				$(this).parent().parent().animate({
					top: "0"
				},
				{
					duration: parseInt($(this).attr("panelDuration"))
				});
				$(this).attr("title", $(this).attr("beforeClickText"));
				$(this).text($(this).attr("beforeClickText"));
				try {
					enableTooltips()
				} catch(c) {}
				try {
					hideTooltip()
				} catch(c) {}
			})
		}
	} else {
		if (_kDirection == "left") {
			$("#" + parentId + " #searchPan")[0].className = "searchPanLeft";
			$("#" + parentId + " #searchBtn")[0].className = "searchBtnLeft";
			$("#" + parentId + " #searchBtnCon")[0].className = "searchBtnConLeft";
			if (_init == "hide") {
				if (_animatefirst == true) {
					$(".searchMain").filter("[id=" + parentId + "]").css({
						top: _topDistance
					});
					$(".searchMain").filter("[id=" + parentId + "]").animate({
						top: _topDistance,
						left: -_width
					},
					{
						duration: 1000
					})
				} else {
					$(".searchMain").filter("[id=" + parentId + "]").css({
						top: _topDistance,
						left: -_width
					})
				}
				$("#" + parentId + " #searchBtn").toggle(function() {
					$(this).parent().parent().animate({
						top: _topDistance,
						left: 0
					},
					{
						duration: parseInt($(this).attr("panelDuration"))
					});
					$(this).attr("title", $(this).attr("afterClickText"));
					$(this).text($(this).attr("afterClickText"));
					try {
						enableTooltips()
					} catch(c) {}
					try {
						hideTooltip()
					} catch(c) {}
				},
				function() {
					$(this).parent().parent().animate({
						top: _topDistance,
						left: -$(this).attr("panelWidth")
					},
					{
						duration: parseInt($(this).attr("panelDuration"))
					});
					$(this).attr("title", $(this).attr("beforeClickText"));
					$(this).text($(this).attr("beforeClickText"));
					try {
						enableTooltips()
					} catch(c) {}
					try {
						hideTooltip()
					} catch(c) {}
				})
			} else {
				if (_animatefirst == true) {
					$(".searchMain").filter("[id=" + parentId + "]").css({
						top: _topDistance,
						left: -_width
					});
					$(".searchMain").filter("[id=" + parentId + "]").animate({
						top: _topDistance,
						left: 0
					},
					{
						duration: 1000
					})
				} else {
					$(".searchMain").filter("[id=" + parentId + "]").css({
						top: _topDistance,
						left: 0
					})
				}
				$("#" + parentId + " #searchBtn").toggle(function() {
					$(this).parent().parent().animate({
						top: _topDistance,
						left: -$(this).attr("panelWidth")
					},
					{
						duration: parseInt($(this).attr("panelDuration"))
					});
					$(this).attr("title", $(this).attr("afterClickText"));
					$(this).text($(this).attr("afterClickText"));
					try {
						enableTooltips()
					} catch(c) {}
					try {
						hideTooltip()
					} catch(c) {}
				},
				function() {
					$(this).parent().parent().animate({
						top: _topDistance,
						left: 0
					},
					{
						duration: parseInt($(this).attr("panelDuration"))
					});
					$(this).attr("title", $(this).attr("beforeClickText"));
					$(this).text($(this).attr("beforeClickText"));
					try {
						enableTooltips()
					} catch(c) {}
					try {
						hideTooltip()
					} catch(c) {}
				})
			}
		} else {
			if (_kDirection == "right") {
				$("#" + parentId + " #searchPan")[0].className = "searchPanRight";
				$("#" + parentId + " #searchBtn2")[0].className = "searchBtnRight";
				$("#" + parentId + " #searchBtnCon2")[0].className = "searchBtnConRight";
				if (_init == "hide") {
					if (_animatefirst == true) {
						$(".searchMain").filter("[id=" + parentId + "]").css({
							top: _topDistance
						});
						$(".searchMain").filter("[id=" + parentId + "]").animate({
							top: _topDistance,
							right: -_width
						},
						{
							duration: 1000
						})
					} else {
						$(".searchMain").filter("[id=" + parentId + "]").css({
							top: _topDistance,
							right: -_width
						})
					}
					$("#" + parentId + " #searchBtn2").toggle(function() {
						$(this).parent().parent().animate({
							top: _topDistance,
							right: 0
						},
						{
							duration: parseInt($(this).attr("panelDuration"))
						});
						$(this).attr("title", $(this).attr("afterClickText"));
						$(this).text($(this).attr("afterClickText"));
						try {
							enableTooltips()
						} catch(c) {}
						try {
							hideTooltip()
						} catch(c) {}
					},
					function() {
						$(this).parent().parent().animate({
							top: _topDistance,
							right: -$(this).attr("panelWidth")
						},
						{
							duration: parseInt($(this).attr("panelDuration"))
						});
						$(this).attr("title", $(this).attr("beforeClickText"));
						$(this).text($(this).attr("beforeClickText"));
						try {
							enableTooltips()
						} catch(c) {}
						try {
							hideTooltip()
						} catch(c) {}
					})
				} else {
					if (_animatefirst == true) {
						$(".searchMain").filter("[id=" + parentId + "]").css({
							top: _topDistance,
							right: -_width
						});
						$(".searchMain").filter("[id=" + parentId + "]").animate({
							top: _topDistance,
							right: 0
						},
						{
							duration: 1000
						})
					} else {
						$(".searchMain").filter("[id=" + parentId + "]").css({
							top: _topDistance,
							right: 0
						})
					}
					$("#" + parentId + " #searchBtn2").toggle(function() {
						$(this).parent().parent().animate({
							top: _topDistance,
							right: -$(this).attr("panelWidth")
						},
						{
							duration: parseInt($(this).attr("panelDuration"))
						});
						$(this).attr("title", $(this).attr("afterClickText"));
						$(this).text($(this).attr("afterClickText"));
						try {
							enableTooltips()
						} catch(c) {}
						try {
							hideTooltip()
						} catch(c) {}
					},
					function() {
						$(this).parent().parent().animate({
							top: _topDistance,
							right: 0
						},
						{
							duration: parseInt($(this).attr("panelDuration"))
						});
						$(this).attr("title", $(this).attr("beforeClickText"));
						$(this).text($(this).attr("beforeClickText"));
						try {
							enableTooltips()
						} catch(c) {}
						try {
							hideTooltip()
						} catch(c) {}
					})
				}
			} else {
				if (_kDirection == "bottom") {
					$("#" + parentId + " #searchPan")[0].className = "searchPanBottom";
					$("#" + parentId + " #searchBtn2")[0].className = "searchBtnBottom";
					$("#" + parentId + " #searchBtnCon2")[0].className = "searchBtnConBottom";
					$("#" + parentId + " #clear2")[0].className = "clearTop";
					if (_init == "hide") {
						if (_animatefirst == true) {
							$(".searchMain").filter("[id=" + parentId + "]").animate({
								bottom: -a - 12
							},
							{
								duration: 1000
							})
						} else {
							$(".searchMain").filter("[id=" + parentId + "]").css({
								bottom: -a - 12
							})
						}
						$("#" + parentId + " #searchBtn2").toggle(function() {
							$(this).parent().parent().animate({
								bottom: -2
							},
							{
								duration: parseInt($(this).attr("panelDuration"))
							});
							$(this).attr("title", $(this).attr("afterClickText"));
							$(this).text($(this).attr("afterClickText"));
							try {
								enableTooltips()
							} catch(c) {}
							try {
								hideTooltip()
							} catch(c) {}
						},
						function() {
							$(this).parent().parent().animate({
								bottom: -a - 12
							},
							{
								duration: parseInt($(this).attr("panelDuration"))
							});
							$(this).attr("title", $(this).attr("beforeClickText"));
							$(this).text($(this).attr("beforeClickText"));
							try {
								enableTooltips()
							} catch(c) {}
							try {
								hideTooltip()
							} catch(c) {}
						})
					} else {
						if (_animatefirst == true) {
							$(".searchMain").filter("[id=" + parentId + "]").css({
								bottom: -a - 12
							});
							$(".searchMain").filter("[id=" + parentId + "]").animate({
								bottom: -2
							},
							{
								duration: 1000
							})
						} else {
							$(".searchMain").filter("[id=" + parentId + "]").css({
								bottom: -2
							})
						}
						$("#" + parentId + " #searchBtn2").toggle(function() {
							$(this).parent().parent().animate({
								bottom: -a - 12
							},
							{
								duration: parseInt($(this).attr("panelDuration"))
							});
							$(this).attr("title", $(this).attr("afterClickText"));
							$(this).text($(this).attr("afterClickText"));
							try {
								enableTooltips()
							} catch(c) {}
							try {
								hideTooltip()
							} catch(c) {}
						},
						function() {
							$(this).parent().parent().animate({
								bottom: -2
							},
							{
								duration: parseInt($(this).attr("panelDuration"))
							});
							$(this).attr("title", $(this).attr("beforeClickText"));
							$(this).text($(this).attr("beforeClickText"));
							try {
								enableTooltips()
							} catch(c) {}
							try {
								hideTooltip()
							} catch(c) {}
						})
					}
				}
			}
		}
	}
};
(function($) {
	$.modTool = {
		depth : 500,
		broswerFlag : null,
		elm_id : 1,
		parentTopHeight : 0,
		parentBottomHeight : 0,
		parentTopHeight_left : 0,
		parentBottomHeight_left : 0,
		colsDefault : 0,
		rowsDefault : 0,
		fixHeight : 0,
		exitVtab : 0,
		vtabIdx : 0,
		hasIframe : 0,
		getPosition : function(b, c) {
			for (var a = 0; a < c.length; a++) {
				if (b == c[a]) {
					return a;
					break
				}
			}
		},
		enableTooltips : function(e) {
			var b, a, c, d;
			if (!document.getElementById || !document.getElementsByTagName) {
				return
			}
			d = document.createElement("span");
			d.id = "btc";
			d.setAttribute("id", "btc");
			d.style.position = "absolute";
			d.style.zIndex = 9999;
			$("body").append($(d));
			$("a[title],span[title],input[title],textarea[title],img[title],div[title]").each(function() {
				if ($(this).attr("defaultTip") != "false") {
					$.modTool.Prepare($(this)[0])
				}
			})
		},
		_getStrLength : function(c) {
			var lengthSelf = 0;
			for (var i = 0; i < c.length; i++) {
				if (c.charCodeAt(i) < 27 || c.charCodeAt(i) > 126)
					lengthSelf += 2;
				else
					lengthSelf++;
			}
			return lengthSelf;
		},
		Prepare : function(f) {
			var g, d, a, e, c;
			d = f.getAttribute("title");
			if (d != null && d.length != 0) {
				f.removeAttribute("title");
				if ($.modTool._getStrLength(d) > 37 || $.modTool._getStrLength(d) == 37) {
					g = $.modTool.CreateEl("span", "tooltip")
				} else {
					if ($.modTool._getStrLength(d) > 10 && $.modTool._getStrLength(d) < 37) {
						g = $.modTool.CreateEl("span", "tooltip_mid")
					} else {
						g = $.modTool.CreateEl("span", "tooltip_min")
					}
				}
				e = $.modTool.CreateEl("span", "top");
				$(e).html(d);
				g.appendChild(e);
				a = $.modTool.CreateEl("b", "bottom");
				g.appendChild(a);
				$.modTool.setOpacity(g);
				f.tooltip = g;
				f.onmouseover = $.modTool.showTooltip;
				f.onmouseout = $.modTool.hideTooltip;
				f.onmousemove = $.modTool.Locate
			}
		},
		showTooltip : function(a) {
			document.getElementById("btc").appendChild(this.tooltip);
			$.modTool.Locate(a)
		},
		hideTooltip : function(a) {
			var b = document.getElementById("btc");
			if (b.childNodes.length > 0) {
				b.removeChild(b.firstChild)
			}
		},
		setOpacity : function(a) {
			a.style.filter = "alpha(opacity:95)";
			a.style.KHTMLOpacity = "0.95";
			a.style.MozOpacity = "0.95";
			a.style.opacity = "0.95"
		},
		CreateEl : function(b, d) {
			var a = document.createElement(b);
			a.className = d;
			a.style.display = "block";
			return (a)
		},
		Locate : function(c) {
			var a = 0, f = 0;
			if (c == null) {
				c = window.event
			}
			if (c.pageX || c.pageY) {
				a = c.pageX;
				f = c.pageY
			} else {
				if (c.clientX || c.clientY) {
					if (document.documentElement.scrollTop) {
						a = c.clientX + document.documentElement.scrollLeft;
						f = c.clientY + document.documentElement.scrollTop
					} else {
						a = c.clientX + document.body.scrollLeft;
						f = c.clientY + document.body.scrollTop
					}
				}
			}
			document.getElementById("btc").style.top = (f + 10) + "px";
			var d = window.document.documentElement.clientWidth;
			var b = $("#btc").width();
			if (d - b < a - 20) {
				document.getElementById("btc").style.left = (d - b) + "px"
			} else {
				document.getElementById("btc").style.left = (a - 20) + "px"
			}
		},
		setDefaultValues : function(a) {
			$.modTool.colsDefault = a.cols;
			$.modTool.rowsDefault = $(a).attr("rows")
		},
		bindEvents : function(a) {
			a.onkeyup = function() {
				$.modTool.grow(a)
			}
		},
		grow : function(d) {
			var c = 0;
			var a = d.value.split("\n");
			for (var b = a.length - 1; b >= 0; --b) {
				c += Math.floor((a[b].length / $.modTool.colsDefault) + 1)
			}
			if (c >= $.modTool.rowsDefault) {
				d.rows = c + 1
			} else {
				d.rows = $.modTool.rowsDefault
			}
		},
		scrollContent : function() {
			try {
				var b =document.documentElement.clientHeight;
				var sch=document.body.clientHeight;
				if($("#scrollContent").height()>(b - $.modTool.fixHeight-1)){
					var item1 = $(".tableStyle:last");
					item1.css("width",item1.width()+15);
				}
				//修改表格高度
				//$("#scrollContent").height(b - $.modTool.fixHeight-1)
				
			} catch(c) {
				alert(c);
			}
		},
		getFixHeight : function() {
			$.modTool.fixHeight = 0;
			//$("#scrollContent").parent().find(">*").not("div").not("#btc").hide();
			$("#scrollContent").parent().find(">div").not("#scrollContent").not(".searchMain").not(".jquery_rgbmultiselect_options_container").not("#cursorMessageDiv").not(".simplemenu").not(".iconmenu").not(".megamenu").not(".b-m-mpanel").each(function() {
				if ($(this).css("display") != "none") {
					$.modTool.fixHeight = $.modTool.fixHeight + $(this).outerHeight();
					if ($(this).css("marginBottom") != "auto") {
						$.modTool.fixHeight = $.modTool.fixHeight + parseInt($(this).css("marginBottom"))
					}
					if ($(this).css("marginTop") != "auto") {
						$.modTool.fixHeight = $.modTool.fixHeight + parseInt($(this).css("marginTop"))
					}
				}
				
			});
			$("#scrollContent").parent().parent().find(">div").not("#scrollContent").not(".searchMain").not(".jquery_rgbmultiselect_options_container").not("#cursorMessageDiv").not(".simplemenu").not(".iconmenu").not(".megamenu").not(".b-m-mpanel").each(function() {
				
				if ($(this).css("display") != "none") {
					$.modTool.fixHeight = $.modTool.fixHeight +$(this).outerHeight(true);
					if ($(this).css("marginBottom") != "auto") {
						$.modTool.fixHeight = $.modTool.fixHeight + parseInt($(this).css("marginBottom"))
					}
					if ($(this).css("marginTop") != "auto") {
						$.modTool.fixHeight = $.modTool.fixHeight + parseInt($(this).css("marginTop"))
					}
				}
			});
		},
		resetHeight : function() {
			try {
				$.modTool.getFixHeight();
				$.modTool.scrollContent()
			} catch(a) {
			}
		},
		setTableStyle : function() {
			$(".tableStyle").each(function() {
				$(this).find("th").addClass("th");
				if ($(this).find("tr").eq(1).find("td").eq(0).find('input[type="checkbox"]').length == 1) {
					if ($(this).attr("useCheckBox") != "false") {
						$(this).attr("useCheckBox", "true")
					}
					if ($(this).attr("useMultColor") != "false") {
						$(this).attr("useMultColor", "true")
					}
				}
				if ($(this).find("tr").eq(1).find("td").eq(0).find('input[type="radio"]').length == 1) {
					if ($(this).attr("useRadio") != "false") {
						$(this).attr("useRadio", "true")
					}
				}
				if ($(this).attr("formMode") == "true") {
					$(this).attr("useColor", "false");
					$(this).attr("useHover", "false");
					$(this).attr("useClick", "false");
					$(this).find("th").css({
						fontWeight : "bold",
						"text-align" : "center"
					});
					$(this).find("tr").not("tr:last").find("td:even").not("[align]").css("text-align", "right");
					if ($(this).attr("footer") != null) {
						if ($(this).attr("footer") == "left") {
							$(this).find("tr:last").find("td").css("text-align", "left")
						} else {
							if ($(this).attr("footer") == "right") {
								$(this).find("tr:last").find("td").css("text-align", "right")
							} else {
								if ($(this).attr("footer") == "center") {
									$(this).find("tr:last").find("td").css("text-align", "center")
								} else {
									if ($(this).attr("footer") == "normal") {
										$(this).find("tr:last").find("td:even").css("text-align", "right")
									}
								}
							}
						}
					} else {
						$(this).find("tr:last").find("td").css("text-align", "center");
					}
					$(this).find("td").css({
						paddingTop : "3px",
						paddingBottom : "3px"
					})
				}else{
					$(this).find("tr").css("cursor","pointer");
				}
				if ($(this).attr("transMode") == "true") {
					$(this).attr("useColor", "false");
					$(this).attr("useHover", "false");
					$(this).attr("useClick", "false");
					$(this).find("th").css({
						fontWeight : "bold",
						"text-align" : "center"
					});
					$(this).css({
						border : "none",
						backgroundColor : "transparent"
					});
					$(this).find("tr").css({
						border : "none",
						backgroundColor : "transparent"
					});
					$(this).find("tr").not("tr:last").find("td:even").css("text-align", "right");
					if ($(this).attr("footer") != null) {
						if ($(this).attr("footer") == "left") {
							$(this).find("tr:last").find("td").css("text-align", "left")
						} else {
							if ($(this).attr("footer") == "right") {
								$(this).find("tr:last").find("td").css("text-align", "right")
							} else {
								if ($(this).attr("footer") == "center") {
									$(this).find("tr:last").find("td").css("text-align", "center")
								} else {
									if ($(this).attr("footer") == "normal") {
										$(this).find("tr:last").find("td:even").css("text-align", "right")
									}
								}
							}
						}
					} else {
						$(this).find("tr:last").find("td").css("text-align", "center")
					}
					$(this).find("td").css({
						paddingTop : "3px",
						paddingBottom : "3px",
						border : "none"
					})
				}
				if ($(this).attr("useColor") != "false") {
					$(this).find("tr:even").addClass("odd")
				}
				if ($(this).attr("useHover") != "false") {
					$(this).find("tr").hover(function() {
						$(this).addClass("highlight")
					}, function() {
						$(this).removeClass("highlight")
					})
				}
				//if ($(this).find("th").attr("sortMode") == "true") {
				$(this).find("th").each(function(){
					if($(this).attr("sortMode")=="true"){
						$(this).filter(":has(span)").hover(function() {
							$(this).removeClass("th");
							$(this).addClass("th_over")
						}, function() {
							$(this).removeClass("th_over");
							$(this).addClass("th")
						});
						if($(this).find("span").attr("class")!="sort_up"&&$(this).find("span").attr("class")!="sort_down"){
							$(this).find("span").removeClass("sort_Off");
							$(this).find("span").addClass("sort_off");
						}
						$(this).click(function() {
							switch ($(this).find("span").attr("class")) {
								case "sort_off":
									$(this).find("span").removeClass("sort_off");
									$(this).find("span").addClass("sort_up");
									break;
								case "sort_up":
									$(this).find("span").removeClass("sort_up");
									$(this).find("span").addClass("sort_down");
									break;
								case "sort_down":
									$(this).find("span").removeClass("sort_down");
									$(this).find("span").addClass("sort_off");
									break;
								default:
									$(this).find("span").addClass("sort_off");
									break;
							}
							eval($(this).attr("onsecclick"));
						})
					}
				})
					
				if ($(this).attr("useClick") != "false") {
					$(this).attr("useClick", "true")
				}
				if ($(this).attr("useClick") == "true" && $(this).attr("useMultColor") == "true") {
					$(this).attr("useClick", "false")
				}
				if ($(this).attr("useRadio") != "true") {
					$(this).attr("useRadio", "false")
				}
				if ($(this).attr("useCheckBox") != "true") {
					$(this).attr("useCheckBox", "false")
				}
				
				if ($(this).attr("useClick") != "false") {
					if ($(this).attr("useRadio") != "false") {
						$(this).find('input[type="radio"]:checked').parents("tr").addClass("singelSeleced");
						$(this).find("tr").click(function() {
							$(this).find('input[type="radio"]').attr("checked", "checked")
						})
					}
				}
				if($(this).attr("formMode") != "true"){
					$(this).find("tr").click(function(){
						$(this).siblings().removeClass("singelSeleced");
						$(this).addClass("singelSeleced");
					})
				}
				
				if ($(this).attr("useMultColor") == "true") {
					if ($(this).attr("useCheckBox") == "false") {
						$(this).find("tr").click(function() {
							$(this).toggleClass("selected")
						})
					} else {
						$(this).find('input[type="checkbox"]:checked').parents("tr").addClass("selected");
						if ($(this).find("th").length > 0) {
							var headCheck = $('th.headCheckBox')[0];
							var a = $('<span class="img_checkAllOff" title="点击全选">&nbsp;&nbsp;&nbsp;</span>');
							$(this).find(headCheck).html("");
							$(this).find(headCheck).append(a);
							if ($(this).attr("headFixMode") == "true") {
								a.toggle(function() {
									$("table:[class=tableStyle]").find("tr").each(function() {
										$(this).addClass("selected");
										$(this).find('input[type="checkbox"]').eq(0).attr("checked", "checked").refresh();
									});
									$(this).removeClass("img_checkAllOff");
									$(this).addClass("img_checkAllOn");
									$(this).attr("title", "取消");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								}, function() {
									$("table:[class=tableStyle]").find("tr").each(function() {
										if ($(this).hasClass("selected")) {
											$(this).removeClass("selected");
											$(this).find('input[type="checkbox"]').eq(0).removeAttr("checked").refresh();
										}
									});
									$(this).removeClass("img_checkAllOn");
									$(this).addClass("img_checkAllOff");
									$(this).attr("title", "点击全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								})
							} else {
								a.toggle(function() {
									$(this).parents("table:first").find("tr").each(function() {
										$(this).addClass("selected");
										$(this).find('input[type="checkbox"]').eq(0).attr("checked", "checked").refresh();
									});
									$(this).removeClass("img_checkAllOff");
									$(this).addClass("img_checkAllOn");
									$(this).attr("title", "取消全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								}, function() {
									$(this).parents("table:first").find("tr").each(function() {
										if ($(this).hasClass("selected")) {
											$(this).removeClass("selected");
											$(this).find('input[type="checkbox"]').eq(0).removeAttr("checked").refresh();
										}
									});
									$(this).removeClass("img_checkAllOn");
									$(this).addClass("img_checkAllOff");
									$(this).attr("title", "点击全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								})
							}
						}
						$(this).find("tr:has(td)").click(function() {
							if ($(this).hasClass("selected")) {
								$(this).removeClass("selected");
								$(this).find('input[type="checkbox"]').eq(0).removeAttr("checked").refresh();
							} else {
								$(this).addClass("selected");
								$(this).find('input[type="checkbox"]').eq(0).attr("checked", "checked").refresh();
							}
						})
					}
				}else if($(this).attr("useMultColor") == "false"){
					if ($(this).attr("useCheckBox") == "false") {
						$(this).find("tr").click(function() {
							$(this).toggleClass("selected")
						})
					} else {
						$(this).find('input[type="checkbox"]:checked').parents("tr").addClass("selected");
						if ($(this).find("th").length > 0) {
							var headCheck = $('th.headCheckBox')[0];
							var a = $('<span class="img_checkAllOff" title="点击全选">&nbsp;&nbsp;&nbsp;</span>');
							$(this).find(headCheck).html("");
							$(this).find(headCheck).append(a);
							if ($(this).attr("headFixMode") == "true") {
								a.toggle(function() {
									$("table:[class=tableStyle]").find("tr").each(function() {
										$(this).addClass("selected");
										$(this).find('input[type="checkbox"]').eq(0).attr("checked", "checked").refresh();
									});
									$(this).removeClass("img_checkAllOff");
									$(this).addClass("img_checkAllOn");
									$(this).attr("title", "取消");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								}, function() {
									$("table:[class=tableStyle]").find("tr").each(function() {
										
											$(this).find('input[type="checkbox"]').eq(0).removeAttr("checked").refresh();
										
									});
									$(this).removeClass("img_checkAllOn");
									$(this).addClass("img_checkAllOff");
									$(this).attr("title", "点击全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								})
							} else {
								a.toggle(function() {
									$(this).parents("table:first").find("tr").each(function() {
										$(this).find('input[type="checkbox"]').eq(0).attr("checked", "checked").refresh();
									});
									$(this).removeClass("img_checkAllOff");
									$(this).addClass("img_checkAllOn");
									$(this).attr("title", "取消全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								}, function() {
									$(this).parents("table:first").find("tr").each(function() {
										$(this).find('input[type="checkbox"]').eq(0).removeAttr("checked").refresh();
										
									});
									$(this).removeClass("img_checkAllOn");
									$(this).addClass("img_checkAllOff");
									$(this).attr("title", "点击全选");
									try {
										$.modTool.hideTooltip();
										$.modTool.enableTooltips()
									} catch(c) {
									}
								})
							}
						}
						$(this).find("tr:has(td)").click(function() {
							$(this).parents("table").find("tr").each(function() {
								if ($(this).hasClass("selected")) {
									$(this).removeClass("selected");
								}
							});
							if ($(this).hasClass("selected")) {
								$(this).removeClass("selected");
							} else {
								$(this).addClass("selected");
							}
						})
					}
				}
			})
		}
	};
	if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
		var g = window.navigator.userAgent.substring(30, 33);
		if (g == "6.0") {
			$.modTool.broswerFlag = "IE6"
		} else {
			if (g == "7.0") {
				$.modTool.broswerFlag = "IE7"
			} else {
				if (g == "8.0") {
					$.modTool.broswerFlag = "IE8"
				}
			}
		}
	} else {
		if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
			$.modTool.broswerFlag = "Firefox"
		} else {
			if (window.navigator.userAgent.indexOf("Opera") >= 0) {
				$.modTool.broswerFlag = "Opera"
			} else {
				if (window.navigator.userAgent.indexOf("Safari") >= 1) {
					$.modTool.broswerFlag = "Safari"
				} else {
					$.modTool.broswerFlag = "Other"
				}
			}
		}
	}
})(jQuery);
$(function() {
		$(".cusTreeTable").each(function() {
			$(this).find("tr").filter(":has(table)").hide();
			
			if ($(this).attr("trClick") == "true") {
				$(this).find("tr").eq(0).nextAll().not(":has(table)").each(function() {
					$(this).addClass("hand");
					$(this).hover(function() {
						$(this).addClass("highlight")
					}, function() {
						$(this).removeClass("highlight")
					});
					$(this).click(function() {
						if ($(this).next().css("display") == "none") {
							$(this).next().show();
							if ($(this).parents("table").attr("ohterClose") != "false") {
								$(this).parents("table").find(".img_remove2").attr("title", "点击展开");
								$(this).parents("table").find(".img_remove2").addClass("img_add2");
								$(this).parents("table").find(".img_remove2").removeClass("img_remove2");
								$(this).next().nextAll().filter(":has(table)").hide();
								$(this).next().prevAll().filter(":has(table)").hide()
							}
							$(this).find(".img_add2").each(function() {
								$(this).attr("title", "点击隐藏");
								$(this).removeClass("img_add2");
								$(this).addClass("img_remove2")
							})
						} else {
							$(this).next().hide();
							$(this).find(".img_remove2").each(function() {
								$(this).removeClass("img_remove2");
								$(this).addClass("img_add2");
								$(this).attr("title", "点击展开")
							})
						}
						$.modTool.enableTooltips();
						$.modTool.hideTooltip()
					})
				})
			} else {
				$(this).find(".img_add2").click(function() {
					if ($(this).parents("tr").next().css("display") == "none") {
						$(this).parents("tr").next().show();
						if ($(this).parents("table").attr("ohterClose") != "false") {
							$(this).parents("table").find(".img_remove2").attr("title", "");
							$(this).parents("table").find(".img_remove2").addClass("img_add2");
							$(this).parents("table").find(".img_remove2").removeClass("img_remove2");
							$(this).parents("tr").next().nextAll().filter(":has(table)").hide();
							$(this).parents("tr").next().prevAll().filter(":has(table)").hide()
						}
						$(this).attr("title", "点击隐藏");
						$(this).removeClass("img_add2");
						$(this).addClass("img_remove2")
					} else {
						$(this).parents("tr").next().hide();
						$(this).removeClass("img_remove2");
						$(this).addClass("img_add2");
						$(this).attr("title", "点击展开")
					}
					$.modTool.enableTooltips();
					$.modTool.hideTooltip()
				})
			}
			
		})

	if ($("#scrollContent").length > 0) {
		$("#scrollContent").css({
			overflowX : "hidden"
		});
		$("body").addClass("trans_bg");
		$.modTool.parentTopHeight = $(window.parent.document.getElementById("head")).outerHeight() + $(window.parent.document.getElementById("rbox_topcenter")).outerHeight() + parseInt($(window.parent.document.getElementById("rbox")).css("paddingTop")) + parseInt($(window.parent.document.getElementById("rbox")).css("paddingBottom"));
		$.modTool.parentBottomHeight = $(window.parent.document.getElementById("foot")).outerHeight() + $(window.parent.document.getElementById("rbox_bottomcenter")).outerHeight();
		$.modTool.parentTopHeight_left = $(window.parent.document.getElementById("hbox")).outerHeight() + $(window.parent.document.getElementById("lbox_topcenter")).outerHeight() + parseInt($(window.parent.document.getElementById("lbox")).css("paddingTop")) + parseInt($(window.parent.document.getElementById("lbox")).css("paddingBottom"));
		$.modTool.parentBottomHeight_left = $(window.parent.document.getElementById("fbox")).outerHeight() + $(window.parent.document.getElementById("lbox_bottomcenter")).outerHeight();

		if ($.modTool.parentTopHeight > 0) {
			if ($("body").attr("leftFrame") == "true") {
				$("body").addClass("contentStyleLeft")
			} else {
				$("body").addClass("contentStyle")
			}
			$("#scrollContent").css({
				overflowY : "auto"
			})
		}else{
			$("#scrollContent").css({
				overflowY : "auto"
			})
		}
		$.modTool.getFixHeight();
		$.modTool.scrollContent();
		
		var A = null;
		if (document.all) {
		} else {
			window.onload = function() {
				$.modTool.resetHeight()
			}
		}
		var k = 0;
		var B = 0;
		if ($("table:[class=tableStyle]", "#scrollContent").length > 0) {
			var d = 0;
			var n = $("table:[class=tableStyle]", "#scrollContent").eq(0);
			var u;
			if ($("table:[class=tableStyle]").length > 1) {
				u = $("table:[class=tableStyle]").eq(0);
				if (u.attr("headFixMode") == "true") {
					d = 1;
					n.css({
						borderTop : 0
					});
					u.addClass("noBottomLine")
				}
			}
			if (n.height() > $("#scrollContent").height()) {
				if ($.modTool.broswerFlag == "IE6") {
					k = 1
				} else {
					if ($.modTool.broswerFlag == "IE7") {
						B = 1
					}
				}
				if (d == 1) {
					if ($.modTool.broswerFlag != "IE6") {
						var z = u.find("th").last();
						var w = z.width();
						z.width(w + 17)
					}
				}
			}
			$.modTool.setTableStyle()
		} else {
			if ($(".flexiStyle", "#scrollContent").length > 0) {
				$("#scrollContent").css({
					overflowY : "hidden",
					overflowX : "hidden"
				});
				$(".contentStyle").css({
					paddingRight : "8px"
				})
			}
		}

		if (k == 1) {
			setTimeout(s, 500)
		}
		if (B == 1) {
			setTimeout(c, 100)
		}
		function s() {
			var C = $("body").css("paddingRight");
			var e = parseInt(C) + 17;
			$("body").css({
				paddingRight : e + "px"
			})
		}

		function c() {
			$("#scrollContent").css({
				paddingRight : "17px"
			})
		}
		
	} else {
		if ($("body").attr("rel") == "layout") {
			$("body").addClass("trans_bg");
			$.modTool.setTableStyle();
			$.modTool.parentTopHeight = $(window.parent.document.getElementById("hbox")).outerHeight() + $(window.parent.document.getElementById("rbox_topcenter")).outerHeight();
			$.modTool.parentBottomHeight = $(window.parent.document.getElementById("fbox")).outerHeight() + $(window.parent.document.getElementById("rbox_bottomcenter")).outerHeight() + 1;
			var t = window.parent.document.documentElement.clientHeight;
			try {
				window.top.document.getElementsByTagName("iframe")["frmright"].style.height = t - $.modTool.parentTopHeight - $.modTool.parentBottomHeight + "px"
			} catch(v) {
			}
		} else {
			$.modTool.setTableStyle();
			//$("body").addClass("zDialogCon");
			// if ($.modTool.broswerFlag == "IE6") {
				// var y = $("body").width();
				// $("body").width(y - 17)
			// }
		}
	}
});
(function(f) {
	var d;
	f.fn.acts_as_tree_table = function(h) {
		d = f.extend({},
		f.fn.acts_as_tree_table.defaults, h);
		this.each(function() {
			var i = f(this);
			i.children("tbody").children("tbody tr").each(function() {
				var j = f(this);
				z(j);
			})
		})
		
		$(this).find("tr:has(td)").click(function() {
			$(this).parents("table").find("tr").each(function() {
				if ($(this).hasClass("selected")) {
					$(this).removeClass("selected");
				}
			});
			if ($(this).hasClass("selected")) {
				$(this).removeClass("selected");
			} else {
				$(this).addClass("selected");
			}
		});
		return this.each(function() {
			var i = f(this);
			i.addClass("acts_as_tree_table");
			i.children("tbody").children("tbody tr").each(function() {
				var j = f(this);
				if (j.not(".parent") && c(j).size() > 0) {
					j.addClass("parent")
				}
				if (j.is(".parent")) {
					
					b(j)
				}
			})
		})
	};
	f.fn.acts_as_tree_table.defaults = {
		expandable: true,
		default_state: "expanded",
		indent: 19,
		tree_column: 0
	};
	f.fn.collapse = function() {
		g(this)
	};
	f.fn.expand = function() {
		e(this)
	};
	f.fn.toggleBranch = function() {
		a(this)
	};
	function c(h) {
		return f("tr.child-of-" + h[0].id)
	}
	function z(h){
		var list=c(h);
		for(var i=list.length;i>0;i--){
			$(list[i-1]).insertAfter(h);
			z([list[i-1]]);
		}
	}
	function g(h) {
		c(h).each(function() {
			var i = f(this);
			g(i);
			i.hide()
		})
	}
	function e(h) {
		c(h).each(function() {
			var i = f(this);
			if (i.is(".expanded.parent")) {
				e(i)
			}
			i.show()
		})
	}
	function b(i) {
		var h = f(i.children("td")[d.tree_column]);
		var j = parseInt(h.css("padding-left")) + d.indent;
		
		c(i).each(function() {
			f(f(this).children("td")[d.tree_column]).css("padding-left", j + "px");
		});
		if (d.expandable) {
			h.prepend('<span style="margin-left:0px; padding-left: ' + d.indent + 'px" class="expander"></span>');
			var k = f(h[0].firstChild);
			k.click(function() {
				a(i)
			});
			if (! (i.is(".expanded") || i.is(".collapsed"))) {
				i.addClass(d.default_state)
			}
			if (i.is(".collapsed")) {
				g(i)
			} else {
				if (i.is(".expanded")) {
					e(i)
				}
			}
		}
	}
	function a(h) {
		if (h.is(".collapsed")) {
			h.removeClass("collapsed");
			h.addClass("expanded");
			e(h)
		} else {
			h.removeClass("expanded");
			h.addClass("collapsed");
			g(h)
		}
	}
})(jQuery);
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
(function($){
		  
	$.addFlex = function(t,p)
	{

		if (t.grid) return false; //return if already exist	
		
		// apply default properties
		p = $.extend({
			 height: 200, //default height
			 width: 'auto', //auto width
			 striped: true, //apply odd even stripes
			 novstripe: false,
			 minwidth: 30, //min width of columns
			 minheight: 80, //min height of columns
			 resizable: true, //resizable table
			 url: false, //ajax url
			 method: 'POST', // data sending method
			 dataType: 'xml', // type of data loaded
			 errormsg: '连接失败',
			 usepager: false, //
			 nowrap: true, //
			 page: 1, //current page
			 total: 1, //total pages
			 useRp: true, //use the results per page select box
			 rp: 15, // results per page
			 rpOptions: [10,15,20,25,40],
			 title: false,
			 pagestat: '共{total}条记录，当前页显示： {from} - {to}条',
			 pagetext: '当前页',
			 outof: 'of',
			 findtext: '查找',
			 procmsg: '数据正在加载中，请等待 ...',
			 query: '',
			 qtype: '',
			 nomsg: '没有数据',
			 minColToggle: 1, //minimum allowed column to be hidden
			 showToggleBtn: true, //show or hide column toggle popup
			 hideOnSubmit: true,
			 autoload: true,
			 blockOpacity: 0.5,
			 onDragCol: false,
			 onToggleCol: false,
			 onChangeSort: false,
			 onSuccess: false,
			 onError: false,
			 onSubmit: false // using a custom populate function
		  }, p);
		  		

		$(t)
		.show() //show if hidden
		.attr({cellPadding: 0, cellSpacing: 0, border: 0})  //remove padding and spacing
		.removeAttr('width') //remove width properties	
		;
		
		//create grid class
		var g = {
			hset : {},
			rePosDrag: function () {

			var cdleft = 0 - this.hDiv.scrollLeft;
			if (this.hDiv.scrollLeft>0) cdleft -= Math.floor(p.cgwidth/2);
			$(g.cDrag).css({top:g.hDiv.offsetTop+1});
			var cdpad = this.cdpad;
			
			$('div',g.cDrag).hide();
			
			$('thead tr:first th:visible',this.hDiv).each
				(
			 	function ()
					{
					var n = $('thead tr:first th:visible',g.hDiv).index(this);

					var cdpos = parseInt($('div',this).width());
					var ppos = cdpos;
					if (cdleft==0) 
							cdleft -= Math.floor(p.cgwidth/2); 

					cdpos = cdpos + cdleft + cdpad;
					
					$('div:eq('+n+')',g.cDrag).css({'left':cdpos+'px'}).show();

					cdleft = cdpos;
					}
				);
				
			},
			fixHeight: function (newH) {
					newH = false;
					if (!newH) newH = $(g.bDiv).height();
					var hdHeight = $(this.hDiv).height();
					$('div',this.cDrag).each(
						function ()
							{
								$(this).height(newH+hdHeight);
							}
					);
					
					var nd = parseInt($(g.nDiv).height());
					
					if (nd>newH)
						$(g.nDiv).height(newH).width(200);
					else
						$(g.nDiv).height('auto').width('auto');
					
					$(g.block).css({height:newH,marginBottom:(newH * -1)});
					
					var hrH = g.bDiv.offsetTop + newH;
					if (p.height != 'auto' && p.resizable) hrH = g.vDiv.offsetTop;
					$(g.rDiv).css({height: hrH});
				
			},
			dragStart: function (dragtype,e,obj) { //default drag function start
				
				if (dragtype=='colresize') //column resize
					{
						$(g.nDiv).hide();$(g.nBtn).hide();
						var n = $('div',this.cDrag).index(obj);
						var ow = $('th:visible div:eq('+n+')',this.hDiv).width();
						$(obj).addClass('dragging').siblings().hide();
						$(obj).prev().addClass('dragging').show();
						
						this.colresize = {startX: e.pageX, ol: parseInt(obj.style.left), ow: ow, n : n };
						$('body').css('cursor','col-resize');
					}
				else if (dragtype=='vresize') //table resize
					{
						var hgo = false;
						$('body').css('cursor','row-resize');
						if (obj) 
							{
							hgo = true;
							$('body').css('cursor','col-resize');
							}
						this.vresize = {h: p.height, sy: e.pageY, w: p.width, sx: e.pageX, hgo: hgo};
						
					}

				else if (dragtype=='colMove') //column header drag
					{
						$(g.nDiv).hide();$(g.nBtn).hide();
						this.hset = $(this.hDiv).offset();
						this.hset.right = this.hset.left + $('table',this.hDiv).width();
						this.hset.bottom = this.hset.top + $('table',this.hDiv).height();
						this.dcol = obj;
						this.dcoln = $('th',this.hDiv).index(obj);
						
						this.colCopy = document.createElement("div");
						this.colCopy.className = "colCopy";
						this.colCopy.innerHTML = obj.innerHTML;
						if ($.browser.msie)
						{
						this.colCopy.className = "colCopy ie";
						}
						
						
						$(this.colCopy).css({position:'absolute',float:'left',display:'none', textAlign: obj.align});
						$('body').append(this.colCopy);
						$(this.cDrag).hide();
						
					}
														
				$('body').noSelect();
			
			},
			dragMove: function (e) {
			
				if (this.colresize) //column resize
					{
						var n = this.colresize.n;
						var diff = e.pageX-this.colresize.startX;
						var nleft = this.colresize.ol + diff;
						var nw = this.colresize.ow + diff;
						if (nw > p.minwidth)
							{
								$('div:eq('+n+')',this.cDrag).css('left',nleft);
								this.colresize.nw = nw;
							}
					}
				else if (this.vresize) //table resize
					{
						var v = this.vresize;
						var y = e.pageY;
						var diff = y-v.sy;
						
						if (!p.defwidth) p.defwidth = p.width;
						
						if (p.width != 'auto' && !p.nohresize && v.hgo)
						{
							var x = e.pageX;
							var xdiff = x - v.sx;
							var newW = v.w + xdiff;
							if (newW > p.defwidth)
								{
									this.gDiv.style.width = newW + 'px';
									p.width = newW;
								}
						}
						
						var newH = v.h + diff;
						if ((newH > p.minheight || p.height < p.minheight) && !v.hgo)
							{
								this.bDiv.style.height = newH + 'px';
								p.height = newH;
								this.fixHeight(newH);
							}
						v = null;
					}
				else if (this.colCopy) {
					$(this.dcol).addClass('thMove').removeClass('thOver'); 
					if (e.pageX > this.hset.right || e.pageX < this.hset.left || e.pageY > this.hset.bottom || e.pageY < this.hset.top)
					{
						//this.dragEnd();
						$('body').css('cursor','move');
					}
					else 
					$('body').css('cursor','pointer');
					$(this.colCopy).css({top:e.pageY + 10,left:e.pageX + 20, display: 'block'});
				}													
			
			},
			dragEnd: function () {

				if (this.colresize)
					{
						var n = this.colresize.n;
						var nw = this.colresize.nw;

								$('th:visible div:eq('+n+')',this.hDiv).css('width',nw);
								$('tr',this.bDiv).each (
									function ()
										{
										$('td:visible div:eq('+n+')',this).css('width',nw);
										}
								);
								this.hDiv.scrollLeft = this.bDiv.scrollLeft;


						$('div:eq('+n+')',this.cDrag).siblings().show();
						$('.dragging',this.cDrag).removeClass('dragging');
						this.rePosDrag();
						this.fixHeight();
						this.colresize = false;
					}
				else if (this.vresize)
					{
						this.vresize = false;
					}
				else if (this.colCopy)
					{
						$(this.colCopy).remove();
						if (this.dcolt != null)
							{
							
							
							if (this.dcoln>this.dcolt)
								$('th:eq('+this.dcolt+')',this.hDiv).before(this.dcol);
							else
								$('th:eq('+this.dcolt+')',this.hDiv).after(this.dcol);
							
							
							
							this.switchCol(this.dcoln,this.dcolt);
							$(this.cdropleft).remove();
							$(this.cdropright).remove();
							this.rePosDrag();
							
							if (p.onDragCol) p.onDragCol(this.dcoln, this.dcolt);
																			
							}
						
						this.dcol = null;
						this.hset = null;
						this.dcoln = null;
						this.dcolt = null;
						this.colCopy = null;
						
						$('.thMove',this.hDiv).removeClass('thMove');
						$(this.cDrag).show();
					}										
				$('body').css('cursor','default');
				$('body').noSelect(false);
			},
			toggleCol: function(cid,visible) {
				
				var ncol = $("th[axis='col"+cid+"']",this.hDiv)[0];
				var n = $('thead th',g.hDiv).index(ncol);
				var cb = $('input[value='+cid+']',g.nDiv)[0];
				
				
				if (visible==null)
					{
						visible = ncol.hide;
					}
				
				
				
				if ($('input:checked',g.nDiv).length<p.minColToggle&&!visible) return false;
				
				if (visible)
					{
						ncol.hide = false;
						$(ncol).show();
						cb.checked = true;
					}
				else
					{
						ncol.hide = true;
						$(ncol).hide();
						cb.checked = false;
					}
					
						$('tbody tr',t).each
							(
								function ()
									{
										if (visible)
											$('td:eq('+n+')',this).show();
										else
											$('td:eq('+n+')',this).hide();
									}
							);							
				
				this.rePosDrag();
				
				if (p.onToggleCol) p.onToggleCol(cid,visible);
				
				return visible;
			},
			switchCol: function(cdrag,cdrop) { //switch columns
				
				$('tbody tr',t).each
					(
						function ()
							{
								if (cdrag>cdrop)
									$('td:eq('+cdrop+')',this).before($('td:eq('+cdrag+')',this));
								else
									$('td:eq('+cdrop+')',this).after($('td:eq('+cdrag+')',this));
							}
					);
					
					//switch order in nDiv
					if (cdrag>cdrop)
						$('tr:eq('+cdrop+')',this.nDiv).before($('tr:eq('+cdrag+')',this.nDiv));
					else
						$('tr:eq('+cdrop+')',this.nDiv).after($('tr:eq('+cdrag+')',this.nDiv));
						
					if ($.browser.msie&&$.browser.version<7.0) $('tr:eq('+cdrop+') input',this.nDiv)[0].checked = true;	
					
					this.hDiv.scrollLeft = this.bDiv.scrollLeft;
			},			
			scroll: function() {
					this.hDiv.scrollLeft = this.bDiv.scrollLeft;
					this.rePosDrag();
			},
			addData: function (data) { //parse data
				
				if (p.preProcess)
					data = p.preProcess(data);
				
				$('.pReload',this.pDiv).removeClass('loading');
				this.loading = false;

				if (!data) 
					{
					$('.pPageStat',this.pDiv).html(p.errormsg);	
					return false;
					}

				if (p.dataType=='xml')
					p.total = +$('rows total',data).text();
				else
					p.total = data.total;
					
				if (p.total==0)
					{
					$('tr, a, td, div',t).unbind();
					$(t).empty();
					p.pages = 1;
					p.page = 1;
					this.buildpager();
					$('.pPageStat',this.pDiv).html(p.nomsg);
					return false;
					}
				
				p.pages = Math.ceil(p.total/p.rp);
				
				if (p.dataType=='xml')
					p.page = +$('rows page',data).text();
				else
					p.page = data.page;
				
				this.buildpager();

				//build new body
				var tbody = document.createElement('tbody');
				
				if (p.dataType=='json')
				{
					$.each
					(
					 data.rows,
					 function(i,row) 
					 	{
							var tr = document.createElement('tr');
							if (i % 2 && p.striped) tr.className = 'erow';
							
							if (row.id) tr.id = 'row' + row.id;
							
							//add cell
							$('thead tr:first th',g.hDiv).each
							(
							 	function ()
									{
										
										var td = document.createElement('td');
										var idx = $(this).attr('axis').substr(3);
										td.align = this.align;
										td.innerHTML = row.cell[idx];
										$(tr).append(td);
										td = null;
									}
							); 
							
							
							if ($('thead',this.gDiv).length<1) //handle if grid has no headers
							{

									for (idx=0;idx<cell.length;idx++)
										{
										var td = document.createElement('td');
										td.innerHTML = row.cell[idx];
										$(tr).append(td);
										td = null;
										}
							}							
							
							$(tbody).append(tr);
							tr = null;
						}
					);				
					
				} else if (p.dataType=='xml') {

				i = 1;

				$("rows row",data).each
				(
				 
				 	function ()
						{
							
							i++;
							
							var tr = document.createElement('tr');
							if (i % 2 && p.striped) tr.className = 'erow';

							var nid =$(this).attr('id');
							if (nid) tr.id = 'row' + nid;
							
							nid = null;
							
							var robj = this;

							
							
							$('thead tr:first th',g.hDiv).each
							(
							 	function ()
									{
										
										var td = document.createElement('td');
										var idx = $(this).attr('axis').substr(3);
										td.align = this.align;
										td.innerHTML = $("cell:eq("+ idx +")",robj).text();
										$(tr).append(td);
										td = null;
									}
							);
							
							
							if ($('thead',this.gDiv).length<1) //handle if grid has no headers
							{
								$('cell',this).each
								(
								 	function ()
										{
										var td = document.createElement('td');
										td.innerHTML = $(this).text();
										$(tr).append(td);
										td = null;
										}
								);
							}
							
							$(tbody).append(tr);
							tr = null;
							robj = null;
						}
				);
				
				}

				$('tr',t).unbind();
				$(t).empty();
				
				$(t).append(tbody);
				this.addCellProp();
				this.addRowProp();
				
				//this.fixHeight($(this.bDiv).height());
				
				this.rePosDrag();
				
				tbody = null; data = null; i = null; 
				
				if (p.onSuccess) p.onSuccess();
				if (p.hideOnSubmit) $(g.block).remove();//$(t).show();
				
				this.hDiv.scrollLeft = this.bDiv.scrollLeft;
				if ($.browser.opera) $(t).css('visibility','visible');
				
			},
			changeSort: function(th) { //change sortorder
			
				if (this.loading) return true;
				
				$(g.nDiv).hide();$(g.nBtn).hide();
				
				if (p.sortname == $(th).attr('abbr'))
					{
						if (p.sortorder=='asc') p.sortorder = 'desc'; 
						else p.sortorder = 'asc';						
					}
				
				$(th).addClass('sorted').siblings().removeClass('sorted');
				$('.sdesc',this.hDiv).removeClass('sdesc');
				$('.sasc',this.hDiv).removeClass('sasc');
				$('div',th).addClass('s'+p.sortorder);
				p.sortname= $(th).attr('abbr');
				
				if (p.onChangeSort)
					p.onChangeSort(p.sortname,p.sortorder);
				else
					this.populate();				
			
			},
			buildpager: function(){ //rebuild pager based on new properties
			
			$('.pcontrol input',this.pDiv).val(p.page);
			$('.pcontrol span',this.pDiv).html(p.pages);
			
			var r1 = (p.page-1) * p.rp + 1; 
			var r2 = r1 + p.rp - 1; 
			
			if (p.total<r2) r2 = p.total;
			
			var stat = p.pagestat;
			
			stat = stat.replace(/{from}/,r1);
			stat = stat.replace(/{to}/,r2);
			stat = stat.replace(/{total}/,p.total);
			
			$('.pPageStat',this.pDiv).html(stat);
			
			},
			populate: function () { //get latest data

				if (this.loading) return true;

				if (p.onSubmit)
					{
						var gh = p.onSubmit();
						if (!gh) return false;
					}

				this.loading = true;
				if (!p.url) return false;
				
				$('.pPageStat',this.pDiv).html(p.procmsg);
				
				$('.pReload',this.pDiv).addClass('loading');
				
				$(g.block).css({top:g.bDiv.offsetTop});
				
				if (p.hideOnSubmit) $(this.gDiv).prepend(g.block); //$(t).hide();
				
				if ($.browser.opera) $(t).css('visibility','hidden');
				
				if (!p.newp) p.newp = 1;
				
				if (p.page>p.pages) p.page = p.pages;
				//var param = {page:p.newp, rp: p.rp, sortname: p.sortname, sortorder: p.sortorder, query: p.query, qtype: p.qtype};
				var param = [
					 { name : 'page', value : p.newp }
					,{ name : 'rp', value : p.rp }
					,{ name : 'sortname', value : p.sortname}
					,{ name : 'sortorder', value : p.sortorder }
					,{ name : 'query', value : p.query}
					,{ name : 'qtype', value : p.qtype}
				];							 
							 
				if (p.params)
					{
						for (var pi = 0; pi < p.params.length; pi++) param[param.length] = p.params[pi];
					}
				
					$.ajax({
					   type: p.method,
					   url: p.url,
					   data: param,
					   dataType: p.dataType,
					   success: function(data){g.addData(data);},
					   error: function(XMLHttpRequest, textStatus, errorThrown) { try { if (p.onError) p.onError(XMLHttpRequest, textStatus, errorThrown); } catch (e) {} }
					 });
			},
			doSearch: function () {
				p.query = $('input[name=q]',g.sDiv).val();
				p.qtype = $('select[name=qtype]',g.sDiv).val();
				p.newp = 1;

				this.populate();				
			},
			changePage: function (ctype){ //change page
			
				if (this.loading) return true;
			
				switch(ctype)
				{
					case 'first': p.newp = 1; break;
					case 'prev': if (p.page>1) p.newp = parseInt(p.page) - 1; break;
					case 'next': if (p.page<p.pages) p.newp = parseInt(p.page) + 1; break;
					case 'last': p.newp = p.pages; break;
					case 'input': 
							var nv = parseInt($('.pcontrol input',this.pDiv).val());
							if (isNaN(nv)) nv = 1;
							if (nv<1) nv = 1;
							else if (nv > p.pages) nv = p.pages;
							$('.pcontrol input',this.pDiv).val(nv);
							p.newp =nv;
							break;
				}
			
				if (p.newp==p.page) return false;
				
				if (p.onChangePage) 
					p.onChangePage(p.newp);
				else				
					this.populate();
			
			},
			addCellProp: function ()
			{
				
					$('tbody tr td',g.bDiv).each
					(
						function ()
							{
									var tdDiv = document.createElement('div');
									var n = $('td',$(this).parent()).index(this);
									var pth = $('th:eq('+n+')',g.hDiv).get(0);
			
									if (pth!=null)
									{
									if (p.sortname==$(pth).attr('abbr')&&p.sortname) 
										{
										this.className = 'sorted';
										}
									 $(tdDiv).css({textAlign:pth.align,width: $('div:first',pth)[0].style.width});
									 
									 if (pth.hide) $(this).css('display','none');
									 
									 }
									 
									 if (p.nowrap==false) $(tdDiv).css('white-space','normal');
									 
									 if (this.innerHTML=='') this.innerHTML = '&nbsp;';
									 
									 //tdDiv.value = this.innerHTML; //store preprocess value
									 tdDiv.innerHTML = this.innerHTML;
									 
									 var prnt = $(this).parent()[0];
									 var pid = false;
									 if (prnt.id) pid = prnt.id.substr(3);
									 
									 if (pth!=null)
									 {
									 if (pth.process) pth.process(tdDiv,pid);
									 }
									 
									$(this).empty().append(tdDiv).removeAttr('width'); //wrap content

									//add editable event here 'dblclick'

							}
					);
					
			},
			getCellDim: function (obj) // get cell prop for editable event
			{
				var ht = parseInt($(obj).height());
				var pht = parseInt($(obj).parent().height());
				var wt = parseInt(obj.style.width);
				var pwt = parseInt($(obj).parent().width());
				var top = obj.offsetParent.offsetTop;
				var left = obj.offsetParent.offsetLeft;
				var pdl = parseInt($(obj).css('paddingLeft'));
				var pdt = parseInt($(obj).css('paddingTop'));
				return {ht:ht,wt:wt,top:top,left:left,pdl:pdl, pdt:pdt, pht:pht, pwt: pwt};
			},
			addRowProp: function()
			{
					$('tbody tr',g.bDiv).each
					(
						function ()
							{
							$(this)
							.click(
								function (e) 
									{ 
										var obj = (e.target || e.srcElement); if (obj.href || obj.type) return true;
										$(this).toggleClass('trSelected');
										if (p.singleSelect) $(this).siblings().removeClass('trSelected');
									}
							)
							.mousedown(
								function (e)
									{
										if (e.shiftKey)
										{
										$(this).toggleClass('trSelected'); 
										g.multisel = true; 
										this.focus();
										$(g.gDiv).noSelect();
										}
									}
							)
							.mouseup(
								function ()
									{
										if (g.multisel)
										{
										g.multisel = false;
										$(g.gDiv).noSelect(false);
										}
									}
							)
							.hover(
								function (e) 
									{ 
									if (g.multisel) 
										{
										$(this).toggleClass('trSelected'); 
										}
									},
								function () {}						
							)
							;
							
							if ($.browser.msie&&$.browser.version<7.0)
								{
									$(this)
									.hover(
										function () { $(this).addClass('trOver'); },
										function () { $(this).removeClass('trOver'); }
									)
									;
								}
							}
					);
					
					
			},
			pager: 0
			};		
		
		//create model if any
		if (p.colModel)
		{
			thead = document.createElement('thead');
			tr = document.createElement('tr');
			
			for (i=0;i<p.colModel.length;i++)
				{
					var cm = p.colModel[i];
					var th = document.createElement('th');

					th.innerHTML = cm.display;
					
					if (cm.name&&cm.sortable)
						$(th).attr('abbr',cm.name);
					
					//th.idx = i;
					$(th).attr('axis','col'+i);
					
					if (cm.align)
						th.align = cm.align;
						
					if (cm.width) 
						$(th).attr('width',cm.width);

					if (cm.hide)
						{
						th.hide = true;
						}
						
					if (cm.process)
						{
							th.process = cm.process;
						}

					$(tr).append(th);
				}
			$(thead).append(tr);
			$(t).prepend(thead);
		} // end if p.colmodel	

		//init divs
		g.gDiv = document.createElement('div'); //create global container
		g.mDiv = document.createElement('div'); //create title container
		g.hDiv = document.createElement('div'); //create header container
		g.bDiv = document.createElement('div'); //create body container
		g.vDiv = document.createElement('div'); //create grip
		g.rDiv = document.createElement('div'); //create horizontal resizer
		g.cDrag = document.createElement('div'); //create column drag
		g.block = document.createElement('div'); //creat blocker
		g.nDiv = document.createElement('div'); //create column show/hide popup
		g.nBtn = document.createElement('div'); //create column show/hide button
		g.iDiv = document.createElement('div'); //create editable layer
		g.tDiv = document.createElement('div'); //create toolbar
		g.sDiv = document.createElement('div');
		
		if (p.usepager) g.pDiv = document.createElement('div'); //create pager container
		g.hTable = document.createElement('table');

		//set gDiv
		g.gDiv.className = 'flexigrid';
		if (p.width!='auto') g.gDiv.style.width = p.width + 'px';

		//add conditional classes
		if ($.browser.msie)
			$(g.gDiv).addClass('ie');
		
		if (p.novstripe)
			$(g.gDiv).addClass('novstripe');

		$(t).before(g.gDiv);
		$(g.gDiv)
		.append(t)
		;

		//set toolbar
		if (p.buttons) 
		{
			g.tDiv.className = 'tDiv';
			var tDiv2 = document.createElement('div');
			tDiv2.className = 'tDiv2';
			
			for (i=0;i<p.buttons.length;i++)
				{
					var btn = p.buttons[i];
					if (!btn.separator)
					{
						var btnDiv = document.createElement('div');
						btnDiv.className = 'fbutton';
						btnDiv.innerHTML = "<div><span>"+btn.name+"</span></div>";
						if (btn.bclass) 
							$('span',btnDiv)
							.addClass(btn.bclass)
							.css({paddingLeft:20})
							;
						btnDiv.onpress = btn.onpress;
						btnDiv.name = btn.name;
						if (btn.onpress)
						{
							$(btnDiv).click
							(	
								function () 
								{
								this.onpress(this.name,g.gDiv);
								}
							);
						}
						$(tDiv2).append(btnDiv);
						if ($.browser.msie&&$.browser.version<7.0)
						{
							$(btnDiv).hover(function(){$(this).addClass('fbOver');},function(){$(this).removeClass('fbOver');});
						}
						
					} else {
						$(tDiv2).append("<div class='btnseparator'></div>");
					}
				}
				$(g.tDiv).append(tDiv2);
				$(g.tDiv).append("<div style='clear:both'></div>");
				$(g.gDiv).prepend(g.tDiv);
		}
		
		//set hDiv
		g.hDiv.className = 'hDiv';

		$(t).before(g.hDiv);

		//set hTable
			g.hTable.cellPadding = 0;
			g.hTable.cellSpacing = 0;
			$(g.hDiv).append('<div class="hDivBox"></div>');
			$('div',g.hDiv).append(g.hTable);
			var thead = $("thead:first",t).get(0);
			if (thead) $(g.hTable).append(thead);
			thead = null;
		
		if (!p.colmodel) var ci = 0;

		//setup thead			
			$('thead tr:first th',g.hDiv).each
			(
			 	function ()
					{
						var thdiv = document.createElement('div');
						
						
					
						if ($(this).attr('abbr'))
							{
							$(this).click(
								function (e) 
									{
										
										if (!$(this).hasClass('thOver')) return false;
										var obj = (e.target || e.srcElement);
										if (obj.href || obj.type) return true; 
										g.changeSort(this);
									}
							)
							;
							
							if ($(this).attr('abbr')==p.sortname)
								{
								this.className = 'sorted';
								thdiv.className = 's'+p.sortorder;
								}
							}
							
							if (this.hide) $(this).hide();
							
							if (!p.colmodel)
							{
								$(this).attr('axis','col' + ci++);
							}
							
							
						 $(thdiv).css({textAlign:this.align, width: this.width + 'px'});
						 thdiv.innerHTML = this.innerHTML;
						 
						$(this).empty().append(thdiv).removeAttr('width')
						.mousedown(function (e) 
							{
								g.dragStart('colMove',e,this);
							})
						.hover(
							function(){
								if (!g.colresize&&!$(this).hasClass('thMove')&&!g.colCopy) $(this).addClass('thOver');
								
								if ($(this).attr('abbr')!=p.sortname&&!g.colCopy&&!g.colresize&&$(this).attr('abbr')) $('div',this).addClass('s'+p.sortorder);
								else if ($(this).attr('abbr')==p.sortname&&!g.colCopy&&!g.colresize&&$(this).attr('abbr'))
									{
										var no = '';
										if (p.sortorder=='asc') no = 'desc';
										else no = 'asc';
										$('div',this).removeClass('s'+p.sortorder).addClass('s'+no);
									}
								
								if (g.colCopy) 
									{
									var n = $('th',g.hDiv).index(this);
									
									if (n==g.dcoln) return false;
									
									
									
									if (n<g.dcoln) $(this).append(g.cdropleft);
									else $(this).append(g.cdropright);
									
									g.dcolt = n;
									
									} else if (!g.colresize) {
										
									var nv = $('th:visible',g.hDiv).index(this);
									var onl = parseInt($('div:eq('+nv+')',g.cDrag).css('left'));
									var nw = jQuery(g.nBtn).outerWidth();
									nl = onl - nw + Math.floor(p.cgwidth/2);
									
									$(g.nDiv).hide();$(g.nBtn).hide();
									
									$(g.nBtn).css({'left':nl,top:g.hDiv.offsetTop}).show();
									
									var ndw = parseInt($(g.nDiv).width());
									
									$(g.nDiv).css({top:g.bDiv.offsetTop});
									
									if ((nl+ndw)>$(g.gDiv).width())
										$(g.nDiv).css('left',onl-ndw+1);
									else
										$(g.nDiv).css('left',nl);
										
									if ($(this).hasClass('sorted')) 
										$(g.nBtn).addClass('srtd');
									else
										$(g.nBtn).removeClass('srtd');
										
									}
									
							},
							function(){
								$(this).removeClass('thOver');
								if ($(this).attr('abbr')!=p.sortname) $('div',this).removeClass('s'+p.sortorder);
								else if ($(this).attr('abbr')==p.sortname)
									{
										var no = '';
										if (p.sortorder=='asc') no = 'desc';
										else no = 'asc';
										
										$('div',this).addClass('s'+p.sortorder).removeClass('s'+no);
									}
								if (g.colCopy) 
									{								
									$(g.cdropleft).remove();
									$(g.cdropright).remove();
									g.dcolt = null;
									}
							})
						; //wrap content
					}
			);

		//set bDiv
		g.bDiv.className = 'bDiv';
		$(t).before(g.bDiv);
		$(g.bDiv)
		.css({ height: (p.height=='auto') ? 'auto' : p.height+"px"})
		.scroll(function (e) {g.scroll()})
		.append(t)
		;
		
		if (p.height == 'auto') 
			{
			$('table',g.bDiv).addClass('autoht');
			}


		//add td properties
		g.addCellProp();
		
		//add row properties
		g.addRowProp();
		
		//set cDrag
		
		var cdcol = $('thead tr:first th:first',g.hDiv).get(0);
		
		if (cdcol != null)
		{		
		g.cDrag.className = 'cDrag';
		g.cdpad = 0;
		
		g.cdpad += (isNaN(parseInt($('div',cdcol).css('borderLeftWidth'))) ? 0 : parseInt($('div',cdcol).css('borderLeftWidth'))); 
		g.cdpad += (isNaN(parseInt($('div',cdcol).css('borderRightWidth'))) ? 0 : parseInt($('div',cdcol).css('borderRightWidth'))); 
		g.cdpad += (isNaN(parseInt($('div',cdcol).css('paddingLeft'))) ? 0 : parseInt($('div',cdcol).css('paddingLeft'))); 
		g.cdpad += (isNaN(parseInt($('div',cdcol).css('paddingRight'))) ? 0 : parseInt($('div',cdcol).css('paddingRight'))); 
		g.cdpad += (isNaN(parseInt($(cdcol).css('borderLeftWidth'))) ? 0 : parseInt($(cdcol).css('borderLeftWidth'))); 
		g.cdpad += (isNaN(parseInt($(cdcol).css('borderRightWidth'))) ? 0 : parseInt($(cdcol).css('borderRightWidth'))); 
		g.cdpad += (isNaN(parseInt($(cdcol).css('paddingLeft'))) ? 0 : parseInt($(cdcol).css('paddingLeft'))); 
		g.cdpad += (isNaN(parseInt($(cdcol).css('paddingRight'))) ? 0 : parseInt($(cdcol).css('paddingRight'))); 

		$(g.bDiv).before(g.cDrag);
		
		var cdheight = $(g.bDiv).height();
		var hdheight = $(g.hDiv).height();
		
		$(g.cDrag).css({top: -hdheight + 'px'});
		
		$('thead tr:first th',g.hDiv).each
			(
			 	function ()
					{
						var cgDiv = document.createElement('div');
						$(g.cDrag).append(cgDiv);
						if (!p.cgwidth) p.cgwidth = $(cgDiv).width();
						$(cgDiv).css({height: cdheight + hdheight})
						.mousedown(function(e){g.dragStart('colresize',e,this);})
						;
						if ($.browser.msie&&$.browser.version<7.0)
						{
							g.fixHeight($(g.gDiv).height());
							$(cgDiv).hover(
								function () 
								{
								g.fixHeight();
								$(this).addClass('dragging') 
								},
								function () { if (!g.colresize) $(this).removeClass('dragging') }
							);
						}
					}
			);
		
		//g.rePosDrag();
							
		}
		

		//add strip		
		if (p.striped) 
			$('tbody tr:odd',g.bDiv).addClass('erow');
			
			
		if (p.resizable && p.height !='auto') 
		{
		g.vDiv.className = 'vGrip';
		$(g.vDiv)
		.mousedown(function (e) { g.dragStart('vresize',e)})
		.html('<span></span>');
		$(g.bDiv).after(g.vDiv);
		}
		
		if (p.resizable && p.width !='auto' && !p.nohresize) 
		{
		g.rDiv.className = 'hGrip';
		$(g.rDiv)
		.mousedown(function (e) {g.dragStart('vresize',e,true);})
		.html('<span></span>')
		.css('height',$(g.gDiv).height())
		;
		if ($.browser.msie&&$.browser.version<7.0)
		{
			$(g.rDiv).hover(function(){$(this).addClass('hgOver');},function(){$(this).removeClass('hgOver');});
		}
		$(g.gDiv).append(g.rDiv);
		}
		
		// add pager
		if (p.usepager)
		{
		g.pDiv.className = 'pDiv';
		g.pDiv.innerHTML = '<div class="pDiv2"></div>';
		$(g.bDiv).after(g.pDiv);
		var html = ' <div class="pGroup"> <div class="pFirst pButton"><span></span></div><div class="pPrev pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"><span class="pcontrol">'+p.pagetext+' <input type="text" size="4" value="1" /> '+p.outof+' <span> 1 </span></span></div> <div class="btnseparator"></div> <div class="pGroup"> <div class="pNext pButton"><span></span></div><div class="pLast pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"> <div class="pReload pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"><span class="pPageStat"></span></div>';
		$('div',g.pDiv).html(html);
		
		$('.pReload',g.pDiv).click(function(){g.populate()});
		$('.pFirst',g.pDiv).click(function(){g.changePage('first')});
		$('.pPrev',g.pDiv).click(function(){g.changePage('prev')});
		$('.pNext',g.pDiv).click(function(){g.changePage('next')});
		$('.pLast',g.pDiv).click(function(){g.changePage('last')});
		$('.pcontrol input',g.pDiv).keydown(function(e){if(e.keyCode==13) g.changePage('input')});
		if ($.browser.msie&&$.browser.version<7) $('.pButton',g.pDiv).hover(function(){$(this).addClass('pBtnOver');},function(){$(this).removeClass('pBtnOver');});
			
			if (p.useRp)
			{
			var opt = "";
			for (var nx=0;nx<p.rpOptions.length;nx++)
			{
				if (p.rp == p.rpOptions[nx]) sel = 'selected="selected"'; else sel = '';
				 opt += "<option value='" + p.rpOptions[nx] + "' " + sel + " >" + p.rpOptions[nx] + "&nbsp;&nbsp;</option>";
			};
			$('.pDiv2',g.pDiv).prepend("<div class='pGroup'><select name='rp'>"+opt+"</select></div> <div class='btnseparator'></div>");
			$('select',g.pDiv).trigger(
					function ()
					{
						if (p.onRpChange) 
							p.onRpChange(+this.value);
						else
							{
							p.newp = 1;
							p.rp = +this.value;
							g.populate();
							}
					}
				);
			}
		
		//add search button
		if (p.searchitems)
			{
				$('.pDiv2',g.pDiv).prepend("<div class='pGroup'> <div class='pSearch pButton'><span></span></div> </div>  <div class='btnseparator'></div>");
				$('.pSearch',g.pDiv).click(function(){$(g.sDiv).slideToggle('fast',function(){$('.sDiv:visible input:first',g.gDiv).trigger('focus');});});				
				//add search box
				g.sDiv.className = 'sDiv';
				
				sitems = p.searchitems;
				
				var sopt = "";
				for (var s = 0; s < sitems.length; s++)
				{
					if (p.qtype=='' && sitems[s].isdefault==true)
					{
					p.qtype = sitems[s].name;
					sel = 'selected="selected"';
					} else sel = '';
					sopt += "<option value='" + sitems[s].name + "' " + sel + " >" + sitems[s].display + "&nbsp;&nbsp;</option>";						
				}
				
				if (p.qtype=='') p.qtype = sitems[0].name;
				
				$(g.sDiv).append("<div class='sDiv2'>"+p.findtext+" <input type='text' size='30' name='q' class='qsbox' /> <select name='qtype'>"+sopt+"</select> <!--input type='button' value='Clear' /--></div>");

				$('input[name=q],select[name=qtype]',g.sDiv).keydown(function(e){if(e.keyCode==13) g.doSearch()});
				$('input[value=Clear]',g.sDiv).click(function(){$('input[name=q]',g.sDiv).val(''); p.query = ''; g.doSearch(); });
				$(g.bDiv).after(g.sDiv);				
				
			}
		
		}
		$(g.pDiv,g.sDiv).append("<div style='clear:both'></div>");
	
		// add title
		if (p.title)
		{
			g.mDiv.className = 'mDiv';
			g.mDiv.innerHTML = '<div class="ftitle">'+p.title+'</div>';
			$(g.gDiv).prepend(g.mDiv);
			if (p.showTableToggleBtn)
				{
					$(g.mDiv).append('<div class="ptogtitle" title="Minimize/Maximize Table"><span></span></div>');
					$('div.ptogtitle',g.mDiv).click
					(
					 	function ()
							{
								$(g.gDiv).toggleClass('hideBody');
								$(this).toggleClass('vsble');
							}
					);
				}
			//g.rePosDrag();
		}

		//setup cdrops
		g.cdropleft = document.createElement('span');
		g.cdropleft.className = 'cdropleft';
		g.cdropright = document.createElement('span');
		g.cdropright.className = 'cdropright';

		//add block
		g.block.className = 'gBlock';
		var gh = $(g.bDiv).height();
		var gtop = g.bDiv.offsetTop;
		$(g.block).css(
		{
			width: g.bDiv.style.width,
			height: gh,
			background: 'white',
			position: 'relative',
			marginBottom: (gh * -1),
			zIndex: 1,
			top: gtop,
			left: '0px'
		}
		);
		$(g.block).fadeTo(0,p.blockOpacity);				
		
		// add column control
		if ($('th',g.hDiv).length)
		{
			
			g.nDiv.className = 'nDiv';
			g.nDiv.innerHTML = "<table cellpadding='0' cellspacing='0'><tbody></tbody></table>";
			$(g.nDiv).css(
			{
				marginBottom: (gh * -1),
				display: 'none',
				top: gtop
			}
			).noSelect()
			;
			
			var cn = 0;
			
			
			$('th div',g.hDiv).each
			(
			 	function ()
					{
						var kcol = $("th[axis='col" + cn + "']",g.hDiv)[0];
						var chk = 'checked="checked"';
						if (kcol.style.display=='none') chk = '';
						
						$('tbody',g.nDiv).append('<tr><td class="ndcol1"><input type="checkbox" '+ chk +' class="togCol" value="'+ cn +'" /></td><td class="ndcol2">'+this.innerHTML+'</td></tr>');
						cn++;
					}
			);
			
			if ($.browser.msie&&$.browser.version<7.0)
				$('tr',g.nDiv).hover
				(
				 	function () {$(this).addClass('ndcolover');},
					function () {$(this).removeClass('ndcolover');}
				);
			
			$('td.ndcol2',g.nDiv).click
			(
			 	function ()
					{
						if ($('input:checked',g.nDiv).length<=p.minColToggle&&$(this).prev().find('input')[0].checked) return false;
						return g.toggleCol($(this).prev().find('input').val());
					}
			);
			
			$('input.togCol',g.nDiv).click
			(
			 	function ()
					{
						
						if ($('input:checked',g.nDiv).length<p.minColToggle&&this.checked==false) return false;
						$(this).parent().next().triggerHandler('click');
						//return false;
					}
			);


			$(g.gDiv).prepend(g.nDiv);
			
			$(g.nBtn).addClass('nBtn')
			.html('<div></div>')
			.attr('title','Hide/Show Columns')
			.click
			(
			 	function ()
				{
			 	$(g.nDiv).toggle(); return true;
				}
			);
			
			if (p.showToggleBtn) $(g.gDiv).prepend(g.nBtn);
			
		}
		
		// add date edit layer
		$(g.iDiv)
		.addClass('iDiv')
		.css({display:'none'})
		;
		$(g.bDiv).append(g.iDiv);
		
		// add flexigrid events
		$(g.bDiv)
		.hover(function(){$(g.nDiv).hide();$(g.nBtn).hide();},function(){if (g.multisel) g.multisel = false;})
		;
		$(g.gDiv)
		.hover(function(){},function(){$(g.nDiv).hide();$(g.nBtn).hide();})
		;
		
		//add document events
		$(document)
		.mousemove(function(e){g.dragMove(e)})
		.mouseup(function(e){g.dragEnd()})
		.hover(function(){},function (){g.dragEnd()})
		;
		
		//browser adjustments
		if ($.browser.msie&&$.browser.version<7.0)
		{
			$('.hDiv,.bDiv,.mDiv,.pDiv,.vGrip,.tDiv, .sDiv',g.gDiv)
			.css({width: '100%'});
			$(g.gDiv).addClass('ie6');
			if (p.width!='auto') $(g.gDiv).addClass('ie6fullwidthbug');			
		} 
		
		g.rePosDrag();
		g.fixHeight();
		
		//make grid functions accessible
		t.p = p;
		t.grid = g;
		
		// load data
		if (p.url&&p.autoload) 
			{
			g.populate();
			}
		
		return t;		
			
	};

	var docloaded = false;

	$(document).ready(function () {docloaded = true} );

	$.fn.flexigrid = function(p) {

		return this.each( function() {
				if (!docloaded)
				{
					$(this).hide();
					var t = this;
					$(document).ready
					(
						function ()
						{
						$.addFlex(t,p);
						}
					);
				} else {
					$.addFlex(this,p);
				}
			});

	}; //end flexigrid

	$.fn.flexReload = function(p) { // function to reload grid

		return this.each( function() {
				if (this.grid&&this.p.url) this.grid.populate();
			});

	}; //end flexReload

	$.fn.flexOptions = function(p) { //function to update general options

		return this.each( function() {
				if (this.grid) $.extend(this.p,p);
			});

	}; //end flexOptions

	$.fn.flexToggleCol = function(cid,visible) { // function to reload grid

		return this.each( function() {
				if (this.grid) this.grid.toggleCol(cid,visible);
			});

	}; //end flexToggleCol

	$.fn.flexAddData = function(data) { // function to add data to grid

		return this.each( function() {
				if (this.grid) this.grid.addData(data);
			});

	};

	$.fn.noSelect = function(p) { //no select plugin by me :-)

		if (p == null) 
			prevent = true;
		else
			prevent = p;

		if (prevent) {
		
		return this.each(function ()
			{
				if ($.browser.msie||$.browser.safari) $(this).bind('selectstart',function(){return false;});
				else if ($.browser.mozilla) 
					{
						$(this).css('MozUserSelect','none');
						$('body').trigger('focus');
					}
				else if ($.browser.opera) $(this).bind('mousedown',function(){return false;});
				else $(this).attr('unselectable','on');
			});
			
		} else {

		
		return this.each(function ()
			{
				if ($.browser.msie||$.browser.safari) $(this).unbind('selectstart');
				else if ($.browser.mozilla) $(this).css('MozUserSelect','inherit');
				else if ($.browser.opera) $(this).unbind('mousedown');
				else $(this).removeAttr('unselectable','on');
			});
		
		}

	}; //end noSelect
		
})(jQuery);
(function(a) {
	a.fn.custCheckBox = function(b) {
		var d = {
			disable_all : false,
			hover : true,
			wrapperclass : "group",
			callback : function() {
			}
		};
		var c = a.extend(d, b);
		return this.each(function() {
			var e = a(this);
			a.fn.buildbox = function(f) {
				if ($.modTool.broswerFlag == "IE6" || $.modTool.broswerFlag == "IE7" || $.modTool.broswerFlag == "IE8") {
					a(f).css({
						display : "none"
					}).before('<span class="cust_checkbox">&nbsp;&nbsp;</span>')
				} else {
					a(f).css({
						display : "none"
					}).before('<span class="cust_checkbox">&nbsp;&nbsp;</span>')
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
					cursor : "pointer"
				});

				a(f).prev("span").prev("label").unbind().click(function() {
					a(f).triggerHandler('click',[e]);
					if (!c.disable_all) {
						var l = a(this).next("span");
						var j = a(l).next("input").attr("type");
						var k = a(l).next("input").attr("disabled");
						if (a(l).hasClass("checkbox")) {
							if (a(l).hasClass("cust_" + j + "_off") && !k) {
								if ($.modTool.broswerFlag == "IE6" || $.modTool.broswerFlag == "IE7" || $.modTool.broswerFlag == "IE8") {
									a(l).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").attr("checked", "checked")
								} else {
									a(l).removeClass("cust_" + j + "_off").removeClass("cust_" + j + "_hvr").addClass("cust_" + j + "_on").next("input").removeAttr("checked")
								}
							} else {
								if (!k) {
									if ($.modTool.broswerFlag == "IE6" || $.modTool.broswerFlag == "IE7" || $.modTool.broswerFlag == "IE8") {
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
						c.callback.call(this);
						a(l).next("input").triggerHandler('change',[e]);
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
				}, function() {
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
					a(f).triggerHandler('click',[e]);
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
						c.callback.call(this);
						$(this).next("input").triggerHandler('change',[e]);
					}
				}).hover(function() {
					if (a(this).hasClass("cust_checkbox_off") && c.hover) {
						a(this).addClass("cust_checkbox_hvr")
					} else {
						if (a(this).hasClass("cust_radio_off") && c.hover) {
							a(this).addClass("cust_radio_hvr")
						}
					}
				}, function() {
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
(function(c) {
	var h, i;
	var d = 0;
	var a = 32;
	var e;
	c.fn.TextAreaResizer = function() {
		return this.each(function() {
			h = c(this).addClass("processed"), i = null;
			c(this).wrap('<div class="resizable-textarea"><span></span></div>').parent().append(c('<div class="grippie"></div>').bind("mousedown", {
				el : this
			}, b));
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
			x : k.clientX + document.documentElement.scrollLeft,
			y : k.clientY + document.documentElement.scrollTop
		}
	}

})(jQuery);
(function(a) {
	a.fn.watermark = function(b, c) {
		return this.each(function() {
			var e = a(this), d;
			e.focus(function() {
				d && !( d = 0) && e.removeClass(b).data("w", 0).val("")
			}).blur(function() {
				! e.val() && ( d = 1) && e.addClass(b).data("w", 1).val(c)
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
(function(a) {
	a.rebrushfileupload = {
		defaults : {
			button_text : " ",
			class_container : "fileupload-rebrush",
			class_field : "fileupload-rebrush-field",
			class_button : "fileupload-rebrush-button"
		}
	};
	a.fn.extend({
		rebrushfileupload : function(d) {
			d = a.extend({}, a.rebrushfileupload.defaults, d);
			var e = ["padding-left", "padding-right", "margin-left", "margin-right", "border-left-width", "border-right-width"];
			a(this).wrap('<div class="file-container"/>');
			var g = a(this).parent();
			g.prepend('<input type="text" value="" readonly="readonly" /><input type="button" class="fileBtn" value="' + d.button_text + '" />');
			var i = g.find("input[type=text]");
			var b = g.find("input[type=button]");
			var f = 0;
			for (var h in e) {
				var c = Math.round(parseFloat(i.css(e[h]) + 0)) + 0;
				var j = Math.round(parseFloat(b.css(e[h]) + 0)) + 0;
				f += (isNaN(c) ? 0 : c) + (isNaN(j) ? 0 : j)
			}
			f += Math.round(parseFloat(i.width())) + Math.round(parseFloat(b.width()));
			if (a.browser.msie) {
				i.width(a(this).width() - 65);
				g.css({
					position : "relative",
					width : a(this).width() + 10,
					overflow : "hidden"
				})
			} else {
				i.width(a(this).width() - 90);
				g.css({
					position : "relative",
					width : a(this).width(),
					overflow : "hidden"
				})
			}
			if ($.modTool.broswerFlag != "IE8") {
				a(this).css({
					position : "absolute",
					"z-index" : 2,
					"font-size" : "12px",
					opacity : "0",
					left : "0px",
					top : "0px"
				})
			} else {
				a(this).css({
					position : "absolute",
					"z-index" : 2,
					"font-size" : "12px",
					opacity : "0",
					left : "0px",
					top : "-18px"
				})
			}
			a(this).change(function() {
				a(this).parent().find("input[type=text]").val(a(this).val());
				if (a(this).attr("showInfo") != "false") {
					try {
						a(this).attr("title", a(this).val());
						$.modTool.enableTooltips()
					} catch(k) {
					}
				}
			})
		}
	})
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
			var g = f.outerHeight(), k = f.outerHeight();
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

})(jQuery);
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
(function(a) {
	a.fn.maxlength = function(b) {
		var c = jQuery.extend({
			events : [],
			maxCharacters : 10,
			status : true,
			statusClass : "maxNum",
			statusText : "",
			notificationClass : "notification",
			showAlert : false,
			alertText : "",
			slider : true
		}, b);
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
			a.each(c.events, function(k, l) {
				g.bind(l, function(m) {
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
(function(a) {
	jQuery.SelectBox = function(F, g) {
		var c = g || {};
		c.inputClass = c.inputClass || "selectbox";
		c.containerClass = c.containerClass || "selectbox-wrapper";
		c.hoverClass = c.hoverClass || "current";
		c.currentClass = c.selectedClass || "selected";
		c.debug = c.debug || false;
		$.modTool.elm_id++;
		var i = 0;
		var e = false;
		var D = 0;
		var A = $(F);
		var x = k(c);
		var p = B();
		var d = q(c);
		var w = false;
		var v = false;
		var j = 1;
		var E;
		var C = 0;
		var G = 0;
		if (window.navigator.userAgent.indexOf("Windows") > -1) {
			G = 1
		}
		C = A.width();
		if(C == "0"){
			for(var i = F.options.length - 1;i >= 0;i--){
				C < F.options[i].innerHTML.length * 20 && (C = F.options[i].innerHTML.length * 20);
			}
		}

		if (C == "0") {
			C = 70
		}
		var n;
		if (G == 1) {
			if ($.modTool.broswerFlag == "Safari") {
				n = $("<input type='button' value=' ' class='selBtn_safari'/>")
			} else {
				n = $("<input type='button' value=' ' class='selBtn'/>")
			}
		} else {
			n = $("<input type='button' value=' ' class='selBtn_linux'/>")
		}
		if (A.attr("disabled")) {
			n.attr("disabled", true);
			n.addClass("selBtn_disabled")
		}
		var u = $("<div class='loader'>加载中.</div>");
		if (A.attr("autoWidth") != null) {
			if (A.attr("autoWidth") == "true") {
				w = true
			} else {
				w = false
			}
		}
		if (A.attr("colNum") != null) {
			j = parseInt(A.attr("colNum"))
		}
		if (A.attr("colWidth") != null) {
			E = Number(A.attr("colWidth"))
		}
		if (j != 1) {
			if (w) {
				d.width(C - 20)
			} else {
				d.width(96)
			}
			if (E != null) {
				x.width(E * j + 40)
			} else {
				var b = Number(C);
				x.width(b * j + 40)
			}
		} else {
			if (w) {
				d.width(C - 20);
				x.width(C + 6)
			} else {
				d.width(96);
				var f = 96 + 4 + 22;
				var b = Number(C);
				x.width(Math.max(f, b))
			}
		}
		A.hide().before(p);
		p.append(d);
		p.append(n);
		p.append(x);
		p.append(u);
		u.hide();
		y();
		if (A.attr("editable") != null) {
			if (A.attr("editable") == "true") {
				v = true
			} else {
				v = false
			}
		}
		if (!v) {
			d.css({
				cursor : "pointer"
			});
			d.click(function() {
				var L;
				var J = x.find("li").length;
				if (j == 1) {
					L = J * 26
				} else {
					if (J % j == 0) {
						L = J * 26 / j
					} else {
						L = (J - J % j) * 26 / j + 26
					}
				}
				x.height(L);
				var H = 200;
				if ($.modTool.parentTopHeight > 0) {
					var K = window.top.document.documentElement.clientHeight;
					H = K - $.modTool.parentTopHeight - $.modTool.parentBottomHeight - p.offset().top - 30
				} else {
					H = window.document.documentElement.clientHeight - (p.offset().top - $(window).scrollTop()) - 30
				}
				if (H < x.height()) {
					if (p.offset().top > x.height()) {
						if ($.modTool.broswerFlag == "IE8") {
							x.css({
								top : -x.height() - 17
							})
						} else {
							if ($.browser.msie) {
								x.css({
									top : -x.height()
								})
							} else {
								x.css({
									top : -x.height() - 7
								})
							}
						}
					} else {
						if (H < 100 && p.offset().top > H) {
							x.height(p.offset().top);
							x.css({
								overflow : "auto"
							});
							if ($.modTool.broswerFlag == "IE8") {
								x.css({
									top : -x.height() - 17
								})
							} else {
								if ($.browser.msie) {
									x.css({
										top : -x.height()
									})
								} else {
									x.css({
										top : -x.height() - 7
									})
								}
							}
						} else {
							x.css({
								overflow : "auto"
							});
							if ($.modTool.broswerFlag == "IE8") {
								x.css({
									top : 8
								})
							} else {
								if ($.browser.msie) {
									x.css({
										top : 25
									})
								} else {
									x.css({
										top : 18
									})
								}
							}
							x.height(H)
						}
					}
				} else {
					if ($.modTool.broswerFlag == "IE8") {
						x.css({
							top : 8
						})
					} else {
						if ($.browser.msie) {
							x.css({
								top : 25
							})
						} else {
							x.css({
								top : 18
							})
						}
					}
				}
				if (!e) {
					$.modTool.depth++;
					p.css({
						zIndex : $.modTool.depth
					});
					setTimeout(I, 100)
				}
				function I() {
					x.toggle()
				}

			}).focus(function() {
				if (x.not(":visible")) {
					$.modTool.depth++;
					p.css({
						zIndex : $.modTool.depth
					});
					e = true;
					setTimeout(H, 100)
				}
				function H() {
					x.show()
				}

			}).keydown(function(H) {
				switch (H.keyCode) {
					case 38:
						H.preventDefault();
						o(-1);
						break;
					case 40:
						H.preventDefault();
						o(1);
						break;
					case 13:
						H.preventDefault();
						$("li." + c.hoverClass).trigger("click");
						break;
					case 27:
						l();
						break
				}
			}).blur(function() {
				if (x.is(":visible") && D > 0) {
				} else {
					l()
				}
			})
		} else {
			d.css({
				cursor : "text"
			});
			d.change(function() {
				A.attr("editValue", $(this).val())
			})
		}
		n.click(function() {
			var L;
			var J = x.find("li").length;
			if (j == 1) {
				L = J * 26
			} else {
				if (J % j == 0) {
					L = J * 26 / j
				} else {
					L = (J - J % j) * 26 / j + 26
				}
			}
			x.height(L);
			var I = 200;
			if ($.modTool.parentTopHeight > 0) {
				var K = window.top.document.documentElement.clientHeight;
				I = K - $.modTool.parentTopHeight - $.modTool.parentBottomHeight - p.offset().top - 30
			} else {
				I = window.document.documentElement.clientHeight - (p.offset().top - $(window).scrollTop()) - 30
			}
			if (I < x.height()) {
				if (p.offset().top > x.height()) {
					if ($.modTool.broswerFlag == "IE8") {
						x.css({
							top : -x.height() - 17
						})
					} else {
						if ($.browser.msie) {
							x.css({
								top : -x.height()
							})
						} else {
							x.css({
								top : -x.height() - 7
							})
						}
					}
				} else {
					if (I < 100 & p.offset().top > I) {
						x.height(p.offset().top);
						x.css({
							overflow : "auto"
						});
						if ($.modTool.broswerFlag == "IE8") {
							x.css({
								top : -x.height() - 17
							})
						} else {
							if ($.browser.msie) {
								x.css({
									top : -x.height()
								})
							} else {
								x.css({
									top : -x.height() - 7
								})
							}
						}
					} else {
						x.css({
							overflow : "auto"
						});
						if ($.modTool.broswerFlag == "IE8") {
							x.css({
								top : 8
							})
						} else {
							if ($.browser.msie) {
								x.css({
									top : 25
								})
							} else {
								x.css({
									top : 18
								})
							}
						}
						x.height(I)
					}
				}
			} else {
				if ($.modTool.broswerFlag == "IE8") {
					x.css({
						top : 8
					})
				} else {
					if ($.browser.msie) {
						x.css({
							top : 25
						})
					} else {
						x.css({
							top : 18
						})
					}
				}
			}
			if (!e) {
				$.modTool.depth++;
				p.css({
					zIndex : $.modTool.depth
				});
				setTimeout(H, 100)
			}
			function H() {
				x.toggle()
			}

		}).focus(function() {
			if (x.not(":visible")) {
				$.modTool.depth++;
				p.css({
					zIndex : $.modTool.depth
				});
				e = true;
				setTimeout(H, 100)
			}
			function H() {
				x.show()
			}

		}).keydown(function(H) {
			switch (H.keyCode) {
				case 38:
					H.preventDefault();
					o(-1);
					break;
				case 40:
					H.preventDefault();
					o(1);
					break;
				case 13:
					H.preventDefault();
					$("li." + c.hoverClass).trigger("click");
					break;
				case 27:
					l();
					break
			}
		}).blur(function() {
			if (x.is(":visible") && D > 0) {
			} else {
				l()
			}
		});
		function l() {
			D = 0;
			x.hide()
		}

		function y() {
			x.append(r(d.attr("id"))).hide();
			var H = d.css("width")
		}

		function B() {
			var H = $("<div></div>");
			H.addClass("mainCon");
			return H
		}

		function k(H) {
			var I = $("<div></div>");
			I.attr("id", $.modTool.elm_id + "_container");
			I.addClass(H.containerClass);
			I.css({});
			return I
		}

		function q(I) {
			var H = document.createElement("input");
			var K = $(H);
			K.attr("id", $.modTool.elm_id + "_input");
			K.attr("type", "text");
			K.addClass(I.inputClass);
			K.attr("autocomplete", "off");
			var J = false;
			if (A.attr("editable") != null) {
				if (A.attr("editable") == "true") {
					J = true
				} else {
					J = false
				}
			}
			if (!J) {
				K.attr("readonly", "readonly")
			} else {
				K.attr("readonly", false)
			}
			K.attr("tabIndex", A.attr("tabindex"));
			if (A.attr("disabled")) {
				K.attr("disabled", true);
				K.addClass("inputDisabled")
			}
			return K
		}

		function o(I) {
			var H = $("li", x);
			if (!H || H.length == 0) {
				return false
			}
			i += I;
			if (i < 0) {
				i = H.size()
			} else {
				if (i > H.size()) {
					i = 0
				}
			}
			a(H, i);
			H.removeClass(c.hoverClass);
			$(H[i]).addClass(c.hoverClass)
		}

		function a(I, J) {
			var H = $(I[J]).get(0);
			var I = x.get(0);
			if (H.offsetTop + H.offsetHeight > I.scrollTop + I.clientHeight) {
				I.scrollTop = H.offsetTop + H.offsetHeight - I.clientHeight
			} else {
				if (H.offsetTop < I.scrollTop) {
					I.scrollTop = H.offsetTop
				}
			}
		}

		function h() {
			var H = $("li." + c.currentClass, x).get(0);
			var I = (H.id).split("_");
			var K = I[0].length + I[1].length + 2;
			var L = H.id;
			var J = L.substr(K, L.length);
			A.val(J);
			A.attr("relText", $(H).text());
			d.val($(H).html());
			A.triggerHandler('click',[e]);
			if (v == true) {
				A.attr("editValue", d.val())
			}
			A.focus();
			return true
		}

		function s() {
			return A.val()
		}

		function m() {
			return d.val()
		}

		function r(N) {
			var O = new Array();
			var K = document.createElement("ul");
			var M = [];
			var I = 0;
			var H;
			if (A.attr("childId") != null) {
				H = true
			}
			var J = 1;
			var L;
			if (A.attr("colNum") != null) {
				J = parseInt(A.attr("colNum"))
			}
			if (A.attr("colWidth") != null) {
				L = Number(A.attr("colWidth"))
			}
			A.find("option").each(function() {
				M.push($(this)[0]);
				var P = document.createElement("li");
				P.setAttribute("id", N + "_" + $(this).val());
				P.innerHTML = $(this).html();
				if ($(this).is(":selected")) {
					var Q;
					if (A.attr("editable") != null) {
						if (A.attr("editable") == "true") {
							Q = true
						} else {
							Q = false
						}
					}
					if (Q == true) {
						d.val("");
						d.addClass("tipColor");
						d.focus(function() {
							if ($(this).val() == "") {
								$(this).val("");
								d.removeClass("tipColor")
							}
						});
						d.blur(function() {
							if ($(this).val() == "") {
								$(this).val("");
								d.addClass("tipColor")
							}
						})
					} else {
						d.val($(this).html());
						$(P).addClass(c.currentClass)
					}
				}
				if (J != 1) {
					$(P).addClass("li_left");
					if (L != null) {
						$(P).width(L)
					} else {
						var R = Number(C);
						$(P).width(R)
					}
				}
				K.appendChild(P);
				$(P).mouseover(function(S) {
					D = 1;
					jQuery(S.target, x).addClass(c.hoverClass)
				}).mouseout(function(S) {
					D = -1;
					jQuery(S.target, x).removeClass(c.hoverClass)
				}).click(function(T) {
					var U = $("li." + c.hoverClass, x).get(0);
					var S = $(this).attr("id").split("_");
					$("#" + S[0] + "_container li." + c.currentClass).removeClass(c.currentClass);
					$(this).addClass(c.currentClass);
					h();
					A.get(0).blur();
					l();
					A.triggerHandler('change',[e]);
					d.removeClass("tipColor");
					if (H) {
						t(A, A.val())
					}
				})
			});
			A.find("optgroup").each(function() {
				var Q = $.modTool.getPosition($(this).children("option").eq(0)[0], M);
				var P = $(this).attr("label");
				$(K).find("li").eq(Q + I).before("<li class='group'>" + P + "</li>");
				I++
			});
			return K
		}

		function t(J, I) {
			if (I != "") {
				var K = J.attr("childId");
				var H = $("#" + K).prev().find("div[class=loader]");
				H.show();
				window.setTimeout(function() {
					z(J, I)
				}, 200)
			}
		}

		function z(J, I) {
			var H;
			if (J.attr("childDataType") == null) {
				H = J.attr("childDataPath") + I
			} else {
				if (J.attr("childDataType") == "url") {
					H = J.attr("childDataPath") + I
				} else {
					H = J.attr("childDataPath") + I + "." + J.attr("childDataType")
				}
			}
			$.ajax({
				url : H,
				error : function() {
					try {
						top.Dialog.alert("")
					} catch(K) {
						alert("")
					}
				},
				success : function(N) {
					var K = J.attr("childId");
					var S = $("#" + K).prev().find("div[class=loader]");
					S.hide();
					var Q = $("#" + K).prev().find("ul");
					var M = $("#" + K).prev().find(">div").attr("id").split("_")[0];
					var L = $("#" + K).prev().find("input:text");
					var O = $("#" + K)[0];
					Q.html("");
					O.options.length = 0;
					$(N).find("node").each(function() {
						var V = $(this).attr("text");
						var U = $(this).attr("value");
						var T = document.createElement("li");
						$(T).text(V);
						$(T).attr("relValue", U);
						Q.append($(T));
						O.options[O.options.length] = new Option(V, U);
						$(T).mouseover(function(W) {
							jQuery(W.target).addClass(c.hoverClass)
						});
						$(T).mouseout(function(W) {
							jQuery(W.target).removeClass(c.hoverClass)
						});
						$(T).mousedown(function(X) {
							$("#" + M + "_container li." + c.currentClass).removeClass(c.currentClass);
							$(this).addClass(c.currentClass);
							$("#" + K).attr("relText", $(this).text());
							$("#" + K).val($(this).attr("relValue"));
							L.val($(this).html());
							$("#" + K).prev().find(">div").hide();
							$("#" + K).focus();
							if ($("#" + K).attr("onchange") != null) {
								$($("#" + K).attr("onchange"))
							}
							var W;
							if ($("#" + K).attr("childId") != null) {
								W = true
							}
							if (W) {
								t($("#" + K), $("#" + K).val())
							}
						})
					});
					if ($(N).find("node").length == 0) {
						var R = document.createElement("li");
						$(R).text("");
						Q.append($(R))
					}
					var P = Q.find("li").eq(0);
					L.val(P.text());
					P.addClass(c.currentClass);
					$("#" + K).attr("relValue", P.attr("relValue"));
					$("#" + K).attr("relText", P.text())
				}
			})
		}

	};
	a.fn.selectbox = function(a) {
		return this.each(function() {
			new jQuery.SelectBox(this, a)
		})
	};
})(jQuery);
(function(a) {
	a.fn.autoGrow = function() {
		return this.each(function() {
			$.modTool.setDefaultValues(this);
			$.modTool.bindEvents(this)
		})
	};
})(jQuery);
(function($){
	$.fn.refresh = function(){
			this.each(function(){
				var node = this.nodeName.toLowerCase();
				if(node == "input" || node == "button"){
					var t = this.type,tt = $(this);
					if(t == "text" || t == "password"){
						tt.addClass("textinput");
						tt.hover(function() {
							if (o != this) {
								tt.removeClass("textinput").addClass("textinput_hover");
							}
						}, function() {
							if (o != this) {
								tt.removeClass("textinput_hover").addClass("textinput");
							}
						});
						tt.focus(function() {
							o = tt[0];
							tt.removeClass("textinput").removeClass("textinput_hover").addClass("textinput_click");
						});
						tt.blur(function() {
							o = null;
							tt.removeClass("textinput_click").addClass("textinput");
						});
						if (tt.attr("clearable") == "true") {
							tt.clearableTextField()
						}
						if (tt.attr("selectable") == "true") {
							tt.selectTextField()
						}
						if (tt.attr("maxNum") != null) {
							tt.maxlength()
						}
						if (tt.attr("watermark") != null) {
							tt.watermark("watermark", tt.attr("watermark"))
						}
					}else if(t == "file"){
					     tt.addClass("file").rebrushfileupload();
					}else if(!t || t == "button" || t == "submit" || t == "reset"){
						if (!tt.attr("class")) {
							tt.addClass("button");
							var C = $.modTool._getStrLength(tt.text() || tt.val());
							if (C < 5) {
								tt.width(60)
							}
							var e = 0;
							var D = 50;
							e = $.modTool._getStrLength(tt.filter(":has(span)").find("span").text());
							if (e != 0) {
								D = 20 + 7 * e + 10
							}
							if ($.modTool.broswerFlag == "Firefox" || $.modTool.broswerFlag == "Opera" || $.modTool.broswerFlag == "Safari") {
								tt.filter(":has(span)").css({
									paddingLeft : "5px",
									width : D + 8 + "px"
								})
							} else {
								tt.filter(":has(span)").css({
									paddingLeft : "5px",
									width : D + "px"
								})
							}
							tt.filter(":has(span)").find("span").css({
								cursor : "default"
							})
							tt.hover(function() {
								if (o != this) {
									$(this).removeClass("button").addClass("button_hover")
								}
							}, function() {
								if (o != this) {
									$(this).removeClass("button_hover").addClass("button")
								}
							});
							tt.focus(function() {
								$(this).removeClass("button").addClass("button_hover")
								
							});
							tt.blur(function() {
								$(this).removeClass("button_hover").addClass("button")
							})
						}
					}else if( t == "radio" || t == "checkbox"){
						if(tt.prev().length&&tt.prev()[0].tagName.toLocaleLowerCase()=="span")
							tt.prev().remove();
						tt.custCheckBox();
					}
				}else if(node == "textarea"){
					var t = $(this);
					if (!t.attr("class")) {
						t.addClass("textarea");
						t.hover(function() {
							if (o != this) {
								$(this).removeClass("textarea").addClass("textarea_hover");
							}
						},
						function() {
							if (o != this) {
								$(this).removeClass("textarea_hover").addClass("textarea")
							}
						});
						t.focus(function() {
							o = this;
							$(this).removeClass("textarea").removeClass("textarea_hover").addClass("textarea_click")
						});
						t.blur(function() {
							o = null;
							$(this).removeClass("textarea_click").addClass("textarea")
						})
						
						if (t.attr("maxNum") != null) {
							t.maxlength({
								maxCharacters : parseInt(t.attr("maxNum"))
							})
						}
						if (t.attr("resize") == "true") {
							t.TextAreaResizer()
						}
						if (t.attr("autoHeight") == "true") {
							t.css({
								height : "auto"
							});
							t.attr("rows", 5);
							t.autoGrow()
						}
						if (t.attr("watermark") != null) {
							t.watermark("watermark", t.attr("watermark"))
						}
					}
				}else if(node == "select"){
					var t = $(this);
					if (!t.attr("class") && !t.attr("multiple")) {
						t.prev(".mainCon").remove();
						t.selectbox();
					}
				}
			});
		return this;
	}
})(jQuery);


function Pager(){
	this.pageCount=1;//页数
	this.currentPage=1;//页码
	this.record=15;//单页记录数
	this.recordCount=0 ;//记录总数
	this.tableName="table";
	this.pagerecorderForFloor=2;//
	this.defaultPageCount=2;
	this.showRowsDisplayed=true;
	this.sortMap='{}';
	this.selRecordList=["15","50","100"];
    Pager.prototype.printPager = function(pagerdiv){
    	this.pageCount=Math.ceil(this.recordCount/this.record);
    	if(this.pageCount<1){
    		this.pageCount=1;
    	}
    	var htmlstring=''
    						+'<div class="float_left padding5">'
    						+(+this.recordCount ? ('共'+this.recordCount+'条记录') : '没有找到记录')
    						+'<input type="hidden" name="'+this.tableName+'_currentIndex" id="'+this.tableName+'_currentIndex" value="'+this.currentPage+'" /><input type="hidden" id="'+this.tableName+'_record" name="'+this.tableName+'_record" value="'+this.record+'" /><input type="hidden" id="ectableName" name="ectableName" value="'+this.tableName+'"  />'
							+'</div>'
							+'<div class="float_right padding5 paging">'
								+'<div class="float_left padding_top4 ">'
								+'<span'+("1"==this.currentPage?' class="paging_disabled"':'')+'><a style="text-decoration:none;" href="javascript:'+("1"!=this.currentPage?(this.tableName+'_pager.turnPage('+this.tableName+'_pager.currentPage-1,this)'):'')+'">上一页</a></span>';
    	htmlstring+='<span'+(1==this.currentPage?' class="paging_disabled"':'')+'><a style="text-decoration:none;" href="javascript:'+("1"!=this.currentPage?(this.tableName+'_pager.turnPage(1,this)'):'')+'">1</a></span>';
								if(this.currentPage>4&&this.pageCount>=6){
									htmlstring+='<span>...</span>';
								}
    							var preIndex=2;
    							
    							if(this.currentPage-preIndex>=0&&this.currentPage>3)
    							{
    								preIndex=this.currentPage-2;
    							}	
    							for(preIndex;0<=this.pageCount-preIndex&&this.currentPage-preIndex>=-2;preIndex++){
    								htmlstring+='<span'+(preIndex==this.currentPage?' class="paging_disabled"':'')+'><a style="text-decoration:none;" href="javascript:'+(preIndex!=this.currentPage?(this.tableName+'_pager.turnPage('+preIndex+',this);'):'')+'">'+preIndex+'</a></span>'
    							}
    							if(this.pageCount-preIndex>=1){
    								htmlstring+='<span>...</span>';
    							}
								if(this.pageCount-preIndex>=0){
									htmlstring+='<span'+(this.pageCount==this.currentPage?' class="paging_disabled"':'')+'><a style="text-decoration:none;" href="javascript:'+(this.pageCount!=this.currentPage?(this.tableName+'_pager.turnPage('+this.pageCount+',this);'):'')+'">'+this.pageCount+'</a></span>'
								}
		htmlstring+='<span'+(this.pageCount==this.currentPage?' class="paging_disabled"':'')+'><a style="text-decoration:none;" href="javascript:'+(this.pageCount!=this.currentPage?(this.tableName+'_pager.turnPage('+this.tableName+'_pager.currentPage+1);'):'')+'">下一页</a></span>&nbsp;'
								+'</div>';
		if(this.showRowsDisplayed==true){
			htmlstring+='<div class="float_left">每页'
								+'<select '
								+ (+this.recordCount  ?  '' : 'disabled="true"')
								+' onchange="this.value&&'+this.tableName+'_pager.changeRecord(1,this);" id="'+this.tableName+'_pagerecord" autoWidth="true">';
			var selstring="";
			var selFlag=true;
			for(var i=0;i<this.selRecordList.length;i++){
				if(this.defaultPageCount==this.selRecordList[i]){
					selFlag=false;
				}
				selstring+='<option '+(this.record==this.selRecordList[i]?'selected':'')+' value='+this.selRecordList[i]+'>'+this.selRecordList[i]+'</option>'
			}
			if(selFlag){
				selstring='<option '+(this.record==this.defaultPageCount?'selected':'')+' value='+this.defaultPageCount+'>'+this.defaultPageCount+'</option>'+selstring;
			}
			htmlstring+=selstring+'</select></div>'
								+'<div class="float_left padding_top4">条记录</div>'
								+'<div class="clear"></div>'
								+'</div>';
		}
		htmlstring+='<div class="clear"></div>';
		document.getElementById(pagerdiv).innerHTML=htmlstring;
    }
    
    Pager.prototype.turnPage=function(pageIndex,obj){
    	$("#"+this.tableName+"_currentIndex").val(pageIndex);
    	XqTipOpen( "数据加载中,请稍后");
    	$("#"+this.tableName+"_form").submit();
    }
    Pager.prototype.changeRecord=function(){
    	$("#"+this.tableName+"_currentIndex").val(1);
    	$("#"+this.tableName+"_record").val($("#"+this.tableName+"_pagerecord").val());
    	XqTipOpen( "数据加载中,请稍后");
    	$("#"+this.tableName+"_form").submit();
    }
    Pager.prototype.changeSortMap=function(){
    	$("#"+this.tableName+"_currentIndex").val(1);
    	$("#"+this.tableName+"_record").val($("#"+this.tableName+"_pagerecord").val());
    	var sortMapNew="{";
    	$("#"+this.tableName).find("th").each(function(){
			if($(this).attr("sortMode")=="true"&&$(this).find("span").attr("class")!="sort_off"){
				sortMapNew+='"'+$(this).attr("sortName")+'":"'+($(this).find("span").hasClass("sort_up")?"true":"false")+'",';
			}
		});
    	if(sortMapNew.length>2){
    		sortMapNew=sortMapNew.substring(0, sortMapNew.length-1);
    	}
    	sortMapNew+="}";
    	$("#sortMap").val(sortMapNew);
    	XqTipOpen( "数据加载中,请稍后");
    	$("#"+this.tableName+"_form").submit();
    }
    Pager.prototype.getInitMap=function(){
    	if(this.sortMap!=''&&this.sortMap!='{}'){
    		var json=eval("("+this.sortMap+")");
    		for(var key in json){
    			$("#"+this.tableName).find("th").each(function(){
    				if($(this).attr("sortMode")=="true"&&$(this).attr("sortName")==key){
    					
    					if(json[key]==true){
    						$(this).find("span").removeClass("sort_off");
    						$(this).find("span").addClass("sort_up");
    					}else{
    						$(this).find("span").removeClass("sort_off");
    						$(this).find("span").addClass("sort_down");
    					}
    				}
    			});
    	    } 
    	}
    }
}
/*box渲染开始*/
$(window).load(function(){
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
		});
		$(".box2").each(function() {

			var t = $(this), v = t.clone(true);
			t.html("");
			$("<div class='box2_topcenter'><div class='box2_topleft'><div class='box2_topright'><div class='title'></div><div class='status'><span class='ss'><a></a></span></div><div class='clear'></div></div></div></div>").appendTo(t);
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
				var D = Number(t.attr("panelHeight")) - t.find(".box2_topcenter").outerHeight() - t.find("#box2_bottomcenter").outerHeight();
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
			var u = "隐藏";
			if (t.attr("statusText")) {
				u = t.attr("statusText")
			}
			var E;
			if (u == "隐藏" && w == "true") {
				t.find(".ss").text(u);
				t.find(".ss").toggle(function() {
					var t = $(this), F = t.parents(".box2").find(".boxContent");
					F.slideUp(300);
					t.text("显示")
				}, function() {
					var t = $(this), F = t.parents(".box2").find(".boxContent");
					F.slideDown(300);
					t.text("隐藏")
				})
			} else {
				if (u == "显示" && w == "true") {
					t.find(".ss").text(u);
					var x = t.find(".boxContent").hide();
					t.find(".ss").toggle(function() {
						var t = $(this), F = t.parents(".box2").find(".boxContent");
						F.slideDown(300);
						t.text("隐藏");
					}, function() {
						var t = $(this), F = t.parents(".box2").find(".boxContent");
						F.slideUp(300)
						t.text("显示")
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
		});
});
/*box渲染结束*/

/*表格操作方法开始*/
(function($){
		$.fn.extend({
			/**
			 * 获取到列表所有被选中的行的id 
	 		 * @param {Object} onlyOne 是否只返回被选中的第一行的id,如果true则按照行的选中状态，否则按照checkbox的勾选状态进行判断
			 */
			getId : function(onlyOne){
				if(onlyOne){
					var arrs = this.find(".singelSeleced");
					for(var i = arrs.length - 1;i >= 0 ;i--){
						if(arrs[i].id) {
							return arrs[i].id;
						}
					}
					arrs = this.find(".selected");
					for(var i = arrs.length - 1;i >= 0 ;i--){
						if(arrs[i].id) {
							return arrs[i].id;
						}
					}
					return null;
				}else{
					var arrs = this.find("input[name=itemlist][checked=checked]"),v=[];
					for(var i = arrs.length - 1;i >= 0 ;i--){
						if(arrs[i].value) {
							v.push(arrs[i].value);
						}
					}
					return v;
				}
			},
			/**
			 *准备删除 
			 */
			preDelete : function(){
				var ids = this.getId(false);
				if(!ids.length){
					var id = this.getId(true);
					if(!id)return ids;
					ids.push(id);
					$("#"+this.attr("id")+"_form").append(
						$("<input/>").attr(
							{
								name:"id",
								value:id,
								type:"hidden"
							}
						)
					);
				}
				return ids  ;
			},
			/**
			 *提交 
			 */
			tableSubmit : function(){
				$("#"+this.attr("id")+"_form")[0].submit();
			},
			/**
			 *上移选定行,
			 *@param {Object} steps 指定行数  
			 */
			moveUp : function(steps){
				var id = $("#"+this.attr("id")).getId(true),row = $("#" + id),steps = steps || 1,n = row.index();
				for(var i = 0 ;i < steps ;i++){
					if(n > 1){
						row.insertBefore(row.prev());
						n --;
					}
				}
				return this;
			},
			/**
			 *下移选定行,
			 *@param {Object} steps 指定行数  
			 */
			moveDown : function(steps){
				var id = $("#"+this.attr("id")).getId(true),row = $("#" + id),steps = steps || 1,l = this.children().children().length,n = row.index();
				for(var i = 0 ;i < steps ;i++){
					if(n < l){
						row.insertAfter(row.next());
						n ++;
					}
				}
			},
			/**
			 *上移顶部 
			 */
			moveTop : function(){
				this.moveUp(this.children().children().length);
			},
			/**
			 *下移底部 
			 */
			moveBottom : function(){
				this.moveDown(this.children().children().length);
			},
			/**
			 *删除选定的行 
			 */
			del : function(){
				var id = $("#"+this.attr("id")).getId(true);
				for(var i = id.length - 1;i > -1 ; i --){
					$("#"+id).slideUp().remove();
				}
			},
			setAction :function(action){
				$("#"+this.attr("id")+"_form")[0].action = action;
				return this;
			}
		});
})(jQuery);
/*表格操作方法结束*/
/*常规页面加载事件开始*/
$(window).load(function(){
	try{
		if(frameElement){
			var dg = frameElement.lhgDG;
			if(dg){
				if(dg.dgWin && !dg.dgWin.dg)
					dg.dgWin.dg = dg;
				if(dg.dgWin && !dg.dgWin.father)
					dg.dgWin.father = dg.father;
			}
		}
	}catch(e){
		
	}
		if(window.listOpen){
			$("#view").bind("click",view);
			$("#add").bind("click",add);
			$("#edit").bind("click",update);
			$("#delete").bind("click",batchDelete);
			$("#find").bind("click", conditionSelect);
			$("#bubble").bind("click", clearConditionSelect);
 			$(window).bind("scroll resize",function(){
 				var box = $(".box2[panelTitle=功能]");
 				if(!box.length) return;
 				if( !box.attr("topInit")){box.attr("topInit",box.find("button").position().top);box.attr("zindex",box.css("z-index"));box.attr("top",box.position().top);}
 				var top = $(window).scrollTop(),topFix = box.attr("topInit");
 				if(top > topFix){
 					if(box.css("position") == "fixed") return;
 					box.css({
 						position: "fixed",
 						top: box.attr("top"),
 						"z-index":100
 					});
 				}
				if(top == 0){
 					if(box.css("position") == "static") return;
 					box.css({
 						position: "static",
 						top: box.attr("top"),
 						"z-index":box.attr("zindex")
 					}).removeAttr("fix");
 				}
 					 
 			})

			
		}
		if(window.boxMenu && window.oxhideUrl && window.sessionId){
				var div = $("<div/>").append(
					$("<table />").append(
						$("<tr/>").append(
							$("<td width='30%'/>").html("名称：")
						).append(
							$("<td/>").append(
								$("<input id='boxMenuName' style='width:180px;' />").refresh().val(window.document.title)
							)
						)
					).append(
						$("<tr/>").append(
							$("<td/>").html("地址：")
						).append(
							$("<td/>").append(
								$("<input id='boxMenuUrl' style='width:180px;' readonly='readonly'/>").refresh().val(window.location)
							)
						)
					).append(
						$("<tr/>").append(
							$("<td/>").html("说明：")
						).append(
							$("<td/>").html("添加成功后可以在左侧菜单中切换<br/>到[导航]--[收藏]中快速进入")
						)
					).append(
						$("<tr/>").append(
							$("<td colspan=2 />").append(
								$("<div style='background-color: red;color: white;display:none;width:100%;' id='boxMenuMsgX'/>")
							).append(
								$("<div style='background-color: green;color: white;display:none;width:100%;margin-left: 5px;' id='boxMenuMsgY'/>")
							)
						)
					).append(
						$("<tr/>").append(
							$("<td colspan=2 align='center'/>").append(
								$("<button id='boxMenuBtn'><span class='icon_save'>确定</span></button>").refresh()
							)
						)
					)
				).appendTo($("body")).attr("id","boxMenuDiv").floatPanel({
					width:250,
					animatefirst:false,
					beforeClickText:"添加到收藏夹",
					afterClickText:"取消",
					direction:"mr"
				});
			$("#boxMenuBtn").click(function(){
				var url = $("#boxMenuUrl").val(),name = $("#boxMenuName").val();
				$("#boxMenuMsgX").hide();
				$("#boxMenuMsgY").hide();
				if(!name){
					$("#boxMenuMsgX").html("错误：请输入名称！").show();
					return;
				}
				if(name.length > 8){
					$("#boxMenuMsgX").html("错误：名称不能超过8个字符！").show();
					return;
				}
				if(!url){
					$("#boxMenuMsgX").html("错误：请输入地址！").show();
					return;
				}
				$.ajax({
					type: "post",
					url:window.oxhideUrl + "/siheAction.do?action=addBoxMenu&callback=?&url="+encodeURIComponent(url)+"&name="+encode(name)+"&SESSIONID="+sessionId+"&"+Math.random(),
					timeout:5000,
					dataType:"jsonp",
					success:function(data){
			    		if(data) $("#boxMenuMsgX").html("错误："+data).show();
			    		else {
			    			$(".searchBtnRight").click();
			    			$("#boxMenuMsgY").html("添加成功！").show();
			    		}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert(errorThrown);
					}
				});
			});
		}
	window.o = null,window.dwrObject = window.dwrObject || "DWRBaseClass";
	$("select:not([class]):not([switch=true]),textarea:not([class]):not([switch=true]),input:button:not([class]):not([switch=true]),input:reset:not([class]):not([switch=true]),input:submit:not([class]):not([switch=true]),button:not([class]):not([switch=true]),input:text:not([class]):not([switch=true]),input:password:not([class]):not([switch=true]),input:file:not([class]):not([switch=true]),input:radio:not([class]):not([switch=true]),input:checkbox:not([class]):not([switch=true])").refresh();
});
/*常规页面加载事件结束*/
/*列表页面加载事件 开始*/
(function(){
		window.add = function(){
		    addWin({
		    	url:showAdd,
		        saveAndAdd:window["saveAndAdd"],
		    	fn:function(){
		    		conditionSelect();
		    	},
		    	title:window["pageTitle"] ? ("增加--" + window["pageTitle"] ) : "增加",
		    	width:formWidth,
		    	height:formHeight
		    });
		}
		
		window.update = function(){
		    var id = $("#"+(window.tableId || "siheTable")).getId(true);
		    if (!id) {
		        info({message:"请选择要修改的记录！"});
		        return;
		    }
		    if (!$MT.dwr(dwrObject + '.checkObjcect('+service+','+id+')')) {
		        info({message:"记录已经被删除，请刷新页面！"});
		        return;
		    }
		    updateWin({
		    	url:showUpdate + "&id="+id,
		    	fn:function(){
		    		conditionSelect();
		    	},
		    	title:window["pageTitle"] ? ("修改--" +  window["pageTitle"] ) : "修改",
		    	width:formWidth,
		    	height:formHeight
		    });
		}
		
		window.view = function(){
		    var id = $("#"+(window.tableId || "siheTable")).getId(true);
		    if (!id) {
		        info({message:"请选择要查看的记录！"});
		        return;
		    }
		    
		    if (!$MT.dwr(dwrObject + '.checkObjcect('+service+','+id+')')) {
		        info({message:"记录已经被删除，请刷新页面！"});
		        return;
		    }
		    viewWin({
		    	url:showView+"&id="+id,
		    	width:viewWidth,
		    	title:window["pageTitle"] ? ("查看--" + window["pageTitle"] ) : "查看",
		    	height:viewHeight
		    });
		}

		window.batchDelete = function () {
			var idLength = $("#"+ (window.tableId || "siheTable")).preDelete().length;
			
		    if (idLength) {
			    ask({
			    	message:"您确定要删除选中的  <font style='color:red;font-weight:bold;font-size:13px;'>"+idLength+"</font>  条记录吗？",
			    	fn:function(data){
			    		if(data=='yes'){
			                url = showBatchDelete;
			                XqTipOpen( "正在执行操作,请稍后");
			               $("#"+ (window.tableId || "siheTable")).setAction(url).tableSubmit();
			            }
			    	}
			    });
		
		    } else {
		        info({message:"请勾选或选择要删除的记录！"});
		        return;
		    }
		}
		window.clearConditionSelect = function(){
			if($("advence").length){
				document[formName].appendChild($("advence")[0])
			}
			var ele = document[formName].elements;
			for(var i =0;i<ele.length;i++){
				if($(ele[i]).hasClass("notclear")){
					continue;
				}
				if(ele[i].tagName == "INPUT" && ele[i].type != "button" )
					ele[i].value = "";
				else if(ele[i].tagName=="SELECT"){
					if(ele[i].options.length)
						ele[i].value = ele[i].options[0].value;
				}
		
			}
			conditionSelect();
		}
		window.conditionSelect = function () {
			XqTipOpen("页面加载中,请稍后");
			if(window["formName"] && document[formName]){
				document[formName].submit();
			}else{
				$("#"+ (window.tableId || "siheTable")).tableSubmit()
			}
		}
})();		
/*列表页面加载事件 开始*/



var getUrl = (function()
{
    var sc = document.getElementsByTagName('script'), bp = '',
	    i = 0, l = sc.length, re = /base(?:\.min)?\.js/i;

	for( ; i < l; i++ )
	{
	    if( re.test(sc[i].src) )
		{
		    bp = !!document.querySelector ?
			    sc[i].src : sc[i].getAttribute('src',4);
			break;
		}
	}
	return bp.split('?');
})(),
getPath = getUrl[0].substr( 0, getUrl[0].lastIndexOf('/') + 1 ),
getArgs = function( name )
{
	
    if( getUrl[1] )
	{
	    var param = getUrl[1].split('&'), i = 0, l = param.length, aParam;

		for( ; i < l; i++ )
		{
		    aParam = param[i].split('=');

			if( name === aParam[0] ) return aParam[1];
		}
	}
	
	return null;
},
baseSkin = getArgs('s') || 'sheet1';
(function(){
	var jss = $("script");
	for(var i = 0;i<jss.length;i++){
		if(jss[i].src.indexOf("base.js") > -1){
			var basePath = jss[i].src.match(/http:\/*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\/*\w*\/*/i);
			document.write("<link rel='stylesheet' type='text/css' href='"+basePath+"/resource/base/theme/"+baseSkin+"/base/style.css'/>");
			document.write("<link rel='stylesheet' type='text/css' href='"+basePath+"/resource/base/theme/icon/icon.css'/>");
		}
	}
})();

function encode(strIn) {
	var intLen = strIn.length;
	var strOut = "";
	var strTemp;

	for ( var i = 0; i < intLen; i++) {
		strTemp = strIn.charCodeAt(i);
		if (strTemp > 255) {
			tmp = strTemp.toString(16);
			for ( var j = tmp.length; j < 4; j++)
				tmp = "0" + tmp;
			strOut = strOut + "^" + tmp;
		} else {
			if (strTemp < 48 || (strTemp > 57 && strTemp < 65)
					|| (strTemp > 90 && strTemp < 97) || strTemp > 122) {
				tmp = strTemp.toString(16);
				for ( var j = tmp.length; j < 2; j++)
					tmp = "0" + tmp;
				strOut = strOut + "~" + tmp;
			} else {
				strOut = strOut + strIn.charAt(i);
			}
		}
	}
	return (strOut);
}


