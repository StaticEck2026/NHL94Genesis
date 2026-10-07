;	NHL 94 (retail) segment $1A264-$1AD8F
;	68k side of the sound driver, as 93 sound93 (same driver, revised): AllSndOff (93 p_turnoff), p_initfx (93
;	play_sfx_or_music_track), play_new_song, the 94 pad readers (ReadJoyData ... sub_1A4EE, run from MusicVB), MusicVB (93
;	p_music_vblank), UploadCommandBufferToZ80, ProcessOneMusicTrack and the event handlers, UpdateChannelFrequencyAndVolume, the 94
;	volume routine sub_1ABAA, Z80_LoadROM (93 p_initialZ80) and ClearAllTrackAndSFXSlots. The Z80 program (unk_1AD90, loaded by
;	Z80_LoadROM), the PCM sample table (unk_1B01C), the samples, the FM patches ($2C248) and the sound pointer table (unk_2C648) follow
;	from $1AD90; they are not in this segment (93: incbins after the driver).
;	94 changes from 93: sounds 0-$7A (93 0-$37) through a long pointer table (93 word offsets), 8 byte channel structs (93 6), a voice
;	volume word (+4) and the controller event handle_command_30, the vblank pad reading, and the Rev A 93 50 Hz tempo block.
;	Transcribed from lst/nhl94.bin.lst lines 61529-63138. Global names are the IDA names, or the 93 sound93 name where IDA has an auto
;	name or no label (IDA name in an ;IDA: comment). Locals are the IDA address (loc_1A27E -> .1A27E) or the 93 local (.fnum, .bendtab,
;	.veltab). IDA gaps: handle_command_30 ($1AC82-$1ACBF) is IDA dc.b, written as instructions; the tables are written as in 93.
;	RAM (ram_addrs.inc IDA names, 93 names): unk_FFD3D4 fm_track_slots (8 x 6 bytes), unk_FFD3A4 fm_channel_structs (94: 6 x 8 bytes:
;	+0 key, +1 note, +2 volume, +3 patch, +4 output channel, +5 age, +6 bit 0 on), unk_FFD1A4 fm_voice_usage_table (8 bytes per key:
;	word +0 pitch bend, +3 patch, word +4 volume), dword_FFD182 Z80_command_buffer (33 bytes, copied to Z80 RAM $02), unk_FFD187
;	per_channel_attenuation_table, byte_FFD180 music_needs_z80_update.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.

AllSndOff	;IDA name (93 p_turnoff, 92 audio stop). Silence everything: free all slots, key off and mute every output channel, send the buffer
	;and stop the PCM channel. Called from Begin and the game screens
	movem.l	d0-d7/a0-a2,-(sp)
	bsr.w	ClearAllTrackAndSFXSlots
	move.b	#$77,(dword_FFD182).w	;93 Z80_command_buffer: key off channels 0-2, 4-6
	move.b	#$77,(dword_FFD182+2).w	;volume change on 0-2, 4-6
	moveq	#6,d0
	movea.w	#(unk_FFD187-M68K_RAM),a0	;93 per_channel_attenuation_table: 7 volume bytes
.1A27E
	move.b	#$7F,(a0)+	;$7F = silent
	dbf	d0,.1A27E
	bsr.w	UploadCommandBufferToZ80
	bsr.w	ClearZ80SpecialEffectsFlags
	movem.l	(sp)+,d0-d7/a0-a2
locret_1A292	;IDA label. The shared rts; p_initfx and ProcessOneMusicTrack branch to it
	rts
p_initfx	;IDA name (93 play_sfx_or_music_track). Start sound d0 (0-$7A; 93 0-$37) in the track slot with the lowest pointer. $30 and up are
	;songs: the song already playing is stopped first (play_new_song). 94 takes the event stream from the long pointer table unk_2C648 (93 word
	;offsets) and also sets each voice volume (+4) to $7F. Called from sfx and song
	cmp.w	#$7A,d0
	bhi.s	locret_1A292	;out of range
	movem.l	d0-d3/a0-a2,-(sp)
	cmp.w	#$30,d0
	blt.w	.1A2AA
	bsr.w	play_new_song	;song: stop the current song
.1A2AA
	lea	(unk_FFD3D4).w,a1	;93 fm_track_slots: 8 x 6 bytes
	moveq	#7,d3
.1A2B0
	move.l	(a1),d1
	move.w	d3,d2
	movea.w	a1,a2
