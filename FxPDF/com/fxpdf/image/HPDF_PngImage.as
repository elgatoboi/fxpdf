/*
* Source used from a project PurePDF under the terms of LGPL licence 
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Alessandro Crugnola $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (Wt, 02 lut 2010) $
* $URL: http://purepdf.googlecode.com/svn/tags/0.20.20100205/src/org/purepdf/Font.as $
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package com.fxpdf.image
{
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Binary;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Object;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.streams.HPDF_MemStream;
	import com.fxpdf.streams.HPDF_MemStreamAttr;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.enum.HPDF_ColorSpace;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	
	public class HPDF_PngImage extends HPDF_Image
	{
		
		public static const IDAT: String = "IDAT";
		public static const IEND: String = "IEND";
		public static const IHDR: String = "IHDR";
		public static const PLTE: String = "PLTE";
		public static const PNGID: Vector.<int> = Vector.<int>( [ 137, 80, 78, 71, 13, 10, 26, 10 ] );
		public static const cHRM: String = "cHRM";
		public static const gAMA: String = "gAMA";
		public static const iCCP: String = "iCCP";
		public static const pHYs: String = "pHYs";
		public static const sRGB: String = "sRGB";
		public static const tRNS: String = "tRNS";
		private static const PNG_FILTER_AVERAGE: int = 3;
		private static const PNG_FILTER_NONE: int = 0;
		private static const PNG_FILTER_PAETH: int = 4;
		private static const PNG_FILTER_SUB: int = 1;
		private static const PNG_FILTER_UP: int = 2;
		private static const TRANSFERSIZE: int = 4096;
		//private static const intents: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.PERCEPTUAL, PdfName.RELATIVECOLORIMETRIC, PdfName.SATURATION, PdfName.ABSOLUTECOLORIMETRIC ] );
		private var XYRatio: Number;
		//private var additional: PdfDictionary = new PdfDictionary();
		private var additional		:Array  = [];
		private var colorspaceTable	:HPDF_Array;
		private var bitDepth: int;
		private var bytesPerPixel: int; // private var of: number private var per: bytes private var pixel: input
		private var colorTable: Bytes;
		private var colorType: int;
		private var compressionMethod: int;
		private var dataStream:DataInputStream;
		private var dpiX: int;
		private var dpiY: int;
		private var filterMethod: int;
		private var gamma: Number = 1.0;
		private var genBWMask: Boolean;
		private var hasCHRM: Boolean = false;
		private var idat: ByteBuffer = new ByteBuffer();
		private var image: Bytes;
		private var inputBands: int;
		private var ins: ByteArrayInputStream;
		//private var intent: PdfName;
		private var intent :HPDF_Name;
		//private var decodeParams:HPDF_Dict; 
		private var interlaceMethod: int;
		private var palShades: Boolean;
		private var smask: Bytes;
		private var trans: Bytes;
		private var transBlue: int = -1;
		private var transGreen: int = -1;
		private var transRedGray: int = -1;
		private var xW: Number, yW: Number, xR: Number, yR: Number, xG: Number, yG: Number, xB: Number, yB: Number;
		private var deflated:Boolean = false; 
		
		
		private function checkMarker( s: String ): Boolean
		{
			if ( s.length != 4 )
				return false;
			
			for ( var k: int = 0; k < 4; ++k )
			{
				var c: int = s.charCodeAt( k );
				
				if ( ( c < 'a'.charCodeAt( 0 ) || c > 'z'.charCodeAt( 0 ) ) && ( c < 'A'.charCodeAt( 0 ) || c > 'Z'.charCodeAt( 0 ) ) )
					return false;
			}
			return true;
		}
		
		private function decodeIdat(): void
		{
			var nbitDepth: int = bitDepth;
			
			if ( nbitDepth == 16 )
				nbitDepth = 8;
			var size: int = -1;
			bytesPerPixel = ( bitDepth == 16 ) ? 2 : 1;
			
			switch ( colorType )
			{
				case 0:
					size = ( nbitDepth * width + 7 ) / 8 * height;
					break;
				case 2:
					size = width * 3 * height;
					bytesPerPixel *= 3;
					break;
				case 3:
					if ( interlaceMethod == 1 )
						size = ( nbitDepth * width + 7 ) / 8 * height;
					bytesPerPixel = 1;
					break;
				case 4:
					size = width * height;
					bytesPerPixel *= 2;
					break;
				case 6:
					size = width * 3 * height;
					bytesPerPixel *= 4;
					break;
			}
			
			if ( size >= 0 )
			{
				image = new Bytes( size );
			}
			
			if ( palShades )
			{
				smask = new Bytes( width * height );
			}
			else if ( genBWMask )
			{
				smask = new Bytes( ( width + 7 ) / 8 * height );
			}
			var bb: Bytes = new Bytes();
			bb.buffer = idat.getBuffer();
			var bai: ByteArrayInputStream = new ByteArrayInputStream( idat.getBuffer(), 0, idat.getBuffer().length );
			var infStream: InputStream = new InflaterInputStream( bai );
			
			dataStream = new DataInputStream( infStream );
			
			if ( interlaceMethod != 1 )
			{
				decodePass2( 0, 0, 1, 1, width, height );
			}
			else
			{
				decodePass2( 0, 0, 8, 8, ( width + 7 ) / 8, ( height + 7 ) / 8 );
				decodePass2( 4, 0, 8, 8, ( width + 3 ) / 8, ( height + 7 ) / 8 );
				decodePass2( 0, 4, 4, 8, ( width + 3 ) / 4, ( height + 3 ) / 8 );
				decodePass2( 2, 0, 4, 4, ( width + 1 ) / 4, ( height + 3 ) / 4 );
				decodePass2( 0, 2, 2, 4, ( width + 1 ) / 2, ( height + 1 ) / 4 );
				decodePass2( 1, 0, 2, 2, width / 2, ( height + 1 ) / 2 );
				decodePass2( 0, 1, 1, 2, width, height / 2 );
			}
		}
		
		private function decodePass( xOffset: int, yOffset: int, xStep: int, yStep: int, passWidth: int, passHeight: int ): void
		{
			if ( ( passWidth == 0 ) || ( passHeight == 0 ) )
			{
				return;
			}
			var bytesPerRow: int = ( inputBands * passWidth * bitDepth + 7 ) / 8;
			var curr: Bytes = new Bytes( bytesPerRow );
			var prior: Bytes = new Bytes( bytesPerRow );
			var srcY: int, dstY: int;
			
			for ( srcY = 0, dstY = yOffset; srcY < passHeight; srcY++, dstY += yStep )
			{
				var filter: int = 0;
				
				try
				{
					filter = dataStream.readUnsignedByte();
					dataStream.readFully( curr.buffer, 0, bytesPerRow );
				}
				catch ( e: Error )
				{
					trace( e.getStackTrace() );
				}
				trace(" y= " + srcY.toString()  + " filter " + filter.toString( )); 
				
				switch ( filter )
				{
					case PNG_FILTER_NONE:
						break;
					case PNG_FILTER_SUB:
						decodeSubFilter( curr, bytesPerRow, bytesPerPixel );
						break;
					case PNG_FILTER_UP:
						decodeUpFilter( curr, prior, bytesPerRow );
						break;
					case PNG_FILTER_AVERAGE:
						throw new Error();
						//decodeAverageFilter( curr, prior, bytesPerRow, bytesPerPixel );
						break;
					case PNG_FILTER_PAETH:
						decodePaethFilter( curr, prior, bytesPerRow, bytesPerPixel );
						break;
					default:
						// Error -- uknown filter type
						throw new Error( "unknown png filter" );
				}
				processPixels( curr, xOffset, xStep, dstY, passWidth );
				var tmp: Bytes = prior;
				prior = curr;
				curr = tmp;
			}
		}
		
		/**
		 * Decode function modified not to use FZLIb 
		 * */
		private function decodePass2( xOffset: int, yOffset: int, xStep: int, yStep: int, passWidth: int, passHeight: int ): void
		{
			if ( ( passWidth == 0 ) || ( passHeight == 0 ) )
			{
				return;
			}
			var bytesPerRow: int = ( inputBands * passWidth * bitDepth + 7 ) / 8;
			var curr: Bytes = new Bytes( bytesPerRow );
			var prior: Bytes = new Bytes( bytesPerRow );
			var srcY: int, dstY: int;
			
			var uncopressedIdat : ByteArray = new ByteArray();
			uncopressedIdat.length  = idat.getBuffer().length; 
			idat.getBuffer().position = 0; 
			idat.getBuffer().readBytes( uncopressedIdat, 0 , idat.getBuffer().length );
			uncopressedIdat.uncompress() ;
			
			
			for ( srcY = 0, dstY = yOffset; srcY < passHeight; srcY++, dstY += yStep )
			{
				var filter: int = 0;
				
				
				try
				{
					/* filter = buffer.readUnsignedByte();
					buffer.readBytes( curr.buffer, 0 , bytesPerRow ); */
					filter = uncopressedIdat.readUnsignedByte();
					//dataStream.readFully( curr.buffer, 0, bytesPerRow );
					uncopressedIdat.readBytes( curr.buffer, 0 , bytesPerRow ) ; 
					
				}
				catch ( e: Error )
				{
					trace( e.getStackTrace() );
				}
				switch ( filter )
				{
					case PNG_FILTER_NONE:
						break;
					case PNG_FILTER_SUB:
						decodeSubFilter( curr, bytesPerRow, bytesPerPixel );
						break;
					case PNG_FILTER_UP:
						decodeUpFilter( curr, prior, bytesPerRow );
						break;
					case PNG_FILTER_AVERAGE:
						throw new Error();
						//decodeAverageFilter( curr, prior, bytesPerRow, bytesPerPixel );
						break;
					case PNG_FILTER_PAETH:
						decodePaethFilter( curr, prior, bytesPerRow, bytesPerPixel );
						break;
					default:
						//break;
						// Error -- uknown filter type
						throw new Error( "unknown png filter" );
				}
				processPixels( curr, xOffset, xStep, dstY, passWidth );
				var tmp: Bytes = prior;
				prior = curr;
				curr = tmp;
			}
		}
		
		public function getColorspace():HPDF_Object
		{
			if ( gamma == 1 && !hasCHRM )
			{
				if ( ( colorType & 2 ) == 0 )
					return new HPDF_Name("DeviceGray");
				else
					return new HPDF_Name("DeviceRGB");
			}
			else
			{
				//var array: PdfArray = new PdfArray();
				var array:HPDF_Array = new HPDF_Array();
				//var dic: PdfDictionary = new PdfDictionary();
				var dic:HPDF_Dict = new HPDF_Dict();
				
				if ( ( colorType & 2 ) == 0 )
				{
					if ( gamma == 1 )
						return new HPDF_Name("DeviceGray");
					//array.add( PdfName.CALGRAY );
					array.HPDF_Array_Add( new HPDF_Name( "CalGray" ));
					//dic.put( PdfName.GAMMA, new PdfNumber( gamma ) );
					dic.HPDF_Dict_Add( "Gamma", new HPDF_Number( gamma ));
					//dic.put( PdfName.WHITEPOINT, new PdfLiteral( "[1 1 1]" ) );
					dic.HPDF_Dict_Add( "WhitePoint", new HPDF_String("[1 1 1]") );
					//array.add( dic );
					array.HPDF_Array_Add( dic );
				}
				else
				{
					//var wp: PdfObject = new PdfLiteral( "[1 1 1]" );
					var wp:Object = new HPDF_String("[1 1 1]");
					//array.add( PdfName.CALRGB );
					array.HPDF_Array_Add( new HPDF_Name( "CalRGB") );
					
					if ( gamma != 1 )
					{
						//var gm: PdfArray = new PdfArray();
						var gm:HPDF_Array = new HPDF_Array; 
						//var n: PdfNumber = new PdfNumber( gamma );
						
						//gm.add( n );
						//gm.add( n );
						//gm.add( n );
						
						gm.HPDF_Array_AddReal( gamma );
						gm.HPDF_Array_AddReal( gamma );
						gm.HPDF_Array_AddReal( gamma );
						//dic.put( PdfName.GAMMA, gm );
						dic.HPDF_Dict_Add( "Gamma", gm );
					}
					
					if ( hasCHRM )
					{
						var z: Number = yW * ( ( xG - xB ) * yR - ( xR - xB ) * yG + ( xR - xG ) * yB );
						var YA: Number = yR * ( ( xG - xB ) * yW - ( xW - xB ) * yG + ( xW - xG ) * yB ) / z;
						var XA: Number = YA * xR / yR;
						var ZA: Number = YA * ( ( 1 - xR ) / yR - 1 );
						var YB: Number = -yG * ( ( xR - xB ) * yW - ( xW - xB ) * yR + ( xW - xR ) * yB ) / z;
						var XB: Number = YB * xG / yG;
						var ZB: Number = YB * ( ( 1 - xG ) / yG - 1 );
						var YC: Number = yB * ( ( xR - xG ) * yW - ( xW - xG ) * yW + ( xW - xR ) * yG ) / z;
						var XC: Number = YC * xB / yB;
						var ZC: Number = YC * ( ( 1 - xB ) / yB - 1 );
						var XW: Number = XA + XB + XC;
						var YW: Number = 1;
						var ZW: Number = ZA + ZB + ZC;
						
						//var wpa: PdfArray = new PdfArray();
						var wpa:HPDF_Array = new HPDF_Array();
						
						/*wpa.add( new PdfNumber( XW ) );
						wpa.add( new PdfNumber( YW ) );
						wpa.add( new PdfNumber( ZW ) );
						*/
						wpa.HPDF_Array_AddReal(  XW );
						wpa.HPDF_Array_AddReal(  YW );
						wpa.HPDF_Array_AddReal(  ZW );
						wp = wpa;
						//var matrix: PdfArray = new PdfArray();
						var matrix :HPDF_Array = new HPDF_Array();
						/*matrix.add( new PdfNumber( XA ) );
						matrix.add( new PdfNumber( YA ) );
						matrix.add( new PdfNumber( ZA ) );
						matrix.add( new PdfNumber( XB ) );
						matrix.add( new PdfNumber( YB ) );
						matrix.add( new PdfNumber( ZB ) );
						matrix.add( new PdfNumber( XC ) );
						matrix.add( new PdfNumber( YC ) );
						matrix.add( new PdfNumber( ZC ) );
						dic.put( PdfName.MATRIX, matrix );
						*/
						matrix.HPDF_Array_AddReal( XA  ) ;
						matrix.HPDF_Array_AddReal( YA  ) ;
						matrix.HPDF_Array_AddReal( ZA  ) ;
						matrix.HPDF_Array_AddReal( XB  ) ;
						matrix.HPDF_Array_AddReal( YB  ) ;
						matrix.HPDF_Array_AddReal( ZB  ) ;
						matrix.HPDF_Array_AddReal( XC  ) ;
						matrix.HPDF_Array_AddReal( YC  ) ;
						matrix.HPDF_Array_AddReal( ZC  ) ;
						dic.HPDF_Dict_Add( "Matrix", matrix );
					}
					//dic.put( PdfName.WHITEPOINT, wp );
					dic.HPDF_Dict_Add( "WhitePoint", wp );
					//array.add( dic );
					array.HPDF_Array_Add( dic );
				}
				return array;
			}
		}
		
		
		//private function getImage(): ImageElement
		private function loadImage():void
		{
			readPng();
			var pal0: int = 0;
			var palIdx: int = 0;
			//var im2: ImageElement;
			palShades = false;
			
			if ( trans != null )
			{
				for ( var k: int = 0; k < trans.length; ++k )
				{
					var n: int = trans[ k ] & 0xff;
					
					if ( n == 0 )
					{
						++pal0;
						palIdx = k;
					}
					
					if ( n != 0 && n != 255 )
					{
						palShades = true;
						break;
					}
				}
			}
			
			if ( ( colorType & 4 ) != 0 )
				palShades = true;
			genBWMask = ( !palShades && ( pal0 > 1 || transRedGray >= 0 ) );
			
			if ( !palShades && !genBWMask && pal0 == 1 )
			{
				var maskArray :HPDF_Array = new HPDF_Array();
				maskArray.HPDF_Array_AddReal(0);
				maskArray.HPDF_Array_AddReal(0);
				additional.push( { name:"Mask", obj:maskArray } );
			}
			
			var needDecode: Boolean = ( interlaceMethod == 1 ) || ( bitDepth == 16 ) || ( ( colorType & 4 ) != 0 ) || palShades || genBWMask;
			
			switch ( colorType )
			{
				case 0:
					inputBands = 1;
					break;
				case 2:
					inputBands = 3;
					break;
				case 3:
					inputBands = 1;
					break;
				case 4:
					inputBands = 2;
					break;
				case 6:
					inputBands = 4;
					break;
			}
			
			if ( needDecode )
				decodeIdat();
			/** PC **/
			//else
				
				
			var components: int = inputBands;
			
			if ( ( colorType & 4 ) != 0 )
				--components;
			var bpc: int = bitDepth;
			
			if ( bpc == 16 )
				bpc = 8;
			
			//var img: ImageElement;
			bitsPerComponent = bpc; 
			
			if ( image != null )
			{
				if ( colorType == 3 )
					null;
					//img = new ImageRaw( null, width, height, components, bpc, image.buffer );
				else
					null;
					//img = ImageElement.getRawInstance( width, height, components, bpc, image.buffer );
			}
			else
			{
				/** PC **/
				image = idat.toByteArray();
				//img = new ImageRaw( null, width, height, components, bpc, idat.toByteArray().buffer );
				deflated = true;
				
				/*var decodeparms: PdfDictionary = new PdfDictionary();
				decodeparms.put( PdfName.BITSPERCOMPONENT, new PdfNumber( bitDepth ) );
				decodeparms.put( PdfName.PREDICTOR, new PdfNumber( 15 ) );
				decodeparms.put( PdfName.COLUMNS, new PdfNumber( width ) );
				decodeparms.put( PdfName.COLORS, new PdfNumber( ( colorType == 3 || ( colorType & 2 ) == 0 ) ? 1 : 3 ) );
				*/
				var decodeparams :HPDF_Dict = new HPDF_Dict();
				decodeparams.HPDF_Dict_AddNumber( "BitsPerComponent", bitDepth );
				decodeparams.HPDF_Dict_AddNumber( "Predictor", 15 );
				decodeparams.HPDF_Dict_AddNumber( "Columns", width );
				decodeparams.HPDF_Dict_AddNumber( "Colors", ( colorType == 3 || ( colorType & 2 ) == 0 ) ? 1 : 3  );
				additional.push( { name:"DecodeParms", obj:decodeparams } );
				//additional.put( PdfName.DECODEPARMS, decodeparms );
			}
			
			/*if ( additional.getValue( PdfName.COLORSPACE ) == null ) {
				additional.put( PdfName.COLORSPACE, getColorspace() );
			}*/
			var hasColorspace :Boolean = false; 
			for each ( var ob:Object in additional ) { 
				if  (ob.name == "ColorSpace")
					hasColorspace = true; 
			}
			if ( !hasColorspace ) 
				additional.push( {name:"ColorSpace", obj:getColorspace()} ); 
			
			if ( intent != null )
				additional.push( "Intent", intent); 
			/*
			if ( additional.size > 0 )
				img.additional = additional;
			
			if ( palShades )
			{
				im2 = ImageElement.getRawInstance( width, height, 1, 8, smask.buffer );
				im2.makeMask();
				img.imageMask = im2;
			}
			
			if ( genBWMask )
			{
				im2 = ImageElement.getRawInstance( width, height, 1, 1, smask.buffer );
				im2.makeMask();
				img.imageMask = im2;
			}
			img.setDpi( dpiX, dpiY );
			img.xyRatio = XYRatio;
			img.originalType = ImageElement.ORIGINAL_PNG;
			return img;
			*/
		}
		
		private function getPixel( curr:Bytes ): Vector.<int>
		{
			var out: Vector.<int>;
			var k: int;
			
			switch ( bitDepth )
			{
				case 8:
				{
					out = new Vector.<int>( curr.length );
					
					for ( k = 0; k < out.length; ++k )
						out[ k ] = curr[ k ] & 0xff;
					return out;
				}
				case 16:
				{
					out = new Vector.<int>( curr.length / 2 );
					
					for ( k = 0; k < out.length; ++k )
						out[ k ] = ( ( curr[ k * 2 ] & 0xff ) << 8 ) + ( curr[ k * 2 + 1 ] & 0xff );
					return out;
				}
				default:
				{
					out = new Vector.<int>( curr.length * 8 / bitDepth );
					var idx: int = 0;
					var passes: int = 8 / bitDepth;
					var mask: int = ( 1 << bitDepth ) - 1;
					
					for ( k = 0; k < curr.length; ++k )
					{
						for ( var j: int = passes - 1; j >= 0; --j )
						{
							out[ idx++ ] = ( curr[ k ] >>> ( bitDepth * j ) ) & mask;
						}
					}
					return out;
				}
			}
		}
		
		private function processPixels( curr: Bytes, xOffset: int, step: int, y: int, width: int ): void
		{
			//trace('processPixels', y );
			var srcX: int;
			var dstX: int;
			var out: Vector.<int> = this.getPixel( curr );
			var sizes: int = 0;
			var yStride: int;
			var k: int;
			var v: Vector.<int>;
			var idx: int;
			
			switch ( colorType )
			{
				case 0:
				case 3:
				case 4:
					sizes = 1;
					break;
				case 2:
				case 6:
					sizes = 3;
					break;
			}
			
			if ( image != null )
			{
				dstX = xOffset;
				yStride = ( sizes * this.width * ( bitDepth == 16 ? 8 : bitDepth ) + 7 ) / 8;
				
				for ( srcX = 0; srcX < width; srcX++ )
				{
					setPixel( image, out, inputBands * srcX, sizes, dstX, y, bitDepth, yStride );
					dstX += step;
				}
			}
			
			if ( palShades )
			{
				if ( ( colorType & 4 ) != 0 )
				{
					if ( bitDepth == 16 )
					{
						for ( k = 0; k < width; ++k )
							out[ k * inputBands + sizes ] >>>= 8;
					}
					yStride = this.width;
					dstX = xOffset;
					
					for ( srcX = 0; srcX < width; srcX++ )
					{
						setPixel( smask, out, inputBands * srcX + sizes, 1, dstX, y, 8, yStride );
						dstX += step;
					}
				}
				else
				{ //colorType 3
					yStride = this.width;
					v = new Vector.<int>( 1 );
					dstX = xOffset;
					
					for ( srcX = 0; srcX < width; srcX++ )
					{
						idx = out[ srcX ];
						
						if ( idx < trans.length )
							v[ 0 ] = trans[ idx ];
						else
							v[ 0 ] = 255; // Patrick Valsecchi
						setPixel( smask, v, 0, 1, dstX, y, 8, yStride );
						dstX += step;
					}
				}
			}
			else if ( genBWMask )
			{
				switch ( colorType )
				{
					case 3:
					{
						yStride = ( this.width + 7 ) / 8;
						v = new Vector.<int>( 1 );
						dstX = xOffset;
						
						for ( srcX = 0; srcX < width; srcX++ )
						{
							idx = out[ srcX ];
							v[ 0 ] = ( ( idx < trans.length && trans[ idx ] == 0 ) ? 1 : 0 );
							setPixel( smask, v, 0, 1, dstX, y, 1, yStride );
							dstX += step;
						}
						break;
					}
					case 0:
					{
						yStride = ( this.width + 7 ) / 8;
						v = new Vector.<int>( 1 );
						dstX = xOffset;
						
						for ( srcX = 0; srcX < width; srcX++ )
						{
							var g: int = out[ srcX ];
							v[ 0 ] = ( g == transRedGray ? 1 : 0 );
							setPixel( smask, v, 0, 1, dstX, y, 1, yStride );
							dstX += step;
						}
						break;
					}
					case 2:
					{
						yStride = ( this.width + 7 ) / 8;
						v = new Vector.<int>( 1 );
						dstX = xOffset;
						
						for ( srcX = 0; srcX < width; srcX++ )
						{
							var markRed: int = inputBands * srcX;
							v[ 0 ] = ( out[ markRed ] == transRedGray && out[ markRed + 1 ] == transGreen && out[ markRed + 2 ] == transBlue ? 1 : 0 );
							setPixel( smask, v, 0, 1, dstX, y, 1, yStride );
							dstX += step;
						}
						break;
					}
				}
			}
		}
		
		private function readPng(): void
		{
			for ( var i: int = 0; i < PNGID.length; i++ )
			{
				if ( PNGID[ i ] != ins.readUnsignedByte() )
				{
					throw new Error( "file is not a valid png" );
				}
			}
			var buffer: Bytes = new Bytes( TRANSFERSIZE );
			var k: int;
			
			while ( true )
			{
				var len: int = getInt( ins );
				
				//trace( len, ins.position );
				var marker: String = getString( ins );
				
				if ( len < 0 || !checkMarker( marker ) )
					throw new Error( "corrupted png file" );
				
				if ( IDAT == marker )
				{
					var size: int;
					
					while ( len != 0 )
					{
						size = ins.readBytes( buffer.buffer, 0, Math.min( len, TRANSFERSIZE ) );
						
						if ( size < 0 )
							return;
						idat.writeBytes( buffer, 0, size );
						len -= size;
					}
				}
				else if ( tRNS == marker )
				{
					switch ( colorType )
					{
						case 0:
							if ( len >= 2 )
							{
								len -= 2;
								var gray: int = getWord( ins );
								
						/* TODO		if ( bitDepth == 16 )
									transRedGray = gray;
								else
									additional.put( PdfName.MASK, new PdfLiteral( "[" + gray + " " + gray + "]" ) );
								*/
							}
							break;
						case 2:
							if ( len >= 6 )
							{
								len -= 6;
								var red: int = getWord( ins );
								var green: int = getWord( ins );
								var blue: int = getWord( ins );
								
								if ( bitDepth == 16 )
								{
									transRedGray = red;
									transGreen = green;
									transBlue = blue;
								}
								else
								{
					/* TODO				additional.put( PdfName.MASK, new PdfLiteral( "[" + red + " " + red + " " + green + " " + green + " " + blue + " " + blue + "]" ) ); */
								}
							}
							break;
						case 3:
							if ( len > 0 )
							{
								trans = new Bytes();
								
								for ( k = 0; k < len; ++k )
									trans[ k ] = ins.readUnsignedByte();
								len = 0;
							}
							break;
					}
					ins.skip( len );
				}
				else if ( IHDR == marker )
				{
					width = getInt( ins );
					height = getInt( ins );
					bitDepth = ins.readUnsignedByte();
					colorType = ins.readUnsignedByte();
					compressionMethod = ins.readUnsignedByte();
					filterMethod = ins.readUnsignedByte();
					interlaceMethod = ins.readUnsignedByte();
				}
				else if ( PLTE == marker )
				{
					if ( colorType == 3 )
					{
						
						colorspaceTable = new HPDF_Array();
						
						colorspaceTable.HPDF_Array_AddName("Indexed");
						
						colorspaceTable.HPDF_Array_Add(  getColorspace() );
						colorspaceTable.HPDF_Array_AddReal( (len/3 -1) );
						
						var colortable		:ByteArray = new ByteArray;
						
						while ( ( len-- ) > 0 )
						{
							colortable.writeByte( ins.readUnsignedByte() );
						}
						
						var colorBinary:HPDF_Binary = new HPDF_Binary( colortable );

						colorspaceTable.HPDF_Array_Add( colorBinary );
						
						additional.push( {name:"ColorSpace", obj:colorspaceTable } );
					}
					else
					{
						ins.skip( len );
					}
				}
				else if ( pHYs == marker )
				{
					var dx: int = getInt( ins );
					var dy: int = getInt( ins );
					var unit: int = ins.readUnsignedByte();
					
					if ( unit == 1 )
					{
						dpiX = ( dx * 0.0254 + 0.5 );
						dpiY = ( dy * 0.0254 + 0.5 );
					}
					else
					{
						if ( dy != 0 )
							XYRatio = Number( dx ) / Number( dy );
					}
				}
				else if ( cHRM == marker )
				{
					xW = getInt( ins ) / 100000;
					yW = getInt( ins ) / 100000;
					xR = getInt( ins ) / 100000;
					yR = getInt( ins ) / 100000;
					xG = getInt( ins ) / 100000;
					yG = getInt( ins ) / 100000;
					xB = getInt( ins ) / 100000;
					yB = getInt( ins ) / 100000;
					hasCHRM = !( Math.abs( xW ) < 0.0001 || Math.abs( yW ) < 0.0001 || Math.abs( xR ) < 0.0001 || Math.abs( yR ) < 0.0001 || Math.abs( xG ) < 0.0001 || Math.abs( yG ) < 0.0001 || Math.abs( xB ) < 0.0001 || Math.abs( yB ) < 0.0001 );
				}
				else if ( sRGB == marker )
				{
					var ri: int = ins.readUnsignedByte();
			//TODO		intent = intents[ ri ];
					gamma = 2.2;
					xW = 0.3127;
					yW = 0.329;
					xR = 0.64;
					yR = 0.33;
					xG = 0.3;
					yG = 0.6;
					xB = 0.15;
					yB = 0.06;
					hasCHRM = true;
				}
				else if ( gAMA == marker )
				{
					var gm: int = getInt( ins );
					
					if ( gm != 0 )
					{
						gamma = 100000 / gm;
						
						if ( !hasCHRM )
						{
							xW = 0.3127;
							yW = 0.329;
							xR = 0.64;
							yR = 0.33;
							xG = 0.3;
							yG = 0.6;
							xB = 0.15;
							yB = 0.06;
							hasCHRM = true;
						}
					}
				}
				else if ( iCCP == marker )
				{
					do
					{
						--len;
					} while ( ins.readUnsignedByte() != 0 );
					ins.readUnsignedByte();
					--len;
					var icccom: Bytes = new Bytes( len );
					var p: int = 0;
					
					while ( len > 0 )
					{
						var r: int = ins.readBytes( icccom.buffer, p, len );
						
						if ( r < 0 )
							throw new Error( "premature end of file" );
						p += r;
						len -= r;
					}
				}
				else if ( IEND == marker )
				{
					break;
				}
				else
				{
					ins.skip( len );
				}
				ins.skip( 4 );
			}
		}
		
	/*	public static function getImage( data: ByteArray ): ImageElement
		{
			var ins: ByteArrayInputStream = new ByteArrayInputStream( data );
			var png :HPDF_PngImage = new HPDF_PngImage( ins );
			png.
			var img: ImageElement = png.getImage();
			img.originalData = data;
			return img;
		}
		*/
		
		public static function getInt( ins: ByteArrayInputStream ): int
		{
			return ( ins.readUnsignedByte() << 24 ) + ( ins.readUnsignedByte() << 16 ) + ( ins.readUnsignedByte() << 8 ) + ins.readUnsignedByte();
		}
		
		public static function getString( ins: ByteArrayInputStream ): String
		{
			var buf: String = "";
			
			for ( var i: int = 0; i < 4; i++ )
			{
				buf += String.fromCharCode( ins.readUnsignedByte() );
			}
			return buf;
		}
		
		public static function getWord( ins: ByteArrayInputStream ): int
		{
			return ( ins.readUnsignedByte() << 8 ) + ins.readUnsignedByte();
		}
		
		protected static function getPixel( image: Bytes, x: int, y: int, bitDepth: int, bytesPerRow: int ): int
		{
			var pos: int;
			var v: int;
			
			if ( bitDepth == 8 )
			{
				pos = bytesPerRow * y + x;
				return image[ pos ] & 0xff;
			}
			else
			{
				pos = bytesPerRow * y + x / ( 8 / bitDepth );
				v = image[ pos ] >> ( 8 - bitDepth * ( x % ( 8 / bitDepth ) ) - bitDepth );
				return v & ( ( 1 << bitDepth ) - 1 );
			}
		}
		
		protected static function setPixel( image: Bytes, data: Vector.<int>, offset: int, size: int, x: int, y: int, bitDepth: int, bytesPerRow: int ): void
		{
			var pos: int;
			var k: int;
			
			if ( bitDepth == 8 )
			{
				pos = bytesPerRow * y + size * x;
				
				for ( k = 0; k < size; ++k )
					image[ pos + k ] = data[ k + offset ];
			}
			else if ( bitDepth == 16 )
			{
				pos = bytesPerRow * y + size * x;
				
				for ( k = 0; k < size; ++k )
					image[ pos + k ] = ( data[ k + offset ] >>> 8 );
			}
			else
			{
				pos = bytesPerRow * y + x / ( 8 / bitDepth );
				var v: int = data[ offset ] << ( 8 - bitDepth * ( x % ( 8 / bitDepth ) ) - bitDepth );
				image[ pos ] |= v;
			}
		}
		
		private static function decodePaethFilter( curr: Bytes, prev: Bytes, count: int, bpp: int ): void
		{
			var raw: int;
			var priorPixel: int;
			var priorRow: int;
			var priorRowPixel: int;
			var i: int;
			
			for ( i = 0; i < bpp; i++ )
			{
				raw = curr[ i ] & 0xff;
				priorRow = prev[ i ] & 0xff;
				curr[ i ] = ( raw + priorRow );
			}
			
			for ( i = bpp; i < count; i++ )
			{
				raw = curr[ i ] & 0xff;
				priorPixel = curr[ i - bpp ] & 0xff;
				priorRow = prev[ i ] & 0xff;
				priorRowPixel = prev[ i - bpp ] & 0xff;
				curr[ i ] = ( raw + paethPredictor( priorPixel, priorRow, priorRowPixel ) );
			}
		}
		
		private static function decodeSubFilter( curr: Bytes, count: int, bpp: int ): void
		{
			var val: int;
			
			for ( var i: int = bpp; i < count; i++ )
			{
				val = curr[ i ] & 0xff;
				val += curr[ i - bpp ] & 0xff;
				curr[ i ] = val;
			}
		}
		
		private static function decodeUpFilter( curr: Bytes, prev: Bytes, count: int ): void
		{
			var raw: int;
			var prior: int;
			
			for ( var i: int = 0; i < count; i++ )
			{
				raw = curr[ i ] & 0xff;
				prior = prev[ i ] & 0xff;
				curr[ i ] = ( raw + prior );
			}
		}
		
		private static function paethPredictor( a: int, b: int, c: int ): int
		{
			var p: int = a + b - c;
			var pa: int = Math.abs( p - a );
			var pb: int = Math.abs( p - b );
			var pc: int = Math.abs( p - c );
			
			if ( ( pa <= pb ) && ( pa <= pc ) )
			{
				return a;
			}
			else if ( pb <= pc )
			{
				return b;
			}
			else
			{
				return c;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		public function HPDF_PngImage(xref:HPDF_Xref, data:ByteArray )
		{
			super(xref);
			var ins: ByteArrayInputStream = new ByteArrayInputStream( data );
			this.ins = ins; 
			
			
			//this.originalData = data; 
		}
		
		
		
		/**
		 * Loads new png image from byte array
		 * */
		public static function LoadPngImageFromByteArray( xref:HPDF_Xref, source:ByteArray ):HPDF_PngImage
		{
			trace("HPDF_LoadPngImageFromByteArray");
			
			var image:HPDF_PngImage = new HPDF_PngImage( xref, source);
			image.loadImage( );
			
			/** Add to xref **/
			//image.HPDF_Dict_Add("ColorSpace", image.getColorspace() );
			// Add with height
			image.HPDF_Dict_AddNumber("Width", image.width);
			image.HPDF_Dict_AddNumber("Height", image.height);
			image.HPDF_Dict_AddNumber("BitsPerComponent", image.bitsPerComponent);
			//image.additional
			for each( var ob:Object in image.additional ){ 
				image.HPDF_Dict_Add( ob.name, ob.obj );
			}
			if ( image.deflated ) { 
				image.HPDF_Dict_AddName("Filter", "FlateDecode");
			}
			
			// write stream data
			/*var idatlen:uint = image.idat.toByteArray().buffer.length;
			var b0:int = image.idat.toByteArray().buffer[0];
			var b1:int = image.idat.toByteArray().buffer[1];
			var b2:int = image.idat.toByteArray().buffer[2];
			var b3:int = image.idat.toByteArray().buffer[3];
			
			//image.stream.WriteFunc( image.idat.toByteArray().buffer );
			image.getPixel( image.
			*/
			var idatlen:uint = image.image.buffer.length;
			var b0:int = image.image.buffer[0];
			var b1:int = image.image.buffer[1];
			var b2:int = image.image.buffer[2];
			var b3:int = image.image.buffer[3];
			
			image.stream.WriteFunc( image.image.buffer );
			
			return image;
			
		}
		
		
			
			
			// C png_byte header[HPDF_PNG_BYTES_TO_CHECK];
			/*var header 			:ByteArray  = HPDF_Utils.createByteArray( HPDF_PNG_BYTES_TO_CHECK );
			var len				:uint = HPDF_PNG_BYTES_TO_CHECK;
			
			
			trace (" HPDF_Image_LoadPngImage");
			
			source.position = 0;
			source.readBytes( header, 0, len );
			
			//HPDF_Stream_Read (png_data, header, &len);
			if ( png_sig_cmp (header, (png_size_t)0, HPDF_PNG_BYTES_TO_CHECK) ) { 
				throw new HPDF_Error("HPDF_LoadPngImageFromByteArray", HPDF_Error.HPDF_INVALID_PNG_IMAGE );
			}
			
			var image 	:HPDF_PngImage = new HPDF_PngImage( this.xref );
			
			image.LoadPngData ( source );
			
			/**if ( compressionMode & HPDF_Consts.HPDF_COMP_IMAGE)
				image.filter = HPDF_Stream.HPDF_STREAM_FILTER_FLATE_DECODE;
			*/
			
			/*return image;
		}
		*/
		
		
		
		
	}
}