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
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.encoder.HPDF_CMapEncoder;
	import com.fxpdf.encoder.HPDF_CMapEncoderAttr;
	import com.fxpdf.encoder.HPDF_CidRange_Rec;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	
	import mx.messaging.config.ConfigMap;
	
	public class HPDF_Type0Font extends HPDF_Font
	{
		public function HPDF_Type0Font(fontdef: HPDF_FontDef , encoder : HPDF_Encoder, xref : HPDF_Xref)
		{
			
			var attr				: HPDF_FontAttr;
			var encoderAttr			: HPDF_CMapEncoderAttr;
			
			var descendantFonts		: HPDF_Array;
			
			
			super( fontdef, encoder, xref ) ;
			
			
			trace (" HPDF_Type0Font_New");
			
			this.header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_FONT;
			
			/* check whether the fontdef object and the encoder object is valid. */
			if ( encoder.type != HPDF_EncoderType.HPDF_ENCODER_TYPE_DOUBLE_BYTE) {
				throw new HPDF_Error("HPDF_Type0Font", HPDF_Error.HPDF_INVALID_ENCODER_TYPE,0 );
			}
			
			if (fontdef.type != HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID &&
				fontdef.type != HPDF_FontDefType.HPDF_FONTDEF_TYPE_TRUETYPE) {
				throw new HPDF_Error("HPDF_Type0Font",HPDF_Error.HPDF_INVALID_FONTDEF_TYPE,0 );
			}
			
			
			attr = new HPDF_FontAttr_Cid();
			this.header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_FONT;
			this.attr	= attr;
			
			encoderAttr	= encoder.attr as  HPDF_CMapEncoderAttr ;
			
			attr.writingMode	= encoderAttr.writingMode;
			
			attr.fontdef = fontdef;
			attr.encoder = encoder;
			attr.xref = xref;
			
			xref.HPDF_Xref_Add( this );
			
			this.HPDF_Dict_AddName ( "Type", "Font");
			this.HPDF_Dict_AddName ( "BaseFont", fontdef.baseFont);
			this.HPDF_Dict_AddName ( "Subtype", "Type0");
			
			if (fontdef.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID) {
				this.HPDF_Dict_AddName ( "Encoding", encoder.name);
			} else {
				attr.cmapStream = CreateCMAP (encoder, xref);
				
				if (attr.cmapStream) {
					this.HPDF_Dict_Add ( "Encoding", attr.cmapStream);
				}
			}
			
			
			descendantFonts = new HPDF_Array();
			
			
			this.HPDF_Dict_Add ( "DescendantFonts", descendantFonts);
			
			if (fontdef.type == HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID) {
				attr.descendantFont = CIDFontType0_New (this, xref);
				attr.type = HPDF_FontType.HPDF_FONT_TYPE0_CID;
			} else {
				attr.descendantFont = CIDFontType2_New (this, xref);
				attr.type = HPDF_FontType.HPDF_FONT_TYPE0_TT;
			}
			
			if (!attr.descendantFont)
				throw new HPDF_Error("descendantFont Eror");
			else
				descendantFonts.HPDF_Array_Add (attr.descendantFont);
			
		}
		
		
		private function CreateCMAP( encoder : HPDF_Encoder, xref : HPDF_Xref) : HPDF_Dict
		{
			var cmap				: HPDF_DictStream = new HPDF_DictStream( xref );
			var attr				: HPDF_CMapEncoderAttr = encoder.attr as HPDF_CMapEncoderAttr;
			var buf				: String;
			var i 				: int; 
			var phase			: uint; 
			var odd				: uint;
			var sysinfo			: HPDF_Dict;
			var range 			: HPDF_CidRange_Rec
			
			var rn			: String = HPDF_Utils.NEW_LINE;
			
			cmap.HPDF_Dict_AddName ( "Type", "CMap");
			cmap.HPDF_Dict_AddName ( "CMapName", encoder.name);
			
			sysinfo = new HPDF_Dict();
			
			cmap.HPDF_Dict_Add ( "CIDSystemInfo", sysinfo);
			
			sysinfo.HPDF_Dict_Add ( "Registry", new HPDF_String ( attr.registry, null));
			sysinfo.HPDF_Dict_Add ( "Ordering", new HPDF_String (	attr.ordering, null));
			sysinfo.HPDF_Dict_AddNumber ( "Supplement", attr.suppliment);
			cmap.HPDF_Dict_AddNumber ( "WMode", attr.writingMode);
			
			/* create cmap data from encoding data */
			cmap.stream.HPDF_Stream_WriteStr ("%!PS-Adobe-3.0 Resource-CMap" + rn);
			cmap.stream.HPDF_Stream_WriteStr ("%%DocumentNeededResources: ProcSet (CIDInit)"+ rn);
			cmap.stream.HPDF_Stream_WriteStr ("%%IncludeResource: ProcSet (CIDInit)"+ rn);
			
			/* C pbuf = HPDF_StrCpy (buf, "%%BeginResource: CMap (", eptr);
			pbuf = HPDF_StrCpy (pbuf, encoder->name, eptr);
			HPDF_StrCpy (pbuf, ")\r\n", eptr);
			*/
			buf = "%%BeginResource: CMap (" + encoder.name + ")" + rn ;
			cmap.stream.HPDF_Stream_WriteStr (buf);
			
			/* C pbuf = HPDF_StrCpy (buf, "%%Title: (", eptr);
			pbuf = HPDF_StrCpy (pbuf, encoder->name, eptr);
			*pbuf++ = ' ';
			pbuf = HPDF_StrCpy (pbuf, attr->registry, eptr);
			*pbuf++ = ' ';
			pbuf = HPDF_StrCpy (pbuf, attr->ordering, eptr);
			*pbuf++ = ' ';
			pbuf = HPDF_IToA (pbuf, attr->suppliment, eptr);
			HPDF_StrCpy (pbuf, ")\r\n", eptr);
			*/ 
			buf = "%%Title: (" + encoder.name + " " + attr.registry + " " + attr.ordering + " " + attr.suppliment + ")" + rn ;
				
			cmap.stream.HPDF_Stream_WriteStr (buf);
			
			cmap.stream.HPDF_Stream_WriteStr ( "%%Version: 1.0" + rn);
			cmap.stream.HPDF_Stream_WriteStr ( "%%EndComments" + rn);
			
			cmap.stream.HPDF_Stream_WriteStr ("/CIDInit /ProcSet findresource begin" + rn  + rn);
			
			/* Adobe CMap and CIDFont Files Specification recommends to allocate
			* five more elements to this dictionary than existing elements.
			*/
			cmap.stream.HPDF_Stream_WriteStr ( "12 dict begin" + rn + rn );
			
			cmap.stream.HPDF_Stream_WriteStr ( "begincmap" + rn + rn);
			cmap.stream.HPDF_Stream_WriteStr ( "/CIDSystemInfo 3 dict dup begin" + rn);
			
			/*pbuf = HPDF_StrCpy (buf, "  /Registry (", eptr);
			pbuf = HPDF_StrCpy (pbuf, attr->registry, eptr);
			HPDF_StrCpy (pbuf, ") def\r\n", eptr);
			*/
			buf = "  /Registry (" + attr.registry + ") def" + rn +rn;
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			/*pbuf = HPDF_StrCpy (buf, "  /Ordering (", eptr);
			pbuf = HPDF_StrCpy (pbuf, attr->ordering, eptr);
			HPDF_StrCpy (pbuf, ") def\r\n", eptr);
			*/
			buf = "  /Ordering (" + attr.ordering + ") def" + rn;
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			/*pbuf = HPDF_StrCpy (buf, "  /Supplement ", eptr)
			pbuf = HPDF_IToA (pbuf, attr->suppliment, eptr);
			pbuf = HPDF_StrCpy (pbuf, " def\r\n", eptr);
			HPDF_StrCpy (pbuf, "end def\r\n\r\n", eptr);
			*/
			buf = "  /Supplement " + attr.suppliment + " def" + rn + "end def" + rn + rn;
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			
			/*pbuf = HPDF_StrCpy (buf, "/CMapName /", eptr);
			pbuf = HPDF_StrCpy (pbuf, encoder->name, eptr);
			HPDF_StrCpy (pbuf, " def\r\n", eptr);
			*/
			buf = "/CMapName /" + encoder.name + " def" + rn ;
			
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			cmap.stream.HPDF_Stream_WriteStr ( "/CMapVersion 1.0 def" + rn);
			cmap.stream.HPDF_Stream_WriteStr ( "/CMapType 1 def" + rn + rn);
			
			if (attr.uidOffset >= 0) {
				/*pbuf = HPDF_StrCpy (buf, "/UIDOffset ", eptr);
				pbuf = HPDF_IToA (pbuf, attr->uid_offset, eptr);
				HPDF_StrCpy (pbuf, " def\r\n\r\n", eptr);
				*/
				buf = "/UIDOffset " + attr.uidOffset + " def" + rn+ rn;
				cmap.stream.HPDF_Stream_WriteStr ( buf );
			}
			
			/*pbuf = HPDF_StrCpy (buf, "/XUID [", eptr);
			pbuf = HPDF_IToA (pbuf, attr->xuid[0], eptr);
			*pbuf++ = ' ';
			pbuf = HPDF_IToA (pbuf, attr->xuid[1], eptr);
			*pbuf++ = ' ';
			pbuf = HPDF_IToA (pbuf, attr->xuid[2], eptr);
			HPDF_StrCpy (pbuf, "] def\r\n\r\n", eptr);
			*/
			buf = "/XUID [" + attr.xuid[0].toString() + " " + attr.xuid[1] + " " + attr.xuid[2] + "] def" + rn + rn ; 
			cmap.stream.HPDF_Stream_WriteStr ( buf );
			
			/*pbuf = HPDF_StrCpy (buf, "/WMode ", eptr);
			pbuf = HPDF_IToA (pbuf, (HPDF_UINT32)attr->writing_mode, eptr);
			HPDF_StrCpy (pbuf, " def\r\n\r\n", eptr);*/
			buf = "/WMode " + attr.writingMode + " def" + rn+ rn; 
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			/* add code-space-range */
			/*pbuf = HPDF_IToA (buf, attr->code_space_range->count, eptr);
			HPDF_StrCpy (pbuf, " begincodespacerange\r\n", eptr);*/
			buf = attr.codeSpaceRange.count.toString() +  " begincodespacerange" +  rn ;
			
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			for (i = 0; i < attr.codeSpaceRange.count; i++) 
			{
				
				range = attr.codeSpaceRange.HPDF_List_ItemAt( i ) as HPDF_CidRange_Rec;
				
				
				/*pbuf = UINT16ToHex (buf, range->from, eptr);
				*pbuf++ = ' ';
				pbuf = UINT16ToHex (pbuf, range->to, eptr);
				HPDF_StrCpy (pbuf, "\r\n", eptr);
				*/
				buf = range.from.toString(16) + " " + range.to_.toString(16) + rn;
				
				cmap.stream.HPDF_Stream_WriteStr ( buf);
				
			}
			
			// HPDF_StrCpy (buf, "endcodespacerange\r\n\r\n", eptr);
			cmap.stream.HPDF_Stream_WriteStr ("endcodespacerange" + rn + rn);
			
			/* add not-def-range */
			/*pbuf = HPDF_IToA (buf, attr->notdef_range->count, eptr);
			HPDF_StrCpy (pbuf, " beginnotdefrange\r\n", eptr);*/
			buf = attr.notdefRange.count.toString() + " beginnotdefrange" + rn ;
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			for (i = 0; i < attr.notdefRange.count; i++) {
				
				range = attr.notdefRange.HPDF_List_ItemAt( i ) as HPDF_CidRange_Rec;
				
				/*pbuf = UINT16ToHex (buf, range->from, eptr);
				*pbuf++ = ' ';
				pbuf = UINT16ToHex (pbuf, range->to, eptr);
				*pbuf++ = ' ';
				pbuf = HPDF_IToA (pbuf, range->cid, eptr);
				HPDF_StrCpy (pbuf, "\r\n", eptr); */
				buf = range.from.toString(16) + " "+ range.to_.toString(16) + " " + range.cid.toString(16) + rn; 
				cmap.stream.HPDF_Stream_WriteStr (buf);
			}
			
			cmap.stream.HPDF_Stream_WriteStr ("endnotdefrange"+rn+ rn);
			
			/* add cid-range */
			//phase = attr->cmap_range->count / 100; 
			phase = attr.cmapRange.count / 100;
			//odd = attr->cmap_range->count % 100; 
			odd = attr.cmapRange.count % 100; 
			
			if (phase > 0)
				buf = HPDF_Utils.HPDF_IToA(100 ); 
			else
				buf = HPDF_Utils.HPDF_IToA(odd );
			buf += " begincidrange" + rn ; 
			
			cmap.stream.HPDF_Stream_WriteStr (buf);
			
			for (i = 0; i < attr.cmapRange.count; i++) {
				
				//HPDF_CidRange_Rec *range = HPDF_List_ItemAt (attr->cmap_range, i);
				range = attr.cmapRange.HPDF_List_ItemAt( i ) as HPDF_CidRange_Rec;
				
				/*pbuf = UINT16ToHex (buf, range->from, eptr);
				*pbuf++ = ' ';
				pbuf = UINT16ToHex (pbuf, range->to, eptr);
				*pbuf++ = ' ';
				pbuf = HPDF_IToA (pbuf, range->cid, eptr);
				HPDF_StrCpy (pbuf, "\r\n", eptr); */
				
				buf = range.from.toString(16) + " "+ range.to_.toString(16) + " " + range.cid.toString(16) + rn; 
				cmap.stream.HPDF_Stream_WriteStr (buf);
				
				//cmap.stream.HPDF_Stream_WriteStr (cmap->stream, buf);
				
				if ((i + 1) %100 == 0) {
					phase--;
					//pbuf = HPDF_StrCpy (buf, "endcidrange\r\n\r\n", eptr);
					buf = "endcidrange" + rn + rn; 
					
					if (phase > 0)
						//pbuf = HPDF_IToA (pbuf, 100, eptr);
						buf += HPDF_Utils.HPDF_IToA(100);
					else
						//pbuf = HPDF_IToA (pbuf, odd, eptr);
						buf += HPDF_Utils.HPDF_IToA(odd);
					
					//HPDF_StrCpy (pbuf, " begincidrange\r\n", eptr);
					buf += " begincidrange" + rn ; 
					
					cmap.stream.HPDF_Stream_WriteStr (buf);
				}
				
			}
			
			if (odd > 0)
				//pbuf = HPDF_StrCpy (buf, "endcidrange\r\n", eptr);
				buf = "endcidrange" + rn ; 
			
			/*pbuf = HPDF_StrCpy (pbuf, "endcmap\r\n", eptr);
			pbuf = HPDF_StrCpy (pbuf, "CMapName currentdict /CMap "
				"defineresource pop\r\n", eptr);
			pbuf = HPDF_StrCpy (pbuf, "end\r\n", eptr);
			pbuf = HPDF_StrCpy (pbuf, "end\r\n\r\n", eptr);
			pbuf = HPDF_StrCpy (pbuf, "%%EndResource\r\n", eptr);
			HPDF_StrCpy (pbuf, "%%EOF\r\n", eptr);
			*/
			buf += "endcmap"+ rn;
			buf += "CMapName currentdict /CMap " +  "defineresource pop" + rn; 
			buf += "end" + rn;
			buf += "end" + rn + rn;
			buf += "%%EndResource" + rn + "%%EOF"+ rn; 
			cmap.stream.HPDF_Stream_WriteStr ( buf);
			
			return cmap;
		}

	
	/** ******************/
	private function 	CIDFontType0_New (parent : HPDF_Font, xref : HPDF_Xref ) : HPDF_Dict
	{
		var attr				: HPDF_FontAttr  = parent.attr as HPDF_FontAttr;
		var fontdef				: HPDF_FontDef = attr.fontdef;
		
		var fontdefAttr			: HPDF_CIDFontDefAttr = fontdef.attr as HPDF_CIDFontDefAttr;
		var encoder				: HPDF_Encoder = attr.encoder; 
		var encoderAttr			: HPDF_CMapEncoderAttr = encoder.attr as HPDF_CMapEncoderAttr;
		
		var saveCid				: uint = 0; 
		var font				: HPDF_Dict;
		var array				: HPDF_Array;
		var subArray			: HPDF_Array;
		var i					: uint;
		
		var descriptor			: HPDF_Dict;
		var cidSystemInfo		: HPDF_Dict;
		
		trace (" HPDF_CIDFontType0_New");
		
		font =  new HPDF_Dict();
		xref.HPDF_Xref_Add( font );
		
		
		font.HPDF_Dict_AddName ( "Type", "Font");
		font.HPDF_Dict_AddName ( "Subtype", "CIDFontType0");
		font.HPDF_Dict_AddNumber ( "DW", fontdefAttr.DW);
		font.HPDF_Dict_AddName ( "BaseFont", fontdef.baseFont);
		
		/* add 'DW2' element */
		array = new HPDF_Array();
		
		font.HPDF_Dict_Add ("DW2", array);
		
		array.HPDF_Array_AddNumber ( fontdefAttr.DW2[0]);
		array.HPDF_Array_AddNumber ( fontdefAttr.DW2[1]);
		
		/* add 'W' element */
		array = new HPDF_Array();
		
		font.HPDF_Dict_Add ( "W", array) ;
		
		/* Create W array. */
		for (i = 0; i< fontdefAttr.widths.count; i++) {
			/*HPDF_CID_Width *w =
				(HPDF_CID_Width *)HPDF_List_ItemAt (fontdef_attr->widths, i);
			*/
			var w : HPDF_CID_Width  = fontdefAttr.widths.HPDF_List_ItemAt( i ) as HPDF_CID_Width;
			
			if (w.cid != saveCid + 1 || !subArray) {
				//sub_array = HPDF_Array_New (parent->mmgr);
				subArray = new HPDF_Array();
				
				array.HPDF_Array_AddNumber ( w.cid);
				array.HPDF_Array_Add ( subArray);
			}
			
			//ret += HPDF_Array_AddNumber (sub_array, w->width);
			subArray.HPDF_Array_AddReal( w.width );
			
			saveCid = w.cid;
			
		}
		
		/* create descriptor */
		descriptor = new HPDF_Dict();
		
		xref.HPDF_Xref_Add( descriptor );
			 
		font.HPDF_Dict_Add( "FontDescriptor", descriptor ) ;
		
		descriptor.HPDF_Dict_AddName ( "Type", "FontDescriptor");
		descriptor.HPDF_Dict_AddName ("FontName", fontdef.baseFont);
		descriptor.HPDF_Dict_AddNumber ( "Ascent", fontdef.ascent);
		descriptor.HPDF_Dict_AddNumber ( "Descent", fontdef.descent);
		descriptor.HPDF_Dict_AddNumber ( "CapHeight",	fontdef.capHeight);
		descriptor.HPDF_Dict_AddNumber ( "MissingWidth",fontdef.missingWidth);
		descriptor.HPDF_Dict_AddNumber ( "Flags", fontdef.flags);
		
		array = HPDF_Array.HPDF_Box_Array_New( fontdef.fontBBox );
		
		
		descriptor.HPDF_Dict_Add ( "FontBBox", array);
		descriptor.HPDF_Dict_AddNumber ("ItalicAngle",	fontdef.italicAngle);
		descriptor.HPDF_Dict_AddNumber ("StemV", fontdef.stemv);
		
		/* create CIDSystemInfo dictionary */
		cidSystemInfo = new HPDF_Dict();
		
		font.HPDF_Dict_Add ( "CIDSystemInfo", cidSystemInfo);
		
		cidSystemInfo.HPDF_Dict_Add ( "Registry",new HPDF_String(  encoderAttr.registry, null) );
		cidSystemInfo.HPDF_Dict_Add ( "Ordering",	new HPDF_String( encoderAttr.ordering, null));
		cidSystemInfo.HPDF_Dict_AddNumber ( "Supplement", encoderAttr.suppliment);
		
		return font ;
	}
	
	
	
	
	private function 	CIDFontType2_New (parent : HPDF_Font, xref : HPDF_Xref ) : HPDF_Dict
	{
		var attr			: HPDF_FontAttr 		= parent.attr as HPDF_FontAttr;
		var fontdef			: HPDF_FontDef			= attr.fontdef;
		var fontdefAttr		: HPDF_TTFontDefAttr	= fontdef.attr as HPDF_TTFontDefAttr;
		var encoder			: HPDF_Encoder			= attr.encoder;
		var encoderAttr		: HPDF_CMapEncoderAttr	= encoder.attr as HPDF_CMapEncoderAttr;
		
		var font			: HPDF_Dict;
		var array			: HPDF_Array;
		var i 				: int;
		var tmpMap			: Vector.<uint> = new Vector.<uint>[65536]; // HPDF_UNICODE tmp_map[65536];
		var cidSystemInfo	: HPDF_Dict;
		var max				: uint = 0;
		var gid				: uint ;
		
		trace (" HPDF_CIDFontType2_New");
		
		font = 	new HPDF_Dict();
		
		xref.HPDF_Xref_Add( font );
		
		// TODO  parent->before_write_fn = CIDFontType2_BeforeWrite_Func;  ??
		
		font.HPDF_Dict_AddName ( "Type", "Font");
		font.HPDF_Dict_AddName ( "Subtype", "CIDFontType2");
		font.HPDF_Dict_AddNumber ( "DW", fontdef.missingWidth);
		
		
		/* add 'DW2' element */
		array = new HPDF_Array();
		
		font.HPDF_Dict_Add ( "DW2", array);
		
		array.HPDF_Array_AddNumber ( fontdef.fontBBox.bottom);
		array.HPDF_Array_AddNumber ( fontdef.fontBBox.bottom - fontdef.fontBBox.top );
		
		for ( var jj : int = 0 ; jj < 65536 ; jj++ ) 
			tmpMap[jj] = 0;
		
		for (i = 0; i < 256; i++) {
			var j : uint ; 
			
			for (j = 0; j < 256; j++) {
				var cid	: uint	= encoderAttr.cidMap[i][j];
				if (cid != 0) {
					//HPDF_UNICODE unicode = encoder_attr->unicode_map[i][j];
					var unicode	: uint = encoderAttr.unicodeMap[i][j];
					
					//HPDF_UINT16 gid = HPDF_TTFontDef_GetGlyphid (fontdef, unicode);
					gid = 0; // TODO fontdefAttr.HPDF_TTFontDef_GetGlyphid( unicode );
					
					tmpMap[cid] = gid; 
					if (max < cid)
						max = cid;
				}
			}
		}
		
		if (max > 0) {
			var dw			: int = fontdef.missingWidth;
			var tmpArrat	: HPDF_Array = null; 
			
			//HPDF_UNICODE *ptmp_map = tmp_map;
			var ptmpMap		: uint ; 
			var tmpArray	: HPDF_Array = null;
			
			
			
			/* add 'W' element */
			array = new HPDF_Array();
			
			
			font.HPDF_Dict_Add ("W", array);
			
			for (i = 0; i < max; i++ ) {
				ptmpMap = tmpMap[i];
				var w : int 	= fontdef.HPDF_TTFontDef_GetGidWidth( ptmpMap ); /// ???
				// C HPDF_INT w = HPDF_TTFontDef_GetGidWidth (fontdef, *ptmp_map);
				
				if (w != dw) {
					if (!tmpArray) {
						array.HPDF_Array_AddNumber (i);
						tmpArray = new HPDF_Array();
						
						array.HPDF_Array_Add ( tmpArray)
					}
					
					tmpArray.HPDF_Array_AddNumber ( w );
				} else
					tmpArray = null;
			}
			
			/* create "CIDToGIDMap" data */
			if (fontdefAttr.embedding) {
				attr.mapStream	=	 new HPDF_DictStream( xref );
				
				font.HPDF_Dict_Add ( "CIDToGIDMap", attr.mapStream);
				
				for (i = 0; i < max; i++) {
					//var u		: Vector.<uint> = new Vector.<uint>[2];
					var u : uint ; 
					gid = tmpMap[i];
					
					u = gid >> 8 & gid;
					//u[0] = gid >> 7
					//u[1] = gid;
					
					// ?? HPDF_MemCpy ((HPDF_BYTE *)(tmp_map + i), u, 2);
					tmpMap[i] = u ; 
				}
				
				var ba : ByteArray = new ByteArray();
				ba = HPDF_Utils.VectorUintToByteArray( tmpMap );
				//attr.mapStream.stream.HPDF_Stream_Write ((HPDF_BYTE *)tmp_map, max * 2)) != HPDF_OK)
				attr.mapStream.stream.HPDF_Stream_Write( ba ) ;
			}
		} else {
			throw new HPDF_Error("CIDFontType02_New", HPDF_Error.HPDF_INVALID_FONTDEF_DATA, 0 );
		}
		
		/* create CIDSystemInfo dictionary */
		cidSystemInfo 	= new HPDF_Dict();
		
		font.HPDF_Dict_Add ( "CIDSystemInfo", cidSystemInfo);
			
		cidSystemInfo.HPDF_Dict_Add ( "Registry",new HPDF_String(  encoderAttr.registry, null) );
		cidSystemInfo.HPDF_Dict_Add ( "Ordering",	new HPDF_String( encoderAttr.ordering, null));
		cidSystemInfo.HPDF_Dict_AddNumber ( "Supplement", encoderAttr.suppliment);
		
		return font;
	}
	
	override public function writeFn(stream:HPDF_Stream):void
	{
		trace("Type0 writefn");
	}

	
	
	}// klasa
	
	
	
}