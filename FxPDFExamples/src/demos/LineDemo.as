package demos
{
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.enum.HPDF_LineJoin;

	public class LineDemo
	{
		import com.fxpdf.doc.HPDF_Doc;
		import com.fxpdf.font.HPDF_Font;
		import com.fxpdf.image.HPDF_Image;
		import com.fxpdf.page.HPDF_Page;
		
		import mx.core.ByteArrayAsset;
		

		
		public function LineDemo()
		{
		}
		
		
		private static function draw_line  ( page : HPDF_Page, x : Number, y: Number , label : String ) : void 
		{
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x, y - 10);
			page.HPDF_Page_ShowText ( label);
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_MoveTo ( x, y - 15);
			page.HPDF_Page_LineTo ( x + 220, y - 15);
			page.HPDF_Page_Stroke ();
		}
		
		private  static function draw_line2  (page : HPDF_Page, x : Number, y: Number , label : String ) : void 
		{
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x, y);
			page.HPDF_Page_ShowText ( label);
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_MoveTo ( x + 30, y - 25);
			page.HPDF_Page_LineTo ( x + 160, y - 25);
			page.HPDF_Page_Stroke ();
		}
		
		private static function draw_rect (page : HPDF_Page, x : Number, y: Number , label : String ) : void 
		{
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x, y - 10);
			page.HPDF_Page_ShowText ( label);
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_Rectangle( x, y - 40, 220, 25);
		}
		
		
		public	static	function run() : HPDF_Doc
		{
			var pdfDoc 			: HPDF_Doc ; 
			var page   			: HPDF_Page ; 
			var defFont 		: HPDF_Font ; 
			var PAGE_HEIGHT		: Number = 650;
			var PAGE_WIDTH		: Number = 550;
			
			var DASH_MODE1:Vector.<uint> = Vector.<uint>([3]);
			var DASH_MODE2:Vector.<uint> =   Vector.<uint>([3, 7]);
			var DASH_MODE3:Vector.<uint> =  Vector.<uint>([8, 7, 2, 7]);
			
			var x				: Number;
			var y				: Number;
			var x1				: Number;
			var y1				: Number;
			var x2				: Number;
			var y2				: Number;
			var x3				: Number;
			var y3				: Number;
			
			var tw				: Number;
			
			pdfDoc = new HPDF_Doc( ) ; 
			
			/* create default-font */
			var font : HPDF_Font = pdfDoc.HPDF_GetFont ( "Helvetica", null);
			
			/* add a new page object. */
			page = pdfDoc.HPDF_AddPage ();
			
			/* print the lines of the page. */
			page.HPDF_Page_SetLineWidth ( 1);
			page.HPDF_Page_Rectangle ( 50, 50, page.HPDF_Page_GetWidth() - 100,
				page.HPDF_Page_GetHeight () - 110);
			page.HPDF_Page_Stroke ();
			
			/* print the title of the page (with positioning center). */
			page.HPDF_Page_SetFontAndSize ( font, 24);
			tw = page.HPDF_Page_TextWidth ( "Line example");
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( (page.HPDF_Page_GetWidth() - tw) / 2,
				page.HPDF_Page_GetHeight () - 50);
			page.HPDF_Page_ShowText ( "Line example");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetFontAndSize ( font, 10);
			
			/* Draw verious widths of lines. */
			page.HPDF_Page_SetLineWidth ( 0);
			draw_line ( page , 60, 770, "line width = 0");
			
			page.HPDF_Page_SetLineWidth ( 1.0);
			draw_line (page ,  60, 740, "line width = 1.0");
			
			page.HPDF_Page_SetLineWidth ( 2.0);
			draw_line (page ,  60, 710, "line width = 2.0");
			
			/* Line dash pattern */
			page.HPDF_Page_SetLineWidth ( 1.0);
			
			page.HPDF_Page_SetDash ( DASH_MODE1, 1, 1);
			draw_line (page ,  60, 680, "dash_ptn=[3], phase=1 -- " + "2 on, 3 off, 3 on...");
			
			page.HPDF_Page_SetDash ( DASH_MODE2, 2, 2);
			draw_line ( page , 60, 650, "dash_ptn=[7, 3], phase=2 -- " +
				"5 on 3 off, 7 on,...");
			
			page.HPDF_Page_SetDash ( DASH_MODE3, 4, 0);
			draw_line ( page , 60, 620, "dash_ptn=[8, 7, 2, 7], phase=0");
			
			page.HPDF_Page_SetDash ( null, 0, 0);
			
			page.HPDF_Page_SetLineWidth ( 30);
			page.HPDF_Page_SetRGBStroke ( 0.0, 0.5, 0.0);
			
			/* Line Cap Style */
			page.HPDF_Page_SetLineCap ( HPDF_LineCap.HPDF_BUTT_END);
			draw_line2 (page ,  60, 570, "PDF_BUTT_END");
			
			page.HPDF_Page_SetLineCap ( HPDF_LineCap.HPDF_ROUND_END);
			draw_line2 ( page , 60, 505, "PDF_ROUND_END");
			
			page.HPDF_Page_SetLineCap ( HPDF_LineCap.HPDF_PROJECTING_SCUARE_END);
			draw_line2 (page ,  60, 440, "PDF_PROJECTING_SCUARE_END");
			
			/* Line Join Style */
			page.HPDF_Page_SetLineWidth ( 30);
			page.HPDF_Page_SetRGBStroke ( 0.0, 0.0, 0.5);
			
			page.HPDF_Page_SetLineJoin ( HPDF_LineJoin.HPDF_MITER_JOIN);
			page.HPDF_Page_MoveTo ( 120, 300);
			page.HPDF_Page_LineTo ( 160, 340);
			page.HPDF_Page_LineTo ( 200, 300);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 60, 360);
			page.HPDF_Page_ShowText ( "PDF_MITER_JOIN");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetLineJoin ( HPDF_LineJoin.HPDF_ROUND_JOIN);
			page.HPDF_Page_MoveTo ( 120, 195);
			page.HPDF_Page_LineTo ( 160, 235);
			page.HPDF_Page_LineTo ( 200, 195);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 60, 255);
			page.HPDF_Page_ShowText ( "PDF_ROUND_JOIN");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetLineJoin ( HPDF_LineJoin.HPDF_BEVEL_JOIN);
			page.HPDF_Page_MoveTo ( 120, 90);
			page.HPDF_Page_LineTo ( 160, 130);
			page.HPDF_Page_LineTo ( 200, 90);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 60, 150);
			page.HPDF_Page_ShowText ( "PDF_BEVEL_JOIN");
			page.HPDF_Page_EndText ();
			
			/* Draw Rectangle */
			page.HPDF_Page_SetLineWidth ( 2);
			page.HPDF_Page_SetRGBStroke ( 0, 0, 0);
			page.HPDF_Page_SetRGBFill ( 0.75, 0.0, 0.0);
			
			draw_rect (page ,  300, 770, "Stroke");
			page.HPDF_Page_Stroke ();
			
			draw_rect ( page , 300, 720, "Fill");
			page.HPDF_Page_Fill ();
			
			draw_rect (page, 300, 670, "Fill then Stroke");
			page.HPDF_Page_FillStroke ();
			
			/* Clip Rect */
			page.HPDF_Page_GSave ();  /* Save the current graphic state */
			draw_rect ( page , 300, 620, "Clip Rectangle");
			page.HPDF_Page_Clip ();
			page.HPDF_Page_Stroke ();
			page.HPDF_Page_SetFontAndSize ( font, 13);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 290, 600);
			page.HPDF_Page_SetTextLeading ( 12);
			page.HPDF_Page_ShowText (
				"Clip Clip Clip Clip Clip Clipi Clip Clip Clip");
			page.HPDF_Page_ShowTextNextLine (
				"Clip Clip Clip Clip Clip Clip Clip Clip Clip");
			page.HPDF_Page_ShowTextNextLine (
				"Clip Clip Clip Clip Clip Clip Clip Clip Clip");
			page.HPDF_Page_EndText ();
			page.HPDF_Page_GRestore ();
			
			/* Curve Example(CurveTo2) */
			x = 330;
			y = 440;
			x1 = 430;
			y1 = 530;
			x2 = 480;
			y2 = 470;
			x3 = 480;
			y3 = 90;
			
			page.HPDF_Page_SetRGBFill ( 0, 0, 0);
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 300, 540);
			page.HPDF_Page_ShowText ( "CurveTo2(x1, y1, x2. y2)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x + 5, y - 5);
			page.HPDF_Page_ShowText ( "Current point");
			page.HPDF_Page_MoveTextPos ( x1 - x, y1 - y);
			page.HPDF_Page_ShowText ( "(x1, y1)");
			page.HPDF_Page_MoveTextPos ( x2 - x1, y2 - y1);
			page.HPDF_Page_ShowText ( "(x2, y2)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetDash ( DASH_MODE1, 1, 0);
			
			page.HPDF_Page_SetLineWidth ( 0.5);
			page.HPDF_Page_MoveTo ( x1, y1);
			page.HPDF_Page_LineTo ( x2, y2);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_SetDash ( null, 0, 0);
			
			page.HPDF_Page_SetLineWidth ( 1.5);
			
			page.HPDF_Page_MoveTo ( x, y);
			page.HPDF_Page_CurveTo2 ( x1, y1, x2, y2);
			page.HPDF_Page_Stroke ();
			
			/* Curve Example(CurveTo3) */
			y -= 150;
			y1 -= 150;
			y2 -= 150;
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 300, 390);
			page.HPDF_Page_ShowText ( "CurveTo3(x1, y1, x2. y2)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x + 5, y - 5);
			page.HPDF_Page_ShowText ( "Current point");
			page.HPDF_Page_MoveTextPos ( x1 - x, y1 - y);
			page.HPDF_Page_ShowText ( "(x1, y1)");
			page.HPDF_Page_MoveTextPos ( x2 - x1, y2 - y1);
			page.HPDF_Page_ShowText ( "(x2, y2)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetDash ( DASH_MODE1, 1, 0);
			
			page.HPDF_Page_SetLineWidth ( 0.5);
			page.HPDF_Page_MoveTo ( x, y);
			page.HPDF_Page_LineTo ( x1, y1);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_SetDash ( null, 0, 0);
			
			page.HPDF_Page_SetLineWidth ( 1.5);
			page.HPDF_Page_MoveTo ( x, y);
			page.HPDF_Page_CurveTo3 ( x1, y1, x2, y2);
			page.HPDF_Page_Stroke ();
			
			/* Curve Example(CurveTo) */
			y -= 150;
			y1 -= 160;
			y2 -= 130;
			x2 += 10;
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( 300, 240);
			page.HPDF_Page_ShowText ( "CurveTo(x1, y1, x2. y2, x3, y3)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_BeginText ();
			page.HPDF_Page_MoveTextPos ( x + 5, y - 5);
			page.HPDF_Page_ShowText ( "Current point");
			page.HPDF_Page_MoveTextPos ( x1 - x, y1 - y);
			page.HPDF_Page_ShowText ( "(x1, y1)");
			page.HPDF_Page_MoveTextPos ( x2 - x1, y2 - y1);
			page.HPDF_Page_ShowText ( "(x2, y2)");
			page.HPDF_Page_MoveTextPos ( x3 - x2, y3 - y2);
			page.HPDF_Page_ShowText ( "(x3, y3)");
			page.HPDF_Page_EndText ();
			
			page.HPDF_Page_SetDash ( DASH_MODE1, 1, 0);
			
			page.HPDF_Page_SetLineWidth ( 0.5);
			page.HPDF_Page_MoveTo ( x, y);
			page.HPDF_Page_LineTo ( x1, y1);
			page.HPDF_Page_Stroke ();
			page.HPDF_Page_MoveTo ( x2, y2);
			page.HPDF_Page_LineTo ( x3, y3);
			page.HPDF_Page_Stroke ();
			
			page.HPDF_Page_SetDash ( null, 0, 0);
			
			page.HPDF_Page_SetLineWidth ( 1.5);
			page.HPDF_Page_MoveTo ( x, y);
			page.HPDF_Page_CurveTo ( x1, y1, x2, y2, x3, y3);
			page.HPDF_Page_Stroke ();
			
			
			
		
		
			
			return pdfDoc;
			
		}		
	}
}