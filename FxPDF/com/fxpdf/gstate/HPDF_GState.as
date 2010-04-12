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
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.types.HPDF_CMYKColor;
	import com.fxpdf.types.HPDF_DashMode;
	import com.fxpdf.types.HPDF_RGBColor;
	import com.fxpdf.types.HPDF_TransMatrix;
	import com.fxpdf.types.enum.HPDF_ColorSpace;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	
	public class HPDF_GState
	{
		
		/** C 
		 *  HPDF_TransMatrix        trans_matrix;
		    HPDF_REAL               line_width;
		    HPDF_LineCap            line_cap;
		    HPDF_LineJoin           line_join;
		    HPDF_REAL               miter_limit;
		    HPDF_DashMode           dash_mode;
		    HPDF_REAL               flatness;
		
		    HPDF_REAL               char_space;
		    HPDF_REAL               word_space;
		    HPDF_REAL               h_scalling;
		    HPDF_REAL               text_leading;
		    HPDF_TextRenderingMode  rendering_mode;
		    HPDF_REAL               text_rise;
		
		    HPDF_ColorSpace         cs_fill;
		    HPDF_ColorSpace         cs_stroke;
		    HPDF_RGBColor           rgb_fill;
		    HPDF_RGBColor           rgb_stroke;
		    HPDF_CMYKColor          cmyk_fill;
		    HPDF_CMYKColor          cmyk_stroke;
		    HPDF_REAL               gray_fill;
		    HPDF_REAL               gray_stroke;
		
		    HPDF_Font               font;
		    HPDF_REAL               font_size;
		    HPDF_WritingMode        writing_mode;
		
		    HPDF_GState             prev;
		    HPDF_UINT               depth; 
		    *    */
		    
		    public	var	transMatrix:HPDF_TransMatrix
		    public	var	lineWidth: Number; 
		    public	var	lineCap : Number ;
		    public	var	lineJoin : Number ; 
		    public	var	miterLimit : Number; 
		    public	var	dashMode : HPDF_DashMode
		    public	var	flatness : Number ;
		
		    public	var	charSpace : Number ;
		    public	var	wordSpace : Number ;
		    public	var	hScalling : Number ;
		    public	var	textLeading : Number ;
		    public	var	renderingMode : Number ; 
		    public	var	textRise : Number ;
		
		    public	var	csFill : Number; 
		    public	var	csStroke : Number ; 
		    public	var	rgbFill : HPDF_RGBColor; 
		    public	var	rgbStroke : HPDF_RGBColor
		    public	var	cmykFill : HPDF_CMYKColor;
		    public	var	cmykStroke : HPDF_CMYKColor;
		    public	var	grayFill : Number ;
		    public	var	grayStroke : Number ;
		    
		    public	var	font : HPDF_Font ; 
		    public	var	fontSize : Number ;
		    public	var	writingMode : Number ; 
		
		    public	var	prev : HPDF_GState ; 
		    public	var	depth : Number ;
		    
		    
		public function HPDF_GState( current : HPDF_GState = null ) 
		{
			if ( current && current.depth >= HPDF_Consts.HPDF_LIMIT_MAX_GSTATE )
			{
				throw new HPDF_Error("Exceed GState limit" , HPDF_Error.HPDF_EXCEED_GSTATE_LIMIT, 0) ;
			}

		
		
		    if (current) 
		    {
		       this.transMatrix		=	current.transMatrix;
		       this.lineWidth		=	current.lineWidth;
		       this.lineCap			=	current.lineCap;
		       this.lineJoin		=	current.lineJoin;
		       this.miterLimit		=	current.miterLimit;
		       this.dashMode		=	current.dashMode;
		       this.flatness		=	current.flatness;
		
		       this.charSpace = current.charSpace;
		       this.wordSpace = current.wordSpace;
		       this.hScalling = current.hScalling;
		       this.textLeading = current.textLeading;
		       this.renderingMode = current.renderingMode;
		       this.textRise = current.textRise;
		
		       this.csStroke = current.csStroke;
		       this.csFill = current.csFill;
		       this.rgbFill = current.rgbFill;
		       this.rgbStroke = current.rgbStroke;
		       this.cmykFill = current.cmykFill;
		       this.cmykStroke = current.cmykStroke;
		       this.grayFill = current.grayFill;
		       this.grayStroke = current.grayStroke;
		
		       this.font = current.font;
		       this.fontSize = current.fontSize;
		
		       this.prev = current;
		       this.depth = current.depth + 1;
		    } else 
		    {
		        var defMatrix: HPDF_TransMatrix	= new HPDF_TransMatrix( 1,0,0,1,0,0);
		        var	defRgbColor : HPDF_RGBColor	=	new HPDF_RGBColor(0, 0, 0);
		        var	defCmykColor : HPDF_CMYKColor	=	new HPDF_CMYKColor(0, 0, 0, 0);
		        
		       var	defDashMode : HPDF_DashMode	=	HPDF_DashMode.getZeroDashMode(); // new HPDF_DashMode( new Vector.<Number>[0,0,0,0,0,0,0,0] , 0,0 );
		
		       this.transMatrix = defMatrix;
		       this.lineWidth = HPDF_Consts.HPDF_DEF_LINEWIDTH;
		       this.lineCap = HPDF_Consts.HPDF_DEF_LINECAP;
		       this.lineJoin = HPDF_Consts.HPDF_DEF_LINEJOIN;
		       this.miterLimit = HPDF_Consts.HPDF_DEF_MITERLIMIT;
		       this.dashMode = defDashMode ;
		       this.flatness = HPDF_Consts.HPDF_DEF_FLATNESS;
		
		       this.charSpace = HPDF_Consts.HPDF_DEF_CHARSPACE;
		       this.wordSpace = HPDF_Consts.HPDF_DEF_WORDSPACE;
		       this.hScalling = HPDF_Consts.HPDF_DEF_HSCALING;
		       this.textLeading = HPDF_Consts.HPDF_DEF_LEADING;
		       this.renderingMode = HPDF_Consts.HPDF_DEF_RENDERING_MODE;
		       this.textRise = HPDF_Consts.HPDF_DEF_RISE;
		
		
		       this.csStroke = HPDF_ColorSpace.HPDF_CS_DEVICE_GRAY;
		       this.csFill = HPDF_ColorSpace.HPDF_CS_DEVICE_GRAY;
		       this.rgbFill = defRgbColor;
		       this.rgbStroke = defRgbColor;
		       this.cmykFill = defCmykColor;
		       this.cmykStroke = defCmykColor;
		       this.grayFill = 0;
		       this.grayStroke = 0;
		
		       this.font = null;
		       this.fontSize = 0;
		       this.writingMode = HPDF_WritingMode.HPDF_WMODE_HORIZONTAL;
		
		       this.prev = null;
		       this.depth = 1;
		    }
		}
		
		public	function	HPDF_GState_Free( ) : HPDF_GState
		{
			return this.prev; 	
		}

	}
}