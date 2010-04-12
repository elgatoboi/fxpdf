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
	import __AS3__.vec.Vector;
	
	public class HPDF_TTF_CmapRange
	{
		public var format	: uint ; 
        public var length	: uint ; 
        public var language	: uint ; 
        public var segCountX2	: uint ; 
        public var searchRange	: uint ; 
        public var entrySelector	: uint ; 
        public var rangeShift	: uint ; 
        public var endCount : Vector.<uint> ; 
        public var reservedPad	: uint ; 
        public var startCount : Vector.<uint>;
        public var idDelta : Vector.<int> ; 
        public var idRangeOffset : Vector.<uint>;
        public var glyphIdArray : Vector.<uint>;
        public var glyphIdArrayCount: uint ;  
        
        
		public function HPDF_TTF_CmapRange()
		{
		}

	}
}