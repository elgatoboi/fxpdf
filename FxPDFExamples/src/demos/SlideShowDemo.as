package demos
{	
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	
	public class SlideShowDemo
	{
		
		public static function print_page(page : HPDF_Page): void {
			
		}
	
		
		public	static	function	run( ) : HPDF_Doc
		{
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ; 
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage() ;
			
			return pdfDoc; 
		}		
	}
}