package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Point;
	
	public class arcDemo
	{
		public function arcDemo()
		{
			
		}
		
		public	static	function	run ( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var font   : HPDF_Font;
			var page   : HPDF_Page; 
			var i : uint ; 
			var fontName : String ; 
			var pos : HPDF_Point ; 
			
			pdfDoc = new HPDF_Doc ( ) ; 
			
			/* add a new page object. */ 
			page = pdfDoc.HPDF_AddPage() ;
			
			page.HPDF_Page_SetHeight ( 220);
		    page.HPDF_Page_SetWidth ( 200);
		
		    /* draw grid to the page */
		    gridSheet.printSheet( pdfDoc , page ); 
			
		    /* draw pie chart
		     *
		     *   A: 45% Red
		     *   B: 25% Blue
		     *   C: 15% green
		     *   D: other yellow
		     */
		
		    /* A */
		    page.HPDF_Page_SetRGBFill ( 1.0, 0, 0);
		    page.HPDF_Page_MoveTo ( 100, 100);
		    page.HPDF_Page_LineTo ( 100, 180);
		    page.HPDF_Page_Arc ( 100, 100, 80, 0, 360 * 0.45);
		    pos = page.HPDF_Page_GetCurrentPos ();
		    page.HPDF_Page_LineTo ( 100, 100);
		    page.HPDF_Page_Fill ();
		
		    /* B */
		    page.HPDF_Page_SetRGBFill ( 0, 0, 1.0);
		    page.HPDF_Page_MoveTo ( 100, 100);
		    page.HPDF_Page_LineTo ( pos.x, pos.y);
		    page.HPDF_Page_Arc ( 100, 100, 80, 360 * 0.45, 360 * 0.7);
		    pos = page.HPDF_Page_GetCurrentPos ();
		    page.HPDF_Page_LineTo ( 100, 100);
		    page.HPDF_Page_Fill ();
		
		    /* C */
		    page.HPDF_Page_SetRGBFill ( 0, 1.0, 0);
		    page.HPDF_Page_MoveTo ( 100, 100);
		    page.HPDF_Page_LineTo ( pos.x, pos.y);
		    page.HPDF_Page_Arc ( 100, 100, 80, 360 * 0.7, 360 * 0.85);
		    pos = page.HPDF_Page_GetCurrentPos ();
		    page.HPDF_Page_LineTo ( 100, 100);
		    page.HPDF_Page_Fill ();
		
		    /* D */
		    page.HPDF_Page_SetRGBFill ( 1.0, 1.0, 0);
		    page.HPDF_Page_MoveTo ( 100, 100);
		    page.HPDF_Page_LineTo ( pos.x, pos.y);
		    page.HPDF_Page_Arc ( 100, 100, 80, 360 * 0.85, 360);
		    pos = page.HPDF_Page_GetCurrentPos ();
		    page.HPDF_Page_LineTo ( 100, 100);
		    page.HPDF_Page_Fill ();
		    
		
		    /* draw center circle */
		    page.HPDF_Page_SetGrayStroke ( 0);
		    page.HPDF_Page_SetGrayFill ( 1);
		    page.HPDF_Page_Circle ( 100, 100, 30);
		    page.HPDF_Page_Fill ();
		
		    return pdfDoc ; 
			
		}

	}
}