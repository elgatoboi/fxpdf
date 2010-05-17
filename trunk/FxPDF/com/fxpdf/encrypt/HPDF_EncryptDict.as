package com.fxpdf.encrypt
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Binary;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.HPDF_EncryptMode;
	import com.fxpdf.types.enum.HPDF_InfoType;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class HPDF_EncryptDict extends HPDF_Dict
	{
		public function HPDF_EncryptDict( xref : HPDF_Xref)
		{
			super();

			trace(" HPDF_EncryptDict");
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_ENCRYPT;
			
			attr = new HPDF_Encrypt();
			
			(attr as HPDF_Encrypt).HPDF_Encrypt_Init();
			
			xref.HPDF_Xref_Add ( this ); 
		}
		
		
		
		public function	HPDF_EncryptDict_CreateID  ( info : HPDF_Dict, xref:HPDF_Xref ):void
		{
			trace("HPDF_EncryptDict_CreateID");
			var  stringBytes:ByteArray; 
			var stringVector :ByteArray; 
			var attr :HPDF_Encrypt = this.attr as HPDF_Encrypt;
			
			var ctx:HPDF_MD5_CTX = new HPDF_MD5_CTX;
			
			ctx.HPDF_MD5Init ();
			
			var date:Date = new Date;
			var time:Number = date.getTime();
			
			time = 123456;
			
			var timeBuf:ByteArray = new ByteArray;
			timeBuf.endian = Endian.LITTLE_ENDIAN ; 
			timeBuf.writeUnsignedInt( time ); 
			var a1:int = timeBuf[0];
			var a2:int = timeBuf[1];
			var a3:int = timeBuf[2];
			var a4:int = timeBuf[3];
			
			HPDF_Encrypt.HPDF_MD5Update(ctx, timeBuf, timeBuf.length );
			
			/* create File Identifier from elements of Into dictionary. */
			if (info) {
				var s:String;
				var len:uint;
				
				/* Author */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_AUTHOR);
				if ( s != null && s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
					
				
				/* Creator */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_CREATOR);
				if (s != null &&  s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
				
				/* Producer */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_PRODUCER);
				if (s != null &&  s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
				
				/* Title */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_TITLE);
				if (s != null &&  s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
				
				/* Subject */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_SUBJECT);
				if (s != null &&  s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
				
				/* Keywords */
				s = info.HPDF_Info_GetInfoAttr(HPDF_InfoType.HPDF_INFO_KEYWORDS);
				if (s != null && s.length > 0) {
					stringBytes = new ByteArray;
					stringBytes.writeUTFBytes( s );
					HPDF_Encrypt.HPDF_MD5Update(ctx, stringBytes, stringBytes.length);
				}
				
				stringBytes = new ByteArray;
				stringBytes.endian = Endian.LITTLE_ENDIAN;
				stringBytes.writeUnsignedInt( xref.entries.length );
				HPDF_Encrypt.HPDF_MD5Update( ctx, stringBytes, stringBytes.length) ;
			}
			
			HPDF_Encrypt.HPDF_MD5Final( attr.encryptId, ctx);
		}
		
		
		public function HPDF_EncryptDict_Prepare  ( info : HPDF_Dict, xref:HPDF_Xref):void
		{
			
			
			var attr:HPDF_Encrypt = this.attr as HPDF_Encrypt;
			var user_key		:HPDF_Binary;
			var owner_key		:HPDF_Binary;
			
			trace((" HPDF_EncryptDict_Prepare\n"));
			
			HPDF_EncryptDict_CreateID ( info, xref);
			attr.HPDF_Encrypt_CreateOwnerKey ();
			attr.HPDF_Encrypt_CreateEncryptionKey ();
			attr.HPDF_Encrypt_CreateUserKey ();
			
			owner_key = new HPDF_Binary( attr.ownerKey ) ; // , HPDF_Encrypt.HPDF_PASSWD_LEN);
			if (!owner_key) 
				throw new HPDF_Error("HPDF_EncryptDict_Prepare - owner_key");
				
			
			this.HPDF_Dict_Add ( "O", owner_key);
			
			user_key = new HPDF_Binary( attr.userKey ) ; //  ,  HPDF_Encrypt.HPDF_PASSWD_LEN);
			if (!user_key)
				throw new HPDF_Error("HPDF_EncryptDict_Prepare - user_key");
			
			this.HPDF_Dict_Add ("U", user_key);
			
			this.HPDF_Dict_AddName ( "Filter", "Standard");
			
			if (attr.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R2) {
				this.HPDF_Dict_AddNumber ( "V", 1);
				this.HPDF_Dict_AddNumber ( "R", 2);
			} else if (attr.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R3) {
				this.HPDF_Dict_AddNumber ( "V", 2);
				this.HPDF_Dict_AddNumber ( "R", 3);
				this.HPDF_Dict_AddNumber ( "Length", attr.keyLen * 8);
			}
			
			this.HPDF_Dict_AddNumber ( "P", attr.permission);
			
		}
		
		
		override public function freeFn():void
		{
			trace((" HPDF_EncryptDict_OnFree\n"));
			attr = null; 
		}
		
		
		public function HPDF_EncryptDict_SetPassword  ( ownerPass:String, userPass:String):void
		{
			
			var attr:HPDF_Encrypt = this.attr as HPDF_Encrypt;
			trace(" HPDF_EncryptDict_SetPassword");
			
			if ( ownerPass.length == 0) 
				throw new HPDF_Error("HPDF_EncryptDict_SetPassword", HPDF_Error.HPDF_ENCRYPT_INVALID_PASSWORD, 0);
			
			if ( ownerPass.length>0 && userPass.length > 0 && ownerPass == userPass )
				throw new HPDF_Error("HPDF_EncryptDict_SetPassword", HPDF_Error.HPDF_ENCRYPT_INVALID_PASSWORD, 0);
			
			attr.ownerPasswd =  attr.HPDF_PadOrTrancatePasswd (ownerPass);
			attr.userPasswd  =  attr.HPDF_PadOrTrancatePasswd (userPass);
			
		}
		
		
		public function HPDF_EncryptDict_Validate  ():Boolean
		{
			trace((" HPDF_EncryptDict_Validate\n"));
			
			if ( header.objClass  != (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_ENCRYPT))
				return false;
			
			return true;
		}
		
		
		public function HPDF_EncryptDict_GetAttr ():HPDF_Encrypt
		{
			trace(" HPDF_EncryptDict_GetAttr");
			
			if ( attr!= null &&	(header.objClass == (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_ENCRYPT)))
				return  attr as HPDF_Encrypt;
			
			return null;
		} 
		
	}
}