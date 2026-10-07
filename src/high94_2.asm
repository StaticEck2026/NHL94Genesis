;	NHL 94 (retail) segment $F8B5A-$FCB99
;	94 code in the high ROM, between hockey94_08 and hockey94_07: wallcollduringcheck, setSlotBit, the team palettes (unk_F8BF4) and
;	featured player pictures (unk_F92F4), the save RAM records (team, player, crowd and user records), the Player Cards screens and
;	CalcAttrib, the user record NAME ENTRY screen, Record Holders, the playoff round screen (loc_FC320) and the shootout (shooters
;	menu, next shooter, "SHOOTOUT WON BY"). 94 only; 93 has no code here.
;	Transcribed from lst/nhl94.bin.lst lines 963039-969431. Global names are the IDA names (no 93 counterparts); the entries IDA has no
;	label for that other segments use are IDA-style (sub_FA07E, sub_FBC14, sub_FC620, unk_F92F4, unk_FA9D2). Locals are the IDA
;	address or IDA _x name. IDA gaps written from the retail bytes: the inline Strings after the print calls and the remap tables (IDA
;	code), the code IDA hid behind them (;IDA hid this), and the palettes / picture lists IDA read as code ($F8BF4-$F98C5). The IDA
;	labels inside Strings are not labels.

wallcollduringcheck	;IDA name (and comments). 94 only: during a check, a skater a2 (not a goalie) near the wall: test the wall at his position
	;with his size + $17 (checkwallcoll, high94_1). Called from CCStart (hockey94_03)
	tst.w	$34(a2)	;check if goalie
	beq.w	.end
	movem.l	d0-d7,-(sp)
	move.w	(a2),d2	;Xpos of checking player
	move.w	$14(a2),d3	;Ypos of checking player
	move.w	$4A(a2),(wcradiusx).w	;moves radiusX into FFBD22 (width of graphic)
	addi.w	#$17,(wcradiusx).l	;add $17 to BD22
	move.w	$4C(a2),(wcradiusy).w	;moves radiusY into FFBD24 (height of graphic)
	addi.w	#$17,(wcradiusy).l	;add $17 to BD24
	movem.l	a0-a6,-(sp)
	exg	a2,a3	;swap a2 and a3
	jsr	(checkwallcoll).l
	exg	a2,a3	;swap a2 and a3
	movem.l	(sp)+,a0-a6
	movem.l	(sp)+,d0-d7
.end
	rts
setSlotBit	;IDA name (and comments). 94 only: word_FFC2F8 bit 5 (the slot) = the puck carrier is in the slot in front of the goal. Called from DoGameFrame (hockey94_01)
	bclr	#5,(word_FFC2F8).w	;clears Slot Bit
	tst.w	(puckc).w
	bmi.w	.ex	;exit if no puckc
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0	;start of SCStructs
	move.w	(puckc).w,d0	;move puckc SCnum into d0
	asl.w	#7,d0	;mult by 128 decimal
	adda.w	d0,a0	;move to start of puckc SCstruct
	move.w	$14(a0),d0	;Ypos
	btst	#7,$62(a0)	;pfgoal - which goal shooting at
	bne.w	.checkpos	;jump if top goal
	neg.w	d0	;negative d0
.checkpos
	cmp.w	#$58,d0	;'X'   ; compare to blueline
	blt.w	.restore	;branch if not in off zone
	cmpi.w	#$47,(a0)	;'G' ; compare X position to $47
	bgt.w	.restore	;branch if greater than 47
	cmpi.w	#$FFB9,(a0)	;compare X position to -$47
	blt.w	.restore	;branch if less than -47
	bset	#5,(word_FFC2F8).w	;set bit
.restore
	movem.l	(sp)+,d0/a0
.ex
	rts
unk_F8BF4	;IDA name. Team palettes: 56 of 16 colors (two per team, 28 teams). Used by attract94 sub_17AF4 and the player cards
	dc.w	$EEA,$0,$42,$EEA,$EEA,$EEE,$0,$888,$AAA,$68,$8A,$CE,$260,$40,$664,$E8E
	dc.w	$EEA,$EEA,$EEA,$0,$42,$EEE,$0,$888,$AAA,$68,$8A,$CE,$260,$40,$664,$E8E
	dc.w	$EE8,$0,$8C,$EE8,$EE8,$EEE,$0,$C8C,$8C,$888,$68,$846,$44,$422,$8CE,$2AE
	dc.w	$EE8,$EE8,$EE8,$0,$8C,$EEE,$0,$C8C,$8C,$888,$68,$846,$44,$422,$8CE,$2AE
	dc.w	$EE8,$822,$8C,$EE8,$EE8,$EEE,$0,$EC8,$48C,$C88,$6C,$866,$268,$224,$620,$CE
	dc.w	$EE8,$EE8,$EE8,$822,$8C,$EEE,$0,$EC8,$48C,$C88,$6C,$866,$268,$224,$620,$CE
	dc.w	$EE8,$6,$8C,$EE8,$EE8,$EEE,$0,$8EE,$2CE,$2AE,$26E,$C,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$6,$8C,$EEE,$0,$8EE,$2CE,$2AE,$26E,$C,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$0,$6,$EE8,$EE8,$EEE,$0,$8EE,$A8E,$4AC,$A88,$46C,$226,$644,$22E,$262
	dc.w	$EE8,$EE8,$EE8,$0,$6,$EEE,$0,$8EE,$A8E,$4AC,$A88,$46C,$226,$644,$22E,$262
	dc.w	$EE8,$0,$42,$EE8,$EE8,$EEE,$0,$8AA,$688,$488,$466,$244,$260,$20,$ACC,$0
	dc.w	$EE8,$EE8,$EE8,$0,$42,$EEE,$0,$8AA,$688,$488,$466,$244,$260,$20,$ACC,$0
	dc.w	$EE8,$6,$6,$EE8,$EE8,$EEE,$0,$C8E,$86E,$44E,$82E,$20E,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$6,$6,$EEE,$0,$C8E,$86E,$44E,$82E,$20E,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,$4A,$EE8,$EE8,$EEE,$0,$CEA,$A8E,$8A8,$44E,$488,$2E,$440,$400,$EE8
	dc.w	$EE8,$EE8,$EE8,$600,$4A,$EEE,$0,$CEA,$A8E,$8A8,$44E,$488,$2E,$440,$400,$EE8
	dc.w	$EEA,$4A,$600,$EEA,$EEA,$EEE,$0,$A,$4,$46,$8E,$CEE,$466,$442,$EC6,$200
	dc.w	$EEA,$EEA,$EEA,$4A,$600,$EEE,$0,$A,$4,$46,$8E,$CEE,$466,$442,$EC6,$200
	dc.w	$EE8,$42,$822,$EE8,$EE8,$EEE,$0,$E8,$4C4,$A8A,$A2,$466,$600,$224,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$42,$822,$EEE,$0,$E8,$4C4,$A8A,$A2,$466,$600,$224,$EE8,$EE8
	dc.w	$EE8,$0,$0,$EE8,$EE8,$EEE,$0,$AAA,$888,$666,$444,$222,$CCC,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$0,$0,$EEE,$0,$AAA,$888,$666,$444,$222,$CCC,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,$6,$EE8,$EE8,$EEE,$0,$88E,$26E,$C68,$2E,$A24,$EAA,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$600,$6,$EEE,$0,$88E,$26E,$C68,$2E,$A24,$EAA,$EE8,$EE8,$EE8
	dc.w	$EE8,$20,$6,$EE8,$EE8,$EEE,$0,$AAA,$A,$888,$C,$22,$6,$CCC,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$20,$6,$EEE,$0,$AAA,$A,$888,$C,$22,$6,$CCC,$EE8,$EE8
	dc.w	$EE8,$822,$4A,$EE8,$EE8,$EEE,$0,$AA8,$66E,$864,$22C,$62A,$8,$622,$222,$A8E
	dc.w	$EE8,$EE8,$EE8,$822,$4A,$EEE,$0,$AA8,$66E,$864,$22C,$62A,$8,$622,$222,$A8E
	dc.w	$EE8,$600,$6,$EE8,$EE8,$EEE,$0,$AAA,$C86,$2E,$C60,$844,$444,$840,$8,$EC8
	dc.w	$EE8,$EE8,$EE8,$600,$6,$EEE,$0,$AAA,$C86,$2E,$C60,$844,$444,$840,$8,$EC8
	dc.w	$EE8,$6,$6A,$EE8,$EE8,$EEE,$0,$68A,$688,$466,$244,$22C,$228,$8,$AAA,$4
	dc.w	$EE8,$EE8,$EE8,$6,$6A,$EEE,$0,$68A,$688,$466,$244,$22C,$228,$8,$AAA,$4
	dc.w	$EE8,$0,$4A,$EE8,$EE8,$EEE,$0,$CCC,$88E,$AAA,$46E,$6E,$888,$666,$2E,$444
	dc.w	$EE8,$EE8,$EE8,$0,$4A,$EEE,$0,$CCC,$88E,$AAA,$46E,$6E,$888,$666,$2E,$444
	dc.w	$EE8,$0,$8C,$EE8,$EE8,$EEE,$0,$AAA,$88A,$66A,$4EE,$464,$440,$2CE,$244,$AEE
	dc.w	$EE8,$EE8,$EE8,$0,$8C,$EEE,$0,$AAA,$88A,$66A,$4EE,$464,$440,$2CE,$244,$AEE
	dc.w	$EE8,$600,$6,$EE8,$EE8,$EEE,$0,$C00,$E,$E44,$ECE,$E80,$88E,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$600,$6,$EEE,$0,$C00,$E,$E44,$ECE,$E80,$88E,$EE8,$EE8,$EE8
	dc.w	$EE8,$0,$860,$EE8,$EE8,$EEE,$0,$860,$642,$888,$CA8,$ACC,$2AE,$6E,$48,$46A
	dc.w	$EE8,$EE8,$EE8,$0,$860,$EEE,$0,$860,$642,$888,$CA8,$ACC,$2AE,$6E,$48,$46A
	dc.w	$EE8,$822,$6A,$EE8,$EE8,$EEE,$0,$602,$24C,$2,$26,$68,$428,$86E,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$822,$6A,$EEE,$0,$602,$24C,$2,$26,$68,$428,$86E,$EE8,$EE8
	dc.w	$EE8,$0,$600,$EE8,$EE8,$EEE,$0,$C86,$E84,$A84,$C44,$822,$E20,$600,$A00,$EA8
	dc.w	$EE8,$EE8,$EE8,$0,$600,$EEE,$0,$C86,$E84,$A84,$C44,$822,$E20,$600,$A00,$EA8
	dc.w	$EE8,$600,$600,$EE8,$EE8,$EEE,$0,$ECA,$AAA,$C66,$822,$CCC,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$600,$600,$EEE,$0,$ECA,$AAA,$C66,$822,$CCC,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$0,$8C,$EE8,$EE8,$EEE,$0,$CE,$6A,$4E,$28,$22,$20,$8E,$888,$6CE
	dc.w	$EE8,$EE8,$EE8,$0,$8C,$EEE,$0,$CE,$6A,$4E,$28,$22,$20,$8E,$888,$6CE
	dc.w	$EE8,$6,$600,$EE8,$EE8,$EEE,$0,$22C,$C86,$EA8,$88E,$842,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$EE8,$EE8,$6,$600,$EEE,$0,$22C,$C86,$EA8,$88E,$842,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,$6,$EE8,$EE8,$EEE,$0,$22C,$422,$AAC,$666,$CAA,$444,$66E,$8CE,$226
	dc.w	$EE8,$EE8,$EE8,$600,$6,$EEE,$0,$22C,$422,$AAC,$666,$CAA,$444,$66E,$8CE,$226
	dc.w	$EE8,$0,$4A,$EE8,$EE8,$EEE,$0,$688,$464,$244,$222,$4E,$A,$22,$AAA,$0
	dc.w	$EE8,$EE8,$EE8,$0,$4A,$EEE,$0,$688,$464,$244,$222,$4E,$A,$22,$AAA,$0
	dc.w	$EE8,$0,$4A,$EE8,$EE8,$EEE,$0,$688,$464,$244,$222,$4E,$A,$22,$AAA,$0
	dc.w	$EE8,$EE8,$EE8,$0,$4A,$EEE,$0,$688,$464,$244,$222,$4E,$A,$22,$AAA,$0
