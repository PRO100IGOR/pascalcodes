/**
* XMLHttpRequest Object Pool
*/ 
var XMLHttp = {
    _objPool: [],
    _getInstance: function (){
        for (var i = 0; i < this._objPool.length; i ++){
            if (this._objPool[i].readyState == 0 || this._objPool[i].readyState == 4){
                return this._objPool[i];
            }
        }
        // 
        this._objPool[this._objPool.length] = this._createObj();
        return this._objPool[this._objPool.length - 1];
    },
    _createObj: function (){
        if (window.XMLHttpRequest){
           var objXMLHttp = new XMLHttpRequest();
        }
        else{
            var MSXML = ['MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'];
            for(var n = 0; n < MSXML.length; n ++){
                try{
                    var objXMLHttp = new ActiveXObject(MSXML[n]);
                    break;
                }
                catch(e){
                }
            }
         }          
        //
        if (objXMLHttp.readyState == null){
            objXMLHttp.readyState = 0;
         }
       /*     if(!-[1, ]){
            	objXMLHttp.attachEvent("load", function (){
	                    //objXMLHttp.readyState = 4;
	                    if (typeof objXMLHttp.onreadystatechange == "function"){
	                        objXMLHttp.onreadystatechange();
	                    }
	            });
	           
            }else{
            objXMLHttp.addEventListener("load", function (){
                    //objXMLHttp.readyState = 4;
                    if (typeof objXMLHttp.onreadystatechange == "function"){
                        objXMLHttp.onreadystatechange();
                    }
            },  false);
            }*/
        return objXMLHttp;
    },
    // 
    sendReq: function (method, url, data, callback,callbackparameter2,isDisplatyError){
        var objXMLHttp = this._getInstance();
        with(objXMLHttp){
            try{
                // 
                if (url.indexOf("?") > 0){
                    url += "&randnum=" + Math.random();
                }
                else{
                    url += "?randnum=" + Math.random();
                }
                open(method, url, true);
                setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
                send(data);
                onreadystatechange = function (){
                    if (objXMLHttp.readyState == 4 && (objXMLHttp.status == 200 || objXMLHttp.status == 304)){
                        callback(objXMLHttp.responseText,callbackparameter2);
                    }
                };
            }
            catch(e){
            	//if(isDisplatyError)
                  alert(url+":"+e.message);
            }
        }
    }
};
