	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_06 segment stub. Retail $0169FA-$017A17.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$169FA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0169FA-$017A17, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddFramer = $11F12		;bsr.w / Bcc.w at $16ACA. middle94_2 (IDA sub_11F12)
AddPOStats = $182A2		;bsr.w / Bcc.w at $172B2
AddSmallFont = $11F04		;bsr.w / Bcc.w at $173BA. middle94_2 (IDA sub_11F04)
AddTeamBlock = $11F20		;bsr.w / Bcc.w at $173B6. middle94_2 (IDA sub_11F20)
Adda1Offset = $13510		;bsr.w / Bcc.w at $174D4
AllSndOff = $1A264		;jsr / jmp (x).l at $17288
DecompressGraphicsWithCallback = $1172C	;bsr.w / Bcc.w at $16AD8. middle94_2 (IDA sub_1172C)
DoDMA = $113E4			;bsr.w / Bcc.w at $176B4
DoDMA_clearCallbackPointer = $11738	;bsr.w / Bcc.w at $16A88. middle94_2 (IDA sub_11738)
DoDMA_nd2 = $114B8		;bsr.w / Bcc.w at $16D94. middle94_1 (IDA sub_114B8)
DoDMAlist = $15E82		;bsr.w / Bcc.w at $16B86
DoFill = $11544			;bsr.w / Bcc.w at $16A68
GameSetUp = $F739E		;jsr / jmp (x).l at $17312
Intermission = $130E6		;bsr.w / Bcc.w at $172B6
KillCrowd = $169D0		;bsr.w / Bcc.w at $172F0
MusicVB = $1A50A			;jsr / jmp (x).l at $176D2
ReadJoy1 = $11340		;bsr.w / Bcc.w at $17542
ReadJoy2 = $11358		;bsr.w / Bcc.w at $17548
ResetClock = $7814		;jsr (x).w at $17278. hockey94_01
RevRinkTiles = $B5188		;#x at $16A82
Rinktilelist = $5605A		;#x at $16C96
Rinktiles = $56062		;#x at $16A72
SetSPA = $1073A			;bsr.w / Bcc.w at $170E6
StartGame = $7742		;jmp (x).w at $17332. hockey94_01
StartPer = $7866			;jmp (x).w at $172C4. hockey94_01
UpdateScores = $1323E		;bsr.w / Bcc.w at $172A4
VBlank = $15D9A			;#x at $16B8E. video94_1 (IDA loc_15D9A)
Vmaddr = $11680			;bsr.w / Bcc.w at $176BC
addframe2 = $167AA		;bsr.w / Bcc.w at $16B56
cramfade = $10FB6		;bsr.w / Bcc.w at $176CA
dobitmap = $1169A		;bsr.w / Bcc.w at $173F0
eraser = $1197E			;bsr.w / Bcc.w at $1739C
forceblack = $10F32		;bsr.w / Bcc.w at $16BB0
newTitleScreen = $FF042		;jsr / jmp (x).l at $172F4
print = $11BA4			;bsr.w / Bcc.w at $17622
print2 = $11A48			;bsr.w / Bcc.w at $174E0
printz = $11B92			;bsr.w / Bcc.w at $17386
printz2 = $11A36			;bsr.w / Bcc.w at $174C0
rtss2 = $15464			;bsr.w / Bcc.w at $1733A. hockey94_05 (an rts)
setvram = $11594			;bsr.w / Bcc.w at $16A36
song = $11156			;bsr.w / Bcc.w at $172A0
EncodePW = $180FC		;bsr.w / Bcc.w at $172C8. IDA: sub_180FC
DisplayTeamStats = $9428			;jsr / jmp (x).l at $172DA. IDA: sub_9428
NextHomeHotPlayer = $F7144		;jsr / jmp (x).l at $1792E (IDA: sub_F7144)
NextAwayHotPlayer = $F7172		;jsr / jmp (x).l at $17938 (IDA: sub_F7172)
NextHomeColdPlayer = $F727C		;jsr / jmp (x).l at $17942 (IDA: sub_F727C)
NextAwayColdPlayer = $F72AA		;jsr / jmp (x).l at $1794C (IDA: sub_F72AA)
UserNameEntry = $FBB88		;jsr / jmp (x).l at $17318 (IDA: sub_FBB88)
ScoutCrowdRecord = $FCB9A		;jsr / jmp (x).l at $178C0 (IDA: sub_FCB9A)
ScoutingReport = $FCC76		;jsr / jmp (x).l at $1732C. IDA: sub_FCC76
GetTeamNickname = $FD5AE		;jsr / jmp (x).l at $178E6 (IDA: sub_FD5AE)
GetTeamArena = $FD5F4		;jsr / jmp (x).l at $1790E (IDA: sub_FD5F4)
LoadHomeTeamGfx = $FEA52		;jsr / jmp (x).l at $16A8C (IDA: sub_FEA52)
DrawPlayoffSprite = $FED2A		;jsr / jmp (x).l at $17536 (IDA: sub_FED2A)
PlayedByHome = $FEEC8		;jsr / jmp (x).l at $178CA (IDA: sub_FEEC8)
PlayedByAway = $FEF5A		;jsr / jmp (x).l at $178D4 (IDA: sub_FEF5A)
PlayoffTreeSetup = $1928E		;#x at $1743A. IDA: unk_1928E
ScoutTextScript = $4B5C0		;#x at $1774A (IDA: unk_4B5C0)
ScoutMap = $54E24		;#x at $173D6 (IDA: unk_54E24)
FaceOffMap = $55BF6		;#x at $16D0E (unk_55BFE is FaceOffMap+8)
RefsMap = $5C408		;#x at $16CF2 (unk_5C410 is RefsMap+8)
RefMap2 = $5CF64		;#x at $16CE4 (unk_5CF6C is RefMap2+8)
CrowdFrameList = $A4B54		;#x at $16AAC (unk_A4B5C is CrowdFrameList+8)
FaceOffSprites = $A78AE		;#x at $16D00 (unk_A78B6 is FaceOffSprites+8)
BigFontMap = $A9A10		;#x at $16AE8 (unk_A9A18 is BigFontMap+8)
SmallFontMap = $AAC52		;#x at $16AD2 (unk_AAC5A is SmallFontMap+8)
EnergyBarMap = $AB920		;#x at $16A9E (unk_AB928 is EnergyBarMap+8)
Teamblocksmap = $ABA14		;#x at $16D24 (IDA: unk_ABA14)
EASNmap = $B3530		;#x at $16CB0 (unk_B3538 is EASNmap+8)
Arrowsmap = $B3640		;#x at $1762A (IDA: unk_B3640)
PlayoffSprite = $F3098		;#x at $173F4 (IDA: unk_F3098)

; Main segment code
	include	hockey94_06.asm