unk_F92F4	;no IDA label (IDA loc_F92F0 is 4 bytes before, inside the palettes; hockey94_08 loads #(loc_F92F0+4)). The featured player pictures
	;of each team (TeamList order): a list of picture.l (graphics94 unk_C63F8 ... unk_C726C) and roster index.w, 0 ends
	dc.l	.F938C,.F93B4,.F93E2,.F940A
	dc.l	.F9432,.F945A,.F9482,.F94AA
	dc.l	.F9364,.F94D2,.F94FA,.F9528
	dc.l	.F9550,.F9578,.F95A0,.F95C8
	dc.l	.F95F0,.F9618,.F964C,.F9674
	dc.l	.F969C,.F96C4,.F96EC,.F9714
	dc.l	.F973C,.F976A,.F9792,.F982C
.F9364
	dc.l	$C726C
	dc.w	0
	dc.l	$C6B98
	dc.w	13
	dc.l	$C6B98
	dc.w	11
	dc.l	$C682E
	dc.w	7
	dc.l	$C682E
	dc.w	4
	dc.l	$C6B98
	dc.w	3
	dc.l	0
.F938C
	dc.l	$C726C
	dc.w	0
	dc.l	$C682E
	dc.w	11
	dc.l	$C682E
	dc.w	13
	dc.l	$C682E
	dc.w	3
	dc.l	$C6B98
	dc.w	5
	dc.l	$C682E
	dc.w	7
	dc.l	0
.F93B4
	dc.l	$C75D6
	dc.w	0
	dc.l	$C8014
	dc.w	18
	dc.l	$C7940
	dc.w	17
	dc.l	$C837E
	dc.w	6
	dc.l	$C7CAA
	dc.w	2
	dc.l	$C86E8
	dc.w	11
	dc.l	$C6B98
	dc.w	19
	dc.l	0
.F93E2
	dc.l	$C97FA
	dc.w	0
	dc.l	$C9490
	dc.w	17
	dc.l	$C9B64
	dc.w	18
	dc.l	$C9126
	dc.w	4
	dc.l	$C8DBC
	dc.w	3
	dc.l	$C8A52
	dc.w	12
	dc.l	0
.F940A
	dc.l	$C9ECE
	dc.w	0
	dc.l	$CA90C
	dc.w	15
	dc.l	$CAC76
	dc.w	16
	dc.l	$CA238
	dc.w	6
	dc.l	$CAFE0
	dc.w	2
	dc.l	$CA5A2
	dc.w	11
	dc.l	0
.F9432
	dc.l	$CB34A
	dc.w	0
	dc.l	$CC0F2
	dc.w	18
	dc.l	$CBD88
	dc.w	17
	dc.l	$CC45C
	dc.w	6
	dc.l	$CB6B4
	dc.w	2
	dc.l	$CBA1E
	dc.w	11
	dc.l	0
.F945A
	dc.l	$D2FEE
	dc.w	0
	dc.l	$D36C2
	dc.w	16
	dc.l	$D3A2C
	dc.w	17
	dc.l	$D3D96
	dc.w	3
	dc.l	$D3358
	dc.w	2
	dc.l	$D4100
	dc.w	10
	dc.l	0
.F9482
	dc.l	$CC7C6
	dc.w	0
	dc.l	$CD56E
	dc.w	18
	dc.l	$CD204
	dc.w	17
	dc.l	$CCE9A
	dc.w	3
	dc.l	$CCB30
	dc.w	2
	dc.l	$CD8D8
	dc.w	12
	dc.l	0
.F94AA
	dc.l	$CDC42
	dc.w	0
	dc.l	$CDFAC
	dc.w	17
	dc.l	$CE316
	dc.w	18
	dc.l	$CE680
	dc.w	8
	dc.l	$CE9EA
	dc.w	2
	dc.l	$CEDF0
	dc.w	14
	dc.l	0
.F94D2
	dc.l	$CF15A
	dc.w	0
	dc.l	$CFF02
	dc.w	18
	dc.l	$D026C
	dc.w	19
	dc.l	$CF82E
	dc.w	8
	dc.l	$CF4C4
	dc.w	3
	dc.l	$CFB98
	dc.w	13
	dc.l	0
.F94FA
	dc.l	$D1AEE
	dc.w	0
	dc.l	$D291A
	dc.w	16
	dc.l	$D2C84
	dc.w	17
	dc.l	$D2246
	dc.w	7
	dc.l	$D1EDC
	dc.w	3
	dc.l	$D25B0
	dc.w	12
	dc.l	$C6B98
	dc.w	13
	dc.l	0
.F9528
	dc.l	$D446A
	dc.w	0
	dc.l	$D4B3E
	dc.w	17
	dc.l	$D47D4
	dc.w	16
	dc.l	$D527E
	dc.w	6
	dc.l	$D4F14
	dc.w	2
	dc.l	$D55E8
	dc.w	11
	dc.l	0
.F9550
	dc.l	$D5CBC
	dc.w	0
	dc.l	$D6026
	dc.w	18
	dc.l	$D5952
	dc.w	17
	dc.l	$D6390
	dc.w	11
	dc.l	$D66FA
	dc.w	2
	dc.l	$D6A64
	dc.w	12
	dc.l	0
.F9578
	dc.l	$D1014
	dc.w	0
	dc.l	$D137E
	dc.w	18
	dc.l	$D16E8
	dc.w	17
	dc.l	$D0940
	dc.w	8
	dc.l	$D0CAA
	dc.w	2
	dc.l	$D05D6
	dc.w	3
	dc.l	0
.F95A0
	dc.l	$D6DCE
	dc.w	0
	dc.l	$D750E
	dc.w	18
	dc.l	$D7BE2
	dc.w	17
	dc.l	$D7F4C
	dc.w	6
	dc.l	$D71A4
	dc.w	2
	dc.l	$D7878
	dc.w	11
	dc.l	0
.F95C8
	dc.l	$D82B6
	dc.w	0
	dc.l	$D8D60
	dc.w	19
	dc.l	$D89F6
	dc.w	18
	dc.l	$D868C
	dc.w	9
	dc.l	$D90CA
	dc.w	2
	dc.l	$D9434
	dc.w	14
	dc.l	0
.F95F0
	dc.l	$DA546
	dc.w	0
	dc.l	$DA8B0
	dc.w	18
	dc.l	$D9E72
	dc.w	17
	dc.l	$D9B08
	dc.w	4
	dc.l	$D979E
	dc.w	3
	dc.l	$DA1DC
	dc.w	14
	dc.l	0
.F9618
	dc.l	$DAC1A
	dc.w	0
	dc.l	$DB9C2
	dc.w	16
	dc.l	$DBD2C
	dc.w	17
	dc.l	$DB2EE
	dc.w	6
	dc.l	$DAF84
	dc.w	2
	dc.l	$DB658
	dc.w	10
	dc.l	$C6B98
	dc.w	11
	dc.l	$C6F02
	dc.w	1
	dc.l	0
.F964C
	dc.l	$DC096
	dc.w	0
	dc.l	$DCEAA
	dc.w	18
	dc.l	$DC7D6
	dc.w	17
	dc.l	$DCB40
	dc.w	2
	dc.l	$DD214
	dc.w	13
	dc.l	$DC46C
	dc.w	14
	dc.l	0
.F9674
	dc.l	$DDFBC
	dc.w	0
	dc.l	$DE326
	dc.w	17
	dc.l	$DD8E8
	dc.w	16
	dc.l	$DE690
	dc.w	9
	dc.l	$DD57E
	dc.w	3
	dc.l	$DDC52
	dc.w	13
	dc.l	0
.F969C
	dc.l	$DE9FA
	dc.w	0
	dc.l	$DF7A2
	dc.w	16
	dc.l	$DF438
	dc.w	17
	dc.l	$DFB0C
	dc.w	11
	dc.l	$DED64
	dc.w	2
	dc.l	$DF0CE
	dc.w	12
	dc.l	0
.F96C4
	dc.l	$E01E0
	dc.w	0
	dc.l	$E054A
	dc.w	19
	dc.l	$E08B4
	dc.w	18
	dc.l	$E0C1E
	dc.w	11
	dc.l	$DFE76
	dc.w	3
	dc.l	$E0F88
	dc.w	4
	dc.l	0
.F96EC
	dc.l	$E12F2
	dc.w	0
	dc.l	$E1D30
	dc.w	18
	dc.l	$E209A
	dc.w	17
	dc.l	$E2404
	dc.w	8
	dc.l	$E165C
	dc.w	3
	dc.l	$E19C6
	dc.w	12
	dc.l	0
.F9714
	dc.l	$E280A
	dc.w	0
	dc.l	$E35B2
	dc.w	18
	dc.l	$E3248
	dc.w	17
	dc.l	$E2B74
	dc.w	6
	dc.l	$E391C
	dc.w	2
	dc.l	$E2EDE
	dc.w	12
	dc.l	0
.F973C
	dc.l	$E3C86
	dc.w	0
	dc.l	$E4D98
	dc.w	17
	dc.l	$E4A2E
	dc.w	16
	dc.l	$E435A
	dc.w	3
	dc.l	$E3FF0
	dc.w	2
	dc.l	$E46C4
	dc.w	11
	dc.l	$C682E
	dc.w	18
	dc.l	0
.F976A
	dc.l	$E5B40
	dc.w	0
	dc.l	$E5EAA
	dc.w	18
	dc.l	$E57D6
	dc.w	17
	dc.l	$E5102
	dc.w	3
	dc.l	$E62C8
	dc.w	2
	dc.l	$E546C
	dc.w	12
	dc.l	0
.F9792
	dc.l	$D446A
	dc.w	0
	dc.l	$C7940
	dc.w	18
	dc.l	$DB9C2
	dc.w	17
	dc.l	$C7CAA
	dc.w	6
	dc.l	$DAF84
	dc.w	3
	dc.l	$C8A52
	dc.w	15
	dc.l	$C97FA
	dc.w	1
	dc.l	$DAC1A
	dc.w	2
	dc.l	$D71A4
	dc.w	4
	dc.l	$D4F14
	dc.w	5
	dc.l	$DCB40
	dc.w	7
	dc.l	$D0CAA
	dc.w	8
	dc.l	$C8DBC
	dc.w	9
	dc.l	$DB2EE
	dc.w	10
	dc.l	$DB658
	dc.w	11
	dc.l	$E46C4
	dc.w	12
	dc.l	$D7878
	dc.w	13
	dc.l	$C6B98
	dc.w	14
	dc.l	$DA1DC
	dc.w	16
	dc.l	$D7BE2
	dc.w	19
	dc.l	$DC7D6
	dc.w	20
	dc.l	$E4D98
	dc.w	21
	dc.l	$D5952
	dc.w	22
	dc.l	$CFF02
	dc.w	23
	dc.l	$C6B98
	dc.w	24
	dc.l	0
.F982C
	dc.l	$CB34A
	dc.w	0
	dc.l	$CD204
	dc.w	19
	dc.l	$E57D6
	dc.w	21
	dc.l	$D2246
	dc.w	10
	dc.l	$CCB30
	dc.w	3
	dc.l	$E546C
	dc.w	14
	dc.l	$CC7C6
	dc.w	1
	dc.l	$E12F2
	dc.w	2
	dc.l	$D3358
	dc.w	4
	dc.l	$CB6B4
	dc.w	5
	dc.l	$DFE76
	dc.w	6
	dc.l	$E165C
	dc.w	7
	dc.l	$D1EDC
	dc.w	8
	dc.l	$CA238
	dc.w	9
	dc.l	$CA5A2
	dc.w	11
	dc.l	$DF0CE
	dc.w	12
	dc.l	$E2EDE
	dc.w	13
	dc.l	$DDC52
	dc.w	15
	dc.l	$C6B98
	dc.w	16
	dc.l	$CA90C
	dc.w	17
	dc.l	$DF7A2
	dc.w	18
	dc.l	$CBD88
	dc.w	20
	dc.l	$CDFAC
	dc.w	22
	dc.l	$CC0F2
	dc.w	23
	dc.l	$CD56E
	dc.w	24
	dc.l	0
sub_F98C6	;94 only. Player card stat line (hockey94_08 sub_F8868): print the label at a1 (appstring) and the value from the save RAM records
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#unk_F9950,a1
	movem.l	d0-d1,-(sp)
	bsr.w	sub_F997A
	movem.l	(sp)+,d0-d1
	bsr.w	sub_F99F2
	tst.w	d0
	bne.w	.F98F4
	movea.l	(sp)+,a1
	move.w	#2,(a1)
	bra.w	.F994A
.F98F4
	movea.l	#$FFFFBF20,a1
	move.w	d0,(word_FFBF14).w
	bsr.w	sub_F998E
	movea.l	(sp),a3
	movea.l	#$FFFFBF20,a1
	jsr	(appstring).l
	move.w	(word_FFBF14).w,d0
	movea.l	#unk_F996A,a1
	cmp.w	#1,d0
	bne.w	.F9928
	movea.l	#unk_F9972,a1
.F9928
	tst.w	d1
	bne.w	.F9942
	movea.l	#unk_F995A,a1
	cmp.w	#1,d0
	bne.w	.F9942
	movea.l	#unk_F9962,a1
.F9942
	movea.l	(sp)+,a3
	jsr	(appstring).l
.F994A
	movem.l	(sp)+,d0-d7/a1-a6
	rts
unk_F9950	dc.b	0	;IDA name. sub_F98C6 text
	dc.b	$A
	dc.b	$52	;R
	dc.b	$65	;e
	dc.b	$63	;c
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$64	;d
	dc.b	$20,0
unk_F995A	dc.b	0	;IDA name. sub_F98C6 text
	dc.b	8,$20
	dc.b	$67	;g
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$73	;s
unk_F9962	dc.b	0	;IDA name. sub_F98C6 text
	dc.b	8,$20
	dc.b	$67	;g
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	0
unk_F996A	dc.b	0	;IDA name. sub_F98C6 text
	dc.b	8,$20
	dc.b	$73	;s
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$73	;s
unk_F9972	dc.b	0	;IDA name. sub_F98C6 text
	dc.b	8,$20
	dc.b	$73	;s
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	0
sub_F997A	;94 only. Start the text at a1 in mesarea (appstring)
	movem.l	d0,-(sp)
	move.w	(a1),d0
	subq.w	#1,d0
.F9982
	move.b	(a1)+,(a3)+
	dbf	d0,.F9982
	movem.l	(sp)+,d0
	rts
sub_F998E	;94 only. Append the number d0 to mesarea
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)
	move.w	d0,d6
	addq.l	#2,a1
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0
	tst.w	d0
	beq.w	.F99AE
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addq.w	#1,d1
.F99AE
	swap	d0
	ext.l	d0
	divu.w	#$A,d0
	addi.w	#$30,d0
	cmp.b	#$30,d0
	bne.w	.F99CA
	cmp.w	#$A,d6
	blt.w	.F99CE
.F99CA
	move.b	d0,(a1)+
	addq.w	#1,d1
.F99CE
	swap	d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addq.w	#1,d1
	btst	#0,d1
	beq.w	.F99E6
	move.b	#0,(a1)+
	addq.w	#1,d1
.F99E6
	movea.l	(sp)+,a0
	addq.w	#2,d1
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
sub_F99F2	;94 only. The record value of the player card (sub_F9B94)
	movem.l	d2-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	movea.l	#$30E,a2
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2
	adda.w	(a2),a2
	move.w	d1,d0
	bra.w	.F9A10
.F9A0C
	adda.w	(a2),a2
	addq.w	#8,a2
.F9A10
	dbf	d0,.F9A0C
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	movea.l	#$FFFF0000,a0
	bsr.w	sub_F9B94
	move.b	(a0),d0
	ext.w	d0
	movea.l	#$30E,a5
	asl.w	#2,d4
	movea.l	0(a5,d4.w),a5
	adda.w	$A(a5),a5
	move.w	(a5),d1
	movem.w	d0,-(sp)
	clr.w	d0
.F9A44
	addq.w	#1,d0
	asl.w	#4,d1
	bne.s	.F9A44
	cmp.w	d5,d0
	movem.w	(sp)+,d0
	bgt.w	.F9A5A
	clr.w	d1
	bra.w	.F9A5E
.F9A5A
	move.w	#1,d1
.F9A5E
	movem.l	(sp)+,d2-d7/a0-a6
	rts
sub_F9A64	;94 only. Player card line (hockey94_08 sub_F8868)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#unk_F9AA6,a1
	movem.l	d0-d1,-(sp)
	bsr.w	sub_F997A
	movem.l	(sp)+,d0-d1
	movea.l	#$FFFFBF20,a1
	bsr.w	sub_F9AE4
	movea.l	(sp)+,a3
	cmpi.w	#2,(a1)
	bne.w	.F9A9A
	move.w	#2,(a3)
	bra.w	.F9AA0
.F9A9A
	jsr	(appstring).l
.F9AA0
	movem.l	(sp)+,d0-d7/a1-a6
	rts
unk_F9AA6	dc.b	0	;IDA name. sub_F9A64 text
	dc.b	6
	dc.b	$62	;b
	dc.b	$79	;y
	dc.b	$20,0
sub_F9AAC	;94 only. Player card line (hockey94_08 sub_F8868)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#unk_F9ADE,a1
	movem.l	d0-d1,-(sp)
	bsr.w	sub_F997A
	movem.l	(sp)+,d0-d1
	movea.l	#$FFFFBF20,a1
	bsr.w	sub_F9B2A
	movea.l	(sp)+,a3
	jsr	(appstring).l
	movem.l	(sp)+,d0-d7/a1-a6
	rts
unk_F9ADE	dc.b	0	;IDA name. sub_F9AAC text
	dc.b	6
	dc.b	$76	;v
	dc.b	$73	;s
	dc.b	$2E	;.
	dc.b	$20
sub_F9AE4	;94 only. Part of sub_F9A64
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#0,a0
	bne.w	.F9B14
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)
	move.w	d1,d0
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$FFFF0000,a0
	bsr.w	sub_F9B94
	movea.l	#$FFFF0000,a0
	movem.l	(sp)+,d0-d7/a1-a6
.F9B14
	move.b	1(a0),d2
	ext.w	d2
	bset	#7,(word_FFC2F8).w
	bsr.w	sub_FA014
	movem.l	(sp)+,d0-d7/a1-a2
	rts
sub_F9B2A	;94 only. Part of sub_F9AAC
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#0,a0
	bne.w	.F9B5A
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)
	move.w	d1,d0
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$FFFF0000,a0
	bsr.w	sub_F9B94
	movea.l	#$FFFF0000,a0
	movem.l	(sp)+,d0-d7/a1-a6
.F9B5A
	move.b	3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset	#7,(word_FFC2F8).w
	bsr.w	sub_FA014
	movea.l	a1,a3
	movea.l	#unk_F9B90,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a1
	move.b	2(a0),d0
	jsr	(sub_FA880).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_F9B90	dc.b	0	;IDA name. sub_F9B2A text
	dc.b	4,$20,0
sub_F9B94	;94 only. Read a record value (unk_F9CA4)
	bclr	#6,(word_FFC2F8).w
loc_F9B9A	;IDA label. Read (word_FFC2F8 bit 6 clear) or write a save RAM record block (ReadSRAM / WriteSRAM). Entered from sub_F9BDA
	movem.l	d0-d1/a0-a1,-(sp)
	asl.l	#2,d0
	addi.l	#0,d0
	movea.l	#unk_F9CA4,a1
	add.w	d1,d1
	move.w	0(a1,d1.w),d1
	asl.w	#2,d1
	ext.l	d1
	add.l	d1,d0
	moveq	#4,d1
	btst	#6,(word_FFC2F8).w
	beq.w	.F9BCE
	jsr	(WriteSRAM).l
	bra.w	.F9BD4
.F9BCE
	jsr	(ReadSRAM).l
.F9BD4
	movem.l	(sp)+,d0-d1/a0-a1
	rts
sub_F9BDA	;94 only. Write the block of loc_F9B9A
	bset	#6,(word_FFC2F8).w
	bra.s	loc_F9B9A
clrCrowdRAM	;IDA name (clrCrowdRAM?). 94 only: read the 16 byte crowd record block of team d1 from save RAM ($B60 + team * 16) to a0. Called from
	;LoadCrowdRec (high94_1) and DisplayGameStats (stats94)
	bclr	#6,(word_FFC2F8).w
loc_F9BE8	;IDA label. The crowd record block: read or write (word_FFC2F8 bit 6). Entered from clrCrowdRAM and sub_F9C18
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0
	addi.l	#$B60,d0
	moveq	#$10,d1
	btst	#6,(word_FFC2F8).w
	beq.w	.F9C0C
	jsr	(WriteSRAM).l
	bra.w	.F9C12
.F9C0C
	jsr	(ReadSRAM).l
.F9C12
	movem.l	(sp)+,d0-d1/a0-a1
	rts
sub_F9C18	;94 only. Write the crowd record block of team d1
	bset	#6,(word_FFC2F8).w
	bra.s	loc_F9BE8
sub_F9C20	;94 only. Read a save RAM record block (loc_F9C26)
	bclr	#6,(word_FFC2F8).w
