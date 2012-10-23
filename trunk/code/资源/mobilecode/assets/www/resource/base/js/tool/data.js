/**
 
	sqllite操作类,>>common.js
 	$.sql.init(opt); 初始化数据库
	$.sql.excute(database,sql,params,callBack); 执行数据库语句
	所有的数据库对象都放在$.datas中，利用$.datas[opt.name]可以获取到
	$.sql.map(key,value)键值对存储
	$.sql.removeMap(key)删除键值对，当不传key时，表示删除全部
**/
(function($){

	$.sql = {
		/*
			初始化数据库,参数:
			{
				name:"数据库名称,必填",
				size:数据库大小,默认2M,可选,
				version:"版本,默认1.0,可选",
				displayName:"数据库显示名称,默认为name,可选"
			}
		*/
		init : function(opt){
			$.extend(opt,{size:1024*1024*2,version:"1.0"});
			try{
				($.datas || ($.datas = {})) && ($.datas[opt.name] || ($.datas[opt.name] = window.openDatabase(opt.name, opt.version, opt.name || opt.displayName, opt.size)));
			}catch(e){
				if($.debug){
					var arr = [];
					for(var i in e){
						arr.push(i+"="+e[i]);
					}
					alert("data.js line 32 " + arr.join(" "));
				}
			}
		},
		/*
			执行非幂等sql，参数：
			database--要操作的数据库名
			sql和param传递分为2种，执行一句和执行多句。
			执行一句：sql为字符串，语句,模仿jdbc方式，参数可以用 :参数名 ,每个参数的:之前必须有空格，例如 where name = :pa1是正确的，where name =:pa1是错误的
					params :查询参数值，应该是参数名和参数值的json对，可选，如果sql中参数多于params中参数，用null代替,只有此时params才可以不传
			执行多句：sql为上述语句的数组，params为上述参数键值对的数组，但二者的顺序要对应，有几个sql就必须有几个params
			
			执行幂等语句时参数
			sql、params不能是数组，只支持查询一组
			database--要操作的数据库名
			callBack是一个回调函数，当查询成功后调用，必须有一个参数resultSet(SQLResultSet对象),resultSet属性：
			    rows:SQLResultSetList对象
				rows.length  : 该结果集包含多少条记录
				rows.item(index)	: 返回下标为index的行的json对象，json对象是列名和列值的键值对
		*/
		excute : function(database,sql,params,callBack){
			if($["datas"] && $.datas[database]){
				var isArr = !!sql.push;
				sql = createSql(sql,params,isArr);
				if(isArr){
					$.datas[database].transaction(
						function(tx){
							for(var i =0;i<sql.length;i++){
								tx.executeSql(sql[i]);
							}
						},
						function(err){
							if($.debug){
								var arr = [];
								for(var i in err){
									arr.push(i + "=" + err[i]);
								}
								alert("excute错误(data.js line 69) " + arr.join(" ")+ " ^  " + sql);
							}
						},
						function(){
							if($.debug)
								alert("excute成功(data.js line 73)！"+ " ^  " + sql);
						}
					);
				}else{
					$.datas[database].transaction(
						function(tx){
							tx.executeSql(sql,[],
								function(tx,results){
									if(callBack)
										callBack(results);
								},
								function(arr){
									if($.debug){
										var arr = [];
										for(var i in err){
											arr.push(i + "=" + err[i]);
										}
										alert("excute错误 data.js line 91 " + arr.join(" ") + " ^  " + sql);
									}
								}
							);
						},
						function(err){
							if($.debug){
								var arr = [];
								for(var i in err){
									arr.push(i + "=" + err[i]);
								}
								alert("excute错误  data.js line 102 " + arr.join(" ") + " ^ "+ sql );
							}
						},
						function(){
							if($.debug)
								alert("excute成功 data.js line 107 "  + " ^  " + sql);
						}
					);
				}
			}else if($.debug){
				alert("excute错误,数据库 " + database+" 不存在"+ " ^  " + sql);
			}
		},
		/*
			键值对存储
			key
			value，当value不输入时，表示取值
		*/
		map:function(key,value){
			if(value){
				window.localStorage.setItem(key,value);
				return value;
			}else{
				return window.localStorage.getItem(key);	
			}
		},
		/*
			删除键值对，当不传key时，表示删除全部
		*/
		removeMap:function(key){
			if(key){
				window.localStorage.removeItem(key);
			}else{
				window.localStorage.clear();
			}
		}
	};
	
	
	
	function createSql(sql,params,isArr){
		if(isArr){
			for(var j =0;j<sql.length;j++){
				if(params[j]){
					for(var i in params[j]){
						sql[j] = sql[j].replaceAll(":"+i,"'"+params[j][i]+"'");
					}
				}
				var index = sql[j].indexOf(" :");
				while(index > -1){
					try{
						sql[j] = sql[j].replaceAll(sql[j].substring(index, sql[j].indexOf(" ", index + 1)), " null ");
					}catch (e) {
						sql[j] = sql.replaceAll(sql[j].substring(index, sql[j].length()), " null ");
					}
					index = sql[j].indexOf(" :");
				}
			}
		}else{
			if(params){
				for(var i in params){
					sql = sql.replaceAll(":"+i,"'"+params[i]+"'");
				}
			}
			var index = sql.indexOf(" :");
			while(index > -1){
				try{
					sql = sql.replaceAll(sql.substring(index, sql.indexOf(" ", index + 1)), " null ");
				}catch (e) {
					sql = sql.replaceAll(sql.substring(index, sql.length()), " null ");
				}
				index = sql.indexOf(" :");
			}
		}
		return sql;
	}
	

})(jQuery);