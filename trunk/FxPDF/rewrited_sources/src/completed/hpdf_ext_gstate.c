/*
 * << Haru Free PDF Library 2.0.0 >> -- hpdf_ext_gstate.c
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
#include "hpdf_ext_gstate.h"
#include "hpdf.h"

const static char  *HPDF_BM_NAMES[] = {
                                      "Normal",
                                      "Multiply",
                                      "Screen",
                                      "Overlay",
                                      "Darken",
                                      "Lighten",
                                      "ColorDodge",
                                      "ColorBurn",
                                      "HardLight",
                                      "SoftLight",
                                      "Difference",
                                      "Exclusion"
                                      };


HPDF_BOOL
HPDF_ExtGState_Validate  (HPDF_ExtGState  ext_gstate)
{
    rewrited to HPDF_ExtGstate
}


HPDF_STATUS
ExtGState_Check  (HPDF_ExtGState  ext_gstate)
{
  rewrited to HPDF_ExtGstate
}


HPDF_Dict
HPDF_ExtGState_New  (HPDF_MMgr   mmgr, 
                     HPDF_Xref   xref)
{
    rewrited to HPDF_ExtGstate
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_ExtGState_SetAlphaStroke  (HPDF_ExtGState   ext_gstate,
                                HPDF_REAL        value)
{
    rewrited to HPDF_ExtGstate
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_ExtGState_SetAlphaFill  (HPDF_ExtGState   ext_gstate,
                              HPDF_REAL        value)
{
    rewrited to HPDF_ExtGstate
}


HPDF_EXPORT(HPDF_STATUS)
HPDF_ExtGState_SetBlendMode  (HPDF_ExtGState   ext_gstate,
                              HPDF_BlendMode   bmode)
{
   rewrited to HPDF_ExtGstate
}

/*
HPDF_STATUS
HPDF_ExtGState_SetStrokeAdjustment  (HPDF_ExtGState   ext_gstate,
                                     HPDF_BOOL        value)
{
// not used
    HPDF_STATUS ret = ExtGState_Check (ext_gstate);
    
    if (ret != HPDF_OK)
        return ret;

    return HPDF_Dict_AddBoolean (ext_gstate, "SA", value);
}
*/

