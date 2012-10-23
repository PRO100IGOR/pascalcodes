// ParameterSet
function ParameterSet() {
 this._parameters = new Array();
 this._keys=new Array();
}
// Methods
ParameterSet.prototype._addParameter = function(name) {
 parameter = new Object();
 parameter.dataType = "string";
 parameter.name = name;
 var property = "__" + name.toLowerCase();
 var _parameters = this._parameters;   
 _parameters[property] = parameter;
 _parameters[_parameters.length] = parameter;
 this._keys.push(name);

 return parameter;
}

ParameterSet.prototype.clear=function(){
	this._parameters.splice(0,this._parameters.length);
	this._parameters=new Array();
	this._keys=new Array();
}
ParameterSet.prototype.Remove=function(name){
	var parameter=this._getParameter(name);
	if(parameter){
		this._parameters["__" + name.toLowerCase()]=null;
		arrayHelper.remove(this._parameters,parameter);
		this._keys.remove(name);
	}
}

ParameterSet.prototype._getParameter = function(name) {
 var _parameters = this._parameters;
 if (typeof(name) == "number"){
  var index = parseInt(name);
  var parameter = _parameters[index];
  return parameter;
 }
 else{
  var property = "__" + name.toLowerCase();
  var parameter = _parameters[property];  
  return parameter;
 }
}  
ParameterSet.prototype.count = function() {
 return this._parameters.length;
}
ParameterSet.prototype.indexToName = function(index) {
 var parameter = this._getParameter(index);
 if (parameter) {
  return parameter.name;
 }
}

ParameterSet.prototype.setValue = function(name, value) {
 var parameter = this._getParameter(name);
 if (!parameter && typeof(name) != "number") {
  parameter = this._addParameter(name);
 }
 if (parameter){
  parameter.value = value;
 }
}
ParameterSet.prototype.getValue = function(name) { 
 var parameter = this._getParameter(name);
 if (parameter) {
  return parameter.value; 
 }
}

ParameterSet.prototype.Keys = function() { 
	return this._keys;
}
ParameterSet.prototype.Items = function() {
	var parameter =new Array();
	for(var index=0;index<this._keys.length;index++){
		parameter.push(this._parameters["__"+this._keys[index].toLowerCase()].value);
	}
	return parameter;
}
ParameterSet.prototype.setDataType = function(name, dataType) {
 var parameter = this._getParameter(name);
 if (!parameter && typeof(name) != "number") {
  parameter = this._addParameter(name);
  
 }
 if (parameter){
  parameter.dataType = dataType;
 }
}
ParameterSet.prototype.getDataType = function(name) { 
 var parameter = this._getParameter(name);
 if (parameter) {
  return parameter.dataType;
 }
}
ParameterSet.prototype.Exists = function(name) { 
 var parameter = this._getParameter(name);
 if (parameter) {
  return true; 
 }else{
 	return false;
 }
}

Array.prototype.remove = function(b) {
var a = this.indexOf(b); 
if (a >= 0) { 
this.splice(a, 1); 
return true; 
} 
return false; 
};

var arrayHelper = {
	indexOf: function (a, o) {
		for (var i = 0; i < a.length; i++) {
			if (a[i] == o) {
				return i;
			}
		}
		return -1;
	},

	insertBefore: function (a, o, o2) {
		var i = this.indexOf(a, o2);
		if (i == -1) {
			a.push(o);
		} else {
			a.splice(i, 0, o);
		}
	},

	remove: function (a, o) {
		var i = this.indexOf(a, o);
		if (i != -1) {
			a.splice(i, 1);
		}
	}
};
