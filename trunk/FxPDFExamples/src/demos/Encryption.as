package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.enum.HPDF_PageSizes;
	import com.fxpdf.types.enum.HPDF_PageDirection;	
	
	public class Encryption
	{
		public function Encryption()
		{
		}
		
		public	static	function run( ownerPassword : String, userPassword : String ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			var tw 	   : Number ; 
			var text   : String = "Encryption demo";
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage() ;
			
			page.HPDF_Page_SetSize ( HPDF_PageSizes.HPDF_PAGE_SIZE_B5, HPDF_PageDirection.HPDF_PAGE_LANDSCAPE);
			
			/* create default-font */
			var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Helvetica", null);
			
			page.HPDF_Page_BeginText ();
			
			page.HPDF_Page_SetFontAndSize ( font, 20);
			tw = page.HPDF_Page_TextWidth ( text);
			
			page.HPDF_Page_MoveTextPos ( (page.HPDF_Page_GetWidth () - tw) / 2,
				(page.HPDF_Page_GetHeight ()  - 20) / 2);
			page.HPDF_Page_ShowText ( text);
			page.HPDF_Page_EndText (); 			
			
			pdfDoc.HPDF_SetPassword ( ownerPassword, userPassword); 			
			
			return pdfDoc; 
		}		
	}
}