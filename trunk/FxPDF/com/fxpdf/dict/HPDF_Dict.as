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
package com.fxpdf.dict
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_DictElement;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_Object;
	import com.fxpdf.objects.HPDF_Proxy;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.streams.HPDF_MemStream;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.enum.HPDF_InfoType;
	import com.fxpdf.xref.HPDF_Xref;
	
	/** represents HPDF_Dict */
	
	public class HPDF_Dict extends HPDF_Object
	{
		
		/*
		 HPDF_Obj_Header            header;
	    HPDF_MMgr                  mmgr;
	    HPDF_Error                 error;
	    HPDF_List                  list;
	    HPDF_Dict_BeforeWriteFunc  before_write_fn;
	    HPDF_Dict_OnWriteFunc      write_fn;
	    HPDF_Dict_AfterWriteFunc   after_write_fn;
	    HPDF_Dict_FreeFunc         free_fn;
	    HPDF_Stream                stream;
	    HPDF_UINT                  filter;
	    void                       *attr; */
    	
    	
    	public	var	list : Vector.<HPDF_DictElement>;
    	
    	public	var	filter : Number ; 
    	public	var	error : HPDF_Error; 
    	
    	
    	
    	public	var	attr	: Object; 
    	
    	public	var	stream 	: HPDF_Stream ; 
    	
    	
    	private	static const HPDF_INFO_ATTR_NAMES:Array  = ["CreationDate","ModDate","Author","Creator","Producer","Title","Subject","Keywords",null];

    	
    	/** represents HPDF_Dict_New **/
		public function HPDF_Dict()
		{
	        //obj->header.obj_class = HPDF_OCLASS_DICT;
	        header	=	new HPDF_Obj_Header	; 
	        header.objClass	=	HPDF_Obj_Header.HPDF_OCLASS_DICT ; 
	        
	        //obj->list = HPDF_List_New (mmgr, HPDF_DEF_ITEMS_PER_BLOCK);
	        list	=	new Vector.<HPDF_DictElement>;
	        
	        //obj->filter = HPDF_STREAM_FILTER_NONE;
	        filter 	=	HPDF_Stream.HPDF_STREAM_FILTER_NONE;
	        
	        error	=	new HPDF_Error( ) ; 
	        //
		}
		
		
		public	function	GetElement ( key : String ) :HPDF_DictElement
		{
			for ( var i:int	=	0	; i < list.length ; i++ ) 
			{
				var el : HPDF_DictElement	=	list[i];
				if ( el.key	==	key ) 	
					return el;
			}
			return null;
			
		}
		
		
		public	function	HPDF_Dict_Add(key:String, obj:Object ):void
		{
			var	header	: HPDF_Obj_Header = obj.header as HPDF_Obj_Header;
			var	element : HPDF_DictElement; 
		
		    if (header.objId & HPDF_Obj_Header.HPDF_OTYPE_DIRECT)
		    	throw new HPDF_Error ( "HPDF_Dict_Add line - invalid object" , HPDF_Error.HPDF_INVALID_OBJECT, 0 )
		    
		    if (!key)
		    	throw new HPDF_Error ( "HPDF_Dict_Add line - invalid object" , HPDF_Error.HPDF_INVALID_OBJECT, 0 )
		        
		    if ( list.length >= HPDF_Consts.HPDF_LIMIT_MAX_DICT_ELEMENT) {
		        trace(" HPDF_Dict_Add exceed limitatin of dict count("+HPDF_Consts.HPDF_LIMIT_MAX_DICT_ELEMENT.toString()+")");
				throw new HPDF_Error ( "HPDF_Dict_Add line - invalid object" , HPDF_Error.HPDF_DICT_COUNT_ERR, 0 )
		    }
		    
		    /* check whether there is an object which has same name */
		    element = GetElement ( key);

		    if (element) 
		    {
		        element.value	=	null ; 
		    } 
		    else 
		    {
		    	element			=	new HPDF_DictElement; 
		        element.key		=	new String( key );
		        element.value	=	null ; 
		
		        this.list.push( element );
	   		 } 

		    if (header.objId & HPDF_Obj_Header.HPDF_OTYPE_INDIRECT) 
		    {
		        var proxy: HPDF_Proxy	=	new HPDF_Proxy( obj );
		        element.value = proxy;
		        proxy.header.objId	|=	HPDF_Obj_Header.HPDF_OTYPE_DIRECT ; 
		    }
		    else {
		        element.value	=	obj;
		        header.objId	|=	HPDF_Obj_Header.HPDF_OTYPE_DIRECT ; 
		    }

	  	}// HPDF_Dict_Add end
			
			
		public	function	HPDF_Dict_AddName ( key : String, value : String):void
		{
		    var name : HPDF_Name	=	new HPDF_Name( value );
		    HPDF_Dict_Add( key, name ) ; 
		}
		
		public function HPDF_Dict_AddNumber(key:String, value:int):void
	    {
	    	var number : HPDF_Number	=	new HPDF_Number( value );
	    	HPDF_Dict_Add( key, number );
	    }
    
		public	function	HPDF_Dict_GetItem  ( key : String, objClass : Number ) : Object
		{
			
		    // C HPDF_DictElement element = GetElement (dict, key);
		    var element : HPDF_DictElement	=	GetElement( key ) ; 
		    var obj : *;

		    // C if (element && HPDF_StrCmp(key, element->key) == 0)
		    if ( element && key	== element.key )  
		    {
		        //C HPDF_Obj_Header *header = (HPDF_Obj_Header *)element->value;
		        var header : HPDF_Obj_Header	=	element.value.header ; 
				
		        //if (header->obj_class == HPDF_OCLASS_PROXY) {
		        if ( header.objClass == HPDF_Obj_Header.HPDF_OCLASS_PROXY ) 
		        {
		            // C HPDF_Proxy p = element->value;
		            var	p  :HPDF_Proxy	=	element.value ; 
		            header = p.obj.header;
		            obj = p.obj;
		        } else
		            obj = element.value;

		        if ((header.objClass & HPDF_Obj_Header.HPDF_OCLASS_ANY) != objClass)
		        {
		            trace(" HPDF_Dict_GetItem dict=%p key=%s obj_class=0x%08X\n" );
		                    //dict, key, (HPDF_UINT)header->obj_class));
		            throw new HPDF_Error(  "HPDF_Dict_GetItem", HPDF_Error.HPDF_DICT_ITEM_UNEXPECTED_TYPE, 0);
		            //HPDF_SetError (dict->error, HPDF_DICT_ITEM_UNEXPECTED_TYPE, 0);
           		}	
      		}
       	    return obj;
    }
    
    
    
    
    public	static	function	HPDF_DictStream_New( xref : HPDF_Xref ) : HPDF_Dict
    {
    	var	obj :HPDF_Dict	=	new HPDF_Dict( ) ;
	    
	    xref.HPDF_Xref_Add( obj );
	    
	    var	length : HPDF_Number	=	new HPDF_Number( 0 ) ;
	    
	    xref.HPDF_Xref_Add( length );
	    
	    obj.HPDF_Dict_Add( "Length", length);

	    obj.stream = new HPDF_MemStream(); 
	    
	    return obj; 
    }	
    
    public	function	HPDF_Dict_RemoveElement( key : String ) : void
    {
    	for (var i:int = 0; i < list.length; i++)
    	{
	        var element:HPDF_DictElement = list[i] as HPDF_DictElement;
	
	        if ( element.key	==	 key)
	        {
	            // TODO list.HPDF_List_Remove(element);
	            
	        }
	    }
    }
    
 
    
    public	function	HPDF_Dict_GetKeyByObj ( obj : Object ) : String
    {
     	var	i : int ; 

	    for (i = 0; i < list.length ; i++)
	    {
	        
			var	element : HPDF_DictElement	=	list[i];
	        var header : HPDF_Obj_Header = element.value.header as HPDF_Obj_Header;
	        if (header.objClass == HPDF_Obj_Header.HPDF_OCLASS_PROXY)
	        {
	            var p:HPDF_Proxy = element.value as HPDF_Proxy;
	
	            if (p.obj == obj)
	                return element.key;
	        } else {
	            if (element.value == obj)
	                return element.key;
	        }
	    }
	
	    return null;
	} 
	public function HPDF_Dict_AddReal( key: String, value : Number ):void
	{
		var real : HPDF_Real = new HPDF_Real( value );
		this.HPDF_Dict_Add( key, real );
	} 
    
	public	function	HPDF_Info_SetInfoAttr ( type : int , value : String, encoder: HPDF_Encoder ) : void
	{
    	var name : String = InfoTypeToName (type);

	    trace((" HPDF_Info_SetInfoAttr"));
	
	    if (type <= HPDF_InfoType.HPDF_INFO_MOD_DATE )
	    {
	        throw new HPDF_Error ( "HPDF_Info_SetInfoAttr", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
	    }
	
	    HPDF_Dict_Add (name, new HPDF_String(value,encoder));
	}
	
	public	function	InfoTypeToName  ( type : int) : String
	{
	    return HPDF_INFO_ATTR_NAMES[type] as String;
	}
	
	/** functions to override **/
	public	function	freeFn( ) : void
	{
		throw new HPDF_Error("HPDF_Dict.freeFn not implemented" , 0,0);
	}
	public	function	beforeWriteFn( ) : void
	{
		//throw new HPDF_Error("HPDF_Dict.beforeWriteFn not implemented" , 0,0);
		trace("HPDF_Dict.beforeWriteFn not implemented" );
	}
	
	
	public	function	afterWriteFn( stream : HPDF_Stream) : void
	{
		//throw new HPDF_Error("HPDF_Dict.afterWriteFn not implemented" , 0,0);
		trace("HPDF_Dict.afterWriteFn not implemented" );
	}
	public	function	writeFn( stream : HPDF_Stream) : void
	{
		//throw new HPDF_Error("HPDF_Dict.writeFn not implemented" , 0,0);
		trace("HPDF_Dict.writeFn not implemented" );
	}
        
 	}
}