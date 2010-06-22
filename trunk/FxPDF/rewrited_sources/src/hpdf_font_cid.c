/*
 * << Haru Free PDF Library 2.0.3 >> -- hpdf_font_cid.c
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
 * 2006.08.04 modified MeasureText().
 */

#include "hpdf_conf.h"
#include "hpdf_utils.h"
#include "hpdf_font.h"

static HPDF_Font
CIDFontType0_New (HPDF_Font parent,
                  HPDF_Xref xref);


static HPDF_Font
CIDFontType2_New (HPDF_Font parent,
                  HPDF_Xref xref);


static HPDF_TextWidth
TextWidth  (HPDF_Font         font,
            const HPDF_BYTE  *text,
            HPDF_UINT         len);


static HPDF_UINT
MeasureText  (HPDF_Font         font,
              const HPDF_BYTE  *text,
              HPDF_UINT         len,
              HPDF_REAL         width,
              HPDF_REAL         font_size,
              HPDF_REAL         char_space,
              HPDF_REAL         word_space,
              HPDF_BOOL         wordwrap,
              HPDF_REAL        *real_width);


static char*
UINT16ToHex  (char     *s,
              HPDF_UINT16    val,
              char     *eptr);


static HPDF_Dict
CreateCMap  (HPDF_Encoder   encoder,
             HPDF_Xref      xref);


static void
OnFree_Func  (HPDF_Dict  obj);


static HPDF_STATUS
CIDFontType2_BeforeWrite_Func  (HPDF_Dict   obj);


/*--------------------------------------------------------------------------*/

HPDF_Font
HPDF_Type0Font_New  (HPDF_MMgr        mmgr,
                     HPDF_FontDef     fontdef,
                     HPDF_Encoder     encoder,
                     HPDF_Xref        xref)
{
    HPDF_Dict font;
    HPDF_FontAttr attr;
    HPDF_CMapEncoderAttr encoder_attr;
    HPDF_STATUS ret = 0;
    HPDF_Array descendant_fonts;

    HPDF_PTRACE ((" HPDF_Type0Font_New\n"));

    font = HPDF_Dict_New (mmgr);
    if (!font)
        return NULL;

    font->header.obj_class |= HPDF_OSUBCLASS_FONT;

    /* check whether the fontdef object and the encoder object is valid. */
    if (encoder->type != HPDF_ENCODER_TYPE_DOUBLE_BYTE) {
        HPDF_SetError(font->error, HPDF_INVALID_ENCODER_TYPE, 0);
        return NULL;
    }

    if (fontdef->type != HPDF_FONTDEF_TYPE_CID &&
        fontdef->type != HPDF_FONTDEF_TYPE_TRUETYPE) {
        HPDF_SetError(font->error, HPDF_INVALID_FONTDEF_TYPE, 0);
        return NULL;
    }

    attr = HPDF_GetMem (mmgr, sizeof(HPDF_FontAttr_Rec));
    if (!attr) {
        HPDF_Dict_Free (font);
        return NULL;
    }

    font->header.obj_class |= HPDF_OSUBCLASS_FONT;
    font->write_fn = NULL;
    font->free_fn = OnFree_Func;
    font->attr = attr;

    encoder_attr = (HPDF_CMapEncoderAttr)encoder->attr;

    HPDF_MemSet (attr, 0, sizeof(HPDF_FontAttr_Rec));

    attr->writing_mode = encoder_attr->writing_mode;
    attr->text_width_fn = TextWidth;
    attr->measure_text_fn = MeasureText;
    attr->fontdef = fontdef;
    attr->encoder = encoder;
    attr->xref = xref;

    if (HPDF_Xref_Add (xref, font) != HPDF_OK)
        return NULL;

    ret += HPDF_Dict_AddName (font, "Type", "Font");
    ret += HPDF_Dict_AddName (font, "BaseFont", fontdef->base_font);
    ret += HPDF_Dict_AddName (font, "Subtype", "Type0");

    if (fontdef->type == HPDF_FONTDEF_TYPE_CID) {
        ret += HPDF_Dict_AddName (font, "Encoding", encoder->name);
    } else {
        attr->cmap_stream = CreateCMap (encoder, xref);

        if (attr->cmap_stream) {
            ret += HPDF_Dict_Add (font, "Encoding", attr->cmap_stream);
        } else
            return NULL;
    }

    if (ret != HPDF_OK)
        return NULL;

    descendant_fonts = HPDF_Array_New (mmgr);
    if (!descendant_fonts)
        return NULL;

    if (HPDF_Dict_Add (font, "DescendantFonts", descendant_fonts) != HPDF_OK)
        return NULL;

    if (fontdef->type == HPDF_FONTDEF_TYPE_CID) {
        attr->descendant_font = CIDFontType0_New (font, xref);
        attr->type = HPDF_FONT_TYPE0_CID;
    } else {
        attr->descendant_font = CIDFontType2_New (font, xref);
        attr->type = HPDF_FONT_TYPE0_TT;
    }

    if (!attr->descendant_font)
        return NULL;
    else
        if (HPDF_Array_Add (descendant_fonts, attr->descendant_font) !=
                HPDF_OK)
            return NULL;

    return font;
}

static void
OnFree_Func  (HPDF_Dict  obj)
{
    HPDF_FontAttr attr = (HPDF_FontAttr)obj->attr;

    HPDF_PTRACE ((" HPDF_Type0Font_OnFree\n"));

    if (attr)
        HPDF_FreeMem (obj->mmgr, attr);
}

static HPDF_Font
CIDFontType0_New (HPDF_Font parent, HPDF_Xref xref)
{
   rewrited hpdf_type0font.
}

