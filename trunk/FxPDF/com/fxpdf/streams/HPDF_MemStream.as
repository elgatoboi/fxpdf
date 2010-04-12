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
	import flash.utils.ByteArray;
	
	import com.fxpdf.types.enum.HPDF_WhenceMode;
	
	public class HPDF_MemStream extends HPDF_Stream
	{
		public function HPDF_MemStream()
		{
			super();
			var memAttr : HPDF_MemStreamAttr	=	new HPDF_MemStreamAttr( );
			attr	=	memAttr;
			 
		}
		
		override	public	function	get	size() : uint
		{
			return (attr as (HPDF_MemStreamAttr)).buf.length;
		}
		override public	function	WriteFunc( data : ByteArray  ) : void
		{
		    //trace(" HPDF_MemStream_WriteFunc");
		    HPDF_MemStream_InWrite (data);
		}
		
		override public	function	SizeFunc ( ) : uint
		{
			var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
			return memAttr.buf.length;
		}
		
		override public	function	ReadFunc ( length : uint  ) : ByteArray 
		{
			var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
			var	ret : ByteArray	=	new ByteArray();
			memAttr.buf.readBytes( ret,0, length ) ;
			return ret;
		}
		
		override public	function	SeekFunc( pos : int, mode: int ) : void
		{
			var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
			if (mode == HPDF_WhenceMode.HPDF_SEEK_SET)
				memAttr.buf.position	=	pos;
			else if (mode == HPDF_WhenceMode.HPDF_SEEK_CUR)
				memAttr.buf.position	=	memAttr.buf.position + pos;
		}
		
		public	function	HPDF_MemStream_FreeData( ) :void
		{
		    trace((" HPDF_MemStream_FreeData\n"));
		
		   var memAttr:HPDF_MemStreamAttr	=	attr as (HPDF_MemStreamAttr) ; // = (HPDF_MemStreamAttr)stream->attr;
		
		    
		    //for (var i:int = 0; i < memAttr.; i++)
		     //   HPDF_FreeMem (stream->mmgr, HPDF_List_ItemAt (attr->buf, i));
		     memAttr.buf	=	new ByteArray;
		
		    //HPDF_List_Clear(attr->buf);
		
		     
		}
		        
		    
/*
HPDF_INT32
HPDF_MemStream_TellFunc  (HPDF_Stream  stream)
{
    HPDF_INT32 ret;
    HPDF_MemStreamAttr attr = (HPDF_MemStreamAttr)stream->attr;

    HPDF_PTRACE((" HPDF_MemStream_TellFunc\n"));

    ret = attr->r_ptr_idx * attr->buf_siz;
    ret += attr->r_pos;

    return ret;
}
*/

/*

HPDF_STATUS
HPDF_MemStream_SeekFunc  (HPDF_Stream      stream,
                          HPDF_INT         pos,
                          HPDF_WhenceMode  mode)
{
    HPDF_MemStreamAttr attr = (HPDF_MemStreamAttr)stream->attr;

    HPDF_PTRACE((" HPDF_MemStream_SeekFunc\n"));

    if (mode == HPDF_SEEK_CUR) {
        pos += (attr->r_ptr_idx * attr->buf_siz);
        pos += attr->r_pos;
    } else if (mode == HPDF_SEEK_END)
        pos = stream->size - pos;

    if (pos > stream->size || stream->size == 0)
        return HPDF_SetError (stream->error, HPDF_STREAM_EOF, 0);

    attr->r_ptr_idx = pos / attr->buf_siz;
    attr->r_pos = pos % attr->buf_siz;
    attr->r_ptr = (HPDF_BYTE*)HPDF_List_ItemAt (attr->buf, attr->r_ptr_idx);
    if (attr->r_ptr == NULL) {
        HPDF_SetError (stream->error, HPDF_INVALID_OBJECT, 0);
        return HPDF_INVALID_OBJECT;
    } else
        attr->r_ptr += attr->r_pos;

    return HPDF_OK;
} 
*/
	
	private	function	HPDF_MemStream_InWrite  ( data : ByteArray ) : void
	{
	 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
	 	
	 	//var	rsize : uint	=	memAttr.bufSiz	-	memAttr.wPos ; 
	 		
    	//trace(" HPDF_MemStream_InWrite");

	    if (data.length <= 0)
	        return ;
	        
	    memAttr.buf.writeBytes( data, 0, data.length );

	  /*  if ( rsize >= count) 
	    {
	        HPDF_MemCpy (attr->w_ptr, *ptr, *count);
	        attr->w_ptr += *count;
	        attr->w_pos += *count;
	        *count = 0;
	    } else {
	        if (rsize > 0) {
	            HPDF_MemCpy (attr->w_ptr, *ptr, rsize);
	            *ptr += rsize;
	            *count -= rsize;
	        }
	        attr->w_ptr = (HPDF_BYTE*)HPDF_GetMem (stream->mmgr, attr->buf_siz);
	
	        if (attr->w_ptr == NULL)
	           return HPDF_Error_GetCode (stream->error);
	
	        if (HPDF_List_Add (attr->buf, attr->w_ptr) != HPDF_OK) {
	            HPDF_FreeMem (stream->mmgr, attr->w_ptr);
	            attr->w_ptr = NULL;
	
	            return HPDF_Error_GetCode (stream->error);
	        }
	        attr->w_pos = 0;
	        */
	        
	     
	}
	
		override   public	function	HPDF2_Stream_Read_UInt4( ) : uint 
 		{
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
			var	number : uint	= memAttr.buf.readUnsignedInt()	;
 		 	return number; 
 		}
 		 /**
 		 * Reads 2 bytes as uint 
 		 * */
 		 override	public	function	HPDF2_Stream_Read_UInt2( ) : uint
 		 {
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
			var	number : uint	= memAttr.buf.readUnsignedShort()	;
 		 	return number;
 		 }
 		 
 		 override public	function	WriteUINT32( value : uint ) : void
 		 {
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
 		 	memAttr.buf.writeUnsignedInt( value );
 		 	
 		 }
 		 override	public	function	WriteUINT16( value : uint ) : void
 		 {
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
 		 	memAttr.buf.writeShort( value );
 		 }
 		 override public	function	WriteINT16( value : int ) : void
 		 {
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
 		 	memAttr.buf.writeShort( value ) ; 
 		 }
 		 override public	function	WriteINT32( value : int ) : void
 		 {
 		 	var	memAttr	: HPDF_MemStreamAttr	=	this.attr as HPDF_MemStreamAttr;
 		 	memAttr.buf.writeInt( value );
 		 }
 		 
 		
 		 
 }
}
 