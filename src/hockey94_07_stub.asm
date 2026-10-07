	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_07 segment stub. Retail $0FCB9A-$0FD617.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$FCB9A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0FCB9A-$0FD617, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddSmallFont = $11F04		;jsr / jmp (x).l at $FCD08
AttribAdjust = $FEF7C		;bsr.w / Bcc.w at $FD376
CalcAttrib = $FA9F8		;bsr.w / Bcc.w at $FD36C
Create_HotCold_Table = $F70A2	;jsr / jmp (x).l at $FCCA6
DecompressGraphicsWithCallback = $1172C	;jsr / jmp (x).l at $FCCFA
DoDMA_clearCallbackPointer = $11738	;jsr / jmp (x).l at $FCE18
Framer = $119B8			;jsr / jmp (x).l at $FCDA8
PushNumberWidth = $11D3A		;jsr / jmp (x).l at $FCFCC
TeamList = $30E			;#x at $FCC62
appstring = $11D9E		;jsr / jmp (x).l at $FCC26
clearTeamStats = $17102		;jsr / jmp (x).l at $FCC98
clrCrowdRAM = $F9BE2		;jsr / jmp (x).l at $FCBAC
dobitmap = $1169A		;jsr / jmp (x).l at $FCD62
PAttribOverallMask = $19420		;move.l (x).l operand at $FD310 (IDA: dword_19420)
GAttribOverallMask = $19582		;move.l (x).l operand at $FD31E (IDA: dword_19582)
eraser = $1197E			;jsr / jmp (x).l at $FD1E8
print2 = $11A48			;jsr / jmp (x).l at $FCFD2
printbigz = $11DE2		;jsr / jmp (x).l at $FCD68
printz = $11B92			;jsr / jmp (x).l at $FCD3E
printz2 = $11A36			;jsr / jmp (x).l at $FD206
setvram = $11594			;jsr / jmp (x).l at $FCCD6
song = $11156			;jsr / jmp (x).l at $FCC8A
StartScoutText = $17718		;jsr / jmp (x).l at $FCE5C (IDA: sub_17718)
ScoutTextPlayer = $17730		;jsr / jmp (x).l at $FCF5A (IDA: sub_17730)
BuildHotColdLists = $F71A2		;jsr / jmp (x).l at $FCC7C (IDA: sub_F71A2)
CompareHotColdTotals = $F7318		;jsr / jmp (x).l at $FCE72 (IDA: sub_F7318)
StartText = $F997A		;jsr / jmp (x).l at $FCC08 (IDA: sub_F997A)
AppendNumber = $F998E		;jsr / jmp (x).l at $FCBCA (IDA: sub_F998E)
ReadNameLog = $F9C68		;jsr / jmp (x).l at $FCC76 (IDA: sub_F9C68)
AppendUserName = $FA014		;bsr.w / Bcc.w at $FCC22 (IDA: sub_FA014)
DrawPlayerPicture = $FAE26		;jsr / jmp (x).l at $FD0EE (IDA: sub_FAE26)
PrintPlayerNameRight = $FD89A		;bsr.w / Bcc.w at $FD368 (IDA: sub_FD89A)
GetTeamRating = $FE172		;bsr.w / Bcc.w at $FCFC0 (IDA: sub_FE172)
UnpackPicture = $FE98A		;bsr.w / Bcc.w at $FD170 (IDA: sub_FE98A)
ScoutMap = $54E24		;#x at $FCD4A (IDA: unk_54E24)
framermap = $55B7E		;#x at $FCD26 (unk_55B86 is framermap+8)
BigFontMap = $A9A10		;#x at $FCCF4 (unk_A9A18 is BigFontMap+8)
SmallFontMap = $AAC52		;#x at $FCD12 (unk_AAC5A is SmallFontMap+8)
RonBarrMap = $B389C		;#x at $FCDEE (IDA: unk_B389C)
PicturePalette = $C63F8		;#x at $FD150 (IDA: unk_C63F8)
HotIconMap = $F5AF6		;#x at $FCE0E (unk_F5AFE is HotIconMap+8)
ColdIconMap = $F5D1C		;#x at $FCE1E (unk_F5D24 is ColdIconMap+8)
TeamLogoBitmaps = $F86F2		;#x at $FD1F2 (IDA: unk_F86F2)
TeamLogoPalettes = $FF462		;#x at $FD19A (IDA: unk_FF462)
vb2 = $15E4C			;#x at $FCC90
waitx = $11176			;jsr / jmp (x).l at $FCEC4

; Main segment code
	include	hockey94_07.asm