static HPDF_Font
CIDFontType2_New (HPDF_Font parent, HPDF_Xref xref)
{
  rewrited hpdf_type0font.
}


static HPDF_STATUS
CIDFontType2_BeforeWrite_Func  (HPDF_Dict obj)
{
    HPDF_FontAttr font_attr = (HPDF_FontAttr)obj->attr;
    HPDF_FontDef def = font_attr->fontdef;
    HPDF_TTFontDefAttr def_attr = (HPDF_TTFontDefAttr)def->attr;
    HPDF_STATUS ret = 0;

    HPDF_PTRACE ((" CIDFontType2_BeforeWrite_Func\n"));

    if (font_attr->map_stream)
        font_attr->map_stream->filter = obj->filter;

    if (font_attr->cmap_stream)
        font_attr->cmap_stream->filter = obj->filter;

    if (!font_attr->fontdef->descriptor) {
        HPDF_Dict descriptor = HPDF_Dict_New (obj->mmgr);
        HPDF_Array array;

        if (!descriptor)
            return HPDF_Error_GetCode (obj->error);

        if (def_attr->embedding) {
            HPDF_Dict font_data = HPDF_DictStream_New (obj->mmgr,
                    font_attr->xref);

            if (!font_data)
                return HPDF_Error_GetCode (obj->error);

            if (HPDF_TTFontDef_SaveFontData (font_attr->fontdef,
                font_data->stream) != HPDF_OK)
                return HPDF_Error_GetCode (obj->error);

            ret += HPDF_Dict_Add (descriptor, "FontFile2", font_data);
            ret += HPDF_Dict_AddNumber (font_data, "Length1",
                    def_attr->length1);
            ret += HPDF_Dict_AddNumber (font_data, "Length2", 0);
            ret += HPDF_Dict_AddNumber (font_data, "Length3", 0);

            font_data->filter = obj->filter;

            if (ret != HPDF_OK)
                return HPDF_Error_GetCode (obj->error);
        }

        ret += HPDF_Xref_Add (font_attr->xref, descriptor);
        ret += HPDF_Dict_AddName (descriptor, "Type", "FontDescriptor");
        ret += HPDF_Dict_AddNumber (descriptor, "Ascent", def->ascent);
        ret += HPDF_Dict_AddNumber (descriptor, "Descent", def->descent);
        ret += HPDF_Dict_AddNumber (descriptor, "Flags", def->flags);

        array = HPDF_Box_Array_New (obj->mmgr, def->font_bbox);
        ret += HPDF_Dict_Add (descriptor, "FontBBox", array);

        ret += HPDF_Dict_AddName (descriptor, "FontName", def_attr->base_font);
        ret += HPDF_Dict_AddNumber (descriptor, "ItalicAngle",
                def->italic_angle);
        ret += HPDF_Dict_AddNumber (descriptor, "StemV", def->stemv);
        ret += HPDF_Dict_AddNumber (descriptor, "XHeight", def->x_height);

        if (ret != HPDF_OK)
            return HPDF_Error_GetCode (obj->error);

        font_attr->fontdef->descriptor = descriptor;
    }

    if ((ret = HPDF_Dict_AddName (obj, "BaseFont",
                def_attr->base_font)) != HPDF_OK)
        return ret;

    if ((ret = HPDF_Dict_AddName (font_attr->descendant_font, "BaseFont",
                def_attr->base_font)) != HPDF_OK)
        return ret;

    return HPDF_Dict_Add (font_attr->descendant_font, "FontDescriptor",
                font_attr->fontdef->descriptor);
}


static HPDF_TextWidth
TextWidth  (HPDF_Font         font,
            const HPDF_BYTE  *text,
            HPDF_UINT         len)
{
    // rewrited to HPDF_FontAttr_Cid
}


static HPDF_UINT
MeasureText  (HPDF_Font          font,
              const HPDF_BYTE   *text,
              HPDF_UINT          len,
              HPDF_REAL          width,
              HPDF_REAL          font_size,
              HPDF_REAL          char_space,
              HPDF_REAL          word_space,
              HPDF_BOOL          wordwrap,
              HPDF_REAL         *real_width)
{
    // rewited 
}


static char*
UINT16ToHex  (char     *s,
              HPDF_UINT16    val,
              char     *eptr)
{
    HPDF_BYTE b[2];
    HPDF_UINT16 val2;
    char c;

    if (eptr - s < 7)
        return s;

    /* align byte-order */
    HPDF_MemCpy (b, (HPDF_BYTE *)&val, 2);
    val2 = (HPDF_UINT16)((HPDF_UINT16)b[0] << 8 | (HPDF_UINT16)b[1]);

    HPDF_MemCpy (b, (HPDF_BYTE *)&val2, 2);

    *s++ = '<';

    if (b[0] != 0) {
        c = b[0] >> 4;
        if (c <= 9)
            c += 0x30;
        else
            c += 0x41 - 10;
        *s++ = c;

        c = b[0] & 0x0f;
        if (c <= 9)
            c += 0x30;
        else
            c += 0x41 - 10;
        *s++ = c;
    }

    c = b[1] >> 4;
    if (c <= 9)
        c += 0x30;
    else
        c += 0x41 - 10;
    *s++ = c;

    c = b[1] & 0x0f;
    if (c <= 9)
        c += 0x30;
    else
        c += 0x41 - 10;
    *s++ = c;

    *s++ = '>';
    *s = 0;

    return s;
}


static HPDF_Dict
CreateCMap  (HPDF_Encoder   encoder,
             HPDF_Xref      xref)
{
    rewrited to HPDF_Type0Font.CreateCMap
}

