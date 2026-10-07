;	NHL 94 (retail) segment $FD618-$FFABF
;	94 code in the high ROM, between hockey94_07 and the checksum: the shootout end, the game stats clear, the arena animations
;	(sub_FE2C8, sub_FD78A, unk_FE364), the Period Stats and Game Statistics screens (sub_FD90C, GameStatisticsScreen,
;	TeamStatTextTbl), the Manual Goalie menu item, ChooseSong, the shootout skate paths, the save RAM option and three stars
;	blocks, the player picture unpack (sub_FE98A), HiScoreScreen, newTitleScreen and the credits, clrTmPdst and chgplayer.
;	94 only; 93 has no code here, except GameStatisticsScreen / DisplayTeamStatsScreen / FormatStatValue / TeamStatTextTbl (stats93).
;	Transcribed from lst/nhl94.bin.lst lines 970645-976744. Global names are the IDA names; the entries IDA has no label for are
;	IDA-style (sub_FD90C, sub_FE1D8 ...) or the 93 name. Locals are the IDA address or IDA name. IDA left code as data at $FD6B4,
;	$FD7D0, $FD8EC-$FE14B, $FE1D8, $FE4FC and $FEEA0: written from the retail bytes (the instructions and Strings), as are the
;	Strings and remap table IDA hid in newTitleScreen. The data tables are formatted from the retail bytes; the IDA labels inside
;	Strings or tables (unk_FDAA9, unk_FF633) are not labels.

sub_FD618	;94 only. Shootout over (sub_FC516, high94_2): freezewindow, then the 5 skaters of player slots 1-5 (word_FFD574 > word_FFD576) or
	;7-$B are set up (setplayer) above or below the view and get assscore (assinsert 7)
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#2,(sflags2).w
	jsr	(freezewindow).l
	move.w	#$60,(word_FFDED0).w
	movea.l	#SortCords,a3
	move.w	#0,d0
	move.w	(word_FFD574).w,d2
	cmp.w	(word_FFD576).w,d2
	bgt.w	.FD648
	move.w	#6,d0
.FD648
	asl.w	#7,d0
	adda.w	d0,a3
	move.w	#4,d2
	move.w	#6,d3
	bra.w	.FD6A4
.FD658
	movem.w	d2-d3,-(sp)
	jsr	(setplayer).l
	move.w	#2,$34(a3)
	move.w	#$F0,d0
	tst.w	(Vpos).w
	bmi.w	.FD678
	move.w	#$FF10,d0
.FD678
	add.w	(Vpos).w,d0
	move.w	d0,$14(a3)
	move.w	#0,(a3)
	move.w	#7,d0	;assscore
	jsr	(assinsert).l
	bclr	#5,$62(a3)
	bclr	#1,$63(a3)
	bclr	#2,$62(a3)
	movem.w	(sp)+,d2-d3
