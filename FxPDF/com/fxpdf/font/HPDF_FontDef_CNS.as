package com.fxpdf.font
{
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.enum.HPDF_FontDefType;

	public class HPDF_FontDef_CNS
	{
		public function HPDF_FontDef_CNS()
		{
		}
		
		public static function SimSun_Init( fontdef : HPDF_CIDFontDef ):void
		{
			trace (" HPDF_FontDef_SimSun_Init");
			
			fontdef.ascent 		= 859;
			fontdef.descent 	= -140;
			fontdef.capHeight 	= 683;
			fontdef.fontBBox = new HPDF_Box(0, -140, 996, 855);
			fontdef.flags = HPDF_FontDef.HPDF_FONT_SYMBOLIC + HPDF_FontDef.HPDF_FONT_FIXED_WIDTH +
				HPDF_FontDef.HPDF_FONT_SERIF;
			fontdef.italicAngle = 0;
			fontdef.stemv = 78;
			
			fontdef.HPDF_CIDFontDef_AddWidth( SIMSUN_W_ARRAY );
			
			fontdef.type  = HPDF_FontDefType.HPDF_FONTDEF_TYPE_CID;
			fontdef.valid = true;
			
		}
		
		
		
		private static const SIMSUN_W_ARRAY : Array = [
			new HPDF_CID_Width(668, 500),
			new HPDF_CID_Width(669, 500),
			new HPDF_CID_Width(670, 500),
			new HPDF_CID_Width(671, 500),
			new HPDF_CID_Width(672, 500),
			new HPDF_CID_Width(673, 500),
			new HPDF_CID_Width(674, 500),
			new HPDF_CID_Width(675, 500),
			new HPDF_CID_Width(676, 500),
			new HPDF_CID_Width(677, 500),
			new HPDF_CID_Width(678, 500),
			new HPDF_CID_Width(679, 500),
			new HPDF_CID_Width(680, 500),
			new HPDF_CID_Width(681, 500),
			new HPDF_CID_Width(682, 500),
			new HPDF_CID_Width(683, 500),
			new HPDF_CID_Width(684, 500),
			new HPDF_CID_Width(685, 500),
			new HPDF_CID_Width(686, 500),
			new HPDF_CID_Width(687, 500),
			new HPDF_CID_Width(688, 500),
			new HPDF_CID_Width(689, 500),
			new HPDF_CID_Width(690, 500),
			new HPDF_CID_Width(691, 500),
			new HPDF_CID_Width(692, 500),
			new HPDF_CID_Width(693, 500),
			new HPDF_CID_Width(694, 500),
			new HPDF_CID_Width(696, 500),
			new HPDF_CID_Width(697, 500),
			new HPDF_CID_Width(698, 500),
			new HPDF_CID_Width(699, 500),
			new HPDF_CID_Width(814, 500),
			new HPDF_CID_Width(815, 500),
			new HPDF_CID_Width(816, 500),
			new HPDF_CID_Width(817, 500),
			new HPDF_CID_Width(818, 500),
			new HPDF_CID_Width(819, 500),
			new HPDF_CID_Width(820, 500),
			new HPDF_CID_Width(821, 500),
			new HPDF_CID_Width(822, 500),
			new HPDF_CID_Width(823, 500),
			new HPDF_CID_Width(824, 500),
			new HPDF_CID_Width(825, 500),
			new HPDF_CID_Width(826, 500),
			new HPDF_CID_Width(827, 500),
			new HPDF_CID_Width(828, 500),
			new HPDF_CID_Width(829, 500),
			new HPDF_CID_Width(830, 500),
			new HPDF_CID_Width(831, 500),
			new HPDF_CID_Width(832, 500),
			new HPDF_CID_Width(833, 500),
			new HPDF_CID_Width(834, 500),
			new HPDF_CID_Width(835, 500),
			new HPDF_CID_Width(836, 500),
			new HPDF_CID_Width(837, 500),
			new HPDF_CID_Width(838, 500),
			new HPDF_CID_Width(839, 500),
			new HPDF_CID_Width(840, 500),
			new HPDF_CID_Width(841, 500),
			new HPDF_CID_Width(842, 500),
			new HPDF_CID_Width(843, 500),
			new HPDF_CID_Width(844, 500),
			new HPDF_CID_Width(845, 500),
			new HPDF_CID_Width(846, 500),
			new HPDF_CID_Width(847, 500),
			new HPDF_CID_Width(848, 500),
			new HPDF_CID_Width(849, 500),
			new HPDF_CID_Width(850, 500),
			new HPDF_CID_Width(851, 500),
			new HPDF_CID_Width(852, 500),
			new HPDF_CID_Width(853, 500),
			new HPDF_CID_Width(854, 500),
			new HPDF_CID_Width(855, 500),
			new HPDF_CID_Width(856, 500),
			new HPDF_CID_Width(857, 500),
			new HPDF_CID_Width(858, 500),
			new HPDF_CID_Width(859, 500),
			new HPDF_CID_Width(860, 500),
			new HPDF_CID_Width(861, 500),
			new HPDF_CID_Width(862, 500),
			new HPDF_CID_Width(863, 500),
			new HPDF_CID_Width(864, 500),
			new HPDF_CID_Width(865, 500),
			new HPDF_CID_Width(866, 500),
			new HPDF_CID_Width(867, 500),
			new HPDF_CID_Width(868, 500),
			new HPDF_CID_Width(869, 500),
			new HPDF_CID_Width(870, 500),
			new HPDF_CID_Width(871, 500),
			new HPDF_CID_Width(872, 500),
			new HPDF_CID_Width(873, 500),
			new HPDF_CID_Width(874, 500),
			new HPDF_CID_Width(875, 500),
			new HPDF_CID_Width(876, 500),
			new HPDF_CID_Width(877, 500),
			new HPDF_CID_Width(878, 500),
			new HPDF_CID_Width(879, 500),
			new HPDF_CID_Width(880, 500),
			new HPDF_CID_Width(881, 500),
			new HPDF_CID_Width(882, 500),
			new HPDF_CID_Width(883, 500),
			new HPDF_CID_Width(884, 500),
			new HPDF_CID_Width(885, 500),
			new HPDF_CID_Width(886, 500),
			new HPDF_CID_Width(887, 500),
			new HPDF_CID_Width(888, 500),
			new HPDF_CID_Width(889, 500),
			new HPDF_CID_Width(890, 500),
			new HPDF_CID_Width(891, 500),
			new HPDF_CID_Width(892, 500),
			new HPDF_CID_Width(893, 500),
			new HPDF_CID_Width(894, 500),
			new HPDF_CID_Width(895, 500),
			new HPDF_CID_Width(896, 500),
			new HPDF_CID_Width(897, 500),
			new HPDF_CID_Width(898, 500),
			new HPDF_CID_Width(899, 500),
			new HPDF_CID_Width(900, 500),
			new HPDF_CID_Width(901, 500),
			new HPDF_CID_Width(902, 500),
			new HPDF_CID_Width(903, 500),
			new HPDF_CID_Width(904, 500),
			new HPDF_CID_Width(905, 500),
			new HPDF_CID_Width(906, 500),
			new HPDF_CID_Width(907, 500),
			new HPDF_CID_Width(7716, 500),
			new HPDF_CID_Width(0xFFFF, 0) ];
		
		}
	}