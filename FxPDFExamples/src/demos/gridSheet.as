package demos
{
	import com.fxpdf.doc.HPDF_Doc;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.page.HPDF_Page;
	
	public class gridSheet
	{
		public function gridSheet()
		{
		}
		
		
		public	static	function	printSheet ( pdfDoc : HPDF_Doc,  page : HPDF_Page ) : void
		{
			var height : Number	= page.HPDF_Page_GetHeight();
			var width : Number	= page.HPDF_Page_GetWidth();
			var font : HPDF_Font = pdfDoc.HPDF_GetFont( "Helvetica",null ) ;
			var x : uint ; 
			var y : uint ; 
			
			page.HPDF_Page_SetFontAndSize( font, 5 ) ;
			page.HPDF_Page_SetGrayFill( 0.5 ) ;
			page.HPDF_Page_SetGrayStroke( 0.8 );
			
		    /* Draw horizontal lines */
		    y = 0;
		    while (y < height) {
		        if (y % 10 == 0)
		            page.HPDF_Page_SetLineWidth ( 0.5);
		        else {
		            if ( page.HPDF_Page_GetLineWidth () != 0.25)
		                page.HPDF_Page_SetLineWidth ( 0.25);
		        }
		
		        page.HPDF_Page_MoveTo (0, y);
		        page.HPDF_Page_LineTo ( width, y);
		        page.HPDF_Page_Stroke ();
		
		        if (y % 10 == 0 && y > 0) {
		            page.HPDF_Page_SetGrayStroke ( 0.5);
		
		            page.HPDF_Page_MoveTo ( 0, y);
		            page.HPDF_Page_LineTo ( 5, y);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_SetGrayStroke ( 0.8);
		        }
		        y += 5;
		    }
		
		
		    /* Draw virtical lines */
		    x = 0;
		    while (x < width) {
		        if (x % 10 == 0)
		            page.HPDF_Page_SetLineWidth ( 0.5);
		        else {
		            if (page.HPDF_Page_GetLineWidth () != 0.25)
		                page.HPDF_Page_SetLineWidth ( 0.25);
		        }
		
		        page.HPDF_Page_MoveTo ( x, 0);
		        page.HPDF_Page_LineTo ( x, height);
		        page.HPDF_Page_Stroke ();
		
		        if (x % 50 == 0 && x > 0) {
		            page.HPDF_Page_SetGrayStroke ( 0.5);
		
		            page.HPDF_Page_MoveTo ( x, 0);
		            page.HPDF_Page_LineTo ( x, 5);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_MoveTo ( x, height);
		            page.HPDF_Page_LineTo ( x, height - 5);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_SetGrayStroke ( 0.8);
		        }
		
		        x += 5;
		    }

		    /* Draw horizontal text */
		    y = 0;
		    while (y < height) {
		        if (y % 10 == 0 && y > 0) {
		            var buf : String ; 
		
		            page.HPDF_Page_BeginText ();
		            page.HPDF_Page_MoveTextPos ( 5, y - 2);
		            buf = y.toString() ; 
		
		            page.HPDF_Page_ShowText ( buf);
		            page.HPDF_Page_EndText ();
		        }

		        y += 5;
		    }


		    /* Draw virtical text */
		    x = 0;
		    while (x < width) {
		        if (x % 50 == 0 && x > 0) {
		            
		
		            page.HPDF_Page_BeginText ();
		            page.HPDF_Page_MoveTextPos ( x, 5);
		            var buf2 : String = x.toString();
		             
		            page.HPDF_Page_ShowText ( buf2);
		            page.HPDF_Page_EndText ();
		
		            page.HPDF_Page_BeginText ();
		            page.HPDF_Page_MoveTextPos ( x, height - 10);
		            page.HPDF_Page_ShowText ( buf2 );
		            page.HPDF_Page_EndText ();
		        }
		
		        x += 5;
		    }
		
		    page.HPDF_Page_SetGrayFill ( 0);
		    page.HPDF_Page_SetGrayStroke ( 0);
		}
		
		
		
		public	static	function	printGrid( pdf :HPDF_Doc, page : HPDF_Page ): void
		{
			var height : Number		=	page.HPDF_Page_GetHeight();
			var width : Number		=	page.HPDF_Page_GetWidth();
			var font : HPDF_Font	=	pdf.HPDF_GetFont("Helvetica", null);
			
			var x : uint ; 
			var y : uint; 
			
			
		    page.HPDF_Page_SetFontAndSize ( font, 5);
		    page.HPDF_Page_SetGrayFill ( 0.5);
		    page.HPDF_Page_SetGrayStroke ( 0.8);
		
		    /* Draw horizontal lines */
		    y = 0;
		    while (y < height) {
		        if (y % 10 == 0)
		            page.HPDF_Page_SetLineWidth ( 0.5);
		        else {
		            if (page.HPDF_Page_GetLineWidth () != 0.25)
		                page.HPDF_Page_SetLineWidth ( 0.25);
		        }
		
		        page.HPDF_Page_MoveTo ( 0, y);
		        page.HPDF_Page_LineTo ( width, y);
		        page.HPDF_Page_Stroke ();
		
		        if (y % 10 == 0 && y > 0) {
		            page.HPDF_Page_SetGrayStroke ( 0.5);
		
		            page.HPDF_Page_MoveTo ( 0, y);
		            page.HPDF_Page_LineTo ( 5, y);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_SetGrayStroke ( 0.8);
		        }
		
		        y += 5;
		    }
		
		
		    /* Draw virtical lines */
		    x = 0;
		    while (x < width) {
		        if (x % 10 == 0)
		            page.HPDF_Page_SetLineWidth ( 0.5);
		        else {
		            if (page.HPDF_Page_GetLineWidth () != 0.25)
		                page.HPDF_Page_SetLineWidth ( 0.25);
		        }
		
		        page.HPDF_Page_MoveTo ( x, 0);
		        page.HPDF_Page_LineTo ( x, height);
		        page.HPDF_Page_Stroke ();
		
		        if (x % 50 == 0 && x > 0) {
		            page.HPDF_Page_SetGrayStroke ( 0.5);
		
		            page.HPDF_Page_MoveTo ( x, 0);
		            page.HPDF_Page_LineTo ( x, 5);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_MoveTo ( x, height);
		            page.HPDF_Page_LineTo ( x, height - 5);
		            page.HPDF_Page_Stroke ();
		
		            page.HPDF_Page_SetGrayStroke ( 0.8);
	        }
		
		        x += 5;
		    }
		
	    /* Draw horizontal text */
	 	   y = 0;
	 	   while (y < height) {
	 	       if (y % 10 == 0 && y > 0) {
			
	
	            page.HPDF_Page_BeginText ();
	            page.HPDF_Page_MoveTextPos ( 5, y - 2);
	            var buf : String = y.toString(); 
	            page.HPDF_Page_ShowText ( buf);
	            page.HPDF_Page_EndText ();
	        }
	
	        y += 5;
	    }
	
	
	    /* Draw virtical text */
	    x = 0;
	    while (x < width) {
	        if (x % 50 == 0 && x > 0) {
	            page.HPDF_Page_BeginText ();
	            page.HPDF_Page_MoveTextPos ( x, 5);
				var buf2 : String = x.toString(); 
	            page.HPDF_Page_ShowText ( buf2);
	            page.HPDF_Page_EndText ();
	
	            page.HPDF_Page_BeginText ();
	            page.HPDF_Page_MoveTextPos ( x, height - 10);
	            page.HPDF_Page_ShowText ( buf2);
	            page.HPDF_Page_EndText ();
	        }
	
	        x += 5;
	    }
	
	    page.HPDF_Page_SetGrayFill ( 0);
	    page.HPDF_Page_SetGrayStroke ( 0);
		}

	}
}


