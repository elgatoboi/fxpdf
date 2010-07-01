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
package com.fxpdf.xref
{
	import __AS3__.vec.Vector;
	
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.HPDF_Xref_Entry;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encrypt.HPDF_Encrypt;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.streams.HPDF_Stream;
	
	public class HPDF_Xref
	{
		public	static	const	HPDF_FREE_ENTRY	: String	=	"f";
		public	static	const	HPDF_IN_USE_ENTRY : String	=	"n";	
		/*#define HPDF_FREE_ENTRY             'f'
#define HPDF_IN_USE_ENTRY           'n'*/
		/** C 
		 *  HPDF_MMgr    mmgr;
      HPDF_Error   error;
      HPDF_UINT32  start_offset;
      HPDF_List    entries;
      HPDF_UINT    addr;
      HPDF_Xref    prev;
      HPDF_Dict    trailer; 
      * */
      
      	public	var	error : HPDF_Error; 
      	public	var	startOffset : Number; 
      	public	var	entries : Vector.<HPDF_Xref_Entry> ;
      	public	var	addr : Number ; 
      	public	var	prev : HPDF_Xref ; 
      	public	var	trailer : Object ;  
      	
      	
      	
      	/** equals to HPDF_Xref_New */
		public function HPDF_Xref( offset : Number) : void
		{
			
		    var newEntry : HPDF_Xref_Entry	 = new HPDF_Xref_Entry( ) ;
			var	i : int ; 
		    trace((" HPDF_Xref_New\n"));
		
		    
    		startOffset	=	offset;

	    	entries	=	new Vector.<HPDF_Xref_Entry>;
	    	
    		this.addr	=	0;

            if ( startOffset == 0 ) 
            {
            	newEntry	=	new HPDF_Xref_Entry ;
				
		        entries.push( newEntry ) ;

		        /* add first entry which is free entry and whose generation
		         * number is 0
		         */
		        newEntry.entryTyp	=	HPDF_FREE_ENTRY;
		        newEntry.byteOffset	=	0;
		        newEntry.genNo		=	HPDF_Consts.HPDF_MAX_GENERATION_NUM;
		        newEntry.obj		= 	null ; 
    		}

		    trailer = new HPDF_Dict ( ) ;
		    error	=	new HPDF_Error( );
		}
		
		
		public	function HPDF_Xref_Free( ) : Number
		{

			/* HPDF_UINT i;
		    HPDF_XrefEntry entry;
		    HPDF_Xref tmp_xref;
		
		*/
			var entry : HPDF_Xref_Entry ;
			var	tmpXref : HPDF_Xref ;
		   trace((" HPDF_Xref_Free\n"));
		
		    /* delete xref entries. where prev element is not NULL,
		     * delete all xref entries recursively.
		     */
		    var lxref : HPDF_Xref	=	this; 
		    while (lxref != null)
		    {
		        /* delete all objects belong to the xref. */
		
		        if (lxref.entries)
		        {
		            for (var i:int = 0; i < lxref.entries.length; i++) 
		            {
		                entry = lxref.HPDF_Xref_GetEntry ( i );
		                if (entry.obj)
		                {
		                    //HPDF_Obj_ForceFree (xref->mmgr, entry->obj);
		                    entry.obj	=	null ; 
		                }
		                // HPDF_FreeMem (xref->mmgr, entry);
		            }
		            ///HPDF_List_Free(xref->entries);
		            lxref.entries	=	null ; 
		        }
		
		        if (lxref.trailer)
		        {
		 	      //     HPDF_Dict_Free (xref->trailer);
		 	      lxref.trailer	=	null; 
		        }
		
		        tmpXref = lxref.prev;
		        //HPDF_FreeMem (xref->mmgr, xref);
		        lxref = null ; 
		        lxref = tmpXref;
		    } 
		    return HPDF_Consts.HPDF_OK;
		}
				
		public	function	HPDF_Xref_Add( obj : Object): void
		{
			
			trace((" HPDF_Xref_Add\n"));
			
			if (!obj) {
				throw new HPDF_Error("HPDF_Xref_Add", HPDF_Error.HPDF_INVALID_OBJECT, 0);
			}
			
			var header:HPDF_Obj_Header = obj.header as HPDF_Obj_Header; //(HPDF_Obj_Header *)obj;
			
			if (header.objId & HPDF_Obj_Header.HPDF_OTYPE_DIRECT ||
				header.objId & HPDF_Obj_Header.HPDF_OTYPE_INDIRECT)
			{
				throw new HPDF_Error("HPDF_Xref_Add", HPDF_Error.HPDF_INVALID_OBJECT, 0);
			}
			
			if (entries.length >= HPDF_Consts.HPDF_LIMIT_MAX_XREF_ELEMENT )
			{
				throw new HPDF_Error("HPDF_Xref_Add", HPDF_Error.HPDF_XREF_COUNT_ERR, 0);
			}
			
			/* in the following, we have to dispose the object when an error is
			* occured.
			*/
			
			var entry : HPDF_Xref_Entry	=	new HPDF_Xref_Entry;
			
			/*if (HPDF_List_Add(xref->entries, entry) != HPDF_OK) {
			HPDF_FreeMem (xref->mmgr, entry);
			goto Fail;
			}
			*/
			
			entries.push( entry );
			
			entry.entryTyp	=	HPDF_IN_USE_ENTRY;
			entry.byteOffset	=	0;
			entry.genNo	=	0;
			entry.obj	=	obj;
			
			header.objId	=	startOffset + entries.length -1 + HPDF_Obj_Header.HPDF_OTYPE_INDIRECT;
			header.genNo	=	entry.genNo;
			
		}
		
		private	function	HPDF_Xref_GetEntry ( index : int ) : HPDF_Xref_Entry
		{
			return entries[index];
		} 
		
		public function HPDF_Xref_GetEntryByObjectId  ( objId : uint) : HPDF_Xref_Entry
		{
			var tmpXref		: HPDF_Xref = this;
			
			trace(" HPDF_Xref_GetEntryByObjectId");
			
			while (tmpXref) {
				var i : uint; 
				
				if (tmpXref.entries.length + tmpXref.startOffset > objId) {
					throw new HPDF_Error("HPDF_Xref_GetEntryByObjectId", HPDF_Error.HPDF_INVALID_OBJ_ID, 0);
				}
				
				if (tmpXref.startOffset < objId) {
					for (i = 0; i < tmpXref.entries.length; i++) {
						if (tmpXref.startOffset + i == objId) {
							var entry : HPDF_Xref_Entry = tmpXref.HPDF_Xref_GetEntry( i ); 
							return entry;
						}
					}
				}
				
				tmpXref = tmpXref.prev;
			}
			
			return null;
		}
		
		
		
		
		
		public	function	HPDF_Xref_WriteToStream( stream : HPDF_Stream, e : HPDF_Encrypt ) : void
		{
			var i		: int;
			var entry 	: HPDF_Xref_Entry;
			
		    //char buf[HPDF_SHORT_BUF_SIZ];
		    //char* pbuf;
		    //char* eptr = buf + HPDF_SHORT_BUF_SIZ - 1;
		    
		    var strIdx : uint	;
		    
			var tmpXref : HPDF_Xref	=	this ;
			var buf 	: String ; 
			var pbuf : String ; 
    		/* write each objects of xref to the specified stream */

		    trace(" HPDF_Xref_WriteToStream");
		
		    while (tmpXref)
		    {
		        if (tmpXref.startOffset == 0)
		            strIdx = 1;
		        else
		            strIdx = 0;
		
		        for ( i = strIdx; i < tmpXref.entries.length ; i++)
		        {
		            entry 	=	tmpXref.entries[i]; 
					
		            var	objId : uint	=	tmpXref.startOffset + i; 
		            var genNo : uint	=	entry.genNo ; 
		
		            entry.byteOffset	=	stream.size ;
		            
		
		            pbuf	=	new String();
		            pbuf	=	HPDF_Utils.HPDF_IToA( objId );
		            pbuf	+=	" ";
		            pbuf	+=	HPDF_Utils.HPDF_IToA( genNo );
		            
		            pbuf += HPDF_Utils.ParseString(" obj\\012" );
					trace("Writing object");
		            stream.HPDF_Stream_WriteStr( pbuf );
		
		            if (e)
		                e.HPDF_Encrypt_InitKey (objId, genNo);
					
		            stream.HPDF_Obj_WriteValue( entry.obj, e) ; 
		
		            stream.HPDF_Stream_WriteStr (HPDF_Utils.ParseString("\\012endobj\\012"));
		                
		       }
		
		       tmpXref = tmpXref.prev;
		    }

		    /* start to write cross-reference table */
		
		    tmpXref = this;
		
		    while (tmpXref)
		    {
		        tmpXref.addr = stream.size;
		
		        //pbuf = buf;
		        //pbuf = (char *)HPDF_StrCpy (pbuf, "xref\012", eptr);
		        pbuf	=	 HPDF_Utils.ParseString("xref\\012");
		        //pbuf = HPDF_IToA (pbuf, tmp_xref->start_offset, eptr);
		        //*pbuf++ = ' ';
		        pbuf += tmpXref.startOffset.toString(); 
		        pbuf 	=	 pbuf + " ";
		        //pbuf = HPDF_IToA (pbuf, tmp_xref->entries->count, eptr);
		        pbuf 	=	pbuf + tmpXref.entries.length.toString( );
		        
		        //HPDF_StrCpy (pbuf, "\012", eptr);
		        pbuf	=	pbuf + HPDF_Utils.ParseString("\\012");
		        
		        //ret = HPDF_Stream_WriteStr (stream, buf);
		        stream.HPDF_Stream_WriteStr( pbuf );
		       
		
		        for (i = 0; i < tmpXref.entries.length; i++) 
		        {
		            // C HPDF_XrefEntry entry = HPDF_Xref_GetEntry(tmp_xref, i);
		            entry =	tmpXref.HPDF_Xref_GetEntry( i );
		
		            //pbuf = buf;
		            pbuf	=	new String ();
		            //pbuf = HPDF_IToA2 (pbuf, entry->byte_offset, HPDF_BYTE_OFFSET_LEN +  1);
		            pbuf	+= HPDF_Utils.IToA2( entry.byteOffset, HPDF_Consts.HPDF_BYTE_OFFSET_LEN +  1 ) ; 
		            
		            //*pbuf++ = ' ';
		            pbuf	+= 	" ";
		            // pbuf = HPDF_IToA2 (pbuf, entry->gen_no, HPDF_GEN_NO_LEN + 1);
		            pbuf	=	pbuf	+ HPDF_Utils.IToA2( entry.genNo, HPDF_Consts.HPDF_GEN_NO_LEN +  1 ) ;  
		            // C*pbuf++ = ' ';
		            pbuf	=	pbuf + " ";
		            //*pbuf++ = entry->entry_typ;
		            pbuf	=	pbuf + entry.entryTyp.toString() ;
		            //HPDF_StrCpy (pbuf, "\015\012", eptr);
		            pbuf	=	pbuf + HPDF_Utils.ParseString("\\015\\012" );
		            //ret = HPDF_Stream_WriteStr (stream, buf);
		            stream.HPDF_Stream_WriteStr( pbuf );
		        }
		
		        tmpXref = tmpXref.prev;
    }

	    /* write trailer dictionary */
	   	WriteTrailer ( stream);

		}
		
		
	private	function	WriteTrailer  ( stream : HPDF_Stream ) : void 
	{
     	var maxObjId : uint	=	entries.length + startOffset;

    	trace (" WriteTrailer");

	    trailer.HPDF_Dict_AddNumber  ("Size", maxObjId) ;
			            
	    if (prev)
	    {
	        trailer.HPDF_Dict_AddNumber ("Prev", prev.addr);
	    }
	    
	
	    stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString("trailer\\012") );
	        
	    //trailer.HPDF_Dict_Write ( stream, null);
	    stream.HPDF_Dict_Write( trailer as HPDF_Dict, null as HPDF_Encrypt ) ; 
	        
	    stream.HPDF_Stream_WriteStr (HPDF_Utils.ParseString ( "\\012startxref\\012"));
	        
	    stream.HPDF_Stream_WriteUInt ( addr);
	        	
	    stream.HPDF_Stream_WriteStr (HPDF_Utils.ParseString("\\012%%EOF\\012"));
	   }
		
	}
}