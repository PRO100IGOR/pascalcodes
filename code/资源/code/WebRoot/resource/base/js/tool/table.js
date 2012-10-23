/*
* 表格对象
*  按钮有add/del/up/down/，表格存放在$.tables数组中
*  $.tables[index].noClick 表示是否可以打开表格的增加、删除行以及行排序功能
*/
(function($){
$.tables = {};

$.fn.table = function(p) {
	var p = $.extend({
		tid:null,  //模版iD
		onAdd:function(tr){ //增加时
			
		},
		onDel:function(tr){  //删除时
			
		}
	},p);
	var  temp = new Table(this.attr("id"),p.onAdd,p.onDel);
	temp.table = this;
	temp.trPan = $("#"+p.tid);
	return temp;
}

var Table = function( id, onAdd , onDel) {
    this.rowSize = 0;
	$.tables[id] = this;
	this.id = id;
    $("#add_" + id).attr("index", id).bind("click",
    function() {
        $.tables[$(this).attr("index")].noClick || $.tables[$(this).attr("index")].add();
    });
    $("#del_" + id).attr("index", id).bind("click",
    function() {
        $.tables[$(this).attr("index")].noClick || $.tables[$(this).attr("index")].del();
    });
    $("#up_" + id).attr("index", id).bind("click",
    function() {
        $.tables[$(this).attr("index")].noClick || $.tables[$(this).attr("index")].up();
    });
    $("#down_" + id).attr("index", id).bind("click",
    function() {
        $.tables[$(this).attr("index")].noClick || $.tables[$(this).attr("index")].down();
    });
	this.onAdd = onAdd;
	this.onDel = onDel;
    /*选中一行*/
    this.select = function(row) {
			$(this.row).removeClass("selected").addClass($(this.row).attr("bclass"));
			$(row).removeClass($(row).attr("bclass")).addClass("selected");
			this.row = $(row);
    };
    /*增加一行*/
    this.add = function() {
        this.rowSize++;
        var classname = this.rowSize % 2 == 0 ? "c": "odd";
        var temp = this.trPan.clone().attr("row",this.rowSize).addClass(classname).attr("tableIndex", this.id).bind("click",
        function() {
            $.tables[$(this).attr("tableIndex")].select(this);
        }).attr("bclass", classname).hover(function() {
            var temp = $(this);
            temp.toggleClass("highlight");
            if (!temp.hasClass("selected")) {
                temp.toggleClass(temp.attr("bclass"));
            }
        }).attr("index", this.rowSize);
        temp.children().children().refresh();
        this.table.append(temp);
        this.onAdd && this.onAdd(temp);
        return temp;
    };
    /*删除一行,返回该行下标*/
    this.del = function() {
        if (this.row) {
            var table = this,temp = -1;
            ask({
                message: "确定删除所选记录？",
                fn: function(op) {
                    if (op == "yes") {
						temp = table.row.attr("index");
						table.rowSize--;
						table.onDel && table.onDel(table.row);
                        table.row.remove();
                        delete table.row;
                    }
                }
            });
			return temp;
        } else {
            info({
                message: "请选择要删除的记录！"
            });
        }
    };
    /*上移一行*/
    this.up = function() {
        if (this.row && this.row.index() > 0) {
            this.row.insertBefore(this.row.prev());
        }
    };
    /*下移一行*/
    this.down = function() {
        if (this.row && this.row.index() < this.row.parent().children().length - 1) {
            this.row.insertAfter(this.row.next());
        }
    };
}
})(jQuery);

