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
package com.fxpdf.types
{
	import __AS3__.vec.Vector;
	
	public class HPDF_DashMode
	{
		
		public	var	ptn : Vector.<Number>;
    	public	var	numPtn : Number; 
    	public	var	phase : Number ; 
    	 
		public function HPDF_DashMode( ptn : Vector.<Number> =null , numPtn : Number=0, phase : Number=0 )
		{
				this.ptn	=	ptn; 
				this.numPtn	=	numPtn ; 
				this.phase	=	phase; 
		}
		public	static function getZeroDashMode ( ) : HPDF_DashMode
		{
			var ret : HPDF_DashMode	=	new HPDF_DashMode();
			ret.ptn	=	new Vector.<Number> ; //[ new Number(0),new Number(0),new Number(0),new Number(0),new Number(0),new Number(0),new Number(0),new Number(0)];
			ret.numPtn	=	0;
			ret.phase	=	0; 
			return ret; 
		}
		

	}
}