	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	sound94 segment stub. Retail $01A264-$01AD8F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$1A264

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $01A264-$01AD8F, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
off_2C708 = $2C708		;movea.l (x).l operand at $1A314 (the sound $30 pointer in unk_2C648)
unk_1AD90 = $1AD90		;#x at $1ACE4
unk_1B01C = $1B01C		;lea (x,pc) at $1A77E
unk_2C648 = $2C648		;lea (x).l at $1A2C8

; Main segment code
	include	sound94.asm
