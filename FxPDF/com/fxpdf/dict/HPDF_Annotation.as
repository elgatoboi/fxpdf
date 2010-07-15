package com.fxpdf.dict
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.encrypt.HPDF_ARC4_Ctx;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Boolean;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.HPDF_Rect;
	import com.fxpdf.types.enum.HPDF_AnnotHighlightMode;
	import com.fxpdf.types.enum.HPDF_AnnotIcon;
	import com.fxpdf.types.enum.HPDF_AnnotType;
	import com.fxpdf.types.enum.HPDF_BSSubtype;
	import com.fxpdf.xref.HPDF_Xref;

	public class HPDF_Annotation extends HPDF_Dict
	{
		public static const HPDF_ANNOT_TYPE_NAMES : Array = [
			"Text",
			"Link",
			"Sound",
			"FreeText",
			"Stamp",
			"Square",
			"Circle",
			"StrikeOut",
			"Highlight",
			"Underline",
			"Ink",
			"FileAttachment",
			"Popup" ];
		
		
		
		public static const HPDF_ANNOT_ICON_NAMES_NAMES : Array = [
			"Comment",
			"Key",
			"Note",
			"Help",
			"NewParagraph",
			"Paragraph",
			"Insert" ]; 
		

		
		public function HPDF_Annotation( xref : HPDF_Xref , type : uint, rect : HPDF_Rect)
		{
			super();
			
			var array			: HPDF_Array;
			var tmp				: Number;
			
			trace(" HPDF_Annotation_New");
			
			
			xref.HPDF_Xref_Add (this);
			
			array = new HPDF_Array();
			
			HPDF_Dict_Add ("Rect", array);
			
			if (rect.top < rect.bottom) {
				tmp = rect.top;
				rect.top = rect.bottom;
				rect.bottom = tmp;
			}
			
			array.HPDF_Array_AddReal ( rect.left);
			array.HPDF_Array_AddReal ( rect.bottom);
			array.HPDF_Array_AddReal ( rect.right);
			array.HPDF_Array_AddReal ( rect.top);
			
			HPDF_Dict_AddName ( "Type", "Annot");
			HPDF_Dict_AddName ( "Subtype", HPDF_ANNOT_TYPE_NAMES[type]);
			
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_ANNOTATION;
		}
		
		
		public function HPDF_Annotation_SetBorderStyle  (subtype:uint   , width:Number, dash_on : uint, dash_off : uint, dash_phase : uint ) : void
		{
			var bs		: HPDF_Dict;
			var dash	: HPDF_Array;
			
			
			trace(" HPDF_Annotation_SetBoderStyle");
			
			bs = new HPDF_Dict ();
			
			HPDF_Dict_Add ( "BS", bs);
			
			if (subtype == HPDF_BSSubtype.HPDF_BS_DASHED) 
			{
				dash = new HPDF_Array ();
				
				bs.HPDF_Dict_Add ( "D", dash);
				
				bs.HPDF_Dict_AddName ( "Type", "Border");
				dash.HPDF_Array_AddReal ( dash_on);
				dash.HPDF_Array_AddReal ( dash_off);
				
				if (dash_phase  != 0)
					dash.HPDF_Array_AddReal ( dash_off);
			}
			
			switch (subtype) {
				case HPDF_BSSubtype.HPDF_BS_SOLID:
					bs.HPDF_Dict_AddName ( "S", "S");
					break;
				case HPDF_BSSubtype.HPDF_BS_DASHED:
					bs.HPDF_Dict_AddName ( "S", "D");
					break;
				case HPDF_BSSubtype.HPDF_BS_BEVELED:
					bs.HPDF_Dict_AddName ( "S", "B");
					break;
				case HPDF_BSSubtype.HPDF_BS_INSET:
					bs.HPDF_Dict_AddName ( "S", "I");
					break;
				case HPDF_BSSubtype.HPDF_BS_UNDERLINED:
					bs.HPDF_Dict_AddName ("S", "U");
					break;
				default:
					throw new HPDF_Error("HPDF_Annotation_SetBoderStyle", HPDF_Error.HPDF_ANNOT_INVALID_BORDER_STYLE, 0);
			}
			
			if (width != HPDF_Consts.HPDF_BS_DEF_WIDTH )
				bs.HPDF_Dict_AddReal ( "W", width);
			
		}
		
		
		public static function HPDF_LinkAnnot_New  ( xref : HPDF_Xref , rect : HPDF_Rect, dst : HPDF_Destination ) : HPDF_Annotation 
		{
			var annot	: HPDF_Annotation;
			
			trace(" HPDF_LinkAnnot_New");
			
			annot = new HPDF_Annotation ( xref, HPDF_AnnotType.HPDF_ANNOT_LINK, rect);
			
			annot.HPDF_Dict_Add ( "Dest", dst);
			
			return annot;
		}
		
		
		public static function HPDF_URILinkAnnot_New  ( xref : HPDF_Xref , rect : HPDF_Rect, uri : String ) : HPDF_Annotation
		{
			var annot	: HPDF_Annotation;
			var action	: HPDF_Dict;
			
			
			trace(" HPDF_URILinkAnnot_New");
			
			annot = new HPDF_Annotation ( xref, HPDF_AnnotType.HPDF_ANNOT_LINK, rect);
			
			/* create action dictionary */
			action = new HPDF_Dict ();
			
			annot.HPDF_Dict_Add ( "A", action);
			
			action.HPDF_Dict_AddName ( "Type", "Action");
			action.HPDF_Dict_AddName ( "S", "URI");
			action.HPDF_Dict_Add ( "URI", new HPDF_String ( uri,null));
						
			return annot;
		}
		
		public function HPDF_LinkAnnot_SetBorderStyle  (width : Number, dash_on : uint,dash_off : uint ):void
		{
			var array		: HPDF_Array; 
			
			trace(" HPDF_LinkAnnot_SetBorderStyle");
			
			if (!CheckSubType ( HPDF_AnnotType.HPDF_ANNOT_LINK))
				throw new HPDF_Error("HPDF_INVALID_ANNOTATION");
			
			if (width < 0)
				throw new HPDF_Error("HPDF_LinkAnnot_SetBorderStyle",HPDF_Error.HPDF_INVALID_PARAMETER, 0);
			
			array = new HPDF_Array();
						
			HPDF_Dict_Add ( "Border", array);
			
			array.HPDF_Array_AddNumber ( 0);
			array.HPDF_Array_AddNumber ( 0);
			array.HPDF_Array_AddReal ( width);
			
			
			if (dash_on && dash_off) {
				var dash	: HPDF_Array = new HPDF_Array();
				
				array.HPDF_Array_Add ( dash);
				
				dash.HPDF_Array_AddNumber (dash_on);
				dash.HPDF_Array_AddNumber ( dash_off);
			}
			
		}
		
		public function HPDF_LinkAnnot_SetHighlightMode  (mode :uint ) : void
		{
			
			trace(" HPDF_LinkAnnot_SetHighlightMode");
			
			if ( !CheckSubType ( HPDF_AnnotType.HPDF_ANNOT_LINK))
				throw new HPDF_Error("HPDF_INVALID_ANNOTATION");
			
			switch (mode) {
				case HPDF_AnnotHighlightMode.HPDF_ANNOT_NO_HIGHTLIGHT:
					HPDF_Dict_AddName ( "H", "N");
					break;
				case HPDF_AnnotHighlightMode.HPDF_ANNOT_INVERT_BORDER:
					HPDF_Dict_AddName ( "H", "O");
					break;
				case HPDF_AnnotHighlightMode.HPDF_ANNOT_DOWN_APPEARANCE:
					HPDF_Dict_AddName ( "H", "P");
					break;
				default:  /* HPDF_ANNOT_INVERT_BOX */
					/* default value */
					HPDF_Dict_RemoveElement ( "H");
			}
			
		}
		
		public static function	HPDF_TextAnnot_New  (xref : HPDF_Xref , rect : HPDF_Rect, text : String, encoder : HPDF_Encoder ) : HPDF_Annotation
			
		{
			var annot	: HPDF_Annotation;
			var s		: HPDF_String;
			
			trace(" HPDF_TextAnnot_New");
			
			annot = new HPDF_Annotation ( xref, HPDF_AnnotType.HPDF_ANNOT_TEXT_NOTES, rect);
			
			
			s = new HPDF_String( text, encoder );
			
			annot.HPDF_Dict_Add ( "Contents", s);
			
			return annot;
		}
		
		
		public function HPDF_TextAnnot_SetIcon  (annot : HPDF_Annotation , icon : uint ) 
		{
			trace((" HPDF_TextAnnot_SetIcon\n"));
			
			if (!annot.CheckSubType ( HPDF_AnnotType.HPDF_ANNOT_TEXT_NOTES))
				throw new HPDF_Error("HPDF_INVALID_ANNOTATION");
			
			if (icon < 0 || icon >= HPDF_AnnotIcon.HPDF_ANNOT_ICON_EOF)
				throw new HPDF_Error("HPDF_TextAnnot_SetIcon", HPDF_Error.HPDF_ANNOT_INVALID_ICON, icon);
			
			annot.HPDF_Dict_AddName ( "Name", HPDF_ANNOT_ICON_NAMES_NAMES[icon]) ; 
		}
		
		
		public function HPDF_TextAnnot_SetOpened  (annot : HPDF_Annotation , opened : HPDF_Boolean ) 
		{
			var b: HPDF_Boolean; 
			
			trace(" HPDF_TextAnnot_SetOpend");
			
			if (!annot.CheckSubType ( HPDF_AnnotType.HPDF_ANNOT_TEXT_NOTES))
				throw new HPDF_Error("HPDF_INVALID_ANNOTATION");
			
			b = new HPDF_Boolean (opened);
			
			annot.HPDF_Dict_Add ( "Open", b);
		}
		
		
		public function HPDF_Annotation_Validate () : Boolean
		{
			trace(" HPDF_Annotation_Validate");
			
			
			if (header.objClass !=	(HPDF_Obj_Header.HPDF_OSUBCLASS_ANNOTATION | HPDF_Obj_Header.HPDF_OCLASS_DICT))
				return false;
			
			return true;
		}
		
		public function CheckSubType ( type : uint ) : Boolean
		{
			var subtype		: HPDF_Name;
			
			trace(" HPDF_Annotation_CheckSubType");
			
			if (!HPDF_Annotation_Validate ())
				return false;
			
			subtype = HPDF_Dict_GetItem ( "Subtype", HPDF_Obj_Header.HPDF_OCLASS_NAME) as HPDF_Name;
			
			if (!subtype ||(subtype.value != HPDF_ANNOT_TYPE_NAMES[type]) )  {
				throw new HPDF_Error("HPDF_Annotation_CheckSubType", HPDF_Error.HPDF_INVALID_ANNOTATION, 0);
				return false;
			}
			
			return true;
		}
	}
}