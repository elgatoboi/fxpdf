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
package com.fxpdf.font.ttf
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_FontDef;
	import com.fxpdf.font.HPDF_TTFontDefAttr;
	import com.fxpdf.streams.HPDF_MemStream;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	import com.fxpdf.types.enum.HPDF_WhenceMode;
	import flash.utils.ByteArray;
	// mport flash.utils.ByteArray;
	
	public class HPDF_FontDef_TT extends HPDF_FontDef
	{
		public	static	const REQUIRED_TAGS : Array	=	["OS/2",
    "cmap",
    "cvt ",
    "fpgm",
    "glyf",
    "head",
    "hhea",
    "hmtx",
    "loca",
    "maxp",
    "name",
    "post",
    "prep" ];
	
		public function HPDF_FontDef_TT()
		{
			var	fontdefAttr : HPDF_TTFontDefAttr	=	new HPDF_TTFontDefAttr( ) ;
			 
		    trace (" HPDF_TTFontDef_New");
		
		    
		    this.sigBytes = HPDF_FONTDEF_SIG_BYTES;
		    this.type = HPDF_FontDefType.HPDF_FONTDEF_TYPE_TRUETYPE;
		    /*this.cleanFn = CleanFunc;
		    this.freeFn = FreeFunc;
			*/
		    attr = fontdefAttr;
		    flags = HPDF_FontDef.HPDF_FONT_STD_CHARSET;
		    // init attr
		    fontdefAttr.nameTbl	=	new HPDF_TTF_NamingTable ( ) ;  
		
		}
		
		
		public	static	function	HPDF2_TTFontDef_Load( fontData : ByteArray, embedding : Boolean ) : HPDF_FontDef
		{
		    var	fontdef : HPDF_FontDef_TT	=	new HPDF_FontDef_TT() ; 
		
		    trace (" HPDF_TTFontDef_Load");
		
		    fontdef.LoadFontData ( fontData, embedding, 0);
		    return fontdef; 	
		}
		
		public	function	LoadFontData ( fontData : ByteArray, embedding : Boolean, offset : uint )  : void
		{
		    
		    var	attr : HPDF_TTFontDefAttr	= attr	as HPDF_TTFontDefAttr;
		    var	tbl  : HPDF_TTFTable; 
		    var stringH : String = "H";
		    var stringx : String = "x";
		
		    trace (" HPDF_TTFontDef_LoadFontData");
		
		    attr.fontData		=	fontData;
		    attr.embedding		=	embedding;
		
		    //stream.HPDF_Stream_Seek ( offset, 0) ; // HPDF_SEEK_SET) ;
		    fontData.position	=	0;
		
		    LoadTTFTable ();
		        
		
		    ParseHead () ; 
		    ParseMaxp ();
		    ParseHhea ();
		    ParseCMap ();
		    ParseHmtx ();
		    ParseLoca () ;
		    ParseName () ; 
		 	ParseOS2 ();
		
		    tbl	=	FindTable ( "glyf");
		    
		    if (!tbl)
		    {
		        throw	new HPDF_Error( "LoadFontData",HPDF_Error.HPDF_TTF_MISSING_TABLE, 4);  
		    }
			
		    attr.glyphTbl.baseOffset	=	tbl.offset;
		    /* TODO capHeight			=	HPDF_TTFontDef_GetCharBBox ((HPDF_UINT16)'H').top;
		    xHeight				=	HPDF_TTFontDef_GetCharBBox ((HPDF_UINT16)'x').top;
		    */
		    
		    var capHeight : Number			=	HPDF_TTFontDef_GetCharBBox (  stringH.charCodeAt(0) ).top;
		    var xHeight : Number			=	HPDF_TTFontDef_GetCharBBox ( stringx.charCodeAt(0) ).top;
		    var missingWidth : Number		=	Math.round( attr.hMetric[0].advanceWidth * 1000 / attr.header.unitsPerEm );
		
		    trace (" fontdef.cap_height=", capHeight);
		    trace (" fontdef.x_height=", xHeight);
		    trace (" fontdef.missing_width=", missingWidth);
		
		    if (!embedding)
		    {
		        /*attr.stream.HPDF_Stream_Free ();
		        attr.stream =  null ;
		        */
		        attr.fontData	=	null ;  
		    }
		
		}
		
		public	function	HPDF_TTFontDef_GetCharBBox(  unicode : uint ) : HPDF_Box
		{ 
		    
		    var	attr : HPDF_TTFontDefAttr	=	attr  as HPDF_TTFontDefAttr;
		    var	gid : uint	=	HPDF_TTFontDef_GetGlyphid( unicode);
		    var	m	: int ;
		    var i : int ; 
		     
		    var	bbox : HPDF_Box	= new HPDF_Box(0, 0, 0, 0);
		    
		    
		
		    if (gid == 0)
		    {
		        trace (" GetCharHeight cannot get gid char=" + unicode.toString() );
		        return bbox;
		    }
		
		    if (attr.header.indexToLocFormat == 0)
		        m = 2;
		    else
		        m = 1;
		
		    // attr.stream.HPDF_Stream_Seek ( attr.glyphTbl.baseOffset + attr.glyphTbl.offsets[gid] * m + 2,0 );
		    attr.fontData.position	=	attr.glyphTbl.baseOffset + attr.glyphTbl.offsets[gid] * m + 2
		
			
		    i = attr.fontData.readShort();
		    bbox.left = Math.round( i * 1000 / attr.header.unitsPerEm );
		
		    i = attr.fontData.readShort();
		    bbox.bottom = Math.round( i * 1000 / attr.header.unitsPerEm );
		
		    i = attr.fontData.readShort();
		    bbox.right = Math.round( i * 1000 / attr.header.unitsPerEm );
		
		    i = attr.fontData.readShort();
		    bbox.top = Math.round( i * 1000 / attr.header.unitsPerEm );
			
		  
		    trace((" PdfTTFontDef_GetCharBBox char=, " + unicode.toString() + 
		            "box=[ " + bbox.left.toString() + " , " +  bbox.bottom.toString()  + " , " +  bbox.right.toString()  + " , " + bbox.top.toString() ));
			
		    return bbox;
		} 
		
		/*public	static	function	GetINT16( stream : HPDF_Stream ) : uint
		{
		    //ret =  (stream, (HPDF_BYTE *)value, &size);
		    var	value : uint	=	stream.HPDF_Stream_Read(2) ; 
		    /*if (ret != HPDF_OK) {
		        *value = 0;
		        return ret;
		    }
		    */
		  /*  value = HPDF_Utils.INT16Swap (value);
		    return value;
		}*/
		/*public	static	function	GetUINT32 ( stream : HPDF_Stream ) : uint
		{
               var	value : uint  = HPDF_Stream_Read (,4);
               value = HPDF_Utils.UINT32Swap (value);
			   return value ; 
		}*/
		
		private	function	ParseHead( ) : void
		{
		    
		    var	tbl : HPDF_TTFTable	=	FindTable( "head" );
		    var	siz : int ; 
		    
		        trace (" HPDF_TTFontDef_ParseHead");
		
		    if (!tbl)
		    {
		        throw new HPDF_Error("ParseHead", HPDF_Error.HPDF_TTF_MISSING_TABLE, 5);
		    }
		
		    //C attr.stream.HPDF_Stream_Seek (tbl.offset, HPDF_WhenceMode.HPDF_SEEK_SET);
		    attr.fontData.position	=	tbl.offset ; 
		   
			attr.header	=	new	HPDF_TTF_FontHeader( ) ; 
		    siz  = 4;
		    var	tmpBuf  :ByteArray		= new ByteArray();
		    //attr.fontData.readBytes(  tmpBuf,0,4 );
		    // TODO attr.header.versionNumber	=	HPDF_Utils.BytesToNumber( tempBuf ) ; // HOW TO CONVERTY ??
		    attr.header.versionNumber	=	new ByteArray(  );
		    attr.fontData.readBytes(   attr.header.versionNumber,0,4 );
		    attr.header.fontRevision	=	attr.fontData.readUnsignedInt();
		    attr.header.checkSumAdjustment	=	attr.fontData.readUnsignedInt();
		    attr.header.magicNumber		=	attr.fontData.readUnsignedInt();
		    attr.header.flags			=	attr.fontData.readUnsignedShort();
		    attr.header.unitsPerEm	=	attr.fontData.readUnsignedShort();
		
		    //tempBuf	=	attr.stream.HPDF_Stream_Read( siz ) ; 
		    //attr.fontData.readBytes (  tmpBuf,0,8);  // converted
		    attr.header.created	=	new ByteArray( ) ; 
		    attr.fontData.readBytes (  attr.header.created,0,8);  // converted
		    // attr.header.created	=	HPDF_Utils.BytesToNumber ( tempBuf );
		    /// attr.header.created// how to convert ??	
		    attr.header.modified = new ByteArray ();
		    attr.fontData.readBytes (  attr.header.modified,0,8); // modified
		    //ret += HPDF_Stream_Read (attr.stream, attr.header.modified, &siz);
		
		    attr.header.xMin				=	attr.fontData.readShort();
		    attr.header.yMin				=	attr.fontData.readShort();
		    attr.header.xMax				=	attr.fontData.readShort();
		    attr.header.yMax				=	attr.fontData.readShort();
		    attr.header.macStyle			=	attr.fontData.readUnsignedShort();
		    attr.header.lowestRecPpem		=	attr.fontData.readUnsignedShort();
		    attr.header.fontDirectionHint	=	attr.fontData.readShort();
		    attr.header.indexToLocFormat	=	attr.fontData.readShort();
		    attr.header.glyphDataFormat		=	attr.fontData.readShort();
			fontBBox	=	new HPDF_Box( ) ; 
		    fontBBox.left	= Math.round( attr.header.xMin * 1000 /		                attr.header.unitsPerEm );
		    fontBBox.bottom	= Math.round( attr.header.yMin * 1000 /		                attr.header.unitsPerEm );
		    fontBBox.right	= Math.round( attr.header.xMax * 1000 /		                attr.header.unitsPerEm );
		    fontBBox.top	= Math.round( attr.header.yMax * 1000 / 		            attr.header.unitsPerEm );
			
		}
		
		private	function FindTable ( tag : String): HPDF_TTFTable
		{
		   /*  HPDF_TTFTable* tbl = attr.offset_tbl.table;
		    HPDF_UINT i; */
		    
		    for (var i:int = 0; i < attr.offsetTbl.numTables; i++)
		    {
		    	var tbl : HPDF_TTFTable	=	attr.offsetTbl.table[i] ; 
		    	if ( tbl.tag	== tag ) 
		    		return tbl ; 
		        /*if (HPDF_MemCmp ((HPDF_BYTE *)tbl.tag, (HPDF_BYTE *)tag, 4) == 0) {
		            HPDF_PTRACE((" FindTable find table[%c%c%c%c]\n",
		                        tbl.tag[0], tbl.tag[1], tbl.tag[2], tbl.tag[3]));
		            return tbl;
		            */
		    }
		    return null;
		} 
		
		
		public	function	HPDF_TTFontDef_GetGlyphid ( unicode : uint ): uint
		{
		    var 	attr : HPDF_TTFontDefAttr	=	this.attr as HPDF_TTFontDefAttr;
		    // HPDF_UINT16 *pend_count = attr.cmap.end_count;
		    //HPDF_UINT seg_count = attr.cmap.seg_count_x2 / 2;
		    var	segCount : uint 	=	attr.cmap.segCountX2 / 2;
		    var	i : int = 0; 
		    trace((" HPDF_TTFontDef_GetGlyphid\n"));
		
		    /* format 0 */
		    if (attr.cmap.format == 0)
		    {
		        unicode &= 0xFF;
		        return attr.cmap.glyphIdArray[unicode];
		    }
		
		    /* format 4 */
		    if (attr.cmap.segCountX2 == 0) {
		    	throw new HPDF_Error( "HPDF_TTFontDef_GetGlyphid",  HPDF_Error.HPDF_TTF_INVALID_CMAP, 0 ) ;
		    }
		
		    for ( i = 0; i < segCount; i++)
		    {
		    	var pendCount : uint = attr.cmap.endCount[i] ; 
		        if (unicode <= pendCount)
		            break;
		        //pend_count++;
		    }
		
		    if (attr.cmap.startCount[i] > unicode)
		    {
		        trace(" HPDF_TTFontDef_GetGlyphid undefined char " + unicode.toString());
		        return 0;
		    }
		
		    if (attr.cmap.idRangeOffset[i] == 0)
		    {
		        trace(" HPDF_TTFontDef_GetGlyphid idx=" + i.toString + " code= " + unicode.toString() + " ret = " + (unicode+ attr.cmap.idDelta[i] ) );
		        return unicode + attr.cmap.idDelta[i];
		    } else
		    {
		        /*HPDF_UINT idx = attr.cmap.id_range_offset[i] / 2 +
		            (unicode - attr.cmap.start_count[i]) - (seg_count - i);
		            */
				var	idx : uint = attr.cmap.idRangeOffset[i] / 2 + (unicode - attr.cmap.startCount[i]) - (segCount - i ) ; 
				
		        if (idx > attr.cmap.glyphIdArrayCount)
		        {
		            trace(" HPDF_TTFontDef_GetGlyphid[" + i.toString() + "] " + idx.toString() + "  > " + attr.cmap.glyphIdArrayCount.toString() );
		            return 0;
		        } else
		        {
		            /*HPDF_UINT16 gid = attr.cmap.glyph_id_array[idx] +
		                attr.cmap.id_delta[i];*/
		            var	gid : uint	=	attr.cmap.glyphIdArray[idx] + attr.cmap.idDelta[i];
		            trace(" HPDF_TTFontDef_GetGlyphid idx=" + idx.toString() + " unicode= " + unicode.toString() + " id = " + gid.toString() );
		            return gid;
		        }
		    }
		} 
		
		private	function	LoadTTFTable( ) : void
		{
		    var	attr : HPDF_TTFontDefAttr	=	attr as HPDF_TTFontDefAttr;
    		// HPDF_TTFTable *tbl;

		    trace (" HPDF_TTFontDef_LoadTTFTable");
			attr.offsetTbl	=	new HPDF_TTF_OffsetTbl( ) ;
			var pos: int	=	attr.fontData.position; 
		    //ret += GetUINT32 (attr->stream, &attr->offset_tbl.sfnt_version);
		    attr.offsetTbl.sfntVersion	=	attr.fontData.readUnsignedInt();
		    //ret += GetUINT16 (attr->stream, &attr->offset_tbl.num_tables);
		    attr.offsetTbl.numTables	=	attr.fontData.readUnsignedShort();
		    //ret += GetUINT16 (attr->stream, &attr->offset_tbl.search_range);
		    attr.offsetTbl.searchRange	=	attr.fontData.readUnsignedShort();
		    //ret += GetUINT16 (attr->stream, &attr->offset_tbl.entry_selector);
		    attr.offsetTbl.entrySelector	=	attr.fontData.readUnsignedShort();
		    //ret += GetUINT16 (attr->stream, &attr->offset_tbl.range_shift);
		    attr.offsetTbl.rangeShift	=	attr.fontData.readUnsignedShort();
			
		   /*if (attr.offsetTbl.numTables * sizeof(HPDF_TTFTable) >
		            HPDF_TTF_MAX_MEM_SIZ)
		        return HPDF_SetError (fontdef->error, HPDF_TTF_INVALID_FOMAT, 0);
		        */
		
		    attr.offsetTbl.table = new Vector.<HPDF_TTFTable> ;
		    
		
		    //tbl = attr.offsetTbl.table;
		    
		    for (var i: int = 0; i < attr.offsetTbl.numTables; i++)
		    {
		        var	tbl : HPDF_TTFTable	=	new HPDF_TTFTable() ;
		
		        //ret += HPDF_Stream_Read (attr->stream, (HPDF_BYTE *)tbl->tag, &siz);
		        var tmpBuf : ByteArray	= new ByteArray();
		        attr.fontData.readBytes(tmpBuf, 0,4); 	
		        tbl.tag	= new String( tmpBuf); 
		        //ret += GetUINT32 (attr->stream, &tbl->check_sum);
		        tbl.checkSum	=	attr.fontData.readUnsignedInt();
		        //ret += GetUINT32 (attr->stream, &tbl->offset);
		        tbl.offset		=	attr.fontData.readUnsignedInt();
		        //ret += GetUINT32 (attr->stream, &tbl->length);
		        tbl.length		=	attr.fontData.readUnsignedInt();
		
		        /*HPDF_PTRACE((" [%d] tag=[%c%c%c%c] check_sum=%u offset=%u length=%u\n",
		                    i, tbl->tag[0], tbl->tag[1], tbl->tag[2], tbl->tag[3],
		                    (HPDF_UINT)tbl->check_sum, (HPDF_UINT)tbl->offset,
		                    (HPDF_UINT)tbl->length));
		*/
		  		attr.offsetTbl.table.push( tbl );
		  		trace("loaded table name = " + tbl.tag + " offset = " + tbl.offset.toString() );
		        // stbl++;
		    }
		}
		
		private	function ParseMaxp():void
		{
		    var	tbl : HPDF_TTFTable	= FindTable ( "maxp");
		    trace (" HPDF_TTFontDef_ParseMaxp");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseMaxp", HPDF_Error.HPDF_TTF_MISSING_TABLE, 9);

		    attr.fontData.position	=	tbl.offset + 4; 
		    attr.numGlyphs			=	attr.fontData.readUnsignedShort();
		    
		    trace(" HPDF_TTFontDef_ParseMaxp num_glyphs= " + attr.numGlyphs);
		}		
		
		
		private	function ParseHhea():void
		{
		    var attr : HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    
		    var	tbl : HPDF_TTFTable	= FindTable ( "hhea");
		    
		    trace (" HPDF_TTFontDef_ParseHhea");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseHhea", HPDF_Error.HPDF_TTF_MISSING_TABLE, 6);
		    
		    attr.fontData.position	=	tbl.offset + 4; 	
		   
		    
		    ascent	=	attr.fontData.readShort();
		    ascent =  Math.round( ascent * 1000 / attr.header.unitsPerEm );
		    
		    descent	=	attr.fontData.readShort();
		    descent =  Math.round( descent * 1000 / attr.header.unitsPerEm );
		    
		    
		    attr.fontData.position	=	tbl.offset + 34; 
		    
		    attr.numHMetric	=	attr.fontData.readUnsignedShort();
		    
		}
		
		private	function	ParseCMap () : void
		{
			var attr 					: HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    var	msUnicodeEncodingOffset : int ; 
		    var	byteEncodingOffset 		: uint ; 
		    
		    var	tbl : HPDF_TTFTable	= FindTable ( "cmap");
		    
		    trace (" HPDF_TTFontDef_ParseCMap");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseCmap", HPDF_Error.HPDF_TTF_MISSING_TABLE, 1);
		    
		    attr.fontData.position	=	tbl.offset ; 	
		    
   			var	version : uint	=	attr.fontData.readUnsignedShort();
   			if ( version != 0 ) {
   				throw new HPDF_Error("ParseCmap",HPDF_Error.HPDF_TTF_INVALID_FOMAT, 0);
   			}
   			var	numCmap	: uint	=	attr.fontData.readUnsignedShort();
   			for ( var i: int = 0 ; i <numCmap ; i++ )
   			{
   				var platformID : uint	= attr.fontData.readUnsignedShort();
   				var encodingID : uint	= attr.fontData.readUnsignedShort();
   				var offset : uint 		= attr.fontData.readUnsignedInt();
   				var	saveOffset : int	= attr.fontData.position ; 
   				attr.fontData.position	=	tbl.offset + offset ; 
   				
   				var format 	: uint		=	attr.fontData.readUnsignedShort();
   				
   				  /* MS-Unicode-CMAP is used for priority */
		        if (platformID == 3 && encodingID == 1 && format == 4) {
		            msUnicodeEncodingOffset = offset;
		            break;
		        }
		                /* Byte-Encoding-CMAP will be used if MS-Unicode-CMAP is not found */
		        if (platformID == 1 && encodingID ==0 && format == 1)
		            byteEncodingOffset = offset;
		        attr.fontData.position	=	saveOffset;
		        
   			}
   			if (msUnicodeEncodingOffset != 0)
   			{
   				trace(" found microsoft unicode cmap.");
   				ParseCMAP_format4( msUnicodeEncodingOffset +   tbl.offset);
   			}
   			else if ( byteEncodingOffset != 0 ) 
   			{
   				 trace(" found byte encoding cmap.");
        		 // TODO ParseCMAP_format0( byteEncodingOffset + tbl.offset);
   			}
   			else
   			{
   				trace( "cannot found target cmap");
   				throw new HPDF_Error( "ParseCmap",HPDF_Error.HPDF_TTF_INVALID_FOMAT, 0);
   			}
		 }
		 
		 
		 private	function	ParseCMAP_format4  ( offset : uint ) : void
		 {
			 
		 	var attr 		: HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		 	var	i		 	: uint ; 
		 	var	tmpInt		: int ; 
		 	var	tmpUint		: uint ; 
			var tmp 		: uint;
			
		 	/*var	pendCount : uint ; 
            HPDF_TTFontDefAttr attr = (HPDF_TTFontDefAttr)fontdef->attr;
		    HPDF_STATUS ret;
		    HPDF_UINT i;
		    HPDF_UINT16 *pend_count;
		    HPDF_UINT16 *pstart_count;
		    HPDF_INT16 *pid_delta;
		    HPDF_UINT16 *pid_range_offset;
		    HPDF_UINT16 *pglyph_id_array;
		    HPDF_INT32 num_read;
		    */
		
		    trace(" ParseCMAP_format4");
		    attr.fontData.position	=	offset ; 
		    attr.cmap	=	new HPDF_TTF_CmapRange( ) ;  
		    attr.cmap.format	=	attr.fontData.readUnsignedShort() ;
		    attr.cmap.length	=	attr.fontData.readUnsignedShort() ; 
		    attr.cmap.language	=	attr.fontData.readUnsignedShort() ;  
		    
		    if ( attr.cmap.format != 4 )
		    {
		    	throw new HPDF_Error("ParseCMAP_format4",  HPDF_Error.HPDF_TTF_INVALID_FOMAT, 0);
		    }
		    
		    attr.cmap.segCountX2	=	attr.fontData.readUnsignedShort() ;  
		    attr.cmap.searchRange	=	attr.fontData.readUnsignedShort() ;  
		    attr.cmap.entrySelector	=	attr.fontData.readUnsignedShort() ;  
		    attr.cmap.rangeShift	=	attr.fontData.readUnsignedShort() ;  
		    
				  
		    /* end_count */
		    attr.cmap.endCount = new Vector.<uint> ; 
		    
		    // pend_count = attr->cmap.end_count;
		    for ( i = 0 ; i < attr.cmap.segCountX2 / 2; i++)
		    {
		    	tmp 	=	attr.fontData.readUnsignedShort() ; 
		    	attr.cmap.endCount.push( tmp );
		    }
		    
		    attr.cmap.reservedPad	=	attr.fontData.readUnsignedShort() ; 
		        

		    /* start_count */
		    attr.cmap.startCount =  new Vector.<uint> ;
		
		    for (i = 0; i < attr.cmap.segCountX2 / 2; i++)
		    {
		    	 tmp	=	attr.fontData.readUnsignedShort() ; 
		    	 attr.cmap.startCount.push( tmp );
		    }
		
		    /* id_delta */
		    attr.cmap.idDelta = new Vector.<int> 
		    
		    for (i = 0; i < attr.cmap.segCountX2 / 2; i++)
		    {
		    	tmpInt	=	attr.fontData.readShort() ; 
		    	attr.cmap.idDelta.push( tmpInt );
		    }
		
		    /* id_range_offset */
		    attr.cmap.idRangeOffset = new Vector.<uint> ;
		    for (i = 0; i < attr.cmap.segCountX2 / 2; i++)
		    {
		    	tmpUint	=	attr.fontData.readUnsignedShort() ; 
		    	attr.cmap.idRangeOffset.push( tmpUint);
		    }
		
		    var numRead  : uint =  attr.fontData.position - offset ; 
		    if (numRead < 0)
		    {
		    	throw new HPDF_Error ( "ParseCMAP_format4 NumRead error" );
		    }
		
		    attr.cmap.glyphIdArrayCount = (attr.cmap.length - numRead) / 2;
		
		    if (attr.cmap.glyphIdArrayCount > 0)
		    {
		        /* glyph_id_array */
		        attr.cmap.glyphIdArray = new Vector.<uint> ;
		        for (i = 0; i < attr.cmap.glyphIdArrayCount ; i++)
		        {
		            tmpUint	=	attr.fontData.readUnsignedShort() ; 
		    		attr.cmap.glyphIdArray.push( tmpUint );
		        }
		    } else
		        attr.cmap.glyphIdArray = null;
		} 
    	
    	
    	private	function	ParseHmtx  () : void
    	{
    		var attr 						: HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    var	msUnicodeEncodingOffset 	: int ; 
		    var	byteEncodingOffset 			: uint ; 
		    var	saveAw						: int = 0; 
			var	hm 							: HPDF_TTF_LongHorMetric;
		    
		    var	tbl : HPDF_TTFTable	= FindTable ( "hmtx");
		    
		    trace (" HPDF_TTFontDef_ParseHtmx");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseHmtx", HPDF_Error.HPDF_TTF_MISSING_TABLE, 7);
		    
		    attr.fontData.position	=	tbl.offset ; 	
		    
		    attr.hMetric	=	new Vector.<HPDF_TTF_LongHorMetric> ; 
		    
		    for (var i : int = 0; i < attr.numHMetric; i++)
		    {
		    	hm	=	new HPDF_TTF_LongHorMetric( ); 
		    	hm.advanceWidth	=	attr.fontData.readUnsignedShort(); 
		    	hm.lsb	=	attr.fontData.readShort();
		                
		        saveAw = hm.advanceWidth;
		        
		        attr.hMetric.push( hm ) ;
		    }
		        
	        /* pad the advance_width of remaining metrics with the value of last metric */
		    while (i < attr.numGlyphs)
		    {
		        hm	=	new HPDF_TTF_LongHorMetric( ); 
		        hm.advanceWidth	=	saveAw;
				
		        hm.lsb	=	attr.fontData.readShort();
		        attr.hMetric.push( hm ) ;
		        i++;
		    }
		    
		}
		
		private	function	ParseLoca ( ) : void 
		{
			var attr 	: HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    var	tbl 	: HPDF_TTFTable	= FindTable ( "loca");
			var i 		: int;
			
		    trace (" HPDF_TTFontDef_ParseLoca");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseLoca", HPDF_Error.HPDF_TTF_MISSING_TABLE, 8);
		    
		    attr.fontData.position	=	tbl.offset ; 	
		    attr.glyphTbl	=	new HPDF_TTF_GryphOffsets( ); 
		    attr.glyphTbl.offsets	=	new Vector.<uint> ; 
		    attr.glyphTbl.flgs		=	new Vector.<uint> ;
		    
		    for ( i = 0 ; i < attr.numGlyphs ; i++ )
		    	attr.glyphTbl.flgs.push( 0 ) ;  
		    attr.glyphTbl.flgs[0] = 1; 
		    	
		    if (attr.header.indexToLocFormat == 0)
		    {
		        /* short version */
		        for ( i = 0; i <= attr.numGlyphs; i++)
		        {
		            var tmp : uint ; 
		            tmp	=	attr.fontData.readUnsignedShort();
		            
		            attr.glyphTbl.offsets.push( tmp ); 
		        }
		    }
		    else 
		    {
		        /* long version */
		        for (i = 0; i <= attr.numGlyphs; i++)
		        {
		        	attr.glyphTbl.offsets.push( attr.fontData.readUnsignedInt() );
		        }
		    } 
		}
		
		
		private	function	ParseName () : void
		{
			
    		var	offsetId1 	: uint = 0;
    		var	offsetId2 	: uint = 0; 
    		var	offsetId1u 	: uint = 0; 
    		var	offsetId2u 	: uint = 0;
    		var	lenId1 		: uint = 0;
    		var	lenId2 		: uint = 0;
    		var	lenId1u 	: uint = 0;
    		var	lenId2u 	: uint = 0;
    		var tmp 		: String ; 
			var tmpBuf 		: ByteArray;
			
			var attr : HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    
		    var	tbl : HPDF_TTFTable	= FindTable ( "name");
		    
		    trace (" HPDF_TTFontDef_ParseName");
		
		    if (!tbl)
		    	throw new HPDF_Error("ParseName", HPDF_Error.HPDF_TTF_MISSING_TABLE, 10);
		    
		    attr.fontData.position	=	tbl.offset ; 	
			
			
			attr.nameTbl.format	=	attr.fontData.readUnsignedShort() ; 
			attr.nameTbl.count	=	attr.fontData.readUnsignedShort() ;
			attr.nameTbl.stringOffset	=	attr.fontData.readUnsignedShort() ;
			
			attr.nameTbl.nameRecords	=	new Vector.<HPDF_TTF_NameRecord> ;
			
			for ( var i : int  = 0 ; i < attr.nameTbl.count ; i ++ )
			{ 
				
				var	name : HPDF_TTF_NameRecord	=	new HPDF_TTF_NameRecord() ; 
				
				name.platformId		=	attr.fontData.readUnsignedShort() ;
				name.encodingId		=	attr.fontData.readUnsignedShort() ;
				name.languageId		=	attr.fontData.readUnsignedShort() ;
				name.nameId			=	attr.fontData.readUnsignedShort() ;
				name.length			=	attr.fontData.readUnsignedShort() ;
				name.offset			=	attr.fontData.readUnsignedShort() ;
				
				if ( name.platformId == 1 && name.encodingId == 0 &&  name.nameId == 6) {
		            offsetId1 = tbl.offset + name.offset +  attr.nameTbl.stringOffset;
		            lenId1 = name.length;
		        }
		        if ( name.platformId == 1 && name.encodingId == 0 && name.nameId == 6) {
            		offsetId1 = tbl.offset + name.offset + attr.nameTbl.stringOffset;
            		lenId1 = name.length;
        		}
                if ( name.platformId == 1 && name.encodingId == 0 && name.nameId == 2) {
		            offsetId2 = tbl.offset + name.offset +  attr.nameTbl.stringOffset;
		            lenId2 = name.length;
        		}
		        if (name.platformId == 3 && name.encodingId == 1 && name.nameId == 6 && name.languageId == 0x0409) {
		            offsetId1u = tbl.offset + name.offset + attr.nameTbl.stringOffset;
		            lenId1u = name.length;
		        }
		        if (name.platformId == 3 && name.encodingId == 1 &&  name.nameId == 2 && name.languageId == 0x0409) {
		            offsetId2u = tbl.offset + name.offset +  attr.nameTbl.stringOffset;
		            lenId2u = name.length;
		        }
		        attr.nameTbl.nameRecords.push( name ) ; 
			} 
			
		   	
		
		    if ((!offsetId1 && !offsetId1u) ||  (!offsetId2 && !offsetId2u))
		    {
		    	throw new HPDF_Error("ParseName", HPDF_Error.HPDF_TTF_INVALID_FOMAT, 0 ) ;
		    }
		    if ( lenId1 == 0 && lenId1u > 0)  lenId1 = lenId1u / 2 + lenId1u % 2;

		    if (lenId2 == 0 && lenId2u > 0)
		        lenId2 = lenId2u / 2 + lenId2u % 2;
		
		    if (lenId1 + lenId2 + 8 > 127)
		    {
		    	throw new HPDF_Error( "ParseName", HPDF_Error.HPDF_TTF_INVALID_FOMAT, 0);
		    }
		    
		    if (offsetId1)
		    {
		    	attr.fontData.position	=	offsetId1 ;
		    	tmpBuf	=	new ByteArray( ) ; 
		    	attr.fontData.readBytes( tmpBuf ,0, lenId1 ) ; 
		    	attr.baseFont	=	new String ( tmpBuf ) ; 

		    } else
		    {
		        attr.baseFont	=	LoadUnicodeName ( offsetId1u, lenId1u ) ;  
		    }
		    
		    if (offsetId2)
		    {
		    	attr.fontData.position	=	offsetId2 ;
		    	tmpBuf	=	new ByteArray( ) ; 
		    	attr.fontData.readBytes( tmpBuf ,0, lenId2 ) ; 
		    	tmp	=	new String ( tmpBuf ) ; 
		    	
		        
		    } else {
		        tmp = LoadUnicodeName ( offsetId2u, lenId2u ) ;   
		    }

		   /*
		    * get "postscript name" of from a "name" table as BaseName.
		    * if subfamily name is not "Regular", add subfamily name to BaseName.
		    * if subfamily name includes the blank character, remove it.
		    * if subfamily name is "Bold" or "Italic" or "BoldItalic", set flags
		    * attribute.
		    */
		    if ( tmp.indexOf("Regular" ) != 0 )
		    {
		       /* TODO char *dst = attr->base_font + len_id1;
		        char *src = tmp;
		        HPDF_UINT j;
		
		        *dst++ = ',';
		
		        for (j = 0; j < len_id2; j++) {
		            if (*src != ' ')
		                *dst++ = *src++;
		
		            if (dst >= attr->base_font + HPDF_LIMIT_MAX_NAME_LEN)
		                break;
		        }
		
		        *dst = 0;
		
		        if (HPDF_StrStr (tmp, "Bold", len_id2))
		            fontdef->flags |= HPDF_FONT_FOURCE_BOLD;
		        if (HPDF_StrStr (tmp, "Italic", len_id2))
		            fontdef->flags |= HPDF_FONT_ITALIC;
		            */
		    }

   			 this.baseFont	=	new String( attr.baseFont ) ; 
	}
		
		
		private	function	LoadUnicodeName( offset : uint , len : uint ) : String
		{
		  
		    /*HPDF_BYTE tmp[HPDF_LIMIT_MAX_NAME_LEN * 2 + 1];
		    HPDF_UINT i = 0;
		    HPDF_UINT j = 0;
		    HPDF_STATUS ret;
		
		    HPDF_MemSet (buf, 0, HPDF_LIMIT_MAX_NAME_LEN + 1);
		
		    if ((ret = HPDF_Stream_Seek (stream, offset, HPDF_SEEK_SET)) !=
		            HPDF_OK)
		        return ret;
		
		    if ((ret = HPDF_Stream_Read (stream, tmp, &len))
		             != HPDF_OK)
		        return ret;
		
		    while (i < len) {
		        i++;
		        buf[j] = tmp[i];
		        j++;
		        i++;
		    }
		    */
		    var attr : HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    attr.fontData.position	=	offset ;
		    var ret : String	=	attr.fontData.readUTFBytes( len ) ;
		    return ret;  
	}
		
	private	function	ParseOS2 () : void
	{
		var attr : HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
		    
	    var	tbl : HPDF_TTFTable	= FindTable ( "OS/2");
	    
	    trace (" ParseOS2");
	
	    if (!tbl)
	    	throw new HPDF_Error("ParseOS2", HPDF_Error.HPDF_TTF_MISSING_TABLE, 0);
	    
	    attr.fontData.position	=	tbl.offset + 8 ; 
	    
	    attr.fsType	=	attr.fontData.readUnsignedShort() ; 
		    
	   
	    if (attr.fsType  & (0x0002 | 0x0100 | 0x0200) && attr.embedding)
	    {
	    	throw new HPDF_Error( "ParseOS2", HPDF_Error.HPDF_TTF_CANNOT_EMBEDDING_FONT, 0);
	    }
	    attr.fontData.position	=	tbl.offset + 20; 
	    
	    attr.panose	=	new Vector.<uint> ; 
	    for ( var i : int = 0 ; i < 12; i ++ ) 
	    { 
	    	attr.panose.push( attr.fontData.readByte( ) ) ; 
	    }
	   
    
	    if (attr.panose[0] == 1 || attr.panose[0] == 4)
	        flags = flags | HPDF_FONT_SERIF;

	    /* get ulCodePageRange1 */
	    attr.fontData.position	=	attr.fontData.position + 78 ; 
	    attr.codePageRange1	=	attr.fontData.readUnsignedInt() ;
	    attr.codePageRange2	=	attr.fontData.readUnsignedInt() ;
	      
	    trace("  ParseOS2 CodePageRange1=" + attr.codePageRange1.toString() + "  CodePageRange2= " + attr.codePageRange2.toString() );
	}
	
	

		
		public	function	HPDF_TTFontDef_GetCharWidth  (unicode : uint ) :int 
		{
			var	advanceWidth : uint ; 
			var	hmetrics	: HPDF_TTF_LongHorMetric	;
			var	attr : HPDF_TTFontDefAttr	=	this.attr as HPDF_TTFontDefAttr;
			
			var gid : uint = this.HPDF_TTFontDef_GetGlyphid( unicode );
		
  	  		trace(" HPDF_TTFontDef_GetCharWidth gid = " + gid.toString());

		    if (gid >= attr.numGlyphs)
		    {
		    	trace(" HPDF_TTFontDef_GetCharWidth WARNING gid > num_glyphs " + gid.toString() + " > " + attr.numGlyphs.toString() );
		        return missingWidth;
		    }
		
		    hmetrics = attr.hMetric[gid];
		
		    if (!attr.glyphTbl.flgs[gid])
		    {
		        attr.glyphTbl.flgs[gid] = 1;
		
		        if (attr.embedding)
		            CheckCompositGryph ( gid);
		    }
		
		    advanceWidth = Math.round( hmetrics.advanceWidth * 1000 / attr.header.unitsPerEm );
		    trace("get char width  = char = " + unicode.toString() + " ret = " + advanceWidth.toString() );
		    return advanceWidth ;
		}
		
		
		/**
		 * CheckCompositGryph( gid ); 
		 * */
		private	function	CheckCompositGryph( gid : uint ) : void
		{
		    var	attr : HPDF_TTFontDefAttr	=	this.attr as HPDF_TTFontDefAttr;
		    var	offset : uint	=	attr.glyphTbl.offsets[gid] ; 
		    var	numOfContours : int ; 
		    var	flags : int ; 
		    var glyphIndex : int ; 		
		    
	        const  ARG_1_AND_2_ARE_WORDS : uint = 1;
	        const  WE_HAVE_A_SCALE : uint   = 8;
	        const  MORE_COMPONENTS : uint  = 32;
	        const  WE_HAVE_AN_X_AND_Y_SCALE : uint  = 64;
	        const  WE_HAVE_A_TWO_BY_TWO : uint  = 128;
		    
		   
		    trace (" CheckCompositGryph");
		
		    if (attr.header.indexToLocFormat == 0)
		        offset *= 2;
		
		    offset += attr.glyphTbl.baseOffset;
		
		    attr.fontData.position	=	offset;
	
	        numOfContours = attr.fontData.readShort() ;  
	
	        if (numOfContours != -1)
	            return ;
	
	        trace (" CheckCompositGryph composit font gid=" +  gid.toString() );
	
	        attr.fontData.position += 8 ; 
	        do 
	        {
	            flags	=	attr.fontData.readShort(); 
	            
	            glyphIndex	=	attr.fontData.readShort();
	
	            if (flags & ARG_1_AND_2_ARE_WORDS)
	            {
	                attr.fontData.position += 4 ; 
	            } else {
	           		attr.fontData.position += 2 ;
	            }
	
	            if (flags & WE_HAVE_A_SCALE)
	            {
	                attr.fontData.position += 2 ;
	            }
	            else if (flags & WE_HAVE_AN_X_AND_Y_SCALE)
	            {
	                attr.fontData.position += 4 ;
	            }
	            else if (flags & WE_HAVE_A_TWO_BY_TWO)
	            {
	               attr.fontData.position += 8 ;
	            }
	
	            if (glyphIndex > 0 && glyphIndex < attr.numGlyphs)
	                attr.glyphTbl.flgs[glyphIndex] = 1;
	
	            trace (" gid="+gid.toString()+", num_of_contours=" +numOfContours.toString() + "  flags=" + flags.toString() +
	                    "glyph_index= " + glyphIndex.toString( ) + "" );
	                    
	        } while (flags & MORE_COMPONENTS);
	    }
	    
	    
	    /**
	    * Save ttf def font data to the stream
	    * */
	    public function	HPDF_TTFontDef_SaveFontData  ( stream : HPDF_Stream ) : void
		{
         	  var	attr 			: HPDF_TTFontDefAttr		= attr as HPDF_TTFontDefAttr;
         	  var	tmpTbl			: Vector.<HPDF_TTFTable> 	= new Vector.<HPDF_TTFTable>(HPDF_REQUIRED_TAGS_COUNT);
         	  var	tmpStream 		: HPDF_MemStream ; 
         	  var	newOffsets 		: Vector.<uint>;
         	  var	i				: int; 
         	  var	j				: int; 
         	  var	tmpCheckSum		: uint = 0xB1B0AFBA; 	
         	  var	offsetBase		: uint; 
         	  var	checkSumPtr 	: uint;
			  var	buf 			: ByteArray;
			  var	tbl 			: HPDF_TTFTable;
			  var	length 			: uint;
			  var	bufu 			: uint; 
			  
			   /*		
			    HPDF_Stream tmp_stream;
			    HPDF_UINT32 *new_offsets;
			    HPDF_UINT i;
			    HPDF_UINT32 check_sum_ptr;
			    HPDF_STATUS ret;
			    HPDF_UINT32 offset_base;
			    HPDF_UINT32 tmp_check_sum = 0xB1B0AFBA;
			    */

		    trace (" SaveFontData");
			
		    stream.WriteUINT32 ( attr.offsetTbl.sfntVersion);
		    stream.WriteUINT16 ( HPDF_REQUIRED_TAGS_COUNT);
		    stream.WriteUINT16 ( attr.offsetTbl.searchRange);
		    stream.WriteUINT16 ( attr.offsetTbl.entrySelector);
		    stream.WriteUINT16 ( attr.offsetTbl.rangeShift);
		
		    tmpStream = new HPDF_MemStream( );
		    
		    offsetBase = 12 + 16 * HPDF_REQUIRED_TAGS_COUNT;
		    
		    newOffsets = new Vector.<uint>;
		
		    /*newOffsets = HPDF_GetMem (fontdef.mmgr,
		            sizeof (HPDF_UINT32) * (attr.num_glyphs + 1));
		    if (!new_offsets) {
		        HPDF_Stream_Free (tmp_stream);
		        return HPDF_Error_GetCode (fontdef.error);
		    }*/

		    for (i = 0; i < HPDF_REQUIRED_TAGS_COUNT; i++)
		    {
		        tbl 	=	FindTable( HPDF_FontDef_TT.REQUIRED_TAGS[i] ) ;
		      
		        if (!tbl)
		        {
		        	throw new HPDF_Error("HPDF_TTFontDef_SaveFontData", HPDF_Error.HPDF_TTF_MISSING_TABLE, i);
		        }
		
		        //C attr.stream.HPDF_Stream_Seek (tbl.offset, HPDF_WhenceMode.HPDF_SEEK_SET);
		        attr.fontData.position	=	tbl.offset;
		        
		        length 				= tbl.length;
		        var	newOffset		: uint = tmpStream.size;
		        //trace("table  " + HPDF_FontDef_TT.REQUIRED_TAGS[i] + " length " + length.toString() + " new offs " + newOffset.toString() ); 
		
		        if ( tbl.tag	==	"head" ) 
		        	checkSumPtr	=	WriteHeader ( tmpStream ) ;
		        else if ( tbl.tag == "glyf" )
		        {
		        	RecreateGLYF ( newOffsets, tmpStream);
		        }
		        else if ( tbl.tag == "loca" )
		        {
		            
		            var	value : uint = 0; 
		            //poffset	=	newOffsets; 
		            value	=	0;
		            
		            if ( attr.header.indexToLocFormat == 0)
		            {
		                for (j = 0; j <= attr.numGlyphs; j++)
		                {
		                	var offset : uint = newOffsets[j];
		                	tmpStream.WriteUINT16( offset );
		                }
		            } else
		            {
		                for ( j = 0; j <= attr.numGlyphs; j++)
		                {
		                    tmpStream.WriteUINT32( newOffsets[j] );
		                }
		            }
		        }
		        else if ( tbl.tag	== "name" )
		        {
		            RecreateName (  tmpStream);
		        }
		        else
		        {
		            
		            var	size : uint = 4; 
		
		            while (length > 4)
		            {
		                value 	= 0;
		                size 	= 4;
		                buf 	= new ByteArray();
		                var aa : int = attr.fontData.readInt();
		                attr.fontData.position -= 4; 
		                attr.fontData.readBytes( buf, 0, 4 ) ;
		                buf.position = 0;  
		                var a0 : int = buf.readByte();
		                var a1 : int = buf.readByte();
		                var a2 : int = buf.readByte();
		                var a3 : uint = buf.readByte() as uint;
		                buf.position = 0; 
		                tmpStream.WriteFunc( buf );
		                /*ret = HPDF_Stream_Read (attr.stream, (HPDF_BYTE *)&value, &size);
		                ret += HPDF_Stream_Write (tmp_stream, (HPDF_BYTE *)&value, size);
		                */
		                buf.position = 0 ; 
		                var num : Number = buf.readUnsignedInt();
		                //trace( "readwrite " + num.toString() );
		                length -= 4; 
		            }
		
		            value 	= 0;
		            size 	= length;
		            buf 	= new ByteArray();
		            attr.fontData.readBytes( buf, 0, size) ; 
		            tmpStream.WriteFunc( buf );
		            /*ret += HPDF_Stream_Read (attr.stream, (HPDF_BYTE *)&value, &size);
		            ret += HPDF_Stream_Write (tmp_stream, (HPDF_BYTE *)&value, size);*/
		        }
				tmpTbl[i] = new HPDF_TTFTable();
		        tmpTbl[i].offset = newOffset;
		        tmpTbl[i].length = tmpStream.size - newOffset;
		
		    }

		    /* recalcurate checksum */
		    for (i = 0; i < HPDF_REQUIRED_TAGS_COUNT; i++)
		    {
		        tbl 	=	tmpTbl[i];
		        length 	= tbl.length; 
		        
		        // trace(" SaveFontData() tag["+REQUIRED_TAGS[i].toString()+" length=" + length.toString() );
				
				tmpStream.HPDF_Stream_Seek( tbl.offset,  HPDF_WhenceMode.HPDF_SEEK_SET );
		
		        tbl.checkSum = 0;
		        while (length > 0)
		        {
		            
		            var	rlen : uint = (length > 4) ? 4 : length;
		            bufu = 0;
		            
		            //bufu = new uint ( tmpStream.HPDF_Stream_Read( rlen ) )  ; 
		            var buff : ByteArray = tmpStream.HPDF_Stream_Read( rlen );
		            buff.position = 0; 
		            if (buff.length < 4) 
		            {
		            	// tworzymy nwoy 4 bajotowy buf
		            	var bufn : ByteArray = new ByteArray () ;
		            	
		            	bufn.writeBytes( buff);
		            	for ( var t : int = 0; t < 4 - buff.length ; t++ )
		            		 bufn.writeByte(0);
		            	buff = bufn;
		            	buff.position = 0; 
		            	var aa1: uint = buff.readByte();
		            	var aa2: uint = buff.readByte();
		            	var aa3: uint = buff.readByte();
		            	var aa4: uint = buff.readByte();
		            }
		            buff.position = 0;
		            bufu = buff.readUnsignedInt();
		            /*if ((ret = HPDF_Stream_Read (tmp_stream, (HPDF_BYTE *)&buf, &rlen))
		                    != HPDF_OK)
		                break;
					*
		            UINT32Swap (&buf);
		            */
		           //trace("buf =  " + bufu.toString() + " check = " + tbl.checkSum.toString() + "new " + (bufu+tbl).toString() + " length = " + length.toString() );
		            tbl.checkSum += bufu;
		            length -= rlen;
		        }

       

		       // trace(" SaveFontData tag[" + HPDF_FontDef_TT.REQUIRED_TAGS[i].toString() + " check-sum=" + tbl.checkSum.toString() + " offset=" + tbl.offset.toString() );
		        stream.HPDF_Stream_WriteStr( HPDF_FontDef_TT.REQUIRED_TAGS[i]  );
		        //ret += HPDF_Stream_Write (stream, (HPDF_BYTE *)REQUIRED_TAGS[i], 4);
		        stream.WriteUINT32 ( tbl.checkSum);
		        tbl.offset += offsetBase;
		        stream.WriteUINT32 ( tbl.offset);
		        stream.WriteUINT32 ( tbl.length);

	    }
	 	 /* calucurate checkSumAdjustment.*/
	    tmpStream.HPDF_Stream_Seek (0, HPDF_WhenceMode.HPDF_SEEK_SET);
	   
	    for (;;)
	    {
	        /*HPDF_UINT32 buf;
	        
	        HPDF_UINT siz = sizeof(buf);
	
	        ret = HPDF_Stream_Read (tmp_stream, (HPDF_BYTE *)&buf, &siz);
	        */
	        
		        try 
		        { 
			        bufu  = tmpStream.HPDF2_Stream_Read_UInt4() ;
			          
			        if ( bufu == -1 ) 
			        	break ; 
			        /*if (ret != HPDF_OK || siz <= 0) {
			            if (ret == HPDF_STREAM_EOF)
			                ret = HPDF_OK;
			            break;
			        }*/
			        //UINT32Swap (&buf);
			        tmpCheckSum -= bufu;
		       }
		       catch( e : Error ) {
		       	break;
		       }
		       
	    }

		   trace(" SaveFontData new checkSumAdjustment=" + tmpCheckSum.toString() ) ;
		
		   tmpStream.HPDF_Stream_Seek ( checkSumPtr,  HPDF_WhenceMode.HPDF_SEEK_SET);
		  //TODO  tmpStream.HPDF_MemStream_Rewrite( tmpCheckSum, 4) ;
		       /* C ret = HPDF_MemStream_Rewrite (tmp_stream, (HPDF_BYTE *)&tmp_check_sum,
		           4); */
		   
		    attr.length1 = tmpStream.size + offsetBase;
		    trace( "save font data tmpStream length = " + tmpStream.size.toString() ) ;
		    trace( "stream size = " + stream.size.toString() ); 
		    stream.HPDF_Stream_WriteToStream( tmpStream, 0, null);
		
			tmpStream = null ; 
		}
		
		/** 
		 * Write Header to the stream 
		 * */
		private	function WriteHeader ( stream : HPDF_Stream ) : uint 
		{
            var	attr : HPDF_TTFontDefAttr	=	this.attr as HPDF_TTFontDefAttr;
            var	checkSumPtr	: uint ; 
		    trace (" WriteHeader");
		
		    stream.HPDF_Stream_Write (attr.header.versionNumber); // length should be 4
		    stream.WriteUINT32 ( attr.header.fontRevision);
		
		    /* save the address of checkSumAdjustment.
		     * the value is rewrite to computed value after new check-sum-value is
		     * generated.
		     */
		    checkSumPtr = stream.size;
		
		    stream.WriteUINT32 (0);
		    stream.WriteUINT32 ( attr.header.magicNumber);
		    stream.WriteUINT16 ( attr.header.flags);
		    stream.WriteUINT16 ( attr.header.unitsPerEm);
		    stream.HPDF_Stream_Write ( attr.header.created); // len shoud be 8 
		    stream.HPDF_Stream_Write ( attr.header.modified );  // len shoud be 8
		    stream.WriteINT16 ( attr.header.xMin);
		    stream.WriteINT16 ( attr.header.yMin);
		    stream.WriteINT16 ( attr.header.xMax);
		    stream.WriteINT16 ( attr.header.yMax);
		    stream.WriteUINT16 ( attr.header.macStyle);
		    stream.WriteUINT16 ( attr.header.lowestRecPpem);
		    stream.WriteINT16 ( attr.header.fontDirectionHint);
		    stream.WriteINT16 ( attr.header.indexToLocFormat);
		    stream.WriteINT16 ( attr.header.glyphDataFormat);
		
		  	return checkSumPtr; 
		}
		
		/**
		 * RecreateGlyf
		 * */
		private	function	RecreateGLYF  ( newOffsets : Vector.<uint> , stream : HPDF_Stream ) : void
		{
                
                var saveOffset : uint = 0 ; 
			    var	startOffset : uint = stream.size;
			    var attr : HPDF_TTFontDefAttr	=	this.attr as  HPDF_TTFontDefAttr;
			    var	i : int ; 
			    			
			    trace (" RecreateGLYF start");

			    for (i = 0; i < attr.numGlyphs; i++)
			    {
			        if (attr.glyphTbl.flgs[i] == 1)
			        {
			            var	offset : uint	 = attr.glyphTbl.offsets[i];
			            var	len : uint	=	attr.glyphTbl.offsets[i + 1] - offset;
			
			            newOffsets[i] = stream.size - startOffset;
			            if (attr.header.indexToLocFormat == 0) {
			                newOffsets[i] /= 2;
			                len *= 2;
			            }
			
			            /*trace(" RecreateGLYF[" + (attr.glyphTbl.baseOffset + offset).toString() + "] move from " + 
			            		"[" + (attr.glyphTbl.baseOffset + offset).toString() + " ] to " + 
			            		"[" + newOffsets[i].toString() +"]" );
						*/			
			            if (attr.header.indexToLocFormat == 0)
			                offset *= 2;
			
			            offset += attr.glyphTbl.baseOffset;
			
			            attr.fontData.position	=	offset;
			             
			            while (len > 0)
			            {
			               	var tmpLen : uint = (len > HPDF_Conf.HPDF_STREAM_BUF_SIZ) ? HPDF_Conf.HPDF_STREAM_BUF_SIZ : len;
							var	buf : ByteArray = new ByteArray( ) ; 
							
			                /* C if ((ret = HPDF_Stream_Read (attr.stream, buf, &tmp_len))
			                        != HPDF_OK) */
			                attr.fontData.readBytes( buf, 0, tmpLen );
			                /*if ((ret = HPDF_Stream_Write (stream, buf, tmp_len)) !=
			                        HPDF_OK)
			                    return ret;
			                    */
			                stream.HPDF_Stream_Write( buf ); 
			
			                len -= tmpLen;
			            }
			
			            saveOffset = stream.size - startOffset;
			            if (attr.header.indexToLocFormat == 0)
			                saveOffset /= 2;
			        } else {
			            newOffsets[i] = saveOffset;
			        }
			    }
			
			    newOffsets[attr.numGlyphs] = saveOffset;
				trace (" RecreateGLYF end");
		} // RecreateGlyf end
		
		
		/** 
		 * Recreate Name
		 * */
		private	function	RecreateName  ( stream : HPDF_Stream ) : void
		{
		    var	attr : HPDF_TTFontDefAttr	=	this.attr as HPDF_TTFontDefAttr;
		    var	tbl : HPDF_TTFTable	=	FindTable("name");
			var	i	 : uint ; 
			var	nameRec : Vector.<HPDF_TTF_NameRecord> ;
			var	tmpStream	: HPDF_Stream	=	new HPDF_MemStream();  	    
		    
		    
		    trace (" RecreateName");
		
		    stream.WriteUINT16 ( attr.nameTbl.format);
		    stream.WriteUINT16 ( attr.nameTbl.count);
		    stream.WriteUINT16 ( attr.nameTbl.stringOffset);
		
		    nameRec = attr.nameTbl.nameRecords;
		    for (i = 0; i < attr.nameTbl.count; i++)
		    {
		    	var rec : HPDF_TTF_NameRecord = nameRec[i] ; 
		        var	nameLen : uint = rec.length;
		        var	buf : ByteArray = new ByteArray( ) ;  
		        var	tmpLen : uint = nameLen ; 
		        var offset : uint = tbl.offset + attr.nameTbl.stringOffset + rec.offset;
		        var	recOffset : uint = tmpStream.size ;  
		        trace(" i = " + i.toString() + " len = " + nameLen.toString() + " offset = " + recOffset.toString()) ; 
		        /* add suffix to font-name. */
		        if (rec.nameId == 1 || rec.nameId == 4)
		        {
		            if (rec.platformId == 0 || rec.platformId == 3) {
		                /*tmpStream.HPDF_Stream_Write ( (HPDF_BYTE *)attr.tagName2,
		                        sizeof(attr.tag_name2));
		                        */
		                var llen : uint = tmpStream.HPDF_Stream_WriteStrUTF( attr.tagName2 ) ; 
		                nameLen += llen ;  
		            } else {
		                tmpStream.HPDF_Stream_WriteStr( attr.tagName ) ; 
		                nameLen += attr.tagName.length; 
		            }
		        }
		
		        stream.WriteUINT16 ( rec.platformId);
		        stream.WriteUINT16 ( rec.encodingId);
		        stream.WriteUINT16 ( rec.languageId);
		        stream.WriteUINT16 ( rec.nameId);
		        stream.WriteUINT16 ( nameLen);
		        stream.WriteUINT16 ( recOffset);
		
		        attr.fontData.position	=	offset;
		
		        /* while (tmpLen > 0) {
		            HPDF_UINT len = (tmp_len > HPDF_STREAM_BUF_SIZ) ?
		                    HPDF_STREAM_BUF_SIZ : tmp_len;
			        var len : uint	=	 (tmp_len > HPDF_STREAM_BUF_SIZ) ?
		                    HPDF_STREAM_BUF_SIZ : tmp_len;
		            if ((ret = HPDF_Stream_Read (attr.stream, buf, &len)) != HPDF_OK) {
		                HPDF_Stream_Free (tmp_stream);
		                return ret;
		            }
		
		            if ((ret = HPDF_Stream_Write (tmp_stream, buf, len)) != HPDF_OK) {
		                HPDF_Stream_Free (tmp_stream);
		                return ret;
		            }
		
		            tmp_len -= len;
		        }
		        */
		        // I guess that this loop rewrites data using buf with a fixed len
		        // In AS3 we can try to read whole buf
		        buf = new ByteArray ( ) ; 
		        attr.fontData.readBytes( buf, 0 , tmpLen ); 
		        tmpStream.HPDF_Stream_Write( buf );  
		
		        /*trace(" RecreateNAME name_rec[" + i.toString() + "] platform_id=" + rec.platformId.toString() + 
		                        "encoding_id=" + rec.encodingId.toString() + " language_id=" + rec.languageId.toString() + 
		                        " name_rec.name_id= " + rec.nameId.toString() +
		                        "length=" + nameLen.toString() +" offset=" + recOffset.toString() );
		                        */
		
		    }
			tmpStream.HPDF_Stream_Seek(0, HPDF_WhenceMode.HPDF_SEEK_SET);
		    stream.HPDF_Stream_WriteToStream (tmpStream,HPDF_Stream.HPDF_STREAM_FILTER_NONE, null);
			tmpStream.HPDF_Stream_Free();
		} 
	}
}