loc_F9C26	;IDA label. A save RAM record block: read or write (word_FFC2F8 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0
	addi.l	#$D20,d0
	moveq	#$10,d1
	btst	#6,(word_FFC2F8).w
	beq.w	.F9C4A
	jsr	(WriteSRAM).l
	bra.w	.F9C50
.F9C4A
	jsr	(ReadSRAM).l
.F9C50
	movem.l	(sp)+,d0-d1/a0-a1
	rts
sub_F9C56	;94 only. Write the block of loc_F9C26
	bset	#6,(word_FFC2F8).w
	bra.s	loc_F9C26
sub_F9C5E	;94 only. Write a user record block (loc_F9C6E)
	bset	#6,(word_FFC2F8).w
	bra.w	loc_F9C6E
sub_F9C68	;94 only. Read a user record block (loc_F9C6E). Called from GameSetUp (hockey94_08)
	bclr	#6,(word_FFC2F8).w
loc_F9C6E	;IDA label. A user record block: read or write (word_FFC2F8 bit 6)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#$80,d1
	move.l	#$DA0,d0
	movea.l	#$FFFFD45A,a0
	btst	#6,(word_FFC2F8).w
	beq.w	.F9C98
	jsr	(WriteSRAM).l
	bra.w	.F9C9E
.F9C98
	jsr	(ReadSRAM).l
.F9C9E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_F9CA4	dc.b	0	;IDA name. Record offsets for sub_F9B94
	dc.b	0,0,$1A,0
	dc.b	$34	;4
	dc.b	0
	dc.b	$4E	;N
	dc.b	0
	dc.b	$68	;h
	dc.b	0,$82,0,$9C,0,$B6,0,$D0,0,$EA,1,4,1,$1E,1
	dc.b	$38	;8
	dc.b	1
	dc.b	$52	;R
	dc.b	1
	dc.b	$6C	;l
	dc.b	1,$86,1,$A0,1,$BA,1,$D4,1,$EE,2,8,2
	dc.b	$22	;"
	dc.b	2
	dc.b	$3C	;<
	dc.b	2
	dc.b	$56	;V
	dc.b	2
	dc.b	$70	;p
	dc.b	2,$8A,2,$A4,2,$BE,2,$D8
sub_F9CDE	;94 only. With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the team and player records after a game (sub_F9DDA,
	;sub_F9EAA, sub_F9F50), then the save RAM checksum (MakeSRAMChecksum). Called from Intermission (penalty94_2)
	tst.w	(ValidSRAM).w
	bmi.w	.F9DD8
	tst.w	(OptUserRec).w
	bne.w	.F9DD8
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_F9FC0
	bsr.w	sub_F9FEA
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#HmShots,a2
	move.w	(word_FFD448).w,d5
	move.w	(VisTeam).w,d6
	bsr.w	sub_F9F50
	move.w	(VisTeam).w,d1
	ext.l	d1
	movea.l	#AwShots,a2
	move.w	(word_FFD44A).w,d5
	move.w	(HomeTeam).w,d6
	bsr.w	sub_F9F50
	clr.w	d7
	movea.l	#HmShots,a1
	move.w	(word_FFD042).w,d4
	move.w	(word_FFD044).w,d5
	move.w	(HomeTeam).w,d1
	move.w	(VisTeam).w,d2
	move.w	(word_FFD448).w,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	sub_F9EAA
	movea.l	#AwShots,a1
	move.w	(word_FFD044).w,d4
	move.w	(word_FFD042).w,d5
	move.w	(VisTeam).w,d1
	move.w	(HomeTeam).w,d2
	move.w	(word_FFD44A).w,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	sub_F9EAA
	movea.l	#ThreeStars,a0
	move.w	(word_FFD042).w,d1
	ext.l	d1
	move.w	(word_FFD044).w,d2
	move.w	(HomeTeam).w,d3
	move.w	(VisTeam).w,d4
	movea.l	#HmShots,a1
	movea.l	#AwShots,a2
	bsr.w	sub_F9DDA
	movea.l	#ThreeStars,a0
	move.w	(word_FFD044).w,d1
	ext.l	d1
	move.w	(word_FFD042).w,d2
	move.w	(VisTeam).w,d3
	move.w	(HomeTeam).w,d4
	movea.l	#AwShots,a1
	movea.l	#HmShots,a2
	bsr.w	sub_F9DDA
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
.F9DD8
	rts
sub_F9DDA	;94 only. Update the record blocks of sub_F9CDE
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_F9C20
	st	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#8,d0
	move.b	$B(a0),d0
	cmp.w	#$2328,d0
	bge.w	.F9E4C
	addq.w	#1,d0
	move.b	d0,$B(a0)
	lsr.w	#8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.F9E34
	blt.w	.F9E4C
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#8,d0
	move.b	$D(a0),d0
	addq.w	#1,d0
	move.b	d0,$D(a0)
	lsr.w	#8,d0
	move.b	d0,$C(a0)
	bra.w	.F9E4C
.F9E34
	clr.w	d0
	move.b	8(a0),d0
	lsl.w	#8,d0
	move.b	9(a0),d0
	addq.w	#1,d0
	move.b	d0,9(a0)
	lsr.w	#8,d0
	move.b	d0,8(a0)
.F9E4C
	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.F9EA0
	move.w	$C(a1),d5
	cmp.b	(a0),d5
	ble.w	.F9E7E
	st	d7
	move.b	d5,(a0)
	move.b	d3,1(a0)
	move.b	d4,2(a0)
	move.b	d2,3(a0)
.F9E7E
	move.w	$C(a2),d5
	move.w	(a2),d6
	sub.w	d5,d6
	cmp.b	4(a0),d6
	ble.w	.F9EA0
	st	d7
	move.b	d6,4(a0)
	move.b	d3,5(a0)
	move.b	d4,6(a0)
	move.b	d2,7(a0)
.F9EA0
	bsr.w	sub_F9C56
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F9EAA	;94 only. Update the crowd records (clrCrowdRAM, sub_F9C18)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	clrCrowdRAM
	move.w	$C(a1),d3
	cmp.b	(a0),d3
	ble.w	.F9ECC
	move.b	d3,(a0)
	move.b	d4,1(a0)
	move.b	d5,3(a0)
	move.b	d2,2(a0)
	st	d7
.F9ECC
	subq.w	#1,d6
	clr.w	d3
.F9ED0
	move.w	d6,d0
	addi.w	#$E8,d0
	move.b	0(a1,d0.w),(word_FFBF12).w
	addi.w	#-$34,d0
	move.b	0(a1,d0.w),d0
	sub.b	d0,(word_FFBF12).w
	cmp.b	(word_FFBF12).w,d3
	bge.w	.F9EF4
	move.b	(word_FFBF12).w,d3
.F9EF4
	dbf	d6,.F9ED0
	cmp.b	4(a0),d3
	ble.w	.F9F12
	st	d7
	move.b	d3,4(a0)
	move.b	d4,5(a0)
	move.b	d5,7(a0)
	move.b	d2,6(a0)
.F9F12
	cmp.w	(HomeTeam).w,d1
	bne.w	.F9F40
	move.b	8(a0),d3
	andi.w	#$FF,d3
	cmp.w	(CrowdPeak).w,d3
	bge.w	.F9F40
	move.w	(CrowdPeak).w,d3
	st	d7
	move.b	d3,8(a0)
	move.b	d4,9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.F9F40
	tst.w	d7
	beq.w	.F9F4A
	bsr.w	sub_F9C18
.F9F4A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F9F50	;94 only. Update the records of sub_F9CDE (sub_F9B94, sub_F9BDA)
	clr.l	d0
	move.w	#$19,d2
.F9F56
	bsr.w	sub_F9B94
	cmp.w	d5,d0
	blt.w	.F9F70
	move.w	d0,-(sp)
	addi.w	#$B4,d0
	move.b	0(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.F9F84
.F9F70
	move.w	d0,-(sp)
	addi.w	#$E8,d0
	move.b	0(a2,d0.w),d4
	addi.w	#-$34,d0
	sub.b	0(a2,d0.w),d4
	move.w	(sp)+,d0
.F9F84
	move.b	(a0),d3
	cmp.b	d3,d4
	ble.w	.F9FB8
	move.b	d4,(a0)
	move.b	(word_FFD042+1).w,1(a0)
	move.b	(word_FFD044+1).w,3(a0)
	cmpa.l	#HmShots,a2
	beq.w	.F9FB0
	move.b	(word_FFD044+1).w,1(a0)
	move.b	(word_FFD042+1).w,3(a0)
.F9FB0
	move.b	d6,2(a0)
	bsr.w	sub_F9BDA
.F9FB8
	addq.w	#1,d0
	dbf	d2,.F9F56
	rts
sub_F9FC0	;94 only. Goalies of team a2 (ReadAttributeNibble). Called from hockey94_10 and sub_FA07E
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a2
	jsr	(ReadAttributeNibble).l
	move.w	d0,(word_FFD448).w
	movea.l	#AwShots,a2
	jsr	(ReadAttributeNibble).l
	move.w	d0,(word_FFD44A).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_F9FEA	;94 only. Players of team a2 (GetPlayerCount)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(word_FFD44C).w
	movea.l	#AwShots,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(word_FFD44E).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FA014	;94 only. Append a record value to mesarea (sub_FAF66)
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2
	tst.w	d2
	beq.w	.FA060
	move.w	#$B,d0
	clr.w	d3
	movea.l	#$FFFFD45A,a0
	mulu.w	#$C,d2
	adda.l	d2,a0
.FA032
	move.b	0(a0,d3.w),d1
	bne.w	.FA03E
	move.b	#$20,d1
.FA03E
	move.b	d1,2(a1)
	tst.b	(a1)+
	addq.w	#1,d3
	dbf	d0,.FA032
	move.w	#$E,(a2)
	btst	#7,(word_FFC2F8).w
	beq.w	.FA05C
	bsr.w	sub_FAF66
.FA05C
	bra.w	.FA076
.FA060
	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#unk_FA07C,a1
	jsr	(sub_F997A).l
	movea.l	(sp)+,a2
	bsr.w	sub_FAF66
.FA076
	movem.l	(sp)+,d0-d3/a0-a3
	rts
unk_FA07C	dc.b	0	;IDA name. sub_FA014 data
	dc.b	2
sub_FA07E	;no IDA label (93 has no counterpart). "Player Cards" menu item (hockey94_11 menu lists), with save RAM only: the player card screens
	;(sub_FA2C0), A / C to page, start exits (ExitAttributeScreen2)
	tst.w	(ValidSRAM).w
	bpl.w	.FA088
	rts
.FA088
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(forceblack).l
	bclr	#0,(disflags).w
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#$8C81,4(a0)
	move.w	#6,(Map3col1).w
	move.w	#$8D00,4(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	bsr.w	sub_F9FC0
	bsr.w	sub_F9FEA
	move.w	(word_FFB012).w,d4
	movea.l	#unk_AAC5A,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$05234167,$89ABCDEF	;remap table (IDA: code)
	jsr	(printz).l
	String	$FD,0,0
	movea.l	#$E6632,a0	;a picture in graphics94 unk_C726C (no IDA label)
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$28,d2	;IDA hid this
	move.w	#$1C,d3
	moveq	#$D,d5
	move.w	#1,d4
	jsr	(dobitmap).l
	move.w	d4,(word_FFD450).w
	addi.w	#$24,d4
	move.w	d4,(word_FFD452).w
	addi.w	#$24,d4
	move.w	d4,-(sp)
	jsr	(printz).l
	String	$FE,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,d4
	jsr	(printz).l
	String	$BE,1,1
	movea.l	#unk_E9A80,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,'!',1
	movea.l	#unk_E9ED6,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	bsr.w	sub_FAFBA
	move.w	#$18,(palcount).w
	clr.w	(word_FFD4F0).w
	clr.w	(word_FFD4F2).w
	tst.w	(FourWayPlay).w
	beq.w	.FA1DA
	cmpi.w	#3,(word_FFC316).w
	beq.w	.FA1EC
	bra.w	.FA1E4
.FA1DA
	btst	#1,(sflags).w
	beq.w	.FA1EC
.FA1E4
	move.w	(cont2team).w,d0
	bra.w	.FA1F0
.FA1EC
	move.w	(cont1team).w,d0
.FA1F0
	subq.w	#1,d0
	bpl.w	.FA1F8
	clr.w	d0
.FA1F8
	andi.w	#1,d0
	movea.l	#word_FFD4F2,a0
	move.w	d0,(word_FFD4F6).w
	bne.w	.FA210
	movea.l	#word_FFD4F0,a0
.FA210
	bsr.w	sub_FA2C0
.FA214
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d3
	bne.w	.FA298
	btst	#6,d1
	beq.w	.FA242
	eori.w	#1,(word_FFD4F6).w
	clr.w	d0
	bra.w	.FA26A
.FA242
	move.w	#1,d0
	btst	#5,d1
	bne.w	.FA26A
	moveq	#1,d0
	jsr	(nodiag).l
	btst	#3,d1
	bne.w	.FA26A
	neg.w	d0
	btst	#2,d1
	bne.w	.FA26A
	bra.s	.FA214
.FA26A
	movea.l	#word_FFD4F0,a0
	move.w	(word_FFD44C).w,(word_FFD4F8).w
	tst.w	(word_FFD4F6).w
	beq.w	.FA28A
	movea.l	#word_FFD4F2,a0
	move.w	(word_FFD44E).w,(word_FFD4F8).w
.FA28A
	add.w	d0,(a0)
	bsr.w	sub_FA2A2
	bsr.w	sub_FA2C0
	bra.w	.FA214
.FA298
	movem.l	(sp)+,d0-d7/a0-a6
	jmp	ExitAttributeScreen2
sub_FA2A2	;94 only. Part of sub_FA07E
	move.w	d0,-(sp)
	move.w	(word_FFD4F8).w,d0
	addq.w	#1,d0
	cmp.w	(a0),d0
	bne.w	.FA2B2
	clr.w	(a0)
.FA2B2
	tst.w	(a0)
	bpl.w	.FA2BC
	subq.w	#1,d0
	move.w	d0,(a0)
.FA2BC
	move.w	(sp)+,d0
	rts
sub_FA2C0	;94 only. Draw a player card: picture (sub_FAEBC), name, "Records" and "This Game" columns (sub_FA550, sub_FA708, sub_FA75C), Overall
	;Rating (sub_FA8AC), Starting Line (loc_FA936), position (loc_FAB4C), goals / assists or saves (sub_FACF0, sub_FAD84)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a0,-(sp)
	move.w	(HomeTeam).w,d0
	tst.w	(word_FFD4F6).w
	beq.w	.FA2D6
	move.w	(VisTeam).w,d0
.FA2D6
	asl.w	#6,d0
	movea.l	#unk_F8BF4,a6
	move.l	$26(a6,d0.w),(dword_FFBD4A).w
	move.w	#$64,(palcount).w
	jsr	(printz).l
	String	$BE,0,7
	move.w	#$28,d0
	move.w	#$15,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	$BE,0,0
	movea.l	(sp),a0	;IDA hid this
	tst.w	(a0)
	bne.w	.FA324
	bsr.w	sub_FA550
	bra.w	.FA328
.FA324
	bsr.w	.FA330
.FA328
	movea.l	(sp)+,a0
	movem.l	(sp)+,d0-d7/a1-a6
	rts
.FA330
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(a0),(word_FFD4F4).w
	bsr.w	sub_FAEBC
	move.w	#$21,d0
	move.w	#8,d1
	jsr	(sub_FA66E).l
	move.w	#$64,(palcount).w
	jsr	(printz).l
	String	$BE,0,0
	move.w	(HomeTeam).w,d0	;IDA hid this
	tst.w	(word_FFD4F6).w	;IDA hid this
	beq.w	.FA36C	;IDA hid this
	move.w	(VisTeam).w,d0
.FA36C
	move.w	d0,(word_FFBF14).w
	movea.l	#$30E,a2
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2
	adda.w	(a2),a2
	bsr.w	sub_FAF8C
	bra.w	.FA38A
.FA386
	adda.w	(a2),a2
	addq.w	#8,a2
.FA38A
	dbf	d0,.FA386
	clr.w	d7
	movea.l	#ThreeStars,a3
	movea.l	a2,a1
	bsr.w	sub_F997A
	movea.l	#$FFFFCF38,a3
.FA3A2
	addq.w	#1,d7
	cmpi.b	#$20,(a3)+
	bne.s	.FA3A2
	subq.w	#1,d7
	move.b	#0,-(a3)
	movea.l	#ThreeStars,a3
	addq.w	#1,d7
	andi.w	#$FE,d7
	addq.w	#2,d7
	move.w	d7,(a3)
	movea.l	a3,a1
	move.w	#8,(printx).l
	move.w	#$B,(printy).l
	jsr	(print2).l
	bsr.w	sub_FAF8C
	movea.l	#HmShots,a2
	tst.w	(word_FFD4F6).w
	beq.w	.FA3F0
	movea.l	#AwShots,a2
.FA3F0
	jsr	(sub_18B5E).l
	move.w	#8,(printx).l
	move.w	#$C,(printy).l
	jsr	(print2).l
	move.w	#8,d1
	jsr	(sub_FAC3E).l
	move.w	#$15,(printx).l
	move.w	#$C,(printy).l
	move.w	(printx).w,-(sp)
	jsr	(printz2).l
	String	'  Records'
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printz2).l
	String	'-----------'
	move.w	#$15,(printx).l
	move.w	#$12,(printy).l
	move.w	(printx).w,-(sp)
	jsr	(printz2).l
	String	' This Game '
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printz2).l
	String	'-----------'
	move.w	(HomeTeam).w,d1
	tst.w	(word_FFD4F6).w
.FA4A4
	beq.w	.FA4AC
	move.w	(VisTeam).w,d1
