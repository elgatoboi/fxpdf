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
package com.fxpdf.page
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.gstate.HPDF_ExtGState;
	import com.fxpdf.gstate.HPDF_GState;
	import com.fxpdf.image.HPDF_Image;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_PageAttr;
	import com.fxpdf.objects.HPDF_Pages;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.HPDF_RGBColor;
	import com.fxpdf.types.enum.HPDF_ColorSpace;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	
	
	/**
	 *  @private
	 *  The HPDF_Page class is a main class represeting current page 
	 *  It is an equivalend to page handler in C version.
	 * 
	 *  HPDF_Page provides all text, draw, colors etc functions
	 *  
	 */
	public class HPDF_Page extends HPDF_Dict
	{
		
		public	static	const	INIT_POS : HPDF_Point	=	new HPDF_Point(0, 0);
		
		private	var	textFunctions : HPDF_Page_TextFunctions ; 
		private	var	sizeFunctions : HPDF_Page_SizeFunctions ; 
		private	var drawFunctions : HPDF_Page_DrawFunctions ;
		private var gstateFunctions : HPDF_Page_GStateFunctions ;
		private var pathFunctions : HPDF_Page_PathFunctions;  
		private var colorFunctions : HPDF_PageColorFunctions ; 
		private var combinedFunctions : HPDF_Page_CombinedFunctions ; 
		private var imageFunctions		:HPDF_Page_ImageFunctions;
		
		private	static const HPDF_INHERITABLE_ENTRIES:Array = [
                        "Resources",
                        "MediaBox",
                        "CropBox",
                        "Rotate",
                        null];
                        
		public function HPDF_Page( xref : HPDF_Xref )
		{
			super() ;
			textFunctions		=	new HPDF_Page_TextFunctions( this );
			sizeFunctions		=	new HPDF_Page_SizeFunctions( this ); 
			drawFunctions		=	new HPDF_Page_DrawFunctions( this ); 
			gstateFunctions		=	new HPDF_Page_GStateFunctions( this );
			pathFunctions		=	new HPDF_Page_PathFunctions( this );
			colorFunctions		=	new HPDF_PageColorFunctions( this );
			combinedFunctions	=	new HPDF_Page_CombinedFunctions( this );
			imageFunctions		=	new HPDF_Page_ImageFunctions( this );
			
    		trace(" HPDF_Page_New");

		    header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE;
		    
    		// C attr = HPDF_GetMem (page->mmgr, sizeof(HPDF_PageAttr_Rec));
		    var pageAttr : HPDF_PageAttr	=	new HPDF_PageAttr ;
		    attr	=	pageAttr;  
		    

		    pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
		    pageAttr.curPos 	= new HPDF_Point(0, 0);
		    pageAttr.textPos	= new HPDF_Point(0, 0);
		
		    
		    xref.HPDF_Xref_Add( this ); 
		    
		    var	g : HPDF_GState	= new HPDF_GState( null ); 
		    pageAttr.gstate		= new HPDF_GState( null ) ;
		    pageAttr.contents	= new HPDF_DictStream( xref ) ;

		    if (!pageAttr.gstate || !pageAttr.contents)
		        return ;

		    pageAttr.stream = pageAttr.contents.stream;
		    pageAttr.xref = xref;

		    /* add requiered elements */
		    this.HPDF_Dict_AddName ("Type", "Page");
		    
		    this.HPDF_Dict_Add ( "MediaBox", HPDF_Array.HPDF_Box_Array_New ( new HPDF_Box (0, 0, Math.floor(HPDF_Consts.HPDF_DEF_PAGE_WIDTH), Math.floor(HPDF_Consts.HPDF_DEF_PAGE_HEIGHT) )));
		    this.HPDF_Dict_Add ( "Contents", pageAttr.contents);
		
		    AddResource ();
		  
		}
		
		public	function	get pageAttr ( ) : HPDF_PageAttr
		{
			return attr as HPDF_PageAttr;
		}
		
		private	function	Page_OnFree  ():void
		{
			if ( attr ) 
			{
				if ( attr.gstate )
				{
					attr.gstate.HPDF_GState_Free( ) ;
				}
			}
			attr = null ; 
		}
		
		private	function	Page_BeforeWrite( ) :void
		{
			if ( attr.gmode == HPDF_Consts.HPDF_GMODE_PATH_OBJECT ) 
			{
				trace("HPDF_Page_BeforeWrite warning path object is not end");
				HPDF_Page_EndPath( );
				return;
			}
			if ( attr.gmode == HPDF_Consts.HPDF_GMODE_TEXT_OBJECT ) 
			{
				 trace((" HPDF_Page_BeforeWrite warning text block is not end"));
				 HPDF_Page_EndText( ) ;
				 return;
			}
			if ( attr.gstate ) 
			{
				while ( attr.gstate.prev ) 
				{
					HPDF_Page_GRestore( );
				}
			}
		}
		
		public	function	HPDF_Page_CheckState( mode: uint ) : void
		{
		    if ( header.objClass != (HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE | HPDF_Obj_Header.HPDF_OCLASS_DICT))
		        return;
		
		    if (!(   (attr as HPDF_PageAttr).gmode & mode))
		    {
		        //return HPDF_RaiseError (page->error, HPDF_PAGE_INVALID_GMODE, 0);
		        throw new HPDF_Error("HPDF_Page_CheckState", HPDF_Error.HPDF_PAGE_INVALID_GMODE, 0);
		    }
		
		     
		}
		
		
		
		
		
		
		
  
		
 
  	
		
		public	function	AddResource ( ) : void
		{
			
    		trace(" HPDF_Page_AddResource");
	
		    var resource:HPDF_Dict = new HPDF_Dict( ); 
		    
		    /* althoth ProcSet-entry is obsolete, add it to resouce for
		     * compatibility
		     */
			this.HPDF_Dict_Add("Resources", resource);
		    
		    var procset:HPDF_Array = new HPDF_Array( );
		    
		    resource.HPDF_Dict_Add ("ProcSet", procset);
		    
		    procset.HPDF_Array_Add ( new HPDF_Name( "PDF") );
		    procset.HPDF_Array_Add ( new HPDF_Name("Text") );
		    procset.HPDF_Array_Add ( new HPDF_Name( "ImageB") );
		    procset.HPDF_Array_Add ( new HPDF_Name( "ImageC") );
		    procset.HPDF_Array_Add ( new HPDF_Name( "ImageI") );
		}
		
		
		public	function	HPDF_Page_GetLocalFontName( font : HPDF_Font ) : String
		{
		   var pageAttr : HPDF_PageAttr = attr as HPDF_PageAttr ; 
    	   var key : String;

		    //trace( " HPDF_Page_GetLocalFontName" );
		
		    /* whether check font-resource exists.  when it does not exists,
		     * create font-resource
		     * 2006.07.21 Fixed a problem which may cause a memory leak.
		     */
		    if (!pageAttr.fonts)
		    {
		        
		        var resources:HPDF_Dict = HPDF_Page_GetInheritableItem ( "Resources", HPDF_Obj_Header.HPDF_OCLASS_DICT ) as HPDF_Dict ;
		        if (!resources)
		            return null;
		
		        var fonts:HPDF_Dict = new HPDF_Dict() ; 
		        resources.HPDF_Dict_Add ( "Font", fonts );
		        pageAttr.fonts = fonts;
		    }

		    /* search font-object from font-resource */
		    key = pageAttr.fonts.HPDF_Dict_GetKeyByObj ( font );
		    if (!key)
		    {
		        /* if the font is not resisterd in font-resource, register font to
		         * font-resource.
		         */
		         
		        /*char fontName[HPDF_LIMIT_MAX_NAME_LEN + 1];
		        char *ptr;
		        char *end_ptr = fontName + HPDF_LIMIT_MAX_NAME_LEN;
				*/
				
		        // ptr = (char *)HPDF_StrCpy (fontName, "F", end_ptr);
		        var fontName : String	=	 "F";
		        //HPDF_IToA (ptr, attr->fonts->list->count + 1, end_ptr);
		        fontName	+=	(pageAttr.fonts.list.length + 1).toString();
		
				pageAttr.fonts.HPDF_Dict_Add( fontName, font ) ; 
		        
		        key = pageAttr.fonts.HPDF_Dict_GetKeyByObj ( font );
		    }

   			return key;
 		 }
 		 
 		 
 		 public	function	HPDF_Page_GetInheritableItem( key : String, objClass : uint ) : Object
 		 {
 		  
		    var	chk : Boolean	=	false;
		    var i : int = 0; 
		    var	obj : Object ; 
		
		    //trace(" HPDF_Page_GetInheritableItem");
		
		    /* check whether the specified key is valid */
		    while ( HPDF_INHERITABLE_ENTRIES[i] )
		    {
		        if ( key == HPDF_INHERITABLE_ENTRIES[i] )
		        {
		            chk = true;
		            break;
		        }
		        i++;
		    }

		    /* the key is not inheritable */
		    if (chk != true)
		    {
		        // HPDF_SetError (page->error, HPDF_INVALID_PARAMETER, 0);
		        throw new HPDF_Error( "HPDF_Page_GetInheritableItem", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
		    }
		
		    obj = HPDF_Dict_GetItem ( key, objClass);
		
		    /* if resources of the object is NULL, search resources of parent
		     * pages recursivly
		     */
		    if (!obj)
		    {
		        // C HPDF_Pages pages = HPDF_Dict_GetItem (page, "Parent", HPDF_OCLASS_DICT);
		        var	pages : HPDF_Pages	=	HPDF_Dict_GetItem ( "Parent", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Pages;
		        while (pages)
		        {
		            obj = HPDF_Dict_GetItem ( key, objClass);
		            if (obj)
		                break;
		
		            pages = pages.HPDF_Dict_GetItem ("Parent", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Pages;
		        }
		    }
		
		    return obj;
		} 
    
    
		
		/*************** TEXT FUNCTIONS ********************/
		
		
		    
		/*--- Text state ---------------------------------------------------------*/
		
		/* Tc */
		
		
		/*--- Text positioning ---------------------------------------------------*/
		
		
		
		
		/** GENERAL GRAPHICS STATE **/
		
		public	function	HPDF_Page_SetLineWidth( lineWidth : Number ) : void
		{
			gstateFunctions.HPDF_Page_SetLineWidth( lineWidth );
		}
		
		
		public function HPDF_Page_SetLineCap( lineCap : int ):void
		{
			gstateFunctions.HPDF_Page_SetLineCap( lineCap );
		}
		
		public function HPDF_Page_SetLineJoin( lineJoin : int ):void
		{
			gstateFunctions.HPDF_Page_SetLineJoin( lineJoin );
		}
		
		
		public function HPDF_Page_SetMiterLimit( miterLimit:Number ):void
		{
			gstateFunctions.HPDF_Page_SetMiterLimit( miterLimit );
		}
		
		public function HPDF_Page_SetDash( dashPtn:Vector.<uint>, numParam:uint, phase:uint ):void
		{
			gstateFunctions.HPDF_Page_SetDash( dashPtn, numParam, phase );
		}
		
		public function HPDF_Page_SetFlat( flatness:Number ):void
		{
			gstateFunctions.HPDF_Page_SetFlat( flatness );
		}
		
		public function HPDF_Page_SetExtGState( extGState:HPDF_ExtGState ):void
		{
			gstateFunctions.HPDF_Page_SetExtGState( extGState );
		}
		
		public function HPDF_Page_GSave():void
		{
			gstateFunctions.HPDF_Page_GSave();
		}
		
		public	function	HPDF_Page_GRestore() :void
		{
			gstateFunctions.HPDF_Page_GRestore();
		}
		
		public	function	HPDF_Page_Concat( a : Number, b : Number, c : Number, d : Number, x : Number, y : Number ) : void
		{
			gstateFunctions.HPDF_Page_Concat( a, b, c, d, x, y );
		}
		
		
		/**--- Path construction operator ------------------------------------------*/
		
		public	function HPDF_Page_MoveTo( x: Number, y : Number) : void
		{
			pathFunctions.HPDF_Page_MoveTo( x, y);
		}
		
		public	function HPDF_Page_LineTo( x: Number, y : Number ) : void
		{
			pathFunctions.HPDF_Page_LineTo( x, y);
		}
		
		public function HPDF_Page_CurveTo( x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			pathFunctions.HPDF_Page_CurveTo( x1, y1, x2, y2, x3, y3);
		}
		
		public function HPDF_Page_CurveTo2( x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			pathFunctions.HPDF_Page_CurveTo2( x2, y2, x3, y3);
		}
		
		public function HPDF_Page_CurveTo3( x1:Number, y1:Number, x3:Number, y3:Number):void
		{
			pathFunctions.HPDF_Page_CurveTo3( x1, y1, x3, y3);
		}
		
		
		public function HPDF_Page_ClosePath():void
		{
			pathFunctions.HPDF_Page_ClosePath();
		}
		
		public	function HPDF_Page_Rectangle( x : Number, y: Number, width : Number, height: Number ) : void
		{
			pathFunctions.HPDF_Page_Rectangle( x, y, width, height);
		}
		
		public function HPDF_Page_ClosePathStroke():void
		{
			pathFunctions.HPDF_Page_ClosePathStroke();
		}
		
		public function HPDF_Page_Eofill():void
		{
			pathFunctions.HPDF_Page_Eofill();
		}
		
		public function HPDF_Page_FillStroke():void
		{
			pathFunctions.HPDF_Page_FillStroke();
		}

		public function HPDF_Page_EofillStroke():void
		{
			pathFunctions.HPDF_Page_EofillStroke();
		}
		
		public function HPDF_Page_ClosePathFillStroke():void
		{
			pathFunctions.HPDF_Page_ClosePathFillStroke();
		}
		
		public function HPDF_Page_ClosePathEofillStroke():void
		{
			pathFunctions.HPDF_Page_ClosePathEofillStroke();
		}
		
		public function HPDF_Page_EndPath() : void
		{
			pathFunctions.HPDF_Page_EndPath();
		}
		
		public function HPDF_Page_Clip():void
		{
			pathFunctions.HPDF_Page_Clip();
		}
		
		public function HPDF_Page_Eoclip():void
		{
			pathFunctions.HPDF_Page_Eoclip();
		}
		
			
		/**--- Text object operator -----------------------------------------------*/
		
		public	function	HPDF_Page_BeginText() : void
		{
			textFunctions.HPDF_Page_BeginText(); 
		}
		
		public	function	HPDF_Page_EndText( ) : void
		{
			textFunctions.HPDF_Page_EndText(); 
		}
		
		
		/*--- Text state ---------------------------------------------------------*/
		
		public	function	HPDF_Page_SetCharSpace  ( value : Number ) : void
		{
		   return textFunctions.HPDF_Page_SetCharSpace( value ) ; 
		}
		
		/* Tw */
		public	function	HPDF_Page_SetWordSpace  ( value : Number ) : void
		{
		   return textFunctions.HPDF_Page_SetWordSpace( value ) ; 
		}
		
		/* Tz */
		public	function	HPDF_Page_SetHorizontalScalling  ( value : Number ) : void
		{
		    return textFunctions.HPDF_Page_SetHorizontalScalling( value ) ; 
		
		}
		
		/* TL */
		public	function	HPDF_Page_SetTextLeading  ( value : Number ) : void
		{
		    return textFunctions.HPDF_Page_SetTextLeading( value ) ; 
		}
		
		/* Tf */
		
		public	function	HPDF_Page_SetFontAndSize  ( font : HPDF_Font, size : Number ) : void
		{
		    return textFunctions.HPDF_Page_SetFontAndSize( font, size ) ; 
		}
		
		/* Tr */
		public	function	HPDF_Page_SetTextRenderingMode  ( mode : int ) : void
		{
		   return textFunctions.HPDF_Page_SetTextRenderingMode( mode ) ; 
		
		}
		
		/* Ts */
		public	function	HPDF_Page_SetTextRaise  ( value : Number ) : void
		{
		   return textFunctions.HPDF_Page_SetTextRaise( value ) ; 
		}
		
		public	function	HPDF_Page_SetTextRise  ( value : Number ) : void
		{
		   return textFunctions.HPDF_Page_SetTextRise( value ) ; 
		}
		
		/**--- Text positioning ---------------------------------------------------*/
		
		
		/* Td */
		
		public	function	HPDF_Page_MoveTextPos  ( x: Number, y : Number ) : void 
		{
		   return textFunctions.HPDF_Page_MoveTextPos( x, y ) ; 
		
		}
		
		/* TD */
		public	function	HPDF_Page_MoveTextPos2  ( x: Number, y : Number ) : void 
		{
		   return textFunctions.HPDF_Page_MoveTextPos2( x, y) ; 
		
		}
		
		/* Tm */
		public	function	HPDF_Page_SetTextMatrix  ( a : Number, b : Number, c : Number, d : Number, x : Number, y : Number ):void
		{
		    textFunctions.HPDF_Page_SetTextMatrix( a, b, c, d, x, y ) ; 
		}
		
		
		/* T* */
		public	function	HPDF_Page_MoveToNextLine  ( ) : void
		{
		    textFunctions.HPDF_Page_MoveToNextLine( ) ; 
		}
		
		/*--- Text showing -------------------------------------------------------*/
		
		/* Tj */
		public	function	HPDF_Page_ShowText  ( text : String ) : void
		{
		    return textFunctions.HPDF_Page_ShowText( text ) ; 
		
		}
		/* TJ */
		/* ' */
		public	function	HPDF_Page_ShowTextNextLine  ( text : String ) : void
		{
		  return textFunctions.HPDF_Page_ShowTextNextLine( text ) ; 
		
		}
		
		/* " */
		public	function	HPDF_Page_ShowTextNextLineEx  ( wordSpace : Number, charSpace : Number, text : String ) : void
		{ 
			return textFunctions.HPDF_Page_ShowTextNextLineEx( wordSpace,charSpace, text ) ; 
		}
		
		/**--- Color showing ------------------------------------------------------*/
		
		
		
		public	function	HPDF_Page_SetGrayFill( gray : Number ) : void
		{
			colorFunctions.HPDF_Page_SetGrayFill( gray );
		}
		
		public	function	HPDF_Page_SetGrayStroke( gray : Number ) : void
		{
			colorFunctions.HPDF_Page_SetGrayStroke( gray );
		}
		
		public	function	HPDF_Page_SetRGBStroke( r : Number, g: Number, b : Number) : void
		{
			colorFunctions.HPDF_Page_SetRGBStroke( r, g, b );
		}
		
		public	function	HPDF_Page_SetCMYKFill( c : Number, m: Number, y:Number, k:Number) : void
		{
			colorFunctions.HPDF_Page_SetCMYKFill( c, m, y, k );
		}
		
		public	function	HPDF_Page_SetCMYKStroke( c : Number, m: Number, y:Number, k:Number) : void
		{
			colorFunctions.HPDF_Page_SetCMYKStroke(  c, m, y, k );
		}
	
		/*--- Shading patterns ---------------------------------------------------*/
		
		/* sh --not implemented yet */
		
		/*--- In-line images -----------------------------------------------------*/
		
		/* BI --not implemented yet */
		/* ID --not implemented yet */
		/* EI --not implemented yet */
		
		/*--- XObjects -----------------------------------------------------------*/
 	// TODO NOT IMPLEMENTED
 	
	 	
	/*--- Marked content -----------------------------------------------------*/
	
	/* BMC --not implemented yet */
	/* BDC --not implemented yet */
	/* EMC --not implemented yet */
	/* MP --not implemented yet */
	/* DP --not implemented yet */
	
	/*--- Compatibility ------------------------------------------------------*/
	
	/* BX --not implemented yet */
	/* EX --not implemented yet */
	
	
	/*--- combined function --------------------------------------------------*/
	
		public	function	HPDF_Page_Ellipse  ( x : Number, y : Number, xray : Number, yray:Number ) : void
		{
			combinedFunctions.HPDF_Page_Ellipse( x, y, xray, yray ); 
		}
		
		public	function	HPDF_Page_Circle  ( x : Number, y : Number, ray : Number ) : void
		{
			combinedFunctions.HPDF_Page_Circle(x, y, ray ); 
		}
		
		
		public	function	HPDF_Page_Arc( x : Number, y : Number, ray : Number, ang1 : Number, ang2 : Number ) : void
		{
			combinedFunctions.HPDF_Page_Arc( x, y, ray, ang1, ang2); 
		}
		
		public	function	InternalArc  ( x : Number, y : Number, ray : Number, ang1 : Number, ang2 : Number, contFlg : Boolean ) : void
		{
			combinedFunctions.InternalArc(x,y, ray, ang1, ang2, contFlg);
		}
		
		public function HPDF_Page_DrawImage( image:HPDF_Image, x:Number, y:Number, width:Number, height:Number ) : void
		{
			imageFunctions.HPDF_Page_DrawImage( image, x, y, width, height );
		}
		
		
		
		public function HPDF_Page_ExecuteXObject( obj :HPDF_Dict ):void
		{
			imageFunctions.HPDF_Page_ExecuteXObject( obj );
		}
		
		
		
		
		public	function	HPDF_Page_TextWidth  ( text : String ) : Number 
		{
			return textFunctions.HPDF_Page_TextWidth( text ) ; 
		}
		public	function	HPDF_Page_TextRect( left : Number, top : Number, right : Number, bottom : Number, text : String, align : Number, len : uint ) : uint
		{
			return textFunctions.HPDF_Page_TextRect( left , top , right , bottom , text , align , len  ) ;
		}
		public	function	HPDF_Page_MeasureText  ( text : String, width : Number , wordwrap : Boolean, realWidth : C_NumberPointer ) : Number
		{
			return textFunctions.HPDF_Page_MeasureText  ( text , width  , wordwrap , realWidth  ) ;
		}
		public	function	InternalShowTextNextLine ( text : String, len : uint ): void
		{
			textFunctions.InternalShowTextNextLine ( text, len );
		}
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public	function	HPDF_Page_GetCurrentTextPos( ) : HPDF_Point
		{
			return textFunctions.HPDF_Page_GetCurrentTextPos(); 
		}
		public	function	HPDF_Page_TextOut  ( xpos : Number, ypos : Number, text : String ) : void
		{
			textFunctions.HPDF_Page_TextOut( xpos, ypos, text); 
		}
		
		
		/** 
		 * Fill functions
		 * */
		public	function	HPDF_Page_SetRGBFill  ( r : Number, g : Number, b : Number ) : void
		{
                       
		    HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT | HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION);
			var buf : String = "";		                  
		    
		    //trace (" HPDF_Page_SetRGBFill");
		
		    
    		if (r < 0 || r > 1 || g < 0 || g > 1 || b < 0 || b > 1)
    		{
    			throw new HPDF_Error("HPDF_Page_SetRGBFill", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
    		}
        	var attr : HPDF_PageAttr	=	attr as HPDF_PageAttr;
		
		    buf = r.toString()+ " "; 
		    buf += g.toString()+ " ";
		    buf += b.toString()+ HPDF_Utils.ParseString(" rg\\012");
		    
		    attr.stream.HPDF_Stream_WriteStr( buf );
		
		    attr.gstate.rgbFill.r = r;
		    attr.gstate.rgbFill.g = g;
		    attr.gstate.rgbFill.b = b;
		    attr.gstate.csFill = HPDF_ColorSpace.HPDF_CS_DEVICE_RGB;
		}
		
		public	function	HPDF_Page_SetSize( size : uint , direction : uint ) : void
		{
			sizeFunctions.HPDF_Page_SetSize  ( size , direction ) ;
		}
		
		public	function	HPDF_Page_GetWidth( ) : Number
		{
		    return HPDF_Page_GetMediaBox().right;
		}
		
		public	function	HPDF_Page_GetHeight( ) : Number
		{
			return HPDF_Page_GetMediaBox ().top ;
		}
		
		
		
		public	function	HPDF_Page_GetLineWidth( ) : Number
		{
			trace(" HPDF_Page_GetLineWidth");
			if ( HPDF_Page_Validate ())
			{
		       return pageAttr.gstate.lineWidth ; 
		    } else
		        return HPDF_Consts.HPDF_DEF_LINEWIDTH; 
		}
		
		
		
		
		
		public function	HPDF_Page_Stroke( ) : void
		{
			HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH);
		    var pbuf : String = ""
		    
		    trace (" HPDF_Page_Stroke");
		    
		     pageAttr.stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString( "S\\012" )   );
		
		     pageAttr.gmode	= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
             pageAttr.curPos = INIT_POS;
		}	
		
		public	function	HPDF_Page_SetHeight( value : Number ) : void
		{
			trace(" HPDF_Page_SetWidth");
		    if (value < 3 || value > 14400)
		    	throw new HPDF_Error( "HPDF_Page_SetHeight", HPDF_Error.HPDF_PAGE_INVALID_SIZE, 0);
		
		    HPDF_Page_SetBoxValue ( "MediaBox", 3, value );
		}
		public	function	HPDF_Page_SetWidth( value : Number ) : void
		{
			//trace(" HPDF_Page_SetWidth");
		    if (value < 3 || value > 14400)
		    	throw new HPDF_Error( "HPDF_Page_SetHeight", HPDF_Error.HPDF_PAGE_INVALID_SIZE, 0);
		
		    HPDF_Page_SetBoxValue ( "MediaBox", 2, value);
		}
		
		public	function	HPDF_Page_SetBoxValue ( name : String, index : uint , value : Number ): void
		{
			return sizeFunctions.HPDF_Page_SetBoxValue( name, index, value ) ; 
		}
		public	function HPDF_Page_GetMediaBox( ) : HPDF_Box
		{
			return sizeFunctions.HPDF_Page_GetMediaBox(); 
		}
		
		
		public	function	HPDF_Page_Validate( ) : Boolean
		{
			if ( !attr) 
				return false;
				
			if ( header.objClass != (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE))
				return false;
				
			return true;
			
		} // end HPDF_Page_Validate
		
		
		override public	function	beforeWriteFn( ) : void
		{
			var attr : HPDF_PageAttr	=	this.attr as HPDF_PageAttr;
			
		    //trace(" HPDF_Page_BeforeWrite");
		
		    if (attr.gmode == HPDF_Consts.HPDF_GMODE_PATH_OBJECT)
		    {
		        trace(" HPDF_Page_BeforeWrite warning path object is not end");
		
		        HPDF_Page_EndPath ();
		    }
		
		    if (attr.gmode == HPDF_Consts.HPDF_GMODE_TEXT_OBJECT) {
		        trace(" HPDF_Page_BeforeWrite warning text block is not end");
		
		        HPDF_Page_EndText () ;
		    }
		
		    if (attr.gstate)
		        while (attr.gstate.prev) {
		            HPDF_Page_GRestore ();
		       }
		     
		}
		
		
		 
		 
		public	function	HPDF_Page_CreateDestination( ) :HPDF_Destination
		{
			
			var attr : HPDF_PageAttr	=	this.attr	as HPDF_PageAttr;
			var dst : HPDF_Destination	;	
			
			trace ("HPDF_Page_CreateDestination");
			
			if ( !HPDF_Page_Validate() ) 
				throw new HPDF_Error("HPDF_Page_CreateDestination - page validate error") ; 
			
			dst = new HPDF_Destination( this, attr.xref );
			
			return dst ;
		}
		
		
		
		
		
		public	function	HPDF_Page_Fill ( ) : void
		{
			HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT |  HPDF_Consts.HPDF_GMODE_CLIPPING_PATH);
			
    		trace (" HPDF_Page_Fill");

		    pageAttr.stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString( "f\\012") ) ;
		
		    pageAttr.gmode	= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
   			pageAttr.curPos	= INIT_POS;
		}
		
		
		
		
		
		
		
        public function HPDF_Page_GetCurrentPos ( ) : HPDF_Point
		{
			var pos : HPDF_Point = new HPDF_Point( 0,0);
		    trace(" HPDF_Page_GetCurrentPos");

		    if ( HPDF_Page_Validate ()) {
		        if (pageAttr.gmode & HPDF_Consts.HPDF_GMODE_PATH_OBJECT)
		            pos = pageAttr.curPos;
		    }

    		return pos;
		} // end HPDF_Page_GetCurrentPos
		
		public	function	HPDF_Page_GetCurrentFontSize( ) : Number
		{
			//trace(" HPDF_Page_GetCurrentFontSize");
			if ( HPDF_Page_Validate() ) {
				return pageAttr.gstate.font ? pageAttr.gstate.fontSize : 0 ; 
			}
			else
				return 0;
    	}
    	
    	public	function	HPDF_Page_GetCurrentFont( ) : HPDF_Font
    	{
    		//trace(" HPDF_Page_GetCurrentFont");
    		if ( HPDF_Page_Validate() ) { 
    			return pageAttr.gstate.font ; 
    		}
    		return null ; 
    	}
    	
    	public	function	HPDF_Page_GetRGBFill( ) : HPDF_RGBColor
    	{
    		var DEF_RGB_COLOR : HPDF_RGBColor=	new HPDF_RGBColor( 0,0,0);
    		//trace("HPDF_Page_GetRGBFill");
    		if ( HPDF_Page_Validate() ) { 
    			if ( pageAttr.gstate.csFill == HPDF_ColorSpace.HPDF_CS_DEVICE_RGB ) 
    				return pageAttr.gstate.rgbFill ; 
    		}
    		return DEF_RGB_COLOR; 
    	}
    	
    	
    	
    	public function HPDF_Page_GetExtGStateName( state  : HPDF_ExtGState ) :String
    	{
    		var key : String; 
    		trace (" HPDF_Page_GetExtGStateName");
    		
    		if (!pageAttr.extGStates) {
    			var resources:HPDF_Dict;
    			var extGStates:HPDF_Dict;
		
		        resources = HPDF_Page_GetInheritableItem ("Resources",HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Dict;
		        
		        extGStates = new HPDF_Dict ();
		        
		        resources.HPDF_Dict_Add ("ExtGState", extGStates);
		        pageAttr.extGStates = extGStates;
		    }
		    
		    /* search ext_gstate-object from ext_gstate-resource */
		    key = pageAttr.extGStates.HPDF_Dict_GetKeyByObj ( state );
		    if (!key) {
		        /* if the ext-gstate is not resisterd in ext-gstate resource, register
		         *  to ext-gstate resource.
		         */
		        var extGStateName : String ; 
		        extGStateName = "E";
		        extGStateName += ( pageAttr.extGStates.list.length + 1).toString(); 
		        
		        pageAttr.extGStates.HPDF_Dict_Add ( extGStateName, state) ;
		
		        key = pageAttr.extGStates.HPDF_Dict_GetKeyByObj (state );
		    }
		
		    return key;
    		
    	}


		override public	function	afterWriteFn( stream : HPDF_Stream ) : void
		{
			null ;
		}
		override public	function	writeFn( stream : HPDF_Stream) : void
		{
			null ; 
		}
		
		public function HPDF_Page_SetFilter  ( filter : uint ):void 
		{
			trace(" HPDF_Page_SetFilter");
			pageAttr.contents.filter = filter; 
		} 
		
		public function HPDF_Page_DrawEps( stream : ByteArray, x:Number=0, y:Number=0, w:Number=0, h:Number=0, useBoundingBox:Boolean=true ) :void
		{
			stream.position = 0;
			
			//var source:String = stream.readU stream.readUTFBytes( stream.bytesAvailable );
			var source:String = new String( stream ) ; 
			
			var regs:Array = source.match(/%%Creator:([^\r\n]+)/);
			
			if (regs.length > 1)
			{
				var version:String = regs[1];
				
				if ( version.indexOf("Adobe Illustrator") != -1 )
				{
					var buffVersion:Array = version.split(" ");
					var numVersion:int = buffVersion.pop();
					
					/*if ( numVersion > 8 )
						throw new Error ("Wrong version, only 1.x, 3.x or 8.x AI files are supported for now.");
					*/
				} else
					null; 
				//throw new Error("This EPS file was not created with Adobe® Illustrator®");
			}
			
			var start:int = source.indexOf('%!PS-Adobe');
			
			if (start != -1) 
				source = source.substr(start);
			
			regs = source.match(/%%BoundingBox:([^\r\n]+)/);
			
			var x1:Number;
			var y1:Number;
			var x2:Number;
			var y2:Number;
			var buffer:Array;
			
			if (regs.length > 1)
			{
				buffer = regs[1].substr(1).split(" ");
				
				x1 = buffer[0];
				y1 = buffer[1];
				x2 = buffer[2];
				y2 = buffer[3];
				
				start = source.indexOf('%%EndSetup');
				
				if ( start == -1 ) 
					start = source.indexOf('%%EndProlog');
				if ( start == -1 ) 
					start = source.indexOf('%%BoundingBox');
				
				source = source.substr(start);
				
				var end:int = source.indexOf('%%PageTrailer');
				
				if ( end == -1) 
					end = source.indexOf('showpage');
				if ( end ) 
					source = source.substr(0, end);
				
				pageAttr.stream.HPDF_Stream_WriteStr ('q' + HPDF_Utils.NEW_LINE );
				
				var k:Number = 1; // przelicznik
				var dx:Number;
				var dy:Number;
				
				if (useBoundingBox)
				{
					dx = x*k-x1;
					dy = y*k-y1;
				}else
				{
					dx = x*k;
					dy = y*k;
				}
				
			//	pageAttr.stream.HPDF_Stream_WriteStr (sprintf('%.3F %.3F %.3F %.3F %.3F %.3F cm', 1,0,0,1,dx,dy+(currentPage.hPt - 2*y*k - (y2-y1))));
				
				pageAttr.stream.HPDF_Stream_WriteStr ( HPDF_Utils.HPDF_FToA(1)+ " "+
					HPDF_Utils.HPDF_FToA(0)+ " "+
					HPDF_Utils.HPDF_FToA(0)+ " "+
					HPDF_Utils.HPDF_FToA(1)+ " "+
					HPDF_Utils.HPDF_FToA(dx)+ " "+
					HPDF_Utils.HPDF_FToA(dy+(HPDF_Page_GetHeight() - 2*y*k - (y2-y1)))+ " cm"+ HPDF_Utils.NEW_LINE);
				
				var scaleX:Number;
				var scaleY:Number;
				
				if (w>0)
				{
					scaleX = w/((x2-x1)/k);
					if (h>0)
					{
						scaleY = h/((y2-y1)/k);
					}else
					{
						scaleY = scaleX;
						h = (y2-y1)/k * scaleY;
					}
				}else
				{
					if (h>0)
					{
						scaleY = h/((y2-y1)/k);
						scaleX = scaleY;
						w = (x2-x1)/k * scaleX;
					}else
					{
						w = (x2-x1)/k;
						h = (y2-y1)/k;
					}
				}
				
				if (!isNaN(scaleX))
					//pageAttr.stream.HPDF_Stream_WriteStr (sprintf('%.3F %.3F %.3F %.3F %.3F %.3F cm', scaleX, 0, 0, scaleY, x1*(1-scaleX), y2*(1-scaleY)));
					pageAttr.stream.HPDF_Stream_WriteStr ( HPDF_Utils.HPDF_FToA(scaleX)+ " "+
															HPDF_Utils.HPDF_FToA(0)+ " "+
															HPDF_Utils.HPDF_FToA(0)+ " "+
															HPDF_Utils.HPDF_FToA(scaleY)+ " "+
															HPDF_Utils.HPDF_FToA(x1*(1-scaleX))+ " "+
															HPDF_Utils.HPDF_FToA(y2*(1-scaleY))+ " cm"+ HPDF_Utils.NEW_LINE);
				
				var lines:Array = source.split(/\r\n|[\r\n]/);
				
				var u:Number = 0;
				var cnt:int = lines.length;
				var line:String;
				var length:int;
				var chunks:Array;
				var c:String;
				var m:String;
				var ty:String;
				var tk:String;
				var cmd:String;
				
				var r:String;
				var g:String;
				var b:String;
				
				for ( var i:int=0; i<cnt; i++)
				{
					line = lines[i];
					if (line == '' || line.charAt(0) == '%') 
						continue;
					length = line.length;
					chunks = line.split(' ');
					cmd = chunks.pop();
					
					if (cmd =='Xa' || cmd =='XA')
					{
						b = chunks.pop(); 
						g = chunks.pop();
						r = chunks.pop();
						pageAttr.stream.HPDF_Stream_WriteStr (r+" "+g+" "+b+ " " + (cmd == 'Xa' ? 'rg' : 'RG') + HPDF_Utils.NEW_LINE);
						continue;
					}
					
					switch (cmd)
					{
						case 'm':
						case 'l':
						case 'y':
						case 'c':
							
						case 'k':
						case 'K':
						case 'g':
						case 'G':
							
						case 's':
						case 'S':
							
						case 'J':
						case 'j':
						case 'w':
						case 'M':
						case 'd':
						case 'n':
						case 'v': // NO P
							pageAttr.stream.HPDF_Stream_WriteStr(line+ HPDF_Utils.NEW_LINE);
							break;
						
						case 'x':
							c = chunks[0];
							m = chunks[1];
							ty = chunks[2];
							tk = chunks[3];
							pageAttr.stream.HPDF_Stream_WriteStr (c+" "+m+" "+ty+" "+tk+" k"+ HPDF_Utils.NEW_LINE);
							break;
						
						case 'X':
							c = chunks[0];
							m = chunks[1];
							ty = chunks[2];
							tk = chunks[3];
							pageAttr.stream.HPDF_Stream_WriteStr (c+" "+m+" "+ty+" "+tk+" K"+ HPDF_Utils.NEW_LINE);
							break;
						
						case 'Y':
						case 'N':
						case 'V':
						case 'L':
						case 'C':
							pageAttr.stream.HPDF_Stream_WriteStr (line.toLowerCase()+ HPDF_Utils.NEW_LINE);
							break;
						
						case 'b':
						case 'B':
							pageAttr.stream.HPDF_Stream_WriteStr (cmd + '*'+ HPDF_Utils.NEW_LINE);
							break;
						
						case 'f':
						case 'F':
							if (u>0)
							{
								var isU:Boolean = false;
								var max:Number = i+5 < cnt ? i+5 : cnt;
								var j:int = i+1;
								for ( ; j<max; j++)
									isU = (isU || (lines[j]=='U' || lines[j]=='*U'));
								if (isU) pageAttr.stream.HPDF_Stream_WriteStr ("f*"+ HPDF_Utils.NEW_LINE);
							}else
								pageAttr.stream.HPDF_Stream_WriteStr ("f*"+ HPDF_Utils.NEW_LINE);
							break;
						
						case '*u':
							u++;
							break;
						
						case '*U':
							u--;
							break;
					}
				}
				
				pageAttr.stream.HPDF_Stream_WriteStr ('Q'+ HPDF_Utils.NEW_LINE);
				
			}
			else throw new Error("No bounding box found in the current EPS file");
			
			
		}
		
/*		public function sprintf(format:String, ... args):String
		{
			var result:String = "";
			
			var length:int = format.length;
			var next:*;
			var str:String;
			for (var i:int = 0; i < length; i++)
			{
				var c:String = format.charAt(i);
				
				if (c == "%")
				{
					var pastFieldWidth:Boolean = false;
					var pastFlags:Boolean = false;
					
					var flagAlternateForm:Boolean = false;
					var flagZeroPad:Boolean = false;
					var flagLeftJustify:Boolean = false;
					var flagSpace:Boolean = false;
					var flagSign:Boolean = false;
					
					var fieldWidth:String = "";
					var precision:String = "";
					
					c = format.charAt(++i);
					
					while (c != "d"
						&& c != "i"
						&& c != "o"
						&& c != "u"
						&& c != "x"
						&& c != "X"
						&& c != "f"
						&& c != "F"
						&& c != "c"
						&& c != "s"
						&& c != "%")
					{
						if (!pastFlags)
						{
							if (!flagAlternateForm && c == "#")
								flagAlternateForm = true;
							else if (!flagZeroPad && c == "0")
								flagZeroPad = true;
							else if (!flagLeftJustify && c == "-")
								flagLeftJustify = true;
							else if (!flagSpace && c == " ")
								flagSpace = true;
							else if (!flagSign && c == "+")
								flagSign = true;
							else
								pastFlags = true;
						}
						
						if (!pastFieldWidth && c == ".")
						{
							pastFlags = true;
							pastFieldWidth = true;
							
							c = format.charAt(++i);
							continue;
						}
						
						if (pastFlags)
						{
							if (!pastFieldWidth)
								fieldWidth += c;
							else
								precision += c;
						}
						
						c = format.charAt(++i);
					}
					
					switch (c)
					{
						case "d":
						case "i":
							next = args.shift();
							str = String(Math.abs(int(next)));
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (int(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "o":
							next = args.shift();
							str = uint(next).toString(8);
							
							if (flagAlternateForm && str != "0")
								str = "0" + str;
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "u":
							next = args.shift();
							str = uint(next).toString(10);
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "X":
							var capitalise:Boolean = true;
						case "x":
							next = args.shift();
							str = uint(next).toString(16);
							
							if (precision != "")
								str = leftPad(str, int(precision), "0");
							
							var prepend:Boolean = flagAlternateForm && uint(next) != 0;
							
							if (fieldWidth != "" && !flagLeftJustify
								&& flagZeroPad && precision == "")
								str = leftPad(str, prepend
									? int(fieldWidth) - 2 : int(fieldWidth), "0");
							
							if (prepend)
								str = "0x" + str;
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							if (capitalise)
								str = str.toUpperCase();
							
							result += str;
							break;
						
						case "f":
						case "F":
							next = args.shift();
							str = Math.abs(Number(next)).toFixed(
								precision != "" ?  Number(precision) : 6);
							
							if (Number(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;
							
							if (flagAlternateForm && str.indexOf(".") == -1)
								str += ".";
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = leftPad(str, int(fieldWidth), "0");
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "c":
							next = args.shift();
							str = String.fromCharCode(int(next));
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "s":
							next = args.shift();
							str = String(next);
							
							if (precision != "")
								str = str.substring(0, int(precision));
							
							if (fieldWidth != "")
							{
								if (flagLeftJustify)
									str = rightPad(str, int(fieldWidth));
								else
									str = leftPad(str, int(fieldWidth));
							}
							
							result += str;
							break;
						
						case "%":
							result += "%";
					}
				}
				else
				{
					result += c;
				}
			}
			
			return result;
		}


*/
		

	}
}