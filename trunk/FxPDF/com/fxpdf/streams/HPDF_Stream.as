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
package com.fxpdf.streams
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.encrypt.HPDF_Encrypt;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Binary;
	import com.fxpdf.objects.HPDF_Boolean;
	import com.fxpdf.objects.HPDF_DictElement;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_Object;
	import com.fxpdf.objects.HPDF_Proxy;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.enum.HPDF_WhenceMode; 
	import flash.utils.ByteArray ;  
	// import flash.utils.ByteArray ;  
	
	public class HPDF_Stream
	{
		
		public	static	const	 HPDF_STREAM_FILTER_NONE   : Number =	       0x0000;
		public	static	const	 HPDF_STREAM_FILTER_ASCIIHEX  : Number =	       0x0100;
		public	static	const	 HPDF_STREAM_FILTER_ASCII85  : Number =	        0x0200;
		public	static	const	 HPDF_STREAM_FILTER_FLATE_DECODE  : Number =	   0x0400;
		public	static	const	 HPDF_STREAM_FILTER_DCT_DECODE   : Number =	    0x0800;

		/* C 
		HPDF_UINT32               sig_bytes;
    HPDF_StreamType           type;
    HPDF_MMgr                 mmgr;
    HPDF_Error                error;
    HPDF_UINT                 size;
    HPDF_Stream_Write_Func    write_fn;
    HPDF_Stream_Read_Func     read_fn;
    HPDF_Stream_Seek_Func     seek_fn;
    HPDF_Stream_Free_Func     free_fn;
    HPDF_Stream_Tell_Func     tell_fn;
    HPDF_Stream_Size_Func     size_fn;
    void*                     attr; */
    	
    	public	var	sigBytes	: uint ; 
    	public	var	type		: int ; 
    	
    	
    	/*public	var	readFn		: Function; 
    	public	var	seekFn		: Function; 
    	public	var	freeFn		: Function;
    	public	var	tellFn		: Function; 
    	public	var	sizeFn		: Function;
    	*/
    	public	var	attr		: Object ;    

		
		public function HPDF_Stream()
		{
		}
		
		
		public	function	get	size() : uint
		{
			throw new HPDF_Error("get size not implemented" , 0 , 0);
		}
		public	function	WriteFunc( data : ByteArray ) : void
		{
		}
		public	function	ReadFunc ( length : uint ) : ByteArray 
		{
			return null; 
		}
		
		public	function	SeekFunc( pos : int, mode: int ) : void
		{
		}
			
		
		public	function	SizeFunc ( ) : uint 
		{
			return 0; 
		}
		
   		 
   		 public	function	HPDF_Stream_WriteStr( value : String ) :void
   		 {
   		 	var	data : ByteArray =	new ByteArray;
   		 	//data.writeUTF( value ) ;  /// ??????? 
   		 	
   		 	//data.writeMultiByte( value, "ascii");
   		 	for ( var i : int	=	0 ; i <value.length ; i ++ ) 
   		 	{
   		 		var a: uint	=	value.charCodeAt( i ) ; 
   		 		//var b : uint = a;
   		 		data.writeByte( a );
   		 		 
   		 	}
   		 	data.position	=	0; 
   		 	WriteFunc( data ); 
   		 } 
   		 
   		 public	function	HPDF_Stream_WriteStrUTF( value : String ) : int 
   		 {
   		 	var	data : ByteArray =	new ByteArray;
   		 	//data.writeUTF( value ) ;  
   		 	//data.writeUTFBytes( value );
   		 	data.writeMultiByte( value, "unicode");
   		 	/*for ( var i : int	=	0 ; i <value.length ; i ++ ) 
   		 	{
   		 		var a: uint	=	value.charCodeAt( i ) ; 
   		 		//var b : uint = a;
   		 		data.writeByte( a );
   		 		 
   		 	}*/
   		 	data.position	=	0; 
   		 	WriteFunc( data );
   		 	return data.length ;  
   		 } 
   		 
   		 
   		public	function	HPDF_Obj_WriteValue  (	obj:HPDF_Object, e:HPDF_Encrypt ) : void
		{
		    var header:HPDF_Obj_Header	=	obj.header ;
		
		   //trace(" HPDF_Obj_WriteValue");
		
		    /*HPDF_PTRACE((" HPDF_Obj_WriteValue obj=0x%08X obj_class=0x%04X\n",
		            (HPDF_UINT)obj, (HPDF_UINT)header->obj_class));
		*/
			var	clas : Number	=	header.objClass & HPDF_Obj_Header.HPDF_OCLASS_ANY;
		    switch (clas)
		    {
		        case HPDF_Obj_Header.HPDF_OCLASS_NAME:
		            HPDF_Name_Write (obj as HPDF_Name);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_NUMBER:
		            HPDF_Number_Write (obj as HPDF_Number);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_REAL:
		            HPDF_Real_Write (obj as HPDF_Real);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_STRING:
		            HPDF_String_Write (obj as HPDF_String, e);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_BINARY:
		            HPDF_Binary_Write (obj as HPDF_Binary, e);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_ARRAY:
		            HPDF_Array_Write (obj as HPDF_Array, e);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_DICT:
		            HPDF_Dict_Write (obj as HPDF_Dict, e);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_BOOLEAN:
		            HPDF_Boolean_Write (obj as HPDF_Boolean);
		            break;
		        case HPDF_Obj_Header.HPDF_OCLASS_NULL:
		            HPDF_Stream_WriteStr ( "null");
		            break;
		        default:
		        {
		         	throw new HPDF_Error("HPDF_Obj_WriteValue", HPDF_Error.HPDF_ERR_UNKNOWN_CLASS, 0 );
		        }
		    }
		}
		
		
		private	function	HPDF_Name_Write( obj : HPDF_Name ) : void
		{
			 HPDF_Stream_WriteEscapeName (obj.value); 
		}
		
		
		
		public	function	HPDF_Stream_WriteEscapeName ( value : String ) :void
		{
			
		
		    // C char tmp_char[HPDF_LIMIT_MAX_NAME_LEN * 3 + 2];
		    var tmpChar : String ; 
		    var	ret : String = new String( ) ; // result string ; 
		    
		    //const HPDF_BYTE* pos1;
		    var pos1: String ; 
		    //char* pos2;

		   // trace(" HPDF_Stream_WriteEscapeName");
		
		    var len : int = value.length ; // HPDF_StrLen (value, HPDF_LIMIT_MAX_NAME_LEN);
		   /* pos1 = (HPDF_BYTE*)value;
		    pos2 = tmp_char;
		
		    *pos2++ = '/';
		    */
		    ret += '/';
		    for (var i:int = 0 ; i < len; i++)
		    {
		        // HPDF_BYTE c = *pos1++;
		        var	ch	: String	=	value.charAt( i );
		        var c 	: uint		=	value.charCodeAt( i ); 	
		        var p1	: uint ; //replacement char
		        if (HPDF_Utils.HPDF_NEEDS_ESCAPE( ch ))
		        {
		            // C *pos2++ = '#';
		            ret += "#" ; 
		            
		            // *pos2 = (char)(c >> 4);
		            p1	=	c >> 4 ;
		            /* C if (*pos2 <= 9)
		                *pos2 += 0x30;
		            else
		                *pos2 += 0x41 - 10;
		               
		            pos2++; */
		            if ( p1 <= 9 ) 
		            	p1 += 0x30;
		            else
		            	p1 += 0x41 - 10; 
		            	
					ret += String.fromCharCode( p1 );
		            /* C *pos2 = (char)(c & 0x0f);
		            if (*pos2 <= 9)
		                *pos2 += 0x30;
		            else
		                *pos2 += 0x41 - 10;
		            pos2++; */
		            p1 = c & 0x0f ;
		            if ( p1 <= 9 ) 
		            	p1 += 0x30;
		            else
		            	p1 += 0x41 - 10; 
		            ret += String.fromCharCode( p1 );
		            
		        } else
		        {
		          // C  *pos2++ = c;
		          	ret += ch ; 
		        }
		    } // escape loop
		     // return HPDF_Stream_Write (stream, (HPDF_BYTE *)tmp_char, HPDF_StrLen(tmp_char, -1));
		    HPDF_Stream_WriteStr ( ret ) ; 
	} // func
	
	
	
	private	function	HPDF_Number_Write  ( obj : HPDF_Number ) : void
	{
		HPDF_Stream_WriteInt( obj.value );
	}
	
	
	
	
	public	function	HPDF_Stream_WriteInt( value : int ) : void 
	{
		HPDF_Stream_WriteStr( value.toString() ); // TODO check min max
	}
	
	private	function	HPDF_Real_Write  ( obj : HPDF_Real ) : void
	{
		return HPDF_Stream_WriteReal ( obj.value );
	}
	
	public	function	HPDF_Stream_WriteReal( value : Number ) :void
	{
		HPDF_Stream_WriteStr( HPDF_Utils.HPDF_FToA(value, 11) ); // TODO check  min max
	}
	
	
	private	function	HPDF_String_Write( obj : HPDF_String, e: HPDF_Encrypt ) :void
	{
		 /*
	     *  When encoder is not NULL, text is changed to unicode using encoder,
	     *  and it outputs by HPDF_write_binary method.
	     */
		var	tmpLen : uint ; 
    	trace(" HPDF_String_Write");

	    /* TODO if (e)
	        HPDF_Encrypt_Reset (e); */

	    if (obj.encoder == null)
	    {
	        if (e) {
	          /* TODO   if ((ret = HPDF_Stream_WriteChar (stream, '<')) != HPDF_OK)
	                return ret;
	
	            if ((ret = HPDF_Stream_WriteBinary (stream, obj->value,
	                    HPDF_StrLen ((char *)obj->value, -1), e)) != HPDF_OK)
	                return ret;
	
	            return HPDF_Stream_WriteChar (stream, '>');*/
	        } else
	        {
	            HPDF_Stream_WriteEscapeText ( obj.value, obj.encoder );
	            return ; 
	        }
	    }
	    else
	    {
	       /* TODO  HPDF_BYTE* src = obj->value;
	        HPDF_BYTE buf[HPDF_TEXT_DEFAULT_LEN * 2];
	        HPDF_UINT tmp_len = 0;
	        HPDF_BYTE* pbuf = buf;
	        HPDF_INT32 len = obj->len;
	        HPDF_ParseText_Rec  parse_state;
	        HPDF_UINT i;
	
	        if ((ret = HPDF_Stream_WriteChar (stream, '<')) != HPDF_OK)
	           return ret;
	
	        if ((ret = HPDF_Stream_WriteBinary (stream, UNICODE_HEADER, 2, e))
	                        != HPDF_OK)
	            return ret;
	
	        HPDF_Encoder_SetParseText (obj->encoder, &parse_state, src, len);
	
	        for (i = 0; i < len; i++) {
	            HPDF_BYTE b = src[i];
	            HPDF_UNICODE tmp_unicode;
	            HPDF_ByteType btype = HPDF_Encoder_ByteType (obj->encoder,
	                    &parse_state);
	
	            if (tmp_len >= HPDF_TEXT_DEFAULT_LEN - 1) {
	                if ((ret = HPDF_Stream_WriteBinary (stream, buf,
	                            tmp_len * 2, e)) != HPDF_OK)
	                    return ret;
	
	                tmp_len = 0;
	                pbuf = buf;
	            }
	
	            if (btype != HPDF_BYTE_TYPE_TRIAL) {
	                if (btype == HPDF_BYTE_TYPE_LEAD) {
	                    HPDF_BYTE b2 = src[i + 1];
	                    HPDF_UINT16 char_code = (HPDF_UINT) b * 256 + b2;
	
	                    tmp_unicode = HPDF_Encoder_ToUnicode (obj->encoder,
	                                char_code);
	                } else {
	                    tmp_unicode = HPDF_Encoder_ToUnicode (obj->encoder, b);
	                }
	
	                HPDF_UInt16Swap (&tmp_unicode);
	                HPDF_MemCpy (pbuf, (HPDF_BYTE*)&tmp_unicode, 2);
	                pbuf += 2;
	                tmp_len++;
	            }
	            */
	        }
	
	        /* TODO if ( tmpLen > 0) 
	        {
	            if ((ret = HPDF_Stream_WriteBinary (stream, buf, tmp_len * 2, e))
	                            != HPDF_OK)
	                return ret;
	        }
	
	        if ((ret = HPDF_Stream_WriteChar (stream, '>')) != HPDF_OK)
	            return ret;*/
	    }
	    
	    
	    private	function	HPDF_Binary_Write( obj : HPDF_Binary, e : HPDF_Encrypt ) :void
	    {
	    	if (obj.len == 0)
	    	{
		        HPDF_Stream_WriteStr ( "<>");
		        return ; 
		    }
		
		    HPDF_Stream_WriteStr ("<") ;
		        
		
		   /* TODO  if (e)
		        HPDF_Encrypt_Reset (e); */
		
		    HPDF_Stream_WriteBinary (obj.value,  e);
		
		    HPDF_Stream_WriteStr (">"); 
	    	
	    }
	    
	    public	function	HPDF_Stream_WriteBinaryString( str : String, e : HPDF_Encrypt ) : void
	    {
	    	var buf: ByteArray = new ByteArray; 
	    	buf.writeMultiByte( str, "unicode" ) ; 
	    	HPDF_Stream_WriteBinary( buf, e ); 
	    }
	    /** Write binary data **/
	    public	function	HPDF_Stream_WriteBinary  ( data : ByteArray , e : HPDF_Encrypt) : void
	    {
		         
		    /* C char buf[HPDF_TEXT_DEFAULT_LEN];
		    HPDF_BYTE ebuf[HPDF_TEXT_DEFAULT_LEN];
		    HPDF_BYTE *pbuf = NULL;
		    HPDF_BOOL flg = HPDF_FALSE;
		    HPDF_UINT idx = 0;
		    HPDF_UINT i;
		    const HPDF_BYTE* p;
		    HPDF_STATUS ret = HPDF_OK; */
		    var	p : ByteArray	; 
			var ret: ByteArray	=	new ByteArray();
			var	idx : int	=	0;
			var	b : int ; 
			var c : int ; 
			
		    trace(" HPDF_Stream_WriteBinary");

		    if (e) {
		        /* TODO if (len <= HPDF_TEXT_DEFAULT_LEN)
		            pbuf = ebuf;
		        else {
		            pbuf = (HPDF_BYTE *)HPDF_GetMem (stream->mmgr, len);
		            flg = HPDF_TRUE;
		        }
		
		        HPDF_Encrypt_CryptBuf (e, data, pbuf, len);
		        p = pbuf; */
		    } else 
		    {
		        p = data;
		    }
			p.position 	=	0;
		    //for (var i:int = 0; i < data.len; i++)
		    while ( p.bytesAvailable > 0 )
		    {
		    	b	= p.readByte();
		        // C char c = *p >> 4;
		        c = b >> 4 ; 
		
		        if (c <= 9)
		            c += 0x30;
		        else
		            c += 0x41 - 10;
		            
		        // C buf[idx++] = c;
		        ret.writeByte( c );
		
		        c = b & 0x0f;
		        if (c <= 9)
		            c += 0x30;
		        else
		            c += 0x41 - 10;
		        // C buf[idx++] = c;
		        ret.writeByte( c );
		
		        if ( ret.position > HPDF_Consts.HPDF_TEXT_DEFAULT_LEN - 2)
		        {
		            //ret = HPDF_Stream_Write (stream, (HPDF_BYTE *)buf, idx);
		            HPDF_Stream_Write( ret ); 
		            /*if (ret != HPDF_OK) {
		                if (flg)
		                    HPDF_FreeMem (stream->mmgr, pbuf);
		                return ret;
		            }
		            */
		            ret = new ByteArray(); 
		        }
		    }

	   		if (ret.position > 0) 
	   		{
		        HPDF_Stream_Write ( ret );
		    }
		
		    /*if (flg)
		        HPDF_FreeMem (stream->mmgr, pbuf);*/
		    return ;
	    }
	    
	    public	function	HPDF_Stream_Write( data : ByteArray ) :void
	    {
	    	WriteFunc( data ); 
	    }
	    public	function	HPDF_Stream_WriteEscapeText ( text : String, encoder:HPDF_Encoder ) : void
	    {
	    	trace((" HPDF_Stream_WriteEscapeText"));
	    	
	    	var len : int =   text == null ? 0 :  Math.min ( text.length, HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN ) ; 
	    	HPDF_Stream_WriteEscapeText2 ( text,encoder,  len );
	    }
	    
	    public	function	HPDF_Stream_WriteEscapeText2  ( text : String,encoder: HPDF_Encoder,len : uint ) : void 
	    {
			                       
		    //char buf[HPDF_TEXT_DEFAULT_LEN];
		    var ret : String	=	new String; 
		   
		    trace(" HPDF_Stream_WriteEscapeText2");

		    if (!len)
		        return ;

  		  	//buf[idx++] = '(';
  		  	ret = "(";

		    for (var i:int = 0; i < len; i++)
		    {
		        // C HPDF_BYTE c = (HPDF_BYTE)*p++;
		        var c : uint	=	text.charCodeAt( i );
		        if ( encoder)
		        	c = encoder.unicodeToByte ( c) ; 
		        var ch : String	=	text.charAt( i );
		        
		        if ( HPDF_Utils.HPDF_NEEDS_ESCAPE(ch) )
		        {
		            // C buf[idx++] = '\\';
		            ret  += "\\" ;
		            /*buf[idx] = c >> 6;
		            buf[idx] += 0x30;
		            idx++;
		            */
		            var b : int	=	( c >> 6 ) + 0x30;
		            ret += String.fromCharCode( b );
		             
		            /* C buf[idx] = (c & 0x38) >> 3;
		            buf[idx] += 0x30; 
		            idx++;*/
		            b =	( (c & 0x38) >> 3 ) + 0x30;
		            ret += String.fromCharCode( b );
		            
		            /* buf[idx] = (c & 0x07);
		            buf[idx] += 0x30;
		            idx++; */
		            b =	( c & 0x07 ) + 0x30;
		            ret += String.fromCharCode( b );
		            
		        }
		        else
		        {
		            ret += ch;
		        } 

		        // if (idx > HPDF_TEXT_DEFAULT_LEN - 4) {
		        if (  ret.length > HPDF_Consts.HPDF_TEXT_DEFAULT_LEN - 4)
		        {
		            HPDF_Stream_WriteStr ( ret );
		            ret = new String ( ); 
		        }
	    }
	    // C buf[idx++] = ')';
	    ret += ")";

   		HPDF_Stream_WriteStr (ret);
   		}
   		
   		
   		private	function	HPDF_Array_Write( array : HPDF_Array, e:HPDF_Encrypt ) : void
   		{
		  
		    trace(" HPDF_Array_Write");
		
		    HPDF_Stream_WriteStr ( "[ ");
		    
		
		    for (var i : int = 0; i < array.list.count; i++)
		    {
		        // C void * element = HPDF_List_ItemAt (array->list, i);
		        var element :HPDF_Object = array.list.obj[i] ;
		
		        HPDF_Obj_Write (element, e);
		        
		        HPDF_Stream_WriteStr (" ");
		        
		    }
		
		    HPDF_Stream_WriteStr ( "]");
   		}
   		
   		
   		private	function	HPDF_Obj_Write ( obj : HPDF_Object,e : HPDF_Encrypt ) : void
   		{
         
		    //HPDF_Obj_Header *header = (HPDF_Obj_Header *)obj;
		    var	header : HPDF_Obj_Header	=	obj.header ; 
		
		    //trace(" HPDF_Obj_Write");
		
		    if (header.objId & HPDF_Obj_Header.HPDF_OTYPE_HIDDEN)
		    {
		         trace("#HPDF_Obj_Write obj=0x%08X skipped" ) ;
		         return ;
		    }
		
		    if (header.objClass == HPDF_Obj_Header.HPDF_OCLASS_PROXY)
		    {
		        /*char buf[HPDF_SHORT_BUF_SIZ];
		        char *pbuf = buf;
		        char *eptr = buf + HPDF_SHORT_BUF_SIZ - 1;
		        */
		        var p : HPDF_Proxy	=	obj as HPDF_Proxy; 
		        // HPDF_Proxy p = obj;
				
		        header = p.obj.header as HPDF_Obj_Header ; 
				//  
				var	pbuf : String = new String ( ) ; 
		        //pbuf = HPDF_IToA (pbuf, header->obj_id & 0x00FFFFFF, eptr);
		        pbuf	=	(header.objId & 0x00FFFFFF).toString() ; 
		        
		        // C *pbuf++ = ' ';
		        pbuf	+=	 " " ;
		        // C pbuf = HPDF_IToA (pbuf, header->gen_no, eptr);
		        pbuf	+=	header.genNo.toString(); 
		        // C  HPDF_StrCpy(pbuf, " R", eptr);
		        pbuf	+=	" R";
		        HPDF_Stream_WriteStr( pbuf);
		        return ; 
		    }
		    
		    HPDF_Obj_WriteValue(obj, e);
   		}
   		
   		///////////////////////////////////////////
   		
   		public	function	HPDF_Dict_Write( dict: HPDF_Dict, e:HPDF_Encrypt ) :void
   		{
   			
		    HPDF_Stream_WriteStr ( HPDF_Utils.ParseString("<<\\012") );
		    
		
		    if (dict.beforeWriteFn ())
		    {
		        dict.beforeWriteFn( );
		    }

		    /* encrypt-dict must not be encrypted. */
		    if (dict.header.objClass == (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_ENCRYPT))
		        e = null;
		
		    if (dict.stream)
		    {
		        /* set filter element */
		        if (dict.filter == HPDF_STREAM_FILTER_NONE)
		           dict.HPDF_Dict_RemoveElement("Filter");
		        else
		        {
		            var array : HPDF_Array = dict.HPDF_Dict_GetItem ( "Filter",HPDF_Obj_Header.HPDF_OCLASS_ARRAY) as HPDF_Array;
		
		            if (!array)
		            {
		                array = new HPDF_Array( ) ;
		                
		                dict.HPDF_Dict_Add( "Filter", array);
		            }
		
		            array.HPDF_Array_Clear( ); 

					/* TODO #ifndef HPDF_NOZLIB
					            if (dict->filter & HPDF_STREAM_FILTER_FLATE_DECODE)
					                HPDF_Array_AddName (array, "FlateDecode");
					#endif /* HPDF_NOZLIB */

		            if (dict.filter & HPDF_STREAM_FILTER_DCT_DECODE)
		                array.HPDF_Array_AddName ("DCTDecode");
		        }
		    } // if dict.stream

		    for (var i:int = 0; i < dict.list.length; i++)
		    {
		       var element: HPDF_DictElement = dict.list[i];
		       var header: HPDF_Obj_Header	=	element.value.header;
		        //HPDF_Obj_Header *header = (HPDF_Obj_Header *)(element->value);
		
		        if (!element.value)
		        {
		          //  return HPDF_SetError (dict->error, HPDF_INVALID_OBJECT, 0);
		          throw new HPDF_Error( "HPDF_Dict_Write", HPDF_Error.HPDF_INVALID_OBJECT, 0 ) ;  
		        }
		
		        if  (header.objId & HPDF_Obj_Header.HPDF_OTYPE_HIDDEN)
		        {
		            trace((" HPDF_Dict_Write obj=%p skipped obj_id=0x%08X\n")) ; 
		                    //element->value, (HPDF_UINT)header->obj_id));
		        } else
		        {
		            HPDF_Stream_WriteEscapeName (element.key);
		            
		            HPDF_Stream_WriteStr (" ");
		            
		
		            HPDF_Obj_Write (element.value, e);
		            
		            HPDF_Stream_WriteStr ( HPDF_Utils.ParseString("\\012") );
		        }
		    }

		    if (dict.writeFn)
		    {
		        dict.writeFn (this);
			}
		
		    HPDF_Stream_WriteStr (">>") ;
				        
		
		    if (dict.stream)
		    {
		        /* get "length" element */
		       var length:HPDF_Number = dict.HPDF_Dict_GetItem ("Length",HPDF_Obj_Header.HPDF_OCLASS_NUMBER) as HPDF_Number;
		       if (!length)
		       {
		            //return HPDF_SetError (dict->error, HPDF_DICT_STREAM_LENGTH_NOT_FOUND, 0);
		            throw new HPDF_Error ( "HPDF_Dict_Write", HPDF_Error.HPDF_DICT_STREAM_LENGTH_NOT_FOUND, 0 ) ;
		       }
		
		       /* "length" element must be indirect-object */
		       if (!(length.header.objId & HPDF_Obj_Header.HPDF_OTYPE_INDIRECT))
		       {
		            //return HPDF_SetError (dict->error, HPDF_DICT_ITEM_UNEXPECTED_TYPE,               0);
		            throw new HPDF_Error("HPDF_Dict_Write" , HPDF_Error.HPDF_DICT_ITEM_UNEXPECTED_TYPE, 0 ) ;
		       }
		
		      HPDF_Stream_WriteStr ( HPDF_Utils.ParseString( "\\012stream\\015\\012") ) ; 
	          // TODO strptr = stream.size;

		      /* TODO  if (e)
		            HPDF_Encrypt_Reset (e); */
			 var strptr : int = size ; 
	         HPDF_Stream_WriteToStream ( dict.stream, dict.filter, e);
	            
	         length.HPDF_Number_SetValue (size - strptr);
	
	         HPDF_Stream_WriteStr ( HPDF_Utils.ParseString( "\\012endstream" ) );
	    }

		    /* 2006.08.13 add. */
		    if ( dict.afterWriteFn )
		    {
		        dict.afterWriteFn (this );
		    }
		
   		}
   		
   		private	function	HPDF_Boolean_Write  ( obj:HPDF_Boolean ) : void 
   		{
		    if (obj.value)
		        HPDF_Stream_WriteStr (  "true");
		    else
		        HPDF_Stream_WriteStr ( "false");
		}
		
		
		
		public	function	HPDF_Stream_WriteToStream ( src:HPDF_Stream, filter:uint, e:HPDF_Encrypt ) : void
		{
		
		    /*HPDF_STATUS ret;
		    HPDF_BYTE buf[HPDF_STREAM_BUF_SIZ];
		    HPDF_BYTE ebuf[HPDF_STREAM_BUF_SIZ];
		    HPDF_BOOL flg;
*/		
		    trace(" HPDF_Stream_WriteToStream");
		
		    
			/* TODO #ifndef HPDF_NOZLIB
			    if (filter & HPDF_STREAM_FILTER_FLATE_DECODE)
			        return HPDF_Stream_WriteToStreamWithDeflate (src, dst, e);
			#endif /* HPDF_NOZLIB */ 
		
		    /* initialize input stream */
		    if (src.HPDF_Stream_Size () == 0)
		        return ;
		
		    src.HPDF_Stream_Seek (0, HPDF_WhenceMode.HPDF_SEEK_SET );
				    
		    var flg:Boolean = false;
	        var size:uint = HPDF_Conf.HPDF_STREAM_BUF_SIZ;
	        
	
	        var buf : ByteArray	=	src.HPDF_Stream_Read ( src.HPDF_Stream_Size() );
			if ( buf.length == 0 ) 
				return ; 
	        flg = true; 
	
	       if (e) {
	          /* TODO  HPDF_Encrypt_CryptBuf (e, buf, ebuf, size);
	            ret = HPDF_Stream_Write(dst, ebuf, size);*/
	        } else { 
	           HPDF_Stream_Write(buf);
	        }
	
	      
		}

    	public	function	HPDF_Stream_Read ( length : int ) : ByteArray
    	{
    		return ReadFunc( length ) ; 
    	}
    	
    	public	function	HPDF_Stream_Seek( pos : int,  mode : int ) : void
    	{
    	
    	  	
    		trace(" HPDF_Stream_Seek");

		    SeekFunc(pos, mode);
		 }
		 
		 public	function	HPDF_Stream_Size( ) :int
		 {
		 	return SizeFunc ( ) ; 
		 }
		 
		 public	function   HPDF_Stream_WriteUInt( value : uint ) : void
		 {
          	HPDF_Stream_WriteInt ( value ) ; 
 		 }
 		 
 		 public	function	HPDF_Stream_Free( ) : void
 		 {
 		 	null ; 
 		 }
 		 
 		 /** functions to read bytes and transform to other types **/
 		 
 		 /**
 		 * Reads 4bytes and converts to uint
 		 * */
 		 public	function	HPDF2_Stream_Read_UInt4( ) : uint 
 		 {
 		 	return null; 
 		 }
 		 /**
 		 * Reads 2 bytes as uint 
 		 * */
 		 public	function	HPDF2_Stream_Read_UInt2( ) : uint
 		 {
 		 	return null ; 
 		 }
 		 
 		 
 		 public	function	WriteUINT32( value : uint ) : void
 		 {
 		 	throw new HPDF_Error("WriteUINT32 not implemented" , 0 , 0);
 		 }
 		 public	function	WriteUINT16( value : uint ) : void
 		 {
 		 	throw new HPDF_Error("WriteUINT16 not implemented" , 0 , 0);
 		 }
 		 public	function	WriteINT16( value : int ) : void
 		 {
 		 	throw new HPDF_Error("WriteINT16 not implemented" , 0 , 0);
 		 }
 		 public	function	WriteINT32( value : int ) : void
 		 {
 		 	throw new HPDF_Error("WriteINT32 not implemented" , 0 , 0);
 		 }
 		 
 		  public	function	HPDF_MemStream_Rewrite  ( buf : ByteArray , size : uint ) : void
 		 {
			    
			    var	attr : HPDF_MemStreamAttr	=	attr as HPDF_MemStreamAttr;
			    var	bufSize : uint ; 
			    var	rlen : uint = size; 
			    
			    trace(" HPDF_MemStream_Rewrite");
			
			    /* TODO while (rlen > 0)
			    {
			        
			        var	tmpLen  :uint ; 
			
			        if (attr.buf.count <= attr.rPtrIdx)
			        {
			            HPDF_STATUS ret = HPDF_MemStream_WriteFunc (stream, buf, rlen);
			            attr.rPtrIdx = attr.buf.count;
			            attr.rPos = attr.wPos;
			            attr.rPtr = attr.wPtr;
			            return ret;
			        } else if (attr.buf.count == attr.rPtrIdx)
			            tmpLen = attr.wpos - attr.rPos;
			        else
			            tmpLen = attr.bufSiz - attr.rPos;
			
			        if (tmpLen >= rlen) {
			            HPDF_MemCpy(attr.r_ptr, buf, rlen);
			            attr.r_pos += rlen;
			            attr.r_ptr += rlen;
			            return HPDF_OK;
			        } else {
			            HPDF_MemCpy(attr.r_ptr, buf, tmp_len);
			            buf += tmp_len;
			            rlen -= tmp_len;
			            attr.r_ptr_idx++;
			
			            if (attr.buf.count > attr.r_ptr_idx) {
			                attr.r_pos = 0;
			                attr.r_ptr = HPDF_MemStream_GetBufPtr (stream, attr.r_ptr_idx,
			                        &buf_size);
			            }
			        }
			    }
			    return HPDF_OK;
			    */
			}
			
}
  
}
 

    
    
    
                                    
	

   		 

 


