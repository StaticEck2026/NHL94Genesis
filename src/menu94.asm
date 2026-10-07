;	NHL 94 (retail) segment $7E36-$80D3
;	The menu engine, as 93 menu93: InitMenuState through vcountwait (93 MenuWaitVblank). The scrolling menu of the pause screen
;	(PauseMode in hockey94_01), also used from penalty94_2, middle94_1 and the stats code after it (stats94).
;	94 changes from 93: the menu state is dword_FFCF20-dword_FFCF28 (93 dword_FFC9B4-dword_FFC9BC); printz2 / print2 (93
;	printsmallz / printsmall); a handler can keep its own screen (word_FFC2F6 bit 1); the 94 item printer sub_8008 (the Manual /
;	Auto Goalie item); PrintTeamData copies 11 words from unk_FFC334 (93 12 from $FFC210); vcountwait reads oldvcount twice.
;	Transcribed from lst/nhl94.bin.lst lines 30310-30582. Global names are the 93 menu93 names where IDA has an auto name (IDA name
;	in an ;IDA: comment); kept IDA names: sub_8008 (94 only), vcountwait. Locals are the IDA address (loc_7EA0 -> .7EA0). IDA gaps:
;	the inline Strings after printz2 (IDA ori.b / move.l / btst), and the two sub_8008 Strings (IDA dc.b, no label: .8050, .8064).

InitMenuState	;IDA: sub_7E36 (93 name). Start a menu: a0 = item list, a1 = screen draw routine; selection and first shown item 0. Falls into
	;DrawMenuScreen. Called from PauseMode (hockey94_01), penalty94_2 and the stats code
	move.l	a0,(dword_FFCF24).w	;item list (93 dword_FFC9B8)
	move.l	a1,(dword_FFCF28).w	;draw routine (93 dword_FFC9BC)
	clr.w	(dword_FFCF20).w	;selected item (93 dword_FFC9B4)
	clr.w	(dword_FFCF20+2).w	;first item shown
DrawMenuScreen	;IDA: sub_7E46 (93 name). Call the draw routine, frame the menu box, print the items and fade in. Called from HandleMenuInput and penalty94_2
	movea.l	(dword_FFCF28).w,a0
	jsr	(a0)
	jsr	(printz2).l
	String	$FE,4,$FC,$C	;IDA: ori.b
	bsr.w	SetMenuPrintX
	moveq	#$16,d0	;22 wide
	moveq	#6,d1	;6 high
	jsr	(Framer).l
	bsr.w	UpdateMenuSelection
	move.w	#$18,(palcount).w	;fade in
	rts
SetMenuPrintX	;IDA: sub_7E72 (93 name). printx = the left edge of the menu box: 5 in 32 column mode, else 9
	move.w	#5,(printx).w
	btst	#1,(disflags).w	;df32c: 32 column mode on
	bne.w	rtss8
	addq.w	#4,(printx).w
	rts
HandleMenuInput	;IDA: sub_7E88 (93 name). Act on the pad bits d1 for the current menu: down / up move the selection, C runs the item's handler and
	;redraws the menu (94: not if the handler set word_FFC2F6 bit 1). Returns eq to leave the menu (start, or C on item 0), ne to stay. Called
	;from PauseMode (hockey94_01), middle94_1 and the stats code
	btst	#7,d1	;sbut
	bne.w	.7EEC	;start: Z clear, flipped to eq
	btst	#1,d1	;dbut
	beq.w	.7EA0
	addq.w	#1,(dword_FFCF20).w	;next lower item
	bra.w	UpdateMenuSelection
.7EA0
	btst	#0,d1	;ubut
	beq.w	.7EB0
	subq.w	#1,(dword_FFCF20).w	;next higher item
	bra.w	UpdateMenuSelection
.7EB0
	btst	#5,d1	;cbut
	beq.w	.7EEC	;nothing: Z set, flipped to ne
	bsr.w	seta2
	move.w	(dword_FFCF20).w,d0	;find the handler of the selected item
	movea.l	(dword_FFCF24).w,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.7ECE
.7ECC
	addq.w	#4,a0
.7ECE
	adda.w	(a0),a0
	dbf	d0,.7ECC
	movea.l	(a0),a0
	jsr	(a0)	;the handler of the selected item
	bclr	#1,(word_FFC2F6).w	;94: the handler drew its own screen
	bne.w	.7EE6
	bsr.w	DrawMenuScreen
.7EE6
	tst.w	(dword_FFCF20).w	;item 0 (resume) leaves the menu
	rts
.7EEC
	eori	#4,ccr	;invert Z
	rts
UpdateMenuSelection	;IDA: sub_7EF2 (93 name). Clamp the selection, scroll the 4 rows shown and print the menu: title, the items (sub_8008), the
	;selected item marked, { / } when there are items above / below. Called from DrawMenuScreen and HandleMenuInput
	move.w	(dword_FFCF20).w,d0
	bpl.w	.7F00
	clr.w	(dword_FFCF20).w	;no item above the first
	clr.w	d0
.7F00
	movea.l	(dword_FFCF24).w,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.7F14
