package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	
	/**
	 * <libHaruAS3> - Font Demo from LibHaru C original sources
	 * 
	 * Author: Piotr Chruscielewski <piotr.chruscielewski@mente.pl>
	 * Based on source code by Takeshi Kanno <takeshi_kanno@est.hi-ho.ne.jp> 
	 * 
	 * */
	  
	public class fontDemo
	{
		private	static const fontList : Array = [   "Courier",
												    "Courier-Bold",
												    "Courier-Oblique",
												    "Courier-BoldOblique",
												    "Helvetica",
												    "Helvetica-Bold",
												    "Helvetica-Oblique",
												    "Helvetica-BoldOblique",
												    "Times-Roman",
												    "Times-Bold",
												    "Times-Italic",
												    "Times-BoldItalic",
												    "Symbol",
												    "ZapfDingbats",
												    null ] ; 
				
		public	static function	run( ) : HPDF_Doc
		{
			var pageTitle : String = "Font Demo" ;
			var pdfDoc : HPDF_Doc ; 
			var fname  : String = "fontDemo.pdf";
			var page   : HPDF_Page ; 
			var defFont : HPDF_Font ; 
			var i : int ; 
			var height : Number ; 
			var width  : Number ; 
			var tw : Number ; 
    
   		   pdfDoc = new HPDF_Doc( ) ; 
   		   
   		   /* Add a new page object. */ 
   		   page = pdfDoc.HPDF_AddPage() ;
   		   
   		   height	= page.HPDF_Page_GetHeight () ;
   		   width	= page.HPDF_Page_GetWidth () ;
		   
		   /* Print the lines of the page. */   		   
   		   page.HPDF_Page_SetLineWidth( 1 ) ;
   		   page.HPDF_Page_Rectangle( 50, 50 , width - 100, height - 110 ) ;
   		   page.HPDF_Page_Stroke() ; 
    
		
		   /* Print the title of the page (with positioning center). */
		   defFont = pdfDoc.HPDF_GetFont ( "Helvetica", null);
		   page.HPDF_Page_SetFontAndSize ( defFont, 24);
		
		   tw = page.HPDF_Page_TextWidth ( pageTitle );
		   page.HPDF_Page_BeginText ( );
		   page.HPDF_Page_TextOut ( (width - tw) / 2, height - 50, pageTitle);
		   page.HPDF_Page_EndText ();
		
		   /* output subtitle. */
		   page.HPDF_Page_BeginText ();
		   page.HPDF_Page_SetFontAndSize ( defFont, 16);
		   page.HPDF_Page_TextOut ( 60, height - 80, "<Standerd Type1 fonts samples>" );
		   page.HPDF_Page_EndText ();
		
		   page.HPDF_Page_BeginText ();
		   page.HPDF_Page_MoveTextPos ( 60, height - 105);
		
		    i = 0;
		    
		    while ( fontList[i] )
		    {
		        var sampText : String = "abcdefgABCDEFG12345!#$%&+-@?" ;
		        var font : HPDF_Font	= pdfDoc.HPDF_GetFont( fontList[i], null );	
		        
		        /* print a label of text */
		        page.HPDF_Page_SetFontAndSize ( defFont, 9);
		        page.HPDF_Page_ShowText (  fontList[i] );
		        page.HPDF_Page_MoveTextPos (  0, -18);
		
		        /* print a sample text. */
		        page.HPDF_Page_SetFontAndSize ( font, 20);
		        page.HPDF_Page_ShowText (  sampText);
		        page.HPDF_Page_MoveTextPos ( 0, -20);
		
		        i++;
		    }
		
		    page.HPDF_Page_EndText ();
			
			return pdfDoc;
		    
		}

	}
}