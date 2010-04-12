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
package com.fxpdf
{
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.types.HPDF_Point;
	import flash.utils.ByteArray;
	//import flash.utils.ByteArray;
	
	public class HPDF_Utils
	{
		public	static	const NEW_LINE : String = String.fromCharCode( 10 );
		
		
		public function HPDF_Utils()
		{
		}
		
		public	static	function	HPDF_ToPoint( x : Number, y : Number ) : HPDF_Point
		{
			return new HPDF_Point(x, y);
		}
		
		public	static	function	ParseString ( pStr : String ) : String
		{
			var ret: String	= new String( pStr );
			var idx : int = ret.indexOf( "\\" );
			while( idx >= 0) 
			{
				var tmp: String;
				tmp = ret.substr(0,idx);
				var octal : Number = new Number ( ret.substr(idx+1, 3 ) );
				var dec : Number = Math.floor( octal / 100) * 64;
				octal = octal - Math.floor( octal /100 ) * 100 ; 
				dec = dec +Math.floor( octal / 10) * 8;
				octal = octal - Math.floor( octal /10 ) * 10 ;
				dec = dec + octal; 
				
				tmp += String.fromCharCode( dec );
				tmp += ret.substr( idx+4, 0xffffff );
				ret = tmp ; 
				idx = ret.indexOf("\\");
			}
			return ret; 
		}
		
		
		
		public	static	function HPDF_NEEDS_ESCAPE ( c : String ) : Boolean
		{
			if ( c.charCodeAt(0) < 0x21 || c.charCodeAt(0) > 0x7e ) 
				return true;
				
			if ( c == "\\" ||
                 c == '%' || 
                 c == '#' || 
                 c == '/' || 
                 c == '(' || 
                 c == ')' || 
                 c == '<' || 
                 c == '>' || 
                 c == '[' || 
                 c == ']' || 
                 c == '{' || 
                 c == '}' ) 
                 	return true; 
               return false;
		}	
		
		public	static	function	HPDF_IS_WHITE_SPACE(c : uint) : Boolean
		{   
			if (c == 0x00 || 
             c == 0x09 || 
             c == 0x0A ||
             c == 0x0C || 
             c == 0x0D ||
             c == 0x20 )
             	return true;
             return false;  
	  }	
		
		public	static	function	IToA2( value : Number, len : int ) : String
		{
			var	 ret : String	=	value.toString(); 
			var l : uint	= ret.length; 
			if ( ret.length < len ) 
			{
				for (var i:int = 0 ; i < len -l-1 ; i++ ) 
					ret = "0" + ret; 	
			}
			return ret; 
			
		} 
		public	static	function	HPDF_IToA( value : Number ) : String
		{
			return Math.round( value ).toString() ; 
		}
		
		
		// TODO 
		// how to implement it the same way ?????
		public	static	function	HPDF_FToA( value : Number, len : uint = 0  ) : String
		{
			var tmp : Number = Math.round ( value * 1000 ) ;
			var r : Number  = tmp / 1000 ; 
			return r.toString(); 
			/*if ( tmp == value ) 
				return value.toString();
			else
				return (tmp/100).toFixed(3);
				*/ 	
		}
		
		
		public	static	function	StringToByteArray( text : String ) : ByteArray
		{
			var	ret	: ByteArray	=	new ByteArray; 
			for  ( var i:int = 0; i < text.length ; i ++ ) 
			{
				ret.writeByte( text.charCodeAt(i) );
				trace("wwrite byte : " + text.charAt(i).toString() ); 
			}
			ret.position = 0; 
			return ret; 
		}
		
		
			/* TEST THIS !!!! */
		public	static	function HPDF_UInt16Swap  ( value : uint ) : uint
		{
		  /*  HPDF_BYTE u[2];
		
		    HPDF_MemCpy (u, (HPDF_BYTE*)value, 2);
		    *value = (HPDF_UINT16)((HPDF_UINT16)u[0] << 8 | (HPDF_UINT16)u[1]);
		    */
		    return value ; 
		}
			
			
			
		/**
		 * Reads one line from byte array
		 * */
		public	static	function ByteArrayReadLn( ba : ByteArray ) : String
		{
			
			var buf : String = new String ; 
			var readSize : uint ;
			var byte : uint  = 0;
			var line : String = "";  

	
   			trace(" ByteArrayReadLn");

		    if (!ba)
		        throw new HPDF_Error("ByteArrayReadLn", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
		        
			while (byte != 	0x0A && byte != 0x0D && ba.bytesAvailable > 0 )
			{
			    byte = ba.readByte();
			    if ( byte != 0x0A && byte != 0x0D )
			    	line += String.fromCharCode( byte );
			}
			return line ; 
        } // end ByteArrayReadLn
			
		

	}
}