package demos
{
	
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.gstate.HPDF_ExtGState;
	import com.fxpdf.gstate.HPDF_GState;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.enum.HPDF_BlendMode;
	
	public class Ext_gstate_demo
	{
		
		public static function draw_circles(page : HPDF_Page , description : String, x : Number, y : Number): void {
			
			page.HPDF_Page_SetLineWidth(1);
			page.HPDF_Page_SetRGBStroke ( 0.0, 0.0, 0.0);
			page.HPDF_Page_SetRGBFill (1.0, 0.0, 0.0);
			page.HPDF_Page_Circle ( x + 40, y + 40, 40);
			page.HPDF_Page_ClosePathFillStroke ();
			page.HPDF_Page_SetRGBFill ( 0.0, 1.0, 0.0);
			page.HPDF_Page_Circle (x + 100, y + 40, 40);
			page.HPDF_Page_ClosePathFillStroke ();
			page.HPDF_Page_SetRGBFill ( 0.0, 0.0, 1.0);
			page.HPDF_Page_Circle ( x + 70, y + 74.64, 40);
			page.HPDF_Page_ClosePathFillStroke ();
			
			page.HPDF_Page_SetRGBFill ( 0.0, 0.0, 0.0);
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_TextOut ( x + 0.0, y + 130.0, description);
			page.HPDF_Page_EndText (); 
		}
		
		public	static	function run() : HPDF_Doc
		{
			var pdfDoc 			: HPDF_Doc ; 
			var page   			: HPDF_Page ; 
			var defFont 		: HPDF_Font ; 
			var PAGE_HEIGHT		: Number = 900;
			var PAGE_WIDTH		: Number = 600;
			var gstate			 :HPDF_ExtGState;
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage();
			
			defFont = pdfDoc.HPDF_GetFont ( "Helvetica-Bold", null);
			page.HPDF_Page_SetFontAndSize ( defFont, 10);			
			
			page.HPDF_Page_SetHeight (PAGE_HEIGHT);
			page.HPDF_Page_SetWidth (PAGE_WIDTH); 
			
			/* normal */
			page.HPDF_Page_GSave ();
			draw_circles (page, "normal", 40.0, PAGE_HEIGHT - 170);
			page.HPDF_Page_GRestore (); 
			
//			/* transparency (0.8) */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetAlphaFill ( 0.8);
			gstate.HPDF_ExtGState_SetAlphaStroke ( 0.8);
			page.HPDF_Page_SetExtGState (  gstate );
			draw_circles (page, "alpha fill = 0.8", 230.0, PAGE_HEIGHT - 170);
			page.HPDF_Page_GRestore (); 		
			
			/* transparency (0.4) */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetAlphaFill ( 0.4);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "alpha fill = 0.4", 420.0, PAGE_HEIGHT - 170);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_MULTIPLY */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_MULTIPLY);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_MULTIPLY", 40.0, PAGE_HEIGHT - 340);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_SCREEN */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_SCREEN);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_SCREEN", 230.0, PAGE_HEIGHT - 340);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_OVERLAY */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_OVERLAY);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_OVERLAY", 420.0, PAGE_HEIGHT - 340);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_DARKEN */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_DARKEN);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_DARKEN", 40.0, PAGE_HEIGHT - 510);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_LIGHTEN */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_LIGHTEN);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_LIGHTEN", 230.0, PAGE_HEIGHT - 510);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_COLOR_DODGE */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_COLOR_DODGE);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_COLOR_DODGE", 420.0, PAGE_HEIGHT - 510);
			page.HPDF_Page_GRestore ();
			
			
			/* blend-mode=HPDF_BM_COLOR_BUM */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_COLOR_BUM);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_COLOR_BUM", 40.0, PAGE_HEIGHT - 680);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_HARD_LIGHT */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_HARD_LIGHT);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_HARD_LIGHT", 230.0, PAGE_HEIGHT - 680);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_SOFT_LIGHT */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_SOFT_LIGHT);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_SOFT_LIGHT", 420.0, PAGE_HEIGHT - 680);
			page.HPDF_Page_GRestore ();
			
			/* blend-mode=HPDF_BM_DIFFERENCE */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_DIFFERENCE);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_DIFFERENCE", 40.0, PAGE_HEIGHT - 850);
			page.HPDF_Page_GRestore ();
			
			
			/* blend-mode=HPDF_BM_EXCLUSHON */
			page.HPDF_Page_GSave ();
			gstate = pdfDoc.HPDF_CreateExtGState();
			gstate.HPDF_ExtGState_SetBlendMode ( HPDF_BlendMode.HPDF_BM_EXCLUSHON);
			page.HPDF_Page_SetExtGState ( gstate);
			draw_circles (page, "HPDF_BM_EXCLUSHON", 230.0, PAGE_HEIGHT - 850);
			page.HPDF_Page_GRestore ();
			
			return pdfDoc;
			
		}		
		
		
		
		
		
	}
}