.7F0C
	adda.w	(a0),a0
	addq.w	#4,a0
	tst.w	2(a0)	;negative: the last item
.7F14
	dbmi	d0,.7F0C
	addq.w	#1,d0
	sub.w	d0,(dword_FFCF20).w	;no item below the last
	move.w	(dword_FFCF20).w,d0
	cmp.w	(dword_FFCF20+2).w,d0
	bge.w	.7F2E
	move.w	d0,(dword_FFCF20+2).w	;scroll up
.7F2E
	subq.w	#3,d0
	cmp.w	(dword_FFCF20+2).w,d0
	ble.w	.7F3C
	move.w	d0,(dword_FFCF20+2).w	;scroll down
.7F3C
	bsr.w	SetMenuPrintX
	move.w	#$D,(printy).w
	movea.l	(dword_FFCF24).w,a1
	jsr	(print2).l	;the menu title (93 printsmall)
	jsr	(printz2).l	;clear the 4 item rows (93 printsmallz)
	dc.w	$0026	;String length, 36 bytes: too many for the macro (as 93). IDA: ori.b / move.l / btst
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01
	dc.b	$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA
	dc.b	$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	(dword_FFCF20+2).w,d0	;skip to the first item shown
	bra.w	.7F8A
.7F86
	adda.w	(a1),a1
	addq.w	#4,a1
.7F8A
	dbf	d0,.7F86
	moveq	#3,d1	;4 rows
	move.w	#$C,(printy).w
	bsr.w	SetMenuPrintX
	move.w	(dword_FFCF20+2).w,d0
	beq.w	.7FB4
	jsr	(printz2).l	;more items above
	String	$FE,5,$FB,1,$FA,1,'{',$FA,$FF	;IDA: ori.b (and hid the rest)
.7FB4
	bsr.w	SetMenuPrintX
	jsr	(printz2).l	;start of an item row
	String	$FB,2,$FA,1	;IDA: ori.b
	move.l	a1,-(sp)
	movea.l	(dword_FFCF24).w,a1
	jsr	(print2).l
	cmp.w	(dword_FFCF20).w,d0
	bne.w	.7FDE
	jsr	(print2).l	;the selected item marker
.7FDE
	movea.l	(sp)+,a1
	bsr.w	sub_8008	;the item text
	addq.w	#1,d0
	addq.w	#4,a1
	tst.w	2(a1)	;negative: the last item
	dbmi	d1,.7FB4
	bmi.w	.8006
	bsr.w	SetMenuPrintX
	jsr	(printz2).l	;more items below
	String	$FE,5,$FB,1,'}'	;IDA: ori.b (and hid the rest)
.8006
	rts
sub_8008	;94 only. Print menu item a1 and step a1 past it. An item whose text starts with 'x' is the goalie option: it prints Manual Goalie
	;(.8050) when the pause team word is 0, else Auto Goalie (.8064): word_FFD05C with sflags bit 1 (sfpj) set, else word_FFD05A. Called from
	;UpdateMenuSelection
	cmpi.b	#$78,2(a1)	;first char 'x'
	bne.w	.8048
	move.l	a1,-(sp)
	movea.l	#.8050,a1
	btst	#1,(sflags).w	;sfpj: the pause pad
	beq.w	.802C
	tst.w	(word_FFD05C).w
	bra.w	.8030
.802C
	tst.w	(word_FFD05A).w
.8030
	beq.w	.803A
	movea.l	#.8064,a1
.803A
	jsr	(print2).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1	;skip the 'x' item text
	bra.w	.804E
.8048
	jsr	(print2).l
.804E
	rts
.8050
	String	'  Manual Goalie   '	;IDA dc.b, no label
.8064
	String	'   Auto Goalie    '	;IDA dc.b, no label
PrintTeamData	;IDA: sub_8078 (93 name). Copy 2 rows of 11 map words (93 12) from unk_FFC334+d0 (93 $FFC210) to printx / printy, then printx += 11
	;(93 12). Saves d0-d2/a0-a1. Called from penalty94_2 (PrintTeamLogoAndScore) and the stats code
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;dfng: don't int graphics
	movea.w	#(unk_FFC334-M68K_RAM),a1
	adda.w	d0,a1
	moveq	#1,d2	;2 rows
.808E
	jsr	(xyVmMap).l
	move.w	#$A,d1	;11 words (93 moveq #$B)
.8098
	move.w	(a1)+,(a0)
	dbf	d1,.8098
	addq.w	#1,(printy).w
	dbf	d2,.808E
	addi.w	#$B,(printx).w
	subq.w	#2,(printy).w
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0-d2/a0-a1
	rts
vcountwait	;IDA name and comment (93 MenuWaitVblank): waits till vcount changes, then resyncs vcount. Saves d0. 94 reads oldvcount twice. Called from PauseMode, sram94, hockey94_02 and the stats code
	move.w	d0,-(sp)
	move.w	(oldvcount).w,d0
	move.w	(oldvcount).w,d0
.80C4
	cmp.w	(vcount).w,d0
	beq.s	.80C4
	move.w	(oldvcount).w,(vcount).w
	move.w	(sp)+,d0
	rts