.FA4AC
	ext.l	d1
	bsr.w	sub_FAF8C
	ext.l	d0
	movea.l	#ThreeStars,a0
	bsr.w	sub_F9B94
	movea.l	#ThreeStars,a0
	move.b	(a0),d2
	move.b	1(a0),d3
	move.b	3(a0),d4
	move.b	2(a0),d5
	move.w	#$E,d1
	move.w	(word_FFD448).w,d0
	tst.w	(word_FFD4F6).w
.FA4DE
	beq.w	.FA4E6
.FA4E2
	move.w	(word_FFD44A).w,d0
.FA4E6
	cmp.w	(word_FFD52E).w,d0
	ble.w	.FA50E
	move.w	#$15,d0
	bsr.w	sub_FA708
	bsr.w	sub_FAF8C
	move.w	#$15,d1
	move.w	#$14,d2
	bsr.w	sub_FAD84
	st	(word_FFD598).w
	bra.w	.FA52A
.FA50E
	move.w	#$15,d0
	bsr.w	sub_FA75C
	bsr.w	sub_FAF8C
	move.w	#$15,d1
	move.w	#$14,d2
	bsr.w	sub_FACF0
	clr.w	(word_FFD598).w
.FA52A
	move.w	#3,d1
	move.w	#$11,d2
	bsr.w	sub_FAF8C
	bsr.w	sub_FA8AC
	move.w	#3,d1
	move.w	#$F,d2
	bsr.w	sub_FAF8C
	bsr.w	loc_FAB4C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FA550	;94 only. Player card "Records" column
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$21,d0
	move.w	#8,d1
	jsr	(sub_FA66E).l
	move.w	#1,d0
	move.w	#8,d1
	bset	#0,(word_FFC2F8).w
	jsr	(sub_FA66E).l
	bclr	#0,(word_FFC2F8).w
	move.w	#$64,(palcount).w
	jsr	(printz).l
	String	$BE,0,0
	move.w	#8,d1	;IDA hid this
	jsr	(sub_FAC3E).l	;IDA hid this
	move.w	#3,d0
	move.w	#$F,d1
	jsr	(loc_FA936).l
	move.w	#8,d0
	move.w	#$B,d1
	jsr	(sub_FABDC).l
	move.w	#$15,(printx).w	;IDA hid this
	move.w	#$C,(printy).w
	move.w	(printx).w,-(sp)	;IDA hid this
	jsr	(printz2).l	;IDA hid this
	String	'  Records'
	move.w	(sp)+,(printx).w	;IDA hid this
	addq.w	#1,(printy).w	;IDA hid this
	jsr	(printz2).l	;IDA hid this
	String	'-----------'
	move.w	(HomeTeam).w,d1
	tst.w	(word_FFD4F6).w
	beq.w	.FA602
	move.w	(VisTeam).w,d1
.FA602
	ext.l	d1
	movea.l	#ThreeStars,a0
	move.l	a0,-(sp)
	jsr	(clrCrowdRAM).l
	move.w	#$15,d0
	move.w	#$E,d1
	move.b	(a0),d2
	move.b	1(a0),d3
	move.b	3(a0),d4
	move.b	2(a0),d5
	bsr.w	sub_FA75C
	movea.l	(sp),a0
	move.w	#$15,d0
	move.w	#$12,d1
	move.b	4(a0),d2
	move.b	5(a0),d3
.FA63E
	move.b	7(a0),d4
	move.b	6(a0),d5
	bsr.w	sub_FA708
	movea.l	(sp)+,a0
	move.w	#$15,d0
	move.w	#$16,d1
	move.b	8(a0),d2
	move.b	9(a0),d3
	move.b	$B(a0),d4
	move.b	$A(a0),d5
	bsr.w	sub_FA6E8
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FA66E	;94 only. Player card helper: clear a text area
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BE,0,0
	move.w	d0,(printx).w	;IDA hid this
	move.w	d1,(printy).w
	move.w	(word_FFD450).w,d4
	move.w	(HomeTeam).w,d3
	tst.w	(word_FFD4F6).w
	beq.w	.FA69A
	move.w	(VisTeam).w,d3
.FA69A
	asl.w	#2,d3
	movea.l	#unk_F86F2,a0
	movea.l	0(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	movea.l	#unk_FF462,a0
	subi.w	#$20,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	(dword_FFBD4A).w,-(sp)
	move.l	(dword_FFBD4E).w,-(sp)
	move.w	#2,d5
	jsr	(dobitmap).l
	move.l	(sp)+,(dword_FFBD4E).w
	move.l	(sp)+,(dword_FFBD4A).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FA6E8	;94 only. Player card record line (unk_FA6F6, loc_FA7B0)
	move.l	#unk_FA6F6,(TempMaxSpd).l
	bra.w	loc_FA7B0
unk_FA6F6	dc.b	0	;IDA name. sub_FA6E8 text
	dc.b	$12,$20
	dc.b	$64	;d
	dc.b	$42	;B
	dc.b	$20
	dc.b	$43	;C
	dc.b	$72	;r
	dc.b	$6F	;o
	dc.b	$77	;w
	dc.b	$64	;d
	dc.b	$20
	dc.b	$4C	;L
	dc.b	$65	;e
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$6C	;l
	dc.b	0
sub_FA708	;94 only. Player card record line (unk_FA734 / unk_FA746, loc_FA7B0)
	movem.l	a1-a3,-(sp)
	movea.l	#unk_FA734,a1
	tst.w	d3
	beq.w	.FA71E
	movea.l	#unk_FA746,a1
.FA71E
	cmp.b	#1,d2
	bne.w	.FA728
	adda.w	(a1),a1
.FA728
	move.l	a1,(TempMaxSpd).w
	movem.l	(sp)+,a1-a3
	bra.w	loc_FA7B0
unk_FA734	dc.b	0	;IDA name. sub_FA708 text
	dc.b	$A,$20
	dc.b	$53	;S
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$73	;s
	dc.b	$20,0,0,8,$20
	dc.b	$53	;S
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$20
unk_FA746	dc.b	0	;IDA name. sub_FA708 text
	dc.b	$C,$20
	dc.b	$53	;S
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$73	;s
	dc.b	$20
	dc.b	$62	;b
	dc.b	$79	;y
	dc.b	0,0,$A,$20
	dc.b	$53	;S
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$20
	dc.b	$62	;b
	dc.b	$79	;y
sub_FA75C	;94 only. Player card record line (unk_FA788 / unk_FA79A, loc_FA7B0)
	movem.l	a1-a3,-(sp)
	movea.l	#unk_FA788,a1
	tst.w	d3
	beq.w	.FA772
	movea.l	#unk_FA79A,a1
.FA772
	cmp.b	#1,d2
	bne.w	.FA77C
	adda.w	(a1),a1
.FA77C
	move.l	a1,(TempMaxSpd).w
	movem.l	(sp)+,a1-a3
	bra.w	loc_FA7B0
unk_FA788	dc.b	0	;IDA name. sub_FA75C text
	dc.b	$A,$20
	dc.b	$47	;G
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$73	;s
	dc.b	$20,0,0,8,$20
	dc.b	$47	;G
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$20
unk_FA79A	dc.b	0	;IDA name. sub_FA75C text
	dc.b	$C,$20
	dc.b	$47	;G
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$73	;s
	dc.b	$20
	dc.b	$62	;b
	dc.b	$79	;y
	dc.b	0,0,$A,$20
	dc.b	$47	;G
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$20
	dc.b	$62	;b
	dc.b	$79	;y
loc_FA7B0	;IDA label. Print a player card record line: label (appstring), value (sub_F998E / sub_FA014 / sub_FA880)
	tst.b	d2
	bne.w	.FA7B8
	rts
.FA7B8
	move.w	d0,(printx).w
	move.w	d1,(printy).w
	move.w	d2,d0
	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	move.l	a1,-(sp)
	jsr	(sub_F998E).l
	movea.l	(sp)+,a1
	movea.l	a1,a3
	movea.l	(TempMaxSpd).w,a1
	jsr	(appstring).l
	move.w	(printx).w,-(sp)
	movea.l	#mesarea,a1
	jsr	(print2).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	movea.l	#mesarea,a1
	move.w	d3,d2
	ext.w	d2
	bset	#7,(word_FFC2F8).w
	jsr	(sub_FA014).l
	movea.l	a1,a3
	movea.l	#unk_FA876,a1
	jsr	(appstring).l
	move.w	(printx).w,-(sp)
	movea.l	#mesarea,a1
	jsr	(print2).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	move.w	d4,d2
	ext.w	d2
	movea.l	#mesarea,a1
	bset	#7,(word_FFC2F8).w
	jsr	(sub_FA014).l
	movea.l	a1,a3
	movea.l	#unk_FA87C,a1
	jsr	(appstring).l
	move.w	d5,d0
	movea.l	#mesarea,a1
	jsr	(sub_FA880).l
	movea.l	#mesarea,a1
	jsr	(print2).l
	rts
unk_FA876	dc.b	0	;IDA name. loc_FA7B0 text
	dc.b	6,$20
	dc.b	$76	;v
	dc.b	$73	;s
	dc.b	$2E	;.
unk_FA87C	dc.b	0	;IDA name. loc_FA7B0 text
	dc.b	4,$20,0
sub_FA880	;94 only. Append a time to mesarea (appstring)
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#2,d0
	movea.l	#$30E,a0
	movea.l	0(a0,d0.w),a0
	move.w	4(a0),d0
	ext.l	d0
	adda.l	d0,a0
	adda.w	(a0),a0
	movea.l	a1,a3
	movea.l	a0,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
sub_FA8AC	;94 only. Player card "Overall Rating" (CalcAttrib, AttribAdjust)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d1,(printx).w
	move.w	d2,(printy).w
	move.w	d1,-(sp)
	jsr	(printz2).l
	String	'Overall'
	move.w	(sp)+,(printx).w	;IDA hid this
	addq.w	#1,(printy).w	;IDA hid this
	jsr	(printz2).l	;IDA hid this
	String	'Rating   '
	movea.l	#HmShots,a2
	tst.w	(word_FFD4F6).w
	beq.w	.FA8F8
	movea.l	#AwShots,a2
.FA8F8
	move.l	(dword_19420).l,d4
	tst.w	(word_FFD598).w
	beq.w	.FA90C
	move.l	(dword_19582).l,d4
.FA90C
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	movea.l	#mesarea,a1
	bsr.w	sub_F998E
	movea.l	#mesarea,a1
	jsr	(print2).l
	movem.l	(sp)+,d0-d7/a0-a6
nullsub_4	;IDA name. An rts
	rts
loc_FA936	;IDA label. Player card "Starting Line": the line slots the player starts in (unk_FA9D2 position names)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).w,d2
	bsr.w	sub_FEE4A
	tst.w	(word_FFD4F6).w
.FA946
	beq.w	.FA952
	move.w	(VisTeam).w,d2
	bsr.w	sub_FEE4A
.FA952
	movea.l	#$30E,a0
	asl.w	#2,d2
	ext.l	d2
	adda.l	d2,a0
	movea.l	(a0),a0
	move.w	6(a0),d2
	ext.l	d2
	adda.l	d2,a0
	move.w	d0,(printx).w
	move.w	d1,(printy).w
	move.w	d0,-(sp)
	jsr	(printz2).l
	String	'Starting Line'
	addq.w	#2,(printy).w	;IDA hid this
	move.w	(sp),(printx).w	;IDA hid this
	movea.l	#unk_FA9D2,a1	;IDA hid this
.FA996
	cmpi.w	#2,(a1)
	beq.w	.FA9CA
	move.w	(sp),(printx).w
	move.l	a1,-(sp)
	jsr	(print2).l
	move.b	(a0)+,d0
	ext.w	d0
	subq.w	#1,d0
	jsr	(FormatPlayerNameShort).l
	jsr	(print2).l
	movea.l	(sp)+,a1
	move.w	(a1),d0
	ext.l	d0
	adda.l	d0,a1
	addq.w	#1,(printy).w
	bra.s	.FA996
