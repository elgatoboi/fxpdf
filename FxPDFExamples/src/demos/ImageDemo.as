package demos
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.image.HPDF_Image;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_EncryptMode;
	import com.fxpdf.types.enum.HPDF_PageDirection;
	import com.fxpdf.types.enum.HPDF_PageSizes;
	
	
	public class ImageDemo
	{
		

		[Embed(source="assets/pngsuite/basn0g01.png", mimeType="application/octet-stream")]
		private static var basn0g01:Class;
		
		[Embed(source="assets/pngsuite/basn0g02.png", mimeType="application/octet-stream")]
		private static var basn0g02:Class;
		
		[Embed(source="assets/pngsuite/basn0g04.png", mimeType="application/octet-stream")]
		private static var basn0g04:Class;
		
		[Embed(source="assets/pngsuite/basn0g08.png", mimeType="application/octet-stream")]
		private static var basn0g08:Class;
		
		[Embed(source="assets/pngsuite/basn0g16.png", mimeType="application/octet-stream")]
		private static var basn0g16:Class;
		
		[Embed(source="assets/pngsuite/basn2c08.png", mimeType="application/octet-stream")]
		private static var basn2c08:Class;
		
		[Embed(source="assets/pngsuite/basn2c16.png", mimeType="application/octet-stream")]
		private static var basn2c16:Class;
		
		[Embed(source="assets/pngsuite/basn3p01.png", mimeType="application/octet-stream")]
		private static var basn3p01:Class;
		
		[Embed(source="assets/pngsuite/basn3p02.png", mimeType="application/octet-stream")]
		private static var basn3p02:Class;
		
		[Embed(source="assets/pngsuite/basn3p04.png", mimeType="application/octet-stream")]
		private static var basn3p04:Class;
		
		[Embed(source="assets/pngsuite/basn3p08.png", mimeType="application/octet-stream")]
		private static var basn3p08:Class;
		
		[Embed(source="assets/pngsuite/basn4a08.png", mimeType="application/octet-stream")]
		private static var basn4a08:Class;
		
		[Embed(source="assets/pngsuite/basn4a16.png", mimeType="application/octet-stream")]
		private static var basn4a16:Class;
		
		[Embed(source="assets/pngsuite/basn6a08.png", mimeType="application/octet-stream")]
		private static var basn6a08:Class;
		
		[Embed(source="assets/pngsuite/basn6a16.png", mimeType="application/octet-stream")]
		private static var basn6a16:Class;
		
		[Embed(source="assets/pngsuite/maskimage.png", mimeType="application/octet-stream")]
		private static var maskimage:Class;
		
		public function ImageDemo()
		{
		}
		
		private  static function show_description ( page : HPDF_Page , x : Number , y : Number , text : String ) : void 
		{
			var buf	 : String = "";
			
			page.HPDF_Page_MoveTo ( x, y - 10);
			page.HPDF_Page_LineTo ( x, y + 10);
			page.HPDF_Page_MoveTo ( x - 10, y);
			page.HPDF_Page_LineTo ( x + 10, y);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_SetFontAndSize ( page.HPDF_Page_GetCurrentFont (), 8);
			page.HPDF_Page_SetRGBFill ( 0, 0, 0);
			
			page.HPDF_Page_BeginText ();
			
			buf = "(x=" + x.toString() + " ,y=" + y.toString() + ")" ;
			
			
			page.HPDF_Page_MoveTextPos ( x - page.HPDF_Page_TextWidth ( buf) - 5,
				y - 10);
			page.HPDF_Page_ShowText ( buf);
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x - 20, y - 25);
			page.HPDF_Page_ShowText ( text);
			page.HPDF_Page_EndText ();
		}
		
		public	static	function run(  ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			var tw 	   : Number ; 
			var text   : String = "User cannot print and copy this document.";
			var font	: HPDF_Font;
			var dst		: HPDF_Destination;
			var image	: HPDF_Image ; 
			var image1	: HPDF_Image ;
			var image2	: HPDF_Image ;
			var image3	: HPDF_Image ;
			
			var x		: Number;
			var y		: Number;
			var angle	: Number;
			var angle1	: Number;
			var angle2	: Number;
			var rad		: Number;
			var rad1	: Number;
			var rad2	: Number;
			var iw		: Number;
			var ih		: Number;
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			
			pdfDoc.HPDF_SetCompressionMode (HPDF_Consts.HPDF_COMP_ALL);
			
			/* create default-font */
			font = pdfDoc.HPDF_GetFont ( "Helvetica", null);
			
			/* add a new page object. */
			page = pdfDoc.HPDF_AddPage ();
			
			page.HPDF_Page_SetWidth ( 550);
			page.HPDF_Page_SetHeight ( 500 );
			
			dst = page.HPDF_Page_CreateDestination ();
			dst.HPDF_Destination_SetXYZ (  0, page.HPDF_Page_GetHeight (), 1);
			pdfDoc.HPDF_SetOpenAction(  dst);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_SetFontAndSize ( font, 20);
			page.HPDF_Page_MoveTextPos ( 220, page.HPDF_Page_GetHeight () - 70);
			page.HPDF_Page_ShowText ( "ImageDemo");
			page.HPDF_Page_EndText ();
			
			/* load image file. */
			image = pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p02() );
			
			/* image1 is masked by image2. */
			image1 = pdfDoc.HPDF_LoadPngImageFromByteArray( new basn3p02() );
			
			/* image2 is a mask image. */
			image2 = pdfDoc.HPDF_LoadPngImageFromByteArray( new basn0g01() );
			
			/* image3 is a RGB-color image. we use this image for color-mask
			* demo.
			*/
			image3 = pdfDoc.HPDF_LoadPngImageFromByteArray( new maskimage() );
			
			iw = image.HPDF_Image_GetWidth ();
			ih = image.HPDF_Image_GetHeight ();
			
			page.HPDF_Page_SetLineWidth ( 0.5 );
			
			x = 100;
			y = page.HPDF_Page_GetHeight() - 150;
			
			/* Draw image to the canvas. (normal-mode with actual size.)*/
			page.HPDF_Page_DrawImage ( image, x, y, iw, ih);
			
			show_description (page,x, y, "Actual Size");
			
			x += 150;
			
			/* Scalling image (X direction) */
			page.HPDF_Page_DrawImage ( image, x, y, iw * 1.5, ih);
			
			show_description (page, x, y, "Scalling image (X direction)");
			
			x += 150;
			
			/* Scalling image (Y direction). */
			page.HPDF_Page_DrawImage ( image, x, y, iw, ih * 1.5);
			show_description ( page,x, y, "Scalling image (Y direction)");
			
			x = 100;
			y -= 120;
			
			/* Skewing image. */
			angle1 = 10;
			angle2 = 20;
			rad1 = angle1 / 180 * 3.141592;
			rad2 = angle2 / 180 * 3.141592;
			
			page.HPDF_Page_GSave ();
			
			page.HPDF_Page_Concat ( iw, Math.tan(rad1) * iw, Math.tan(rad2) * ih, ih, x, y);
			
			page.HPDF_Page_ExecuteXObject ( image);
			page.HPDF_Page_GRestore ();
			
			show_description (page, x, y, "Skewing image");
			
			x += 150;
			
			/* Rotating image */
			angle = 30;     /* rotation of 30 degrees. */
			rad = angle / 180 * 3.141592; /* Calcurate the radian value. */
			
			page.HPDF_Page_GSave ();
			
			page.HPDF_Page_Concat ( iw * Math.cos(rad),
				iw * Math.sin(rad),
				ih * -Math.sin(rad),
				ih * Math.cos(rad),
				x, y);
			
			page.HPDF_Page_ExecuteXObject ( image);
			page.HPDF_Page_GRestore ();
			
			show_description (page, x, y, "Rotating image");
			
			x += 150;
			
			/* draw masked image. */
			
			/* Set image2 to the mask image of image1 */
			image1.HPDF_Image_SetMaskImage ( image2 );
			
			page.HPDF_Page_SetRGBFill ( 0, 0, 0);
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x - 6, y + 14);
			page.HPDF_Page_ShowText ( "MASKMASK");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_DrawImage ( image1, x - 3, y - 3, iw + 6, ih + 6);
			
			show_description (page, x, y, "masked image");
			
			x = 100;
			y -= 120;
			
			/* color mask. */
			page.HPDF_Page_SetRGBFill ( 0, 0, 0);
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x - 6, y + 14);
			page.HPDF_Page_ShowText ( "MASKMASK");
			page.HPDF_Page_EndText ();
			
			image3.HPDF_Image_SetColorMask ( 0, 255, 0, 0, 0, 255);
			page.HPDF_Page_DrawImage (image3, x, y, iw, ih);
			
			show_description (page, x, y, "Color Mask");
			
			return pdfDoc;
		}
		
	}
}