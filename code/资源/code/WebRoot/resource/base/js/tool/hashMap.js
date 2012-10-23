 function HashMap()
  {
      /** Map 大小 **/
      var size = 0;
      /** 对象 **/
      var entry = new Object();
      
      /** 存 **/
      this.put = function (key , value)
      {
          if(!this.containsKey(key))
          {
              size ++ ;
          }
          entry[key] = value;
      }
      
      /** 取 **/
      this.get = function (key)
      {
          return this.containsKey(key) ? entry[key] : null;
      }
      
	  /**取指定level的值**/
	  this.getfromlevel = function (key,type)
      {
		  for(var prop in entry)
          {
              if(entry[prop] == value)
              {
                  return true;
              }
          }
          return this.containsKey(key) ? entry[key] : null;
      }
      /** 删除 **/
      this.remove = function ( key )
      {
          if( this.containsKey(key) && ( delete entry[key] ) )
          {
             size --;
          }
      }
      
      /** 是否包含 Key **/
      this.containsKey = function ( key )
      {
          return (key in entry);
      }
      
      /** 是否包含 Value **/
      this.containsValue = function ( value )
     {
          for(var prop in entry)
          {
              if(entry[prop] == value)
              {
                  return true;
              }
          }
          return false;
      }
      
      /** 所有 Value **/
      this.values = function ()
      {
          var values = new Array();
          for(var prop in entry)
          {
              values.push(entry[prop]);
          }
          return values;
      }
      
      /** 所有 Key **/
      this.keys = function ()
      {
          var keys = new Array();
          for(var prop in entry)
          {
              keys.push(prop);
          }
          return keys;
      }
      
      /** Map Size **/
      this.size = function ()
      {
          return size;
      }
      
      /* 清空 */
      this.clear = function ()
      {
          size = 0;
          entry = new Object();
      }
  }
  
 
 /** 把对象做为Key时 ，自动调用了该对象的 toString() 方法 其实最终还是以String对象为Key**/
 
 /** 如果是自定义对象 那自己得重写 toString() 方法 否则 . 就是下面的结果 **/
 
 function MyObject(name)
 {
     this.name = name;
 }
 
 /**
 function MyObject(name)
 {
     this.name = name;
     
     this.toString = function ()
     {
         return this.name;
     }
 }
 **/