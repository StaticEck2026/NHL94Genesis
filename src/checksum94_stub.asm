	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	checksum94 segment stub. Retail $0FFAC0-$0FFB0F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$FFAC0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0FFAC0-$0FFB0F: none. Every branch in the segment is a bra.s / Bcc.s / dbf to a label
; inside it (checked against the retail displacements), and the only absolute addresses are the VDP ports (ports.inc).

; Main segment code
	include	checksum94.asm
