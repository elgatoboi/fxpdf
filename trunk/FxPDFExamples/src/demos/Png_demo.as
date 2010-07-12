package demos
{
	public class Png_demo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.page.HPDF_Page;
		import com.fxpdf.image.HPDF_Image;		
		import mx.core.ByteArrayAsset;
		

		
		public function Png_demo()
		{
		}
		
		public	static	function run() : HPDF_Doc
		{
			var pdfDoc 			: HPDF_Doc ; 
			var page   			: HPDF_Page ; 
			var defFont 		: HPDF_Font ; 
			var PAGE_HEIGHT		: Number = 650;
			var PAGE_WIDTH		: Number = 550;
			var y				: int = 50; 
			
			//[Embed(source="assets/pngsuite/basn0g01.png", mimeType="application/octet-stream")]
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
			
			
			var byteArrayAsset 			: ByteArrayAsset	= new basn0g01();
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage();
			
			defFont = pdfDoc.HPDF_GetFont ( "Helvetica-Bold", null);
			page.HPDF_Page_SetFontAndSize ( defFont, 10);			
			
			page.HPDF_Page_SetHeight (PAGE_HEIGHT);
			page.HPDF_Page_SetWidth (PAGE_WIDTH); 
			
			var img		: HPDF_Image		= pdfDoc.HPDF_LoadPngImageFromByteArray( byteArrayAsset );
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn0g02() );
			page.HPDF_Page_DrawImage(img,180, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn0g04() );
			page.HPDF_Page_DrawImage(img,260, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn0g08() );
			page.HPDF_Page_DrawImage(img,340, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn0g16() );
			page.HPDF_Page_DrawImage(img,420, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			y += 50;
			
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn2c08() );
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn2c16() );
			page.HPDF_Page_DrawImage(img,180, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			y += 50;
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p01() );
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p02() );
			page.HPDF_Page_DrawImage(img,180, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p04() );
			page.HPDF_Page_DrawImage(img,260, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p08() );
			page.HPDF_Page_DrawImage(img,340, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			y += 50;
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn4a08() );
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn4a16() );
			page.HPDF_Page_DrawImage(img,180, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			y += 50;
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn6a08() );
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			img		= pdfDoc.HPDF_LoadPngImageFromByteArray( new basn6a16() );
			page.HPDF_Page_DrawImage(img,180, page.HPDF_Page_GetHeight() - y,  img.width , img.height);
			
			
			

			
			return pdfDoc;
			
		}		
	}
}