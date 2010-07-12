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
package com.fxpdf.encrypt
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.types.HPDF_EncryptMode;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class HPDF_Encrypt
	{
	
		public static const HPDF_ID_LEN              : int = 16;
		public static const HPDF_PASSWD_LEN          : int = 32;
		public static const HPDF_ENCRYPT_KEY_MAX     : int = 16;
		public static const HPDF_MD5_KEY_LEN         : int = 16;
		public static const HPDF_PERMISSION_PAD      : uint = 0xFFFFFFC0;
		public static const HPDF_ARC4_BUF_SIZE       : int = 256; 
		
		private static const HPDF_PADDING_STRING:ByteArray = HPDF_Utils.arrayToByteArray( [
			0x28, 0xBF, 0x4E, 0x5E, 0x4E, 0x75, 0x8A, 0x41,
			0x64, 0x00, 0x4E, 0x56, 0xFF, 0xFA, 0x01, 0x08,
			0x2E, 0x2E, 0x00, 0xB6, 0xD0, 0x68, 0x3E, 0x80,
			0x2F, 0x0C, 0xA9, 0xFE, 0x64, 0x53, 0x69, 0x7A]); 
		
		public var mode 			:int;
		
		public var keyLen			:uint;
		public var ownerPasswd		: ByteArray = HPDF_Utils.createByteArray( HPDF_PASSWD_LEN );
		public var userPasswd		: ByteArray = HPDF_Utils.createByteArray( HPDF_PASSWD_LEN );
		public var ownerKey			: ByteArray = HPDF_Utils.createByteArray( HPDF_PASSWD_LEN );
		public var userKey			: ByteArray = HPDF_Utils.createByteArray( HPDF_PASSWD_LEN );
		
		public var permission			: int;
		public var encryptId			: ByteArray = HPDF_Utils.createByteArray( HPDF_ID_LEN );
		public var encryptionKey		: ByteArray = HPDF_Utils.createByteArray( HPDF_MD5_KEY_LEN +5);
		public var md5EncryptionKey		: ByteArray = HPDF_Utils.createByteArray( HPDF_MD5_KEY_LEN);
		public var arc4ctx				: HPDF_ARC4_Ctx = new HPDF_ARC4_Ctx;
		
		
		public function HPDF_Encrypt()
		{
		}
		
		
		public function HPDF_Encrypt_Init():void
		{
			
			this.mode = HPDF_EncryptMode.HPDF_ENCRYPT_R2;
			this.keyLen = 5; 
			
			ownerPasswd		= new ByteArray;
			userPasswd		= new ByteArray;
			
			for (var i:int = 0; i< HPDF_PASSWD_LEN ;i++) {
				ownerPasswd.writeByte( HPDF_PADDING_STRING[i] );
				userPasswd.writeByte( HPDF_PADDING_STRING[i] );
			}
			
			permission = HPDF_Consts.HPDF_ENABLE_PRINT | HPDF_Consts.HPDF_ENABLE_EDIT_ALL | HPDF_Consts.HPDF_ENABLE_COPY | HPDF_Consts.HPDF_ENABLE_EDIT | HPDF_PERMISSION_PAD; 
		}
		
		public static function	HPDF_MD5Update  ( ctx:HPDF_MD5_CTX, buf:ByteArray, len:uint):void
		{
			
			var t:uint; 
			var bufPos :uint = 0; 
			
			/* Update bitcount */
			
			t = ctx.bits[0];
			if ((ctx.bits[0] = t + (len << 3)) < t)
				ctx.bits[1]++;     /* Carry from low to high */
			ctx.bits[1] += len >>> 29;
			
			t = (t >>> 3) & 0x3f; /* Bytes already in shsInfo->data */
			
			/* Handle any leading odd-sized chunks */
			
			if (t) {
				//C HPDF_BYTE *p = (HPDF_BYTE *) ctx.in + t;
				var pos:uint = t; 
				
				t = 64 - t;
				if (len < t)
				{
					//C HPDF_MemCpy (p, buf, len);
					ctx.inbytes.position = pos; 
					ctx.inbytes.writeBytes( buf,bufPos, len );
					var a1:int = buf[0];
					var a2:int = buf[1];
					var a3:int = buf[2];
					var a4:int = buf[3];

					return;
				}
				//C HPDF_MemCpy (p, buf, t);
				ctx.inbytes.position = pos; 
				ctx.inbytes.writeBytes( buf,bufPos, len );
				
				MD5ByteReverse (ctx.inbytes, 16);
				MD5Transform (ctx.buf, ctx.inbytes);
				bufPos += t;
				len -= t;
			}
			
			/* Process data in 64-byte chunks */
			
			while (len >= 64) {
				//C HPDF_MemCpy (ctx.in, buf, 64);
				ctx.inbytes.position = pos; 
				ctx.inbytes.writeBytes( buf,bufPos, 64 );
				
				MD5ByteReverse (ctx.inbytes, 16);
				MD5Transform (ctx.buf, ctx.inbytes)
				bufPos += 64;
				len -= 64;
			}
			
			/* Handle any remaining bytes of data. */
			
			//C HPDF_MemCpy (ctx.in, buf, len);
			ctx.inbytes.position = 0; 
			ctx.inbytes.writeBytes( buf, bufPos, len );
		} 
		
		/*
		* Final wrapup - pad to 64-byte boundary with the bit pattern
		* 1 0* (64-bit count of bits processed, MSB-first)
		*/
		public static function HPDF_MD5Final  ( digest:ByteArray, ctx:HPDF_MD5_CTX) : void
		{
			
			var count	:uint;
			
			var p 		:int ; 
			var pos		:int; 
			
			/* Compute number of bytes mod 64 */
			count = (ctx.bits[0] >> 3) & 0x3F;
			
			/* Set the first char of padding to 0x80.  This is safe since there is
			always at least one byte free */
			
			//pos = count; 
			//ctx.inbytes[pos]
			
			// C p = ctx.in + count;
			// C *p++ = 0x80;
			pos = count  ; 
			ctx.inbytes[pos] = 0x80;
			pos ++; 
			
			/* Bytes of padding needed to make 64 bytes */
			count = 64 - 1 - count;
			
			/* Pad out to 56 mod 64 */
			if (count < 8) {
				/* Two lots of padding:  Pad the first block to 64 bytes */
				
				//C HPDF_MemSet (p, 0, count);				
				MD5ByteReverse (ctx.inbytes, 16);
				
				// C MD5Transform (ctx.buf, (HPDF_UINT32 *) ctx.inbytes);
				MD5Transform ( ctx.buf, ctx.inbytes);
				
				/* Now fill the next block with 56 bytes */
				// C HPDF_MemSet (ctx.in, 0, 56);
				// HPDF_Utils.VectorMemSet( ctx.inbytes, 0, 0, 56 );
				HPDF_Utils.byteArraySet( ctx.inbytes, 0, 56, 0 );
				
			} else {
				/* Pad block to 56 bytes */
				/*	HPDF_MemSet (p, 0, count - 8); */
				HPDF_Utils.byteArraySet( ctx.inbytes, pos,count-8, 0 );
				 
			}
			MD5ByteReverse (ctx.inbytes, 14);
			
			/* Append length in bits and transform */
			
			/* C ((HPDF_UINT32 *) ctx.in)[14] = ctx.bits[0];
			((HPDF_UINT32 *) ctx.in)[15] = ctx.bits[1]; */
			
			ctx.inbytes.position = 4*14; 
			ctx.inbytes.endian = Endian.LITTLE_ENDIAN;
			ctx.inbytes.writeUnsignedInt( ctx.bits[0] );
			ctx.inbytes.writeUnsignedInt( ctx.bits[1] );
			
			
			MD5Transform (ctx.buf, ctx.inbytes);
			
			
			MD5ByteReverseU ( ctx.buf, 4);
			
			
			/** Rewrite UINT32 as bytes **/
			
			var tmpBuf:ByteArray = new ByteArray();
			tmpBuf.endian = Endian.LITTLE_ENDIAN;
			
			tmpBuf.writeUnsignedInt( ctx.buf[0] );
			tmpBuf.writeUnsignedInt( ctx.buf[1] );
			tmpBuf.writeUnsignedInt( ctx.buf[2] );
			tmpBuf.writeUnsignedInt( ctx.buf[3] );
			
			tmpBuf.position  =0; 
			
			for ( var j:int = 0; j < 16 ; j ++ ) { 
				digest[j] = tmpBuf.readByte();
			}
			
			
			//HPDF_MemSet ((HPDF_BYTE *)ctx, 0, sizeof (ctx));   /* In case it's sensitive */
			ctx = new HPDF_MD5_CTX;			
		}
		
		public function HPDF_Encrypt_InitKey  ( objectId:uint, genNo:uint):void
		{
			var ctx					: HPDF_MD5_CTX = new HPDF_MD5_CTX;
			var lkeyLen				: uint;
			
			
			trace(" HPDF_Encrypt_Init objectid = " + objectId.toString() );
			
			encryptionKey[keyLen] = objectId;
			encryptionKey[keyLen + 1] = (objectId >>> 8);
			encryptionKey[keyLen + 2] = (objectId >>> 16);
			encryptionKey[keyLen + 3] = genNo;
			encryptionKey[keyLen + 4] = (genNo >>> 8);
			
			ctx.HPDF_MD5Init();
			HPDF_MD5Update( ctx, encryptionKey, keyLen + 5 );
			HPDF_MD5Final( md5EncryptionKey, ctx );
			
			lkeyLen = ( keyLen + 5 > HPDF_ENCRYPT_KEY_MAX ) ?
				HPDF_ENCRYPT_KEY_MAX : keyLen + 5;
			
			ARC4Init(arc4ctx, md5EncryptionKey, lkeyLen);
		}
		
		public function ARC4Init  ( ctx:HPDF_ARC4_Ctx, key:ByteArray, keyLen : uint ):void
		{
			var tmpArray 			: ByteArray = HPDF_Utils.createByteArray( HPDF_ARC4_BUF_SIZE);
			var	i					: uint; 
			var j					: uint = 0; 
			
			trace(" ARC4Init\n");
			
			for (i = 0; i < HPDF_ARC4_BUF_SIZE; i++)
				ctx.state[i] = i;
			
			for (i = 0; i < HPDF_ARC4_BUF_SIZE; i++)
				tmpArray[i] = key[i % keyLen];
			
			for (i = 0; i < HPDF_ARC4_BUF_SIZE; i++) {
				var tmp		:int; 
				
				j = (j + ctx.state[i] + tmpArray[i]) % HPDF_ARC4_BUF_SIZE;
				
				tmp = ctx.state[i];
				ctx.state[i] = ctx.state[j];
				ctx.state[j] = tmp;
			}
			
			ctx.idx1 = 0;
			ctx.idx2 = 0;
		}
		
		public function HPDF_Encrypt_Reset ():void
		{
			var keyLen : uint = ( keyLen + 5 > HPDF_ENCRYPT_KEY_MAX) ?		HPDF_ENCRYPT_KEY_MAX : keyLen + 5;
			
			trace(" HPDF_Encrypt_Reset");
			
			ARC4Init(arc4ctx, md5EncryptionKey, keyLen);
		} 
		
		
		private static function MD5ByteReverse  ( vec:ByteArray, longs:uint ):void
		{
			/** Not needed ? **/
			
			/*var t			:uint;
			var a1:uint = vec[0];
			var a2:uint = vec[1];
			var a3:uint = vec[2];
			var a4:uint = vec[3];
			var a5:uint = vec[4];
			var a6:uint = vec[5];
			var a7:uint = vec[6];
			var a8:uint = vec[7];
			do
			{
				/* C t = (HPDF_UINT32) ((HPDF_UINT32) buf[3] << 8 | buf[2]) << 16 |
					((HPDF_UINT32) buf[1] << 8 | buf[0]);
				*(HPDF_UINT32 *) buf = t;
				buf += 4;
				*/
				/*var b1 :int = vec[longs*4 + 0];
				var b2 :int = vec[longs*4 + 1];
				var b3 :int = vec[longs*4 + 2];
				var b4 :int = vec[longs*4 + 3];
				
				vec[longs*4 + 0] = b4;
				vec[longs*4 + 1] = b3;
				vec[longs*4 + 2] = b2;
				vec[longs*4 + 3] = b1;
			}
			while (--longs);
			*/
		}
		
		private static function MD5ByteReverseU  ( vec:Vector.<uint>, longs:uint ):void
		{
			/** Not needed ? **/
			do
			{
				/* C t = (HPDF_UINT32) ((HPDF_UINT32) buf[3] << 8 | buf[2]) << 16 |
				((HPDF_UINT32) buf[1] << 8 | buf[0]);
				*(HPDF_UINT32 *) buf = t;
				buf += 4;
				*/
			/*	var b1 :uint = vec[0];
				var b2 :uint = vec[1];
				var b3 :uint = vec[2];
				var b4 :uint = vec[3];
				
				vec[0] = b4;
				vec[1] = b3;
				vec[2] = b2;
				vec[3] = b1;
				*/
			}
			while (--longs);
		}
		
		
		private static function F1(x:uint, y:uint, z:uint):uint
		{
			return z ^ (x & (y ^ z));
		}
		
		private static function F2(x:uint, y:uint, z:uint):uint 
		{
			return  F1(z, x, y);
		}
		private static function F3(x:uint, y:uint, z:uint):uint
		{ 
			return  (x ^ y ^ z);
		}
		private static function F4(x:uint, y:uint, z:uint):uint 
		{
				return (y ^ (x | ~z));
		}
		
		
		private static function HPDF_MD5STEP(f:Function, w:uint, x:uint, y:uint, z:uint, data:uint, s:uint):uint
		{
			var ff:uint = f(x,y,z);
			var ret:uint = w +  ff + data;
			ret = ret << s | ret >>> (32-s);
			ret += x;
			return ret; 
		}
		
		/*
		* The core of the MD5 algorithm, this alters an existing MD5 hash to
		* reflect the addition of 16 longwords of new data.  MD5Update blocks
		* the data and converts bytes into longwords for this routine.
		*/
		private static function MD5Transform  ( buf:Vector.<uint>,	inbytes_bytes:ByteArray ):void
		{
			
			/** Conver bytes array to UINT32 array **/
			var inbytes:Vector.<uint> = new Vector.<uint>;
			inbytes_bytes.endian = Endian.LITTLE_ENDIAN;
			inbytes_bytes.position = 0; 
			for ( var i:int = 0; i< 16 ; i++ ) { 
				inbytes[i] = inbytes_bytes.readUnsignedInt( );
				// trace( "i = " + i.toString() + " " + inbytes[i].toString() ) ;
			}
			var a			:uint;
			var b			:uint;
			var c			:uint;
			var d			:uint;
			
			a = buf[0];
			b = buf[1];
			c = buf[2];
			d = buf[3];
			
			
			a = HPDF_MD5STEP (F1, a, b, c, d, inbytes[0] + 0xd76aa478, 7);
			d = HPDF_MD5STEP (F1, d, a, b, c, inbytes[1] + 0xe8c7b756, 12);
			c = HPDF_MD5STEP (F1, c, d, a, b, inbytes[2] + 0x242070db, 17);
			b = HPDF_MD5STEP (F1, b, c, d, a, inbytes[3] + 0xc1bdceee, 22);
			a = HPDF_MD5STEP (F1, a, b, c, d, inbytes[4] + 0xf57c0faf, 7);
			d = HPDF_MD5STEP (F1, d, a, b, c, inbytes[5] + 0x4787c62a, 12);
			c = HPDF_MD5STEP (F1, c, d, a, b, inbytes[6] + 0xa8304613, 17);
			b = HPDF_MD5STEP (F1, b, c, d, a, inbytes[7] + 0xfd469501, 22);
			a = HPDF_MD5STEP (F1, a, b, c, d, inbytes[8] + 0x698098d8, 7);
			d = HPDF_MD5STEP (F1, d, a, b, c, inbytes[9] + 0x8b44f7af, 12);
			c = HPDF_MD5STEP (F1, c, d, a, b, inbytes[10] + 0xffff5bb1, 17);
			b = HPDF_MD5STEP (F1, b, c, d, a, inbytes[11] + 0x895cd7be, 22);
			a = HPDF_MD5STEP (F1, a, b, c, d, inbytes[12] + 0x6b901122, 7);
			d = HPDF_MD5STEP (F1, d, a, b, c, inbytes[13] + 0xfd987193, 12);
			c = HPDF_MD5STEP (F1, c, d, a, b, inbytes[14] + 0xa679438e, 17);
			b = HPDF_MD5STEP (F1, b, c, d, a, inbytes[15] + 0x49b40821, 22);
			
			a = HPDF_MD5STEP (F2, a, b, c, d, inbytes[1] + 0xf61e2562, 5);
			d = HPDF_MD5STEP (F2, d, a, b, c, inbytes[6] + 0xc040b340, 9);
			c = HPDF_MD5STEP (F2, c, d, a, b, inbytes[11] + 0x265e5a51, 14);
			b = HPDF_MD5STEP (F2, b, c, d, a, inbytes[0] + 0xe9b6c7aa, 20);
			a = HPDF_MD5STEP (F2, a, b, c, d, inbytes[5] + 0xd62f105d, 5);
			d = HPDF_MD5STEP (F2, d, a, b, c, inbytes[10] + 0x02441453, 9);
			c = HPDF_MD5STEP (F2, c, d, a, b, inbytes[15] + 0xd8a1e681, 14);
			b = HPDF_MD5STEP (F2, b, c, d, a, inbytes[4] + 0xe7d3fbc8, 20);
			a = HPDF_MD5STEP (F2, a, b, c, d, inbytes[9] + 0x21e1cde6, 5);
			d = HPDF_MD5STEP (F2, d, a, b, c, inbytes[14] + 0xc33707d6, 9);
			c = HPDF_MD5STEP (F2, c, d, a, b, inbytes[3] + 0xf4d50d87, 14);
			b = HPDF_MD5STEP (F2, b, c, d, a, inbytes[8] + 0x455a14ed, 20);
			a = HPDF_MD5STEP (F2, a, b, c, d, inbytes[13] + 0xa9e3e905, 5);
			d = HPDF_MD5STEP (F2, d, a, b, c, inbytes[2] + 0xfcefa3f8, 9);
			c = HPDF_MD5STEP (F2, c, d, a, b, inbytes[7] + 0x676f02d9, 14);
			b = HPDF_MD5STEP (F2, b, c, d, a, inbytes[12] + 0x8d2a4c8a, 20);
			
			a = HPDF_MD5STEP (F3, a, b, c, d, inbytes[5] + 0xfffa3942, 4);
			d = HPDF_MD5STEP (F3, d, a, b, c, inbytes[8] + 0x8771f681, 11);
			c = HPDF_MD5STEP (F3, c, d, a, b, inbytes[11] + 0x6d9d6122, 16);
			b = HPDF_MD5STEP (F3, b, c, d, a, inbytes[14] + 0xfde5380c, 23);
			a = HPDF_MD5STEP (F3, a, b, c, d, inbytes[1] + 0xa4beea44, 4);
			d = HPDF_MD5STEP (F3, d, a, b, c, inbytes[4] + 0x4bdecfa9, 11);
			c = HPDF_MD5STEP (F3, c, d, a, b, inbytes[7] + 0xf6bb4b60, 16);
			b = HPDF_MD5STEP (F3, b, c, d, a, inbytes[10] + 0xbebfbc70, 23);
			a = HPDF_MD5STEP (F3, a, b, c, d, inbytes[13] + 0x289b7ec6, 4);
			d = HPDF_MD5STEP (F3, d, a, b, c, inbytes[0] + 0xeaa127fa, 11);
			c = HPDF_MD5STEP (F3, c, d, a, b, inbytes[3] + 0xd4ef3085, 16);
			b = HPDF_MD5STEP (F3, b, c, d, a, inbytes[6] + 0x04881d05, 23);
			a = HPDF_MD5STEP (F3, a, b, c, d, inbytes[9] + 0xd9d4d039, 4);
			d = HPDF_MD5STEP (F3, d, a, b, c, inbytes[12] + 0xe6db99e5, 11);
			c = HPDF_MD5STEP (F3, c, d, a, b, inbytes[15] + 0x1fa27cf8, 16);
			b = HPDF_MD5STEP (F3, b, c, d, a, inbytes[2] + 0xc4ac5665, 23);
			
			a = HPDF_MD5STEP (F4, a, b, c, d, inbytes[0] + 0xf4292244, 6);
			d = HPDF_MD5STEP (F4, d, a, b, c, inbytes[7] + 0x432aff97, 10);
			c = HPDF_MD5STEP (F4, c, d, a, b, inbytes[14] + 0xab9423a7, 15);
			b = HPDF_MD5STEP (F4, b, c, d, a, inbytes[5] + 0xfc93a039, 21);
			a = HPDF_MD5STEP (F4, a, b, c, d, inbytes[12] + 0x655b59c3, 6);
			d = HPDF_MD5STEP (F4, d, a, b, c, inbytes[3] + 0x8f0ccc92, 10);
			c = HPDF_MD5STEP (F4, c, d, a, b, inbytes[10] + 0xffeff47d, 15);
			b = HPDF_MD5STEP (F4, b, c, d, a, inbytes[1] + 0x85845dd1, 21);
			a = HPDF_MD5STEP (F4, a, b, c, d, inbytes[8] + 0x6fa87e4f, 6);
			d = HPDF_MD5STEP (F4, d, a, b, c, inbytes[15] + 0xfe2ce6e0, 10);
			c = HPDF_MD5STEP (F4, c, d, a, b, inbytes[6] + 0xa3014314, 15);
			b = HPDF_MD5STEP (F4, b, c, d, a, inbytes[13] + 0x4e0811a1, 21);
			a = HPDF_MD5STEP (F4, a, b, c, d, inbytes[4] + 0xf7537e82, 6);
			d = HPDF_MD5STEP (F4, d, a, b, c, inbytes[11] + 0xbd3af235, 10);
			c = HPDF_MD5STEP (F4, c, d, a, b, inbytes[2] + 0x2ad7d2bb, 15);
			b = HPDF_MD5STEP (F4, b, c, d, a, inbytes[9] + 0xeb86d391, 21);
			
			buf[0] += a;
			buf[1] += b;
			buf[2] += c;
			buf[3] += d;
			
		} 
		
		
		public function HPDF_Encrypt_CreateOwnerKey  ():void
		{
			var rc4_ctx			:HPDF_ARC4_Ctx;
			var md5_ctx			:HPDF_MD5_CTX;
			var digest			:ByteArray = new ByteArray;
			var tmppwd			:ByteArray = new ByteArray;
			var i				:uint ; 	
			var j				:uint ; 	
			
			trace(" HPDF_Encrypt_CreateOwnerKey");
			
			/* create md5-digest using the value of owner_passwd */
			
			/* Algorithm 3.3 step 2 */
			md5_ctx = new HPDF_MD5_CTX;
			md5_ctx.HPDF_MD5Init();
			var i1:uint = ownerPasswd[0];
			var i2:uint = ownerPasswd[1];
			var i3:uint = ownerPasswd[2];
			HPDF_MD5Update(md5_ctx, ownerPasswd, HPDF_PASSWD_LEN);
			
			trace("@ Algorithm 3.3 step 2");
			
			HPDF_MD5Final(digest, md5_ctx);
			trace("digest after: " , digest[0].toString(), digest[1].toString(), digest[2].toString() ); 
			
			/* Algorithm 3.3 step 3 (Revision 3 only) */
			if ( this.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R3) {

				for (i = 0; i < 50; i++) {
					md5_ctx.HPDF_MD5Init();
					HPDF_MD5Update (md5_ctx, digest, keyLen);
					HPDF_MD5Final(digest, md5_ctx);
					trace("digest after 3.3: " , digest[0].toString(), digest[1].toString(), digest[2].toString() ); 
					trace("@ Algorithm 3.3 step 3 loop "+ i.toString());
				}
			}
			
			/* Algorithm 3.3 step 4 */
			trace("@ Algorithm 3.3 step 7 loop 0");
			rc4_ctx = new HPDF_ARC4_Ctx;
			ARC4Init (rc4_ctx, digest, this.keyLen);
			trace("digest after 3.3 step 7 : " , digest[0].toString(), digest[1].toString(), digest[2].toString() );
			
			trace(("@ Algorithm 3.3 step 5"));
			
			/* Algorithm 3.3 step 6 */
			trace(("@ Algorithm 3.3 step 6"));
			rc4_ctx.ARC4CryptBuf ( this.userPasswd, tmppwd, HPDF_PASSWD_LEN);
			
			/* Algorithm 3.3 step 7 */
			trace("@ Algorithm 3.3 step 7");
			if (this.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R3) {
				
				var tmppwd2			:ByteArray = new ByteArray;
				
				for (i = 1; i <= 19; i++) {
					
					var new_key			:ByteArray = new ByteArray;
					
					for (j = 0; j < this.keyLen; j++) {
						trace("new key writing byte : " , (digest[j] ^ i ).toString());
						new_key.writeByte( digest[j] ^ i );
					}
					
					trace("@ Algorithm 3.3 step 7 loop " + i.toString());
					
					tmppwd2 = new ByteArray();
					tmppwd2.writeBytes( tmppwd, 0, HPDF_PASSWD_LEN );
					
					ARC4Init(rc4_ctx, new_key, this.keyLen);
					rc4_ctx.ARC4CryptBuf( tmppwd2, tmppwd, HPDF_PASSWD_LEN);
					trace("tmppwd after: " + tmppwd[0].toString(), tmppwd[1].toString() ); 
				}
				
			}
			
			/* Algorithm 3.3 step 8 */
			trace("@ Algorithm 3.3 step 8");
			ownerKey = new ByteArray;
			ownerKey.writeBytes( tmppwd, 0, tmppwd.length );
		}
		
		
		public function HPDF_Encrypt_CreateEncryptionKey  ():void
		{
			var md5_ctx 	:HPDF_MD5_CTX = new HPDF_MD5_CTX;
			var tmpFlg		:ByteArray 		= HPDF_Utils.createByteArray( 4);
			
			
			trace(" HPDF_Encrypt_CreateEncryptionKey");
			
			/* Algorithm3.2 step2 */
			md5_ctx.HPDF_MD5Init();
			HPDF_MD5Update( md5_ctx, this.userPasswd, HPDF_PASSWD_LEN);
			
			/* Algorithm3.2 step3 */
			HPDF_MD5Update(md5_ctx, this.ownerKey, HPDF_PASSWD_LEN);
			
			
			/* Algorithm3.2 step4 */
			trace("@@@ permission =" + this.permission.toString());
			tmpFlg[0] = this.permission;
			tmpFlg[1] = this.permission >> 8;
			tmpFlg[2] = this.permission >> 16;
			tmpFlg[3] = this.permission >> 24;
			
			HPDF_MD5Update( md5_ctx, tmpFlg, 4);
			
			/* Algorithm3.2 step5 */
			trace("@ Algorithm 3.2 step 5");
			
			HPDF_MD5Update(md5_ctx, this.encryptId, HPDF_ID_LEN);
			HPDF_MD5Final(this.encryptionKey, md5_ctx);
			
			/* Algorithm 3.2 step6 (Revision 3 only) */
			if ( this.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R3) {
				var	i:uint;
				
				for (i = 0; i < 50; i++) {
					trace("@ Algorithm 3.3 step 6 loop " +  i.toString());
					md5_ctx.HPDF_MD5Init();
					HPDF_MD5Update (md5_ctx, this.encryptionKey, this.keyLen);
					HPDF_MD5Final(this.encryptionKey, md5_ctx);
				}
			}
		}
		
		
		public function	HPDF_Encrypt_CreateUserKey  ():void
		{
			var ctx:HPDF_ARC4_Ctx = new HPDF_ARC4_Ctx;
			
			trace((" HPDF_Encrypt_CreateUserKey key\n"));
			
			/* Algorithm 3.4/5 step1 */
			
			/* Algorithm 3.4 step2 */
			var b:uint = encryptionKey[0];
			var b1:uint = encryptionKey[1];
			var b2:uint = encryptionKey[2];
			ARC4Init( ctx,this.encryptionKey,this.keyLen);
			ctx.ARC4CryptBuf( HPDF_PADDING_STRING, this.userKey, HPDF_PASSWD_LEN);
			
			if (this.mode == HPDF_EncryptMode.HPDF_ENCRYPT_R3) 
			{
				var md5_ctx		:HPDF_MD5_CTX 	=	new HPDF_MD5_CTX;
				var digest		:ByteArray		=	HPDF_Utils.createByteArray( HPDF_MD5_KEY_LEN );
				var digest2		:ByteArray		=	HPDF_Utils.createByteArray( HPDF_MD5_KEY_LEN );
				var i			:uint;
				
				/* Algorithm 3.5 step2 (same as Algorithm3.2 step2) */
				md5_ctx.HPDF_MD5Init(  );
				HPDF_MD5Update(md5_ctx, HPDF_PADDING_STRING, HPDF_PASSWD_LEN);
				
				/* Algorithm 3.5 step3 */
			 	HPDF_MD5Update(md5_ctx, this.encryptId, HPDF_ID_LEN);
				HPDF_MD5Final(digest, md5_ctx);
				
				trace(("@ Algorithm 3.5 step 3\n"));
				
				/* Algorithm 3.5 step4 */
				ARC4Init(ctx, this.encryptionKey, this.keyLen);
				ctx.ARC4CryptBuf( digest, digest2, HPDF_MD5_KEY_LEN);
				
				trace(("@ Algorithm 3.5 step 4\n"));
				
				/* Algorithm 3.5 step5 */
				for (i = 1; i <= 19; i++) {
					var j		:uint;
					var newKey		:ByteArray = HPDF_Utils.createByteArray( HPDF_MD5_KEY_LEN );
					
					trace("@ Algorithm 3.5 step 5 loop "+ i.toString() );
					
					for (j = 0; j < this.keyLen; j++)
						newKey[j] = this.encryptionKey[j] ^ i;
					
					digest.position = 0; 
					digest.writeBytes( digest2, 0,HPDF_MD5_KEY_LEN);
					
					ARC4Init( ctx, newKey, this.keyLen);
					ctx.ARC4CryptBuf( digest, digest2, HPDF_MD5_KEY_LEN);
				}
				
				/* use the result of Algorithm 3.4 as 'arbitrary padding' */
				HPDF_Utils.byteArraySet( userKey,0,HPDF_PASSWD_LEN,0);
				userKey.writeBytes( digest2, 0, HPDF_MD5_KEY_LEN);
			}
			
		}
		
		
		public function HPDF_Encrypt_CryptBuf  (  src:ByteArray, dst:ByteArray, len:uint) : void
		{
			arc4ctx.ARC4CryptBuf( src, dst, len);
		}
		
		public function	HPDF_PadOrTrancatePasswd  ( pwd:String ):ByteArray
		{
			var len:uint = pwd.length; 
			
			var newPass:ByteArray = HPDF_Utils.createByteArray( HPDF_PASSWD_LEN, 0 );
			
			if (len >= HPDF_PASSWD_LEN) {
				newPass.writeUTFBytes( pwd.substr(0, HPDF_PASSWD_LEN ) ); 
			}
			else {
				if (len > 0)
					newPass.writeUTFBytes( pwd );
				// padd the rest
				for ( var i:int = 0 ;i< HPDF_PASSWD_LEN - len ; i ++ ) { 
					newPass[len+i] = HPDF_PADDING_STRING[i];
				}
			}
			return newPass;
		}



	}
}