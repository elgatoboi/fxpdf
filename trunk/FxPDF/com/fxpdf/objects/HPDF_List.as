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
package com.fxpdf.objects
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.error.HPDF_Error;
	
	public class HPDF_List
	{
		
		/** C   HPDF_UINT       block_siz;
      HPDF_UINT       items_per_block;
      HPDF_UINT       count;
      void            **obj; */
      
      	public	var	blockSiz : Number ; 
      	public	var	itemsPerBlock : Number ; 
      	// public	var	count :  Number ; 
      	public	var	obj : Array; // Array of arrays
      	
      	/** Oryginalna wersja ma podzial danych nabloki 
      	 * probujemy zrobic tobez takiegopodzialu*/
      
		public function HPDF_List(  pItemsPerBlock : Number )
		{
			blockSiz		=	0 ; 
        	itemsPerBlock	=	pItemsPerBlock <= 0 ? HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK : pItemsPerBlock ;
        	// count			=	0; 
        	// obj 			=	null ;
        	obj	=	new Array( ); 
        }
        
        public	function	get count ( ) :uint
        {
        	return obj.length ; 
        }
        public	function	HPDF_List_Add( item : Object ) : void
        {
        	/*if ( count > blockSiz ){
        		Resize ( blockSiz + itemsPerBlock );
        	}*/
        	obj.push( item );
        }
        
		public function HPDF_List_Insert  ( target : Object, item : Object ) : void
		{
			var targetIdx	: int = HPDF_List_Find( target ) ;
			var lastItem	: Object = this.obj[count - 1]; 
			var i 			: int ; 
			
			
			trace(" HPDF_List_Insert");
			
			if (targetIdx < 0)
				throw new HPDF_Error("HPDF_List_Insert", HPDF_Error.HPDF_ITEM_NOT_FOUND, 0);
			
			/* move the item of the list to behind one by one. */
			for (i = count - 2; i >= targetIdx; i--)
				obj[i + 1] = obj[i];
			
			obj[targetIdx] = item;
			
			HPDF_List_Add (lastItem);
		}
        
		
		
		public function HPDF_List_Find  ( item  :Object ) : int
		{
			
			
			trace(" HPDF_List_Find");
			
			for (var i:uint = 0; i < count; i++) {
				if ( obj[i] == item)
					return i;
			}
			
			return -1;
		}

		
        public	function	HPDF_List_ItemAt( i : int ) : Object 
        {
        	return obj[i]; 
        }
		
		public function HPDF_List_Free():void
		{
			
		}
     /*   private	function	Resize( count : int ) : Boolean
        {
        	var	newObj : Object;
        	
        	if ( this.count >= count ) {
        		if (this.count == count ) 
        			return true; 
        		else
        			return false; //HPDF_INVALID_PARAMETER;
        	} 
        	
        	newObj	=	new Array() ;
        }


    
 
 Resize  (HPDF_List   list,
         HPDF_UINT   count)
{
    void **new_obj;

    HPDF_PTRACE((" HPDF_List_Resize\n"));

    if (list->count >= count) {
        if (list->count == count)
            return HPDF_OK;
        else
            return HPDF_INVALID_PARAMETER;
    }

    new_obj = (void **)HPDF_GetMem (list->mmgr, count * sizeof(void *));

    if (!new_obj)
        return HPDF_Error_GetCode (list->error);

    if (list->obj)
        HPDF_MemCpy ((HPDF_BYTE *)new_obj, (HPDF_BYTE *)list->obj,
                list->block_siz * sizeof(void *));

    list->block_siz = count;
    if (list->obj)
        HPDF_FreeMem (list->mmgr, list->obj);
    list->obj = new_obj;

    return HPDF_OK;
}
*/

	}
}