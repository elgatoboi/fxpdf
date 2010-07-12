package demos
{
	public class Png_demo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.image.HPDF_Image;
		import com.fxpdf.page.HPDF_Page;
		import com.fxpdf.HPDF_Consts;
		import com.fxpdf.types.HPDF_Destination;
		
		import mx.core.ByteArrayAsset;
		

		
		public function Png_demo()
		{
		}
		
		public static function draw_image(pdfDoc: HPDF_Doc, page : HPDF_Page , imgClass : Class, filename : String, x : Number, y : Number, text : String): void {
			
			var img		: HPDF_Image		= pdfDoc.HPDF_LoadPngImageFromByteArray( new imgClass() );
			page.HPDF_Page_DrawImage(img, x, y,  img.width , img.height);
			
			/* Print the text. */
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_SetTextLeading (16);
			page.HPDF_Page_MoveTextPos ( x, y);
			page.HPDF_Page_ShowTextNextLine (filename);
			page.HPDF_Page_ShowTextNextLine (text);
			page.HPDF_Page_EndText (); 			
		}
		
		public	static	function run() : HPDF_Doc
		{
			var pdfDoc 			: HPDF_Doc ; 
			var page   			: HPDF_Page ; 
			var defFont 		: HPDF_Font ; 
			var PAGE_HEIGHT		: Number = 650;
			var PAGE_WIDTH		: Number = 550;
			var dst				: HPDF_Destination;

			[Embed(source="assets/pngsuite/basn0g01.png", mimeType="application/octet-stream")]
			var basn0g01:Class;
			
			[Embed(source="assets/pngsuite/basn0g02.png", mimeType="application/octet-stream")]
			var basn0g02:Class;
			
			[Embed(source="assets/pngsuite/basn0g04.png", mimeType="application/octet-stream")]
			var basn0g04:Class;
			
			[Embed(source="assets/pngsuite/basn0g08.png", mimeType="application/octet-stream")]
			var basn0g08:Class;
			
			[Embed(source="assets/pngsuite/basn0g16.png", mimeType="application/octet-stream")]
			var basn0g16:Class;
			
			[Embed(source="assets/pngsuite/basn2c08.png", mimeType="application/octet-stream")]
			var basn2c08:Class;
			
			[Embed(source="assets/pngsuite/basn2c16.png", mimeType="application/octet-stream")]
			var basn2c16:Class;
			
			[Embed(source="assets/pngsuite/basn3p01.png", mimeType="application/octet-stream")]
			var basn3p01:Class;
			
			[Embed(source="assets/pngsuite/basn3p02.png", mimeType="application/octet-stream")]
			var basn3p02:Class;
			
			[Embed(source="assets/pngsuite/basn3p04.png", mimeType="application/octet-stream")]
			var basn3p04:Class;
			
			[Embed(source="assets/pngsuite/basn3p08.png", mimeType="application/octet-stream")]
			var basn3p08:Class;
			
			[Embed(source="assets/pngsuite/basn4a08.png", mimeType="application/octet-stream")]
			var basn4a08:Class;
			
			[Embed(source="assets/pngsuite/basn4a16.png", mimeType="application/octet-stream")]
			var basn4a16:Class;
			
			[Embed(source="assets/pngsuite/basn6a08.png", mimeType="application/octet-stream")]
			var basn6a08:Class;
			
			[Embed(source="assets/pngsuite/basn6a16.png", mimeType="application/octet-stream")]
			var basn6a16:Class;
						
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage();
			
			page.HPDF_Page_SetHeight (PAGE_HEIGHT);
			page.HPDF_Page_SetWidth (PAGE_WIDTH);	
			
			defFont = pdfDoc.HPDF_GetFont ( "Helvetica", null);			
			
			pdfDoc.HPDF_SetCompressionMode(HPDF_Consts.HPDF_COMP_ALL);

			dst = page.HPDF_Page_CreateDestination()
			dst.HPDF_Destination_SetXYZ(0, page.HPDF_Page_GetHeight (), 1);
			
//			HPDF_SetOpenAction(pdf, dst);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_SetFontAndSize ( defFont, 20);
			page.HPDF_Page_MoveTextPos ( 220, page.HPDF_Page_GetHeight () - 70);
			page.HPDF_Page_ShowText ( "PngDemo");
			page.HPDF_Page_EndText ();
						

			page.HPDF_Page_SetFontAndSize ( defFont, 12);			

			
			draw_image(pdfDoc, page, basn0g01, "basn0g01.png", 100, page.HPDF_Page_GetHeight() - 150,  "1bit grayscale.");
			
			draw_image(pdfDoc, page, basn0g02, "basn0g02.png", 200, page.HPDF_Page_GetHeight() - 150,  "2bit grayscale.");
			
			draw_image(pdfDoc, page, basn0g04, "basn0g04.png", 300, page.HPDF_Page_GetHeight() - 150,  "4bit grayscale.");
			
			draw_image(pdfDoc, page, basn0g08, "basn0g08.png", 400, page.HPDF_Page_GetHeight() - 150,  "8bit grayscale.");

			draw_image(pdfDoc, page, basn2c08, "basn2c08.png", 100, page.HPDF_Page_GetHeight() - 250,  "8bit color.");
			
			draw_image(pdfDoc, page, basn2c16, "basn2c16.png", 200, page.HPDF_Page_GetHeight() - 250,  "16bit color.");
			
			draw_image(pdfDoc, page, basn2c16, "basn3p01.png", 100, page.HPDF_Page_GetHeight() - 350,  "1bit pallet.");

			draw_image(pdfDoc, page, basn3p02, "basn3p02.png", 200, page.HPDF_Page_GetHeight() - 350,  "2bit pallet.");
			
			draw_image(pdfDoc, page, basn3p04, "basn3p04.png", 300, page.HPDF_Page_GetHeight() - 350,  "4bit pallet.");

			draw_image(pdfDoc, page, basn3p08, "basn3p08.png", 400, page.HPDF_Page_GetHeight() - 350,  "8bit pallet.");
			
			draw_image(pdfDoc, page, basn4a08, "basn4a08.png", 100, page.HPDF_Page_GetHeight() - 450,  "8bit alpha.");
			
			draw_image(pdfDoc, page, basn4a08, "basn4a16.png", 200, page.HPDF_Page_GetHeight() - 450,  "16bit alpha.");
			
			draw_image(pdfDoc, page, basn6a08, "basn6a08.png", 100, page.HPDF_Page_GetHeight() - 550,  "8bit alpha.");

			draw_image(pdfDoc, page, basn6a16, "basn6a16.png", 200, page.HPDF_Page_GetHeight() - 550,  "16bit alpha.");

			
			return pdfDoc;
			
		}		
	}
}