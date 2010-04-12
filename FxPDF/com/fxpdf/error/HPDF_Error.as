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
package com.fxpdf.error
{
	/** represents error object */
	/** equals to HPDF_Error_Rec type in C */
	
	
	public class HPDF_Error extends Error
	{
		
/**		 HPDF_STATUS             error_no;
		    HPDF_STATUS             detail_no;
		    HPDF_Error_Handler      error_fn;
		    void                    *user_data; 
	*/	    
	
		/* error-code */
		public	static	const	HPDF_OK	: Number = 0; 
	public static const HPDF_ARRAY_COUNT_ERR                       : Number = 0x1001;
	public static const HPDF_ARRAY_ITEM_NOT_FOUND                  : Number = 0x1002;
	public static const HPDF_ARRAY_ITEM_UNEXPECTED_TYPE            : Number = 0x1003;
	public static const HPDF_BINARY_LENGTH_ERR                     : Number = 0x1004;
	public static const HPDF_CANNOT_GET_PALLET                     : Number = 0x1005;
	public static const HPDF_DICT_COUNT_ERR                        : Number = 0x1007;
	public static const HPDF_DICT_ITEM_NOT_FOUND                   : Number = 0x1008;
	public static const HPDF_DICT_ITEM_UNEXPECTED_TYPE             : Number = 0x1009;
	public static const HPDF_DICT_STREAM_LENGTH_NOT_FOUND          : Number = 0x100A;
	public static const HPDF_DOC_ENCRYPTDICT_NOT_FOUND             : Number = 0x100B;
	public static const HPDF_DOC_INVALID_OBJECT                    : Number = 0x100C;
	/*                                                 : Number = 0x100D */
	public static const HPDF_DUPLICATE_REGISTRATION                : Number = 0x100E;
	public static const HPDF_EXCEED_JWW_CODE_NUM_LIMIT             : Number = 0x100F;
	/*                                                 : Number = 0x1010 */
	public static const HPDF_ENCRYPT_INVALID_PASSWORD              : Number = 0x1011;
	/*                                                 : Number = 0x1012 */
	public static const HPDF_ERR_UNKNOWN_CLASS                     : Number = 0x1013;
	public static const HPDF_EXCEED_GSTATE_LIMIT                   : Number = 0x1014;
	public static const HPDF_FAILD_TO_ALLOC_MEM                    : Number = 0x1015;
	public static const HPDF_FILE_IO_ERROR                         : Number = 0x1016;
	public static const HPDF_FILE_OPEN_ERROR                       : Number = 0x1017;
	/*                                                 : Number = 0x1018 */
	public static const HPDF_FONT_EXISTS                           : Number = 0x1019;
	public static const HPDF_FONT_INVALID_WIDTHS_TABLE             : Number = 0x101A;
	public static const HPDF_INVALID_AFM_HEADER                    : Number = 0x101B;
	public static const HPDF_INVALID_ANNOTATION                    : Number = 0x101C;
	/*                                                 : Number = 0x101D */
	public static const HPDF_INVALID_BIT_PER_COMPONENT             : Number = 0x101E;
	public static const HPDF_INVALID_CHAR_MATRICS_DATA             : Number = 0x101F;
	public static const HPDF_INVALID_COLOR_SPACE                   : Number = 0x1020;
	public static const HPDF_INVALID_COMPRESSION_MODE              : Number = 0x1021;
	public static const HPDF_INVALID_DATE_TIME                     : Number = 0x1022;
	public static const HPDF_INVALID_DESTINATION                   : Number = 0x1023;
	/*                                                 : Number = 0x1024 */
	public static const HPDF_INVALID_DOCUMENT                      : Number = 0x1025;
	public static const HPDF_INVALID_DOCUMENT_STATE                : Number = 0x1026;
	public static const HPDF_INVALID_ENCODER                       : Number = 0x1027;
	public static const HPDF_INVALID_ENCODER_TYPE                  : Number = 0x1028;
	/*                                                 : Number = 0x1029 */
	/*                                                 : Number = 0x102A */
	public static const HPDF_INVALID_ENCODING_NAME                 : Number = 0x102B;
	public static const HPDF_INVALID_ENCRYPT_KEY_LEN               : Number = 0x102C;
	public static const HPDF_INVALID_FONTDEF_DATA                  : Number = 0x102D;
	public static const HPDF_INVALID_FONTDEF_TYPE                  : Number = 0x102E;
	public static const HPDF_INVALID_FONT_NAME                     : Number = 0x102F;
	public static const HPDF_INVALID_IMAGE                         : Number = 0x1030;
	public static const HPDF_INVALID_JPEG_DATA                     : Number = 0x1031;
	public static const HPDF_INVALID_N_DATA                        : Number = 0x1032;
	public static const HPDF_INVALID_OBJECT                        : Number = 0x1033;
	public static const HPDF_INVALID_OBJ_ID                        : Number = 0x1034;
	public static const HPDF_INVALID_OPERATION                     : Number = 0x1035;
	public static const HPDF_INVALID_OUTLINE                       : Number = 0x1036;
	public static const HPDF_INVALID_PAGE                          : Number = 0x1037;
	public static const HPDF_INVALID_PAGES                         : Number = 0x1038;
	public static const HPDF_INVALID_PARAMETER                     : Number = 0x1039;
	/*                                                 : Number = 0x103A */
	public static const HPDF_INVALID_PNG_IMAGE                     : Number = 0x103B;
	public static const HPDF_INVALID_STREAM                        : Number = 0x103C;
	public static const HPDF_MISSING_FILE_NAME_ENTRY               : Number = 0x103D;
	/*                                                 : Number = 0x103E */
	public static const HPDF_INVALID_TTC_FILE                      : Number = 0x103F;
	public static const HPDF_INVALID_TTC_INDEX                     : Number = 0x1040;
	public static const HPDF_INVALID_WX_DATA                       : Number = 0x1041;
	public static const HPDF_ITEM_NOT_FOUND                        : Number = 0x1042;
	public static const HPDF_LIBPNG_ERROR                          : Number = 0x1043;
	public static const HPDF_NAME_INVALID_VALUE                    : Number = 0x1044;
	public static const HPDF_NAME_OUT_OF_RANGE                     : Number = 0x1045;
	/*                                                 : Number = 0x1046 */
	/*                                                 : Number = 0x1047 */
	public static const HPDF_PAGE_INVALID_PARAM_COUNT              : Number = 0x1048;
	public static const HPDF_PAGES_MISSING_KIDS_ENTRY              : Number = 0x1049;
	public static const HPDF_PAGE_CANNOT_FIND_OBJECT               : Number = 0x104A;
	public static const HPDF_PAGE_CANNOT_GET_ROOT_PAGES            : Number = 0x104B;
	public static const HPDF_PAGE_CANNOT_RESTORE_GSTATE            : Number = 0x104C;
	public static const HPDF_PAGE_CANNOT_SET_PARENT                : Number = 0x104D;
	public static const HPDF_PAGE_FONT_NOT_FOUND                   : Number = 0x104E;
	public static const HPDF_PAGE_INVALID_FONT                     : Number = 0x104F;
	public static const HPDF_PAGE_INVALID_FONT_SIZE                : Number = 0x1050;
	public static const HPDF_PAGE_INVALID_GMODE                    : Number = 0x1051;
	public static const HPDF_PAGE_INVALID_INDEX                    : Number = 0x1052;
	public static const HPDF_PAGE_INVALID_ROTATE_VALUE             : Number = 0x1053;
	public static const HPDF_PAGE_INVALID_SIZE                     : Number = 0x1054;
	public static const HPDF_PAGE_INVALID_XOBJECT                  : Number = 0x1055;
	public static const HPDF_PAGE_OUT_OF_RANGE                     : Number = 0x1056;
	public static const HPDF_REAL_OUT_OF_RANGE                     : Number = 0x1057;
	public static const HPDF_STREAM_EOF                            : Number = 0x1058;
	public static const HPDF_STREAM_READLN_CONTINUE                : Number = 0x1059;
	/*                                                 : Number = 0x105A */
	public static const HPDF_STRING_OUT_OF_RANGE                   : Number = 0x105B;
	public static const HPDF_THIS_FUNC_WAS_SKIPPED                 : Number = 0x105C;
	public static const HPDF_TTF_CANNOT_EMBEDDING_FONT             : Number = 0x105D;
	public static const HPDF_TTF_INVALID_CMAP                      : Number = 0x105E;
	public static const HPDF_TTF_INVALID_FOMAT                     : Number = 0x105F;
	public static const HPDF_TTF_MISSING_TABLE                     : Number = 0x1060;
	public static const HPDF_UNSUPPORTED_FONT_TYPE                 : Number = 0x1061;
	public static const HPDF_UNSUPPORTED_FUNC                      : Number = 0x1062;
	public static const HPDF_UNSUPPORTED_JPEG_FORMAT               : Number = 0x1063;
	public static const HPDF_UNSUPPORTED_TYPE1_FONT                : Number = 0x1064;
	public static const HPDF_XREF_COUNT_ERR                        : Number = 0x1065;
	public static const HPDF_ZLIB_ERROR                            : Number = 0x1066;
	public static const HPDF_INVALID_PAGE_INDEX                    : Number = 0x1067;
	public static const HPDF_INVALID_URI                           : Number = 0x1068;
	public static const HPDF_PAGE_LAYOUT_OUT_OF_RANGE              : Number = 0x1069;
	public static const HPDF_PAGE_MODE_OUT_OF_RANGE                : Number = 0x1070;
	public static const HPDF_PAGE_NUM_STYLE_OUT_OF_RANGE           : Number = 0x1071;
	public static const HPDF_ANNOT_INVALID_ICON                    : Number = 0x1072;
	public static const HPDF_ANNOT_INVALID_BORDER_STYLE            : Number = 0x1073;
	public static const HPDF_PAGE_INVALID_DIRECTION                : Number = 0x1074;
	public static const HPDF_INVALID_FONT                          : Number = 0x1075;
	public static const HPDF_PAGE_INSUFFICIENT_SPACE               : Number = 0x1076;
	public static const HPDF_PAGE_INVALID_DISPLAY_TIME             : Number = 0x1077;
	public static const HPDF_PAGE_INVALID_TRANSITION_TIME          : Number = 0x1078;
	public static const HPDF_INVALID_PAGE_SLIDESHOW_TYPE           : Number = 0x1079;
	public static const HPDF_EXT_GSTATE_OUT_OF_RANGE               : Number = 0x1080;
	public static const HPDF_INVALID_EXT_GSTATE                    : Number = 0x1081;
	public static const HPDF_EXT_GSTATE_READ_ONLY                  : Number = 0x1082;
	public static const HPDF_INVALID_U3D_DATA                      : Number = 0x1083;


		public	var	errorNo	: int ; 
		public	var	detailNo : int ; 
		public 	var	errorFn : Function ;  
		    
		public	var	userData : Object ; 
		
		public function HPDF_Error(message:String="", id:int=0, pDetailNo  :Number = 0 )
		{
			super(message, id);
			errorNo	=	id; 
			detailNo	=	pDetailNo ;
		}
		
		public function	HPDF_Error_Init( userData : Object ):void
		{
			this.userData	=	userData; 
		}
		
		
		public	function	HPDF_Error_Reset ( ) : void
		{
			 this.errorNo	=	0;
			 this.detailNo	=	0;
    	}
    	
    	
    	public	function	HPDF_SetError ( errorNo : Number, detailNo:Number ) : Number
    	{
    		this.errorNo	=	errorNo;
    		this.detailNo	=	detailNo;
    		
    		return errorNo; 		
    	}

	}
}