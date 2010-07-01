/*
 * << Haru Free PDF Library 2.0.3 >> -- hpdf_xref.h
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
#include "hpdf_objects.h"

static HPDF_STATUS
WriteTrailer  (HPDF_Xref     xref,
               HPDF_Stream   stream);


HPDF_Xref
HPDF_Xref_New  (HPDF_MMgr     mmgr,
                HPDF_UINT32   offset)
{
 rewrited

}


void
HPDF_Xref_Free  (HPDF_Xref  xref)
{
rewr
}


HPDF_STATUS
HPDF_Xref_Add  (HPDF_Xref  xref,
                void       *obj)
{
   rewrited
}

HPDF_XrefEntry
HPDF_Xref_GetEntry  (HPDF_Xref  xref,
                     HPDF_UINT  index)
{
    rewrited
}


HPDF_XrefEntry
HPDF_Xref_GetEntryByObjectId  (HPDF_Xref  xref,
                               HPDF_UINT  obj_id)
{
   rewrited
}


HPDF_STATUS
HPDF_Xref_WriteToStream  (HPDF_Xref    xref,
                          HPDF_Stream  stream,
                          HPDF_Encrypt e)
{
    rewr
}

static HPDF_STATUS
WriteTrailer  (HPDF_Xref     xref,
               HPDF_Stream   stream)
{
   rewr
}