.FD6A4
	adda.l	#$80,a3
	dbf	d2,.FD658
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FD6B4	;no IDA label, and nothing calls it (IDA left it as data). Clamp $44 / $46(a3) to the box for position $34(a3) in unk_FD71C (unk_FD72C when bit 7 of $62(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	$34(a3),d7
	subq.w	#1,d7
	movea.l	#unk_FD71C,a0
	btst	#7,$62(a3)
	beq.w	.FD6D4
	movea.l	#unk_FD72C,a0
.FD6D4
	add.w	d7,d7
	move.w	(a0,d7.w),d0
	cmp.w	$44(a3),d0
	blt.w	.FD6E6
	move.w	d0,$44(a3)
.FD6E6
	move.w	2(a0,d7.w),d0
	cmp.w	$44(a3),d0
	bgt.w	.FD6F6
	move.w	d0,$44(a3)
.FD6F6
	move.w	4(a0,d7.w),d0
	cmp.w	$46(a3),d0
	blt.w	.FD706
	move.w	d0,$46(a3)
.FD706
	move.w	6(a0,d7.w),d0
	cmp.w	$46(a3),d0
	bgt.w	.FD716
	move.w	d0,$46(a3)
.FD716
	movem.l	(sp)+,d0-d7/a0
	rts
unk_FD71C	;no IDA label. sub_FD6B4 boxes: min / max of $44, then of $46, per position
	dc.w	$FFB5,0,0,$108,0,$4B,0,$108
unk_FD72C	;no IDA label. sub_FD6B4 boxes, top net
	dc.w	$FFB5,0,$FEF8,0,0,$4B,$FEF8,0
sub_FD73C	;94 only. Clear the game stats: word_FFD572 (19 words), both team structs (HmShots, AwShots), PenBuf, BA_PS_flags, word_FFC2F4 / F8 /
	;FA and word_FFD42E / word_FFD43E. Called from GameSetUp (hockey94_08)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFD572,a0
	moveq	#$12,d0
.FD748
	clr.w	(a0)+
	dbf	d0,.FD748
	movea.l	#HmShots,a0
	move.w	#$363,d0
.FD758
	clr.w	(a0)+
	dbf	d0,.FD758
	movea.l	#PenBuf,a0
	moveq	#$24,d0
.FD766
	clr.w	(a0)+
	dbf	d0,.FD766
	clr.w	(BA_PS_flags).w
	clr.w	(word_FFC2F4).w
	clr.w	(word_FFC2F8).w
	clr.w	(word_FFC2FA).w
	clr.w	(word_FFD42E).w
	clr.w	(word_FFD43E).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FD78A	;94 only. Add the frame word_FFD6AE of the arena animation (sprite list dword_FFD6BA, see sub_FE2C8) to the sprite table a6 (d6
	;sprites, 64 at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse angle replay (word_FFC2F4 bit 4), sflags2 bit 3 or sflags
	;bit 7. Called from setvideo (video94_1)
	tst.w	(word_FFD6B4).w
	bmi.w	.FD898
	tst.l	(dword_FFD6BA).w
	beq.w	.FD898
	btst	#4,(word_FFC2F4).w	;check if reverse angle replay
	bne.w	.FD898	;branch if so
	btst	#3,(sflags2).w
	bne.w	.FD898
	btst	#7,(sflags).w
	bne.w	.FD898
	movea.l	(dword_FFD6BA).w,a1
	adda.l	4(a1),a1
	move.w	(Hpos).w,d4
	move.w	(Vpos).w,d5
	move.w	(word_FFD6AE).w,d0
	bra.w	.FD7F0
	andi.w	#$F,d2	;nothing branches here: draw d2 + 1 (4 at most) frames from d3 (.FD7F0)
	cmp.w	#3,d2
	bls.w	.FD7DE
	moveq	#3,d2
.FD7DE
	bra.w	.FD7EA
.FD7E2
	move.w	d3,d0
	add.w	d2,d0
	bsr.w	.FD7F0
.FD7EA
	dbf	d2,.FD7E2
	rts
.FD7F0
	ext.w	d0
	beq.w	.FD898
	cmp.w	#$40,d6
	bge.w	.FD898
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	2(a0,d0.w),d1
	sub.w	0(a0,d0.w),d1
	lsr.w	#3,d1
	subq.w	#1,d1
	move.w	d1,-(sp)
	adda.w	0(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
.FD83A
	cmp.w	2(a0),d2
	bgt.w	.FD88E
	cmp.w	2(a0),d3
	blt.w	.FD88E
	cmp.w	(a0),d0
	bgt.w	.FD88E
	cmp.w	(a0),d1
	blt.w	.FD88E
	move.w	2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	6(a0),d5
	andi.w	#$F800,d5
	add.w	4(a0),d5
	add.w	(word_FFD6AC).w,d5
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6
	beq.w	.FD894
.FD88E
	addq.w	#8,a0
	dbf	d4,.FD83A
.FD894
	movem.l	(sp)+,d0-d5
.FD898
	rts
sub_FD89A	;94 only. Print the name of player d0 of team a2 (FormatPlayerName), moved left so it ends before column $29 (a trailing pad byte or
	;two not counted), then the icon of sub_FF8DE. Called from sub_FD1FE (hockey94_07)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(word_FFDEE8).w
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-1(a0,d5.w)
	bne.w	.FD8C4
	subq.w	#1,d0
	tst.b	-2(a0,d5.w)
	bne.w	.FD8C4
	subq.w	#1,d0
.FD8C4
	add.w	(printx).w,d0
	subi.w	#$29,d0
	bmi.w	.FD8D6
	neg.w	d0
	add.w	d0,(printx).w
.FD8D6
	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(sub_FF8DE).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FD8EC	;no IDA label, and nothing calls it (IDA left it as data). a1 = the FormatPlayerNameWithAttrib String without its first 2 characters (the length word moved up 2)
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNameWithAttrib).l
	move.w	(a1),d0
	subq.w	#2,d0
	move.w	d0,2(a1)
	addq.w	#2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	String	' . '
sub_FD90C	;no IDA label (IDA left it as data; 93 has no counterpart). "Period Stats" menu item (hockey94_11 menu lists): both team logos
	;(unk_F86F2, unk_FF462 palettes), then the goals (word_FFD598 0) or shots of each team by period ($342 / $34A of the team struct; OT when
	;byte_FFC2FC bit 1) and the total. Left / right switch, start exits (ExitAttributeScreen2)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(word_FFD598).w
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	$BE,1,$B
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$BE,1,$13
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$9E,2,$C
	movea.l	#unk_F86F2,a0
	move.w	(VisTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	movea.l	#unk_FF462,a0
	subi.w	#$40,d0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movea.l	#unk_FFBD68,a0
	movea.l	#$FFFFBD88,a1
	move.w	#7,d0
.FD9A6
	move.l	(a0)+,(a1)+
	dbf	d0,.FD9A6
	jsr	(printz).l
	String	$8E,2,$14
	movea.l	#unk_F86F2,a0
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	subi.w	#$40,d0
	movea.l	#unk_FF462,a0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BD,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BD,6,3,'  Period Stats  ',$BE,6,1
	btst	#1,(byte_FFC2FC).w
	beq.w	.FDA76
	jsr	(printz).l
	dc.w	$001C	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,9,'1',$BE,$11,9,'2',$BE,$16,9,'3',$BE,$1A,9,'OT',$BE,' ',9,'Total',0
	jsr	(printz).l
	dc.w	$001C	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,$A,'<',$BE,$11,$A,'<',$BE,$16,$A,'<',$BE,$1A,$A,'<<',$BE,' ',$A,'<<<<<',0
	bra.w	.FDAAE
.FDA76
	jsr	(printz).l
	dc.w	$0016	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,9,'1',$BE,$11,9,'2',$BE,$16,9,'3',$BE,' ',9,'Total'
	jsr	(printz).l
	dc.w	$0016	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,$A,'<',$BE,$11,$A,'<',$BE,$16,$A,'<',$BE,' ',$A,'<<<<<'
.FDAAE
	bsr.w	.FDB0E
	bsr.w	.FDB56
	move.w	#$18,(palcount).w
.FDABC
	jsr	(_rjoy).l	;left (bit 2) goals, right (bit 3) shots, start exits
	btst	#7,d1
	bne.w	.FDB04
	btst	#2,d1
	bne.w	.FDAF0
	btst	#3,d1
	bne.w	.FDADC
	bra.s	.FDABC
.FDADC
	tst.w	(word_FFD598).w
	bne.s	.FDABC
	st	(word_FFD598).w
	bsr.w	.FDB0E
	bsr.w	.FDB56
	bra.s	.FDABC
.FDAF0
	tst.w	(word_FFD598).w
	beq.s	.FDABC
	clr.w	(word_FFD598).w
	bsr.w	.FDB0E
	bsr.w	.FDB56
	bra.s	.FDABC
.FDB04
	movem.l	(sp)+,d0-d7/a0-a6
	jmp	(ExitAttributeScreen2).l
.FDB0E
	tst.w	(word_FFD598).w
	beq.w	.FDB36
	jsr	(printz).l
	String	$BE,$12,7,'Shots',$BE,$F,$1A,'[ For Goals'
	rts
.FDB36
	jsr	(printz).l
	String	$BE,$12,7,'Goals',$BE,$F,$1A,'For Shots ]'
	rts
.FDB56
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BE,0,0
	movea.l	#AwShots,a2
	move.w	#$E,(printy).w
	bsr.w	.FDB8C
	movea.l	#HmShots,a2
	move.w	#$16,(printy).w
	bsr.w	.FDB8C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.FDB8C
	lea	$342(a2),a0
	tst.w	(word_FFD598).w
	beq.w	.FDB9C
	lea	$34A(a2),a0
.FDB9C
	clr.w	(word_FFD5A8).w
	move.w	#$B,(printx).w
	bsr.w	.FDC28
	cmpi.w	#1,(gsp).w
	blt.w	.FDBF0
	move.w	#$10,(printx).w
	bsr.w	.FDC28
	cmpi.w	#2,(gsp).w
	blt.w	.FDBF0
	move.w	#$15,(printx).w
	bsr.w	.FDC28
	cmpi.w	#3,(gsp).w
	blt.w	.FDBF0
	btst	#1,(byte_FFC2FC).w
	beq.w	.FDBF0
	move.w	#$1A,(printx).w
	bsr.w	.FDC28
.FDBF0
	move.w	#$21,(printx).w
	jsr	(printz).l
	String	'   '
	subq.w	#3,(printx).w
	move.w	(word_FFD5A8).w,d0
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.FDC1A
	move.w	#3,d1
.FDC1A
	jsr	(PushNumberWidth).l
	jsr	(print).l
	rts
.FDC28
	move.w	(a0)+,d0
	add.w	d0,(word_FFD5A8).w
	jsr	(printz).l
	String	'   '
	subq.w	#3,(printx).w
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.FDC4E
	move.w	#3,d1
.FDC4E
	jsr	(PushNumberWidth).l
	jmp	(print).l
GameStatisticsScreen	;no IDA label (IDA left it as data; 93 name). "Game Statistics" menu item (hockey94_11 menu lists): both teams' totals
	;(DisplayTeamStatsScreen). 94 has more rows than the screen: up / down scroll them (word_FFD59E the most, $70 or $30 without penalties,
	;OptPen), start exits (ExitAttributeScreen2)
	moveq	#9,d0
	moveq	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	$BD,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BD,6,4,'Game  Statistics',$BD,7,1
	move.w	#$2C,d0
	jsr	(PrintTeamData).l
	addq.w	#4,(printx).w
	clr.w	d0
	jsr	(PrintTeamData).l
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
	clr.w	(PlayerScrollCtr).w
	move.w	#$70,(word_FFD59E).w	;the most scroll: 15 rows
	tst.w	(OptPen).w
	bne.w	.FDCCE
	move.w	#$30,(word_FFD59E).w	;11 rows
.FDCCE
	bsr.w	DisplayTeamStatsScreen
	bsr.w	sub_FDDAA
.FDCD6
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	btst	#7,d3
	beq.w	.FDCF0
	jmp	(ExitAttributeScreen2).l
.FDCF0
	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#0,d3
	bne.w	.FDD0C
	neg.w	d0
	btst	#1,d3
	beq.w	.FDD10
.FDD0C
	move.w	d0,(PlayerScrollCtr).w
.FDD10
	bsr.w	.FDD1A
	bsr.w	sub_FDDAA
	bra.s	.FDCD6
.FDD1A
	move.w	(PlayerScrollCtr).w,d0
	beq.w	locret_FE14A
	add.w	(VertLineScrolling).w,d0
	bmi.w	locret_FE14A
	cmp.w	(word_FFD59E).w,d0
	bgt.w	locret_FE14A
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.FDD46
	clr.w	(PlayerScrollCtr).w
.FDD46
	andi.w	#$F,d1
	bne.w	sub_FDD6A
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.FDD5C
	bsr.w	sub_FDD92
.FDD5C
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	sub_FDD6A
	bsr.w	sub_FDD9C
sub_FDD6A	;no IDA label. Plane A vertical scroll (VSRAM 0) = VertLineScrolling - $50, with disflags bit 2 set while it writes
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.l	#$40020010,4(a0)
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
sub_FDD92	;no IDA label. d3 = VertLineScrolling / 16 (GameStatisticsScreen, at a scroll step)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	locret_FDDA8
sub_FDD9C	;no IDA label. d3 = VertLineScrolling / 16 + 6 (GameStatisticsScreen, at a scroll step)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	locret_FDDA8
locret_FDDA8	;no IDA label. rts of sub_FDD92 / sub_FDD9C
	rts
sub_FDDAA	;no IDA label. GameStatisticsScreen scroll arrows (printz2): up ($7B) when VertLineScrolling > 0, down ($7D) when it is below word_FFD59E
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz2).l
	String	$F9,1
	tst.w	(VertLineScrolling).w
	beq.w	.FDDD4
	jsr	(printz2).l
	String	$F8,4,3,'&',8,$F9,1,'{'
	bra.w	.FDDE4
.FDDD4
	jsr	(printz2).l
	String	$F8,4,3,'&',8,$F9,1,' '
.FDDE4
	move.w	(word_FFD59E).w,d0
	cmp.w	(VertLineScrolling).w,d0
	beq.w	.FDE04
	jsr	(printz2).l
	String	$F8,4,3,'&',$1A,$F9,1,'}'
	bra.w	.FDE14
.FDE04
	jsr	(printz2).l
	String	$F8,4,3,'&',$1A,$F9,1,' '
.FDE14
	jsr	(printz2).l
	String	$F9
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayTeamStatsScreen	;no IDA label (93 name). Team logos (PrintTeamData), then each TeamStatTextTbl row (TeamStatTextTblNoPen when penalties are
	;off, OptPen) centred, with the home value at x $22 and the visitors' at x 9 (FormatStatValue); sub_FDD6A first
	jsr	(printz).l
	String	$BD,2,7
	move.w	#$2C,d0
	jsr	(PrintTeamData).l
	jsr	(printz).l
	String	$BD,$1A,7
	moveq	#0,d0
	jsr	(PrintTeamData).l
	bsr.w	sub_FDD6A
	jsr	(printz).l
	String	$BE,0,0
	moveq	#$E,d6
	lea	TeamStatTextTbl(pc),a1
	tst.w	(OptPen).w
	bne.w	.FDE74
	move.w	#$A,d6
	lea	TeamStatTextTblNoPen(pc),a1
.FDE74
	move.w	(a1),d0
	lsr.w	#1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).w
	jsr	(print).l
	movea.l	a1,a0
	move.w	#$22,(printx).w
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	FormatStatValue
	move.w	#9,(printx).w
	lea	$364(a2),a2
	bsr.w	FormatStatValue
	lea	4(a0),a1
	addq.w	#2,(printy).w
	dbf	d6,.FDE74
	rts
FormatStatValue	;no IDA label (93 name). Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value (offsets $A and $352 are times,
	;PushTime), "/second" if any, " (pct%)" for passing. 94: offset $FFFF is the shooting percentage (goals $C * 100 / shots 0), printed with a
	;"%"
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)
	cmpi.w	#$FFFF,(a0)	;shooting percentage row
	bne.w	.FDEF8
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#0,d1
	move.w	(a2,d1.w),d1
	beq.w	.FDEDE
	divu.w	d1,d0
.FDEDE
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.FDF8E
.FDEF8
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$352,(a0)	;PP Minutes: a time
	bne.w	.FDF0E
	bsr.w	.FDFA4
	bra.w	.FDF26
.FDF0E
	cmpi.w	#$A,(a0)
	beq.w	.FDF1A
	bsr.w	.FDF9E
.FDF1A
	cmpi.w	#$A,(a0)
	bne.w	.FDF26
	bsr.w	.FDFA4
.FDF26
	jsr	(appstring).l
	move.w	2(a0),d0
	bmi.w	.FDF8E
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.FDF8E
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.FDF78
	divu.w	d1,d0
.FDF78
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
.FDF8E
	movea.w	a3,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jmp	(print).l
.FDF9E
	jmp	(PushNumber).l
.FDFA4
	jmp	(PushTime).l
TeamStatTextTbl	;93 name. Label, then the team struct stat offset and the second offset ($FFFF none). 15 rows
	dc.w	$0008
	dc.b	'Score',0
	dc.w	$C,$FFFF
	dc.w	$0008
	dc.b	'Shots',0
	dc.w	0,$FFFF
	dc.w	$000E
	dc.b	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	dc.w	$000C
	dc.b	'Power Play'
	dc.w	2,4
	dc.w	$000C
	dc.b	'PP Minutes'
	dc.w	$352,$FFFF
	dc.w	$000A
	dc.b	'PP Shots'
	dc.w	$354,$FFFF
	dc.w	$000A
	dc.b	'SH Goals'
	dc.w	$356,$FFFF
	dc.w	$000C
	dc.b	'Breakaways'
	dc.w	$35A,$358
	dc.w	$000C
	dc.b	'One-Timers'
	dc.w	$35E,$35C
	dc.w	$0010
	dc.b	'Penalty Shots',0
	dc.w	$362,$360
	dc.w	$000E
	dc.b	'Faceoffs Won'
	dc.w	$E,$FFFF
	dc.w	$000E
	dc.b	'Body Checks',0
	dc.w	$10,$FFFF
	dc.w	$000C
	dc.b	'Penalties',0
	dc.w	6,8
	dc.w	$000E
	dc.b	'Attack Zone',0
	dc.w	$A,$FFFF
	dc.w	$000A
	dc.b	'Passing',0
	dc.w	$14,$12
TeamStatTextTblNoPen	;94 only. The rows without the power play ones, used when penalties are off. 11 rows
	dc.w	$0008
	dc.b	'Score',0
	dc.w	$C,$FFFF
	dc.w	$0008
	dc.b	'Shots',0
	dc.w	0,$FFFF
	dc.w	$000E
	dc.b	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	dc.w	$000C
	dc.b	'Breakaways'
	dc.w	$35A,$358
	dc.w	$000C
	dc.b	'One-Timers'
	dc.w	$35E,$35C
	dc.w	$0010
	dc.b	'Penalty Shots',0
	dc.w	$362,$360
	dc.w	$000E
	dc.b	'Faceoffs Won'
	dc.w	$E,$FFFF
	dc.w	$000E
	dc.b	'Body Checks',0
	dc.w	$10,$FFFF
	dc.w	$000C
	dc.b	'Penalties',0
	dc.w	6,8
	dc.w	$000E
	dc.b	'Attack Zone',0
	dc.w	$A,$FFFF
	dc.w	$000A
	dc.b	'Passing',0
	dc.w	$14,$12
locret_FE14A	;no IDA label. rts after the stat tables (GameStatisticsScreen scroll step)
	rts
updatePPTeamTime	;IDA name (and comments). 94 only: one more second of power play time ($352 of the team struct) for the team on the power play
	;(sflags2 bit 5, bit 6 the visitors). Called from updatepentime (penalty94_1)
	btst	#5,(sflags2).w	;check if PP
	beq.w	.FE170	;branch if not
	movea.l	#HmShots,a2	;move home team struct into a2
	btst	#6,(sflags2).w	;check who's on PP
	beq.w	.FE16C	;branch if home (team 1)
	movea.l	#AwShots,a2	;move away team struct into a2
.FE16C
	addq.w	#1,$352(a2)	;add 1 to PP team total
.FE170
	rts
sub_FE172	;94 only. d0 = the unk_FE18E byte of team $28(a2). Called from sub_FABDC (high94_2, the player card "Team Rating") and sub_FCFB8 (hockey94_07)
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$28(a2),d0
	movea.l	#unk_FE18E,a0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
unk_FE18E	;IDA name. sub_FE172 values, one byte per team (TeamList order)
	dc.b	$33,$4C,$49,$4B,$4E,$43,$4B,$43,$34,$42,$4A,$49,$44,$42
	dc.b	$4A,$37,$45,$4B,$47,$38,$45,$38,$48,$47,$48,$46,$5B,$59
sub_FE1AA	;94 only. Cap word_FFC31A at 2, unless a second pad is on (cont2team) and a3 is not the puck carrier. Called from doinput (logic94_1)
	movem.l	d0,-(sp)
	tst.w	(cont2team).w
	beq.w	.FE1C2
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.FE1D2
.FE1C2
	cmpi.w	#2,(word_FFC31A).w
	ble.w	.FE1D2
	move.w	#2,(word_FFC31A).w
.FE1D2
	movem.l	(sp)+,d0
	rts
sub_FE1D8	;no IDA label (IDA left it as data; 93 has no counterpart). "x Manual Goalie" menu item (hockey94_11 menu lists; sub_8008 prints
	;Manual / Auto Goalie from the same words): with OptNOP set, toggle the goalie mode of the pause pad (word_FFD05C for pad 2, sflags bit 1,
	;else word_FFD05A; both when the pads are on one team). In a penalty shot or shootout (word_FFC2FA bit 0, BA_PS_flags bit 2) the pad then
	;takes player 0 / 6 or 5 / $B by its mode, when BA_Sktr_SCnum is on its side (setc1player / setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).w
	beq.w	.FE214
	move.w	(cont1team).w,d0
	cmp.w	(cont2team).w,d0
	bne.w	.FE1FA
	eori.w	#1,(word_FFD05C).w
	bra.w	.FE20E
.FE1FA
	btst	#1,(sflags).w
	beq.w	.FE20E
	eori.w	#1,(word_FFD05C).w
	bra.w	.FE214
.FE20E
	eori.w	#1,(word_FFD05A).w
.FE214
	btst	#0,(word_FFC2FA).w
	bne.w	.FE228
	btst	#2,(BA_PS_flags).w
	beq.w	.FE2C2
.FE228
	btst	#1,(sflags).w
	bne.w	.FE28A
	cmpi.w	#2,(OptNOP).w
	bne.w	.FE24A
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.FE2C2
	bra.w	.FE254
.FE24A
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.FE2C2
.FE254
	move.w	#0,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.FE266
	move.w	#6,d0
.FE266
	tst.w	(word_FFD05A).w
	bne.w	.FE280
	move.w	#5,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.FE280
	move.w	#$B,d0
.FE280
	jsr	(setc1player).l
	bra.w	.FE2C2
.FE28A
	cmpi.w	#2,(OptNOP).w
	bne.w	.FE2A2
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.FE2C2
	bra.w	.FE2AC
.FE2A2
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.FE2C2
.FE2AC
	move.w	#6,d0
	tst.w	(word_FFD05C).w
	bne.w	.FE2BC
	move.w	#$B,d0
.FE2BC
	jsr	(setc2player).l
.FE2C2
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FE2C8	;94 only. Run the arena animation word_FFD6B4 (negative: none): the first time, its frame list and graphics from unk_FE364
	;(dword_FFD6B6 / dword_FFD6BA, tiles to VRAM d4 = word_FFD6AC: DoDMA_clearCallbackPointer); then count down the frame time word_FFD6B2 by d7
	;and step (sub_FE326). Called from periodicevents (hockey94_01) and waitxsr (middle94_1)
	tst.w	(word_FFD6B4).w
	bmi.w	.FE324
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(dword_FFD6BA).w
	bne.w	.FE310
	move.w	(word_FFD6B4).w,d0
	asl.w	#3,d0
	movea.l	#unk_FE364,a0
	move.l	0(a0,d0.w),(dword_FFD6B6).w
	move.l	4(a0,d0.w),(dword_FFD6BA).w
	movea.l	4(a0,d0.w),a2
	addq.w	#8,a2
	move.w	(word_FFD6AC).w,d4
	jsr	(DoDMA_clearCallbackPointer).l
	clr.w	(word_FFD6B0).w
	bsr.w	sub_FE326
	bra.w	.FE320
.FE310
	sub.w	d7,(word_FFD6B2).w
	bpl.w	.FE320
	addq.w	#1,(word_FFD6B0).w
	bsr.w	sub_FE326
.FE320
	movem.l	(sp)+,d0-d7/a0-a6
.FE324
	rts
sub_FE326	;94 only. Read frame word_FFD6B0 of the list: word_FFD6AE = frame, word_FFD6B2 = time; frame $FF loops to the start, $FE ends the animation (sub_FE548)
	movea.l	(dword_FFD6B6).w,a0
	move.w	(word_FFD6B0).w,d0
	add.w	d0,d0
	move.b	0(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(word_FFD6AE).w
	move.b	1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(word_FFD6B2).w
	cmpi.w	#$FFFF,(word_FFD6AE).w
	bne.w	.FE354
	clr.w	(word_FFD6B0).w
	bra.s	sub_FE326
.FE354
	cmpi.w	#$FFFE,(word_FFD6AE).w
	bne.w	.FE362
	bsr.w	sub_FE548
.FE362
	rts
unk_FE364	;IDA name. The 8 arena animations (sub_FE510 d0): frame list, then the graphics in graphics94 unk_E9ED6 (sprite list at 4(x), tiles at 8(x))
	dc.l	unk_FE4DC,$EA2EC
	dc.l	unk_FE490,$EAB10
	dc.l	unk_FE4B6,$EAB10
	dc.l	unk_FE47E,$EB816
	dc.l	unk_FE428,$EC284
	dc.l	unk_FE3F8,$EC284
	dc.l	unk_FE3E2,$ED1B0
	dc.l	unk_FE3A4,$ED1B0
unk_FE3A4	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A,5,$A,6,$A
	dc.b	7,$A,8,$A,9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A
	dc.b	5,$A,6,$A,7,$A,8,$A,9,$A,$A,$A,$FE,0
unk_FE3E2	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$FF,0
unk_FE3F8	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$A,$10,$A
	dc.b	$11,$A,$12,$A,$13,$A,$14,$A,$15,$A,$16,$A,$17,$A,$FE,0
unk_FE428	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	2,8,1,8,$FF,0
unk_FE47E	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,8,5,8,6,8,7,8,8,8
	dc.b	$FF,0
unk_FE490	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,$1E,5,8,6,8,7,8,8,$1E
	dc.b	5,8,6,8,7,8,8,$1E,9,8,$A,8,$B,8,$C,8
	dc.b	$D,8,$E,8,$FE,0
unk_FE4B6	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	$F,8,$10,8,$11,8,$12,$1E,$13,8,$14,8,$15,8,$16,$1E
	dc.b	$13,8,$14,8,$15,8,$16,$1E,$17,8,$18,8,$19,8,$1A,8
	dc.b	$1B,8,$1C,8,$FE,0
unk_FE4DC	;no IDA label. unk_FE364 frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$7F,$FE,0
sub_FE4FC	;no IDA label, and nothing calls it (IDA left it as data). sflags bit 6, xc1 = 0, yc1 = $160
	bset	#6,(sflags).w
	move.w	#0,(xc1).w
	move.w	#$160,(yc1).w
	rts
sub_FE510	;94 only. Start arena animation d0 (unk_FE364): word_FFD6B4 = d0, sub_FE2C8 loads it. Called from FallDown (hockey94_03, 7),
	;DisplayPlayerAttributeMenu (hockey94_10, 0 on a home hat trick) and puckfaceoff2 (logic94_4, the one sub_FE53C set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(word_FFD6B4).w
	move.l	#0,(dword_FFD6B6).w
	move.l	#0,(dword_FFD6BA).w
	move.w	#1,(word_FFD6AE).w
	clr.w	(word_FFD6B0).w
	st	(word_FFD6BE).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FE53C	;94 only. Set the faceoff animation: byte_FFC2FC bit 0, word_FFD6BE = d0. Called from puckfaceoff (logic94_4)
	bset	#0,(byte_FFC2FC).w
	move.w	d0,(word_FFD6BE).w
	rts
sub_FE548	;94 only. End the arena animation: word_FFD6B4 = -1, byte_FFC2FC bit 0 cleared. Called from sub_FE326 and puckfaceoff2 (logic94_4)
	move.w	#$FFFF,(word_FFD6B4).w
	bclr	#0,(byte_FFC2FC).w
	rts
ChooseSong	;IDA name. 94 only: SongNum = byte SongIndex of the 6 song bytes of team HmTeam (unk_FE5B0), or one of the 8 of unk_FE658 at random
	;when 0; $FFFF with gmode bit 4. Called from StartPer (hockey94_01), checkgoal (hockey94_04), puckshootout (logic94_4) and sub_FF7E2
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#4,(gmode).w
	beq.w	.FE56C
	move.w	#$FFFF,d1
	bra.w	.FE5A6
.FE56C
	bclr	#6,(byte_FFC2FE).w
	movea.l	#unk_FE5B0,a0
	movea.l	#unk_FE658,a1
	move.w	(HmTeam).w,d0
	mulu.w	#6,d0
	add.w	(SongIndex).w,d0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	bne.w	.FE5A6
	move.w	#8,d0
	jsr	(randomd0).l
	andi.w	#7,d0
	move.b	0(a1,d0.w),d1
.FE5A6
	move.w	d1,(SongNum).w
	movem.l	(sp)+,d0-d1/a0-a1
	rts
unk_FE5B0	;IDA name. ChooseSong: 6 songs per team (TeamList order), 0 = random (unk_FE658)
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$31,$32,$30,0,$5A,$31
	dc.b	$34,$33,$33,$34,$5A,0
	dc.b	$35,$37,$35,$37,$36,$36
	dc.b	$38,$3A,$39,$38,$5A,$65
	dc.b	$4A,$4B,$4B,0,$5A,0
	dc.b	$3B,$3C,$3D,0,$5A,$3C
	dc.b	$3E,$3F,$3F,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$40,$42,$41,$42,$5A,$40
	dc.b	$43,$43,$45,$44,$5A,$46
	dc.b	$4F,$4E,$4F,$4D,$5A,$4C
	dc.b	$50,$51,$50,0,$5A,$52
	dc.b	$47,$48,$47,$49,$5A,$49
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$56,$57,$56,$58,0,$58
	dc.b	$59,$5B,$59,$5C,$5A,$5C
	dc.b	$5D,$5E,$5D,0,$5A,$5E
	dc.b	$5F,$60,$61,$63,$64,$65
	dc.b	$67,$68,$68,$67,$5A,$69
	dc.b	$6A,$6B,$6B,0,$5A,0
	dc.b	$6C,$6C,$6D,0,$5A,0
	dc.b	$6E,$6F,$70,0,$5A,0
	dc.b	$71,$73,$71,0,$5A,$74
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
unk_FE658	;IDA name. ChooseSong: the 8 songs for a random pick
	dc.b	$34,$40,$42,$49,$58,$5C,$65,$66
sub_FE660	;94 only. Read the $100 bytes at save RAM $1EF6 to unk_FFD076 (ReadSRAM); sflags bit 4 cleared, lastsfx = -1, recbpr = $FFFF0000. Called from Begin (hockey94_01) and GameSetUp (hockey94_08)
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$1EF6,d0
	movea.l	#unk_FFD076,a0
	jsr	(ReadSRAM).l
	bclr	#4,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#$FFFF0000,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
sub_FE696	;94 only. Write unk_FFD076 back to save RAM $1EF6 (WriteSRAM, MakeSRAMChecksum); as sub_FE660 after. Called from EncodePW (hockey94_09) and EncodePlayerAttributes (stats94)
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$1EF6,d0
	movea.l	#unk_FFD076,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	bclr	#4,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#$FFFF0000,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
sub_FE6D2	;94 only. Clear bytes 8-$B of the 8 ThreeStars records and write the $80 bytes to save RAM $D20 (WriteSRAM, MakeSRAMChecksum). Called from sub_FBC14 (high94_2, Record Holders)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#7,d7
.FE6E0
	clr.b	8(a0)
	clr.b	9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbf	d7,.FE6E0
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir	;IDA name (and comments). 94 only: penalty shot / shootout: passdir = word_FFDA1A (the end of the skate path, sub_FE7FC), turned by
	;passdirlist for the bottom net. Called from shotdiradj (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(word_FFDA1A).w,d0
	btst	#7,$62(a3)	;check what net shooting at
	bne.w	.FE73A	;branch if top net
	movea.l	#passdirlist,a0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
.FE73A
	move.w	d0,(passdir).w	;move d0 into passdir
	movem.l	(sp)+,d0-d7/a0-a6
	rts
passdirlist	dc.w	0	;IDA name. PSandSOpassdir: passdir for the other net
	dc.w	7
	dc.w	6
	dc.w	5
	dc.w	4
	dc.w	3
	dc.w	2
	dc.w	1
	dc.w	8
sub_FE756	;94 only. Shootout: pick one of the 7 skate paths (unk_FE788) at random (word_FFDA12) and start it (sub_FE7FC). Called from sub_FC4C0 (high94_2) and puckshootout (logic94_4)
	movem.l	d0-d7/a0-a6,-(sp)
.FE75A
	move.w	#7,d0
	jsr	(randomd0).l
	cmp.w	#6,d0
	bgt.s	.FE75A
	move.w	d0,(word_FFDA12).w
	bclr	#3,(byte_FFC2FC).w
	move.w	#$FFFF,(word_FFDA14).w
	clr.w	(word_FFDA16).w
	bsr.w	sub_FE7FC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FE788	;IDA name. The 7 shootout skate paths (sub_FE7FC)
	dc.l	unk_FE7A4
	dc.l	unk_FE7B0
	dc.l	unk_FE7C0
	dc.l	unk_FE7CC
	dc.l	unk_FE7D8
	dc.l	unk_FE7E4
	dc.l	unk_FE7F0
unk_FE7A4	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$10,$E2,$10,$D0,$8020,5
unk_FE7B0	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$FFC9,$A0,$FFFF,$C8,$FFE0,$D0,$8020,5
unk_FE7C0	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$FFB0,$40,$1A,$BC,$8020,5
unk_FE7CC	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$FFCE,$58,$14,$D0,$802C,5
unk_FE7D8	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$FFCE,8,$20,$D0,$8028,6
unk_FE7E4	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$1C,$F4,8,$E0,$8020,6
unk_FE7F0	;no IDA label. unk_FE788 path: x, y points; $80 in the high byte ends it (low byte: word_FFDA1C, then word_FFDA1A)
	dc.w	$FFE6,$F8,0,$E0,$8020,2
sub_FE7FC	;94 only. Next point of shootout path word_FFDA12 (word_FFDA14): word_FFDA16 / word_FFDA18 = x (turned by bit 0 of $76(a3)) / y; at
	;the end ($80) byte_FFC2FC bit 3, word_FFDA1C and word_FFDA1A (passdir)
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,(word_FFDA16).w
	beq.w	.FE85E
	addq.w	#1,(word_FFDA14).w
	move.w	(word_FFDA14).w,d0
	asl.w	#2,d0
	movea.l	#unk_FE788,a0
	move.w	(word_FFDA12).w,d1
	asl.w	#2,d1
	movea.l	0(a0,d1.w),a0
	move.w	0(a0,d0.w),(word_FFDA16).w
	btst	#0,$76(a3)
	beq.w	.FE838
	neg.w	(word_FFDA16).w
.FE838
	move.w	2(a0,d0.w),(word_FFDA18).w
	cmpi.b	#$80,4(a0,d0.w)
	bne.w	.FE85E
	bset	#3,(byte_FFC2FC).w
	clr.w	(word_FFDA1C).w
	move.b	5(a0,d0.w),(word_FFDA1C+1).w
	move.w	6(a0,d0.w),(word_FFDA1A).w
.FE85E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FE864	;94 only. Shootout skate path: d0 / d1 = the point (mirrored for the bottom net); within $A of it ($12 while $28 / $2A(a3) are 0) take
	;the next one (sub_FE7FC). Called from asspuckc (logic94_3)
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,(word_FFDA16).w
	beq.w	.FE8E6
	move.w	(word_FFDA16).w,d0
	move.w	(word_FFDA18).w,d1
	btst	#7,$62(a3)
	bne.w	.FE888
	neg.w	d0
	neg.w	d1
.FE888
	sub.w	(a3),d0
	bpl.w	.FE890
	neg.w	d0
.FE890
	tst.w	$28(a3)
	bne.w	.FE8A8
	tst.w	$2A(a3)
	bne.w	.FE8A8
	cmp.w	#$12,d0
	ble.w	.FE8B0
.FE8A8
	cmp.w	#$A,d0
	bgt.w	.FE8DE
.FE8B0
	sub.w	$14(a3),d1
	bpl.w	.FE8BA
	neg.w	d1
.FE8BA
	tst.w	$28(a3)
	bne.w	.FE8D2
	tst.w	$2A(a3)
	bne.w	.FE8D2
	cmp.w	#$12,d1
	ble.w	.FE8DA
.FE8D2
	cmp.w	#$A,d1
	bgt.w	.FE8DE
.FE8DA
	bsr.w	sub_FE7FC
.FE8DE
	move.w	(word_FFDA16).w,d0
	move.w	(word_FFDA18).w,d1
.FE8E6
	movem.l	(sp)+,d2-d7/a0-a6
	rts
sub_FE8EC	;94 only. Shootout, skater a3 has the puck (word_FFC2FA bit 1): Z set (d0 is restored) = shoot now: after 3 (word_FFD454) at the path
	;end, within word_FFDA1C of its last point, or with the puck stopped before $F. Called from asspuckc (logic94_3)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,(word_FFC2FA).w
	beq.w	.FE980
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.FE980
	cmpi.w	#3,(word_FFD454).w
	ble.w	.FE97A
	cmpi.b	#$80,(word_FFDA16).w
	beq.w	.FE97A
	btst	#3,(byte_FFC2FC).w
	bne.w	.FE942
	tst.w	(puckvx).w
	bne.w	.FE980
	tst.w	(puckvy).w
	bne.w	.FE980
	cmpi.w	#$F,(word_FFD454).w
	blt.w	.FE97A
	bra.w	.FE980
.FE942
	move.w	(word_FFDA16).w,d0
	move.w	(word_FFDA18).w,d1
	btst	#7,$62(a3)
	bne.w	.FE958
	neg.w	d0
	neg.w	d1
.FE958
	sub.w	(a3),d0
	bpl.w	.FE960
	neg.w	d0
.FE960
	sub.w	$14(a3),d1
	bpl.w	.FE96A
	neg.w	d1
.FE96A
	cmp.w	(word_FFDA1C).w,d0
	bgt.w	.FE980
	cmp.w	(word_FFDA1C).w,d1
	bgt.w	.FE980
.FE97A
	clr.w	d0
	bra.w	.FE984
.FE980
	move.w	#1,d0
.FE984
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FE98A	;94 only. Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit pixels + 5 at $FFFFDA1E (count first). Called from
	;sub_FAEBC (high94_2), sub_FD14A (hockey94_07) and sub_F8868 (hockey94_08)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFDA1E,a0
	movea.l	#$FFFFDEA0,a1
	move.w	(a2)+,d0
	move.w	d0,(a0)+
	asl.w	#3,d0
	subq.w	#1,d0
.FE9A2
	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,1(a1)
	move.b	(a2)+,2(a1)
	move.l	#0,-(sp)
	move.l	(a1),d2
	andi.l	#$E0000000,d2
	lsr.l	#1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2
	lsr.l	#2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2
	lsr.l	#3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2
	lsr.l	#4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2
	lsr.l	#5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2
	lsr.l	#6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2
	lsr.l	#7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2
	move.w	#8,d5
	lsr.l	d5,d2
	addq.l	#5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbf	d0,.FE9A2
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FEA52	;94 only. Load the HomeTeam graphics of unk_FEA74 to VRAM d4 - $18 (DoDMA_clearCallbackPointer). Called from setupice (hockey94_06), ClrHor (penalty94_1) and sub_9CDC (stats94)
	move.w	d0,-(sp)
	subi.w	#$18,d4
	movea.l	#unk_FEA74,a2
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2
	addq.w	#8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	(sp)+,d0
	rts
unk_FEA74	;IDA name. sub_FEA52: one address per team (TeamList order) in graphics94 unk_E9ED6
	dc.l	$EDE8A,$F2A84,$EE194,$EE49E
	dc.l	$EE7A8,$EEAB2,$EEDBC,$EF0C6
	dc.l	$EF3D0,$EF6DA,$EF9E4,$EFCEE
	dc.l	$EFFF8,$F0302,$F060C,$F0916
	dc.l	$F0C20,$F0F2A,$F1234,$F153E
	dc.l	$F1848,$F1B52,$F1E5C,$F2166
	dc.l	$F2470,$F277A,$F2D8E,$F2D8E
sub_FEAE4	;94 only. Print " (n)": byte $CE + d0 of team a2, then the next row at x $E. Called from DisplayPlayerAttributeMenu (hockey94_10)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$CE,a2
	bra.w	loc_FEB0C
sub_FEAFA	;94 only. As sub_FEAE4 with byte $B4 + d0. Called from DisplayPlayerAttributeMenu (hockey94_10)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$B4,a2
loc_FEB0C	;IDA label. sub_FEAE4 / sub_FEAFA: the number (1 to 3 digits, PushNumberWidth) and ")"
	move.b	0(a2,d0.w),d0
	ext.w	d0
	move.w	#1,d1
	cmp.w	#9,d0
	ble.w	.FEB2E
	move.w	#2,d1
	cmp.w	#$63,d0
	ble.w	.FEB2E
	move.w	#3,d1
.FEB2E
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	')'
	addq.w	#1,(printy).w
	move.w	#$E,(printx).w
	movem.l	(sp)+,d0/a2
	rts
sub_FEB54	;94 only. For frames $1776 / $185A (y to $124 / $FEDC, or $116 / $FEEA by FallXPos) and $17E8 / $1A00 / $18CC / $193E (x to +-$82 /
	;$88 by bit 3 of 4(a3)) of $58(a3): move player a3 half way there. Called from updateplayers (hockey94_02)
	cmpi.w	#$193E,$58(a3)
	beq.w	.FEC44
	cmpi.w	#$1A00,$58(a3)
	beq.w	.FEC0C
	cmpi.w	#$18CC,$58(a3)
	beq.w	.FEC28
	cmpi.w	#$17E8,$58(a3)
	beq.w	.FEBF0
	cmpi.w	#$1776,$58(a3)
	beq.w	.FEB94
	cmpi.w	#$185A,$58(a3)
	beq.w	.FEBC2
	bra.w	.FEC5C
.FEB94
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.FEBAC
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.FEBB0
.FEBAC
	move.w	#$116,d0
.FEBB0
	sub.w	$14(a3),d0
	bmi.w	.FEC5C
	asr.w	#1,d0
	add.w	d0,$14(a3)
	bra.w	.FEC5C
.FEBC2
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.FEBDA
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.FEBDE
.FEBDA
	move.w	#$FEEA,d0
.FEBDE
	sub.w	$14(a3),d0
	bpl.w	.FEC5C
	asr.w	#1,d0
	add.w	d0,$14(a3)
	bra.w	.FEC5C
.FEBF0
	move.w	#$82,d0
	btst	#3,4(a3)
	beq.w	.FEC02
	move.w	#$FF7E,d0
.FEC02
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.FEC5C
.FEC0C
	move.w	#$88,d0
	btst	#3,4(a3)
	beq.w	.FEC1E
	move.w	#$FF78,d0
.FEC1E
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.FEC5C
.FEC28
	move.w	#$FF7E,d0
	btst	#3,4(a3)
	beq.w	.FEC3A
	move.w	#$82,d0
.FEC3A
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.FEC5C
.FEC44
	move.w	#$FF78,d0
	btst	#3,4(a3)
	beq.w	.FEC56
	move.w	#$88,d0
.FEC56
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
.FEC5C
	rts
sub_FEC5E	;94 only. d0 = the team (of 28) with the highest crowd record byte 8 (clrCrowdRAM; 0 counts as $50). Called from DisplayGameStats (stats94)
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#$1B,d1
	ext.l	d1
	clr.w	d7
	movea.l	#ThreeStars,a0
.FEC70
	jsr	(clrCrowdRAM).l
	clr.w	d2
	move.b	8(a0),d2
	bne.w	.FEC84
	move.w	#$50,d2
.FEC84
	cmp.w	d7,d2
	ble.w	.FEC8E
	move.w	d2,d7
	move.w	d1,d0
.FEC8E
	dbf	d1,.FEC70
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte	;IDA name (and comments). 94 only. Called from setInjuryType (hockey94_03)
	clr.w	d0	;clear d0
	move.b	$74(a2),d0	;move H/F bit into d0 (this is always even)
	lsr.w	#2,d0	;shift 2 right (divide by 4)
	rts
chkFgtBit1	;IDA name. 94 only: test bit 1 of $74(a2). Called from setInjuryType (hockey94_03)
	btst	#1,$74(a2)
	rts
sub_FECAA	;94 only. d0 = a random faceoff animation from unk_FECE6 (sub_FE510), 6 when fox <= -$40 and foy <= $C0. Called from puckfaceoff (logic94_4)
	movem.l	a0,-(sp)
	movea.l	#unk_FECE6,a0
	move.w	#$64,d0
	jsr	(randomd0).l
	andi.w	#7,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	cmpi.w	#$FFC0,(fox).w
	bgt.w	.FECE0
	cmpi.w	#$C0,(foy).w
	bgt.w	.FECE0
	move.w	#6,d0
.FECE0
	movem.l	(sp)+,a0
	rts
unk_FECE6	;IDA name. sub_FECAA animations
	dc.w	3,5,3,1,5,2,3,3,$FFFF
sub_FECF8	;94 only. Compare the scores ($24 of HmShots / AwShots) and test $28 of the leader for $13; the result is not used (bne.w *+4). Called from puckfaceoff (logic94_4)
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#HmShots,a0
	movea.l	#AwShots,a1
	move.w	$24(a0),d0
	sub.w	$24(a1),d0
	beq.w	.FED24
	bpl.w	.FED1A
	exg	a0,a1
.FED1A
	cmpi.w	#$13,$28(a0)
	bne.w	*+4
.FED24
	movem.l	(sp)+,d0-d2/a0-a2
	rts
sub_FED2A	;94 only. The unk_F3098 sprite at word_FFB8AE / word_FFB8B0 (SetSframe) in Satt, then end the sprite list (word_FFC2E8 = its size). Called from PlayoffScreen (hockey94_06)
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.l	#unk_F3098,a0
	move.w	(word_FFB016).w,d3
	ori.w	#$8000,d3
	move.w	(word_FFB8AE).w,d0
	move.w	(word_FFB8B0).w,d1
	move.w	#1,d2
	jsr	(SetSframe).l
	cmpa.w	#$C018,a6
	bne.w	.FED5C
	clr.l	(a6)+
	clr.l	(a6)+
.FED5C
	clr.b	-5(a6)
	move.l	a6,d0
	subi.l	#$FFFFC018,d0
	lsr.w	#1,d0
	move.w	d0,(word_FFC2E8).w
	rts
HiScoreScreen	;IDA name. 94 only: vb2, the $F4378 bitmap and HiScoreImg, then wait up to $50 * 4 frames or a button (waitx). Called from Begin (hockey94_01, attract mode)
	move.l	#vb2,(vbint).w
	bclr	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	jsr	(forceblack).l
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1
.FEDBA
	clr.l	(a0)+
	dbf	d1,.FEDBA
	jsr	(loc_115AA).l
	jsr	(printz).l
	String	$BE,$E,3
	movea.l	#$F4378,a2
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	clr.w	d4
	moveq	#$F,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,$10,$10
	movea.l	#HiScoreImg,a2
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	#$18,(palcount).w
	move	#$2500,sr
	move.w	#$50,(RNGseed).w
.FEE30
	moveq	#4,d0
	jsr	(waitx).l
	tst.w	d1
	bne.w	.FEE44
	subq.w	#1,(RNGseed).w
	bpl.s	.FEE30
.FEE44
	move	#$2700,sr
	rts
sub_FEE4A	;94 only. a2 = HmShots, or AwShots when team d2 is not $28 of HmShots. Called from loc_FA936 (high94_2)
	movea.l	#HmShots,a2
	cmp.w	$28(a2),d2
	beq.w	.FEE5E
	movea.l	#AwShots,a2
.FEE5E
	rts
sub_FEE60	;94 only. Not in gmode bit 0: add 1 to dword_FFDEA4 (dword_FFDEAC for d4), and to the next long unless word_FFBF12 is 8 or $54(a3). Called from loc_B72E (logic94_1)
	movem.l	d1-d7/a0,-(sp)
	btst	#0,(gmode).w
	bne.w	.FEE9A
	move.w	(word_FFBF12).w,d1
	movea.l	#dword_FFDEA4,a0
	tst.w	d4
	beq.w	.FEE84
	movea.l	#dword_FFDEAC,a0
.FEE84
	addq.l	#1,(a0)
	cmp.w	#8,d1
	beq.w	.FEE9A
	cmp.w	$54(a3),d1
	beq.w	.FEE9A
	addq.l	#1,4(a0)
.FEE9A
	movem.l	(sp)+,d1-d7/a0
	rts
sub_FEEA0	;no IDA label, and nothing calls it (IDA left it as data). The sub_FB992 String at $FFFFDEBA, ended with 0 at word_FFD4E8 and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFDEBA,a1
	bsr.w	sub_FB992
	move.w	(word_FFD4E8).w,d0
	move.b	#0,(a1,d0.w)
	addq.w	#1,d0
	andi.w	#$FFFE,d0
	move.w	d0,-2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FEEC8	;94 only. a1 = String "(played by NAME)" for word_FFD042 (sub_FB992 name), or an empty String for 0. Called from sub_17730 (hockey94_06)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(word_FFD042).w,d0
loc_FEED0	;IDA label. sub_FEEC8 / sub_FEF5A body
	tst.w	d0
	beq.w	loc_FEF52
	movea.l	#$FFFFD4DC,a1
	move.w	d0,(word_FFD4EA).w
	bsr.w	sub_FB992
	adda.w	(word_FFD4E8).w,a1
	move.b	#0,(a1)
	addq.w	#1,(word_FFD4E8).w
	andi.w	#$FFFE,(word_FFD4E8).w
	addq.w	#2,(word_FFD4E8).w
	move.w	(word_FFD4E8).w,(word_FFD4DA).w
	movea.l	#word_FFD4DA,a1
	move.l	a1,-(sp)
	movea.l	#$FFFFBF20,a3
	movea.l	#unk_FEF42,a1
	bsr.w	sub_F997A
	movea.l	(sp)+,a1
	movea.l	#$FFFFBF20,a3
	jsr	(appstring).l
	movea.l	#$FFFFBF20,a3
	jsr	(appendz).l
	String	')'
	movea.l	#$FFFFBF20,a1
loc_FEF3C	;IDA label. Exit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
unk_FEF42	;IDA name. sub_FEEC8 text
	String	'(played by '
unk_FEF50	;IDA name. sub_FEEC8: the empty String
	dc.w	2	;empty String
loc_FEF52	;IDA label. sub_FEEC8: no name
	movea.l	#unk_FEF50,a1
	bra.s	loc_FEF3C
sub_FEF5A	;94 only. As sub_FEEC8 for word_FFD044. Called from sub_17730 (hockey94_06)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(word_FFD044).w,d0
	bra.w	loc_FEED0
set_bit1_C2FE	;IDA name (and comments). 94 only. Called from updateplayers (hockey94_02)
	bra.w	.set
	bclr	#1,(byte_FFC2FE).w
	bra.w	.ex
.set
	bset	#1,(byte_FFC2FE).w	;set bit 1 of C2FE
.ex
	rts
AttribAdjust	;IDA name (and comments). 94 only: an attribute under $32 becomes d0 / 2 + $19. Called from DispAttribValue (stats94), sub_FA8AC (high94_2) and sub_FD1FE (hockey94_07)
	cmp.w	#$32,d0	;'2'   ; compare $32 to d0
	bge.w	.exit	;branch if greater than
	asr.w	#1,d0	;divide by 2
	addi.w	#$19,d0	;add $19 (25 dec)
.exit
	rts
sub_FEF8C	;nothing calls it. Z clear when the puck is within $1E of player a3 and moving toward him (x, then y); d0-d1 kept
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	cmp.w	#$1E,d0
	bgt.w	.FEFC6
	move.w	(puckvx).w,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
	beq.w	.FEFC6
	move.w	(pucky).w,d0
	sub.w	$14(a3),d0
	cmp.w	#$1E,d0
	bgt.w	.FEFC6
	move.w	(puckvy).w,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
.FEFC6
	movem.w	(sp)+,d0-d1
	rts
ReadGoaliePulled	;IDA name (and comments). 94 only: Z clear when the team of a3 pulled its goalie ($26 of the team struct). Called from doshot
	;(logic94_1), assdefo (logic94_2), asspuckc (logic94_3) and assnearest (logic94_4)
	movem.l	a1,-(sp)
	movea.l	#HmShots,a1
	btst	#6,$62(a3)	;check if home or away 0=home 1=away
	beq.w	.chkgoalie
	movea.l	#AwShots,a1
.chkgoalie
	tst.w	$26(a1)
	movem.l	(sp)+,a1
	rts
sub_FEFF0	;94 only. End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA $50C, then assexit (goalie) or Setplass. Called from assonetimer (high94_1) and setass (hockey94_04)
	movem.l	d0/a0,-(sp)
	bclr	#3,$64(a3)
	bclr	#5,$62(a3)
	bclr	#1,$63(a3)
	clr.w	(word_FFBF76).w
	st	(onetimerplayer).w
	move.w	d1,-(sp)
	move.w	#$50C,d1
	jsr	(SetSPA).l
	tst.w	$34(a3)
	bpl.w	.FF02C
	jsr	(assexit).l
	bra.w	.FF032
.FF02C
	jsr	(Setplass).l
.FF032
	clr.w	$5A(a3)
	st	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
newTitleScreen	;IDA name. 94 only: the title screen (TitleScreenImg, NHLShieldImg, PAlogoImg, TitleImg) with the vblank loc_FF348, song $78, then the
	;scrolling credits ($5776, $57B8 text; sub_FF2C8, sub_FF318) until start. Called from Opening (hockey94_06)
	move	#$2700,sr
	move.w	(VDP_CNTR).l,(RNGseed).w
	move.w	(VDP_CNTR).l,(RNGseed+2).w
	move.l	#loc_FF348,(vbint).l
	bset	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	move.w	#0,d0
	jsr	(setvram).l
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$9217,4(a0)
	move.w	#$8B03,4(a0)
	clr.w	(Vscroll).w
	jsr	(printz).l
	String	$FF,0,0
	move.l	#$80,d0	;IDA hid this (and the Strings)
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	$FE,0,0
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(eraser).l
	clr.w	d4
	move.w	d4,-(sp)
	jsr	(printz).l
	String	$FD,0,0
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#$17,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(word_FFBF12).w
	move.w	(sp)+,d4
	jsr	(printz).l
	String	$FE,0,$17
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	move.w	#$17,d1
	move.w	(a1),d2
	move.w	#5,d3
	moveq	#0,d5
	bset	#0,(word_FFC2F8).w
	jsr	(dobitmap).l
	bclr	#0,(word_FFC2F8).w
	move.w	(word_FFBF12).w,d4
	jsr	(printz).l
	String	$BE,1,1
	movea.l	#NHLShieldImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,$19,1
	movea.l	#PAlogoImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,1,$E
	movea.l	#TitleImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#8,d5
	jsr	(dobitmap).l
	clr.w	(palfadenew).w
	clr.l	(dword_FFBDA8).w
	clr.w	(word_FFBDAC).w
	move.w	d4,(word_FFB012).w
	movea.l	#unk_AAC5A,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$0D104567,$89ABCDEF	;remap table. FF210 + FF211 = Palette assignment for scrolling credits
	jsr	(printz).l
	String	$EF,0,0
	movea.l	#$5776,a1	;start of credits for scrolling
	jsr	(sub_FF2C8).l
	addi.w	#$20,(Vscroll).w
	move.w	#$104,(word_FFB8B2).w
	move.w	#$120,(word_FFB8AE).w
	move.w	#$D0,(word_FFB8B0).w
	clr.w	(asv).w
	move.w	#$FFCE,(DispAttribCtr).w
	move.w	#$20,(palcount).w
	move.w	#$78,-(sp)
	jsr	(song).l
	bsr.w	sub_FF3B0
	move	#$2500,sr
.FF26A
	jsr	(sub_FF318).l
	tst.w	(word_FFB8B2).w
	bne.s	.FF26A
	move.w	#$3C,d3
.FF27A
	jsr	(sub_FF318).l
	dbf	d3,.FF27A
	jsr	(printz).l
	String	$EF,0,0
	movea.l	#$57B8,a1
.FF296
	jsr	(sub_FF2C8).l
	adda.w	(a1),a1
	moveq	#$27,d4
.FF2A0
	jsr	(sub_FF318).l
	jsr	(sub_FF318).l
	addq.w	#1,(Vscroll).w
	dbf	d4,.FF2A0
	moveq	#$78,d4
.FF2B6
	jsr	(sub_FF318).l
	dbf	d4,.FF2B6
	tst.w	2(a1)
	bpl.s	.FF296
	rts
sub_FF2C8	;94 only. Credits: clear the row below the screen (Vscroll / 8 + $1C) and print the Strings from a1 centred there
	move.w	(Vscroll).w,d0
	asr.w	#3,d0
	addi.w	#$1C,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	move.w	d0,-(sp)
	clr.w	(printx).w
	moveq	#$20,d0
	moveq	#6,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
.FF2F2
	move.w	(a1),d0
	asr.w	#1,d0
	neg.w	d0
	addi.w	#$11,d0
	move.w	d0,(printx).w
	jsr	(print).l
	addq.w	#1,(printy).w
	andi.w	#$1F,(printy).w
	tst.w	2(a1)
	bpl.s	.FF2F2
	rts
sub_FF318	;94 only. Credits: wait for vcount, run the word_FFB8B2 count down; start (orjoy bit 7) returns from the caller too
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(vcount).w,d0
.FF320
	cmp.w	(vcount).w,d0
	beq.s	.FF320
	subq.w	#2,(word_FFB8B2).w
	bpl.w	.FF332
	clr.w	(word_FFB8B2).w
.FF332
	jsr	(orjoy).l
	btst	#7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	beq.w	.FF346
	addq.w	#4,sp
.FF346
	rts
loc_FF348	;IDA label. newTitleScreen vblank: line scroll table (SortCords) and Vscroll, sprites, cramfade, sub_FF3F8, MusicVB
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.FF39A
	movea.w	#(SortCords-M68K_RAM),a0
	move.w	(VSCRLPM).w,d1
	move.w	#$1C0,d0
	jsr	(DoDMA).l
	movea.l	#VDP_DATA,a0
	move.l	#$40000010,4(a0)
	move.w	(Vscroll).w,(a0)
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(word_FFC2E8).w,d0
	beq.w	.FF394
	clr.w	(word_FFC2E8).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
.FF394
	jsr	(cramfade).l
.FF39A
	addq.w	#1,(vcount).w
	jsr	(sub_FF3F8).l
	jsr	(MusicVB).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
sub_FF3B0	;94 only. Credits: the line scroll table at SortCords
	movem.l	d0-d1,-(sp)
	move.w	#$14,(Hscroll).w
	move.w	#$50,(word_FFBF14).w
	move.w	#$50,d0
	movea.l	#SortCords,a0
	move.l	#$FD80,d1
.FF3D0
	move.l	d1,(a0)+
	btst	#0,d0
	bne.w	.FF3DC
	subq.w	#1,d1
.FF3DC
	dbf	d0,.FF3D0
	move.w	#$60,d0
	move.l	#$100,d1
.FF3EA
	move.l	d1,(a0)+
	addq.l	#4,d1
	dbf	d0,.FF3EA
	movem.l	(sp)+,d0-d1
	rts
sub_FF3F8	;94 only. Credits: line scroll step, every word_FFBF14 frames
	subq.w	#1,(word_FFBF14).w
	bmi.w	.FF402
	rts
.FF402
	clr.w	(word_FFBF14).w
	movem.l	d0-d2/a0,-(sp)
	move.w	#$DF,d0
	movea.w	#(SortCords-M68K_RAM),a0
.FF412
	tst.l	(a0)+
	cmp.w	#$28,d0
	ble.w	.FF458
	move.w	(Hscroll).w,d1
	cmp.w	#$8F,d0
	blt.w	.FF44C
	move.w	-2(a0),d2
	beq.w	.FF458
	add.w	d1,d2
	move.w	d2,-2(a0)
	andi.w	#$FC00,d2
	cmp.w	#$FC00,d2
	beq.w	.FF458
	move.w	#0,-2(a0)
	bra.w	.FF458
.FF44C
	sub.w	d1,-2(a0)
	bpl.w	.FF458
	clr.w	-2(a0)
.FF458
	dbf	d0,.FF412
	movem.l	(sp)+,d0-d2/a0
	rts
unk_FF462	;IDA name. Team logo palettes, 16 colors per team. Used by sub_FD90C, sub_FA66E (high94_2), sub_FD17E (hockey94_07) and loc_F865C (hockey94_08)
	dc.w	$EEA,0,$42,$EEA,$EEA,$EEE,0,$888,$AAA,$68,$8A,$CE,$260,$40,$664,$E8E
	dc.w	$EE8,$8C,0,$A0A,$A0A,$EEE,0,$C8C,$8C,$888,$68,$846,$44,$422,$8CE,$2AE
	dc.w	$EE8,$822,$8C,$EE8,$EE8,$EEE,0,$EC8,$48C,$C88,$6C,$866,$268,$224,$620,$CE
	dc.w	$EE8,6,$8C,$EE8,$EE8,$EEE,0,$8EE,$2CE,$2AE,$26E,$C,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,0,6,$EE8,$EE8,$EEE,0,$8EE,$A8E,$4AC,$A88,$46C,$226,$644,$22E,$262
	dc.w	$EE8,0,$42,$EE8,$EE8,$EEE,0,$8AA,$688,$488,$466,$244,$260,$20,$ACC,0
	dc.w	$EE8,6,6,$EE8,$EE8,$EEE,0,$C8E,$86E,$44E,$82E,$20E,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,$4A,$EE8,$EE8,$EEE,0,$CEA,$A8E,$8A8,$44E,$488,$2E,$440,$400,$EE8
	dc.w	$EEA,$4A,$600,$EEA,$EEA,$EEE,0,$8AE,$4AE,$66,$88,$220,$A84,$842,$200,$2E
	dc.w	$EE8,$42,$822,$EE8,$EE8,$EEE,0,$20,$40,$A8A,$20,$466,$200,$224,$888,$422
	dc.w	$EE8,0,0,$EE8,$EE8,$EEE,0,$AAA,$888,$666,$444,$222,$CCC,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$88E,$26E,$C68,$2E,$A24,$EAA,$EE8,$EE8,$EE8
	dc.w	$EE8,$20,6,$EE8,$EE8,$EEE,0,$AAA,$A,$888,$C,$22,6,$CCC,$EE8,$EE8
	dc.w	$EE8,$822,$4A,$EE8,$EE8,$EEE,0,$AA8,$66E,$864,$22C,$62A,8,$622,$222,$A8E
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$AAA,$C86,$2E,$C60,$844,$444,$840,8,$EC8
	dc.w	$EE8,6,$6A,$EE8,$EE8,$EEE,0,$68A,$688,$466,$244,$22C,$228,8,$AAA,4
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$CCC,$88E,$AAA,$46E,$6E,$888,$666,$2E,$444
	dc.w	$EE8,0,$8C,$EE8,$EE8,$EEE,0,$AAA,$88A,$66A,$4EE,$464,$440,$2CE,$244,$AEE
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$C00,$E,$E44,$ECE,$E80,$88E,$EE8,$EE8,$EE8
	dc.w	$EE8,0,$822,$EE8,$EE8,$EEE,0,$860,$642,$888,$CA8,$ACC,$2AE,$6E,$48,$46A
	dc.w	$EE8,$822,$6A,$EE8,$EE8,$EEE,0,$602,$24C,2,$26,$68,$428,$86E,$EE8,$EE8
	dc.w	$EE8,0,$600,$EE8,$EE8,$EEE,0,$C86,$E84,$A84,$C44,$822,$E20,$600,$A00,$EA8
	dc.w	$EE8,$600,$600,$EE8,$EE8,$EEE,0,$ECA,$AAA,$C66,$822,$CCC,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,0,$8C,$EE8,$EE8,$EEE,0,$CE,$6A,$4E,$28,$22,$20,$8E,$888,$6CE
	dc.w	$EE8,6,$600,$EE8,$EE8,$EEE,0,$22C,$C86,$EA8,$88E,$842,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$22C,$422,$AAC,$666,$CAA,$444,$66E,$8CE,$226
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$688,$464,$244,$222,$4E,$A,$22,$AAA,0
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$688,$464,$244,$222,$4E,$A,$22,$AAA,0
sub_FF7E2	;94 only. Not in a shootout (word_FFC2FA bit 1), scores not level: once (sflags2 bit 5), ChooseSong with SongIndex 1 (home ahead) or 4
	;and byte_FFC2FE bit 6; sflags2 is put back on exit. Called from puckfaceoff2 (logic94_4)
	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).w,-(sp)
	btst	#1,(word_FFC2FA).w
	bne.w	loc_FF884
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a3
	move.w	$24(a2),d0
	sub.w	$24(a3),d0
	beq.w	loc_FF884
	bpl.w	.FF824
	btst	#6,(sflags2).w
	bne.w	.FF83A
	bsr.w	sub_FF87C
	bset	#6,(sflags2).w
	bra.w	.FF83A
.FF824
	exg	a2,a3
	btst	#6,(sflags2).w
	beq.w	.FF83A
	bsr.w	sub_FF87C
	bclr	#6,(sflags2).w
.FF83A
	bset	#5,(sflags2).w
	bne.w	loc_FF884
	cmpa.w	#$C6CE,a3
	bne.w	.FF868
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#1,(SongIndex).w
	jsr	(ChooseSong).l
.FF85E
	bset	#6,(byte_FFC2FE).w
	bra.w	loc_FF884
.FF868
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#4,(SongIndex).w
	jsr	(ChooseSong).l
	bra.s	.FF85E
sub_FF87C	;94 only. Clear sflags2 bit 5
	bclr	#5,(sflags2).w
	rts
loc_FF884	;IDA label. sub_FF7E2 exit
	move.w	(sp)+,(sflags2).w
	movem.l	(sp)+,d0/a0-a3
	rts
sub_FF88E	;94 only. Clear the penalties: PBnum, Penaltytimer, Pencntdwn, PenBuf and both teams' penalty slots (clrTmPdst). Called from clockcont_0 (hockey94_01)
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).w
	clr.w	(Penaltytimer).w
	clr.w	(Pencntdwn).w
	move.w	#$10,d0
	movea.l	#PenBuf,a0
.loop
	clr.l	(a0)+
	dbf	d0,.loop
	movea.l	#HmShots,a0
	bsr.w	clrTmPdst
	movea.l	#AwShots,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst	;IDA name (and comments). 94 only
	move.w	#$19,d0	;19 = 25 decimal (max roster size)
	adda.w	#$66,a0	;'f'   ; Starting at (C734-home, CA98-away) and decrementing
.loop
	move.w	#$FFFE,(a0)+	;-2 = bench
	dbf	d0,.loop
	move.w	#$FFFF,(a0)	;-1 = ice
	rts
sub_FF8DE	;94 only. The icon by the name of player word_FFDEE8 of team a2 at x word_FFDEEA, y $19: unk_F5AF6 when he is in $FFFFBF5C /
	;$FFFFBF5E, unk_F5D1C in $FFFFBF60 / $FFFFBF62, else clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$FFFFBF5C,a0
	move.w	#2,(word_FFDEEA).w
	cmpa.l	#HmShots,a2
	bne.w	.FF904
	movea.l	#$FFFFBF5E,a0
	move.w	#$20,(word_FFDEEA).w
.FF904
	move.w	#0,d0
.FF908
	move.w	(a0)+,d1
	cmp.w	(word_FFDEE8).w,d1
	beq.w	.FF960
	dbf	d0,.FF908
	movea.l	#$FFFFBF60,a0
	cmpa.l	#HmShots,a2
	bne.w	.FF92C
	movea.l	#$FFFFBF62,a0
.FF92C
	move.w	#0,d0
.FF930
	move.w	(a0)+,d1
	cmp.w	(word_FFDEE8).w,d1
	beq.w	.FF96E
	dbf	d0,.FF930
	move.w	(word_FFDEEA).w,(printx).w
	move.w	#$19,(printy).w
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.FF9A2
.FF960
	move.w	(word_FFDEE4).w,d4
	movea.l	#unk_F5AF6,a0
	bra.w	.FF978
.FF96E
	move.w	(word_FFDEE6).w,d4
	movea.l	#unk_F5D1C,a0
.FF978
	move.w	(word_FFDEEA).w,(printx).w
	move.w	#$19,(printy).w
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	movea.w	#$30A,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
.FF9A2
	movem.l	(sp)+,d0/a0-a1
	rts
chgplayer	;IDA name (and comments). 94 only: the pad d4 takes the nearest free skater to where the puck is going (not a goalie, not locked or
	;unavailable; in a penalty shot / shootout only BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same one. Called from
	;changeplayer (logic94_1)
	btst	#6,(word_FFC2F6).w	;Check bit 6. This is never set anywhere
	bne.w	exit
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0	;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	moveq	#5,d2
	move.w	d4,d3
	eori.w	#2,d3	;other controller
	moveq	#-1,d5	;-1
	movea.w	#(SortCords-M68K_RAM),a0	;start of search
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)
	beq.w	.t1
	adda.w	#$300,a0	;controller is on other team
.t1
	movea.w	#(c1playernum-M68K_RAM),a1
.top
	tst.w	$34(a0)	;position
	ble.w	.next	;cant switch to goalie
	btst	#2,$63(a0)	;#pf2unav
	bne.w	.next	;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	$52(a0),d1	;SCnum
	cmp.w	0(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.FFA22
	btst	#3,$62(a0)	;is player controlled?
	bne.w	.next	;yes branch
.FFA22
	btst	#2,(BA_PS_flags).w
	beq.w	.FFA54
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.FFA54
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next
.FFA54
	btst	#5,$62(a0)	;#pfalock
	bne.w	.next	;player is locked
	movem.w	(sp),d0-d1
	sub.w	(a0),d0	;Xpos
	muls.w	d0,d0
	sub.w	$14(a0),d1	;Ypos
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next
	move.w	$52(a0),d1	;Scnum
	cmp.w	0(a1,d3.w),d1
	beq.w	.next	;this is current player
	move.l	d0,d5
	move.w	d1,d6
.next
	adda.w	#$80,a0	;size of SCstruct
	dbf	d2,.top
	addq.w	#4,sp
	pea	(.ex).l
	cmp.w	0(a1,d4.w),d6
	beq.w	swpchk	;player is same so sweep check
	move.w	d6,d0	;d0 now is new player
	tst.w	d4
	beq.w	j_setc1player	;IDA hid this
	bra.w	j_setc2player
.ex
	movem.l	(sp)+,d0-d6/a0-a1
exit	;IDA name
	rts
swpchk	;IDA name. Sweepcheck (logic94_1)
	jmp	Sweepcheck
j_setc1player	;IDA: setc1player (a thunk IDA gave its target's name)
	jmp	setc1player
j_setc2player	;IDA: setc2player (a thunk IDA gave its target's name)
	jmp	setc2player
