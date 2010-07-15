package demos
{
	public class Jpeg_demo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.page.HPDF_Page;
		import com.fxpdf.image.HPDF_Image;		
		import mx.core.ByteArrayAsset;
		

		
		public function Jpeg_demo()
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
			[Embed(source="assets/rgb.jpg", mimeType="application/octet-stream")]
			var rgb:Class;
			
			[Embed(source="assets/pngsuite/basn0g02.png", mimeType="application/octet-stream")]
			var basn0g02:Class;
			
			var byteArrayAsset 			: ByteArrayAsset	= new rgb();
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage();
			
			defFont = pdfDoc.HPDF_GetFont ( "Helvetica-Bold", null);
			page.HPDF_Page_SetFontAndSize ( defFont, 10);			
			
			page.HPDF_Page_SetHeight (PAGE_HEIGHT);
			page.HPDF_Page_SetWidth (PAGE_WIDTH); 
			
			var img		: HPDF_Image		= pdfDoc.HPDF_LoadJpegImageFromFile( byteArrayAsset );
			page.HPDF_Page_DrawImage(img,100, 300,  img.width , img.height);
			
			

			
			return pdfDoc;
			
		}		
	}
}