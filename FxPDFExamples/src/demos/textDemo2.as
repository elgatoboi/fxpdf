package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.enum.HPDF_PageDirection;
	import com.fxpdf.types.enum.HPDF_PageSizes;
	import com.fxpdf.types.enum.HPDF_TextAlignment;
	
	public class textDemo2
	{
		private var no : int = 0; 
		
		public function textDemo2()
		{
		}
		
		private	function PrintText( page : HPDF_Page ) : void
		{
		    var pos : HPDF_Point = page.HPDF_Page_GetCurrentTextPos();
			var buf : String = ".[" + no.toString() + "]";
			
		    buf += pos.x.toString() ; 
		    buf += " ";
		    buf += pos.y.toString() ; 
		    page.HPDF_Page_ShowText( buf );
		} 
				
		
		public	static	function	run( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			var SAMP_TXT : String = "The quick brown fox jumps over the lazy dog. ";
			var angle1 : Number; 
			var angle2 : Number; 
			var rad1 : Number; 
			var rad2 : Number; 
			var rect : HPDF_Box = new HPDF_Box();
			
   		    pdfDoc = new HPDF_Doc( ) ; 
   		   
   		    /* Add a new page object. */ 
   		    page = pdfDoc.HPDF_AddPage() ;
   		   
		    page.HPDF_Page_SetSize ( HPDF_PageSizes.HPDF_PAGE_SIZE_A5, HPDF_PageDirection.HPDF_PAGE_PORTRAIT);
		
		    gridSheet.printGrid  (pdfDoc, page);
		    
		    var pageHeight : Number = page.HPDF_Page_GetHeight ();
		
		    var font : HPDF_Font = pdfDoc.HPDF_GetFont ("Helvetica", null);
		    page.HPDF_Page_SetTextLeading ( 20);
		
		    /* text_rect method */
		
		    /* page.HPDF_TALIGN_LEFT */
		    rect.left = 25;
		    rect.top = 545;
		    rect.right = 200;
		    rect.bottom = rect.top - 40;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "page.HPDF_TALIGN_LEFT");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_LEFT, 0);
		    page.HPDF_Page_EndText ();
		
		    /* page.HPDF_TALIGN_RIGTH */
		    rect.left = 220;
		    rect.right = 395;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "page.HPDF_TALIGN_RIGTH");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_RIGHT, 0);
		
		    page.HPDF_Page_EndText ();
		
		    /* page.HPDF_TALIGN_CENTER */
		    rect.left = 25;
		    rect.top = 475;
		    rect.right = 200;
		    rect.bottom = rect.top - 40;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "page.HPDF_TALIGN_CENTER");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_CENTER, 0);
		
		    page.HPDF_Page_EndText ();
		
		    /* page.HPDF_TALIGN_JUSTIFY */
		    rect.left = 220;
		    rect.right = 395;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "page.HPDF_TALIGN_JUSTIFY");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_JUSTIFY, 0);
		
		    page.HPDF_Page_EndText ();
		
		
		
		    /* Skewed coordinate system */
		    page.HPDF_Page_GSave ();
		
		    angle1 = 5;
		    angle2 = 10;
		    rad1 = angle1 / 180 * 3.141592;
		    rad2 = angle2 / 180 * 3.141592;
		
		    page.HPDF_Page_Concat ( 1, Math.tan(rad1), Math.tan(rad2), 1, 25, 350);
		    rect.left = 0;
		    rect.top = 40;
		    rect.right = 175;
		    rect.bottom = 0;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "Skewed coordinate system");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_LEFT, 0);
		
		    page.HPDF_Page_EndText ();
		
		    page.HPDF_Page_GRestore ();
		
		
		    /* Rotated coordinate system */
		    page.HPDF_Page_GSave ();
		
		    angle1 = 5;
		    rad1 = angle1 / 180 * 3.141592;
		
		    page.HPDF_Page_Concat ( Math.cos(rad1), Math.sin(rad1), -Math.sin(rad1), Math.cos(rad1), 220, 350);
		    rect.left = 0;
		    rect.top = 40;
		    rect.right = 175;
		    rect.bottom = 0;
		
		    page.HPDF_Page_Rectangle ( rect.left, rect.bottom, rect.right - rect.left,
		                rect.top - rect.bottom);
		    page.HPDF_Page_Stroke ();
		
		    page.HPDF_Page_BeginText ();
		
		    page.HPDF_Page_SetFontAndSize ( font, 10);
		    page.HPDF_Page_TextOut ( rect.left, rect.top + 3, "Rotated coordinate system");
		
		    page.HPDF_Page_SetFontAndSize ( font, 13);
		    page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
		                SAMP_TXT, HPDF_TextAlignment.HPDF_TALIGN_LEFT, 0);
		
		    page.HPDF_Page_EndText ();
		
		    page.HPDF_Page_GRestore ();
		
		
		    /* text along a circle */
		    page.HPDF_Page_SetGrayStroke ( 0);
		    page.HPDF_Page_Circle ( 210, 190, 145);
		    page.HPDF_Page_Circle ( 210, 190, 113);
		    page.HPDF_Page_Stroke ();
		
		    angle1 = 360 / SAMP_TXT.length ; 
		    angle2 = 180;
		
		    page.HPDF_Page_BeginText ();
		    font = pdfDoc.HPDF_GetFont ( "Courier-Bold", null);
		    page.HPDF_Page_SetFontAndSize ( font, 30);
		
		    for (var i:int = 0; i < SAMP_TXT.length; i++) {
		        var buf : String ; 
		        var x : Number; 
		        var y : Number; 
		
		        rad1 = (angle2 - 90) / 180 * 3.141592;
		        rad2 = angle2 / 180 * 3.141592;
		
		        x = 210 + Math.cos(rad2) * 122;
		        y = 190 + Math.sin(rad2) * 122;
		
		        page.HPDF_Page_SetTextMatrix(  Math.cos(rad1),  Math.sin(rad1), - Math.sin(rad1),  Math.cos(rad1), x, y);
		        buf = SAMP_TXT.charAt( i );
		        page.HPDF_Page_ShowText ( buf);
		        angle2 -= angle1;
		    }
		
		    page.HPDF_Page_EndText ();
		
		    return pdfDoc; 
					
		}

   

	}
}