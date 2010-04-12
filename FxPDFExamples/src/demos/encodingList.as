package demos
{
	import mx.core.ByteArrayAsset;
	
	import com.fxpdf.dict.HPDF_Outline;
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.encoder.HPDF_BasicEncoder;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_PageMode;
	
	public class encodingList
	{
		private	static const PAGE_WIDTH : int	= 420;
		private	static const PAGE_HEIGHT : int	= 400;
		private	static const CELL_WIDTH : int	= 20;
		private	static const CELL_HEIGHT : int	= 20;
		private	static const CELL_HEADER : int	= 10;

		[Embed(source="assets/a010013l.afm", mimeType='application/octet-stream')]
        public static var a010013l_afm:Class;      
         
        [Embed(source="assets/a010013l.pfb", mimeType='application/octet-stream')]
        public static var a010013l_pfb : Class;
              
 		private	static const encodings : Array = [
            "StandardEncoding",
            "MacRomanEncoding",
            "WinAnsiEncoding",
            "ISO8859-2",
            "ISO8859-3",
            "ISO8859-4",
            "ISO8859-5",
            "ISO8859-9",
            "ISO8859-10",
            "ISO8859-13",
            "ISO8859-14",
            "ISO8859-15",
            "ISO8859-16",
            "CP1250",
            "CP1251",
            "CP1252",
            "CP1254",
            "CP1257",
            "KOI8-R",
            "Symbol-Set",
            "ZapfDingbats-Set",
            null ] ;
    

		public	static	function run( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var font   : HPDF_Font ; 
			var i : uint ; 
			var root : HPDF_Outline;
			var fontName : String ; 
			
			pdfDoc = new HPDF_Doc ( ) ; 
			
			/* set compression mode */
			/* currenty (2010-01-21) not implemented in libHaruAS3 !!!!!!! */
		    // TODO pdfDoc.HPDF_SetCompressionMode (  HPDF_COMP_ALL );
		
		    /* Set page mode to use outlines. */
		    pdfDoc.HPDF_SetPageMode(  HPDF_PageMode.HPDF_PAGE_MODE_USE_OUTLINE );
		    /* get default font */
		    font = pdfDoc.HPDF_GetFont (  "Helvetica", null);
		
		    /* load font object */
		    var afmByte : ByteArrayAsset	=	new a010013l_afm();
		    var pfbByte : ByteArrayAsset	=	new a010013l_pfb();
		   	fontName = pdfDoc.HPDF_LoadType1FontFromStream( afmByte, pfbByte ) ;
		     //       "type1\\a010013l.pfb");
		   // fontName = "Helvetica";
		    
		    /* create outline root. */
		    root = pdfDoc.HPDF_CreateOutline ( null, "Encoding list", null);
		    root.HPDF_Outline_SetOpened ( true );
		    
		
		    while ( encodings[i] ) {
		        
		        var page : HPDF_Page	=	pdfDoc.HPDF_AddPage();
		        var outline : HPDF_Outline ; 
		        var dst : HPDF_Destination;
		        var font2 : HPDF_Font ; 
		        
		        
		        page.HPDF_Page_SetWidth ( PAGE_WIDTH);
		        page.HPDF_Page_SetHeight ( PAGE_HEIGHT);
		
		        outline = pdfDoc.HPDF_CreateOutline ( root, encodings[i], null);
		        dst = page.HPDF_Page_CreateDestination ();
		        dst.HPDF_Destination_SetXYZ( 0, page.HPDF_Page_GetHeight(), 1);
		        /* HPDF_Destination_SetFitB(dst); */
		        outline.HPDF_Outline_SetDestination( dst);
		
		        page.HPDF_Page_SetFontAndSize ( font, 15);
		        drawGraph ( page );
		
		        page.HPDF_Page_BeginText ();
		        page.HPDF_Page_SetFontAndSize ( font, 20);
		        page.HPDF_Page_MoveTextPos ( 40, PAGE_HEIGHT - 50);
		        page.HPDF_Page_ShowText ( encodings[i]);
		        page.HPDF_Page_ShowText ( " Encoding" );
		        page.HPDF_Page_EndText ( );
		
		        if ( encodings[i] == "Symbol-Set" )
		            font2 = pdfDoc.HPDF_GetFont ( "Symbol", null);
		        else if ( encodings[i] == "ZapfDingbats-Set" )
		            font2 = pdfDoc.HPDF_GetFont ( "ZapfDingbats", null);
		        else
		            font2 = pdfDoc.HPDF_GetFont ( fontName, encodings[i]);
		
		        page.HPDF_Page_SetFontAndSize ( font2, 14);
		        drawFonts (page , encodings[i]);
		        i++;
		    }
			return pdfDoc; 
			
		}
		
		
		private	static	function	drawGraph ( page : HPDF_Page ) : void
		{
			var buf : String = new String( ) ; 
			var i : uint ; 
    		/* Draw 16 X 15 cells */

		    /* Draw vertical lines. */
		    page.HPDF_Page_SetLineWidth ( 0.5 );

		    for (i = 0; i <= 17; i++)
		    {
		        var x : int = i * CELL_WIDTH + 40;
		
		        page.HPDF_Page_MoveTo ( x, PAGE_HEIGHT - 60);
		        page.HPDF_Page_LineTo ( x, 40);
		        page.HPDF_Page_Stroke ( );

		        if (i > 0 && i <= 16)
		        {
		            page.HPDF_Page_BeginText ();
		            page.HPDF_Page_MoveTextPos ( x + 5, PAGE_HEIGHT - 75);
		            buf = (i-1).toString( 16 ) ; 
		            page.HPDF_Page_ShowText ( buf);
		            page.HPDF_Page_EndText ();
		        }
		    }

		    /* Draw horizontal lines. */
		    for (i = 0; i <= 15; i++)
		    {
		       var y : int = i * CELL_HEIGHT + 40;
		
		       page.HPDF_Page_MoveTo ( 40, y);
		       page.HPDF_Page_LineTo ( PAGE_WIDTH - 40, y);
		       page.HPDF_Page_Stroke ( );
		
		        if (i < 14)
		        {
		            page.HPDF_Page_BeginText ();
		            page.HPDF_Page_MoveTextPos ( 45, y + 5);
		            buf = (15 - i).toString( 16 ) ; 
		            page.HPDF_Page_ShowText ( buf);
		            page.HPDF_Page_EndText ();
		        }
		    }
    	} // end drawGraph
    	
    	
    	private	static	function	drawFonts( page : HPDF_Page, encoding : String ) : void
    	{
    		var i : int ; 
    		var j : int ; 
    		
    		page.HPDF_Page_BeginText() ; 
    		var be : HPDF_BasicEncoder	=	new HPDF_BasicEncoder( encoding );
		    /* Draw all character from 0x20 to 0xFF to the canvas. */
		    for (i = 1; i < 17; i++) { 
		        for (j = 1; j < 17; j++) {
		        	var buf : String = new String; 
		            var y : int = PAGE_HEIGHT - 55 - ((i - 1) * CELL_HEIGHT);
		            var x : int = j * CELL_WIDTH + 50; 
		            
		            // create character
		            var buf0 : int  =   (i - 1) * 16 + (j - 1);
		            buf = String.fromCharCode(  buf0 );
		            
		           
		            
		            if ( buf0 >= 32)
		            {
		                var d : Number ; 
		                /* AS3 change !!! 
		           	 	 In AS3 String - each character is already in unicode 
		           		 so we need to change the single-byte code to the unicode
		                 because later it is treated as unicode sign
		                */
		                buf0 = be.HPDF_Encoder_ToUnicode(  buf0 );
		                buf = String.fromCharCode(  buf0 );
		                
		
		                d  = x - page.HPDF_Page_TextWidth ( buf ) / 2;
		                page.HPDF_Page_TextOut ( d, y, buf);
		            }
		        }
		    }
		    page.HPDF_Page_EndText ( ); 
    	}


	}
}