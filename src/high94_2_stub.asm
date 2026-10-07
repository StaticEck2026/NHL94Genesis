	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	high94_2 segment stub. Retail $0F8B5A-$0FCB99.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$F8B5A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0F8B5A-$0FCB99, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddSmallFont = $11F04		;jsr / jmp (x).l at $FB0B6
AttribAdjust = $FEF7C		;bsr.w / Bcc.w at $FA916
DecompressGraphicsWithCallback = $1172C	;jsr / jmp (x).l at $FA0EE
DoDMA_clearCallbackPointer = $11738	;jsr / jmp (x).l at $FB118
ExitAttributeScreen2 = $9CD8	;jsr / jmp (x).l at $FA29C
ExitToOpening = $172E4		;jsr / jmp (x).l at $FC4CA
FormatPlayerNameShort = $18B6E	;jsr / jmp (x).l at $FA9B0
FormatPlayerNameWithAttrib = $18AE8	;jsr / jmp (x).l at $FC366
Framer = $119B8			;jsr / jmp (x).l at $FB186
GetPlayerCount = $9F9A		;jsr / jmp (x).l at $F9FF4
MakeSRAMChecksum = $1A206	;jsr / jmp (x).l at $F9DCE
PrintTeamData = $8078		;jsr / jmp (x).l at $FC9FE
ProcessInputWithRepeat = $11318	;jsr / jmp (x).l at $FA220
PushNumberWidth = $11D3A		;jsr / jmp (x).l at $FAC2C
ReadAttributeNibble = $9F40	;jsr / jmp (x).l at $F9FCA
ReadJoy1 = $11340		;jsr / jmp (x).l at $FB2EE
ReadJoy2 = $11358		;jsr / jmp (x).l at $FB2E0
ReadSRAM = $1A244		;jsr / jmp (x).l at $F9BCE
SetupScreen = $9BD8		;jsr / jmp (x).l at $FBC1C
VBlank_SetOptions = $17C42	;#x at $FB024
Vmaddr = $11680			;jsr / jmp (x).l at $FA0A6
WriteSRAM = $1A1E4		;jsr / jmp (x).l at $F9BC4
appstring = $11D9E		;jsr / jmp (x).l at $F990A
checkwallcoll = $F6FD6		;jsr / jmp (x).l at $F8B8E
dobitmap = $1169A		;jsr / jmp (x).l at $FA126
PAttribOverallMask = $19420		;move.l (x).l operand, retail long (IDA: dword_19420)
GAttribOverallMask = $19582		;move.l (x).l operand, retail long (IDA: dword_19582)
eraser = $1197E			;jsr / jmp (x).l at $FA152
forceblack = $10F32		;jsr / jmp (x).l at $FA08C
getNameandAttrib = $8D4E		;jsr / jmp (x).l at $FC90C
getname = $18A90			;jsr / jmp (x).l at $FCB00
getpzjoy = $A41E			;jsr / jmp (x).l at $FA21A
nodiag = $112F0			;jsr / jmp (x).l at $FA250
orjoy = $112BC			;jsr / jmp (x).l at $FB07C
prefmes = $1277A			;jsr / jmp (x).l at $FC328
print = $11BA4			;jsr / jmp (x).l at $FB16C
print2 = $11A48			;jsr / jmp (x).l at $FA3D2
printbig = $11DF4		;jsr / jmp (x).l at $FC348
printbigz = $11DE2		;jsr / jmp (x).l at $FB1FE
printz = $11B92			;jsr / jmp (x).l at $FA0FC
printz2 = $11A36			;jsr / jmp (x).l at $FA42A
setupIceRinkMap = $16C96		;jsr / jmp (x).l at $FB0D6
setvram = $11594			;jsr / jmp (x).l at $FB072
FormatPlayerNameLast = $18B5E		;jsr / jmp (x).l at $FA3F0 (IDA: sub_18B5E)
GetDefenseStart = $9F5C			;jsr / jmp (x).l at $FAB7E (IDA: sub_9F5C)
EndShootout = $FD618		;jsr / jmp (x).l at $FC540 (IDA: sub_FD618)
GetTeamRating = $FE172		;bsr.w / Bcc.w at $FAC24 (IDA: sub_FE172)
ClearWinRecords = $FE6D2		;bsr.w / Bcc.w at $FBD28 (IDA: sub_FE6D2)
StartShootoutPath = $FE756		;bsr.w / Bcc.w at $FC4D4 (IDA: sub_FE756)
UnpackPicture = $FE98A		;bsr.w / Bcc.w at $FAF0E (IDA: sub_FE98A)
GetTeamStruct = $FEE4A		;bsr.w / Bcc.w at $FA93E (IDA: sub_FEE4A)
PAttribOverall = $1940E		;#x, retail long (IDA: unk_1940E)
GAttribOverall = $19570		;#x, retail long (IDA: unk_19570)
ScoutMap = $54E24		;#x at $FB0E8 (IDA: unk_54E24)
framermap = $55B7E		;#x at $FB086 (unk_55B86 is framermap+8)
BigFontMap = $A9A10		;#x at $FB122 (unk_A9A18 is BigFontMap+8)
SmallFontMap = $AAC52		;#x at $FA0E8 (unk_AAC5A is SmallFontMap+8)
LogoBoxMap = $BF702		;#x at $FB112 (unk_BF70A is LogoBoxMap+8)
PicturePalette = $C63F8		;#x at $FAEEE (IDA: unk_C63F8)
NoPicSkater1 = $C682E		;#x at $FAEB0 (IDA: unk_C682E)
NoPicSkater2 = $C6B98		;#x at $FAEA0 (IDA: unk_C6B98)
NoPicGoalie1 = $C6F02		;#x at $FAE84 (IDA: unk_C6F02)
PlayerPictures = $C726C		;#x at $FAE94 (IDA: unk_C726C)
CornerLogoMap = $E9A80		;movea.l #x, retail long (IDA: unk_E9A80)
ArenaGfxBank = $E9ED6		;#x at $FA192 (IDA: unk_E9ED6)
TeamLogoBitmaps = $F86F2		;#x at $FA69C (IDA: unk_F86F2)
TeamLogoPalettes = $FF462		;#x at $FA6AE (IDA: unk_FF462)
vcountwait = $80BA		;jsr / jmp (x).l at $FA214

; Main segment code
	include	high94_2.asm
