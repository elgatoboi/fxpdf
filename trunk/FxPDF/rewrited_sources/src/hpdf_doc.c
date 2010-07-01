/*
 * << Haru Free PDF Library 2.0.5 >> -- hpdf_doc.c
 *
 * Copyright (c) 1999-2006 Takeshi Kanno <takeshi_kanno@est.hi-ho.ne.jp>
 *
 * Permission to use, copy, modify, distribute and sell this software
 * and its documentation for any purpose is hereby granted without fee,
 * provided that the above copyright notice appear in all copies and
 * that both that copyright notice and this permission notice appear
 * in supporting documentation.
 * It is provided "as is" without express or implied warranty.
 *
 */


#include "hpdf_conf.h"
#include "hpdf_utils.h"
#include "hpdf_encryptdict.h"
#include "hpdf_destination.h"
#include "hpdf_info.h"
#include "hpdf_page_label.h"
#include "hpdf.h"


static const char *HPDF_VERSION_STR[5] = {
                "%PDF-1.2\012%\267\276\255\252\012",
                "%PDF-1.3\012%\267\276\255\252\012",
                "%PDF-1.4\012%\267\276\255\252\012",
                "%PDF-1.5\012%\267\276\255\252\012",
                "%PDF-1.6\012%\267\276\255\252\012"
};


static HPDF_STATUS
WriteHeader  (HPDF_Doc      pdf,
              HPDF_Stream   stream);


static HPDF_STATUS
PrepareTrailer  (HPDF_Doc   pdf);


static void
FreeEncoderList (HPDF_Doc  pdf);


static void
FreeFontDefList (HPDF_Doc  pdf);


static void
CleanupFontDefList (HPDF_Doc  pdf);


static HPDF_Dict
GetInfo  (HPDF_Doc  pdf);

static HPDF_STATUS
InternalSaveToStream  (HPDF_Doc      pdf,
                       HPDF_Stream   stream);

static const char*
LoadType1FontFromStream (HPDF_Doc     pdf,
                         HPDF_Stream  afmdata,
                         HPDF_Stream  pfmdata);


static const char*
LoadTTFontFromStream (HPDF_Doc         pdf,
                      HPDF_Stream      font_data,
                      HPDF_BOOL        embedding,
                       const char      *file_name);


static const char*
LoadTTFontFromStream2 (HPDF_Doc         pdf,
                       HPDF_Stream      font_data,
                       HPDF_UINT        index,
                       HPDF_BOOL        embedding,
                       const char      *file_name);


/*---------------------------------------------------------------------------*/

HPDF_EXPORT(const char *)
HPDF_GetVersion (void)
{
    return HPDF_VERSION_TEXT;
}


HPDF_BOOL
HPDF_Doc_Validate  (HPDF_Doc  pdf)
{
    rewrited
}


HPDF_EXPORT(HPDF_BOOL)
HPDF_HasDoc  (HPDF_Doc  pdf)
{
   rewrited
}


HPDF_EXPORT(HPDF_Doc)
HPDF_New  (HPDF_Error_Handler    user_error_fn,
           void                  *user_data)
{
    rewrited
}


HPDF_EXPORT(HPDF_Doc)
HPDF_NewEx  (HPDF_Error_Handler    user_error_fn,
             HPDF_Alloc_Func       user_alloc_fn,
             HPDF_Free_Func        user_free_fn,
             HPDF_UINT             mem_pool_buf_size,
             void                 *user_data)
{
    HPDF_Doc pdf;
    HPDF_MMgr mmgr;
    HPDF_Error_Rec tmp_error;

    HPDF_PTRACE ((" HPDF_NewEx\n"));

    /* initialize temporary-error object */
    HPDF_Error_Init (&tmp_error, user_data);

    /* create memory-manager object */
    mmgr = HPDF_MMgr_New (&tmp_error, mem_pool_buf_size, user_alloc_fn,
            user_free_fn);
    if (!mmgr) {
        HPDF_CheckError (&tmp_error);
        return NULL;
    }

    /* now create pdf_doc object */
    pdf = HPDF_GetMem (mmgr, sizeof (HPDF_Doc_Rec));
    if (!pdf) {
        HPDF_MMgr_Free (mmgr);
        HPDF_CheckError (&tmp_error);
        return NULL;
    }

    HPDF_MemSet (pdf, 0, sizeof (HPDF_Doc_Rec));
    pdf->sig_bytes = HPDF_SIG_BYTES;
    pdf->mmgr = mmgr;
    pdf->pdf_version = HPDF_VER_13;
    pdf->compression_mode = HPDF_COMP_NONE;

    /* copy the data of temporary-error object to the one which is
       included in pdf_doc object */
    pdf->error = tmp_error;

    /* switch the error-object of memory-manager */
    mmgr->error = &pdf->error;

    if (HPDF_NewDoc (pdf) != HPDF_OK) {
        HPDF_Free (pdf);
        HPDF_CheckError (&tmp_error);
        return NULL;
    }

    pdf->error.error_fn = user_error_fn;

    return pdf;
}