.FA9CA
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FA9D2	;no IDA label (IDA hid the movea.l #$FA9D2). Position names; an empty String ends the list
	String	'G   '
	String	'LD  '
	String	'RD  '
	String	'LW  '
	String	'C   '
	String	'RW  '
	dc.w	2
CalcAttrib	;IDA name (and comments). 94 only: the overall rating of player d0: his attributes weighted by OvrPlayerWgtList (skaters) or
	;OvrGoalWgtList (goalies), and by AttribWgtList. Called from getNameandAttrib (stats94) and sub_FA8AC
	move.l	a6,-(sp)	;push a6 to stack
	clr.w	(OvrDivisor).w
	clr.w	(OvrDividend).w
	movea.l	#AttribWgtList,a6	;move address FAB3C into a6
	cmp.l	(dword_19420).l,d4	;compare long word (1FBA000A) to d4
	bne.w	.1	;branch if not equal
	movea.l	#OvrPlayerWgtList,a6	;move address FAB1C into a6
.1
	cmp.l	(dword_19582).l,d4	;compare long word 130F000A to d4
	bne.w	.11	;branch if not equal
	movea.l	#OvrGoalWgtList,a6	;move address FAB2C into a6
.11
	movea.l	$1E(a2),a0	;move ROM address of Team Data into a0
	lea	$1A2(a2),a4	;move start of Hot/Cold table to a4
	clr.l	d1	;clear d1
	move.w	d0,d1	;move d0 into d1. d0 is the offset of the player
	asl.w	#4,d1	;mult d1 by 16
	adda.l	d1,a4	;add d1 to a4
	adda.l	#$10,a4	;add 16 dec to a4. Move to start of Hot/Cold for player.
	adda.w	(a0),a0	;add player table offset to Team Data start
.skip
	adda.w	(a0),a0	;add Player Name length to a0
	addq.w	#8,a0	;add 8 (skips attributes)
	dbf	d0,.skip	;skip until at player
	clr.w	d0	;clear d0
	clr.w	d1	;clear d1
	moveq	#$F,d2	;move 15 dec into d2 (start at bit 15)
	swap	d4	;swap words in d4
.loop2
	btst	d2,d4	;bit test d2 bit in d4
	beq.w	.check	;branch if bit is 0
	move.w	d2,d3	;move d2 into d3
	lsr.w	#1,d3	;divide d3 by 2
	neg.w	d3	;negate d3
	move.b	-1(a0,d3.w),d3	;move a0+d3-1 into d3. a0 currently at end of player data. Sets d3 byte to attribute
	btst	#0,d2	;test bit 0 of d2
	beq.w	.0	;branch if equal
	lsr.w	#4,d3	;divide d3 by 16. Shifts upper nibble to lower in case d2 was odd
.0
	andi.w	#$F,d3	;pass bottom nibble of d3
	cmp.w	#$D,d2	;compare d2 to 13 dec (check if Wgt nibble)
	bne.w	.cont	;branch if not equal
	bra.w	.00
.cont
	cmp.w	#6,d2	;compare d2 to 6 (Fight nibble)
	beq.w	.00
	movem.l	d5-d7,-(sp)	;push to stack
	move.b	0(a6,d2.w),d5	;move a6+d2 into d5
	ext.w	d5	;sign extend d5
	cmp.w	#2,d5	;comare d5 to 2
	beq.w	.000	;branch if equal
	move.w	d3,-(sp)	;push d3 to stack (current attribute)
	subq.w	#2,d5	;sub 2 from d5
.attribadd
	add.w	(sp),d3	;add stack value to d3
	dbf	d5,.attribadd	;loop until d5 is 0
	asr.w	#1,d3	;divide d3 by 2
	tst.w	(sp)+	;test stack and increment
.000
	movem.l	(sp)+,d5-d7	;pop off stack into d5-d7
	cmpa.l	#AttribWgtList,a6	;check if a6 is FAB3C
	beq.w	.FAACA	;branch if equal
	neg.w	d2	;negate d2
	move.w	d7,-(sp)	;push d7 to stack
	move.b	-1(a4,d2.w),d7	;move data at a4+d2-1 into d7
	ext.w	d7	;sign extend d7
	add.w	d7,(OvrDivisor).w	;add d7 to data at D6CE
	addq.w	#1,(OvrDividend).w	;add 1 to D6D0
	move.w	(sp)+,d7	;pop from stack into d7
	neg.w	d2	;negate d2
	bra.w	.00	;branch
.FAACA
	move.w	d3,-(sp)	;push d3 onto stack
	asl.w	#4,d3	;mult d3 by 16
	add.w	(sp),d3	;add value on stack to d3
	add.w	(sp)+,d3	;add value again from stack into d3 and increment
	neg.w	d2	;negate d2
	add.b	-1(a4,d2.w),d3	;add data at a4+s2-1 into d3
	bpl.w	.pos	;branch if positive
	clr.b	d3	;clear d3
.pos
	neg.w	d2	;negate d2
.00
	add.w	d3,d0	;add d3 to d0 (d0 = attribute value)
	addi.w	#$64,d1	;'d'   ; add 100 dec to d1
.check
	dbf	d2,.loop2
	cmpa.l	#AttribWgtList,a6	;compare address value FAB3C to a6
	beq.w	.FAB0E	;branch if equal
	move.w	#$64,d1	;'d'   ; move 100 dec into d1
	movem.l	d6-d7,-(sp)	;push d6 and d7 to stack
	move.w	(OvrDivisor).w,d6	;move into d6
	ext.l	d6	;word extend d6
	move.w	(OvrDividend).w,d7	;move into d7
	divs.w	d7,d6	;divide d7 into d6
	add.w	d6,d0	;add d6 to d0
	movem.l	(sp)+,d6-d7	;pop from stack
.FAB0E
	cmp.w	d1,d0
	blt.w	.FAB18
	move.w	d0,d1
	subq.w	#1,d0
.FAB18
	movea.l	(sp)+,a6
	rts
OvrPlayerWgtList	dc.b	2	;IDA name. CalcAttrib skater weights
	dc.b	2,2,2,4,6,2,4,2,4,6,6,4,2,2,2
OvrGoalWgtList	dc.b	2	;IDA name. CalcAttrib goalie weights
	dc.b	2,2,2,2,2,2,2,9,9,2,2,9,2,2,2
AttribWgtList	dc.b	2	;IDA name. CalcAttrib attribute weights
	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
loc_FAB4C	;IDA label. Player card position: Goalie, Forward or Defenseman (from the roster index: ReadAttributeNibble, sub_9F5C)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#mesarea,a1
	bsr.w	sub_FAC90
	move.w	d1,(printx).w
	move.w	d2,(printy).w
	jsr	(print2).l
	movea.l	#HmShots,a2
	tst.w	(word_FFD4F6).w
	beq.w	.FAB7C
	movea.l	#AwShots,a2
.FAB7C
	move.w	d0,-(sp)
	jsr	(sub_9F5C).l
	cmp.w	(sp),d0
	ble.w	.FABC0
	move.w	(sp),d0
	jsr	(ReadAttributeNibble).l
	cmp.w	(sp),d0
	ble.w	.FABAC
	jsr	(printz2).l
	String	' Goalie'
	bra.w	.FABD4	;IDA hid this
.FABAC
	jsr	(printz2).l	;IDA hid this
	String	' Forward'
	bra.w	.FABD4
.FABC0
	jsr	(printz2).l
	String	' Defenseman'
.FABD4
	tst.w	(sp)+	;IDA hid this
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FABDC	;94 only. Player card "Team Rating" (sub_FE172, high ROM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(printx).w
	move.w	d1,(printy).w
	move.w	d0,-(sp)
	jsr	(printz2).l
	String	'Team'
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printz2).l
	String	'Rating  '
.FAC0E
	movea.l	#HmShots,a0
	tst.w	(word_FFD4F6).w
	beq.w	.FAC22
	movea.l	#AwShots,a0
.FAC22
	movea.l	a0,a2
	bsr.w	sub_FE172
.FAC28
	move.w	#2,d1
	jsr	(PushNumberWidth).l
.FAC32
	jsr	(print2).l
	movem.l	(sp)+,d0-d7/a0-a6
.FAC3C
	rts
sub_FAC3E	;94 only. Player card helper (sub_FAC78)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d1,(printy).w
	movea.l	#HmShots,a0
	tst.w	(word_FFD4F6).w
	beq.w	.FAC5A
	movea.l	#AwShots,a0
.FAC5A
	movea.l	$1E(a0),a0
	adda.w	4(a0),a0
.FAC62
	bsr.w	sub_FAC78
	adda.w	(a0),a0
	adda.w	(a0),a0
	addq.w	#1,(printy).w
	bsr.w	sub_FAC78
.FAC72
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FAC78	;94 only. Part of sub_FAC3E
	move.w	#$14,(printx).w
	move.w	(a0),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	movea.l	a0,a1
	jmp	print2
sub_FAC90	;94 only. Part of loc_FAB4C
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	tst.w	(word_FFD4F6).w
	beq.w	.FACA8
	movea.l	#AwShots,a0
.FACA8
	movea.l	$1E(a0),a0
	move.w	(a0),d1
	ext.l	d1
	adda.l	d1,a0
.FACB2
	move.w	(a0),d1
	ext.l	d1
	adda.l	d1,a0
	addq.l	#8,a0
	dbf	d0,.FACB2
	subq.l	#8,a0
	move.w	#4,(a1)+
	move.b	(a0),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	bne.w	.FACD8
	move.b	#$20,d0
	bra.w	.FACDC
.FACD8
	addi.b	#$30,d0
.FACDC
	move.b	d0,(a1)+
	move.b	(a0),d0
	andi.w	#$F,d0
	addi.b	#$30,d0
	move.b	d0,(a1)+
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FACF0	;94 only. Player card "Goals" / "Assists" (sub_FAF50)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_FAF50
	move.l	a0,-(sp)
	adda.l	#$B4,a0
	move.b	0(a0,d0.w),d3
	ext.w	d3
	movea.l	(sp)+,a0
	adda.l	#$CE,a0
	move.b	0(a0,d0.w),d4
	ext.w	d4
	move.w	d1,(printx).w
	move.w	d2,(printy).w
	move.w	d1,-(sp)
	jsr	(printz2).l
	String	'Goals    '
	move.w	d0,-(sp)
	move.w	d3,d0
	movea.l	#mesarea,a1
	bsr.w	sub_F998E
	move.w	(sp)+,d0
	movea.l	#mesarea,a1
	jsr	(print2).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printz2).l
	String	'Assists  '
	move.w	d4,d0
	movea.l	#mesarea,a1
	bsr.w	sub_F998E
	movea.l	#mesarea,a1
	jsr	(print2).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FAD84	;94 only. Player card "Saves" / "Save %" (sub_FAF50)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_FAF50
	move.l	a0,-(sp)
	adda.l	#$B4,a0
.FAD94
	move.b	0(a0,d0.w),d3
	ext.w	d3
	movea.l	(sp)+,a0
	adda.l	#$E8,a0
	move.b	0(a0,d0.w),d4
	ext.w	d4
	move.w	d4,d7
	sub.w	d3,d7
	move.w	d1,(printx).w
	move.w	d2,(printy).w
	move.w	d1,-(sp)
	jsr	(printz2).l
	String	'Saves    '
	move.w	d7,d0
	movea.l	#mesarea,a1
	move.l	a1,-(sp)
	bsr.w	sub_F998E
	movea.l	(sp)+,a1
	jsr	(print2).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printz2).l
	String	'Save %   '
	move.w	d7,d0
	mulu.w	#$64,d0
	tst.w	d4
	bne.w	.FAE0A
	clr.w	d0
	bra.w	.FAE0C
.FAE0A
	divu.w	d4,d0
.FAE0C
	movea.l	#mesarea,a1
	move.l	a1,-(sp)
	bsr.w	sub_F998E
	movea.l	(sp)+,a1
	jsr	(print2).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FAE26	;94 only. Draw the player picture (graphics94 unk_C682E ... unk_C726C)
	movem.l	d0-d7/a1-a6,-(sp)
	movea.l	#unk_F92F4,a0
	move.w	d1,d2
	asl.w	#2,d2
	movea.l	0(a0,d2.w),a0
	move.w	#$FFFF,d2
	bra.w	.FAE50
.FAE40
	cmp.w	4(a0),d0
	bne.w	.FAE4E
	movea.l	(a0),a0
	bra.w	.FAEB6
.FAE4E
	addq.l	#6,a0
.FAE50
	addq.w	#1,d2
	tst.l	(a0)
	bne.s	.FAE40
	movea.l	#$30E,a0
	asl.w	#2,d1
	movea.l	0(a0,d1.w),a0
	movea.l	a0,a6
	move.w	d0,d6
	adda.w	(a6),a6
	bra.w	.FAE70
.FAE6C
	adda.w	(a6),a6
	addq.w	#8,a6
.FAE70
	dbf	d6,.FAE6C
	adda.w	(a6),a6
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d3
.FAE7E
	addq.w	#1,d3
	asl.w	#4,d1
	bne.s	.FAE7E
	movea.l	#unk_C6F02,a0
	btst	#0,4(a6)
	bne.w	.FAE9A
	movea.l	#unk_C726C,a0
.FAE9A
	cmp.w	d3,d0
	blt.w	.FAEB6
	movea.l	#unk_C6B98,a0
	btst	#0,4(a6)
	bne.w	.FAEB6
	movea.l	#unk_C682E,a0
.FAEB6
	movem.l	(sp)+,d0-d7/a1-a6
	rts
sub_FAEBC	;94 only. Player card picture box (sub_FAE26, sub_FE98A)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_FAF8C
	move.w	(HomeTeam).w,d1
	tst.w	(word_FFD4F6).w
	beq.w	.FAED4
	move.w	(VisTeam).w,d1
.FAED4
	bsr.w	sub_FAE26
	jsr	(printz).l
	String	$8E,1,8
	move.w	(word_FFD452).w,d4	;IDA hid this
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#unk_C63F8,a0
	adda.l	(a0),a0
	tst.l	(a2)
	bne.w	.FAF0C
	movea.l	#unk_C63F8,a1
	adda.l	4(a1),a1
	tst.l	(a2)+
	bra.w	.FAF0E
.FAF0C
	adda.l	(a2)+,a1
.FAF0E
	bsr.w	sub_FE98A
	movea.l	#$FFFFDA1E,a2
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	movem.l	d0/a0-a1,-(sp)
	adda.w	#$20,a0
	movea.l	#unk_FFBD68,a1
	move.w	#7,d0
.FAF36
	move.l	(a0)+,(a1)+
	dbf	d0,.FAF36
	movem.l	(sp)+,d0/a0-a1
	move.w	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FAF50	;94 only. Player card value (sub_FACF0, sub_FAD84)
	movea.l	#HmShots,a0
	tst.w	(word_FFD4F6).w
	beq.w	.FAF64
	movea.l	#AwShots,a0
.FAF64
	rts
sub_FAF66	;94 only. Part of sub_FA014
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3
.FAF6E
	move.b	-(a3),d0
	cmp.b	#$20,d0
	bne.w	.FAF80
	move.b	#0,(a3)
	subq.w	#1,(a2)
	bra.s	.FAF6E
.FAF80
	addq.w	#1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
sub_FAF8C	;94 only. Player card helper
	movem.l	d1/a0,-(sp)
	movea.l	#$FFFFD4FA,a0
	tst.w	(word_FFD4F6).w
	beq.w	.FAFA4
	movea.l	#$FFFFD514,a0
.FAFA4
	move.w	(word_FFD4F4).w,d1
	subq.w	#1,d1
	move.b	0(a0,d1.w),d0
	ext.w	d0
	move.w	d0,(word_FFD52E).w
	movem.l	(sp)+,d1/a0
	rts
sub_FAFBA	;94 only. Load the player card tiles (sub_FAFE4)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFD4FA,a1
	movea.l	#HmShots,a0
	bsr.w	sub_FAFE4
	movea.l	#$FFFFD514,a1
	movea.l	#AwShots,a0
	bsr.w	sub_FAFE4
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FAFE4	;94 only. Part of sub_FAFBA
	movea.l	$1E(a0),a0
	adda.w	6(a0),a0
	movea.l	a1,a2
	addq.w	#6,a2
	clr.w	d0
.FAFF2
	move.w	#5,d1
.FAFF6
	move.b	0(a0,d1.w),d3
	subq.b	#1,d3
	cmp.b	d3,d0
	beq.w	.FB00C
	dbf	d1,.FAFF6
	move.b	d0,(a2)+
	bra.w	.FB00E
.FB00C
	move.b	d0,(a1)+
.FB00E
	addq.w	#1,d0
	cmp.w	#$1A,d0
	blt.s	.FAFF2
	rts
loc_FB018	;IDA label. "NAME ENTRY" screen for the user records (own vblank VBlank_SetOptions): pick a name from the name log or enter a new one (sub_FB4C4 ... sub_FBBDE). Called from sub_FBB88
	movem.l	d0-d7/a0-a6,-(sp)
	move	#$2700,sr
	move.w	#2,d4
	move.l	#VBlank_SetOptions,(vbint).w
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setvram).l
	move	#$2500,sr
	jsr	(orjoy).l
	move.w	d4,(framercset).w
	movea.l	#unk_55B86,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$91234567,$89ABCDEF	;remap table (IDA: code)
	move.w	d4,(word_FFD530).w
	movea.l	#unk_55B86,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$91234560,$89ABCDEF	;remap table (IDA: code)
	move.w	d4,(word_FFB012).w
	jsr	(AddSmallFont).l
	jsr	(printz).l
	String	$FF,0,0
	moveq	#$28,d0	;IDA hid this
	moveq	#$1C,d1	;IDA hid this
	move.w	#$7FF,d2	;IDA hid this
	jsr	(eraser).l	;IDA hid this
	jsr	(setupIceRinkMap).l
	jsr	(printz).l	;IDA hid this
	String	$FE,0,0
	movea.l	#unk_54E24,a0	;IDA hid this (and printz Strings)
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5
	jsr	(dobitmap).l
	move.w	d4,(word_FFD430).w
	addi.w	#$24,d4
	move.w	d4,(word_FFD436).w
	movea.l	#unk_BF70A,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(word_FFB010).w
	movea.l	#unk_A9A18,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$71234567,$89ABCDEF	;remap table
	jsr	(printz).l
	String	$BF,$1F,6
	move.w	(HomeTeam).w,d0
	tst.w	(word_FFD4EE).w
	beq.w	.FB152
	move.w	(VisTeam).w,d0
.FB152
	movea.l	#$30E,a1	;TeamList
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1
	adda.w	4(a1),a1
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	jsr	(printz).l
	String	$BF,$1B,7
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$8F,$1C,8
	move.w	(HomeTeam).w,d3
	tst.w	(word_FFD4EE).w
	beq.w	.FB1A8
	move.w	(VisTeam).w,d3
.FB1A8
	asl.w	#2,d3
	movea.l	#unk_F86F2,a0	;team logo maps (hockey94_08)
	movea.l	0(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	movea.l	#unk_FF462,a0
	subi.w	#$40,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.w	#4,d5
	move.w	(word_FFD430).w,d4
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BF,2,0
	move.w	#$24,d0
	move.w	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BF,$A,2,'NAME  ENTRY'
	bsr.w	sub_F9C68
	clr.w	(word_FFD4EC).w
	move.w	#1,(word_FFD4EA).w
	clr.w	d0
	bsr.w	sub_FBBDE
	movea.l	#word_FFD4DA,a1
	bsr.w	sub_FB992
	bsr.w	sub_FB822
	jsr	(printz).l
	String	$BF,7,6,'Name Log'
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	clr.w	d4
	bsr.w	sub_FB722
	bsr.w	sub_FB77A
	bsr.w	sub_FB7CA
.FB264
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(sub_FB97C).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	sub_FB7A0
	move.w	#1,(word_FFD6C4).w
	bsr.w	sub_FB4C4
	clr.w	d0
	bra.w	.FB410
.FB296
	bsr.w	sub_FB8EC
	jsr	(printz).l
	String	$BF,5,$12
	tst.w	(word_FFD6C4).w
	beq.w	.FB2BC
	movea.l	#word_FFD4DA,a1
	bsr.w	sub_FB91A
	bsr.w	sub_FB6F0
.FB2BC
	bsr.w	sub_FB874
.FB2C0
	move.w	(vcount).w,d0
.FB2C4
	cmp.w	(vcount).w,d0
	beq.s	.FB2C4
	movem.w	d1,-(sp)
	move.w	(cont1team).w,d1
	subq.w	#1,d1
	cmp.w	(word_FFD4EE).w,d1
	movem.w	(sp)+,d1
	beq.w	.FB2EE
	jsr	(ReadJoy2).l
	tst.w	d1
	beq.s	.FB2C0
	bra.w	.FB2F8
.FB2EE
	jsr	(ReadJoy1).l
	tst.w	d1
	beq.s	.FB2C0
.FB2F8
	btst	#7,d1
	bne.w	.FB4BA
	tst.w	(word_FFD6C4).w
	bne.w	.FB332
	move.w	#1,d0
	btst	#1,d1
	bne.w	.FB37C
	move.w	#$FFFF,d0
	btst	#0,d1
	bne.w	.FB37C
	btst	#4,d1
	beq.w	.FB296
	bsr.w	sub_FB4C4
	clr.w	d0
	bra.w	.FB37C
.FB332
	moveq	#-1,d0
	btst	#6,d1
	bne.w	.FB410
	neg.w	d0
	btst	#5,d1
	bne.w	.FB410
	btst	#3,d1
	bne.w	.FB43E
	neg.w	d0
	btst	#2,d1
	bne.w	.FB43E
	moveq	#6,d0
	btst	#1,d1
	bne.w	.FB43E
	neg.w	d0
	btst	#0,d1
	bne.w	.FB43E
	btst	#4,d1
	beq.w	.FB296
	bsr.w	sub_FB4C4
	bra.w	.FB296
.FB37C
	add.w	d0,(word_FFD4EA).w
.FB380
	cmpi.w	#7,(word_FFD4EA).w
	ble.w	.FB390
	move.w	#1,(word_FFD4EA).w
.FB390
	tst.w	(word_FFD4EA).w
	bne.w	.FB39E
	move.w	#7,(word_FFD4EA).w
.FB39E
	bsr.w	sub_FBBDE
	beq.s	.FB380
	movea.l	#word_FFD4DA,a1
	bsr.w	sub_FB992
	tst.w	(word_FFD6C4).w
	bne.w	.FB3C0
	jsr	(sub_FB634).l
	bra.w	.FB296
.FB3C0
	jsr	(printz).l
	String	$BF,4,$13
	add.w	d4,(printx).w
	jsr	(printz).l
	String	'   '
	bsr.w	sub_FB7CA
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	sub_FB7A0
	bsr.w	sub_FB722
	move.w	d4,d0
	neg.w	d0
	bra.w	*+4
.FB410
	add.w	d4,d0
	cmp.w	#$B,d0
	bhi.w	.FB296
	move.w	d0,d4
	bsr.w	sub_FB77A
	movea.l	#word_FFD4DA,a0
	clr.w	d0
	cmpi.b	#$2D,0(a0,d4.w)
	beq.w	.FB43E
	move.b	0(a0,d4.w),d0
	ext.w	d0
	bsr.w	sub_FB750
	sub.w	d5,d0
.FB43E
	add.w	d5,d0
	cmp.w	#$1D,d0
	bhi.w	.FB296
	move.w	d0,-(sp)
	bsr.w	sub_FB7CA
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	sub_FB7A0
	move.w	(sp)+,d5
	bsr.w	sub_FB7CA
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	tst.w	(word_FFD6C4).w
	beq.w	.FB48E
	jsr	(sub_FB97C).l
.FB48E
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	sub_FB7A0
	movea.l	#word_FFD4DA,a0
	movea.l	#unk_FB95C,a1
	move.b	0(a1,d5.w),d0
	move.b	d0,0(a0,d4.w)
	bra.w	.FB296
.FB4BA
	bsr.w	sub_FB9D4
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB4C4	;94 only. Name entry: the letter grid ("D-Pad to a letter.", "C to select letter.", "A to go back.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BF,1,$14
	move.w	#$16,d0
	move.w	#7,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bchg	#0,(word_FFD6C4+1).w
	bne.w	.FB5F0
	jsr	(printz).l
	String	$BF,$19,$11
	movea.l	#unk_FB95C,a0
	moveq	#4,d0
.FB504
	moveq	#5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
.FB510
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbf	d1,.FB510
	movea.w	#(mesarea-M68K_RAM),a1
	jsr	(print).l
	addq.w	#2,(printy).w
	subi.w	#$C,(printx).w
	dbf	d0,.FB504
	jsr	(printz).l
	String	$FE,1,$14
	moveq	#$16,d0
	moveq	#7,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$BF,2,$15,'D-Pad to a letter.'
	move.w	#2,(printx).w
	addq.w	#1,(printy).w
	move.w	(printx).w,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).w
	addq.w	#1,(printy).w
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).w
	addq.w	#1,(printy).w
	jsr	(printz).l
	String	'B to cancel.'
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
.FB5D2
	jsr	(printz).l
	String	'START when done.'
