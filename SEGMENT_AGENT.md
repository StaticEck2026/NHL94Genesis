# NHL 94 segment agent

This file is the queue and the history. Do not rewrite it as a whole file. Edit it in place.

## Current segment

`main94`. Not matched. `org 0`: vectors, header, `Start`, `SegaInit`. The file already exists. Confirm the end against `lst/nhl94.bin` before writing instructions.

## Sources

- Listing: `lst/nhl94.bin.lst` in this repo. Open that file. Do not disassemble `lst/nhl94.bin`. Do not write a disassembler.
- The listing was exported from IDA as an LST in ASM68K / MRI mode. It has no address column. A `loc_`, `sub_`, or `unk_` name is the address. A named routine is at the instruction before the next address-bearing label. Confirm the org against `lst/nhl94.bin` before the first verify.
- Style source: the matching file in https://github.com/abdulahmad/NHLPA93Genesis. 93 is the closer source.
- Reference ROM: `lst/nhl94.bin`. This is the ROM the listing was generated from. Bytes and branch displacements come from it. Do not substitute another ROM.
- `src/hockey94.asm` is the include order. Do not reorder it.
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

## ROM map

The first row that is not matched is the current segment. Ranges are provisional until that row is matched.

| File | Status | Start | Note |
|---|---|---|---|
| main94 | not matched | org 0 | vectors, header, Start, SegaInit |
| teamdata94 | not matched | after main94 | existing draft |
| frames94 | not matched | SPAList | no file yet. SPAList ends near unk_73A0 |
| ram94 | not matched | | equates only, no ROM bytes |
| hockey94_01 | not matched | VBjsr | line 29709, next loc_76E8 |
| attract94 | not matched | EASportsScreen | 94 only |
| hockey94_02 | not matched | ReplayMode | before doinput, if present |
| logic94_1 | not matched | doinput | line 35886, before loc_B470 |
| logic94_2 | not matched | assbench | |
| logic94_3 | not matched | asswingo | |
| logic94_4 | not matched | checkob | |
| logic94_5 | not matched | ChkOffsides | |
| middle94_1 | not matched | remap | |
| middle94_2 | not matched | dobitmap | |
| penalty94_1 | not matched | AddPenalty | |
| penalty94_2 | not matched | printscores1 | |
| hockey94_03 | not matched | checkcoll | line 48484 |
| hockey94_04 | not matched | checkfight | |
| hockey94_05 | not matched | puckstick | |
| video94_1 | not matched | VBlank | |
| video94_2 | not matched | showclock | |
| hockey94_06 | not matched | setupice | line 53024 |
| hockey94_07 | not matched | ScoutingReport | 94 screens |
| hockey94_08 | not matched | setoptions | |
| hockey94_09 | not matched | DefaultMenus | |
| hockey94_10 | not matched | ResolveGames | through crash |
| hockey94_11 | not matched | cd0 | data |
| sram94 | not matched | InitSaveRAM | |
| sound94 | not matched | AllSndOff | 68k driver, then incbin |
| graphics94 | not matched | | incbin from extractAssets94.js |
| checksum94 | not matched | ValidationRoutine | existing draft |

## History

No segment has matched.
