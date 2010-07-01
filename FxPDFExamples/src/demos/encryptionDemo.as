package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.enum.HPDF_PageDirection;
	import com.fxpdf.types.enum.HPDF_PageSizes;
	import com.fxpdf.types.enum.HPDF_TextAlignment;
	
	public class encryptionDemo
	{
		private var no : int = 0; 
		
		public function textDemo2()
		{
		}
		
		
		
		public	static	function	run( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			var text	: String = "This is an encrypt document example.";
   		    pdfDoc = new HPDF_Doc( ) ; 
   		   
   		    /* Add a new page object. */ 
   		    page = pdfDoc.HPDF_AddPage() ;
   		   
		    page.HPDF_Page_SetSize ( HPDF_PageSizes.HPDF_PAGE_SIZE_B5, HPDF_PageDirection.HPDF_PAGE_LANDSCAPE);
		
		    var font : HPDF_Font = pdfDoc.HPDF_GetFont ("Helvetica", null);
			
		    page.HPDF_Page_BeginText ();
			 
		    page.HPDF_Page_SetFontAndSize ( font, 20);
			
			var tw:Number = page.HPDF_Page_TextWidth( text );
			
			page.HPDF_Page_MoveTextPos (  ( page.HPDF_Page_GetWidth () - tw) / 2,( page.HPDF_Page_GetHeight () - 20) / 2);
			page.HPDF_Page_ShowText (text);
			page.HPDF_Page_EndText ();
			
			pdfDoc.HPDF_SetPassword ( "owner","user"); 
		
		    return pdfDoc; 
					
		}

   

	}
}