HPDF_EXPORT(void)
HPDF_Free  (HPDF_Doc  pdf)
{
     rewrited 
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_NewDoc  (HPDF_Doc  pdf)
{
     rewrited
}


HPDF_EXPORT(void)
HPDF_FreeDoc  (HPDF_Doc  pdf)
{
   rewrted
}


HPDF_EXPORT(void)
HPDF_FreeDocAll  (HPDF_Doc  pdf)
{
    HPDF_PTRACE ((" HPDF_FreeDocAll\n"));

    if (HPDF_Doc_Validate (pdf)) {
        HPDF_FreeDoc (pdf);

        if (pdf->fontdef_list)
            FreeFontDefList (pdf);

        if (pdf->encoder_list)
            FreeEncoderList (pdf);

        pdf->compression_mode = HPDF_COMP_NONE;

        HPDF_Error_Reset (&pdf->error);
    }
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetPagesConfiguration  (HPDF_Doc    pdf,
                             HPDF_UINT   page_per_pages)
{
  rewrited
}


static HPDF_STATUS
WriteHeader  (HPDF_Doc      pdf,
              HPDF_Stream   stream)
{
    rewrited
}


static HPDF_STATUS
PrepareTrailer  (HPDF_Doc    pdf)
{
     rewrited
}


HPDF_STATUS
HPDF_Doc_SetEncryptOn  (HPDF_Doc   pdf)
{
  rewited
}

HPDF_EXPORT(HPDF_STATUS)
HPDF_SetPassword  (HPDF_Doc          pdf,
                   const char  *owner_passwd,
                   const char  *user_passwd)
{
    rewrited
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetPermission  (HPDF_Doc    pdf,
                     HPDF_UINT   permission)
{
    rewrited
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetEncryptionMode  (HPDF_Doc           pdf,
                         HPDF_EncryptMode   mode,
                         HPDF_UINT          key_len)
{
   rewrited
}


HPDF_STATUS
HPDF_Doc_SetEncryptOff  (HPDF_Doc   pdf)
{
   rewrited
}


HPDF_STATUS
HPDF_Doc_PrepareEncryption  (HPDF_Doc   pdf)
{
   rewr
}


static HPDF_STATUS
InternalSaveToStream  (HPDF_Doc      pdf,
                       HPDF_Stream   stream)
{
    rewr
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SaveToStream  (HPDF_Doc   pdf)
{
   rew
}


HPDF_EXPORT(HPDF_UINT32)
HPDF_GetStreamSize  (HPDF_Doc   pdf)
{
   rwer
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_ReadFromStream  (HPDF_Doc       pdf,
                      HPDF_BYTE     *buf,
                      HPDF_UINT32   *size)
{
    HPDF_UINT isize = *size;
    HPDF_STATUS ret;

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (!HPDF_Stream_Validate (pdf->stream))
        return HPDF_RaiseError (&pdf->error, HPDF_INVALID_OPERATION, 0);

    if (*size == 0)
        return HPDF_RaiseError (&pdf->error, HPDF_INVALID_PARAMETER, 0);

    ret = HPDF_Stream_Read (pdf->stream, buf, &isize);

    *size = isize;

    if (ret != HPDF_OK)
        HPDF_CheckError (&pdf->error);

    return ret;
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_ResetStream  (HPDF_Doc     pdf)
{
    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (!HPDF_Stream_Validate (pdf->stream))
        return HPDF_RaiseError (&pdf->error, HPDF_INVALID_OPERATION, 0);

    return HPDF_Stream_Seek (pdf->stream, 0, HPDF_SEEK_SET);
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SaveToFile  (HPDF_Doc     pdf,
                  const char  *file_name)
{
    HPDF_Stream stream;

    HPDF_PTRACE ((" HPDF_SaveToFile\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    stream = HPDF_FileWriter_New (pdf->mmgr, file_name);
    if (!stream)
        return HPDF_CheckError (&pdf->error);

    InternalSaveToStream (pdf, stream);

    HPDF_Stream_Free (stream);

    return HPDF_CheckError (&pdf->error);
}


HPDF_EXPORT(HPDF_Page)
HPDF_GetCurrentPage  (HPDF_Doc   pdf)
{
   rewr
}


HPDF_EXPORT(HPDF_Page)
HPDF_GetPageByIndex  (HPDF_Doc    pdf,
                      HPDF_UINT   index)
{
   rew
}


HPDF_Pages
HPDF_Doc_GetCurrentPages  (HPDF_Doc   pdf)
{
   rwer
}


HPDF_STATUS
HPDF_Doc_SetCurrentPages  (HPDF_Doc     pdf,
                           HPDF_Pages   pages)
{
   rwewr
}


HPDF_STATUS
HPDF_Doc_SetCurrentPage  (HPDF_Doc    pdf,
                          HPDF_Page   page)
{
    rewer
}


HPDF_EXPORT(HPDF_Page)
HPDF_AddPage  (HPDF_Doc  pdf)
{
    rewr
}


HPDF_Pages
HPDF_Doc_AddPagesTo  (HPDF_Doc     pdf,
                      HPDF_Pages   parent)
{
   rewr
}


HPDF_EXPORT(HPDF_Page)
HPDF_InsertPage  (HPDF_Doc    pdf,
                  HPDF_Page   target)
{
  rewer
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetErrorHandler  (HPDF_Doc             pdf,
                       HPDF_Error_Handler   user_error_fn)
{
    rewrite
}


/*----- font handling -------------------------------------------------------*/


static void
FreeFontDefList  (HPDF_Doc   pdf)
{
    rewr
}

static void
CleanupFontDefList  (HPDF_Doc  pdf)
{
    rewr
}


HPDF_FontDef
HPDF_Doc_FindFontDef  (HPDF_Doc          pdf,
                       const char  *font_name)
{
    rewr
}


HPDF_STATUS
HPDF_Doc_RegisterFontDef  (HPDF_Doc       pdf,
                           HPDF_FontDef   fontdef)
{
    rewr
}



HPDF_FontDef
HPDF_GetFontDef  (HPDF_Doc          pdf,
                  const char  *font_name)
{
   rewe
}


/*----- encoder handling ----------------------------------------------------*/


HPDF_Encoder
HPDF_Doc_FindEncoder  (HPDF_Doc         pdf,
                       const char  *encoding_name)
{
    rewer
}



HPDF_STATUS
HPDF_Doc_RegisterEncoder  (HPDF_Doc       pdf,
                           HPDF_Encoder   encoder)
{
   rewr
}


HPDF_EXPORT(HPDF_Encoder)
HPDF_GetEncoder  (HPDF_Doc         pdf,
                  const char  *encoding_name)
{
   rewr
}


HPDF_EXPORT(HPDF_Encoder)
HPDF_GetCurrentEncoder  (HPDF_Doc    pdf)
{
    rewer
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetCurrentEncoder  (HPDF_Doc    pdf,
                         const char  *encoding_name)
{
    rewer
}


static void
FreeEncoderList  (HPDF_Doc  pdf)
{
    rewr
}


/*----- font handling -------------------------------------------------------*/


HPDF_Font
HPDF_Doc_FindFont  (HPDF_Doc          pdf,
                    const char  *font_name,
                    const char  *encoding_name)
{
    HPDF_UINT i;
    HPDF_Font font;

    HPDF_PTRACE ((" HPDF_Doc_FindFont\n"));

    for (i = 0; i < pdf->font_mgr->count; i++) {
        HPDF_FontAttr attr;

        font = (HPDF_Font)HPDF_List_ItemAt (pdf->font_mgr, i);
        attr = (HPDF_FontAttr) font->attr;

        if (HPDF_StrCmp (attr->fontdef->base_font, font_name) == 0 &&
                HPDF_StrCmp (attr->encoder->name, encoding_name) == 0)
            return font;
    }

    return NULL;
}


HPDF_EXPORT(HPDF_Font)
HPDF_GetFont  (HPDF_Doc          pdf,
               const char  *font_name,
               const char  *encoding_name)
{
    HPDF_FontDef fontdef = NULL;
    HPDF_Encoder encoder = NULL;
    HPDF_Font font;

    HPDF_PTRACE ((" HPDF_GetFont\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    if (!font_name) {
        HPDF_RaiseError (&pdf->error, HPDF_INVALID_FONT_NAME, 0);
        return NULL;
    }

    /* if encoding-name is not specified, find default-encoding of fontdef
     */
    if (!encoding_name) {
	   printf("get font def font name = %s \n",font_name);
        fontdef = HPDF_GetFontDef (pdf, font_name);

        if (fontdef) {
            HPDF_Type1FontDefAttr attr = (HPDF_Type1FontDefAttr)fontdef->attr;
			printf("fondef->type = %d  encoding_scheme = %s \n ", fontdef->type , attr->encoding_scheme);
            if (fontdef->type == HPDF_FONTDEF_TYPE_TYPE1 &&
                HPDF_StrCmp (attr->encoding_scheme,
                            HPDF_ENCODING_FONT_SPECIFIC) == 0)
                encoder = HPDF_GetEncoder (pdf, HPDF_ENCODING_FONT_SPECIFIC);
            else
                encoder = HPDF_GetEncoder (pdf, HPDF_ENCODING_STANDARD);
        } else {
            HPDF_CheckError (&pdf->error);
            return NULL;
        }

        font = HPDF_Doc_FindFont (pdf, font_name, encoder->name);
    } else {
        font = HPDF_Doc_FindFont (pdf, font_name, encoding_name);
    }

    if (font)
        return font;

    if (!fontdef) {
        fontdef = HPDF_GetFontDef (pdf, font_name);

        if (!fontdef) {
            HPDF_CheckError (&pdf->error);
            return NULL;
        }
    }

    if (!encoder) {
        encoder = HPDF_GetEncoder (pdf, encoding_name);

        if (!encoder)
            return NULL;
    }

    switch (fontdef->type) {
        case HPDF_FONTDEF_TYPE_TYPE1:
            font = HPDF_Type1Font_New (pdf->mmgr, fontdef, encoder, pdf->xref);

            if (font)
                HPDF_List_Add (pdf->font_mgr, font);

            break;
        case HPDF_FONTDEF_TYPE_TRUETYPE:
            if (encoder->type == HPDF_ENCODER_TYPE_DOUBLE_BYTE)
                font = HPDF_Type0Font_New (pdf->mmgr, fontdef, encoder,
                        pdf->xref);
            else
                font = HPDF_TTFont_New (pdf->mmgr, fontdef, encoder, pdf->xref);

            if (font)
                HPDF_List_Add (pdf->font_mgr, font);

            break;
        case HPDF_FONTDEF_TYPE_CID:
            font = HPDF_Type0Font_New (pdf->mmgr, fontdef, encoder, pdf->xref);

            if (font)
                HPDF_List_Add (pdf->font_mgr, font);

            break;
        default:
            HPDF_RaiseError (&pdf->error, HPDF_UNSUPPORTED_FONT_TYPE, 0);
            return NULL;
    }

    if (!font)
        HPDF_CheckError (&pdf->error);

    if (font && (pdf->compression_mode & HPDF_COMP_METADATA))
        font->filter = HPDF_STREAM_FILTER_FLATE_DECODE;

    return font;
}


HPDF_EXPORT(const char*)
HPDF_LoadType1FontFromFile  (HPDF_Doc     pdf,
                             const char  *afm_file_name,
                             const char  *data_file_name)
{
    HPDF_Stream afm;
    HPDF_Stream pfm = NULL;
    const char *ret;

    HPDF_PTRACE ((" HPDF_LoadType1FontFromFile\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    /* create file stream */
    afm = HPDF_FileReader_New (pdf->mmgr, afm_file_name);

    if (data_file_name)
        pfm = HPDF_FileReader_New (pdf->mmgr, data_file_name);

    if (HPDF_Stream_Validate (afm) &&
            (!data_file_name || HPDF_Stream_Validate (pfm))) {

        ret = LoadType1FontFromStream (pdf, afm, pfm);
    } else
        ret = NULL;

    /* destroy file stream */
    if (afm)
        HPDF_Stream_Free (afm);

    if (pfm)
        HPDF_Stream_Free (pfm);

    if (!ret)
        HPDF_CheckError (&pdf->error);

    return ret;
}


static const char*
LoadType1FontFromStream  (HPDF_Doc      pdf,
                          HPDF_Stream   afmdata,
                          HPDF_Stream   pfmdata)
{
    HPDF_FontDef def;

    HPDF_PTRACE ((" HPDF_LoadType1FontFromStream\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    def = HPDF_Type1FontDef_Load (pdf->mmgr, afmdata, pfmdata);
    if (def) {
        HPDF_FontDef  tmpdef = HPDF_Doc_FindFontDef (pdf, def->base_font);
        if (tmpdef) {
            HPDF_FontDef_Free (def);
            HPDF_SetError (&pdf->error, HPDF_FONT_EXISTS, 0);
            return NULL;
        }

        if (HPDF_List_Add (pdf->fontdef_list, def) != HPDF_OK) {
            HPDF_FontDef_Free (def);
            return NULL;
        }
    }
    return def->base_font;
}


HPDF_EXPORT(const char*)
HPDF_LoadTTFontFromFile (HPDF_Doc         pdf,
                         const char      *file_name,
                         HPDF_BOOL        embedding)
{
    HPDF_Stream font_data;
    const char *ret;

    HPDF_PTRACE ((" HPDF_LoadTTFontFromFile\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    /* create file stream */
    font_data = HPDF_FileReader_New (pdf->mmgr, file_name);

    if (HPDF_Stream_Validate (font_data)) {
        ret = LoadTTFontFromStream (pdf, font_data, embedding, file_name);
    } else
        ret = NULL;

    if (!ret)
        HPDF_CheckError (&pdf->error);

    return ret;
}

/* PC */
HPDF_EXPORT(const char*)
HPDF2_LoadTTFontFromStream (HPDF_Doc         pdf,
                      HPDF_Stream      font_data,
                      HPDF_BOOL        embedding,
                      const char      *file_name)
{
 return LoadTTFontFromStream( pdf,
                      font_data,
                      embedding,
                      file_name);

/*	const char *ret;
      HPDF_MMgr mmgr;
HPDF_Error_Rec tmp_error;


 	// tutaj robie memory stream z bufora 
	ret ="TWORZE MMGR";
	mmgr = HPDF_MMgr_New (&tmp_error,size,NULL, NULL) ; //  user_alloc_fn,   user_free_fn);
	strcat(ret,";Utworzono");

	HPDF_Stream str = HPDF_MemStream_New  (mmgr,size);

	strcat(ret,";Utworzono2");

HPDF_MemStream_Rewrite  (str,font_data,size);

	strcat(ret,";Utworzono3");

//	char *ret2 = LoadTTFontFromStream (pdf, str,embedding, file_name);
       char *ok; 
	if ( HPDF_Stream_Validate (font_data) )
          ok = "stream ok"; 
      else 
             ok = "blad streamu";
	strcat(ret, ok);
	return ret;
*/

}


static const char*
LoadTTFontFromStream (HPDF_Doc         pdf,
                      HPDF_Stream      font_data,
                      HPDF_BOOL        embedding,
                      const char      *file_name)
{
    HPDF_FontDef def;

    HPDF_PTRACE ((" HPDF_LoadTTFontFromStream\n"));
	printf("load ttf from stream\n");
    def = HPDF_TTFontDef_Load (pdf->mmgr, font_data, embedding);
    if (def) {
        HPDF_FontDef  tmpdef = HPDF_Doc_FindFontDef (pdf, def->base_font);
        if (tmpdef) {
			printf("BLAD tmpdef\n");
            HPDF_FontDef_Free (def);
            HPDF_SetError (&pdf->error, HPDF_FONT_EXISTS, 0);
            return NULL;
        }

        if (HPDF_List_Add (pdf->fontdef_list, def) != HPDF_OK) {
            HPDF_FontDef_Free (def);
            return NULL;
        }
    } else
        return NULL;

    if (embedding) {
        if (pdf->ttfont_tag[0] == 0) {
            HPDF_MemCpy (pdf->ttfont_tag, "HPDFAA", 6);
        } else {
            HPDF_INT i;

            for (i = 5; i >= 0; i--) {
                pdf->ttfont_tag[i] += 1;
                if (pdf->ttfont_tag[i] > 'Z')
                    pdf->ttfont_tag[i] = 'A';
                else
                    break;
            }
        }

        HPDF_TTFontDef_SetTagName (def, pdf->ttfont_tag);
    }

    return def->base_font;
}


HPDF_EXPORT(const char*)
HPDF_LoadTTFontFromFile2 (HPDF_Doc         pdf,
                          const char      *file_name,
                          HPDF_UINT        index,
                          HPDF_BOOL        embedding)
{
    HPDF_Stream font_data;
    const char *ret;

    HPDF_PTRACE ((" HPDF_LoadTTFontFromFile2\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    /* create file stream */
    font_data = HPDF_FileReader_New (pdf->mmgr, file_name);

    if (HPDF_Stream_Validate (font_data)) {
        ret = LoadTTFontFromStream2 (pdf, font_data, index, embedding, file_name);
    } else
        ret = NULL;

    if (!ret)
        HPDF_CheckError (&pdf->error);

    return ret;
}


static const char*
LoadTTFontFromStream2 (HPDF_Doc         pdf,
                       HPDF_Stream      font_data,
                       HPDF_UINT        index,
                       HPDF_BOOL        embedding,
                       const char      *file_name)
{
    HPDF_FontDef def;

    HPDF_PTRACE ((" HPDF_LoadTTFontFromStream2\n"));

    def = HPDF_TTFontDef_Load2 (pdf->mmgr, font_data, index, embedding);
    if (def) {
        HPDF_FontDef  tmpdef = HPDF_Doc_FindFontDef (pdf, def->base_font);
        if (tmpdef) {
            HPDF_FontDef_Free (def);
            HPDF_SetError (&pdf->error, HPDF_FONT_EXISTS, 0);
            return NULL;
        }

        if (HPDF_List_Add (pdf->fontdef_list, def) != HPDF_OK) {
            HPDF_FontDef_Free (def);
            return NULL;
        }
    } else
        return NULL;

    if (embedding) {
        if (pdf->ttfont_tag[0] == 0) {
            HPDF_MemCpy (pdf->ttfont_tag, "HPDFAA", 6);
        } else {
            HPDF_INT i;

            for (i = 5; i >= 0; i--) {
                pdf->ttfont_tag[i] += 1;
                if (pdf->ttfont_tag[i] > 'Z')
                    pdf->ttfont_tag[i] = 'A';
                else
                    break;
            }
        }

        HPDF_TTFontDef_SetTagName (def, pdf->ttfont_tag);
    }

    return def->base_font;
}


HPDF_EXPORT(HPDF_Image)
HPDF_LoadRawImageFromFile  (HPDF_Doc          pdf,
                            const char       *filename,
                            HPDF_UINT         width,
                            HPDF_UINT         height,
                            HPDF_ColorSpace   color_space)
{
    HPDF_Stream imagedata;
    HPDF_Image image;

    HPDF_PTRACE ((" HPDF_LoadRawImageFromFile\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    /* create file stream */
    imagedata = HPDF_FileReader_New (pdf->mmgr, filename);

    if (HPDF_Stream_Validate (imagedata))
        image = HPDF_Image_LoadRawImage (pdf->mmgr, imagedata, pdf->xref, width,
                    height, color_space);
    else
        image = NULL;

    /* destroy file stream */
    HPDF_Stream_Free (imagedata);

    if (!image)
        HPDF_CheckError (&pdf->error);

    if (pdf->compression_mode & HPDF_COMP_IMAGE)
        image->filter = HPDF_STREAM_FILTER_FLATE_DECODE;

    return image;
}


HPDF_EXPORT(HPDF_Image)
HPDF_LoadRawImageFromMem  (HPDF_Doc           pdf,
                           const HPDF_BYTE   *buf,
                           HPDF_UINT          width,
                           HPDF_UINT          height,
                           HPDF_ColorSpace    color_space,
                           HPDF_UINT          bits_per_component)
{
    HPDF_Image image;

    HPDF_PTRACE ((" HPDF_LoadRawImageFromMem\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    image = HPDF_Image_LoadRawImageFromMem (pdf->mmgr, buf, pdf->xref, width,
                height, color_space, bits_per_component);

    if (!image)
        HPDF_CheckError (&pdf->error);

    if (pdf->compression_mode & HPDF_COMP_IMAGE)
        image->filter = HPDF_STREAM_FILTER_FLATE_DECODE;

    return image;
}


HPDF_EXPORT(HPDF_Image)
HPDF_LoadJpegImageFromFile  (HPDF_Doc     pdf,
                             const char  *filename)
{
    HPDF_Stream imagedata;
    HPDF_Image image;

    HPDF_PTRACE ((" HPDF_LoadJpegImageFromFile\n"));

    if (!HPDF_HasDoc (pdf))
        return NULL;

    /* create file stream */
    imagedata = HPDF_FileReader_New (pdf->mmgr, filename);

    if (HPDF_Stream_Validate (imagedata))
        image = HPDF_Image_LoadJpegImage (pdf->mmgr, imagedata, pdf->xref);
    else
        image = NULL;

    /* destroy file stream */
    HPDF_Stream_Free (imagedata);

    if (!image)
        HPDF_CheckError (&pdf->error);

    return image;
}


/*----- Catalog ------------------------------------------------------------*/

HPDF_EXPORT(HPDF_PageLayout)
HPDF_GetPageLayout  (HPDF_Doc   pdf)
{
    HPDF_PTRACE ((" HPDF_GetPageLayout\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_PAGE_LAYOUT_SINGLE;

    return HPDF_Catalog_GetPageLayout (pdf->catalog);
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetPageLayout  (HPDF_Doc          pdf,
                     HPDF_PageLayout   layout)
{
    HPDF_STATUS ret;

    HPDF_PTRACE ((" HPDF_GetPageLayout\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (layout < 0 || layout >= HPDF_PAGE_LAYOUT_EOF)
        return HPDF_RaiseError (&pdf->error, HPDF_PAGE_LAYOUT_OUT_OF_RANGE,
                (HPDF_STATUS)layout);

    ret = HPDF_Catalog_SetPageLayout (pdf->catalog, layout);
    if (ret != HPDF_OK)
        HPDF_CheckError (&pdf->error);

    return HPDF_OK;
}

HPDF_EXPORT(HPDF_PageMode)
HPDF_GetPageMode  (HPDF_Doc   pdf)
{
    HPDF_PTRACE ((" HPDF_GetPageMode\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_PAGE_MODE_USE_NONE;

    return HPDF_Catalog_GetPageMode (pdf->catalog);
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetPageMode  (HPDF_Doc        pdf,
                   HPDF_PageMode   mode)
{
    HPDF_STATUS ret;

    HPDF_PTRACE ((" HPDF_GetPageMode\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (mode < 0 || mode >= HPDF_PAGE_MODE_EOF)
        return HPDF_RaiseError (&pdf->error, HPDF_PAGE_MODE_OUT_OF_RANGE,
                (HPDF_STATUS)mode);

    ret = HPDF_Catalog_SetPageMode (pdf->catalog, mode);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return HPDF_OK;
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetOpenAction  (HPDF_Doc            pdf,
                     HPDF_Destination    open_action)
{
    HPDF_STATUS ret;

    HPDF_PTRACE ((" HPDF_SetOpenAction\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (open_action && !HPDF_Destination_Validate (open_action))
        return HPDF_RaiseError (&pdf->error, HPDF_INVALID_DESTINATION, 0);

    ret = HPDF_Catalog_SetOpenAction (pdf->catalog, open_action);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return HPDF_OK;
}


HPDF_EXPORT(HPDF_UINT)
HPDF_GetViewerPreference  (HPDF_Doc   pdf)
{
    HPDF_PTRACE ((" HPDF_Catalog_GetViewerPreference\n"));

    if (!HPDF_HasDoc (pdf))
        return 0;

    return HPDF_Catalog_GetViewerPreference (pdf->catalog);
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetViewerPreference  (HPDF_Doc     pdf,
                           HPDF_UINT    value)
{
    HPDF_STATUS ret;

    HPDF_PTRACE ((" HPDF_Catalog_SetViewerPreference\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    ret = HPDF_Catalog_SetViewerPreference (pdf->catalog, value);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return HPDF_OK;
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_AddPageLabel  (HPDF_Doc             pdf,
                    HPDF_UINT            page_num,
                    HPDF_PageNumStyle    style,
                    HPDF_UINT            first_page,
                    const char     *prefix)
{
    HPDF_Dict page_label;
    HPDF_STATUS ret;

    HPDF_PTRACE ((" HPDF_AddPageLabel\n"));

    if (!HPDF_HasDoc (pdf))
        return HPDF_INVALID_DOCUMENT;

    page_label = HPDF_PageLabel_New (pdf, style, first_page, prefix);

    if (!page_label)
        return HPDF_CheckError (&pdf->error);

    if (style < 0 || style >= HPDF_PAGE_NUM_STYLE_EOF)
        return HPDF_RaiseError (&pdf->error, HPDF_PAGE_NUM_STYLE_OUT_OF_RANGE,
                    (HPDF_STATUS)style);

    ret = HPDF_Catalog_AddPageLabel (pdf->catalog, page_num, page_label);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return HPDF_OK;
}


/*----- Info ---------------------------------------------------------------*/

static HPDF_Dict
GetInfo  (HPDF_Doc  pdf)
{
    if (!HPDF_HasDoc (pdf))
        return NULL;

    if (!pdf->info) {
        pdf->info = HPDF_Dict_New (pdf->mmgr);

        if (!pdf->info || HPDF_Xref_Add (pdf->xref, pdf->info) != HPDF_OK)
            pdf->info = NULL;
    }

    return pdf->info;
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetInfoAttr  (HPDF_Doc          pdf,
                   HPDF_InfoType     type,
                   const char  *value)
{
    HPDF_STATUS ret;
    HPDF_Dict info = GetInfo (pdf);

    HPDF_PTRACE((" HPDF_SetInfoAttr\n"));

    if (!info)
        return HPDF_CheckError (&pdf->error);

    ret = HPDF_Info_SetInfoAttr (info, type, value, pdf->cur_encoder);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return ret;
}


HPDF_EXPORT(const char*)
HPDF_GetInfoAttr  (HPDF_Doc        pdf,
                   HPDF_InfoType   type)
{
    const char *ret = NULL;
    HPDF_Dict info = GetInfo (pdf);

    HPDF_PTRACE((" HPDF_GetInfoAttr\n"));

    if (info)
        ret = HPDF_Info_GetInfoAttr (info, type);
    else
        HPDF_CheckError (&pdf->error);

    return ret;
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetInfoDateAttr  (HPDF_Doc        pdf,
                       HPDF_InfoType   type,
                       HPDF_Date       value)
{
    HPDF_STATUS ret;
    HPDF_Dict info = GetInfo (pdf);

    HPDF_PTRACE((" HPDF_SetInfoDateAttr\n"));

    if (!info)
        return HPDF_CheckError (&pdf->error);

    ret = HPDF_Info_SetInfoDateAttr (info, type, value);
    if (ret != HPDF_OK)
        return HPDF_CheckError (&pdf->error);

    return ret;
}


HPDF_EXPORT(HPDF_Outline)
HPDF_CreateOutline  (HPDF_Doc       pdf,
                     HPDF_Outline   parent,
                     const char    *title,
                     HPDF_Encoder   encoder)
{
    HPDF_Outline outline;

    if (!HPDF_HasDoc (pdf))
        return NULL;

    if (!parent) {
        if (pdf->outlines) {
            parent = pdf->outlines;
        } else {
            pdf->outlines = HPDF_OutlineRoot_New (pdf->mmgr, pdf->xref);

            if (pdf->outlines) {
                HPDF_STATUS ret = HPDF_Dict_Add (pdf->catalog, "Outlines",
                            pdf->outlines);
                if (ret != HPDF_OK) {
                    HPDF_CheckError (&pdf->error);
                    pdf->outlines = NULL;
                    return NULL;
                }

                parent = pdf->outlines;
            } else {
                HPDF_CheckError (&pdf->error);
                return NULL;
            }
        }
    }

    if (!HPDF_Outline_Validate (parent) || pdf->mmgr != parent->mmgr) {
        HPDF_RaiseError (&pdf->error, HPDF_INVALID_OUTLINE, 0);
        return NULL;
    }

    outline = HPDF_Outline_New (pdf->mmgr, parent, title, encoder, pdf->xref);
    if (!outline)
        HPDF_CheckError (&pdf->error);

    return outline;
}


HPDF_EXPORT(HPDF_ExtGState)
HPDF_CreateExtGState  (HPDF_Doc  pdf)
{
    rewrited to HPDF_Doc
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_SetCompressionMode  (HPDF_Doc    pdf,
                          HPDF_UINT   mode)
{
    if (!HPDF_Doc_Validate (pdf))
        return HPDF_INVALID_DOCUMENT;

    if (mode != (mode & HPDF_COMP_MASK))
        return HPDF_RaiseError (&pdf->error, HPDF_INVALID_COMPRESSION_MODE, 0);

#ifndef HPDF_NOZLIB
    pdf->compression_mode = mode;

    return HPDF_OK;

#else /* HPDF_NOZLIB */

    return HPDF_INVALID_COMPRESSION_MODE;

#endif /* HPDF_NOZLIB */
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_GetError  (HPDF_Doc   pdf)
{
    if (!HPDF_Doc_Validate (pdf))
        return HPDF_INVALID_DOCUMENT;

    return HPDF_Error_GetCode (&pdf->error);
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_GetErrorDetail  (HPDF_Doc   pdf)
{
    if (!HPDF_Doc_Validate (pdf))
        return HPDF_INVALID_DOCUMENT;

    return HPDF_Error_GetDetailCode (&pdf->error);
}


HPDF_EXPORT(void)
HPDF_ResetError  (HPDF_Doc   pdf)
{
    if (!HPDF_Doc_Validate (pdf))
        return;

    HPDF_Error_Reset (&pdf->error);
}

