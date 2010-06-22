package com.fxpdf.font
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.objects.HPDF_List;
	import com.fxpdf.types.enum.HPDF_FontDefType;

	public class HPDF_CIDFontDef extends HPDF_FontDef
	{
		
		
		public function HPDF_CIDFontDef( name : String,  initFn : Function )
		{
			super();
			
			var fontdef_attr			:HPDF_CIDFontDefAttr = new HPDF_CIDFontDefAttr();
			
			this.baseFont	= name;
			this.type		= HPDF_FontDefType.HPDF_FONTDEF_TYPE_UNINITIALIZED;
			this.valid		= false; 
			this.attr		= fontdef_attr;
			this.initFn		= initFn;
			
			fontdef_attr.widths = new HPDF_List( HPDF_Conf.HPDF_DEF_CHAR_WIDTHS_NUM );
			
			this.missingWidth		= 500;
			fontdef_attr.DW			= 1000;
			fontdef_attr.DW2[0]		= 880;
			fontdef_attr.DW2[1]		= -1000;
			
		}
		
		public function HPDF_CIDFontDef_FreeWidth  ():void
		{
			var attr 			: HPDF_CIDFontDefAttr = this.attr as HPDF_CIDFontDefAttr;
    		var i 				: uint;
			
    		trace (" HPDF_FontDef_Validate");
			
			attr.widths = null ; 
		    this.valid = false;
		}
		
		public function HPDF_CIDFontDef_GetCIDWidth  ( cid : uint ) :int 
		{
			var attr 			: HPDF_CIDFontDefAttr = this.attr as HPDF_CIDFontDefAttr;
			var i 				: uint;
            
    		trace(" HPDF_CIDFontDef_GetCIDWidth");
			
			for ( i = 0 ; i < attr.widths.count ; i++ ) {
				var w:HPDF_CID_Width = attr.widths.HPDF_List_ItemAt(i) as HPDF_CID_Width;
				if ( w.cid == cid ) 
					return w.width; 
			}
			return attr.DW;
		}
		
		public function HPDF_CIDFontDef_AddWidth( widths : Array):void
		{
			
			var attr 			: HPDF_CIDFontDefAttr = this.attr as HPDF_CIDFontDefAttr;
			
			trace (" HPDF_CIDFontDef_AddWidth");
			
			for ( var i: int = 0; i < widths.length ; i++ ) { 
				attr.widths.HPDF_List_Add( widths[i] );
			}
		
		}
		
		public function HPDF_CIDFontDef_ChangeStyle  ( bold:Boolean, italic:Boolean ) :void
		{
			var attr 			: HPDF_CIDFontDefAttr = this.attr as HPDF_CIDFontDefAttr;
			
			trace (" HPDF_CIDFontDef_ChangeStyle");
			if (bold) {
				this.stemv *= 2; 
				this.flags |= HPDF_FONT_FOURCE_BOLD;;
			}
			
			if (italic) {
				this.italicAngle -= 11;
				this.flags 		|= HPDF_FONT_ITALIC;
			}
		}
	
	}
}