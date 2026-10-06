# First segment prompt

Paste this into a new Copilot Agent session. Opus 5.5, High. One segment only.

```text
Open this file before you write any asm. It is already in the repo:

lst/nhl94.bin.lst

Search it for Reset and read from the start of the ROM through the byte before team data. The listing has no address column. loc_ and sub_ names are the address. If it does not open, stop and say the path you tried.

Do not disassemble lst/nhl94.bin. Do not write a disassembler. Do not edit hockey94.asm. Do not delete an asm file. Edit main94.asm in place. Do not rewrite SEGMENT_AGENT.md as a whole file.

Follow SEGMENT_AGENT.md. Complete only main94. Do not start teamdata94.

main94 is org 0: vectors, header, Start, SegaInit. The file already exists and is not matched. Style source is NHLPA93Genesis/src/main93.asm, then NHL92Genesis/src/main.asm. Confirm the end against lst/nhl94.bin. That is the ROM the listing was generated from.

1. Write src/main94_stub.asm at org 0. Include src/stubinc/ports.inc, equals.inc, ram_addrs.inc, and src/main94.asm.
2. Point package.json build:seg and verify:seg at main94 and 0x0. Add seg:main94: buildseg.bat, then fixopcodes.js on "output\main94 .lst" and output\main94.bin, then verifySegment.js main94 0x0 lst/nhl94.bin. The assembler listing name has a space before .lst.
3. Record the confirmed range in SEGMENT_AGENT.md. Keep the queue. main94 is the current segment. teamdata94 stays not matched.
4. Transcribe the listing for that range. Write real cmp / cmpi / exg. fixopcodes.js rewrites an EA cmp.l only. A real cmpi.l stays 0C80. Take every outside stub address from the branch displacement in lst/nhl94.bin.
5. Run npm.cmd run seg:main94. MATCH must cover the confirmed range. Then add comments and run it again.

Stop after 5 failed verifies. Report the first address, the built byte, the retail byte, and the instruction you emitted.
```
