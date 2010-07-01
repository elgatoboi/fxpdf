package com.fxpdf.dict
{
	import com.fxpdf.objects.HPDF_Obj_Header;

	public class HPDF_Null extends HPDF_Dict
	{
		public function HPDF_Null()
		{
			super();
			header.objClass = HPDF_Obj_Header.HPDF_OCLASS_NULL;
		}
	}
}