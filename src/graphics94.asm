;	graphics94.asm: retail $1AD90-$F66ED (899422 bytes), the sound data after the 68k driver (sound94) and the graphics, up to the
;	94 code in the high ROM. incbin only, no gap and no overlap. Each file is a slice of lst/nhl94.bin written by npm run extractassets
;	(extractAssets94.js) into Extracted\NHL94\Sound, Graphics and Text. One slice per IDA label. Labels are the IDA names (the
;	matched segments use them; SNASM symbols are case-insensitive), or for an address with no IDA label the name the matched segment
;	uses (IDA hid it in a string) or, for the team logos, logo<team>. Files use the 92 / 93 name where the 94 asset is the same one
;	(same use, mostly the same size), else the extractAssets94.js draft name where its slice lined up, else the label. A map's tiles
;	start past its 8-byte header: the IDA label there is written as label+8. Not labels (no slice starts there): the IDA names made
;	from constants (unk_1C000, unk_3FEB0, unk_44120, unk_50000, unk_E0000), from offsets or attribute longs read as addresses
;	(unk_2000A, unk_4082A, byte_408AA, unk_8000A), from a label difference (byte_2C266) and from data read as code (unk_1D491,
;	unk_2000D, unk_3000C, unk_40EE8, unk_8000C, unk_D0000, dword_EDF9B, loc_F4458 ... loc_F4F02).
unk_1AD90		;retail $1AD90-$1B01B (652 bytes). IDA unk_1AD90: the Z80 sound program. Z80_LoadROM (sound94) copies $295 bytes from here into Z80 RAM (through $1B024, into the sample table, as 93 does)
	incbin	..\Extracted\NHL94\Sound\unk_1AD90.bin
	even
unk_1B01C		;retail $1B01C-$2C247 (70188 bytes). IDA unk_1B01C: the PCM sample table (handle_command_10; 93 pcm_sample_table), 15 entries
	;of 8 bytes, then the PCM samples from $1B094. IDA unk_1C000 (an andi.l constant in the high ROM), unk_1D491 (data in hockey94_10 read as a
	;bcs.w), unk_2000A (an attribute long in hockey94_11) and unk_2000D (data in the high ROM read as code) are not labels
	incbin	..\Extracted\NHL94\Sound\unk_1B01C.bin
	even
unk_2C248		;retail $2C248-$2C647 (1024 bytes). IDA unk_2C248: 32 FM patches of 32 bytes (93 fm_instrument_patches;
	;UpdateChannelFrequencyAndVolume reads byte $1E, the pitch bend scale). IDA byte_2C266 (+$1E, from that label difference) is not a label
	incbin	..\Extracted\NHL94\Sound\fm_instrument_patches.bin
	even
unk_2C648		;retail $2C648-$2C707 (192 bytes). IDA unk_2C648: the event stream pointers of sounds 0-$2F (p_initfx; 93 word offsets)
	incbin	..\Extracted\NHL94\Sound\unk_2C648.bin
	even
off_2C708		;retail $2C708-$2CEF1 (2026 bytes). IDA off_2C708: the pointers of sounds $30-$7A, the songs (play_new_song reads the first), then the event streams of sounds 0-$2F from $2C834
	incbin	..\Extracted\NHL94\Sound\off_2C708.bin
	even
