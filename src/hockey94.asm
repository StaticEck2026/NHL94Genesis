;
;	NHL 94 segment queue. Ranges are not confirmed yet.
;	The IDA listing has no address column. loc_ / sub_ / unk_ names are the address.
;	The first segment pass is main94. Confirm each start against lst/nhl94.bin.
;	Do not reorder these includes.
;
	include	Main94.Asm		;org 0. First pass. Not matched.
	include	TeamData94.Asm		;after main94. Existing draft, not matched.
	include	Ram94.Asm		;equates only

	include	hockey94_01.asm		;VBjsr, Begin. Listing line 29709. Next loc_76E8. SPAList ends near unk_73A0.
	include	attract94.asm		;94 only: EASportsScreen, HiScoreScreen, LoadDefMenuOptions
	include	hockey94_02.asm		;ReplayMode through updateanim, if present before doinput
	include	logic94_1.asm		;doinput. Listing line 35886, before loc_B470.
	include	logic94_2.asm		;assbench through the next 93 logic split
	include	logic94_3.asm
	include	logic94_4.asm		;checkob
	include	logic94_5.asm		;ChkOffsides
	include	middle94_1.asm		;remap
	include	middle94_2.asm		;dobitmap
	include	penalty94_1.asm		;AddPenalty
	include	penalty94_2.asm
	include	hockey94_03.asm		;checkcoll. Listing line 48484.
	include	hockey94_04.asm		;checkfight
	include	hockey94_05.asm		;puckstick
	include	video94_1.asm		;VBlank
	include	video94_2.asm		;showclock
	include	hockey94_06.asm		;setupice. Listing line 53024.
	include	hockey94_07.asm		;ScoutingReport, title, 94 screens
	include	hockey94_08.asm		;setoptions
	include	hockey94_09.asm		;DefaultMenus, password
	include	hockey94_10.asm		;ResolveGames, crash
	include	hockey94_11.asm		;cd0, PenaltyList, text tables
	include	sram94.asm		;InitSaveRAM, backup RAM
	include	sound94.asm		;p_turnoff / AllSndOff, then Z80 and sound data
	include	graphics94.asm		;graphics incbins
	include	checksum94.asm		;SecurityCheck, ValidationRoutine. Existing file.
	dcb.b	$80000-*,$FF
