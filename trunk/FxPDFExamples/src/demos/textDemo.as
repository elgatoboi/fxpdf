package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_RGBColor;
	import com.fxpdf.types.enum.HPDF_TextRenderingMode;
	
	public class textDemo
	{
		public function textDemo()
		{
		}
		
		
		
		private	static function	showStripePattern  ( page : HPDF_Page, x : Number, y :Number ): void
		{
         	var iy : uint = 0;
         	
		    while (iy < 50) {
		        page.HPDF_Page_SetRGBStroke ( 0.0, 0.0, 0.5);
		        page.HPDF_Page_SetLineWidth ( 1);
		        page.HPDF_Page_MoveTo ( x, y + iy);
		        page.HPDF_Page_LineTo ( x + page.HPDF_Page_TextWidth ( "ABCabc123"), y + iy);
		        page.HPDF_Page_Stroke ();
		        iy += 3;
		    }
		    page.HPDF_Page_SetLineWidth ( 2.5);
		}
		
		private static function	showDescription  (page : HPDF_Page, x : Number, y :Number, text  :String ) : void
		{                   
		    var fsize : Number = page.HPDF_Page_GetCurrentFontSize ();
		    var font : HPDF_Font = page.HPDF_Page_GetCurrentFont ();
		    var c  : HPDF_RGBColor = page.HPDF_Page_GetRGBFill ();
		
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_SetRGBFill ( 0, 0, 0);
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL);
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( x, y - 12, text);
		    page.HPDF_Page_EndText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, fsize);
		    page.HPDF_Page_SetRGBFill ( c.r, c.g, c.b);
		    
		} 
		
		
		public	static	function	run( ) : HPDF_Doc
		{
			const pageTitle : String = "Text Demo";
			const sampText : String = "abcdefgABCDEFG123!#$%&+-@?";
    		const sampText2 : String = "The quick brown fox jumps over the lazy dog.";
    		
    		var tw : Number ; 
    		var fsize : Number ; 
    		var i : Number ; 
    		var len : Number ; 
    		
    		var angle1 : Number ; 
    		var angle2 : Number ; 
    		var rad1 : Number ; 
    		var rad2 : Number ; 
    		
    		var ypos : Number ; 

 			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			
   		    pdfDoc = new HPDF_Doc( ) ; 
   		   
   		    /* Add a new page object. */ 
   		    page = pdfDoc.HPDF_AddPage() ;
   		   
		    /* set compression mode */
		    // NOT SUPPORTED YET IN LibHaruAS3 page.HPDF_SetCompressionMode (pdf, page.HPDF_COMP_ALL);

		    /* create default-font */
		    var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Helvetica", null);

		    /* draw grid to the page */
		    gridSheet.printGrid  (pdfDoc, page);

		        /* print the title of the page (with positioning center). */
		    page.HPDF_Page_SetFontAndSize ( font, 24);
		    tw = page.HPDF_Page_TextWidth ( pageTitle);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( (page.HPDF_Page_GetWidth() - tw) / 2,
		                page.HPDF_Page_GetHeight () - 50, pageTitle);
		    page.HPDF_Page_EndText ();
		
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_MoveTextPos ( 60, page.HPDF_Page_GetHeight() - 60);

		    /*
		     * font size
		     */
		    fsize = 8;
		    while (fsize < 60) {
		    	var buf : String ; 
		        /* set style and size of font. */
		        page.HPDF_Page_SetFontAndSize( font, fsize);
		
		        /* set the position of the text. */
		        page.HPDF_Page_MoveTextPos ( 0, -5 - fsize);
		
		        /* measure the number of characters which included in the page. */
		        buf = new String( sampText ) ;
		        len = page.HPDF_Page_MeasureText ( sampText, page.HPDF_Page_GetWidth() - 120, false, null);
		
		        page.HPDF_Page_ShowText ( buf );
		
		        /* print the description. */
		        page.HPDF_Page_MoveTextPos ( 0, -10);
		        page.HPDF_Page_SetFontAndSize( font, 8);
		        buf += fsize.toString(); 
		        page.HPDF_Page_ShowText ( buf);
		        fsize *= 1.5;
		    }

		    /*
		     * font color
		     */
		     
		    var r : Number;
		    var g : Number;
		    var b : Number;
		     
		     
		    page.HPDF_Page_SetFontAndSize( font, 8);
		    page.HPDF_Page_MoveTextPos ( 0, -30);
		    page.HPDF_Page_ShowText ( "Font color");
		
		    page.HPDF_Page_SetFontAndSize ( font, 18);
		    page.HPDF_Page_MoveTextPos ( 0, -20);
		    len = sampText.length;
		    for (i = 0; i < len; i++) {
		        r  = i / len ;
		        g = 1 - ( i / len ); 
		        page.HPDF_Page_SetRGBFill ( r, g, 0.0);
		        page.HPDF_Page_ShowText ( sampText.charAt(i) );
		    }
		    page.HPDF_Page_MoveTextPos ( 0, -25);

		    for (i = 0; i < len; i++) {
		        
		        r = i / len ;
		        b = 1 - ( i / len ); 
		        
		        page.HPDF_Page_SetRGBFill ( r, 0, b);
		        page.HPDF_Page_ShowText ( sampText.charAt(i));
		    }
		    page.HPDF_Page_MoveTextPos ( 0, -25);

		    for (i = 0; i < len; i++) {
		        
		        b = i / len ;
		        g = 1 - ( i / len ); 
		       
		        page.HPDF_Page_SetRGBFill ( 0, g, b);
		        page.HPDF_Page_ShowText ( sampText.charAt(i));
		    }

   			 page.HPDF_Page_EndText ();

  			  ypos = 450;

		    /*
		     * Font rendering mode
		     */
		    page.HPDF_Page_SetFontAndSize( font, 32);
		    page.HPDF_Page_SetRGBFill ( 0.5, 0.5, 0.0);
		    page.HPDF_Page_SetLineWidth ( 1.5);
		
		     /* PDF_FILL */
		    showDescription (page, 60, ypos,	                "RenderingMode=PDF_FILL");
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos, "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		    /* PDF_STROKE */
		    showDescription (page, 60, ypos - 50, "RenderingMode=PDF_STROKE");
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_STROKE);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos - 50, "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		    /* PDF_FILL_THEN_STROKE */
		    showDescription (page, 60, ypos - 100,"RenderingMode=PDF_FILL_THEN_STROKE");
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL_THEN_STROKE);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos - 100, "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		    /* PDF_FILL_CLIPPING */
		    showDescription (page, 60, ypos - 150,"RenderingMode=PDF_FILL_CLIPPING");
		    page.HPDF_Page_GSave ();
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL_CLIPPING);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos - 150, "ABCabc123");
		    page.HPDF_Page_EndText ();
		    showStripePattern (page, 60, ypos - 150);
		    page.HPDF_Page_GRestore ();
		
		    /* PDF_STROKE_CLIPPING */
		    showDescription (page, 60, ypos - 200, "RenderingMode=PDF_STROKE_CLIPPING");
		    page.HPDF_Page_GSave ();
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_STROKE_CLIPPING);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos - 200, "ABCabc123");
		    page.HPDF_Page_EndText ();
		    showStripePattern (page, 60, ypos - 200);
		    page.HPDF_Page_GRestore ();
		
		    /* PDF_FILL_STROKE_CLIPPING */
		    showDescription (page, 60, ypos - 250,  "RenderingMode=PDF_FILL_STROKE_CLIPPING");
		    page.HPDF_Page_GSave ();
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL_STROKE_CLIPPING);
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, ypos - 250, "ABCabc123");
		    page.HPDF_Page_EndText ();
		    showStripePattern (page, 60, ypos - 250);
		    page.HPDF_Page_GRestore ();
		
		    /* Reset text attributes */
		    page.HPDF_Page_SetTextRenderingMode ( HPDF_TextRenderingMode.HPDF_FILL);
		    page.HPDF_Page_SetRGBFill ( 0, 0, 0);
		    page.HPDF_Page_SetFontAndSize( font, 30);
		
		
		    /*
		     * Rotating text
		     */
		    angle1 = 30;                   /* A rotation of 30 degrees. */
		    rad1 = angle1 / 180 * 3.141592; /* Calcurate the radian value. */
		
		    showDescription (page, 320, ypos - 60, "Rotating text");
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_SetTextMatrix ( Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1), Math.cos(rad1),
		                330, ypos - 60);
		    page.HPDF_Page_ShowText ( "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		
		    /*
		     * Skewing text.
		     */
		    showDescription (page, 320, ypos - 120, "Skewing text");
		    page.HPDF_Page_BeginText ();
		
		    angle1 = 10;
		    angle2 = 20;
		    rad1 = angle1 / 180 * 3.141592;
		    rad2 = angle2 / 180 * 3.141592;
		
		    page.HPDF_Page_SetTextMatrix ( 1, Math.tan(rad1), Math.tan(rad2), 1, 320, ypos - 120);
		    page.HPDF_Page_ShowText ( "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		    /*
		     * scaling text (X direction)
		     */
		    showDescription (page, 320, ypos - 175, "Scaling text (X direction)");
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_SetTextMatrix ( 1.5, 0, 0, 1, 320, ypos - 175);
		    page.HPDF_Page_ShowText ( "ABCabc12");
		    page.HPDF_Page_EndText ();
		
		    /*
		     * scaling text (Y direction)
		     */
		    showDescription ( page,320, ypos - 250, "Scaling text (Y direction)");
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_SetTextMatrix ( 1, 0, 0, 2, 320, ypos - 250);
		    page.HPDF_Page_ShowText ( "ABCabc123");
		    page.HPDF_Page_EndText ();
		
		
		    /*
		     * char spacing, word spacing
		     */
		
		    showDescription ( page,60, 140, "char-spacing 0");
		    showDescription (page, 60, 100, "char-spacing 1.5");
		    showDescription ( page,60, 60, "char-spacing 1.5, word-spacing 2.5");
		
		    page.HPDF_Page_SetFontAndSize ( font, 20);
		    page.HPDF_Page_SetRGBFill ( 0.1, 0.3, 0.1);
		
		    /* char-spacing 0 */
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, 140, sampText2);
		    page.HPDF_Page_EndText ();
		
		    /* char-spacing 1.5 */
		    page.HPDF_Page_SetCharSpace ( 1.5);
		
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, 100, sampText2);
		    page.HPDF_Page_EndText ();
		
		    /* char-spacing 1.5, word-spacing 3.5 */
		    page.HPDF_Page_SetWordSpace ( 2.5);
		
		    page.HPDF_Page_BeginText ();
		    page.HPDF_Page_TextOut ( 60, 60, sampText2);
		    page.HPDF_Page_EndText ();
		
		   return pdfDoc; 
					
		}

   

	}
}