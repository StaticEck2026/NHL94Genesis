# NHL 94 segment agent

This file is the rule set for one segment at a time. Do not rewrite it as a whole file. Edit it in place.

## Sources

- Listing: `lst/nhl94.bin.lst` in this repo. Open that file. Do not disassemble `lst/nhl94.bin`. Do not write a disassembler.
- The listing was exported from IDA as an LST in ASM68K / MRI mode. It has no address column. A `loc_`, `sub_`, or `unk_` name is the address. A named routine is at the instruction before the next address-bearing label. Confirm the org against `lst/nhl94.bin` before the first verify.
- Style source, in order: the matching file in `NHLPA93Genesis`, then `NHL92Genesis`. 93 names win when the body is the same routine.
- Reference ROM: `lst/nhl94.bin`. This is the ROM the listing was generated from. Bytes and branch displacements come from it. Do not substitute another ROM.
- `src/hockey94.asm` is the queue. Do not reorder it.
- Stub includes live in `src/stubinc` (`ports.inc`, `equals.inc`, `ram_addrs.inc`).

## Build

`buildseg.bat <name>` assembles `src/<name>_stub.asm`. The stub is `org` at the confirmed start, includes `src/stubinc`, and includes `src/<name>.asm`.

`npm run seg:<name>` runs buildseg, then `fixopcodes.js` on `output/<name> .lst` and `output/<name>.bin` with the org, then `verifySegment.js`. The assembler listing name has a space before `.lst`.

A MATCH of 0 bytes is a failure. The byte count must be the confirmed range.

## Rules carried from 93

- Write real `cmp`, `cmpi`, and `exg`. `fixopcodes.js` rewrites an EA `cmp.l` (`0Cxx` to `B0BC`) only. A real `cmpi.l #imm,d0` stays `0C80`. Do not revert that rule.
- Retail pad bytes win over the listing.
- A `printz` string can hide the next instruction. Write the instruction. Do not label a byte inside a string.
- If IDA splits one instruction into `dc.b` and `ori.b`, write the instruction.
- A 92 or 93 name is the field even when the 94 value differs. The equate gets the 94 value. The comment records the older value.
- Bit names (`sf2drec`, `sfwrap`) replace the number. Keep the flag word the retail bytes use.
- `jsr name` only when SNASM emits the same opcode. `jsr (name).l` is `4EB9`. `jsr (name).w` is `4EB8`. `bsr.w` stays `bsr.w`.
- A global label ends local-label scope. Strip `?` from IDA names. Keep each comment line under 200 characters.
- Do not delete an asm file. Edit it in place. Do not add a file except the stub and the segment asm.

## Queue

No segment is matched. The first pass is `main94` (`org 0`, vectors, header, `Start`, `SegaInit`). It is an existing draft, not a verified segment. Confirm its end against `lst/nhl94.bin` before writing instructions. The next file is `teamdata94`, also an existing draft and not matched. `Ram94` has no ROM bytes. `hockey94_01` starts at `VBjsr`.

## ROM map

Ranges below are provisional. Nothing is matched.

| File | Start | Listing note |
|---|---|---|
| main94 | org 0 | vectors, header, Start, SegaInit. First pass |
| teamdata94 | after main94 | existing draft, not matched |
| frames94 | SPAList | no file yet. SPAList ends near unk_73A0 |
| ram94 | | equates only, no ROM bytes |
| hockey94_01 | VBjsr | line 29709, next loc_76E8 |
| attract94 | EASportsScreen | 94 only |
| hockey94_02 | ReplayMode | before doinput, if present |
| logic94_1 | doinput | line 35886, before loc_B470 |
| logic94_2 | assbench | |
| logic94_3 | asswingo | |
| logic94_4 | checkob | |
| logic94_5 | ChkOffsides | |
| middle94_1 | remap | |
| middle94_2 | dobitmap | |
| penalty94_1 | AddPenalty | |
| penalty94_2 | printscores1 | |
| hockey94_03 | checkcoll | line 48484 |
| hockey94_04 | checkfight | |
| hockey94_05 | puckstick | |
| video94_1 | VBlank | |
| video94_2 | showclock | |
| hockey94_06 | setupice | line 53024 |
| hockey94_07 | ScoutingReport | 94 screens |
| hockey94_08 | setoptions | |
| hockey94_09 | DefaultMenus | |
| hockey94_10 | ResolveGames | through crash |
| hockey94_11 | cd0 | data |
| sram94 | InitSaveRAM | |
| sound94 | AllSndOff | 68k driver, then incbin |
| graphics94 | | incbin from extractAssets94.js |
| checksum94 | ValidationRoutine | existing draft, not matched |
