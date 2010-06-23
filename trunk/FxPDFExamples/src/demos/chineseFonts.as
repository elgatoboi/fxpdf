package demos
{
	
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.HPDF_Box;	
	import com.fxpdf.types.enum.HPDF_PageDirection;
	import com.fxpdf.types.enum.HPDF_PageSizes;	
	import com.fxpdf.types.enum.HPDF_TextAlignment;
	
	public class chineseFonts
	{
		
		public	static function	run( ) : HPDF_Doc
		{
			
			var pdfDoc : HPDF_Doc ; 
			var page   : HPDF_Page ;
			var rect : HPDF_Box = new HPDF_Box();
			var height : Number ; 
			var width  : Number ; 
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* Add a new page object. */ 
			page = pdfDoc.HPDF_AddPage() ;	
			
			page.HPDF_Page_SetSize ( HPDF_PageSizes.HPDF_PAGE_SIZE_A5, HPDF_PageDirection.HPDF_PAGE_PORTRAIT);
			
			height	= page.HPDF_Page_GetHeight () ;
			width	= page.HPDF_Page_GetWidth () ;
			
			pdfDoc.HPDF_UseCNSEncodings();
			pdfDoc.HPDF_UseCNSFonts();
			
			var chText : String = "我們又向南朝奧地利前進，目的地是先參觀哈爾恩鹽礦，隔日再往莫札特出生地薩爾斯堡朝聖。昔日巴德迪小鎮的鹽礦對照奧地利今天的富裕，已經不再具備重要經濟價值，很久以前就停止開採，進而轉為觀光景點，繼續經營。"
			
			var font :HPDF_Font = pdfDoc.HPDF_GetFont( "SimSun", "GBK-EUC-H");
			
			rect.left = 25;
			rect.top = 545;
			rect.right = width - 50;
			rect.bottom = rect.top - 340;				
			
			/* output subtitle. */
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_SetFontAndSize ( font, 10);
						
			page.HPDF_Page_TextRect ( rect.left, rect.top, rect.right, rect.bottom,
					chText, HPDF_TextAlignment.HPDF_TALIGN_LEFT, 0);			
			
			page.HPDF_Page_EndText ();			
						
			return pdfDoc;
		}
	}
}