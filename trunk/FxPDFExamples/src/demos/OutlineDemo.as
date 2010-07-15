package demos
{
	import com.fxpdf.dict.HPDF_Outline;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.HPDF_PageMode;
	import com.fxpdf.types.enum.HPDF_LineJoin;

	public class OutlineDemo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.image.HPDF_Image;
		import com.fxpdf.page.HPDF_Page;
		
		import mx.core.ByteArrayAsset;
		

		
		public function OutlineDemo()
		{
		}
		
		
		
		private static function 	print_page  ( page : HPDF_Page, page_num : Number):void
		{
			var buf 		: String;
			
			page.HPDF_Page_SetWidth ( 200);
			page.HPDF_Page_SetHeight ( 200);
			
			
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
			var page			: Vector.<HPDF_Page> = new Vector.<HPDF_Page>(10);
			var outline			: Vector.<HPDF_Outline> = new Vector.<HPDF_Outline>(10);
			
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* create default-font */
			var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Helvetica", null);
			
			
			/* Set page mode to use outlines. */
			pdfDoc.HPDF_SetPageMode(HPDF_PageMode.HPDF_PAGE_MODE_USE_OUTLINE);
			
			/* Add 3 pages to the document. */
			page[0] = pdfDoc.HPDF_AddPage ();
			page[0].HPDF_Page_SetFontAndSize ( font, 30);
			print_page( page[0], 1);
			
			page[1] = pdfDoc.HPDF_AddPage ();
			page[1].HPDF_Page_SetFontAndSize ( font, 30);
			print_page(page[1], 2);
			
			page[2] = pdfDoc.HPDF_AddPage ();
			page[2].HPDF_Page_SetFontAndSize ( font, 30);
			print_page(page[2], 3);
			
			/* create outline root. */
			var root:HPDF_Outline = pdfDoc.HPDF_CreateOutline ( null, "OutlineRoot", null);
			root.HPDF_Outline_SetOpened ( true);
			
			outline[0] = pdfDoc.HPDF_CreateOutline ( root, "page1", null);
			outline[1] = pdfDoc.HPDF_CreateOutline ( root, "page2", null);
			
			/* create outline with test which is ISO8859-2 encoding */
			outline[2] = pdfDoc.HPDF_CreateOutline ( root, "ISO8859-2 text ÓÔŐÖ×ŘŮ", pdfDoc.HPDF_GetEncoder ( "ISO8859-2"));
			
			/* create destination objects on each pages
			* and link it to outline items.
			*/
			
			var dst:HPDF_Destination = page[0].HPDF_Page_CreateDestination ();
			dst.HPDF_Destination_SetXYZ( 0, page[0].HPDF_Page_GetHeight(), 1);
			outline[0].HPDF_Outline_SetDestination( dst );
			//  HPDF_Catalog_SetOpenAction(dst);
			
			dst = page[1].HPDF_Page_CreateDestination ();
			dst.HPDF_Destination_SetXYZ( 0, page[1].HPDF_Page_GetHeight(), 1);
			outline[1].HPDF_Outline_SetDestination( dst);
			
			dst = page[2].HPDF_Page_CreateDestination ();
			dst.HPDF_Destination_SetXYZ( 0, page[2].HPDF_Page_GetHeight(), 1);
			outline[2].HPDF_Outline_SetDestination( dst);
			
			
			return pdfDoc;
			
		}		
	}
}