package com.fxpdf.dict
{
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.streams.HPDF_MemStream;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.xref.HPDF_Xref;

	public class HPDF_DictStream extends HPDF_Dict
	{
		public function HPDF_DictStream( xref:HPDF_Xref )
		{
			super();
			
			xref.HPDF_Xref_Add( this );
			
			var	length : HPDF_Number	=	new HPDF_Number( 0 ) ;
			
			xref.HPDF_Xref_Add( length );
			
			HPDF_Dict_Add( "Length", length);
			
			this.stream = new HPDF_MemStream();
			
		}
	}
}