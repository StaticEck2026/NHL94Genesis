# First segment prompt

Paste this into a new Copilot Agent session. Opus 5.5, High. One segment only.

```text
Open this file before you write any asm. It is already in the repo:

lst/nhl94.bin.lst

Search it for VBjsr and read through Begin until the next routine that belongs in attract94 or hockey94_02. The listing has no address column. loc_ and sub_ names are the address. If it does not open, stop and say the path you tried.

Do not disassemble lst/nhl94.bin. Do not write a disassembler. Do not edit hockey94.asm, teamdata94.asm, ram94.asm, or main94.asm. Do not delete an asm file. Edit it in place. Do not rewrite SEGMENT_AGENT.md as a whole file.

Follow SEGMENT_AGENT.md. Complete only hockey94_01. Do not start attract94.

hockey94_01 starts at VBjsr. Confirm the org against lst/nhl94.bin before the first verify. That is the ROM the listing was generated from. SPAList ends near unk_73A0. The next address-bearing label after VBjsr is loc_76E8, which is inside Begin, not the start. Style source is NHLPA93Genesis/src/hockey93_01.asm, then NHL92Genesis/src/hockey.asm.

1. Copy nothing from a 93 stub blindly. Write src/hockey94_01_stub.asm at the confirmed org. Include src/stubinc/ports.inc, equals.inc, ram_addrs.inc, and src/hockey94_01.asm.
2. Point package.json build:seg and verify:seg at hockey94_01 and that org. Add seg:hockey94_01 in the same shape as the 93 seg scripts: buildseg.bat, then fixopcodes.js on "output\hockey94_01 .lst" and output\hockey94_01.bin, then verifySegment.js. The assembler listing name has a space before .lst.
3. Record the confirmed range in SEGMENT_AGENT.md. Keep the queue.
4. Transcribe the listing for that range. Write real cmp / cmpi / exg. fixopcodes.js rewrites an EA cmp.l only. A real cmpi.l stays 0C80. Take every outside stub address from the branch displacement in lst/nhl94.bin.
5. Run npm.cmd run seg:hockey94_01. MATCH must cover the confirmed range. Then add comments and run it again.

Stop after 5 failed verifies. Report the first address, the built byte, the retail byte, and the instruction you emitted.
```
