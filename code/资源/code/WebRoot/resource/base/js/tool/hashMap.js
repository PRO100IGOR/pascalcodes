 function HashMap()
  {
      /** Map ��С **/
      var size = 0;
      /** ���� **/
      var entry = new Object();
      
      /** �� **/
      this.put = function (key , value)
      {
          if(!this.containsKey(key))
          {
              size ++ ;
          }
          entry[key] = value;
      }
      
      /** ȡ **/
      this.get = function (key)
      {
          return this.containsKey(key) ? entry[key] : null;
      }
      
	  /**ȡָ��level��ֵ**/
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
      /** ɾ�� **/
      this.remove = function ( key )
      {
          if( this.containsKey(key) && ( delete entry[key] ) )
          {
             size --;
          }
      }
      
      /** �Ƿ���� Key **/
      this.containsKey = function ( key )
      {
          return (key in entry);
      }
      
      /** �Ƿ���� Value **/
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
      
      /** ���� Value **/
      this.values = function ()
      {
          var values = new Array();
          for(var prop in entry)
          {
              values.push(entry[prop]);
          }
          return values;
      }
      
      /** ���� Key **/
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
      
      /* ��� */
      this.clear = function ()
      {
          size = 0;
          entry = new Object();
      }
  }
  
 
 /** �Ѷ�����ΪKeyʱ ���Զ������˸ö���� toString() ���� ��ʵ���ջ�����String����ΪKey**/
 
 /** ������Զ������ ���Լ�����д toString() ���� ���� . ��������Ľ�� **/
 
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