.FB5EA
	movem.l	(sp)+,d0-d7/a0-a6
.FB5EE
	rts
.FB5F0
	movea.l	#word_FFD4DA,a1
.FB5F6
	bsr.w	sub_FB992
	move.w	#0,(printx).w
.FB600
	move.w	#$F,(printy).w
	move.w	#$28,d0
.FB60A
	move.w	#$D,d1
	move.w	#$7FF,d2
.FB612
	jsr	(eraser).l
.FB618
	jsr	(printz).l
	String	$FE,1,$14
	moveq	#$16,d0
	moveq	#7,d1
.FB628
	jsr	(Framer).l
	bsr.w	sub_FB634
	bra.s	.FB5EA
sub_FB634	;94 only. Name entry help text ("D-Pad up/down to move arrows.", "Press START to select name.", "Press B to edit.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BF,2,$15,'D-Pad up/down to    '
	jsr	(printz).l
	String	$BF,2,$16,'move arrows.        '
	move.w	#2,(printx).w
	move.w	(printx).w,-(sp)
	addq.w	#1,(printy).w
	jsr	(printz).l
	String	'Press START to      '
	addq.w	#1,(printy).w	;IDA hid this
	move.w	(sp),(printx).w
	jsr	(printz).l
	String	'select name.        '
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	jsr	(printz).l
	String	'Press B to edit.    '
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB6F0	;94 only. Name entry helper (unk_FB7F2, unk_FB80A)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(word_FFD4EA).w,d0
	mulu.w	#$C,d0
	movea.l	#$FFFFD45A,a0
	movea.l	#unk_FB7F2,a1
	tst.b	0(a0,d0.w)
	beq.w	.FB716
	movea.l	#unk_FB80A,a1
.FB716
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB722	;94 only. Name entry helper (sub_FB750)
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	(word_FFD4DA).w,d0
	bsr.w	sub_FB750
	cmp.w	#$1E,d0
	blt.w	.FB73C
	clr.w	d5
	bra.w	.FB74A
.FB73C
	move.w	d0,d5
	movea.l	#unk_FB95C,a0
	move.b	0(a0,d5.w),(word_FFD4DA).w
.FB74A
	movem.l	(sp)+,d0-d4/a0-a6
	rts
sub_FB750	;94 only. Name entry helper
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#unk_FB95C,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3
.FB762
	cmp.b	0(a0,d0.w),d1
	beq.w	.FB774
	addq.w	#1,d0
	dbf	d3,.FB762
	move.w	#$1E,d0
.FB774
	movem.l	(sp)+,d1-d3/a0-a6
	rts
sub_FB77A	;94 only. Name entry: the " < " cursor
	jsr	(printz).l
	String	$BF,4,$13
	add.w	d4,(printx).w
	tst.w	(word_FFD6C4).w
	beq.w	locret_FB79E
	jsr	(printz).l
	String	' < '
locret_FB79E	;IDA label. The shared rts of sub_FB77A
	rts
sub_FB7A0	;94 only. Name entry helper
	tst.w	(word_FFD6C4).w
	beq.s	locret_FB79E
	movea.l	#ThreeStars,a1
	move.w	#4,(a1)
	move.b	#0,3(a1)
	movea.l	#unk_FB95C,a0
	move.b	0(a0,d5.w),d0
	move.b	d0,2(a1)
	jmp	print
sub_FB7CA	;94 only. Name entry helper
	jsr	(printz).l
	String	$BF,$18,$10
	move.w	d5,d0
	ext.l	d0
	divu.w	#6,d0
	asl.w	#1,d0
	add.w	d0,(printy).w
	swap	d0
	asl.w	#1,d0
	add.w	d0,(printx).w
	moveq	#3,d0
	moveq	#3,d1
	rts
unk_FB7F2	dc.b	0	;IDA name. sub_FB6F0 table
	dc.b	$18,$BF,2,$10,$20,$20
	dc.b	$45	;E
	dc.b	$6E	;n
	dc.b	$74	;t
	dc.b	$65	;e
	dc.b	$72	;r
	dc.b	$20
	dc.b	$6E	;n
	dc.b	$65	;e
	dc.b	$77	;w
	dc.b	$20
	dc.b	$6E	;n
	dc.b	$61	;a
	dc.b	$6D	;m
	dc.b	$65	;e
	dc.b	$3A	;:
	dc.b	$20,0
unk_FB80A	dc.b	0	;IDA name. sub_FB6F0 table
	dc.b	$18,$BF,2,$10
	dc.b	$53	;S
	dc.b	$65	;e
	dc.b	$6C	;l
	dc.b	$65	;e
	dc.b	$63	;c
	dc.b	$74	;t
	dc.b	$20
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$20
	dc.b	$72	;r
	dc.b	$65	;e
	dc.b	$70	;p
	dc.b	$6C	;l
	dc.b	$61	;a
	dc.b	$63	;c
	dc.b	$65	;e
	dc.b	$3A	;:
	dc.b	0
sub_FB822	;94 only. Name entry: the "Name Log" list (sub_FB91A, sub_FB992)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(word_FFD4E8).w,-(sp)
	move.w	(word_FFD4EA).w,-(sp)
	jsr	(printz).l
	String	$BF,5,8
	move.w	#6,d7	;IDA hid this
	move.w	#1,(word_FFD4EA).w	;IDA hid this
	movea.l	#$FFFFBF20,a1
.FB84A
	bsr.w	sub_FB992
	move.w	(printx).w,-(sp)
	bsr.w	sub_FB91A
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#1,(word_FFD4EA).w
	dbf	d7,.FB84A
	move.w	(sp)+,(word_FFD4EA).w
	move.w	(sp)+,(word_FFD4E8).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB874	;94 only. Name entry helper (sub_FB89E)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(word_FFD4EA).w,d0
	cmp.w	(word_FFD4EC).w,d0
	beq.w	.FB898
	movea.l	#unk_FB8E4,a1
	bsr.w	sub_FB89E
	movea.l	#unk_FB8DC,a1
	bsr.w	sub_FB89E
.FB898
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB89E	;94 only. Name entry: print a name
	tst.w	(word_FFD4EC).w
	beq.w	.FB8D4
	jsr	(printz).l
	String	$BF,3,8
	move.w	(word_FFD4EC).w,d0	;IDA hid this
	subq.w	#1,d0
	add.w	d0,(printy).w
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$12,(printx).w
	jsr	(print).l
.FB8D4
	move.w	(word_FFD4EA).w,(word_FFD4EC).w
	rts
unk_FB8DC	dc.b	0	;IDA name. sub_FB874 data
	dc.b	4
	dc.b	$5D	;]
	dc.b	0,0,4
	dc.b	$5B	;[
	dc.b	0
unk_FB8E4	dc.b	0	;IDA name. sub_FB874 data
	dc.b	4,$20,0,0,4,$20,0
sub_FB8EC	;94 only. Name entry helper
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3
	movea.l	#word_FFD4DA,a0
	clr.w	(word_FFD4E8).w
.FB8FE
	cmpi.b	#$2D,(a0)
	beq.w	.FB914
	tst.b	(a0)+
	beq.w	.FB914
	addq.w	#1,(word_FFD4E8).w
	dbf	d3,.FB8FE
.FB914
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB91A	;94 only. Name entry helper
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(word_FFD4E8).w,d0
	move.w	#0,d3
	move.w	#$E,(a0)+
.FB930
	move.b	0(a1,d3.w),d1
	cmp.w	(word_FFD4E8).w,d3
	blt.w	.FB940
	move.b	#$2D,d1
.FB940
	move.b	d1,(a0)+
	addq.w	#1,d3
	cmp.w	#$C,d3
	blt.s	.FB930
	movea.l	#ThreeStars,a1
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FB95C	dc.b	$41	;IDA name. Name entry data
	dc.b	$42	;B
	dc.b	$43	;C
	dc.b	$44	;D
	dc.b	$45	;E
	dc.b	$46	;F
	dc.b	$47	;G
	dc.b	$48	;H
	dc.b	$49	;I
	dc.b	$4A	;J
	dc.b	$4B	;K
	dc.b	$4C	;L
	dc.b	$4D	;M
	dc.b	$4E	;N
	dc.b	$4F	;O
	dc.b	$50	;P
	dc.b	$51	;Q
	dc.b	$52	;R
	dc.b	$53	;S
	dc.b	$54	;T
	dc.b	$55	;U
	dc.b	$56	;V
	dc.b	$57	;W
	dc.b	$58	;X
	dc.b	$59	;Y
	dc.b	$5A	;Z
	dc.b	$2E	;.
	dc.b	$31	;1
	dc.b	$32	;2
	dc.b	$20
	dc.b	$2D	;-
	dc.b	0
sub_FB97C	;94 only. Name entry helper
	move.w	(framercset).w,-(sp)
	move.w	(word_FFD530).w,(framercset).w
	jsr	(Framer).l
	move.w	(sp)+,(framercset).w
	rts
sub_FB992	;94 only. Name entry: read the name log
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFD45A,a0
	move.w	(word_FFD4EA).w,d2
	mulu.w	#$C,d2
	move.w	#0,(word_FFD4E8).w
	move.w	#$B,d3
.FB9AE
	move.b	0(a0,d2.w),d0
	beq.w	.FB9BA
	bra.w	.FB9C2
.FB9BA
	move.b	#$2D,d0
	subq.w	#1,(word_FFD4E8).w
.FB9C2
	move.b	d0,(a1)+
	addq.w	#1,(word_FFD4E8).w
	addq.w	#1,d2
	dbf	d3,.FB9AE
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FB9D4	;94 only. Name entry: store the name in save RAM (sub_FBA76, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFD45A,a0
	move.w	(word_FFD4EA).w,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#word_FFD4DA,a1
	move.w	#$B,d4
.FB9F2
	cmpi.b	#$2D,(a1)
	bne.w	.FB9FE
	move.b	#0,(a1)
.FB9FE
	move.b	(a1)+,d1
	cmp.b	(a0)+,d1
	bne.w	.FBA0E
	dbf	d4,.FB9F2
	bra.w	.FBA4C
.FBA0E
	movea.l	#$FFFFD45A,a0
	move.w	(word_FFD4EA).w,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#word_FFD4DA,a1
	move.w	#$B,d4
.FBA28
	move.b	(a1)+,d1
	cmp.b	#$2D,d1
	bne.w	.FBA36
	move.b	#0,d1
.FBA36
	move.b	d1,(a0)+
	dbf	d4,.FBA28
	bsr.w	sub_F9C5E
	jsr	(sub_FBA76).l
	jsr	(MakeSRAMChecksum).l
.FBA4C
	movea.l	#word_FFD042,a5
	tst.w	(word_FFD4EE).w
	beq.w	.FBA60
	movea.l	#word_FFD044,a5
.FBA60
	tst.b	(word_FFD4DA).w
	bne.w	.FBA6C
	clr.w	(word_FFD4EA).w
.FBA6C
	move.w	(word_FFD4EA).w,(a5)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FBA76	;94 only. Write the name record (ReadSRAM / WriteSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2D7,d7
	moveq	#0,d0
	moveq	#4,d1
	movea.l	#ThreeStars,a0
	move.w	(word_FFD4EA).w,d6
.FBA8C
	clr.w	d5
	jsr	(ReadSRAM).l
	cmp.b	1(a0),d6
	bne.w	.FBAA2
	clr.b	1(a0)
	st	d5
.FBAA2
	cmp.b	3(a0),d6
	bne.w	.FBAB0
	clr.b	3(a0)
	st	d5
.FBAB0
	tst.w	d5
	beq.w	.FBABC
	jsr	(WriteSRAM).l
.FBABC
	addq.l	#4,d0
	dbf	d7,.FBA8C
	move.w	#$1B,d7
	move.l	#$B60,d0
	moveq	#$10,d1
	movea.l	#ThreeStars,a0
	move.w	(word_FFD4EA).w,d6
.FBAD8
	clr.w	d5
	jsr	(ReadSRAM).l
	cmp.b	1(a0),d6
	bne.w	.FBAEE
	clr.b	1(a0)
	st	d5
.FBAEE
	cmp.b	3(a0),d6
	bne.w	.FBAFC
	clr.b	3(a0)
	st	d5
.FBAFC
	cmp.b	5(a0),d6
	bne.w	.FBB0A
	clr.b	5(a0)
	st	d5
.FBB0A
	cmp.b	7(a0),d6
	bne.w	.FBB18
	clr.b	7(a0)
	st	d5
.FBB18
	cmp.b	9(a0),d6
	bne.w	.FBB26
	clr.b	9(a0)
	st	d5
.FBB26
	cmp.b	$B(a0),d6
	bne.w	.FBB34
	clr.b	$B(a0)
	st	d5
.FBB34
	tst.w	d5
	beq.w	.FBB40
	jsr	(WriteSRAM).l
.FBB40
	addi.l	#$10,d0
	dbf	d7,.FBAD8
	move.l	#$D20,d0
	move.w	(word_FFD4EA).w,d3
	asl.w	#4,d3
	ext.l	d3
	add.l	d3,d0
	moveq	#$10,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	move.l	a0,-(sp)
	move.w	#$F,d3
.FBB6E
	clr.b	(a0)+
	dbf	d3,.FBB6E
	movea.l	(sp)+,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FBB88	;94 only. With user records on (OptUserRec 0): the name entry (loc_FB018) for the pads in use. Called from PeriodOver (hockey94_06)
	tst.w	(OptUserRec).w
	bne.w	.FBBDC
	clr.w	(word_FFD042).w
	clr.w	(word_FFD044).w
	tst.w	(cont1team).w
	beq.w	.FBBB0
	move.w	(cont1team).w,(word_FFD4EE).w
	subq.w	#1,(word_FFD4EE).w
	jsr	(loc_FB018).l
.FBBB0
	tst.w	(cont2team).w
	beq.w	.FBBDC
	movem.w	d0,-(sp)
	move.w	(cont1team).w,d0
	cmp.w	(cont2team).w,d0
	movem.w	(sp)+,d0
	beq.w	.FBBDC
	move.w	(cont2team).w,(word_FFD4EE).w
	subq.w	#1,(word_FFD4EE).w
	jsr	(loc_FB018).l
.FBBDC
	rts
sub_FBBDE	;94 only. Name entry helper
	movem.w	d0,-(sp)
	move.w	(word_FFD044).w,d0
	tst.w	(word_FFD4EE).w
	beq.w	.FBBF2
	move.w	(word_FFD042).w,d0
.FBBF2
	cmp.w	(word_FFD4EA).w,d0
	bne.w	.FBC0E
	move.w	#1,d0
	tst.w	(sp)
	bpl.w	.FBC08
	move.w	#$FFFF,d0
.FBC08
	add.w	d0,(word_FFD4EA).w
	clr.w	d0
.FBC0E
	movem.w	(sp)+,d0
	rts
sub_FBC14	;no IDA label. "Record Holders" menu item (hockey94_11 menu lists): the save RAM record holders (sub_FBD86 ... sub_FC282)
	move.w	#0,d0
	move.w	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	$BE,1,1
	movea.l	#unk_E9A80,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,'!',1
	movea.l	#unk_E9ED6,a0
	movea.l	a0,a1
.FBC62
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BD,$B,1
	move.w	#$12,d0
	move.w	#7,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BD,$E,2,'Record',$BD,$D,5,'Holders',$BD,1,9
	jsr	(printz2).l	;IDA hid this
	String	$F8,6,3,5,8,$F9,1,'Name',$F9,0
	bsr.w	sub_F9C68	;IDA hid this
	clr.w	(word_FFBF12).w
	bclr	#6,(word_FFC2F8).w
	bsr.w	sub_FC282
	bset	#6,(word_FFC2F8).w
	bsr.w	sub_FC282
	bsr.w	sub_FC184
	bsr.w	sub_FBD86
	bsr.w	sub_FBEA4
.FBCF0
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d3
	beq.w	.FBD10
	jmp	ExitAttributeScreen2
.FBD10
	tst.w	(word_FFBF12).w
.FBD14
	bne.w	.FBD36
	btst	#6,d3
	beq.w	.FBD36
.FBD20
	btst	#5,d3
	beq.w	.FBD36
	bsr.w	sub_FE6D2
	bsr.w	sub_FC184
.FBD30
	bsr.w	sub_FBEA4
	bra.s	.FBCF0
.FBD36
	btst	#3,d1
	beq.w	.FBD58
	cmpi.w	#2,(word_FFBF12).w
	beq.s	.FBCF0
	bsr.w	sub_FBFA0
	addq.w	#1,(word_FFBF12).w
	bsr.w	sub_FBD86
	bsr.w	sub_FBD7A
	bra.s	.FBCF0
.FBD58
	btst	#2,d1
	beq.s	.FBCF0
	tst.w	(word_FFBF12).w
	beq.s	.FBCF0
	bsr.w	sub_FBFA0
	subq.w	#1,(word_FFBF12).w
	bsr.w	sub_FBD86
	bsr.w	sub_FBD7A
	bra.w	.FBCF0
	dc.b	$4E	;N
	dc.b	$75	;u
sub_FBD7A	;94 only. Record Holders helper (loc_FBFDE)
	tst.w	(word_FFBF12).w
	beq.w	sub_FBEA4
	bra.w	loc_FBFDE
sub_FBD86	;94 only. Record Holders: the record titles (unk_FBDB2, unk_FBE04, unk_FBE54)
	movea.l	#unk_FBDB2,a1
	tst.w	(word_FFBF12).w
	beq.w	.FBDAA
	movea.l	#unk_FBE54,a1
	cmpi.w	#2,(word_FFBF12).w
	beq.w	.FBDAA
	movea.l	#unk_FBE04,a1
.FBDAA
	jsr	(print2).l
	rts
unk_FBDB2	dc.b	0	;IDA name. sub_FBD86 Strings
	dc.b	$52	;R
	dc.b	$F8,6,3,$10,8,$F9,1,$20,$20,$20
	dc.b	$57	;W
	dc.b	$69	;i
	dc.b	$6E	;n
	dc.b	$20
	dc.b	$25	;%
	dc.b	$20,$20,$20
	dc.b	$57	;W
	dc.b	$69	;i
	dc.b	$6E	;n
	dc.b	$2D	;-
	dc.b	$4C	;L
	dc.b	$6F	;o
	dc.b	$73	;s
	dc.b	$73	;s
	dc.b	$2D	;-
	dc.b	$54	;T
	dc.b	$69	;i
	dc.b	$65	;e
	dc.b	$FD,4,$FC,$19
	dc.b	$55	;U
	dc.b	$73	;s
	dc.b	$65	;e
	dc.b	$20
	dc.b	$41	;A
	dc.b	$2B	;+
	dc.b	$43	;C
	dc.b	$20
	dc.b	$74	;t
	dc.b	$6F	;o
	dc.b	$20
	dc.b	$63	;c
	dc.b	$6C	;l
	dc.b	$65	;e
	dc.b	$61	;a
	dc.b	$72	;r
	dc.b	$20
	dc.b	$41	;A
	dc.b	$4C	;L
	dc.b	$4C	;L
	dc.b	$20
	dc.b	$77	;w
	dc.b	$69	;i
	dc.b	$6E	;n
	dc.b	$20
	dc.b	$72	;r
	dc.b	$65	;e
	dc.b	$63	;c
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$64	;d
	dc.b	$73	;s
	dc.b	$FD,$10,$FC,$1A,$20,$20
	dc.b	$4D	;M
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$65	;e
	dc.b	$20
	dc.b	$5D	;]
	dc.b	$F9,0
unk_FBE04	dc.b	0	;IDA name. sub_FBD86 Strings
	dc.b	$50	;P
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$47	;G
	dc.b	$6F	;o
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$73	;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
	dc.b	$54	;T
	dc.b	$65	;e
	dc.b	$61	;a
	dc.b	$6D	;m
	dc.b	$73	;s
	dc.b	$20,$20,$20,$20,$FD,4,$FC,$19,$20,$20,$20,$20
	dc.b	$54	;T
	dc.b	$45	;E
	dc.b	$41	;A
	dc.b	$4D	;M
	dc.b	$20
	dc.b	$4D	;M
	dc.b	$55	;U
	dc.b	$53	;S
	dc.b	$54	;T
	dc.b	$20
	dc.b	$57	;W
	dc.b	$49	;I
	dc.b	$4E	;N
	dc.b	$20
	dc.b	$54	;T
	dc.b	$4F	;O
	dc.b	$20
	dc.b	$51	;Q
	dc.b	$55	;U
	dc.b	$41	;A
	dc.b	$4C	;L
	dc.b	$49	;I
	dc.b	$46	;F
	dc.b	$59	;Y
	dc.b	$20,$20,$20,$20,$FD,$10,$FC,$1A
	dc.b	$5B	;[
	dc.b	$20
	dc.b	$4D	;M
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$65	;e
	dc.b	$20
	dc.b	$5D	;]
	dc.b	$F9,0
unk_FBE54	dc.b	0	;IDA name. sub_FBD86 Strings
	dc.b	$50	;P
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$53	;S
	dc.b	$61	;a
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$73	;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
	dc.b	$54	;T
	dc.b	$65	;e
	dc.b	$61	;a
	dc.b	$6D	;m
	dc.b	$73	;s
	dc.b	$20,$20,$20,$20,$FD,4,$FC,$19,$20,$20,$20,$20
	dc.b	$54	;T
	dc.b	$45	;E
	dc.b	$41	;A
	dc.b	$4D	;M
	dc.b	$20
	dc.b	$4D	;M
	dc.b	$55	;U
	dc.b	$53	;S
	dc.b	$54	;T
	dc.b	$20
	dc.b	$57	;W
	dc.b	$49	;I
	dc.b	$4E	;N
	dc.b	$20
	dc.b	$54	;T
	dc.b	$4F	;O
	dc.b	$20
	dc.b	$51	;Q
	dc.b	$55	;U
	dc.b	$41	;A
	dc.b	$4C	;L
	dc.b	$49	;I
	dc.b	$46	;F
	dc.b	$59	;Y
	dc.b	$20,$20,$20,$20,$FD,$10,$FC,$1A
	dc.b	$5B	;[
	dc.b	$20
	dc.b	$4D	;M
	dc.b	$6F	;o
	dc.b	$72	;r
	dc.b	$65	;e
	dc.b	$20,$20,$F9,0
sub_FBEA4	;94 only. Record Holders: the rows (sub_FC136)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz2).l
	String	$F8,4,2,2,$A,$F9,0
	move.w	#6,d7	;IDA hid this
	movea.l	#$FFFFD542,a0	;IDA hid this
	movea.l	#$FFFFD54A,a2
	movea.l	#ThreeStars,a5
.FBECE
	move.w	#2,(printx).w
	move.b	(a0)+,d0
	ext.w	d0
	move.b	0(a2,d0.w),d5
	asl.w	#4,d0
	move.b	$A(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	$B(a5,d0.w),d4
	move.w	d4,-(sp)
	move.b	$C(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	$D(a5,d0.w),d4
	move.w	d4,(word_FFBF4A).w
	move.b	8(a5,d0.w),d4
	lsl.w	#8,d4
	move.b	9(a5,d0.w),d4
	move.w	d4,(word_FFBF4E).w
	add.w	(word_FFBF4A).w,d4
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,(word_FFBF4C).w
	move.w	(sp)+,d4
	tst.w	d4
	beq.w	.FBF86
	bsr.w	sub_FC136
	move.w	#$13,(printx).w
	move.w	d0,-(sp)
	move.w	d5,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print2).l
	move.w	#$1A,(printx).w
	move.w	(word_FFBF4E).w,d0
	move.w	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(print2).l
	move.w	#$1F,(printx).w
	move.w	(word_FFBF4C).w,d0
	move.w	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(print2).l
	move.w	#$24,(printx).w
	move.w	(word_FFBF4A).w,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	move.w	(sp)+,d0
	bra.w	.FBF8C
.FBF86
	movea.l	#unk_FC100,a1
.FBF8C
	jsr	(print2).l
	addq.w	#2,(printy).w
	dbf	d7,.FBECE
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FBFA0	;94 only. Record Holders helper
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	move.w	(printm).w,-(sp)
	jsr	(printz2).l
	String	$F8,4,2,0,$A
	move.w	#$28,d0
	move.w	#$12,d1
	jsr	(eraser).l
	move.w	(sp)+,(printm).w
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
loc_FBFDE	;IDA label. Record Holders: the rows of the other page (sub_FC136)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz2).l
	String	$F8,4,2,2,$A,$F9,0
	move.w	#6,d7	;IDA hid this
	movea.l	#$FFFFD532,a0	;IDA hid this
	cmpi.w	#1,(word_FFBF12).w
	beq.w	.FC00C
	movea.l	#$FFFFD53A,a0
.FC00C
	movea.l	#ThreeStars,a2
.FC012
	move.w	#2,(printx).w
	move.b	(a0)+,d0
	ext.w	d0
	asl.w	#4,d0
	move.b	0(a2,d0.w),d5
	cmpi.w	#1,(word_FFBF12).w
	beq.w	.FC030
	move.b	4(a2,d0.w),d5
.FC030
	tst.b	d5
	beq.w	.FC0E6
	bsr.w	sub_FC136
	move.w	#$12,(printx).w
	move.w	d0,-(sp)
	cmpi.w	#1,(word_FFBF12).w
	bne.w	.FC054
	move.b	0(a2,d0.w),d0
	bra.w	.FC058
.FC054
	move.b	4(a2,d0.w),d0
.FC058
	andi.w	#$FF,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print2).l
	move.w	(sp)+,d0
	move.w	#$19,(printx).w
	movea.l	#unk_FC128,a1
	movea.l	#mesarea,a3
	bsr.w	sub_F997A
	move.w	d0,-(sp)
	cmpi.w	#1,(word_FFBF12).w
	bne.w	.FC098
	move.b	1(a2,d0.w),d0
	bra.w	.FC09C
.FC098
	move.b	5(a2,d0.w),d0
.FC09C
	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	bsr.w	sub_FA880
	movea.l	#unk_FC12E,a1
	movea.l	#mesarea,a3
	jsr	(appstring).l
	movea.l	#mesarea,a1
	move.w	(sp)+,d0
	cmpi.w	#1,(word_FFBF12).w
	bne.w	.FC0D6
	move.b	2(a2,d0.w),d0
	bra.w	.FC0DA
.FC0D6
	move.b	6(a2,d0.w),d0
.FC0DA
	andi.w	#$FF,d0
	bsr.w	sub_FA880
	bra.w	.FC0EC
.FC0E6
	movea.l	#unk_FC100,a1
.FC0EC
	jsr	(print2).l
	addq.w	#2,(printy).w
	dbf	d7,.FC012
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FC100	dc.b	0	;IDA name. sub_FBEA4 data
	dc.b	$28	;(
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20
unk_FC128	dc.b	0	;IDA name. loc_FBFDE data
	dc.b	6
	dc.b	$62	;b
	dc.b	$79	;y
	dc.b	$20,0
unk_FC12E	dc.b	0	;IDA name. loc_FBFDE data
	dc.b	8,$20
	dc.b	$76	;v
	dc.b	$73	;s
	dc.b	$2E	;.
	dc.b	$20,0
sub_FC136	;94 only. Record Holders: print a value (sub_FA014)
	move.w	d7,-(sp)
	neg.w	d7
	addq.w	#7,d7
	addi.w	#$30,d7
	movea.l	#mesarea,a1
	move.w	#6,(a1)
	move.b	d7,2(a1)
	move.b	#$2E,3(a1)
	move.b	#$20,4(a1)
	move.b	#0,5(a1)
	jsr	(print2).l
	move.w	(sp)+,d7
	move.b	-1(a0),d2
	ext.w	d2
	movea.l	#mesarea,a1
	bclr	#7,(word_FFC2F8).w
	bsr.w	sub_FA014
	jmp	print2
sub_FC184	;94 only. Record Holders helper
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	movea.l	#$FFFFD54A,a1
	movea.l	#$FFFFD552,a6
	movea.l	#$FFFFD562,a5
	move.w	#7,d7
.FC1A4
	move.b	8(a0),d0
	lsl.w	#8,d0
	move.b	9(a0),d0
	move.b	$A(a0),d1
	lsl.w	#8,d1
	move.b	$B(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	.FC1C6
	clr.w	d0
	bra.w	.FC1CC
.FC1C6
	mulu.w	#$64,d0
	divu.w	d1,d0
.FC1CC
	move.b	d0,(a1)+
	move.b	$C(a0),(a6)+
	move.b	$D(a0),(a6)+
	adda.w	#$10,a0
	dbf	d7,.FC1A4
	movea.l	#$FFFFD542,a1
	move.l	a1,-(sp)
	move.w	#1,d0
	move.w	#6,d7
.FC1EE
	move.b	d0,(a1)+
	addq.w	#1,d0
	dbf	d7,.FC1EE
	movea.l	(sp),a1
	movea.l	#$FFFFD54A,a0
	movea.l	#$FFFFD552,a6
	movea.l	#$FFFFD562,a5
.FC20A
	movea.l	(sp),a1
	move.w	#5,d7
	clr.w	d6
.FC212
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	0(a0,d1.w),d0
	move.b	0(a0,d2.w),d3
	cmp.b	d3,d0
	bgt.w	.FC272
	blt.w	.FC264
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	0(a6,d1.w),d0
	move.w	0(a6,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	.FC272
	blt.w	.FC264
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	0(a5,d1.w),d0
	move.w	0(a5,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	.FC272
.FC264
	move.b	(a1),d0
	move.b	-1(a1),d1
	move.b	d0,-1(a1)
	move.b	d1,(a1)
	st	d6
.FC272
	dbf	d7,.FC212
	tst.w	d6
	bne.s	.FC20A
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FC282	;94 only. Record Holders: read the records (ReadSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movea.l	#$FFFFD532,a1
	btst	#6,(word_FFC2F8).w
	beq.w	.FC2B4
	movea.l	#$FFFFD53A,a1
.FC2B4
	move.l	a1,-(sp)
	move.w	#1,d0
	move.w	#6,d7
.FC2BE
	move.b	d0,(a1)+
	addq.w	#1,d0
	dbf	d7,.FC2BE
	movea.l	(sp),a1
	movea.l	#ThreeStars,a0
.FC2CE
	movea.l	(sp),a1
	move.w	#5,d7
	clr.w	d6
.FC2D6
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#4,d1
	asl.w	#4,d2
	move.b	0(a0,d1.w),d0
	move.b	0(a0,d2.w),d3
	btst	#6,(word_FFC2F8).w
	beq.w	.FC2FC
	move.b	4(a0,d1.w),d0
	move.b	4(a0,d2.w),d3
.FC2FC
	cmp.b	d3,d0
	bge.w	.FC310
	move.b	(a1),d0
	move.b	-1(a1),d1
	move.b	d0,-1(a1)
	move.b	d1,(a1)
	st	d6
.FC310
	dbf	d7,.FC2D6
	tst.w	d6
	bne.s	.FC2CE
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
loc_FC320	;IDA label. Playoff round screen: the two teams (" vs."), and the round. Jumped to from sub_187B8 (hockey94_10)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	$BF,3,2
	moveq	#$1B,d0	;IDA hid this
	moveq	#$C,d1
	jsr	(Framer).l
	lea	unk_FC466(pc),a1
	jsr	(printbig).l
	move.w	(BA_Skater_Offset).w,d0
	movea.l	#HmShots,a2
	tst.w	(BA_Team).w
	beq.w	.FC366
	movea.l	#AwShots,a2
.FC366
	jsr	(FormatPlayerNameWithAttrib).l
	move.w	(printx).w,-(sp)
	jsr	(print).l
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#6,(printx).w
	jsr	(printz).l
	String	' vs.',$BF,4,7
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.FC3BA
	movea.l	#HmShots,a2
.FC3BA
	jsr	(FormatPlayerNameWithAttrib).l
	jsr	(print).l
	jsr	(printz).l
	String	$BF,4,9
	movea.l	#HmShots,a1
	movea.l	$1E(a1),a1
	adda.w	4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).w
	move.w	(word_FFD574).w,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	$BF,4,$A
	movea.l	#AwShots,a1	;IDA hid this
	movea.l	$1E(a1),a1	;IDA hid this
	adda.w	4(a1),a1	;IDA hid this
	jsr	(print).l	;IDA hid this
	move.w	#$15,(printx).w	;IDA hid this
	move.w	(word_FFD576).w,d0
	move.w	#3,d1	;IDA hid this
	jsr	(PushNumberWidth).l	;IDA hid this
	jsr	(print).l	;IDA hid this
	jsr	(printz).l	;IDA hid this
	String	$BF,4,$C,'Round '
	move.w	(word_FFD578).w,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FC466	dc.b	0	;IDA name. loc_FC320 big text
	dc.b	$16,$BF,4,3
	dc.b	$53	;S
	dc.b	$48	;H
	dc.b	$4F	;O
	dc.b	$4F	;O
	dc.b	$54	;T
	dc.b	$4F	;O
	dc.b	$55	;U
	dc.b	$54	;T
	dc.b	$20
	dc.b	$4D	;M
	dc.b	$4F	;O
	dc.b	$44	;D
	dc.b	$45	;E
	dc.b	$BF,4,5,0
sub_FC47C	;94 only. Clear the player structs (SortCords) and the shootout state. Called from hockey94_08
	movea.l	#SortCords,a0
	move.w	#$3FF,d0
.FC486
	clr.w	(a0)+
	dbf	d0,.FC486
	clr.w	(word_FFDED0).w
	move.w	#1,(word_FFD578).w
	bclr	#3,(word_FFC2FA).w
	clr.w	(word_FFD574).w
	clr.w	(word_FFD576).w
	clr.w	(word_FFD586).w
	clr.w	(word_FFD594).w
.FC4AC
	bsr.w	sub_FC570
	move.w	#1,(word_FFD594).w
	bsr.w	sub_FC570
	clr.w	(word_FFD594).w
	rts
sub_FC4C0	;94 only. Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, sub_FE756), or the end (ExitToOpening). Called from logic94_4
	btst	#3,(word_FFC2FA).w
	beq.w	.FC4D0
	jmp	ExitToOpening
.FC4D0
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_FE756
	move.w	(word_FFD594).w,(BA_Team).w
	move.w	#$B,(BA_Goalie_SCnum).w
	movea.l	#$FFFFD57A,a0
	tst.w	(word_FFD594).w
	beq.w	.FC4FE
	move.w	#5,(BA_Goalie_SCnum).w
	movea.l	#$FFFFD588,a0
.FC4FE
	move.w	(word_FFD586).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),(BA_Skater_Offset).w
	bclr	#2,(byte_FFB7AC).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FC516	;94 only. Shootout: count the goals and end it when one team cannot catch up (sub_FD618, high ROM). Called from sub_F37C (logic94_4)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#0,(word_FFD594+1).w
	beq.w	.FC54A
	cmpi.w	#5,(word_FFD578).w
	blt.w	.FC54A
	move.w	(word_FFD574).w,d0
	cmp.w	(word_FFD576).w,d0
	beq.w	.FC54A
	bset	#3,(word_FFC2FA).w
	jsr	(sub_FD618).l
	bra.w	.FC56A
.FC54A
	eori.w	#1,(word_FFD594).w
	bne.w	.FC56A
	addq.w	#1,(word_FFD586).w
	cmpi.w	#5,(word_FFD586).w
	blt.w	.FC566
	clr.w	(word_FFD586).w
.FC566
	addq.w	#1,(word_FFD578).w
.FC56A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FC570	;94 only. Part of sub_FC47C
	movea.l	#word_FFD586,a0
	move.w	(HomeTeam).w,d0
	tst.w	(word_FFD594).w
	beq.w	.FC58C
	move.w	(VisTeam).w,d0
	movea.l	#word_FFD594,a0
.FC58C
	movea.l	#$30E,a1
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1
	adda.w	6(a1),a1
	move.w	#5,d0
.FC5A0
	clr.w	d1
	move.b	(a1)+,d1
	subq.w	#1,d1
	move.w	d1,-(a0)
	dbf	d0,.FC5A0
	rts
sub_FC5AE	;94 only. Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA (penalty94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BF,1,$D
	move.w	#6,d1
	move.w	#$1E,d0
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BF,2,$E,'SHOOTOUT WON BY'
	addq.w	#2,(printy).w
	move.w	(HomeTeam).w,d1
	move.w	(word_FFD574).w,d0
	cmp.w	(word_FFD576).w,d0
	bgt.w	.FC5FE
	move.w	(VisTeam).w,d1
.FC5FE
	asl.w	#2,d1
	movea.l	#$30E,a1
	movea.l	0(a1,d1.w),a1
	adda.w	4(a1),a1
	move.w	#2,(printx).w
	jsr	(printbig).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FC620	;no IDA label. Shootout shooters menu item (hockey94_11 menu lists): pick the 3 shooters of each team
	btst	#0,(word_FFC2FA).w
	beq.w	loc_FC6C6
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l
	clr.w	(DispAttribCtr).w
	clr.w	(PlayerScrollCtr).w
	jsr	(printz2).l
	String	$FF,2,$FD,0,$FC
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bsr.w	sub_FCA1E
	bsr.w	sub_FCA28
	move.w	#0,(word_FFD5B8).w
loc_FC666	;IDA label. Shootout shooters: redraw (sub_FC986, sub_FCAB8, sub_FCB1A)
	bsr.w	sub_FC986
	bsr.w	sub_FCB1A
	bsr.w	sub_FCAB8
loc_FC672	;IDA label. Shootout shooters: the input loop
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	loc_FC6C6
	move.w	#1,d0
	btst	#1,d1
	bne.w	loc_FC952
	move.w	#$FFFF,d0
	btst	#0,d1
	bne.w	loc_FC952
	move.w	#0,d0
	btst	#2,d1
	bne.w	loc_FC946
	move.w	#5,d0
	btst	#3,d1
	bne.w	loc_FC946
	btst	#5,d1
	bne.w	loc_FC6CC
	bra.s	loc_FC672
loc_FC6C6	;IDA label. Leave (ExitAttributeScreen2)
	jmp	ExitAttributeScreen2
loc_FC6CC	;IDA label. Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7
	movea.l	#$FFFFD57A,a0
	cmpa.l	#HmShots,a2
	beq.w	.FC6E6
	movea.l	#$FFFFD588,a0
.FC6E6
	move.w	(word_FFD5B8).w,d0
	asl.w	#1,d0
	move.w	0(a0,d0.w),d6
	jsr	(ReadAttributeNibble).l
	move.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
	subq.w	#1,d0
	cmpi.w	#5,(word_FFD5B8).w
	bne.w	.FC712
	move.w	d1,d0
	subq.w	#1,d0
	clr.w	d1
.FC712
	move.w	d0,(word_FFD5B6).w
	clr.w	(PlayerScrollCtr).w
	clr.w	(VertLineScrolling).w
	movea.w	#(Satt-M68K_RAM),a0
	clr.w	d2
.FC724
	move.b	d1,0(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.FC732
	move.w	d2,(VertLineScrolling).w
.FC732
	addq.w	#1,d1
	addq.w	#1,d2
	dbf	d0,.FC724
	bsr.w	sub_FCA04
	jsr	(printz2).l
	String	$F8,0,3,1,0
	move.w	#$12,d0
	move.w	#3,d1
	jsr	(Framer).l
	jsr	(printz2).l
	String	$FD,$15,$FC
	move.w	#$12,d0	;IDA hid this
	move.w	#3,d1	;IDA hid this
	jsr	(Framer).l	;IDA hid this
	jsr	(printz2).l	;IDA hid this
	String	$F8,4,2,2,1,'{Select Player}'
	clr.w	d0
	bra.w	.FC7EE
.FC796
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	loc_FC666
	btst	#5,d1
	bne.w	.FC820
	moveq	#1,d0
	btst	#1,d1
	bne.w	.FC7EE
	btst	#3,d1
	bne.w	.FC7DE
	moveq	#-1,d0
	btst	#0,d1
	bne.w	.FC7EE
	btst	#2,d1
	bne.w	.FC7DE
	bra.s	.FC796
.FC7DE
	add.w	(DispAttribCtr).w,d0
	bmi.s	.FC796
	move.w	d0,(DispAttribCtr).w
.FC7E8
	bsr.w	sub_FC850
.FC7EC
	bra.s	.FC796
.FC7EE
	add.w	(VertLineScrolling).w,d0
	bmi.s	.FC796
	cmp.w	(word_FFD5B6).w,d0
	bgt.s	.FC796
.FC7FA
	move.w	d0,(VertLineScrolling).w
	cmp.w	(PlayerScrollCtr).w,d0
	bgt.w	.FC80A
	move.w	d0,(PlayerScrollCtr).w
.FC80A
	subq.w	#5,d0
	cmp.w	(PlayerScrollCtr).w,d0
	ble.w	.FC818
	move.w	d0,(PlayerScrollCtr).w
.FC818
	bsr.w	sub_FC850
	bra.w	.FC796
.FC820
	movea.w	#(Satt-M68K_RAM),a3
	adda.w	(VertLineScrolling).w,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(word_FFD5B8).w,d2
	movea.l	#$FFFFD57A,a0
	cmpa.l	#HmShots,a2
	beq.w	.FC846
	movea.l	#$FFFFD588,a0
.FC846
	asl.w	#1,d2
	move.w	d0,0(a0,d2.w)
	bra.w	loc_FC666
sub_FC850	;94 only. Shootout shooters: the player list rows (getNameandAttrib)
	jsr	(printz).l
	String	$BE,$16,1
.FC85C
	movea.l	#unk_1940E,a1
	cmpi.w	#5,(word_FFD5B8).w
	bne.w	.FC872
	movea.l	#unk_19570,a1
.FC872
	move.w	(DispAttribCtr).w,d0
	bra.w	.FC87E
.FC87A
	adda.w	(a1),a1
	addq.w	#4,a1
.FC87E
	tst.w	(a1)
	dbmi	d0,.FC87A
	bpl.w	.FC88E
	subq.w	#1,(DispAttribCtr).w
	bra.s	.FC85C
.FC88E
	cmpa.l	#unk_1940E,a1
	bne.w	.FC89E
	movea.l	#unk_FC91A,a1
.FC89E
	cmpa.l	#unk_19570,a1
	bne.w	.FC8AE
	movea.l	#unk_FC930,a1
.FC8AE
	jsr	(print).l
	move.l	(a1),d4
	movea.w	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).w,d2
	move.w	(word_FFD5B6).w,d1
	sub.w	d2,d1
	cmp.w	#5,d1
	bls.w	.FC8CE
	moveq	#5,d1
.FC8CE
	move.w	#2,(printy).w
.FC8D4
	jsr	(printz2).l
	String	$FE,4,$FD,5,$FA,1,'                      ',$FD,5
	cmp.w	(VertLineScrolling).w,d2
	bne.w	.FC906
	move.w	d7,(printa).w
.FC906
	clr.w	d0
	move.b	0(a3,d2.w),d0
	jsr	(getNameandAttrib).l
	addq.w	#1,d2
	dbf	d1,.FC8D4
	rts
unk_FC91A	dc.b	0	;IDA name. sub_FC850 data
	dc.b	$12,$20,$20,$20,$20
	dc.b	$4F	;O
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$72	;r
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$6C	;l
	dc.b	$20,$20,$20,$20
	dc.b	$5D	;]
	dc.b	$1F
	dc.b	$3A	;:
	dc.b	0,$A
unk_FC930	dc.b	0	;IDA name. sub_FC850 data
	dc.b	$12,$20,$20,$20,$20
	dc.b	$4F	;O
	dc.b	$76	;v
	dc.b	$65	;e
	dc.b	$72	;r
	dc.b	$61	;a
	dc.b	$6C	;l
	dc.b	$6C	;l
	dc.b	$20,$20,$20,$20
	dc.b	$5D	;]
	dc.b	$1B,$F,0,$A
loc_FC946	;IDA label. Shootout shooters input
	cmp.w	(word_FFD5B8).w,d0
	beq.w	loc_FC672
	bra.w	loc_FC976
loc_FC952	;IDA label. Shootout shooters input
	cmpi.w	#5,(word_FFD5B8).w
	beq.w	loc_FC672
	add.w	(word_FFD5B8).w,d0
	bmi.w	.FC972
	cmp.w	#5,d0
	blt.w	loc_FC976
	clr.w	d0
	bra.w	loc_FC976
.FC972
	move.w	#4,d0
loc_FC976	;IDA label. Shootout shooters: redraw the shooters
	move.w	d0,(word_FFD5B8).w
	bsr.w	sub_FCB1A
	bsr.w	sub_FCAB8
	bra.w	loc_FC672
sub_FC986	;94 only. Shootout shooters background and "Shootout" title
	bsr.w	sub_FCA04
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	$FD,0,0
	movea.l	#unk_54E24,a1	;IDA hid this
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#1,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	$BE,7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BE,$A,4,'  Shootout  ',$BE,$F,1
	clr.w	d0
	cmpa.w	#$C6CE,a2
	beq.w	.FC9FE
	move.w	#$2C,d0
.FC9FE
	jmp	PrintTeamData
sub_FCA04	;94 only. Shootout shooters helper
	jsr	(printz).l
	String	$BE,0,0
	moveq	#$28,d0	;IDA hid this
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	eraser
sub_FCA1E	;94 only. Shootout shooters helper
	clr.w	(word_FFBD82).w
	clr.w	(word_FFBDA2).w
	rts
sub_FCA28	;94 only. Shootout shooters: "Shooters" 1. 2. 3.
	jsr	(printz2).l
	String	$FF,2,$FD,0,$FC,$A
	jsr	(printz2).l
	String	$FE,4
	jsr	(printz2).l
	String	$FD,7,$FC,$C,'Shooters'
.FCA54
	jsr	(printz2).l
	String	$FD,3,$FC,$E,'1. '
	jsr	(printz2).l	;IDA hid this
	String	$FD,3,$FC,$10,'2. '
	jsr	(printz2).l	;IDA hid this
	String	$FD,3,$FC,$12,'3. '
	jsr	(printz2).l	;IDA hid this
	String	$FD,3,$FC,$14,'4. '
	jsr	(printz2).l	;IDA hid this
	String	$FD,3,$FC,$16,'5. '
	jsr	(printz2).l	;IDA hid this
	String	$FD,$1A,$FC,$C,'Goalie'
	rts
sub_FCAB8	;94 only. Shootout shooters: the selected player box (getname)
	jsr	(printz2).l
	String	$F8,4,2,8,7,$F9,1
	moveq	#$18,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printz2).l
	String	$FD,$15,$FC,8,$FE,6
	movea.l	#$FFFFD57A,a1
	cmpa.l	#HmShots,a2
	beq.w	.FCAF6
	movea.l	#$FFFFD588,a1
.FCAF6
	move.w	(word_FFD5B8).w,d0
	asl.w	#1,d0
	move.w	0(a1,d0.w),d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print2).l
	clr.w	(word_FFB030).w
	rts
sub_FCB1A	;94 only. Shootout shooters: the shooters' names (FormatPlayerNameShort)
	movem.l	d0-d7/a0-a6,-(sp)
.FCB1E
	jsr	(printz2).l
	String	$FD,6,$FC,$E,$FE,6
	move.w	#0,d1
	movea.l	#$FFFFD57A,a0
	cmpa.l	#HmShots,a2
	beq.w	.FCB46
	movea.l	#$FFFFD588,a0
.FCB46
	move.w	d1,d0
	asl.w	#1,d0
	move.w	0(a0,d0.w),d0
	jsr	(FormatPlayerNameShort).l
	move.w	(printx).w,-(sp)
	cmp.w	(word_FFD5B8).w,d1
	bne.w	.FCB66
	move.w	#2,(word_FFB030).w
.FCB66
	cmp.w	#5,d1
	bne.w	.FCB7A
	move.w	#$19,(printx).w
	move.w	#$E,(printy).w
.FCB7A
	jsr	(print2).l
	clr.w	(word_FFB030).w
	move.w	(sp)+,(printx).w
	addq.w	#2,(printy).w
	addq.w	#1,d1
	cmp.w	#6,d1
	blt.s	.FCB46
	movem.l	(sp)+,d0-d7/a0-a6
	rts
