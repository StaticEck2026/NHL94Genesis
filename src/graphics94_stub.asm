;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	graphics94 segment stub. Retail $01AD90-$0F66ED.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; External addresses outside $01AD90-$0F66ED: none. The segment is incbin only.
; Run npm run extractassets first (npm run seg:graphics94 does) to write Extracted\NHL94.
; .region data
	org	$1AD90

; Main segment data
	include	graphics94.asm
