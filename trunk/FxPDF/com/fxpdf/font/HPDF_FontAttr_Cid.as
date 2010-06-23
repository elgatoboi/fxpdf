package com.fxpdf.font
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_ParseText;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.types.enum.HPDF_ByteType;
	import com.fxpdf.types.enum.HPDF_FontDefType;

	public class HPDF_FontAttr_Cid extends HPDF_FontAttr
	{
		public function HPDF_FontAttr_Cid()
		{
			super();
			
		}
		override public function textWidthFn(font:HPDF_Font, text:String, len:uint):HPDF_TextWidth
		{
			var tw			: HPDF_TextWidth = new HPDF_TextWidth();
			var attr		: HPDF_FontAttr  = font.attr as HPDF_FontAttr;
			var parseState	: HPDF_ParseText; 
			var encoder		: HPDF_Encoder = attr.encoder;
			var w 			: uint;
			var cid			: uint; 
			var dw2			: int ; 
			var b			: uint; 
			
			trace (" HPDF_Type0Font_TextWidth");
			
			if (attr.fontdef.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID) {
				var cidFontdefAttr	: HPDF_CIDFontDefAttr = attr.fontdef.attr as HPDF_CIDFontDefAttr;
				dw2		= cidFontdefAttr.DW2[1];
			} else {
				dw2 = attr.fontdef.fontBBox.bottom -	attr.fontdef.fontBBox.top;
			}
			
			/** MOdified AS3 code **/
			for ( var i : int = 0; i < text.length ; i++ ) {
				var ch : uint = text.charCodeAt(i);
				if (attr.fontdef.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID) {
					/* cid-based font */
					cid = encoder.HPDF_CMapEncoder_ToCID ( ch);
					var cidFontDef:HPDF_CIDFontDef = attr.fontdef as HPDF_CIDFontDef;
					w = cidFontDef.HPDF_CIDFontDef_GetCIDWidth ( cid);
				} 
				else {
				/* unicode-based font */
					/*unicode = HPDF_CMapEncoder_ToUnicode (encoder, code);
					w = HPDF_TTFontDef_GetCharWidth (attr->fontdef, unicode);
					*/
					throw new HPDF_Error("Not supported - FA-51");
				}
				tw.width += w; 
				
			
			}
			
			
			
			/** End of AS3 mod **/
			
			/*var tmpLen: Number;
			encoder.HPDF_Encoder_SetParseText (  parseState, text, len);
			
			while (i < len) {
				//HPDF_ByteType btype = HPDF_CMapEncoder_ByteType (encoder, &parse_state);
				var btype : uint	= encoder.HPDF_CMapEncoder_ByteType( parseState );
				var cid		: uint;
				var unicode	: uint;
				var code	: uint; 
				var w		: uint = 0;
				
			/*b = *text++;
				code = b;
				
				if (btype == HPDF_BYTE_TYPE_LEAD) {
					code <<= 8;
					code += *text;
				}
				
				if (btype != HPDF_BYTE_TYPE_TRIAL) {
					if (attr->writing_mode == HPDF_WMODE_HORIZONTAL) {
						if (attr->fontdef->type == HPDF_FONTDEF_TYPE_CID) {
							/* cid-based font */
							/*cid = HPDF_CMapEncoder_ToCID (encoder, code);
							w = HPDF_CIDFontDef_GetCIDWidth (attr->fontdef, cid);
						} else {
							/* unicode-based font */
							/*unicode = HPDF_CMapEncoder_ToUnicode (encoder, code);
							w = HPDF_TTFontDef_GetCharWidth (attr->fontdef, unicode);
						}
					} else {
						w = -dw2;
					}
					
					tw.numchars++;
				}
				
				if (HPDF_IS_WHITE_SPACE(code)) {
					tw.numwords++;
					tw.numspace++;
				}
				*/
			/*	tw.width += w;
				i++;
			}
			*/
			
			/* 2006.08.19 add. */
			if ( HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
				; /* do nothing. */
			else
				tw.numwords++;
			
			return tw;
		}
		
		
		override public function measureTextFn(font:HPDF_Font, text:String, len:uint, width:Number, fontSize:Number, charSpace:Number, wordSpace:Number, wordwrap:Boolean, realWidth:C_NumberPointer):Number
		{
			var w		: Number = 0;
			var tmpLen	: uint = 0;
			var i 		: uint ; 
			var attr	: HPDF_FontAttr = font.attr as HPDF_FontAttr;
			
			return textWidthFn( font, text, len ).width;
			
			/*HPDF_REAL w = 0;
			HPDF_UINT tmp_len = 0;
			HPDF_UINT i;
			HPDF_FontAttr attr = (HPDF_FontAttr)font->attr;
			HPDF_ByteType last_btype = HPDF_BYTE_TYPE_TRIAL;
			HPDF_Encoder encoder = attr->encoder;
			HPDF_ParseText_Rec  parse_state;
			HPDF_INT dw2;
			
			HPDF_PTRACE ((" HPDF_Type0Font_MeasureText\n"));*/
			
		/*	if (attr.fontdef.type == HPDF_FONTDEF_TYPE_CID) {
				HPDF_CIDFontDefAttr cid_fontdef_attr =
					(HPDF_CIDFontDefAttr)attr->fontdef->attr;
				dw2 = cid_fontdef_attr->DW2[1];
			} else {
				dw2 = attr->fontdef->font_bbox.bottom -
					attr->fontdef->font_bbox.top;
			}
			
			HPDF_Encoder_SetParseText (encoder, &parse_state, text, len);
			
			for (i = 0; i < len; i++) {
				HPDF_BYTE b = *text++;
				HPDF_BYTE b2 = *text;  /* next byte */
			/*	HPDF_ByteType btype = HPDF_Encoder_ByteType (encoder, &parse_state);
				HPDF_UNICODE unicode;
				HPDF_UINT16 code = b;
				HPDF_UINT16 tmp_w = 0;
				
				if (btype == HPDF_BYTE_TYPE_LEAD) {
					code <<= 8;
					code += b2;
				}
				
				if (!wordwrap) {
					if (HPDF_IS_WHITE_SPACE(b)) {
						tmp_len = i + 1;
						if (real_width)
						*real_width = w;
					} else if (btype == HPDF_BYTE_TYPE_SINGLE ||
						btype == HPDF_BYTE_TYPE_LEAD) {
						tmp_len = i;
						if (real_width)
						*real_width = w;
					}
				} else {
					if (HPDF_IS_WHITE_SPACE(b)) {
						tmp_len = i + 1;
						if (real_width)
						*real_width = w;
					} else
						if (last_btype == HPDF_BYTE_TYPE_TRIAL ||
							(btype == HPDF_BYTE_TYPE_LEAD &&
								last_btype == HPDF_BYTE_TYPE_SINGLE)) {
							if (!HPDF_Encoder_CheckJWWLineHead(encoder, code)) {
								tmp_len = i;
								if (real_width)
								*real_width = w;
							}
						}
				}
				
				if (HPDF_IS_WHITE_SPACE(b)) {
					w += word_space;
				}
				
				if (btype != HPDF_BYTE_TYPE_TRIAL) {
					if (attr->writing_mode == HPDF_WMODE_HORIZONTAL) {
						if (attr->fontdef->type == HPDF_FONTDEF_TYPE_CID) {
							/* cid-based font */
						/*	HPDF_UINT16 cid = HPDF_CMapEncoder_ToCID (encoder, code);
							tmp_w = HPDF_CIDFontDef_GetCIDWidth (attr->fontdef, cid);
						} else {
							/* unicode-based font */
							/*unicode = HPDF_CMapEncoder_ToUnicode (encoder, code);
							tmp_w = HPDF_TTFontDef_GetCharWidth (attr->fontdef,
								unicode);
						}
					} else {
						tmp_w = -dw2;
					}
					
					if (i > 0)
						w += char_space;
				}
				
				w += (HPDF_DOUBLE)tmp_w * font_size / 1000;
				
				/* 2006.08.04 break when it encountered  line feed */
			/*	if (w > width || b == 0x0A)
					return tmp_len;
				
				if (HPDF_IS_WHITE_SPACE(b))
					last_btype = HPDF_BYTE_TYPE_TRIAL;
				else
					last_btype = btype;
			}
			*/
			/* all of text can be put in the specified width */
			/*if (real_width)
			*real_width = w;
			
			return len;
			*/
			return null; 
		}
	}
}