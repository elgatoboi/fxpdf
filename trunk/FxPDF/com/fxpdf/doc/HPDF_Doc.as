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
package com.fxpdf.doc
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.catalog.HPDF_Catalog;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_Outline;
	import com.fxpdf.encoder.HPDF_BasicEncoder;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.font.HPDF_FontAttr;
	import com.fxpdf.font.HPDF_FontDef;
	import com.fxpdf.font.HPDF_TTFont;
	import com.fxpdf.font.HPDF_Type0Font;
	import com.fxpdf.font.HPDF_Type1Font;
	import com.fxpdf.font.HPDF_Type1FontDefAttr;
	import com.fxpdf.font.ttf.HPDF_FontDef_TT;
	import com.fxpdf.font.type1.HPDF_FontDef_Type1;
	import com.fxpdf.objects.HPDF_List;
	import com.fxpdf.objects.HPDF_Pages;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.streams.HPDF_MemStream;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_PageMode;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	import com.fxpdf.types.enum.HPDF_InfoType;
	import com.fxpdf.types.enum.HPDF_PdfVer;
	import com.fxpdf.xref.HPDF_Xref;
	//import flash.utils.ByteArray;
	
	/** 
	 * Main class represents whole pdf document
	 * */
	public class HPDF_Doc
	{
		
		import flash.utils.ByteArray;
		private	static const HPDF_VERSION_STR:Array	= [
                "%PDF-1.2\\012%\\267\\276\\255\\252\\012",
                "%PDF-1.3\\012%\\267\\276\\255\\252\\012",
                "%PDF-1.4\\012%\\267\\276\\255\\252\\012",
                "%PDF-1.5\\012%\\267\\276\\255\\252\\012",
                "%PDF-1.6\\012%\\267\\276\\255\\252\\012",
                "%PDF-1.7\\012%\\267\\276\\255\\252\\012" ]; 
                
                
        public	static	const	HPDF_MAJOR_VERSION : Number = 2;
		public	static	const	HPDF_MINOR_VERSION  : Number = 1;
		public	static	const	HPDF_BUGFIX_VERSION  : Number = 0  ;
		public	static	const	HPDF_EXTRA_VERSION : String = "";
		public	static	const	HPDF_VERSION_TEXT  : String = "2.1.0";
		public	static	const	HPDF_VERSION_ID : Number =  20100 ;         
		public	static	const	HPDF_SIG_BYTES : Number	=	 0x41504446 ; 
		/* local variables */
		private	var	_userErrorFunc : Function; // user error handler function
		
		
		//private	var	sigBytes : Number ; 
		private	var	sigBytes	: Number ; 
		public	var	pdfVersion  : int ; 
		
		public	var	compressionMode : Number ; 
		
		public	var	error :HPDF_Error;
		
		public	var	xref : HPDF_Xref ; 
		public	var	rootPages	: HPDF_Pages;
		public	var	curPages	: HPDF_Pages; 
		public	var	curPage		: HPDF_Page ; 
		
		public	var	pageList	: HPDF_List ;
		
		public	var	info	: HPDF_Dict; 
		public	var	trailer : HPDF_Dict ;
		
		public	var	catalog : HPDF_Catalog;
		
		public	var	pagePerPages	: Number ;
		public	var	curPageNum		: Number ;
		
		public	var	stream	: HPDF_Stream ;  
		
		public	var	curEncoder : HPDF_Encoder ; 	
		public	var	encoderList : HPDF_List  ; 
		
		
		/*** FONTS **/
		public	var	fontdefList	: HPDF_List ; 
		public	var	fontMgr		: HPDF_List ; 
		public	var	ttfontTag	: String ; 
		
		
		public	var outlines : HPDF_Outline ; 
		/** C VARIABLES *.
		  HPDF_UINT32     sig_bytes;
	    HPDF_PDFVer     pdf_version;
	
	    HPDF_MMgr         mmgr;
	    HPDF_Catalog      catalog;
	    HPDF_Outline      outlines;
	    HPDF_Xref         xref;
	    HPDF_Pages        root_pages;
	    HPDF_Pages        cur_pages;
	    HPDF_Page         cur_page;
	    HPDF_List         page_list;
	    HPDF_Error_Rec    error;
	    HPDF_Dict         info;
	    HPDF_Dict         trailer;
	
	    HPDF_List         font_mgr;
	    HPDF_BYTE         ttfont_tag[6];
	
	    HPDF_List         fontdef_list;
	
	    HPDF_List         encoder_list;
	
	    HPDF_Encoder      cur_encoder;
	
	    HPDF_BOOL         compression_mode;
	
	    HPDF_BOOL         encrypt_on;
	    HPDF_EncryptDict  encrypt_dict;
	
	    HPDF_Encoder      def_encoder;
	
	    HPDF_UINT         page_per_pages;
	    HPDF_UINT         cur_page_num;
	
	    HPDF_Stream       stream;
	    */
			
		/** equals to HPDF_New **/
		public function HPDF_Doc( userErrorFunc:Function = null, userData : Object = null) 
		{
			
                
			 var	tmpError : HPDF_Error = new HPDF_Error;
			_userErrorFunc	=	userErrorFunc;
			
			/* initialize temporary-error object */
		    // HPDF_Error_Init (&tmp_error, user_data);
		    tmpError.HPDF_Error_Init( 	userData ) ; 
		
		    /* create memory-manager object */
		  /*  mmgr = HPDF_MMgr_New (&tmp_error, mem_pool_buf_size, user_alloc_fn,
		            user_free_fn);
		    if (!mmgr) {
		        HPDF_CheckError (&tmp_error);
		        return NULL;
		    }
		    */
		

		    this.pdfVersion	=	HPDF_PdfVer.HPDF_VER_13 ;
		    this.sigBytes	=	HPDF_SIG_BYTES;
		     	
		    //pdf->compression_mode = HPDF_COMP_NONE;
		    this.compressionMode	=	HPDF_Consts.HPDF_COMP_NONE; 
		
		    /* copy the data of temporary-error object to the one which is
		       included in pdf_doc object */
		    //pdf->error = tmp_error;\
		    this.error	=	tmpError;
		
		    /* switch the error-object of memory-manager */
		    // mmgr->error = &pdf->error;
		
		   HPDF_NewDoc( );
		    
		
		}
		
		
		
		
		private	function	HPDF_NewDoc ( ) : void
		{
			/*char buf[HPDF_TMP_BUF_SIZ];
		    char *ptr = buf;
		    char *eptr = buf + HPDF_TMP_BUF_SIZ - 1;
		    const char *version;
			*/
			trace (" HPDF_NewDoc\n");
		
		    /*if (!HPDF_Doc_Validate (pdf))
		        return HPDF_DOC_INVALID_OBJECT;
		        */
		
		    HPDF_FreeDoc ();
			
		    //pdf->xref = HPDF_Xref_New (pdf->mmgr, 0);
		    xref	=	new HPDF_Xref ( 0 );
		   
		    trailer = xref.trailer as HPDF_Dict; // pdf->xref->trailer;
		
		    fontMgr = new HPDF_List ( HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK);
		   
		    if (!fontdefList)
		    {
		        fontdefList = new HPDF_List( HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK);
		        
		    }
		
		    if (!encoderList) {
		        encoderList = new HPDF_List( HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK);
		    }
			
		    catalog	=	new HPDF_Catalog( xref ) ;
		    
		
		    rootPages = catalog.HPDF_Catalog_GetRoot ();
		    
		    pageList = new HPDF_List (HPDF_Conf.HPDF_DEF_PAGE_LIST_NUM);
		    		    
		    curPages = rootPages;
		
		    var	ptr 			: String = "FxPDF.com Library " ;
		    var version 		: String = HPDF_GetVersion ();
			
		    ptr += version ; 
		    
		    HPDF_SetInfoAttr ( HPDF_InfoType.HPDF_INFO_PRODUCER, ptr)
		    
		     		   
		}
		
		
		private	function	HPDF_FreeDoc  () : void
		{
			
			trace(" HPDF_FreeDoc");

	   		if (this.xref)
	   		{
		          xref.HPDF_Xref_Free( );
		          xref = null;
		    }
		        
	
	        /* TODO if (pdf->font_mgr) {
	            HPDF_List_Free (pdf->font_mgr);
	            pdf->font_mgr = NULL;
	        }

	        if (pdf->fontdef_list)
    	        CleanupFontDefList (pdf);
				*/
	        // TODO HPDF_MemSet(pdf->ttfont_tag, 0, 6);
	
	        this.pdfVersion	=	HPDF_PdfVer.HPDF_VER_13;
	        /* TODO 
	        pdf->outlines = NULL;
	        pdf->catalog = NULL;
	        pdf->root_pages = NULL;
	        pdf->cur_pages = NULL;
	        pdf->cur_page = NULL;
	        pdf->encrypt_on = HPDF_FALSE;
	        pdf->cur_page_num = 0;
	        pdf->cur_encoder = NULL;
	        pdf->def_encoder = NULL;
	        pdf->page_per_pages = 0;
	
	        if (pdf->page_list) {
	            HPDF_List_Free (pdf->page_list);
	            pdf->page_list = NULL;
	        }
	
	        pdf->encrypt_dict = NULL;
	        pdf->info = NULL;
			*/
	        //HPDF_Error_Reset (&pdf->error);
	        this.error.HPDF_Error_Reset ( ) ; 
	
	        /* TODO if (pdf->stream) {
	            HPDF_Stream_Free (pdf->stream);
	            pdf->stream = NULL;
	        }
	        */
  	  }
  	  
  	  
  	  public	function	HPDF_AddPage( ) : HPDF_Page
  	  {
  	  	 trace (" HPDF_AddPage");

	     /* TODO if (!HPDF_HasDoc ())
	        return null;*/

		 if (pagePerPages != -1) 
		 {
	        if (pagePerPages <= curPageNum)
	        {
	            curPages	=	HPDF_Doc_AddPagesTo ( rootPages);
	            if (!curPages)
	                return null;
	            curPageNum = 0;
	        }
		 }

	    var page:HPDF_Page	=	new HPDF_Page( xref ) ;
	   
	    curPages.HPDF_Pages_AddKids ( page );
	      
	    pageList.HPDF_List_Add ( page ) ;

    	curPage	=	page; 
    

	    if ( compressionMode & HPDF_Consts.HPDF_COMP_TEXT)
			page.HPDF_Page_SetFilter ( HPDF_Stream.HPDF_STREAM_FILTER_FLATE_DECODE); 

	    curPageNum++;

    	return page;
  	  	
  	  }
  	  
  	  public	function	HPDF_HasDoc( ) :Boolean
  	  {
		
    	trace (" HPDF_HasDoc");
    	if ( sigBytes != HPDF_SIG_BYTES ) 
    		return false; 
    	
    	if ( !catalog ) {
    		throw new HPDF_Error ( "Invalid Document", HPDF_Error.HPDF_INVALID_DOCUMENT, 0);
    	}
    	return true;
     } 
     
     
     
     public	function	HPDF_Doc_AddPagesTo( parent : HPDF_Pages ) : HPDF_Pages
     {
     	
     	
		var	pages : HPDF_Pages ; 
	   	trace(" HPDF_AddPagesTo");

	    if (!HPDF_HasDoc ())
	        return null;

	    if (! parent.HPDF_Pages_Validate ())
	    {
	    	throw new HPDF_Error( "Invalid Pages", HPDF_Error.HPDF_INVALID_PAGES , 0 );
	    }

	    pages = new HPDF_Pages( parent, xref ); 
	    
		curPages	=	pages; 
		return pages; 
	} 
	
	
	
	public	function	HPDF_SaveToStream  () : void
	{
	    trace (" HPDF_SaveToStream");
	
	   if (!stream)
	        stream = new HPDF_MemStream(); 
	        
	
	    if (!stream) // .HPDF_Stream_Validate ( ))
	    {
	    	throw new HPDF_Error( "HPDF_SaveToStream" , HPDF_Error.HPDF_INVALID_STREAM, 0 );
	    }
		(stream as HPDF_MemStream ).HPDF_MemStream_FreeData( );
	    
	    InternalSaveToStream ( stream );
	}
	
	public	function	InternalSaveToStream  ( stream  :HPDF_Stream  ) : void
	{
	    WriteHeader( stream );
	    /* prepare trailer */
	    PrepareTrailer ();
	    /* prepare encription */
	    /*if (pdf->encrypt_on) {
	        HPDF_Encrypt e= HPDF_EncryptDict_GetAttr (pdf->encrypt_dict);
	
	        if ((ret = HPDF_Doc_PrepareEncryption (pdf)) != HPDF_OK)
	            return ret;
	
	        if ((ret = HPDF_Xref_WriteToStream (pdf->xref, stream, e)) != HPDF_OK)
	            return ret;
	    } else {*/
	    xref.HPDF_Xref_WriteToStream (stream, null);
	}
	
	
	/******** WRITE FUNCTIONS ************/
	private	function	WriteHeader( stream : HPDF_Stream ) : void
	{
		
		var idx : uint = pdfVersion ;

    	trace ((" WriteHeader\n"));
    	var h:HPDF_Utils; 
    	var str:String	=	HPDF_Utils.ParseString( HPDF_VERSION_STR[idx] )
    	stream.HPDF_Stream_WriteStr ( str );

 	}
 	
 	private	function	PrepareTrailer  ( ) : void
 	{
		
    	trace (" PrepareTrailer");
		trailer.HPDF_Dict_Add("Root", catalog );
	    trailer.HPDF_Dict_Add("Info", info );
	 }
	 public	function	HPDF_GetVersion( ) :String
	 {
	 	return HPDF_VERSION_TEXT;	
	 }
	 
	 public	function HPDF_SetInfoAttr  ( type : int , value : String ) : void
	 {
        
   		var info:HPDF_Dict = GetInfo ( );

	    trace(" HPDF_SetInfoAttr");
	
	    info.HPDF_Info_SetInfoAttr ( type, value, curEncoder);
	 }
	 
	 public	function	GetInfo ( ) : HPDF_Dict
	 {
	 	if (!info ) 
	 	{
	 		info = new HPDF_Dict( ) ; 
	 		xref.HPDF_Xref_Add( info ) ;
	 	}
	 	return info ;
	 }
	 
	 
	  public	function	HPDF_GetFont ( fontName : String , encodingName : String ) : HPDF_Font
	  {
          var	fontdef : HPDF_FontDef ; 
          var	encoder : HPDF_Encoder ; 
          var	font	: HPDF_Font	; 
   		  
   		  trace (" HPDF_GetFont");

	
	     if (!fontName){
	    	throw new HPDF_Error ( "HPDF_GetFont",HPDF_Error.HPDF_INVALID_FONT_NAME, 0);
	    }
	        

	    /* if encoding-name is not specified, find default-encoding of fontdef
	     */
	    if (!encodingName)
	    {
	        fontdef = HPDF_GetFontDef ( fontName);
	
	        if (fontdef)
	        {
	            var attr:HPDF_Type1FontDefAttr = fontdef.attr as HPDF_Type1FontDefAttr;
	
	            if (fontdef.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1 && ( attr.encodingScheme == HPDF_Encoder.HPDF_ENCODING_FONT_SPECIFIC ) )
	                encoder = HPDF_GetEncoder ( HPDF_Encoder.HPDF_ENCODING_FONT_SPECIFIC);
	            else
	                encoder = HPDF_GetEncoder ( HPDF_Encoder.HPDF_ENCODING_STANDARD);
	        } else 
	        {
	            return null;
	        }
	
	        font = HPDF_Doc_FindFont ( fontName, encoder.name);
	    } else {
	        font = HPDF_Doc_FindFont ( fontName, encodingName);
	    }

	    if (font)
	        return font;

	    if (!fontdef)
	    {
	        fontdef = HPDF_GetFontDef (fontName);
	
	        if (!fontdef) {
	            return null;
	        }
	    }

	    if (!encoder)
	    {
	        encoder = HPDF_GetEncoder (encodingName);
	
	        if (!encoder)
	            return null;
	    }
	    

	    switch (fontdef.type) {
	        case HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1:
	            font = new HPDF_Type1Font ( fontdef, encoder, xref);
	
	            if (font)
	                fontMgr.HPDF_List_Add ( font);
	
	            break;
	        case HPDF_FontDefType.HPDF_FONTDEF_TYPE_TRUETYPE:
	        
	        
	            if (encoder.type == HPDF_EncoderType.HPDF_ENCODER_TYPE_DOUBLE_BYTE)
	                font = new HPDF_Type0Font (fontdef, encoder, xref );
	            else
	                font = new  HPDF_TTFont ( fontdef, encoder,xref);
	                
	
	            if (font)
	                fontMgr.HPDF_List_Add ( font);
	
	            break;
	        case HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID:
	            font = new HPDF_Type0Font ( fontdef, encoder, xref);
	
	            if (font)
	                fontMgr.HPDF_List_Add ( font);
	
	            break;
	        default:
	            throw new HPDF_Error ( "HPDF_GetFont",HPDF_Error.HPDF_UNSUPPORTED_FONT_TYPE, 0);
	    }

	    //if (!font)
	     //   HPDF_CheckError (&pdf->error);
	
	    if (font && (compressionMode & HPDF_Consts.HPDF_COMP_METADATA))
	        font.filter = HPDF_Stream.HPDF_STREAM_FILTER_FLATE_DECODE;
	
	    return font;
	} 
	
	public	function	HPDF_GetFontDef ( fontName : String ) : HPDF_FontDef
	{
		
		
	    var	def : HPDF_FontDef ; 
	    trace (" HPDF_GetFontDef");
	
	   
	    def = HPDF_Doc_FindFontDef ( fontName);
	
	    if (!def) 
	    {
	        def = HPDF_FontDef.HPDF_Base14FontDef_New( fontName );
	
	        if (!def)
	            return null;
	
	        fontdefList.HPDF_List_Add (def) ;
	    }
	
	    return def;
	}
	
	public	function	  HPDF_GetEncoder( encodingName : String ) : HPDF_Encoder
	{
	    
	    var	encoder : HPDF_Encoder;
	    
	    trace (" HPDF_GetEncoder");
	
	    
	    encoder = HPDF_Doc_FindEncoder ( encodingName);
	
	    if (!encoder)
	    {
	        encoder = new HPDF_BasicEncoder ( encodingName );
	        encoderList.HPDF_List_Add ( encoder );
	    }
	
	    return encoder;
	}
	
	
	public	function	HPDF_Doc_FindEncoder  ( encodingName : String ) : HPDF_Encoder
	{
	    
	
	    trace (" HPDF_Doc_FindEncoder");
	
	    for (var i : int = 0; i < encoderList.count; i++)
	    {
	        var encoder: HPDF_Encoder = encoderList.HPDF_List_ItemAt ( i ) as HPDF_Encoder;
	
	        if (encodingName == encoder.name ) 
			{
	            /* if encoder is uninitialize, call init_fn() */
	            if ( encoder.type == HPDF_EncoderType.HPDF_ENCODER_TYPE_UNINITIALIZED)
	            {
	            	encoder.InitFn() ; 
	            }
	
	            return encoder;
	        }
	    }
	    return null ; 
	}
	
	public	function	HPDF_Doc_FindFontDef  ( fontName : String ) : HPDF_FontDef
	{
	    
	
	    trace (" HPDF_Doc_FindFontDef");
	
	    for (var i : int = 0; i < fontdefList.count; i++)
	    {
	        var  def: HPDF_FontDef = fontdefList.HPDF_List_ItemAt (i ) as HPDF_FontDef;
	
	        if (fontName == def.baseFont )
	        {
	            if (def.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_UNINITIALIZED)
	            {
	                def.initFn(); 
	            }
	
	            return def;
	        }
	    }HPDF_FontDef
	
	    return null;
	}
	
	public function	HPDF_Doc_FindFont  ( fontName : String, encodingName : String ) : HPDF_Font
	{

	    
	    trace (" HPDF_Doc_FindFont");
	
	    for (var i : int = 0; i < fontMgr.count; i++) {
	      
	
	        var font : HPDF_Font = fontMgr.HPDF_List_ItemAt ( i ) as HPDF_Font;
	        var attr: HPDF_FontAttr	=	font.attr as HPDF_FontAttr ;
	        
	        if ( ( attr.fontdef.baseFont ==  fontName ) && (attr.encoder.name ==  encodingName ))
	            return font;
	    }
	
	    return null;
	} 
	
	
	public	function HPDF_LoadTTFontFromStream( fontData: ByteArray, embedding:Boolean ):String
	{
		trace("HPDF_LoadTTFontFromStream");
		
		var	def			: HPDF_FontDef	 = HPDF_FontDef_TT.HPDF2_TTFontDef_Load ( fontData, embedding);
		var	ZString 	: String = "Z";
		var oldTag 		: String;
		
	    if (def)
	    {
	        
	        var	tmpdef : HPDF_FontDef	=	HPDF_Doc_FindFontDef( def.baseFont ); 
	        if (tmpdef)
	        {
	            def.HPDF_FontDef_Free( ) ; 
	            throw new HPDF_Error("HPDF_LoadTTFontFromStream", HPDF_Error.HPDF_FONT_EXISTS, 0);
	        }
	
	        fontdefList.HPDF_List_Add ( def );
	    }
	    else
	       return null;

	    if (embedding)
	    {
	    	if ( ttfontTag	==	"" || !ttfontTag)
	    		ttfontTag	=	new String("HPDFAA");
	        else
	        {
	            for (var i : int = 5; i >= 0; i--)
	            {
	                // ttfontTag.[i] += 1;
	                oldTag 	= new String ( ttfontTag ); 
	                var oldChar : uint  = ttfontTag.charCodeAt(i);
	                ttfontTag = ttfontTag.substr(0,i) ;
	                ttfontTag += String.fromCharCode( oldChar + 1 );
	                ttfontTag += oldTag.substr(i+1, oldTag.length - i ); 
	                /*if (pdf->ttfont_tag[i] > 'Z')
	                    pdf->ttfont_tag[i] = 'A';
	                else
	                    break;
	                    */
	                if ( ttfontTag.charCodeAt(i) > ZString.charCodeAt(0) )
	                {
	                	oldTag 	= new String ( ttfontTag ); 
	                	ttfontTag = ttfontTag.substr(0,i) ;
	                	ttfontTag += "A";
	                	ttfontTag += oldTag.substr(i+1, oldTag.length - i ); 
	                }
	                else
	                	break ; 
	            }
	        }
	
	        def.HPDF_TTFontDef_SetTagName (ttfontTag);
	    }
    	return def.baseFont; 
	}
	
	
	
	public	function	HPDF_LoadType1FontFromStream ( afmData : ByteArray, pfmData : ByteArray) : String
	{
		trace (" HPDF_LoadType1FontFromStream");
		
		 var def : HPDF_FontDef	=  HPDF_FontDef_Type1.HPDF_Type1FontDef_Load ( afmData, pfmData ) ; 
		 if ( def ) 
		 {
		 	var tmpdef : HPDF_FontDef = HPDF_Doc_FindFontDef( def.baseFont ) ;
		 	 
		 	if ( tmpdef ) {
		 		def.HPDF_FontDef_Free() ; 
		 		throw new HPDF_Error("HPDF_LoadType1FontFromStream", HPDF_Error.HPDF_FONT_EXISTS, 0);
		 		return null;
		 	}
		 	
		 	fontdefList.HPDF_List_Add( def );
		 	
		 }
		 return def.baseFont ; 
		
	}
	
		public	function	HPDF_CreateOutline ( parent : HPDF_Outline, title : String, encoder : HPDF_Encoder ) : HPDF_Outline
		{
			var outline : HPDF_Outline ; 
			
			if ( !this.HPDF_HasDoc() ) 
				return null 
			
			if ( !parent ) 
			{
				if ( this.outlines ) {
					parent = this.outlines; 
				}
				else
				{
					this.outlines = new HPDF_Outline( true,null,null,null, xref) 
					catalog.HPDF_Dict_Add( "Outlines", this.outlines ); 
					parent = this.outlines;
				}
			}
			if ( ! parent.HPDF_Outline_Validate( ) ) {
				throw new HPDF_Error("HPDF_CreateOutline",HPDF_Error.HPDF_INVALID_OUTLINE, 0); 
			}
			
			outline = new  HPDF_Outline (false, parent, title, encoder, xref ) ;
    		return outline;
		}
	 
		public	function	HPDF_SetPageMode( mode : uint ) : void
		{
			
			trace (" HPDF_GetPageMode");

		    if (!HPDF_HasDoc ())
		    	throw new HPDF_Error("HPDF_SetPageMode - invalid document");
		    
		    if (mode < 0 || mode >= HPDF_PageMode.HPDF_PAGE_MODE_EOF)
		        throw new HPDF_Error("HPDF_SetPageMode", HPDF_Error.HPDF_PAGE_MODE_OUT_OF_RANGE, mode );
		
		    catalog.HPDF_Catalog_SetPageMode ( mode );
		} // end HPDF_SetPageMode
		    
		public	function HPDF_SetCompressionMode  ( mode : uint ) :void 
		{
			if (mode != (mode & HPDF_Consts.HPDF_COMP_MASK)) {
				throw new HPDF_Error("HPDF_SetCompressionMode", HPDF_Error.HPDF_INVALID_COMPRESSION_MODE);
			}
			
			compressionMode = mode;
			
		}
		


	 

 
}
	 
	
    
    
} 
	
	 