.1A2B6
	cmp.l	(a1),d1
	bgt.s	.1A2B0
	addq.w	#6,a1
	dbf	d3,.1A2B6
	tst.w	(a2)
	bpl.w	.1A2FE	;no free slot (lowest pointer is in use): do nothing
	asl.w	#2,d0
	lea	(unk_2C648).l,a0
	movea.l	0(a0,d0.w),a0
	move.l	a0,(a2)
	clr.w	4(a2)
	move.b	(a0),5(a2)	;first delay
	lea	(unk_FFD1A4).w,a0	;93 fm_voice_usage_table
	asl.w	#3,d2
	adda.w	d2,a0
	moveq	#7,d0	;the 8 midi channels of this track
.1A2E6
	clr.w	(a0)
	clr.b	2(a0)
	clr.b	3(a0)
	move.w	#$7F,4(a0)
	adda.w	#$40,a0
	dbf	d0,.1A2E6
.1A2FE
	movem.l	(sp)+,d0-d3/a0-a2
	rts
play_new_song	;IDA: sub_1A304 (93 name). Stop the song in progress: free the first slot whose pointer is at or past the first song ($30, off_2C708)
	;and key off its channels. Called from p_initfx, DoGameFrame (hockey94_01) and others
	movem.l	d0-d3/a0-a3,-(sp)
	move	sr,-(sp)
	move	#$2700,sr	;94: no interrupts while the slots change
	lea	(unk_FFD3D4).w,a1
	moveq	#7,d3
	movea.l	(off_2C708).l,a0
.1A31A
	cmpa.l	(a1),a0
	addq.w	#6,a1
	dble	d3,.1A31A
	bgt.w	.1A368	;none: no song playing
	clr.l	(dword_FFD182).w
	clr.b	(byte_FFD186).w
	move.l	#-1,-6(a1)	;free the slot
	moveq	#5,d1
	lea	(unk_FFD3A4).w,a2	;93 fm_channel_structs (94: 6 x 8 bytes)
.1A33C
	move.b	(a2),d2
	andi.w	#7,d2
	cmp.w	d2,d3
	bne.w	.1A35E
	bsr.w	ReleaseChannelAndNote
	move.b	4(a2),d0
	lea	(unk_FFD187).w,a1
	move.b	#$7F,0(a1,d0.w)
	bset	d0,(dword_FFD182+2).w
.1A35E
	addq.w	#8,a2
	dbf	d1,.1A33C
	bsr.w	UploadCommandBufferToZ80
.1A368
	move	(sp)+,sr
	movem.l	(sp)+,d0-d3/a0-a3
	rts
ReadJoyData	;IDA name. 94 only: read the pads every vblank (MusicVB). With FourWayPlay, pads 1-4 through the 4 way adaptor (sub_1A3B2 ...
	;sub_1A430) to byte_FFBEF6-byte_FFBEF9, else pads 1 and 2 (sub_1A470, sub_1A464)
	movem.l	d1/a0,-(sp)
	tst.w	(FourWayPlay).w
	beq.w	.1A39C
	bsr.s	sub_1A3B2
	move.b	d0,(byte_FFBEF6).w
	bsr.s	sub_1A3DC
	move.b	d0,(byte_FFBEF7).w
	bsr.w	sub_1A406
	move.b	d0,(byte_FFBEF8).w
	bsr.w	sub_1A430
	move.b	d0,(byte_FFBEF9).w
	bra.w	.1A3AC
.1A39C
	bsr.w	sub_1A470
	move.b	d0,(byte_FFBEF6).w
	bsr.w	sub_1A464
	move.b	d0,(byte_FFBEF7).w
.1A3AC
	movem.l	(sp)+,d1/a0
	rts
sub_1A3B2	;94 only. 4 way play pad 1: take the Z80 bus (sub_1A4EE if it is not granted), select pad 1 on port 2 and read it on port 1 (loc_1A456)
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$64,d0
.1A3BE
	btst	#0,(IO_Z80BUS).l
	beq.s	.1A3D0
	dbf	d0,.1A3BE
	bsr.w	sub_1A4EE
.1A3D0
	move.b	#$C,(IO_CT2_DATA+1).l
	bra.w	loc_1A456
sub_1A3DC	;94 only. 4 way play pad 2: take the Z80 bus (sub_1A4EE if it is not granted), select pad 2 on port 2 and read it on port 1 (loc_1A456)
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$64,d0
.1A3E8
	btst	#0,(IO_Z80BUS).l
	beq.s	.1A3FA
	dbf	d0,.1A3E8
	bsr.w	sub_1A4EE
