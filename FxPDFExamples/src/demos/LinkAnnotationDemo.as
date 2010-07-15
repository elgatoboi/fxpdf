package demos
{
	import com.fxpdf.dict.HPDF_Annotation;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.HPDF_Rect;
	import com.fxpdf.types.enum.HPDF_AnnotHighlightMode;
	import com.fxpdf.types.enum.HPDF_LineJoin;

	public class LinkAnnotationDemo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.image.HPDF_Image;
		import com.fxpdf.page.HPDF_Page;
		
		import mx.core.ByteArrayAsset;
		

		
		public function LinkAnnotationDemo()
		{
		}
		
		private static function 	print_page  ( page : HPDF_Page, font : HPDF_Font, page_num : Number):void
		{
			var buf 		: String;
			
			page.HPDF_Page_SetWidth ( 200);
			page.HPDF_Page_SetHeight ( 200);
			
			page.HPDF_Page_SetFontAndSize ( font, 20);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 50, 150);
			buf = "Page " + page_num.toString( ) ;
			
			page.HPDF_Page_ShowText ( buf);
			page.HPDF_Page_EndText ();
		} 
		
		
		
		public	static	function run() : HPDF_Doc
		{
			var pdfDoc 			: HPDF_Doc ; 
			
			var defFont 		: HPDF_Font ; 
			var PAGE_HEIGHT		: Number = 650;
			var PAGE_WIDTH		: Number = 550;
			var page			: Vector.<HPDF_Page> = new Vector.<HPDF_Page>(8);
			var tp				: HPDF_Point; 
		 	var annot			: HPDF_Annotation;
			var rect			: HPDF_Rect;
			var dst				: HPDF_Destination;
			
			var uri	: String  = "http://sourceforge.net/projects/libharu"; 
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			
			/* create default-font */
			var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Helvetica", null);
			
			/* add a new page object. */
			
			/* create index page */
			var  index_page : HPDF_Page = pdfDoc.HPDF_AddPage ();
			index_page.HPDF_Page_SetWidth ( 300);
			index_page.HPDF_Page_SetHeight ( 220);
			
			/* Add 7 pages to the document. */
			for (var i:int = 0; i < 7; i++) {
				page[i] = pdfDoc.HPDF_AddPage ();
				print_page( page[i], font, i + 1);
			}
			
			index_page.HPDF_Page_BeginText ();
			index_page.HPDF_Page_SetFontAndSize ( font, 10);
			index_page.HPDF_Page_MoveTextPos ( 15, 200);
			index_page.HPDF_Page_ShowText ( "Link Annotation Demo");
			index_page.HPDF_Page_EndText ();
			
			/*
			* Create Link-Annotation object on index page.
			*/
			index_page.HPDF_Page_BeginText();
			index_page.HPDF_Page_SetFontAndSize ( font, 8);
			index_page.HPDF_Page_MoveTextPos ( 20, 180);
			index_page.HPDF_Page_SetTextLeading ( 23);
			
			/* page1 (HPDF_ANNOT_NO_HIGHTLIGHT) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page1 (HilightMode=HPDF_ANNOT_NO_HIGHTLIGHT)");
			rect = new HPDF_Rect();
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[0].HPDF_Page_CreateDestination ( );
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetHighlightMode (HPDF_AnnotHighlightMode.HPDF_ANNOT_NO_HIGHTLIGHT);
			
			
			/* page2 (HPDF_ANNOT_INVERT_BOX) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page2 (HilightMode=HPDF_ANNOT_INVERT_BOX)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[1].HPDF_Page_CreateDestination ();
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetHighlightMode ( HPDF_AnnotHighlightMode.HPDF_ANNOT_INVERT_BOX);
			
			
			/* page3 (HPDF_ANNOT_INVERT_BORDER) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page3 (HilightMode=HPDF_ANNOT_INVERT_BORDER)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[2].HPDF_Page_CreateDestination ();
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetHighlightMode ( HPDF_AnnotHighlightMode.HPDF_ANNOT_INVERT_BORDER);
			
			
			/* page4 (HPDF_ANNOT_DOWN_APPEARANCE) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page4 (HilightMode=HPDF_ANNOT_DOWN_APPEARANCE)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[3].HPDF_Page_CreateDestination ();
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetHighlightMode ( HPDF_AnnotHighlightMode.HPDF_ANNOT_DOWN_APPEARANCE);
			
			
			/* page5 (dash border) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page5 (dash border)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[4].HPDF_Page_CreateDestination ();
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetBorderStyle ( 1, 3, 2);
			
			
			/* page6 (no border) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page6 (no border)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[5].HPDF_Page_CreateDestination ();
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetBorderStyle ( 0, 0, 0);
			
			
			/* page7 (bold border) */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "Jump to Page7 (bold border)");
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_MoveToNextLine ();
			
			dst = page[6].HPDF_Page_CreateDestination ( );
			
			annot = index_page.HPDF_Page_CreateLinkAnnot ( rect, dst);
			
			annot.HPDF_LinkAnnot_SetBorderStyle ( 2, 0, 0);
			
			
			/* URI link */
			tp = index_page.HPDF_Page_GetCurrentTextPos ();
			
			index_page.HPDF_Page_ShowText ( "URI (");
			index_page.HPDF_Page_ShowText ( uri );
			index_page.HPDF_Page_ShowText ( ")");
			
			rect.left = tp.x - 4;
			rect.bottom = tp.y - 4;
			rect.right = index_page.HPDF_Page_GetCurrentTextPos ().x + 4;
			rect.top = tp.y + 10;
			
			index_page.HPDF_Page_CreateURILinkAnnot ( rect, uri);
			
			index_page.HPDF_Page_EndText (); 
			
		
		
			
			return pdfDoc;
			
		}		
	}
}