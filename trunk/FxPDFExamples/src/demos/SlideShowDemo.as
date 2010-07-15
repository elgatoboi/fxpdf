package demos
{	
	import com.fxpdf.dict.HPDF_Annotation;
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_PageMode;
	import com.fxpdf.types.HPDF_Rect;
	import com.fxpdf.types.enum.HPDF_AnnotHighlightMode;
	import com.fxpdf.types.enum.HPDF_TransitionStyle;
	
	public class SlideShowDemo
	{
		
		private static function
		print_page  ( page : HPDF_Page , caption : String,font : HPDF_Font, style : uint, prev : HPDF_Page, next : HPDF_Page ) : void 
		{
			var r: Number = Math.random() ;
			var g: Number = Math.random();
			var b: Number = Math.random();
			
			var rect			: HPDF_Rect;
			var dst				: HPDF_Destination;
			var annot			: HPDF_Annotation;
			
			page.HPDF_Page_SetWidth ( 800);
			page.HPDF_Page_SetHeight ( 600);
			
			page.HPDF_Page_SetRGBFill ( r, g, b);
			
			page.HPDF_Page_Rectangle ( 0, 0, 800, 600);
			page.HPDF_Page_Fill ();
			
			page.HPDF_Page_SetRGBFill ( 1 - r, 1 - g, 1 - b);
			
			page.HPDF_Page_SetFontAndSize ( font, 30);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_SetTextMatrix ( 0.8, 0, 0, 1, 0, 0);   
			page.HPDF_Page_TextOut ( 50, 530, caption);
			
			page.HPDF_Page_SetTextMatrix ( 1, 0, 0, 1, 0, 0);   
			page.HPDF_Page_SetFontAndSize ( font, 20);
			page.HPDF_Page_TextOut ( 55, 300, 
				"Type \"Ctrl+L\" in order to return from full screen mode.");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetSlideShow ( style, 5.0, 1.0);
			
			page.HPDF_Page_SetFontAndSize ( font, 20);
			
			if (next) {
				page.HPDF_Page_BeginText ();
				page.HPDF_Page_TextOut ( 680, 50, "Next=>");
				page.HPDF_Page_EndText ();
				rect = new HPDF_Rect();
				rect.left = 680;
				rect.right = 750;
				rect.top = 70;
				rect.bottom = 50;
				dst = next.HPDF_Page_CreateDestination ();
				dst.HPDF_Destination_SetFit();
				annot = page.HPDF_Page_CreateLinkAnnot ( rect, dst);
				annot.HPDF_LinkAnnot_SetBorderStyle ( 0, 0, 0);
				annot.HPDF_LinkAnnot_SetHighlightMode ( HPDF_AnnotHighlightMode.HPDF_ANNOT_INVERT_BOX);
			} 
			
			if (prev) {
				page.HPDF_Page_BeginText ();
				page.HPDF_Page_TextOut ( 50, 50, "<=Prev");
				page.HPDF_Page_EndText ();
				rect = new HPDF_Rect();
				rect.left = 50;
				rect.right = 110;
				rect.top = 70;
				rect.bottom = 50;
				dst = prev.HPDF_Page_CreateDestination ();
				dst.HPDF_Destination_SetFit();
				annot = page.HPDF_Page_CreateLinkAnnot ( rect, dst);
				annot.HPDF_LinkAnnot_SetBorderStyle ( 0, 0, 0);
				annot.HPDF_LinkAnnot_SetHighlightMode (HPDF_AnnotHighlightMode.HPDF_ANNOT_INVERT_BOX);
			}
			
			
		}
		
		public	static	function	run( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : Vector.<HPDF_Page> = new Vector.<HPDF_Page>(16); 
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			
			var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Courier", null);
			
			/* Add 17 pages to the document. */
			page[0] = pdfDoc.HPDF_AddPage ();
			page[1] = pdfDoc.HPDF_AddPage ();
			page[2] = pdfDoc.HPDF_AddPage ();
			page[3] = pdfDoc.HPDF_AddPage ();
			page[4] = pdfDoc.HPDF_AddPage ();
			page[5] = pdfDoc.HPDF_AddPage ();
			page[6] = pdfDoc.HPDF_AddPage ();
			page[7] = pdfDoc.HPDF_AddPage ();
			page[8] = pdfDoc.HPDF_AddPage ();
			page[9] = pdfDoc.HPDF_AddPage ();
			page[10] = pdfDoc.HPDF_AddPage ();
			page[11] = pdfDoc.HPDF_AddPage ();
			page[12] = pdfDoc.HPDF_AddPage ();
			page[13] = pdfDoc.HPDF_AddPage ();
			page[14] = pdfDoc.HPDF_AddPage ();
			page[15] = pdfDoc.HPDF_AddPage ();
			page[16] = pdfDoc.HPDF_AddPage ();
			
			print_page(page[0], "HPDF_TS_WIPE_RIGHT", font, 
				HPDF_TransitionStyle.HPDF_TS_WIPE_RIGHT, null, page[1]);
			print_page(page[1], "HPDF_TS_WIPE_UP", font, 
				HPDF_TransitionStyle.HPDF_TS_WIPE_UP, page[0], page[2]);
			print_page(page[2], "HPDF_TS_WIPE_LEFT", font, 
				HPDF_TransitionStyle.HPDF_TS_WIPE_LEFT, page[1], page[3]);
			print_page(page[3], "HPDF_TS_WIPE_DOWN", font, 
				HPDF_TransitionStyle.HPDF_TS_WIPE_DOWN, page[2], page[4]);
			print_page(page[4], "HPDF_TS_BARN_DOORS_HORIZONTAL_OUT", font, 
				HPDF_TransitionStyle.HPDF_TS_BARN_DOORS_HORIZONTAL_OUT, page[3], page[5]);
			print_page(page[5], "HPDF_TS_BARN_DOORS_HORIZONTAL_IN", font, 
				HPDF_TransitionStyle.HPDF_TS_BARN_DOORS_HORIZONTAL_IN, page[4], page[6]);
			print_page(page[6], "HPDF_TS_BARN_DOORS_VERTICAL_OUT", font, 
				HPDF_TransitionStyle.HPDF_TS_BARN_DOORS_VERTICAL_OUT, page[5], page[7]);
			print_page(page[7], "HPDF_TS_BARN_DOORS_VERTICAL_IN", font, 
				HPDF_TransitionStyle.HPDF_TS_BARN_DOORS_VERTICAL_IN, page[6], page[8]);
			print_page(page[8], "HPDF_TS_BOX_OUT", font, 
				HPDF_TransitionStyle.HPDF_TS_BOX_OUT, page[7], page[9]);
			print_page(page[9], "HPDF_TS_BOX_IN", font, 
				HPDF_TransitionStyle.HPDF_TS_BOX_IN, page[8], page[10]);
			print_page(page[10], "HPDF_TS_BLINDS_HORIZONTAL", font, 
				HPDF_TransitionStyle.HPDF_TS_BLINDS_HORIZONTAL, page[9], page[11]);
			print_page(page[11], "HPDF_TS_BLINDS_VERTICAL", font, 
				HPDF_TransitionStyle.HPDF_TS_BLINDS_VERTICAL, page[10], page[12]);
			print_page(page[12], "HPDF_TS_DISSOLVE", font, 
				HPDF_TransitionStyle.HPDF_TS_DISSOLVE, page[11], page[13]);
			print_page(page[13], "HPDF_TS_GLITTER_RIGHT", font, 
				HPDF_TransitionStyle.HPDF_TS_GLITTER_RIGHT, page[12], page[14]);
			print_page(page[14], "HPDF_TS_GLITTER_DOWN", font, 
				HPDF_TransitionStyle.HPDF_TS_GLITTER_DOWN, page[13], page[15]);
			print_page(page[15], "HPDF_TS_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT", font, 
				HPDF_TransitionStyle.HPDF_TS_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT, page[14], page[16]);
			print_page(page[16], "HPDF_TS_REPLACE", font, 
				HPDF_TransitionStyle.HPDF_TS_REPLACE, page[15], null);
			
			
			pdfDoc.HPDF_SetPageMode ( HPDF_PageMode.HPDF_PAGE_MODE_FULL_SCREEN);
			
			
			return pdfDoc; 
		}		
	}
}