.1A3FA
	move.b	#$1C,(IO_CT2_DATA+1).l
	bra.w	loc_1A456
sub_1A406	;94 only. 4 way play pad 3: take the Z80 bus (sub_1A4EE if it is not granted), select pad 3 on port 2 and read it on port 1 (loc_1A456)
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$64,d0
.1A412
	btst	#0,(IO_Z80BUS).l
	beq.s	.1A424
	dbf	d0,.1A412
	bsr.w	sub_1A4EE
.1A424
	move.b	#$2C,(IO_CT2_DATA+1).l
	bra.w	loc_1A456
sub_1A430	;94 only. 4 way play pad 4: take the Z80 bus (sub_1A4EE if it is not granted), select pad 4 on port 2 and read it on port 1 (loc_1A456)
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$64,d0
.1A43C
	btst	#0,(IO_Z80BUS).l
	beq.s	.1A44E
	dbf	d0,.1A43C
	bsr.w	sub_1A4EE
.1A44E
	move.b	#$3C,(IO_CT2_DATA+1).l
loc_1A456	;IDA label. Read the pad on port 1; branched to from sub_1A3B2 ... sub_1A430
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
	bra.w	loc_1A498
sub_1A464	;94 only. Read pad 2 (port 2). Falls into loc_1A47A
	movem.l	d1/a0,-(sp)
	lea	(IO_CT2_DATA+1).l,a0
	bra.s	loc_1A47A
sub_1A470	;94 only. Read pad 1 (port 1)
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
loc_1A47A	;IDA label. Take the Z80 bus (sub_1A4EE if it is not granted), then loc_1A498
	move.w	#$100,(IO_Z80BUS).l
	move.w	#$64,d0
.1A486
	btst	#0,(IO_Z80BUS).l
	beq.s	loc_1A498
	dbf	d0,.1A486
	bsr.w	sub_1A4EE
