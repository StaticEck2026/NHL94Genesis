;	NHL 94 (retail) segment $F66EE-$F739D
;	94 code in the high ROM, after the graphics: the one-timer (puckvzadj, sub_F6778 / sub_F67E4 pass target, assonetimer,
;	setonetimeranim, onetimershot), the 4 way play adaptor test (Unk_ControlsSetRelated), the crowd meter (LoadCrowdRec, Crowd_Noise),
;	stopna2, the 92 corner wall check (checkwallcoll, wallcollb), the hot / cold tables (Create_HotCold_Table, AttributeCalc) and the
;	hot / cold player lists for the MATCHUPS text (sub_F7144 ... sub_F737E). 94 only; 93 has no code here.
;	Transcribed from lst/nhl94.bin.lst lines 958869-960186. Names and most comments are the IDA ones (this IDA database is
;	commented). IDA gaps written from the retail bytes: unused code IDA left as dc.b (sub_F6DC6 ... sub_F6E1A, sub_F6E3A, sub_F70CC
;	and three rts), and labels for the branches IDA wrote as $F66FC / $F6772 / *+4. Locals are the IDA address or IDA _x name.

puckvzadj	;IDA name. 94 only: set puckvz for a top shelf shot from the distance to the goal line ($108) over puckvy, at most $7FFF. Called from doshot (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(pucky).w,d0	;move pucky into d0
	bpl.w	.F66FC	;branch if positive
	neg.w	d0	;negate d0
.F66FC
	subi.w	#$108,d0
	;sub top goal line from d0
	bpl.w	.0	;branch if positive
	neg.w	d0	;negate d0
.0
	swap	d0	;swap d0 words
	andi.l	#$FFFF0000,d0	;pass upper word of d0
	move.w	(puckvy).w,d1	;move puckvy into d1
	beq.w	.F6772	;branch if zero
	bpl.w	.F671C	;branch if positive
	neg.w	d1	;negate d1
.F671C
	move.w	#$11,d2	;move 11 into d2
	tst.w	(word_FFD06E).w	;This byte is never set
	beq.w	.F672C	;branch if equal (always is)
	move.w	#$16,d2	;move 16 into d2
.F672C
	divu.w	d1,d0	;divide d1 into d0
	andi.l	#$FFFF,d0	;pass lower word of d0
	divu.w	d2,d0	;divide d2 into d0
	tst.w	d0	;check d0
	bne.w	.F6740	;branch if not zero
	move.w	#1,d0	;move 1 into d0
.F6740
	move.l	#$A0000,d1
	move.w	d0,d3	;move d0 into d3
	mulu.w	d2,d0	;mult d2 and d0
	divu.w	d0,d1	;divide d0 into d1
	move.w	d2,d4	;move d2 into d4
	add.w	d2,d2	;double d2
	add.w	d4,d2	;add d4 to d2 (now d2 is d2 x 3)
	mulu.w	d3,d2	;multiply d3 and d2
	cmp.l	#$7FFF,d2	;compare to d2
	blt.w	.F6762	;branch if less than
	move.w	#$7FFF,d2	;move 7FFF into d2
.F6762
	add.w	d2,d1	;add d2 to d1
	tst.w	d1	;test d1
	bpl.w	.F676E	;branch if positive
	move.w	#$7FFF,d1	;move 7FFF into d1
.F676E
	move.w	d1,(puckvz).w	;move d1 into puckvz
.F6772
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F6778	;94 only. One-timer pass: puckvz = sqrt(12 * word_FFD418), then puckvx / puckvy toward the target word_FFD414 / word_FFD416 in puckvz
	;/ 3 frames; flip the puck (puckflip, a3 = the puck at puckx). Called from passmode (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	(word_FFD418).w,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(sroot).l
	move.w	d0,(puckvz).w
	ext.l	d0
	move.w	#3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	(word_FFD414).w,d1
	sub.w	(puckx).w,d1
	swap	d1
	tst.w	d0
	bne.w	.F67B6
	move.w	#1,d0
.F67B6
	divs.w	d0,d1
	move.w	d1,(puckvx).w
	clr.l	d1
	move.w	(word_FFD416).w,d1
	sub.w	(pucky).w,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,(puckvy).w
	movea.l	#puckx,a3
	move.w	(puckvz).w,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F67E4	;94 only. One-timer pass target for receiver a3: an offset by facing from word_F68DE / word_F68FE (skater, near or far from the goal)
	;or word_F691E (goalie), +-10 at random, into word_FFD414 / word_FFD416; word_FFC2F8 bit 2 = near. Called from passmode
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#2,(word_FFC2F8).w
	tst.w	$34(a3)
	bne.w	.F6800
	movea.l	#word_F691E,a0
	bra.w	.F6830
.F6800
	move.w	$14(a3),d0
	btst	#7,$62(a3)
	bne.w	.F6810
	neg.w	d0
.F6810
	bset	#2,(word_FFC2F8).w
	movea.l	#word_F68DE,a0
	cmp.w	#$58,d0
	blt.w	.F6830
	movea.l	#word_F68FE,a0
	bclr	#2,(word_FFC2F8).w
.F6830
	move.w	$54(a3),d0
	btst	#7,$62(a3)
	bne.w	.F6844
	addq.w	#4,d0
	andi.w	#7,d0
.F6844
	asl.w	#2,d0
	move.w	0(a0,d0.w),d1
	move.w	2(a0,d0.w),d2
	cmpa.l	#word_F68FE,a0
	bne.w	.F687E
	move.w	$14(a3),d0
	bpl.w	.F6862
	neg.w	d0
.F6862
	cmp.w	#$8A,d0
	blt.w	.F687E
	move.w	(a3),d0
	bpl.w	.F6872
	neg.w	d0
.F6872
	cmp.w	#$37,d0
	bgt.w	.F687E
	move.w	#$103,d2
.F687E
	btst	#7,$62(a3)
	bne.w	.F688C
	neg.w	d1
	neg.w	d2
.F688C
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,(word_FFD414).w
	tst.w	$34(a3)
	beq.w	.F68D4
	sub.w	(a3),d1
	bmi.w	.F68C8
	subi.w	#$3C,d1
	bpl.w	.F68D4
	neg.w	d1
	add.w	d1,(word_FFD414).w
	bra.w	.F68D4
.F68C8
	addi.w	#$3C,d1
	bmi.w	.F68D4
	sub.w	d1,(word_FFD414).w
.F68D4
	move.w	d2,(word_FFD416).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
word_F68DE	;IDA name. sub_F67E4 target offsets (x, y) by facing, receiver near the goal
	dc.w	$74,$C2,$74,$C2,$74,$C2,$74,$C2
	dc.w	$FF8C,$C2,$FF8C,$C2,$FF8C,$C2,$FF8C,$C2
word_F68FE	;IDA name. sub_F67E4 target offsets (x, y) by facing, receiver far from the goal
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB
word_F691E	;IDA name. sub_F67E4 target offsets (x, y) by facing, goalie
	dc.w	$FFFB,$FFF7,$32,$FFF7,$32,$FFF7,$32,$FFF7
	dc.w	$FFFB,$FFF7,$FFCE,$FFF7,$FFCE,$FFF7,$FFCE,$FFF7
assonetimer	;IDA name (and comments). 94 only: assignment $23 (asstab, hockey94_11), player a3 shooting a one-timer: take control of him
	;(setc1player / setc2player, also for pads 3 and 4), start the animation (setonetimeranim), then shoot when the puck arrives (sub_FEFF0)
	bclr	#1,$62(a3)	;pfna - clear new assignment
	beq.w	.checkxpos	;branch if not new assignment
	bset	#3,$64(a3)	;set one timer bit
	bne.w	.checkxpos	;branch if already set
	bclr	#0,(word_FFBF76).w
	bclr	#5,(byte_FFC2FE).w
	clr.w	(word_FFBF76).w
	clr.w	(word_FFBF6E).w
	st	(passplayer).w
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$52(a3),d0	;move a3 SCnum into d0
	move.w	d0,(onetimerplayer).w	;move d0
	btst	#3,$62(a3)	;check if joystick controlled
	bne.w	.setanim	;branch if so
	tst.w	(inputjoy).w	;check input controller
	bmi.w	.setanim	;branch if minus (no control)
	beq.w	.cont1or3	;branch if controller 1 or 3
	cmpi.w	#1,(TmpJoyPuckCarrier).w	;compare if puck carrier is player 4
	bne.w	.setplayer2	;branch if not
	move.w	(cont2team).w,-(sp)
	move.w	(c2playernum).w,-(sp)
	move.w	(cont4team).w,(cont2team).w
	move.w	(c4playernum).w,(c2playernum).w
	jsr	(setc2player).l
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(c2playernum).w
	move.w	(sp)+,(cont2team).w
	bra.w	.setanim
.setplayer2
	jsr	(setc2player).l
	bra.w	.setanim
.cont1or3
	tst.w	(TmpJoyPuckCarrier).w	;check if puck carrier is player 3
	bne.w	.setplayer1	;branch if not
	move.w	(cont1team).w,-(sp)
	move.w	(c1playernum).w,-(sp)
	move.w	(cont3team).w,(cont1team).w
	move.w	(c3playernum).w,(c1playernum).w
	jsr	(setc1player).l
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(c1playernum).w
	move.w	(sp)+,(cont1team).w
	bra.w	.setanim
.setplayer1
	jsr	(setc1player).l
	bra.w	.setanim	;IDA: *+4
.setanim
	move.w	d0,-(sp)
	bsr.w	setonetimeranim	;sets the one timer animation
	clr.w	$5A(a3)	;clear SPAnum
	jsr	(SetSPA).l
	bset	#5,$62(a3)	;lock animation
	bset	#1,$63(a3)	;set anim in progress
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.checkxpos
	btst	#0,(word_FFBF76).w	;check if shot initiated
	bne.w	.F6A96	;branch if set
	movem.w	d0-d1,-(sp)	;push to stack
	move.w	(puckx).w,d0	;move puckx to d0
	sub.w	(a3),d0	;sub Xpos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 3C (60 pixels)
	bgt.w	.chkxvel	;branch if greater than
	cmp.w	#$FFC4,d0	;compare to -60 pixels
	bgt.w	.chkypos	;branch if greater than
.chkxvel
	move.w	(puckvx).w,d1	;move puckvx into d1
	eor.w	d1,d0	;EOR d1 with d0
	bmi.w	.chkypos	;branch if minus
.F6A6A
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	bra.w	.F6A9E
.chkypos
	move.w	(pucky).w,d0	;move pucky into d0
	sub.w	$14(a3),d0	;sub Ypos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 60 pix
	bgt.w	.chkyvel	;branch if greater than
	cmp.w	#$FFC4,d0	;check with -60 pix
	bgt.w	.F6A92	;branch if greater than
.chkyvel
	move.w	(puckvy).w,d1	;move puckvy into d0
	eor.w	d1,d0	;EOR d1 with d0
	bpl.s	.F6A6A	;branch if positive
.F6A92
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack
.F6A96
	tst.w	(puckc).w	;check if puck carrier
	bmi.w	.F6AA8	;branch if no puck carrier
.F6A9E
	bclr	#7,(byte_FFC2FE).w	;clear bit 7
	bra.w	.F6C02
.F6AA8
	btst	#0,(gmode).w	;check if game clock
	bne.w	.F6C02	;branch if clock stopped
	movem.l	d0-d1,-(sp)	;push to stack
	cmpi.w	#$10,$5A(a3)	;compare 10 to SPAnum
	bge.w	.F6B58	;branch if greater than or equal
	btst	#2,(word_FFBF76).w	;check bit 2
	bne.w	.F6B58	;branch if set
	move.w	(a3),d0	;move Xpos into d0
	move.w	(puckx).w,d1	;move puckx into d1
	sub.w	d1,d0	;sub d1 from d0
	bpl.w	.F6AD8	;branch if positive
	neg.w	d0	;negate d0
.F6AD8
	move.w	$14(a3),d1	;move Ypos into d1
	move.w	(pucky).w,d2	;move pucky into d2
	sub.w	d2,d1	;sub d2 from d1
	bpl.w	.F6AE8	;branch if positive
	neg.w	d1	;negate d1
.F6AE8
	move.w	(puckvx).w,d2	;move puckvx into d2
	beq.w	.F6AF6	;branch if d2 is 0
	cmp.w	d0,d1	;compare d0 to d1
	ble.w	.F6AFC	;branch if less than or equal
.F6AF6
	move.w	(puckvy).w,d2
	move.w	d1,d0
.F6AFC
	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.F6B0C
	neg.w	d2
.F6B0C
	move.w	#$11,d1
	tst.w	(word_FFD06E).w
	beq.w	.F6B1C
	move.w	#$16,d1
.F6B1C
	tst.w	d2
	bne.w	.F6B26
	move.w	#1,d2
.F6B26
	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	$5A(a3),d2
	lsr.w	#2,d2
	subq.w	#6,d2
	neg.w	d2
	asl.w	#2,d2
	cmp.w	d2,d0
	bgt.w	.F6B50
	neg.w	$5A(a3)
	addi.w	#$18,$5A(a3)
	bra.w	.F6BC8
.F6B50
	add.w	d7,(word_FFBF6E).w
	bra.w	.F6B7E
.F6B58
	bset	#2,(word_FFBF76).w
	btst	#1,(word_FFBF76).w
	bne.w	.F6B7E
	cmpi.w	#$18,$5A(a3)
	bne.w	.F6B7E
	addi.w	#$30,$5C(a3)
	bset	#1,(word_FFBF76).w
.F6B7E
	btst	#1,(word_FFBF76).w
	beq.w	.F6BA4
	cmpi.w	#$18,$5A(a3)
	ble.w	.F6BA4
	btst	#0,(word_FFBF76).w
	bne.w	.F6BA4
	movem.l	(sp)+,d0-d1
	bra.w	.F6C02
.F6BA4
	btst	#0,(word_FFBF76).w
	beq.w	.F6BC8
	cmpi.w	#$18,$5A(a3)
	bne.w	.F6BC8
	cmpi.w	#1,$5C(a3)
	ble.w	.F6BC8
	move.w	#1,$5C(a3)
.F6BC8
	btst	#1,$63(a3)
	bne.w	.F6BDA
	movem.l	(sp)+,d0-d1
	bra.w	.F6BF8
.F6BDA
	move.w	$5A(a3),d0
	movem.l	(sp)+,d0-d1
	btst	#0,(word_FFBF76).w
	beq.w	.F6BF6
	bclr	#5,$62(a3)
	bra.w	.F6BF8
.F6BF6
	nop
.F6BF8
	btst	#1,$63(a3)
	bne.w	.ex
.F6C02
	jsr	(sub_FEFF0).l
.ex
	rts
setonetimeranim	;IDA name. 94 only: the one-timer animation: d1 = $7FC or $92E from the angle to the goal (vtoa, noidea)
	move.w	#$7FC,d1
	movem.w	d0-d1,-(sp)	;push to stack d0 and d1
	move.w	(a3),d0	;move XPos of a3 into d0
	neg.w	d0	;negate d0
	move.w	#$108,d1	;move top goal line into d1
	btst	#7,$62(a3)	;check which goal shooting at
	bne.w	.F6C26	;branch if top
	neg.w	d1	;negate d1
.F6C26
	sub.w	$14(a3),d1	;sub Ypos from d1
	jsr	(vtoa).l
	jsr	(noidea).l	;code doesnt save any changes
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	beq.w	.ex
	move.w	#$92E,d1
.ex
	rts
sub_F6C44	;94 only. d0 = 1 when the puck is on the half of the goal player a3 shoots at, else 0 (the code after the bra is never used). Called from doinput (logic94_1) and logic94_4
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0
	btst	#7,$62(a3)	;pfgoal - check which goal shooting at
	bne.w	.cont	;branch if top goal
	neg.w	d0
.cont
	tst.w	d0	;check if d0 is 0
	bpl.w	.plus	;branch if higher
	bra.w	.0
	move.w	(passdir).w,d0	;code never used from here up to _0
	addq.w	#4,d0
	andi.w	#7,d0
	move.w	$54(a3),d1
	cmp.w	d0,d1
	bra.w	.plus
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#3,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#1,d1
	andi.w	#7,d1
	beq.w	.plus
.0
	move.w	#0,d0
	bra.w	.ex
.plus
	move.w	#1,d0
.ex
	movem.w	(sp)+,d0-d1
	rts
onetimershot	;IDA name (and comments). 94 only: do the one-timer shot (doshot), credit the last two passers as the assists, add to crowdlevel /
	;CwdExciteLvl and to the one-timer attempts ($35C of the team struct). Called from puckstick (hockey94_05)
	move.w	#4,(passdir).w
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#HmShots,a0	;Home Stats
	btst	#6,$62(a3)	;check if home or away
	beq.w	.F6CDE	;branch if home
	lea	$364(a0),a0	;add if away
.F6CDE
	clr.w	d0
	move.b	$66(a3),d0	;player offset in roster
	move.w	$1A(a0),$1C(a0)	;move assist 1 player to assist 2
	move.w	$18(a0),$1A(a0)	;move last player to touch puck to assist 1
	move.w	d0,$18(a0)	;move d0 into player touching puck
	bset	#7,(byte_FFC2FE).w	;set bit 7
	addi.w	#$96,(crowdlevel).w	;add to crowdlevel
	addi.w	#$A,(CwdExciteLvl).w	;add to Excite Level
	addq.w	#1,$35C(a0)	;add to one timer attempt
	movem.l	(sp)+,d0/a0
	bset	#0,(word_FFBF76).w	;set bit 0
	bset	#1,$63(a3)	;set animation in progress
	bset	#1,(word_FFC2F8).w	;set bit 1
	rts
noidea	;IDA name. 94 only, called from setonetimeranim. IDA comment: it does nothing, d0 and d1 are restored at the end; it seems meant to
	;change the way the one-timer player faces
	movem.w	d0-d1,-(sp)	;push d0 and d1 on stack
	neg.w	d0	;negate d0
	addq.w	#8,d0	;add 8 to d0
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	$54(a3),d1	;move facedir into d1
	add.w	d0,d1	;add d0 to d1
	andi.w	#7,d1	;pass first 3 bits of d1
	cmp.w	#4,d1	;compare to 4
	bgt.w	.g0	;branch if greater than
	move.w	4(a3),d0	;move attribute into d0
	eori.w	#$FFFF,d0	;EOR FFFF with d0. Makes d0 opposite.
	andi.w	#$800,d0	;pass 12th bit of d0
	bra.w	.ex
.g0
	move.w	4(a3),d0	;move attribute into d0
	andi.w	#$800,d0	;pass 12th bit of d0
.ex
	movem.w	(sp)+,d0-d1	;pop from stack
	rts
Unk_ControlsSetRelated	;IDA name. 94 only: detect the 4 way play adaptor (EA 4 Way Play) on port 2: FourWayPlay = 1 when found. Called from Begin (hockey94_01)
	move.w	#0,(IO_Z80RES).l
	move.b	#$40,(IO_CT1_CTRL+1).l
	move.b	#$43,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	#$7F,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	(IO_CT1_DATA+1).l,d0
	andi.b	#3,d0
	cmp.b	#0,d0
	bne.s	.F6DAE
	move.w	#1,(FourWayPlay).w
	bra.s	.F6DBC
.F6DAE
	move.w	#0,(FourWayPlay).w
	move.b	#$40,(IO_CT2_CTRL+1).l
.F6DBC
	move.w	#$100,(IO_Z80RES).l
	rts
sub_F6DC6	;no IDA label (IDA dc.b, no xref). 94 only, unused: read 4 way play pad 1 (ReadJoy1 with the pad word swapped in)
	move.b	#0,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	($FFFFBEFE).w,($FFFFBEFA).w
	jsr	(ReadJoy1).l
	move.w	($FFFFBEFA).w,($FFFFBEFE).w
	rts
sub_F6DE2	;no IDA label (IDA dc.b, no xref). 94 only, unused: the same for pad 2
	move.b	#$10,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	($FFFFBF00).w,($FFFFBEFA).w
	jsr	(ReadJoy1).l
	move.w	($FFFFBEFA).w,($FFFFBF00).w
	rts
sub_F6DFE	;no IDA label (IDA dc.b, no xref). 94 only, unused: the same for pad 3
	move.b	#$20,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	($FFFFBF02).w,($FFFFBEFA).w
	jsr	(ReadJoy1).l
	move.w	($FFFFBEFA).w,($FFFFBF02).w
	rts
sub_F6E1A	;no IDA label (IDA dc.b, no xref). 94 only, unused: the same for pad 4
	move.b	#$30,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	($FFFFBF04).w,($FFFFBEFA).w
	jsr	(ReadJoy1).l
	move.w	($FFFFBEFA).w,($FFFFBF04).w
	rts
	rts	;IDA dc.b, no xref
nullsub_2	;IDA name. An rts; called from forcepldata
	rts
sub_F6E3A	;no IDA label (IDA dc.b, no xref). 94 only, unused: put player a3's number ($52) in the home or away nibble of word_FFBE86 (unless word_FFBE78 is -1)
	cmpi.w	#$FFFF,(word_FFBE78).w
	beq.w	.F6E88
	movem.l	d0-d2,-(sp)
	move.w	#1,d0
	btst	#6,$62(a3)
	beq.w	.F6E5A
	move.w	#2,d0
.F6E5A
	cmp.w	(cont3team).w,d0
	beq.w	.F6E6E
	move.w	#$F,d1
	move.w	#4,d0
	bra.w	.F6E76
.F6E6E
	move.w	#$F0,d1
	move.w	#0,d0
.F6E76
	and.w	d1,(word_FFBE86).w
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(word_FFBE86).w
	movem.l	(sp)+,d0-d2
.F6E88
	rts
LoadCrowdRec	;IDA name. 94 only: CrowdRecord = the arena record of HomeTeam from save RAM (clrCrowdRAM into the buffer at ThreeStars), $50 when none. Called from StartGame (hockey94_01)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(clrCrowdRAM).l
	move.b	8(a0),d0
	beq.w	.F6EB0
	andi.w	#$FF,d0
	bra.w	.ex
.F6EB0
	move.w	#$50,d0
.ex
	move.w	d0,(CrowdRecord).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise	;IDA name (Crowd_Noise?). 94 only: the crowd meter each frame: crowd noise on / off (word_FFC2F6 bit 7) from CwdExciteLvl against
	;CrowdRecord / CrowdAvg, and every $14 ticks CurCrowdMeter (sqrt(level * 4) + 65 dB) and CrowdPeak. Called from setvideo (video94_1)
	btst	#7,(sflags).w	;screen is in horizontal mode
	bne.w	.ex1
	btst	#0,(word_FFC2FA).w
	bne.w	.ex1
	btst	#0,(sflags3).w	;check if game paused
	bne.w	.ex2
	btst	#7,(word_FFC2F6).w
	bne.w	.F6F24
	tst.w	(word_FFC304).w
	beq.w	.F6EFC
	subq.w	#1,(word_FFC304).w
	bpl.w	.ex1
	clr.w	(word_FFC304).w
.ex2
	rts
.F6EFC
	move.w	(CrowdRecord).w,d0
	move.w	d0,(CrowdAvg).w
	subi.w	#$B,(CrowdAvg).w
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#2,d0
	addq.w	#6,d0
	cmp.w	(CwdExciteLvl).w,d0
	bgt.w	.ex1
	bset	#7,(word_FFC2F6).w
	rts
.F6F24
	move.w	(CrowdAvg).w,d0
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#2,d0
	cmp.w	(CwdExciteLvl).w,d0
	blt.w	.F6F3E
	bclr	#7,(word_FFC2F6).w
.F6F3E
	sub.w	d7,(CwdChkCntr).w
	bpl.w	.ex1
	move.w	#$14,(CwdChkCntr).w
	addq.w	#1,(CwdChkCnt).w
	move.w	(CwdExciteLvl).w,d0
	ext.l	d0
	asl.w	#2,d0
	jsr	(sroot).l
	addi.w	#$41,d0
	move.w	d0,(CurCrowdMeter).w
	cmp.w	(CrowdPeak).w,d0
	ble.w	.F6F72
	move.w	d0,(CrowdPeak).w
.F6F72
	move.w	(CurCrowdMeter).w,d0
	cmp.w	(CrowdRecord).w,d0
	blt.w	.stack
	bra.w	.stack	;IDA: *+4
.stack
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex1
	rts
stopna2	;IDA name (92 / 93 name). Slow the velocity at $28 / $2A of a3 toward 0 by $7D0. Called from logic94_5 (goalieacc)
	tst.w	$28(a3)
	bpl.w	.xp
	addi.w	#$7D0,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp
	subi.w	#$7D0,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y
	tst.w	$2A(a3)
	bpl.w	.yp
	addi.w	#$7D0,$2A(a3)
	bmi.w	.ex
	clr.w	$2A(a3)
.yp
	subi.w	#$7D0,$2A(a3)
	bpl.w	.ex
	clr.w	$2A(a3)
.ex
	rts
checkwallcoll	;IDA name (and comments; 92 name). IDA: ywall 210 = blue line to the end of the rink, corner radius 64. Corner circles and side walls
	;for object a3 at d2 / d3 (wcradiusx / wcradiusy); a hit goes to
	;wallcollb. Called from wallcollduringcheck (high94_2). 93 checkwallcoll is checkwallcoll2 (hockey94_04)
	bclr	#4,$64(a3)	;clears bit 4 in pflags3 (not used in 92)
	move.w	#$88,d4	;sideline
	sub.w	(wcradiusx).w,d4	;BD22 = wcradiusx
	move.w	#$12A,d5	;ywall
	sub.w	(wcradiusy).w,d5	;BD24 = wcradiusy
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4	;'@'   ; radius
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.ctc
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.ctc
	neg.w	d5
	cmp.w	d5,d3
	blt.w	.exit
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.circle
	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0	;cos0 = dy/r
	move.w	d2,d1	;sin0 = -dx/r
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3	;dist from dot
	cmp.l	#$1000,d3	;.radius^2 = $1000
	bls.w	.exit
	exg	d0,d3
	jsr	(sroot).l
	exg	d0,d3
	ext.l	d0
	asl.l	#8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#8,d1
	divs.w	d3,d1
	bsr.w	wallcollb
.exit
	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0	;wallcos(a3)
	or.w	$50(a3),d0	;wallsin(a3)
	bne.w	rtss3
	move.w	#$100,d0	;now check side walls
	clr.w	d1
	cmp.w	d5,d3
	bge.w	wallcollb
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	wallcollb
	exg	d0,d1
	cmp.w	d4,d2
	bge.w	wallcollb
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	wallcollb
rtss3	;IDA name. The shared rts of checkwallcoll
	rts
wallcollb	;IDA name (92 name). Thunk: jmp wallcollb2 (hockey94_04)
	jmp	wallcollb2
Create_HotCold_Table	;IDA name (and comments). 94 only: fill the hot / cold table at $1A2 of team struct a0 with 416 random values (-9 ... 8,
	;randomd0s). Called from StartGame (hockey94_01) and ScoutingReport (hockey94_07)
	movem.l	d0-d7,-(sp)
	move.w	#$19F,d1	;$19F = 415. Loop will run 416 times.
	;(26 players/team * 8) * 2 teams = 416
HotColdLoop	;IDA name. The Create_HotCold_Table loop
	move.w	#9,d0	;sets RNG limit (-9 - +8)
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A2,a0	;offset to Hot/Cold table
	move.b	d0,0(a0,d1.w)
	movea.l	(sp)+,a0
	dbf	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
sub_F70CC	;no IDA label (IDA dc.b, no xref). 94 only, unused: clamp d3 to 0 ... 100
	tst.w	d3
	bpl.w	.F70D6
	clr.w	d3
	rts
.F70D6
	cmp.w	#$64,d3
	ble.w	.F70E2
	move.w	#$64,d3
.F70E2
	rts
AttributeCalc	;IDA name (and comments). 94 only: attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0 ... $1E. Called from setplayer (hockey94_05)
	movem.l	d0-d2/a1,-(sp)
	move.w	(word_FFBF14).w,d1	;BF14 goes to d1
	movea.l	#HmShots,a1	;Start of Home Team struct
	btst	#6,$62(a3)	;Check if home or away
	beq.w	.attribmath
.away
	;shift to start of Away Team struct
	adda.l	#$364,a1
.attribmath
	clr.w	d1
	move.b	$66(a3),d1	;move roster offset into d1
	asl.w	#4,d1	;shifts d1 4 bits left, moving the values over 1 nibble
	adda.l	#$1A2,a1	;a1 points to Hot/Cold Table Start
	move.b	0(a1,d1.w),d1	;move data at add. (a1 + d1) into d1
	ext.w	d1	;sign-extend word. Ex: F5 (-5) -> FFF5
	ext.l	d1	;sign-extend long word. Ex: FFF5 -> FFFFFFF5
	divs.w	#3,d1	;Signed-Div D1 by 3 (FFFFFFF5 / 3, or -5 / 3 = -1r2, or FFFEFFFF
	;Remainder is 4 MS Nibbles, result is 4 LS Nibbles)
	move.w	d3,-(sp)	;push d3 onto stack
	asl.w	#2,d3	;shift left 2 bits (mult. by 4)
	add.w	(sp)+,d3	;Pop off d3 value and add to d3 (attrib X 5)
	add.w	d1,d3	;add d1 (H/C value) to d3
	bmi.w	.LowerLimit
.UpperLimitCheck
	;check if above upper limit (1E or 30 decimal)
	cmp.w	#$1E,d3
	blt.w	.MaskAttribMathResult
.UpperLimit
	;if above, set to 1E
	move.w	#$1E,d3
	bra.w	.MaskAttribMathResult
.LowerLimit
	clr.w	d3	;if below lower limit (0), set to 0
.MaskAttribMathResult
	andi.w	#$FF,d3	;pass only lower byte
	movem.l	(sp)+,d0-d2/a1
	rts
sub_F7144	;94 only. d1 = the next home hot player (word_FFBF56 index into the list at $FFBF5E), a1 = HmShots. Called from sub_17730 (hockey94_06, the MATCHUPS text)
	movem.l	d0/a0,-(sp)
	movea.l	#$FFFFBF5E,a0
	move.w	(word_FFBF56).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(word_FFBF56).w
	bge.w	.F7166
	addq.w	#1,(word_FFBF56).w
.F7166
	movem.l	(sp)+,d0/a0
	movea.l	#HmShots,a1
	rts
sub_F7172	;94 only. The same for the away team ($FFBF5C, word_FFBF54), a1 = AwShots. Called from sub_17730
	movem.l	d0/a0,-(sp)
	movea.l	#$FFFFBF5C,a0
	move.w	(word_FFBF54).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(word_FFBF54).w
	bge.w	.F7194
	addq.w	#1,(word_FFBF54).w
.F7194
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts
	rts	;IDA dc.b, no xref
sub_F71A2	;94 only. Build the hot / cold player lists of both teams (sub_F71F0, sub_F72DA, sub_F72FA). Called from ScoutingReport
	clr.w	(word_FFBF54).w
	clr.w	(word_FFBF56).w
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	bsr.w	sub_F71F0
	movea.l	#$FFFFBF5E,a0
	bsr.w	sub_F72DA
	movea.l	#$FFFFBF62,a0
	bsr.w	sub_F72FA
	movea.l	#AwShots,a0
	bsr.w	sub_F71F0
	movea.l	#$FFFFBF5C,a0
	bsr.w	sub_F72DA
	movea.l	#$FFFFBF60,a0
	bsr.w	sub_F72FA
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F71F0	;94 only. Sum the hot / cold values of the 6 starters of team a0 into $FFBF20 (byte pairs: player, sum), then sort them by sum
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A2,a2
	movea.l	$1E(a0),a0
	adda.w	6(a0),a0
	movea.l	#$FFFFBF20,a1
	move.w	#5,d0
.F720E
	move.b	(a0)+,d1
	subq.b	#1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#4,d1
	clr.b	(a1)
	addq.w	#3,d1
	move.w	#3,d7
.F7220
	clr.w	d2
	move.b	0(a2,d1.w),d2
	cmp.b	#9,d7
	beq.w	.F7238
	cmp.b	#$D,d7
	beq.w	.F7238
	add.b	d2,(a1)
.F7238
	addq.w	#1,d1
	addq.w	#1,d7
	cmp.b	#$10,d7
	bne.s	.F7220
	tst.b	(a1)+
	dbf	d0,.F720E
.F7248
	movea.l	#$FFFFBF20,a1
	clr.w	d1
	move.w	#4,d0
.F7254
	move.b	3(a1),d6
	cmp.b	1(a1),d6
	ble.w	.F726C
	st	d1
	move.w	2(a1),d2
	move.w	(a1),2(a1)
	move.w	d2,(a1)
.F726C
	tst.w	(a1)+
	dbf	d0,.F7254
	tst.w	d1
	bne.s	.F7248
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F727C	;94 only. d1 = the next home cold player (word_FFBF5A, $FFBF62), a1 = HmShots. Called from sub_17730
	movem.l	d0/a0,-(sp)
	movea.l	#$FFFFBF62,a0
	move.w	(word_FFBF5A).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(word_FFBF5A).w
	bge.w	.F729E
	addq.w	#1,(word_FFBF5A).w
.F729E
	movem.l	(sp)+,d0/a0
	movea.l	#HmShots,a1
	rts
sub_F72AA	;94 only. The same for the away team (word_FFBF58, $FFBF60), a1 = AwShots. Called from sub_17730
	movem.l	d0/a0,-(sp)
	movea.l	#$FFFFBF60,a0
	move.w	(word_FFBF58).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(word_FFBF58).w
	bge.w	.F72CC
	addq.w	#1,(word_FFBF58).w
.F72CC
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts
	rts	;IDA dc.b, no xref
sub_F72DA	;94 only. Copy the hottest player of $FFBF20 to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#$FFFFBF20,a1
	move.w	#0,d0
.F72E8
	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbf	d0,.F72E8
	movem.l	(sp)+,d0-d1/a0-a1
	rts
sub_F72FA	;94 only. Copy the coldest player ($FFBF2A) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$FFFFBF2A,a1
	move.w	#0,d0
.F7308
	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbf	d0,.F7308
	movem.l	(sp)+,d0/a0-a1
	rts
sub_F7318	;94 only. Compare the teams' hot / cold totals (sub_F737E into word_FFBF12 / word_FFBF14): word_FFBF50 = 1 when the away total is
	;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text "Lately ... has been playing (extremely) well")
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	bsr.w	sub_F737E
	move.w	d1,(word_FFBF12).w
	movea.l	#AwShots,a0
	bsr.w	sub_F737E
	move.w	d1,(word_FFBF14).w
	move.w	(word_FFBF12).w,d1
	move.w	(word_FFBF14).w,d2
	sub.w	d1,d2
	move.w	#0,(word_FFBF50).w
	tst.w	d2
	bmi.w	.F7354
	move.w	#1,(word_FFBF50).w
.F7354
	tst.w	d2
	bpl.w	.F735C
	neg.w	d2
.F735C
	move.w	#$FFFF,d0
	cmp.w	#$5E,d2
	blt.w	.F7378
	move.w	#$22,d0
	cmp.w	#$BD,d2
	blt.w	.F7378
	move.w	#$23,d0
.F7378
	movem.l	(sp)+,d1-d7/a0-a6
	rts
sub_F737E	;94 only. d1 = the hot / cold total of the starters of team a0 (sub_F71F0)
	bsr.w	sub_F71F0
	move.w	#6,d0
	movea.l	#$FFFFBF20,a0
	clr.w	d1
.F738E
	move.b	1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbf	d0,.F738E
	rts
