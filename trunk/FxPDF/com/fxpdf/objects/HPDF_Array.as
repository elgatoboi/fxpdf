/*
Copyright 2010 FxPDF.com

FxPDF is based on libHaru code originally developed & maintained by Takeshi Kanno (libHaru.org). 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.fxpdf.objects
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_Real;
	
	public class HPDF_Array extends HPDF_Object
	{
		
	    //HPDF_List        list;
	    public	var	list : HPDF_List ; 
	     
		public function HPDF_Array()
		{
			 /*obj = HPDF_GetMem (mmgr, sizeof(HPDF_Array_Rec));
			    if (obj) {
			        HPDF_MemSet (obj, 0, sizeof(HPDF_Array_Rec));
			        obj->header.obj_class = HPDF_OCLASS_ARRAY;
			        obj->mmgr = mmgr;
			        obj->error = mmgr->error;
			        obj->list = HPDF_List_New (mmgr, HPDF_DEF_ITEMS_PER_BLOCK);
			        if (!obj->list) {
			            HPDF_FreeMem (mmgr, obj);
			            obj = NULL;
			        }
			        */
			super( ) ;
			header.objClass	=	HPDF_Obj_Header.HPDF_OCLASS_ARRAY ; 
			list	=	new HPDF_List( HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK );
		
	    }
	    
	    public	static	function	HPDF_Box_Array_New ( box : HPDF_Box ) : HPDF_Array
	    {
	    	var obj  :HPDF_Array	=	new HPDF_Array( ) ; 
	    	obj.HPDF_Array_Add ( new HPDF_Real( box.left) );
	    	obj.HPDF_Array_Add ( new HPDF_Real( box.bottom) );
	    	obj.HPDF_Array_Add ( new HPDF_Real( box.right) );
	    	obj.HPDF_Array_Add ( new HPDF_Real( box.top) );
	    	
	    	return obj;
	    }
	   
   		public	function	HPDF_Array_Add	( obj : Object ) : void
   		{
			if (!obj){
				throw new HPDF_Error("HPDF_Array_Add Invalid Object" , HPDF_Error.HPDF_INVALID_OBJECT, 0);
			}
		    
		    var	header  :HPDF_Obj_Header	=	obj.header; 

   			if ( header.objId & HPDF_Obj_Header.HPDF_OTYPE_DIRECT )
   			{
   				throw new HPDF_Error("HPDF_Array_Add Invalid Object" , HPDF_Error.HPDF_INVALID_OBJECT, 0);
   			}

 			if ( this.list.count >= HPDF_Consts.HPDF_LIMIT_MAX_ARRAY)
 			{
 				 trace(" HPDF_Array_Add exceed limitatin of array count(" + HPDF_Consts.HPDF_LIMIT_MAX_ARRAY.toString()+")");
 				 
 			}
 			if (header.objId &  HPDF_Obj_Header.HPDF_OTYPE_INDIRECT ) 
 			{
 				var proxy : HPDF_Proxy	=	new HPDF_Proxy ( obj );
 				proxy.header.objId	|= HPDF_Obj_Header.HPDF_OTYPE_DIRECT;
 				obj	= proxy; 
 			}
 			else	
 				 header.objId |= HPDF_Obj_Header.HPDF_OTYPE_DIRECT;

			this.list.HPDF_List_Add( obj );
   		}
   		
   		
   		public	function	HPDF_Array_AddName( value : String ) :void
   		{
   			var	n : HPDF_Name	=	new HPDF_Name ( value ) ; 
        	HPDF_Array_Add (n); 
   		}
   		
   		public	function	HPDF_Array_AddReal( value : Number ) : void
   		{
   			var r : HPDF_Real = new HPDF_Real ( value );
   			// trace ("HPDF_Array_AddReal");
   			this.HPDF_Array_Add( r) ; 
   		}
		
		
		public function HPDF_Array_AddNumber( value : Number ) : void
		{
			var r  : HPDF_Number = new HPDF_Number ( value );
			// trace ("HPDF_Array_AddReal");
			this.HPDF_Array_Add( r) ; 
			
		}

	
   		
   		public	function	HPDF_Array_Clear ( ) : void
   		{
   			for (var i:int = 0; i < list.count; i++)
   			{
	        	var obj:HPDF_Object = list.HPDF_List_ItemAt ( i) as HPDF_Object;
	        }
	        list	=	new HPDF_List( HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK  );
    	}
    	
    	public	function	HPDF_Array_GetItem  ( index : uint, objClass : uint ) : Object
    	{
            var obj : * ;
            var header : HPDF_Obj_Header; 
		
		    trace(" HPDF_Array_GetItem");
		
		    obj = this.list.HPDF_List_ItemAt ( index);
		
		    if (!obj)
		    {
		    	throw new HPDF_Error( "HPDF_Array_GetItem",HPDF_Error.HPDF_ARRAY_ITEM_NOT_FOUND, 0);
		    }
		
		    header = obj.header ; 
		
		    if (header.objClass == HPDF_Obj_Header.HPDF_OCLASS_PROXY) {
		        obj = obj.obj ;
		        header = obj.header ;  
		    }
		
		    if ((header.objClass & HPDF_Obj_Header.HPDF_OCLASS_ANY) != objClass)
		    {
		    	throw new HPDF_Error( "HPDF_Array_GetItem",HPDF_Error.HPDF_ARRAY_ITEM_UNEXPECTED_TYPE, 0);
		    }
		    return obj;
		   }
		}
    	
    	
	
}