loc_1A498	;IDA label. Read a 3 button pad at a0 (TH low, then high), release the bus and return d0 = the buttons, the directions through unk_1A4DE
	moveq	#0,d0
	move.b	#0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	nop
	nop
	move.b	(a0),d1
	move.w	#0,(IO_Z80BUS).l
	asl.b	#2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	unk_1A4DE(pc),a0
	andi.b	#$F0,d0
	or.b	0(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
unk_1A4DE	;IDA name. Direction nibble table for loc_1A498: remaps the nibble when opposite directions are pressed together
	dc.b	0,1,2,1,4,5,6,6,8,9,$A,$A,8,9,$A,0
sub_1A4EE	;94 only. Reset the Z80 and wait for its bus
	move.w	#$100,(IO_Z80RES).l
	move.w	#$100,(IO_Z80BUS).l
.1A4FE
	btst	#0,(IO_Z80BUS).l
	bne.s	.1A4FE
	rts
MusicVB	;IDA name (93 p_music_vblank, 92 vblank handler). Read the pads (ReadJoyData, 94), clear the change bits, run the 8 track slots (d7 = track
	;7-0), send the buffer if anything changed and age the channels. 94 keeps the Rev A 93 50 Hz block: with word_FFDEF2 bit 0 set the slots run
	;again every 6th frame (word_FFD070). Called from the vblank handlers
	bsr.w	ReadJoyData
	clr.b	(byte_FFD180).w	;93 music_needs_z80_update
	clr.l	(dword_FFD182).w	;key off/on, volume, frequency bits
	clr.b	(byte_FFD186).w	;patch bits
.1A51A
	lea	(unk_FFD3D4).w,a5
	moveq	#7,d7
.1A520
	bsr.w	ProcessOneMusicTrack
	addq.w	#6,a5
	dbf	d7,.1A520
	btst	#0,(word_FFDEF2).w
	beq.w	.1A542
	subq.w	#1,(word_FFD070).w
	bpl.w	.1A542
	addq.w	#6,(word_FFD070).w
	bra.s	.1A51A
.1A542
	tst.b	(byte_FFD180).w
	beq.w	.1A54E	;nothing changed
	bsr.w	UploadCommandBufferToZ80
.1A54E
	movea.w	#(unk_FFD3A4-M68K_RAM),a0
	moveq	#5,d0
.1A554
	addq.b	#1,5(a0)	;age
	bne.w	.1A560
	subq.b	#1,5(a0)	;hold at $FF
.1A560
	addq.w	#8,a0
	dbf	d0,.1A554
	rts
z80_bus_release_delay	;IDA: loc_1A568 (93 name). Z80 busy: give the bus back, wait, then falls into UploadCommandBufferToZ80 to retry
	clr.w	(IO_Z80BUS).l
	moveq	#$64,d0
.1A570
	dbf	d0,.1A570
UploadCommandBufferToZ80	;IDA: sub_1A574 (93 name). Copy the 33 byte command buffer (dword_FFD182) to Z80 RAM $02 once the Z80 is idle (Z80 RAM $97 = 0, $96 = $7D)
	move.w	#$100,(IO_Z80BUS).l
.1A57C
	btst	#0,(IO_Z80BUS).l
	bne.s	.1A57C
	movea.l	#Z80_RAM,a0
	cmpi.b	#0,$97(a0)
	bne.s	z80_bus_release_delay
	cmpi.b	#$7D,$96(a0)
	bne.s	z80_bus_release_delay
	move.b	#$D1,$96(a0)
	move.b	#0,$97(a0)
	adda.w	#2,a0
	movea.w	#(dword_FFD182-M68K_RAM),a1
	moveq	#$20,d0
.1A5B2
	move.b	(a1)+,(a0)+
	dbf	d0,.1A5B2
	clr.w	(IO_Z80BUS).l
locret_1A5BE	;IDA label. The shared rts; handle_command_10 branches to it
	rts
ProcessOneMusicTrack	;IDA: sub_1A5C0 (93 name). Count down track slot a5 (track d7) and run every event that is due through command_jump_table. A 0
	;status ends the stream; a non-negative long at +2 is a loop pointer. Called from MusicVB
	subq.w	#1,4(a5)
	bpl.w	locret_1A292
.1A5C8
	tst.w	(a5)
	bmi.w	locret_1A292
	movea.l	(a5),a0
	addq.l	#4,(a5)
	clr.w	4(a5)
	move.b	4(a0),5(a5)
	move.b	1(a0),d0
	bne.w	.1A5F4
	st	(a5)
	tst.w	2(a0)
	bmi.w	locret_1A292
	move.l	2(a0),(a5)
	bra.s	.1A5C8
.1A5F4
	move.b	1(a0),d0
	andi.w	#$70,d0	;status bits 6-4
	lsr.w	#3,d0
	lea	command_jump_table(pc),a2
	adda.w	0(a2,d0.w),a2
	jsr	(a2)
	bra.s	ProcessOneMusicTrack
command_jump_table	;IDA: unk_1A60A (93 name). Event handlers by status bits 6-4, as offsets from the table. 94 adds handle_command_30
	dc.w	handle_command_00-command_jump_table
	dc.w	handle_command_10-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_30-command_jump_table
	dc.w	handle_command_40-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_60-command_jump_table
	dc.w	handle_command_skip-command_jump_table
handle_command_00	;IDA: loc_1A61A (93 name). Event $0x: key off note +2 on channel +1 bits 3-0 of track d7. Also entered from handle_command_10 (volume 0). Falls into ReleaseChannelAndNote
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	asl.w	#8,d0
	move.b	2(a0),d0
	movea.w	#(unk_FFD3D4-M68K_RAM),a2
	moveq	#5,d1
.1A632
	subq.w	#8,a2
	cmp.w	(a2),d0
	dbeq	d1,.1A632
	bne.w	locret_1A292
	btst	#0,6(a2)
	dbne	d1,.1A632
	beq.w	locret_1A292
ReleaseChannelAndNote	;IDA: sub_1A64C (93 name). Key off channel struct a2 if it is on. The PCM patches ($60 up) stop the PCM channel (ClearZ80SpecialEffectsFlags)
	bclr	#0,6(a2)
	beq.w	locret_1A292
	cmpi.b	#$60,3(a2)
	bge.w	ClearZ80SpecialEffectsFlags
	move.b	4(a2),d0
	bset	d0,(dword_FFD182).w
	st	(byte_FFD180).w
	rts
ClearZ80SpecialEffectsFlags	;IDA: sub_1A66E (93 name). Clear Z80 RAM $8E (byte_A0008E, the PCM rate byte written by UpdateChannelFrequencyAndVolume): stops the PCM channel
	move.w	#$100,(IO_Z80BUS).l
.1A676
	btst	#0,(IO_Z80BUS).l
	bne.s	.1A676
	clr.b	(byte_A0008E).l
	clr.w	(IO_Z80BUS).l
	rts
handle_command_10	;no IDA label (93 name). Event $1x: key on note +2 at volume +3 on channel +1 bits 3-0 of track d7 (volume 0 = key off). An FM
	;patch takes a free channel or the oldest one; a PCM patch ($60 up) sets the sample start / end (unk_1B01C, 93 pcm_sample_table) in Z80 RAM
	;$23-$28. Then the volume (sub_1ABAA) and the frequency (UpdateChannelFrequencyAndVolume)
	tst.b	3(a0)
	beq.s	handle_command_00	;volume 0: key off
	movea.w	#(unk_FFD3CC-M68K_RAM),a2
	lea	(unk_FFD1A4).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d6
	asl.w	#3,d0
	move.b	3(a3,d0.w),d0
	cmp.b	#$60,d0
	bge.w	.1A74E	;PCM patch
	subq.w	#8,a2
	moveq	#4,d1
	bra.w	.1A6C8
.1A6C0
	cmp.b	5(a2),d2
	bhi.w	.1A6CE
.1A6C8
	movea.w	a2,a4
	move.b	5(a4),d2
.1A6CE
	subq.w	#8,a2
	dbf	d1,.1A6C0
	moveq	#4,d1
	movea.w	#(unk_FFD3CC-M68K_RAM),a2
.1A6DA
	subq.w	#8,a2
	btst	#0,6(a2)
	dbeq	d1,.1A6DA
	bne.w	.1A6FC
	movea.w	a2,a4
	cmp.b	3(a4),d0
	dbeq	d1,.1A6DA
	beq.w	.1A720
	bra.w	.1A704
.1A6FC
	cmp.b	3(a4),d0
	beq.w	.1A720
.1A704
	movea.w	a4,a2
.1A706
	move.b	d0,3(a2)
	clr.w	d1
	move.b	4(a2),d1
	bset	d1,(byte_FFD186).w
	movea.w	#(unk_FFD19C-M68K_RAM),a4
	move.b	d0,0(a4,d1.w)
	st	(byte_FFD180).w
.1A720
	clr.b	5(a2)
	bset	#0,6(a2)
	move.b	d6,(a2)
	move.b	2(a0),1(a2)
	move.b	3(a0),2(a2)
	clr.w	d1
	move.b	4(a2),d1
	bset	d1,(dword_FFD182).w
	bset	d1,(dword_FFD182+1).w
	bsr.w	sub_1ABAA
	bra.w	UpdateChannelFrequencyAndVolume
.1A74E
	bset	#0,6(a2)
	beq.w	.1A760
	cmp.b	3(a2),d0
	ble.w	locret_1A5BE
.1A760
	move.b	d0,3(a2)
	clr.b	5(a2)
	move.b	d6,(a2)
	move.b	2(a0),1(a2)
	move.b	3(a0),2(a2)
	ext.w	d0
	subi.w	#$60,d0
	asl.w	#3,d0
	lea	unk_1B01C(pc),a1	;PCM sample start, end longs by patch - $60
	move.l	4(a1,d0.w),d1
	move.l	0(a1,d0.w),d0
	move.w	#$100,(IO_Z80BUS).l
.1A792
	btst	#0,(IO_Z80BUS).l
	bne.s	.1A792
	movea.l	#Z80_RAM,a1
	move.b	d0,$25(a1)
	lsr.w	#8,d0
	move.b	d0,$24(a1)
	swap	d0
	move.b	d0,$23(a1)
	move.b	d1,$28(a1)
	lsr.w	#8,d1
	move.b	d1,$27(a1)
	swap	d1
	move.b	d1,$26(a1)
	move.b	#$29,$96(a1)
	move.b	#0,$97(a1)
	clr.w	(IO_Z80BUS).l
	bsr.w	sub_1ABAA
UpdateChannelFrequencyAndVolume	;IDA: sub_1A7D8 (93 name). Set the frequency of channel struct a2 from its note and the pitch bend of its key (a3 =
	;voice table, word +0 = bend). Called from handle_command_60 and handle_command_10
	clr.l	d3
	move.b	1(a2),d3
	divu.w	#$C,d3	;d3 = octave, high word = note in the octave
	move.w	d3,-(sp)
	swap	d3
	add.w	d3,d3
	lea	.fnum(pc),a4
	move.w	0(a4,d3.w),d2
	clr.w	d1
	move.b	(a2),d1
	asl.w	#3,d1
	move.w	0(a3,d1.w),d3
	beq.w	.1A834
	moveq	#$C,d1
	cmpi.b	#$60,3(a2)
	bge.w	.1A81C
	move.b	3(a2),d1
	asl.w	#5,d1
	lea	($2C248).l,a4	;93 fm_instrument_patches: 32 bytes per patch
	move.b	$1E(a4,d1.w),d1	;byte $1E = pitch bend scale (IDA: byte_2C266-unk_2C248)
	ext.w	d1
.1A81C
	muls.w	d1,d3
	asr.l	#2,d3
	asr.w	#7,d3
	addi.w	#$C0,d3	;centre of .bendtab
	add.w	d3,d3
	lea	.bendtab(pc),a4
	mulu.w	0(a4,d3.w),d2
	asl.l	#1,d2
	swap	d2
.1A834
	move.w	(sp)+,d3
	cmpi.b	#$60,3(a2)
	bge.w	.1A860
	asl.w	#3,d3
	asl.w	#8,d3
	or.w	d3,d2
	clr.w	d3
	move.b	4(a2),d3
	bset	d3,(dword_FFD182+3).w
	add.w	d3,d3
	movea.w	#(unk_FFD18E-M68K_RAM),a4
	move.w	d2,0(a4,d3.w)
	st	(byte_FFD180).w
	rts
.1A860
	btst	#0,6(a2)
	beq.w	.1A88E
	move.w	#$100,(IO_Z80BUS).l
.1A872
	btst	#0,(IO_Z80BUS).l
	bne.s	.1A872
	neg.w	d3
	addq.w	#8,d3
	lsr.w	d3,d2
	move.b	d2,(byte_A0008E).l
	clr.w	(IO_Z80BUS).l
.1A88E
	rts
.fnum	;IDA: unk_1A890. frequency number of each note in the octave
	dc.w	$0146,$0159,$016E,$0184,$019B,$01B3,$01CD,$01E8,$0205,$0224,$0245,$0268
.bendtab	;IDA: unk_1A8A8. 385 factors, entry $C0 = $8000 (no bend)
	dc.w	$4000,$403B,$4076,$40B2,$40EE,$412A,$4166,$41A3,$41E0,$421D
	dc.w	$425A,$4297,$42D5,$4313,$4351,$438F,$43CE,$440D,$444C,$448B
	dc.w	$44CA,$450A,$454A,$458A,$45CA,$460B,$464C,$468D,$46CE,$4710
	dc.w	$4752,$4794,$47D6,$4818,$485B,$489E,$48E1,$4925,$4969,$49AD
	dc.w	$49F1,$4A35,$4A7A,$4ABF,$4B04,$4B4A,$4B8F,$4BD5,$4C1B,$4C62
	dc.w	$4CA9,$4CF0,$4D37,$4D7E,$4DC6,$4E0E,$4E56,$4E9F,$4EE8,$4F31
	dc.w	$4F7A,$4FC4,$500E,$5058,$50A2,$50ED,$5138,$5183,$51CE,$521A
	dc.w	$5266,$52B2,$52FF,$534C,$5399,$53E6,$5434,$5482,$54D0,$551F
	dc.w	$556E,$55BD,$560C,$565C,$56AC,$56FC,$574C,$579D,$57EE,$5840
	dc.w	$5891,$58E3,$5936,$5988,$59DB,$5A2E,$5A82,$5AD6,$5B2A,$5B7E
	dc.w	$5BD3,$5C28,$5C7D,$5CD3,$5D29,$5D7F,$5DD6,$5E2D,$5E84,$5EDB
	dc.w	$5F33,$5F8B,$5FE4,$603D,$6096,$60EF,$6149,$61A3,$61FD,$6258
	dc.w	$62B3,$630E,$636A,$63C6,$6423,$647F,$64DC,$653A,$6597,$65F6
	dc.w	$6654,$66B3,$6712,$6771,$67D1,$6831,$6892,$68F2,$6954,$69B5
	dc.w	$6A17,$6A79,$6ADC,$6B3F,$6BA2,$6C06,$6C6A,$6CCE,$6D33,$6D98
	dc.w	$6DFD,$6E63,$6EC9,$6F30,$6F97,$6FFE,$7066,$70CE,$7136,$719F
	dc.w	$7208,$7272,$72DC,$7346,$73B1,$741C,$7488,$74F4,$7560,$75CD
	dc.w	$763A,$76A7,$7715,$7783,$77F2,$7861,$78D0,$7940,$79B0,$7A21
	dc.w	$7A92,$7B04,$7B76,$7BE8,$7C5B,$7CCE,$7D41,$7DB5,$7E2A,$7E9F
	dc.w	$7F14,$7F89,$8000,$8076,$80ED,$8164,$81DC,$8254,$82CD,$8346
	dc.w	$83C0,$843A,$84B4,$852F,$85AA,$8626,$86A2,$871F,$879C,$881A
	dc.w	$8898,$8916,$8995,$8A14,$8A94,$8B14,$8B95,$8C16,$8C98,$8D1A
	dc.w	$8D9D,$8E20,$8EA4,$8F28,$8FAC,$9031,$90B7,$913D,$91C3,$924A
	dc.w	$92D2,$935A,$93E2,$946B,$94F4,$957E,$9609,$9694,$971F,$97AB
	dc.w	$9837,$98C4,$9952,$99E0,$9A6E,$9AFD,$9B8D,$9C1D,$9CAD,$9D3E
	dc.w	$9DD0,$9E62,$9EF5,$9F88,$A01C,$A0B0,$A145,$A1DA,$A270,$A306
	dc.w	$A39D,$A435,$A4CD,$A565,$A5FE,$A698,$A732,$A7CD,$A868,$A904
	dc.w	$A9A1,$AA3E,$AADC,$AB7A,$AC18,$ACB8,$AD58,$ADF8,$AE99,$AF3B
	dc.w	$AFDD,$B080,$B123,$B1C7,$B26C,$B311,$B3B7,$B45D,$B504,$B5AC
	dc.w	$B654,$B6FD,$B7A7,$B851,$B8FB,$B9A6,$BA52,$BAFF,$BBAC,$BC5A
	dc.w	$BD08,$BDB7,$BE67,$BF17,$BFC8,$C07A,$C12C,$C1DF,$C292,$C346
	dc.w	$C3FB,$C4B1,$C567,$C61D,$C6D5,$C78D,$C846,$C8FF,$C9B9,$CA74
	dc.w	$CB2F,$CBEC,$CCA8,$CD66,$CE24,$CEE3,$CFA2,$D063,$D124,$D1E5
	dc.w	$D2A8,$D36B,$D42E,$D4F3,$D5B8,$D67E,$D744,$D80C,$D8D4,$D99D
	dc.w	$DA66,$DB30,$DBFB,$DCC7,$DD93,$DE60,$DF2E,$DFFD,$E0CC,$E19D
	dc.w	$E26D,$E33F,$E411,$E4E5,$E5B9,$E68D,$E763,$E839,$E910,$E9E8
	dc.w	$EAC0,$EB9A,$EC74,$ED4F,$EE2A,$EF07,$EFE4,$F0C2,$F1A1,$F281
	dc.w	$F361,$F443,$F525,$F608,$F6EC,$F7D0,$F8B6,$F99C,$FA83,$FB6B
	dc.w	$FC54,$FD3E,$FE28,$FF13,$FF13
sub_1ABAA	;94 only. Set the volume of channel struct a2: note volume (+2) * the voice volume (voice table +4) / 128. FM: attenuation from
	;.veltab (volume / 8); PCM: Z80 RAM $83 (byte_A00083, at least 3). Called from handle_command_10 and handle_command_30
	movem.l	d0,-(sp)
	clr.w	d0
	move.b	2(a2),d0
	clr.w	d1
	move.b	(a2),d1
	asl.w	#3,d1
	mulu.w	4(a3,d1.w),d0
	lsr.w	#7,d0
	cmpi.b	#$60,3(a2)
	bge.w	.1AC00
	lea	.veltab(pc),a4
	lsr.w	#3,d0
	move.b	0(a4,d0.w),d0
	clr.w	d3
	move.b	4(a2),d3
	movea.w	#(unk_FFD187-M68K_RAM),a4
	move.b	d0,0(a4,d3.w)
	bset	d3,(dword_FFD182+2).w
	st	(byte_FFD180).w
	movem.l	(sp)+,d0
	rts
.veltab	;IDA: unk_1ABF0. attenuation by volume / 8 (93 handle_command_10 .veltab)
	dc.b	$1A,$18,$16,$14,$12,$10,$0E,$0C,$0A,$08,$06,$04,$03,$02,$01,$00
.1AC00
	move.w	#$100,(IO_Z80BUS).l
.1AC08
	btst	#0,(IO_Z80BUS).l
	bne.s	.1AC08
	lsr.b	#2,d0
	cmp.w	#3,d0
	bgt.w	.1AC1E
	moveq	#3,d0
.1AC1E
	move.b	d0,(byte_A00083).l
	clr.w	(IO_Z80BUS).l
	movem.l	(sp)+,d0
	rts
handle_command_40	;no IDA label (93 name). Event $4x: set the patch of channel +1 bits 3-0 of track d7 to +2 (voice table +3)
	lea	(unk_FFD1A4).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	asl.w	#3,d0
	move.b	2(a0),3(a3,d0.w)
	rts
handle_command_60	;no IDA label (93 name). Event $6x: set the pitch bend of channel +1 bits 3-0 of track d7 to word +2 - $2000, and update the frequency of every channel with that key
	lea	(unk_FFD1A4).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#3,d0
	move.w	2(a0),0(a3,d0.w)
	subi.w	#$2000,0(a3,d0.w)
	movea.w	#(unk_FFD3A4-M68K_RAM),a2
	moveq	#5,d0
.1AC70
	cmp.b	(a2),d4
	bne.w	.1AC7A
	bsr.w	UpdateChannelFrequencyAndVolume
.1AC7A
	addq.w	#8,a2
	dbf	d0,.1AC70
	rts
handle_command_30	;no IDA label (IDA dc.b). 94 only: event $3x, controller +2 = +3 on channel +1 bits 3-0 of track d7. Only controller 7
	;(volume) is used: set the voice volume (voice table +5) and update the volume of every channel with that key (sub_1ABAA)
	cmpi.b	#7,2(a0)
	beq.w	.1AC8E
	rts
.1AC8E
	lea	(unk_FFD1A4).w,a3
	move.b	1(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#3,d0
	move.b	3(a0),5(a3,d0.w)
	movea.w	#(unk_FFD3A4-M68K_RAM),a2
	moveq	#5,d0
.1ACAE
	cmp.b	(a2),d4
	bne.w	.1ACB8
	bsr.w	sub_1ABAA
.1ACB8
	addq.w	#8,a2
	dbf	d0,.1ACAE
	rts
handle_command_skip	;no IDA label (93 name). Events $2x, $5x and $7x: ignored
	rts
Z80_LoadROM	;IDA name (93 p_initialZ80, 92 initialization). Free all slots, load the Z80 program (unk_1AD90, $295 bytes) into Z80 RAM, build 29
	;tables of 256 bytes below Z80 RAM $2000 (unk_A02000; (x - $80) * 8 / n + $80 for n = 8-$24), then reset and start the Z80. Called from Begin
	movem.l	d0-d2/a0-a2,-(sp)
	bsr.w	ClearAllTrackAndSFXSlots
	move.w	#$100,(IO_Z80RES).l
	move.w	#$100,(IO_Z80BUS).l
.1ACDA
	btst	#0,(IO_Z80BUS).l
	bne.s	.1ACDA
	movea.l	#unk_1AD90,a1
	movea.l	#Z80_RAM,a2
	move.w	#$294,d0	;$295 bytes
.1ACF4
	move.b	(a1)+,(a2)+
	dbf	d0,.1ACF4
	movea.l	#unk_A02000,a2
	moveq	#8,d2
	move.l	#$1C,d3
.1AD08
	move.w	#$FF,d0
.1AD0C
	move.w	d0,d1
	subi.w	#$80,d1
	asl.w	#3,d1
	ext.l	d1
	divs.w	d2,d1
	addi.w	#$80,d1
	move.b	d1,-(a2)
	dbf	d0,.1AD0C
	clr.b	(a2)
	addq.w	#1,d2
	dbf	d3,.1AD08
	move.w	#0,(IO_Z80RES).l
	move.w	#0,(IO_Z80BUS).l
	move.w	#$1F4,d0
.1AD3E
	dbf	d0,.1AD3E
	move.w	#$100,(IO_Z80RES).l
	clr.b	(byte_FFD180).w
	movem.l	(sp)+,d0-d2/a0-a2
	rts
ClearAllTrackAndSFXSlots	;IDA: sub_1AD54 (93 name). Free the 8 track slots and reset the 6 channel structs (output channels 0, 1, 2, 4, 5, 6). Called from AllSndOff and Z80_LoadROM
	lea	(unk_FFD3D4).w,a0
	moveq	#7,d0
	moveq	#-1,d1
.1AD5C
	move.l	d1,(a0)
	addq.w	#6,a0
	dbf	d0,.1AD5C
	moveq	#5,d0
	movea.w	#(unk_FFD3D4-M68K_RAM),a0
.1AD6A
	subq.w	#8,a0
	move.b	d0,4(a0)
	cmp.w	#3,d0
	blt.w	.1AD7C
	addq.b	#1,4(a0)
.1AD7C
	st	3(a0)
	st	(a0)
	clr.b	1(a0)
	clr.b	6(a0)
	dbf	d0,.1AD6A
	rts
