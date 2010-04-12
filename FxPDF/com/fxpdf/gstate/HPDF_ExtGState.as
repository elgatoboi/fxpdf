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
package com.fxpdf.gstate
{
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.enum.HPDF_BlendMode;
	import com.fxpdf.xref.HPDF_Xref;

	public class HPDF_ExtGState extends HPDF_Dict
	{
		private	static const HPDF_BM_NAMES:Array = [
                                      "Normal",
                                      "Multiply",
                                      "Screen",
                                      "Overlay",
                                      "Darken",
                                      "Lighten",
                                      "ColorDodge",
                                      "ColorBurn",
                                      "HardLight",
                                      "SoftLight",
                                      "Difference",
                                      "Exclusion"
                                      ];
                                      
                                      
		public function HPDF_ExtGState( xref : HPDF_Xref )
		{
			super();
			trace (" HPDF_ExtGState_New");
			xref.HPDF_Xref_Add( this ); 
			this.HPDF_Dict_AddName ( "Type", "ExtGState");
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_EXT_GSTATE;
		}
		
		
		public function HPDF_ExtGState_Validate() : Boolean
		{
			var h:HPDF_Obj_Header
			if ( header.objClass != (HPDF_Obj_Header.HPDF_OSUBCLASS_EXT_GSTATE | HPDF_Obj_Header.HPDF_OCLASS_DICT) &&
                 header.objClass != (HPDF_Obj_Header.HPDF_OSUBCLASS_EXT_GSTATE_R | HPDF_Obj_Header.HPDF_OCLASS_DICT))
                 return false;
            return true; 
                 
		}
		
		public function ExtGState_Check() : void
		{
			if ( !HPDF_ExtGState_Validate())
				throw new HPDF_Error("ExtGState_Check - invalid");
			
			if  (header.objClass ==  (HPDF_Obj_Header.HPDF_OSUBCLASS_EXT_GSTATE_R | HPDF_Obj_Header.HPDF_OCLASS_DICT))
				throw new HPDF_Error("ExtGState_Check",HPDF_Error.HPDF_EXT_GSTATE_READ_ONLY,0);
			
		}
		
		public function HPDF_ExtGState_SetAlphaStroke( value :Number ) : void
		{
			ExtGState_Check();
			if ( value < 0 || value > 1.0)
        	throw new HPDF_Error("HPDF_ExtGState_SetAlphaStroke",HPDF_Error.HPDF_EXT_GSTATE_OUT_OF_RANGE,0);
             
             this.HPDF_Dict_AddReal( "CA", value );
		}
		
		public function HPDF_ExtGState_SetAlphaFill( value :Number ) : void
		{
			ExtGState_Check();
			if ( value < 0 || value > 1.0)
        	throw new HPDF_Error("HPDF_ExtGState_SetAlphaFill",HPDF_Error.HPDF_EXT_GSTATE_OUT_OF_RANGE,0);
             
             this.HPDF_Dict_AddReal( "ca", value );
		}
		
		public function HPDF_ExtGState_SetBlendMode( value :Number ) : void
		{
			ExtGState_Check();
			
			if ( value < 0 || value > HPDF_BlendMode.HPDF_BM_EOF)
        	throw new HPDF_Error("HPDF_ExtGState_SetBlendMode",HPDF_Error.HPDF_EXT_GSTATE_OUT_OF_RANGE,0);
             
             this.HPDF_Dict_AddName( "BM", HPDF_BM_NAMES[value] );
		}
		
		
	}
}