unk_2CEF2		;retail $2CEF2-$4B5BF (124622 bytes). IDA unk_2CEF2: the song event streams, song $30 (the first off_2C708 pointer) to song
	;$7A ($490E2). IDA unk_3000C, unk_40EE8 (data in the high ROM read as code), unk_3FEB0 (the Calc_Checksum long count), unk_4082A, byte_408AA
	;(the offsets in off_5DE7A) and unk_44120 (the string long #$44120 in SetLCmode2, logic94_1) are not labels
	incbin	..\Extracted\NHL94\Sound\unk_2CEF2.bin
	even
unk_4B5C0		;retail $4B5C0-$4B79F (480 bytes). IDA unk_4B5C0: the script sub_17730 (hockey94_06) types out word by word on the ScoutingReport (MATCHUPS) screen
	incbin	..\Extracted\NHL94\Text\unk_4B5C0.bin
	even
unk_4B7A0		;retail $4B7A0-$4DEED (10062 bytes). no IDA label (hidden in a setoptions string; hockey94_08 loads #$4B7A0): the game setup screen bitmap, 40 x 28 (93 GameSetUp.map.jim)
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-1.map.jim
	even
unk_4DEEE		;retail $4DEEE-$4E45B (1390 bytes). no IDA label (hidden in a setoptions string; hockey94_08 loads #$4DEEE): the second game setup bitmap
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-2.map.jim
	even
TitleScreenImg		;retail $4E45C-$52DA9 (18766 bytes). IDA TitleScreenImg: the newTitleScreen backdrop (high ROM). IDA unk_50000 (an addi.l constant in the high ROM) is not a label
	incbin	..\Extracted\NHL94\Graphics\Title94-1.map.jim
	even
NHLShieldImg		;retail $52DAA-$5338B (1506 bytes). IDA NHLShieldImg: the NHL shield on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-2.map.jim
	even
PAlogoImg		;retail $5338C-$5394D (1474 bytes). IDA PAlogoImg: the NHLPA logo on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-3.map.jim
	even
TitleImg		;retail $5394E-$54E23 (5334 bytes). IDA TitleImg: the title on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-4.map.jim
	even
unk_54E24		;retail $54E24-$55B7D (3418 bytes). IDA unk_54E24 (93 ScoutMap): the ScoutingReport and PlayoffScreen background
	incbin	..\Extracted\NHL94\Graphics\unknown5.map.jim
	even
framermap		;retail $55B7E-$55BF5 (120 bytes). IDA framermap (92 / 93 FramerMap): Framer
	incbin	..\Extracted\NHL94\Graphics\Framer.map.jim
	even
unk_55B86	equ	framermap+8	;retail $55B86. the framer tiles (AddFramer, ScoutingReport)
FaceOffMap		;retail $55BF6-$56059 (1124 bytes). IDA FaceOffMap (92 / 93 name): puckfaceoff2
	incbin	..\Extracted\NHL94\Graphics\FaceOff.map.jim
	even
unk_55BFE	equ	FaceOffMap+8	;retail $55BFE. the tiles (puckfaceoff2, sub_16D0A)
Rinktilelist		;retail $5605A-$5C407 (25518 bytes). IDA Rinktilelist (93 IceRinkMap): the ice rink (updatescroll, setupIceRinkMap, sub_A448, DisplayPeriodOver, crash)
	incbin	..\Extracted\NHL94\Graphics\IceRink94.map.jim
	even
Rinktiles	equ	Rinktilelist+8	;retail $56062. IDA Rinktiles: the rink tiles (setupice, ClrHor)
RefsMap		;retail $5C408-$5CF63 (2908 bytes). IDA RefsMap (92 / 93 name): the ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs.map.jim
	even
unk_5C410	equ	RefsMap+8	;retail $5C410. the tiles (puckpenshot, Endfaceoff, StartHL2, sub_16CEE)
unk_5CF64		;retail $5CF64-$5DE79 (3862 bytes). IDA unk_5CF64 (93 RefMap2): the horizontal ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs2.map.jim
	even
unk_5CF6C	equ	unk_5CF64+8	;retail $5CF6C. the tiles (chkprogress, sub_16CE0)
off_5DE7A		;retail $5DE7A-$5DE83 (10 bytes). IDA off_5DE7A: the sprite header (93 Sprites; addframe2): long offsets from here $4082A (to
	;$9E6A4) and $408AA (to frameSprData), then a word. IDA read the two offsets as the addresses unk_4082A and byte_408AA
	incbin	..\Extracted\NHL94\Graphics\off_5DE7A.bin
	even
Spritetiles		;retail $5DE84-$9E723 (264352 bytes). IDA Spritetiles: the sprite tiles (93 Sprites+$A; addframe2 adds the frame tile offset
	;to #Spritetiles). IDA unk_8000A (an attribute long in hockey94_11) and unk_8000C (data in the high ROM read as code) are not labels
	incbin	..\Extracted\NHL94\Graphics\Spritetiles.bin
	even
frameSprData		;retail $9E724-$A44C7 (23972 bytes). IDA frameSprData: the frame data at off_5DE7A + $408AA (93 FrameDataOff and SprDataBytes)
	incbin	..\Extracted\NHL94\Graphics\frameSprData.bin
	even
Hotlist		;retail $A44C8-$A4B53 (1676 bytes). IDA Hotlist (93 HotList): the hot spot byte pair of each frame (GetHot)
	incbin	..\Extracted\NHL94\Graphics\Hotlist.bin
	even
CrowdFrameList		;retail $A4B54-$A78AD (11610 bytes). IDA CrowdFrameList (93 CrowdSprites): showcrowd
	incbin	..\Extracted\NHL94\Graphics\Crowd.anim
	even
unk_A4B5C	equ	CrowdFrameList+8	;retail $A4B5C. the tiles (setupice, sub_16CD2)
unk_A78AE		;retail $A78AE-$A8921 (4212 bytes). IDA unk_A78AE (93 FaceOffSprites, same size): checkfo
	incbin	..\Extracted\NHL94\Graphics\FaceOff.anim
	even
unk_A78B6	equ	unk_A78AE+8	;retail $A78B6. the tiles (puckfaceoff2, sub_16CFC)
ZamFrameList		;retail $A8922-$A9A0F (4334 bytes). IDA ZamFrameList (93 ZamSprites): showzam
	incbin	..\Extracted\NHL94\Graphics\Zam.anim
	even
unk_A892A	equ	ZamFrameList+8	;retail $A892A. the tiles (Intermission)
unk_A9A10		;retail $A9A10-$AAC51 (4674 bytes). IDA unk_A9A10 (93 BigFontMap): the big font (sub_11E8E)
	incbin	..\Extracted\NHL94\Graphics\BigFont94.map.jim
	even
unk_A9A18	equ	unk_A9A10+8	;retail $A9A18. the tiles (setupice, ScoutingReport, sub_FAFE4)
unk_AAC52		;retail $AAC52-$AB91F (3278 bytes). IDA unk_AAC52 (93 SmallFontMap, same size): the small font (print, print2, showclock, RenderSmallFontChar)
	incbin	..\Extracted\NHL94\Graphics\SmallFont.map.jim
	even
unk_AAC5A	equ	unk_AAC52+8	;retail $AAC5A. the tiles (AddSmallFont, setupice, ScoutingReport, setoptions)
unk_AB920		;retail $AB920-$ABA13 (244 bytes). IDA unk_AB920 (93 EnergyBarMap, same size): the line energy bar frames (linebar)
	incbin	..\Extracted\NHL94\Graphics\EnergyBar.map.jim
	even
unk_AB928	equ	unk_AB920+8	;retail $AB928. the tiles (setupice, sub_16CC4)
unk_ABA14		;retail $ABA14-$AFE11 (17406 bytes). IDA unk_ABA14 (93 Teamblocksmap): the team blocks (setupTeamBlocksMap, DrawTeamBlocks, sub_17B98)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks.map.jim
	even
unk_ABA1C	equ	unk_ABA14+8	;retail $ABA1C. the tiles (AddTeamBlock)
unk_AFE12		;retail $AFE12-$B352F (14110 bytes). IDA unk_AFE12: 94 only, dobitmap entries (sub_17B78)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks94.map.jim
	even
unk_AFE1A	equ	unk_AFE12+8	;retail $AFE1A. the tiles (sub_F84D0, where 93 setoptions called AddTeamBlock)
unk_B3530		;retail $B3530-$B363F (272 bytes). IDA unk_B3530 (93 EASNmap): the EASN logo (EASNLogo)
	incbin	..\Extracted\NHL94\Graphics\EASN.map.jim
	even
unk_B3538	equ	unk_B3530+8	;retail $B3538. the tiles (setupEASNmap)
unk_B3640		;retail $B3640-$B389B (604 bytes). IDA unk_B3640 (93 Arrowsmap, same size): the playoff tree arrows (DrawPlayoffBracket)
	incbin	..\Extracted\NHL94\Graphics\Arrows.map.jim
	even
unk_B3648	equ	unk_B3640+8	;retail $B3648. the tiles (PlayoffScreen)
unk_B389C		;retail $B389C-$B3E73 (1496 bytes). IDA unk_B389C (93 Ronbarrmap, same size): the Ron Barr picture (ScoutingReport). The old
	;extractAssets94.js RonBarrCompressed.map.jim ran 4 bytes into unk_B3E74
	incbin	..\Extracted\NHL94\Graphics\RonBarr.map.jim
	even
unk_B3E74		;retail $B3E74-$B4259 (998 bytes). IDA unk_B3E74 (93 ScoresMap, same size): read by the 93 ShowScores code (stats94, from $80D4, no IDA label; not matched yet)
	incbin	..\Extracted\NHL94\Graphics\Scores.map.jim
	even
unk_B425A		;retail $B425A-$B517F (3878 bytes). no IDA label (hidden in the EASportsScreen string; attract94 loads #$B425A): the EA Sports screen map
	incbin	..\Extracted\NHL94\Graphics\unk_B425A.bin
	even
RevRinkTilelist		;retail $B5180-$BB4ED (25454 bytes). IDA RevRinkTilelist: the reversed ice rink (updatescroll, sub_A448)
	incbin	..\Extracted\NHL94\Graphics\IceRink94Reverse.map.jim
	even
RevRinkTiles	equ	RevRinkTilelist+8	;retail $B5188. IDA RevRinkTiles: the tiles (setupice)
unk_BB4EE		;retail $BB4EE-$BC05B (2926 bytes). IDA unk_BB4EE: the replay map sub_A4A8 shows at 0,0 (16 x 11)
	incbin	..\Extracted\NHL94\Graphics\ReplayOptions.map.jim
	even
unk_BB4F6	equ	unk_BB4EE+8	;retail $BB4F6. the tiles (ReplayMode)
unk_BC05C		;retail $BC05C-$BE269 (8718 bytes). no IDA label (hidden in the SetHor string; penalty94_1 loads #$BC05C): SetHor (93 IceRinkMap)
	incbin	..\Extracted\NHL94\Graphics\PauseScreen.map.jim
	even
icerinkmap	equ	unk_BC05C+8	;retail $BC064. IDA icerinkmap: the tiles (SetHor)
unk_BE26A		;retail $BE26A-$BEFB7 (3406 bytes). IDA unk_BE26A: the second print font (print, print2)
	incbin	..\Extracted\NHL94\Graphics\SmallFont94.map.jim
	even
unk_BE272	equ	unk_BE26A+8	;retail $BE272. the tiles (setoptions: the setup screen font)
unk_BEFB8		;retail $BEFB8-$BF541 (1418 bytes). IDA unk_BEFB8: the setoptions menu background (setoptions, sub_F76D4)
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd1.map.jim
	even
unk_BF542		;retail $BF542-$BF701 (448 bytes). IDA unk_BF542: the setoptions framer
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd2.map.jim
	even
unk_BF54A	equ	unk_BF542+8	;retail $BF54A. the framer tiles (setoptions; 93 FramerMap+8)
unk_BF702		;retail $BF702-$BF8CF (462 bytes). IDA unk_BF702: the logo box (loc_F8796, sub_F8762)
	incbin	..\Extracted\NHL94\Graphics\GameSetupLogoBorder.map.jim
	even
unk_BF70A	equ	unk_BF702+8	;retail $BF70A. the tiles (setoptions, sub_FAFE4)
logoANA		;retail $BF8D0-$BFD65 (1174 bytes). no IDA label: the ANA logo, team 0 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoANA.map.jim
	even
logoBOS		;retail $BFD66-$C00BB (854 bytes). no IDA label: the BOS logo, team 1 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoBOS.map.jim
	even
logoBUF		;retail $C00BC-$C0411 (854 bytes). no IDA label: the BUF logo, team 2 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoBUF.map.jim
	even
logoCGY		;retail $C0412-$C08A7 (1174 bytes). no IDA label: the CGY logo, team 3 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoCGY.map.jim
	even
logoCHI		;retail $C08A8-$C0CDD (1078 bytes). no IDA label: the CHI logo, team 4 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoCHI.map.jim
	even
logoDET		;retail $C0CDE-$C1033 (854 bytes). no IDA label: the DET logo, team 6 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoDET.map.jim
	even
logoEDM		;retail $C1034-$C1429 (1014 bytes). no IDA label: the EDM logo, team 7 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoEDM.map.jim
	even
logoFLA		;retail $C142A-$C18FF (1238 bytes). no IDA label: the FLA logo, team 8 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoFLA.map.jim
	even
logoHFD		;retail $C1900-$C1B95 (662 bytes). no IDA label: the HFD logo, team 9 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoHFD.map.jim
	even
logoNYI		;retail $C1B96-$C1FEB (1110 bytes). no IDA label: the NYI logo, team 13 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoNYI.map.jim
	even
logoLA		;retail $C1FEC-$C2361 (886 bytes). no IDA label: the LA logo, team 10 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoLA.map.jim
	even
logoDAL		;retail $C2362-$C2637 (726 bytes). no IDA label: the DAL logo, team 5 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoDAL.map.jim
	even
logoMTL		;retail $C2638-$C29AD (886 bytes). no IDA label: the MTL logo, team 11 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoMTL.map.jim
	even
logoNJ		;retail $C29AE-$C2E63 (1206 bytes). no IDA label: the NJ logo, team 12 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoNJ.map.jim
	even
logoNYR		;retail $C2E64-$C3339 (1238 bytes). no IDA label: the NYR logo, team 14 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoNYR.map.jim
	even
logoOTW		;retail $C333A-$C374F (1046 bytes). no IDA label: the OTW logo, team 15 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoOTW.map.jim
	even
logoPHI		;retail $C3750-$C3B05 (950 bytes). no IDA label: the PHI logo, team 16 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoPHI.map.jim
	even
logoPIT		;retail $C3B06-$C3E7B (886 bytes). no IDA label: the PIT logo, team 17 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoPIT.map.jim
	even
logoQUE		;retail $C3E7C-$C41D1 (854 bytes). no IDA label: the QUE logo, team 18 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoQUE.map.jim
	even
logoSJ		;retail $C41D2-$C4607 (1078 bytes). no IDA label: the SJ logo, team 19 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoSJ.map.jim
	even
logoSTL		;retail $C4608-$C49DD (982 bytes). no IDA label: the STL logo, team 20 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoSTL.map.jim
	even
logoTB		;retail $C49DE-$C4DF3 (1046 bytes). no IDA label: the TB logo, team 21 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoTB.map.jim
	even
logoTOR		;retail $C4DF4-$C5149 (854 bytes). no IDA label: the TOR logo, team 22 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoTOR.map.jim
	even
logoVAN		;retail $C514A-$C555F (1046 bytes). no IDA label: the VAN logo, team 23 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoVAN.map.jim
	even
logoWSH		;retail $C5560-$C57D5 (630 bytes). no IDA label: the WSH logo, team 24 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoWSH.map.jim
	even
logoWPG		;retail $C57D6-$C5C4B (1142 bytes). no IDA label: the WPG logo, team 25 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoWPG.map.jim
	even
logoASE		;retail $C5C4C-$C6021 (982 bytes). no IDA label: the ASE logo, team 26 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoASE.map.jim
	even
logoASW		;retail $C6022-$C63F7 (982 bytes). no IDA label: the ASW logo, team 27 in unk_F86F2 (hockey94_08 loc_F865C, hockey94_07 sub_FD1F0)
	incbin	..\Extracted\NHL94\Graphics\logoASW.map.jim
	even
unk_C63F8		;retail $C63F8-$C682D (1078 bytes). IDA unk_C63F8: the player picture palette, and the picture of a player with none (sub_FD14A, sub_F8868)
	incbin	..\Extracted\NHL94\Graphics\unk_C63F8.bin
	even
unk_C682E		;retail $C682E-$C6B97 (874 bytes). IDA unk_C682E: read by sub_FAE26 (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_C682E.bin
	even
unk_C6B98		;retail $C6B98-$C6F01 (874 bytes). IDA unk_C6B98: read by sub_FAE26 (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_C6B98.bin
	even
unk_C6F02		;retail $C6F02-$C726B (874 bytes). IDA unk_C6F02: read by sub_FAE26 (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_C6F02.bin
	even
unk_C726C		;retail $C726C-$E9A7F (141332 bytes). IDA unk_C726C: read by sub_FAE26 (high ROM, not matched yet). IDA unk_D0000 (data read as code) and unk_E0000 (an andi.l constant) are not labels
	incbin	..\Extracted\NHL94\Graphics\unk_C726C.bin
	even
unk_E9A80		;retail $E9A80-$E9ED5 (1110 bytes). IDA unk_E9A80: read in the high ROM near unk_FA07C and by sub_FBBDE (not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_E9A80.bin
	even
unk_E9ED6		;retail $E9ED6-$F3097 (37314 bytes). IDA unk_E9ED6: read in the high ROM near unk_FA07C and by sub_FBBDE (not matched yet). IDA dword_EDF9B (data read as code) is not a label
	incbin	..\Extracted\NHL94\Graphics\unk_E9ED6.bin
	even
unk_F3098		;retail $F3098-$F5337 (8864 bytes). IDA unk_F3098: PlayoffScreen and sub_FED2A. The IDA code labels loc_F4458 ... loc_F4F02 in it are data read as code: not labels
	incbin	..\Extracted\NHL94\Graphics\unk_F3098.bin
	even
HiScoreImg		;retail $F5338-$F5AF5 (1982 bytes). IDA HiScoreImg: HiScoreScreen (high ROM)
	incbin	..\Extracted\NHL94\Graphics\HiScoreImg.bin
	even
unk_F5AF6		;retail $F5AF6-$F5D1B (550 bytes). IDA unk_F5AF6: read by sub_FF8DE (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_F5AF6.bin
	even
unk_F5AFE	equ	unk_F5AF6+8	;retail $F5AFE. the tiles (ScoutingReport)
unk_F5D1C		;retail $F5D1C-$F600D (754 bytes). IDA unk_F5D1C: read by sub_FF8DE (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\unk_F5D1C.bin
	even
unk_F5D24	equ	unk_F5D1C+8	;retail $F5D24. the tiles (ScoutingReport)
revframetbl		;retail $F600E-$F66ED (1760 bytes). IDA revframetbl: the replay frame table (RestoreReplayFrame)
	incbin	..\Extracted\NHL94\Graphics\revframetbl.bin
	even
