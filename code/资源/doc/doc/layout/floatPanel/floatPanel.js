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