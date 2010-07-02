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
			
			[Embed(source="assets/pngsuite/basn0g01.png", mimeType="application/octet-stream")]
			var basn0g01:Class;
			
			var byteArrayAsset 			: ByteArrayAsset	= new basn0g01();
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage();
			
			defFont = pdfDoc.HPDF_GetFont ( "Helvetica-Bold", null);
			page.HPDF_Page_SetFontAndSize ( defFont, 10);			
			
			page.HPDF_Page_SetHeight (PAGE_HEIGHT);
			page.HPDF_Page_SetWidth (PAGE_WIDTH); 
			
			var img		: HPDF_Image		= pdfDoc.HPDF_LoadPngImageFromByteArray( byteArrayAsset );
			
			page.HPDF_Page_DrawImage(img,100, page.HPDF_Page_GetHeight() - 150,  img.width , img.height);
			
			return pdfDoc;
			
		}		
	}
}