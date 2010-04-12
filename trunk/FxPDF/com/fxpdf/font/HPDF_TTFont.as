/*
Copyright 2010 FxPDF.com

FxPDF is based on libHaru code originally developed & maintained by Takeshi Kanno (libHaru.org). 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.fxpdf.font
{
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_BasicEncoderAttr;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.ttf.HPDF_FontAttrTTF;
	import com.fxpdf.font.ttf.HPDF_FontDef_TT;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_TTFont extends HPDF_Font
	{
		public function HPDF_TTFont(fontdef: HPDF_FontDef , encoder : HPDF_Encoder, xref : HPDF_Xref) 
		{
			super( fontdef, encoder, xref );
			
			
			if (encoder.type != HPDF_EncoderType.HPDF_ENCODER_TYPE_SINGLE_BYTE)
			{
					throw new HPDF_Error( "HPDF_TTFont",HPDF_Error.HPDF_INVALID_ENCODER_TYPE, 0);
			}
			if (fontdef.type != HPDF_FontDefType.HPDF_FONTDEF_TYPE_TRUETYPE)
			{
					throw new HPDF_Error( "HPDF_TTFont",HPDF_Error.HPDF_INVALID_FONTDEF_TYPE, 0);
			}
        	
    		var	attr	: HPDF_FontAttrTTF 	= new HPDF_FontAttrTTF(); 
    		this.attr	=	attr;
    		
    		
 			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_FONT;
		    /*font.write_fn = OnWrite;
		    font.before_write_fn = BeforeWrite;
		    font.free_fn = OnFree;
		    */
		    
		    attr.type 			= HPDF_FontType.HPDF_FONT_TRUETYPE;
		    attr.writingMode	= HPDF_WritingMode.HPDF_WMODE_HORIZONTAL;
		    /*attr.textWidth_fn = TextWidth;
		    attr.measure_text_fn = MeasureText;
		    */
		    attr.fontdef = fontdef;
		    attr.encoder = encoder;
		    attr.xref = xref;
    
   			/* TODO attr.widths = HPDF_GetMem (mmgr, sizeof(HPDF_INT16) * 256);
  	
		    attr.used = HPDF_GetMem (mmgr, sizeof(HPDF_BYTE) * 256);
		    if (!attr.used) {
		        HPDF_Dict_Free (font);
		        return NULL;
		    }*/
		    //attr.used =	new		
		
		    //HPDF_MemSet (attr.used, 0, sizeof(HPDF_BYTE) * 256);
		    attr.widths	=	new Vector.<uint>;
		    attr.used	=	new Vector.<uint>; 
		    for ( var i : int = 0; i < 256 ; i++ ) 
		    {
		    	attr.widths.push(0);
		    	attr.used.push( 0 );
		    }
		
		    var fontdefAttr : HPDF_TTFontDefAttr = fontdef.attr as HPDF_TTFontDefAttr;

		    HPDF_Dict_AddName ("Type", "Font");
		    HPDF_Dict_AddName ("BaseFont", fontdefAttr.baseFont);
		    HPDF_Dict_AddName ("Subtype", "TrueType");
		
		    var  encoderAttr : HPDF_BasicEncoderAttr = encoder.attr as HPDF_BasicEncoderAttr;
		
		    HPDF_Dict_AddNumber ( "FirstChar", encoderAttr.firstChar);
		    HPDF_Dict_AddNumber ( "LastChar", encoderAttr.lastChar);
		    if (fontdef.missingWidth != 0)
		        HPDF_Dict_AddNumber ( "MissingWidth", fontdef.missingWidth);
		
		
		    xref.HPDF_Xref_Add (this);
			
		}
		
		override public	function	beforeWriteFn( ) : void
		{
			trace (" HPDF_TTFont_BeforeWrite");
   			CreateDescriptor ( ); 
		}
		
		public	function	CreateDescriptor  ( ) : void
		{
			var fontAttr : HPDF_FontAttr	=	this.attr as HPDF_FontAttr ;
			var	def	: HPDF_FontDef	=	fontAttr.fontdef ; 
			
			var	defAttr	: HPDF_TTFontDefAttr	=	def.attr	as HPDF_TTFontDefAttr;
		
    		trace (" HPDF_TTFont_CreateDescriptor");

		    if (!fontAttr.fontdef.descriptor)
		    {
		        var	descriptor : HPDF_Dict	=	new HPDF_Dict( )  ;
		        var	array : HPDF_Array		=	new HPDF_Array( ) ; 
		        
		        fontAttr.xref.HPDF_Xref_Add( descriptor );
		        descriptor.HPDF_Dict_AddName ( "Type", "FontDescriptor");
		        descriptor.HPDF_Dict_AddNumber ( "Ascent", def.ascent);
		        descriptor.HPDF_Dict_AddNumber ( "Descent", def.descent);
		        descriptor.HPDF_Dict_AddNumber ( "Flags", def.flags);
				
				
		        array = HPDF_Array.HPDF_Box_Array_New( def.fontBBox);
		        descriptor.HPDF_Dict_Add ( "FontBBox", array);
		
		        descriptor.HPDF_Dict_AddName ( "FontName", defAttr.baseFont);
		        descriptor.HPDF_Dict_AddNumber ( "ItalicAngle", def.italicAngle);
		        descriptor.HPDF_Dict_AddNumber ( "StemV", def.stemv);
		        descriptor.HPDF_Dict_AddNumber ( "XHeight", def.xHeight);
		
		        if (defAttr.charSet)
		            descriptor.HPDF_Dict_AddName ( "CharSet", defAttr.charSet);
		
		        if (defAttr.embedding)
		        {
		            var	fontData : HPDF_Dict	=	HPDF_Dict.HPDF_DictStream_New ( fontAttr.xref );
		            
		            (fontAttr.fontdef as HPDF_FontDef_TT).HPDF_TTFontDef_SaveFontData ( fontData.stream );

		            descriptor.HPDF_Dict_Add ("FontFile2", fontData);
		            fontData..HPDF_Dict_AddNumber ( "Length1", defAttr.length1);
		            fontData.HPDF_Dict_AddNumber ("Length2", 0);
		            fontData.HPDF_Dict_AddNumber ("Length3", 0);
		            fontData.filter = filter;
		        }
		
		        
		        fontAttr.fontdef.descriptor = descriptor;
		    }
		
		    HPDF_Dict_Add ( "FontDescriptor", fontAttr.fontdef.descriptor);
		}
		
		public	function	  CharWidth( code : uint ) : int 
		{
			var	attr : HPDF_FontAttr	=	this.attr	as HPDF_FontAttr;
			if (attr.used[code] == 0 )
			{
				var unicode : uint	=	attr.encoder.HPDF_Encoder_ToUnicode( code );
				attr.used [ code ] = 1;
				attr.widths [ code ] = ( attr.fontdef as HPDF_FontDef_TT).HPDF_TTFontDef_GetCharWidth( unicode );
			}
			return attr.widths [ code ] ;
		}

	}
}