/**
 
	sqllite������,>>common.js
 	$.sql.init(opt); ��ʼ�����ݿ�
	$.sql.excute(database,sql,params,callBack); ִ�����ݿ����
	���е����ݿ���󶼷���$.datas�У�����$.datas[opt.name]���Ի�ȡ��
	$.sql.map(key,value)��ֵ�Դ洢
	$.sql.removeMap(key)ɾ����ֵ�ԣ�������keyʱ����ʾɾ��ȫ��
**/
(function($){

	$.sql = {
		/*
			��ʼ�����ݿ�,����:
			{
				name:"���ݿ�����,����",
				size:���ݿ��С,Ĭ��2M,��ѡ,
				version:"�汾,Ĭ��1.0,��ѡ",
				displayName:"���ݿ���ʾ����,Ĭ��Ϊname,��ѡ"
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
			ִ�з��ݵ�sql��������
			database--Ҫ���������ݿ���
			sql��param���ݷ�Ϊ2�֣�ִ��һ���ִ�ж�䡣
			ִ��һ�䣺sqlΪ�ַ��������,ģ��jdbc��ʽ������������ :������ ,ÿ��������:֮ǰ�����пո����� where name = :pa1����ȷ�ģ�where name =:pa1�Ǵ����
					params :��ѯ����ֵ��Ӧ���ǲ������Ͳ���ֵ��json�ԣ���ѡ�����sql�в�������params�в�������null����,ֻ�д�ʱparams�ſ��Բ���
			ִ�ж�䣺sqlΪ�����������飬paramsΪ����������ֵ�Ե����飬�����ߵ�˳��Ҫ��Ӧ���м���sql�ͱ����м���params
			
			ִ���ݵ����ʱ����
			sql��params���������飬ֻ֧�ֲ�ѯһ��
			database--Ҫ���������ݿ���
			callBack��һ���ص�����������ѯ�ɹ�����ã�������һ������resultSet(SQLResultSet����),resultSet���ԣ�
			    rows:SQLResultSetList����
				rows.length  : �ý����������������¼
				rows.item(index)	: �����±�Ϊindex���е�json����json��������������ֵ�ļ�ֵ��
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
								alert("excute����(data.js line 69) " + arr.join(" ")+ " ^  " + sql);
							}
						},
						function(){
							if($.debug)
								alert("excute�ɹ�(data.js line 73)��"+ " ^  " + sql);
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
										alert("excute���� data.js line 91 " + arr.join(" ") + " ^  " + sql);
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
								alert("excute����  data.js line 102 " + arr.join(" ") + " ^ "+ sql );
							}
						},
						function(){
							if($.debug)
								alert("excute�ɹ� data.js line 107 "  + " ^  " + sql);
						}
					);
				}
			}else if($.debug){
				alert("excute����,���ݿ� " + database+" ������"+ " ^  " + sql);
			}
		},
		/*
			��ֵ�Դ洢
			key
			value����value������ʱ����ʾȡֵ
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
			ɾ����ֵ�ԣ�������keyʱ����ʾɾ��ȫ��
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