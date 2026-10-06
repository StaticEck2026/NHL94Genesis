# NHL 94 Genesis

Bitwise rebuild of NHL 94 for the Sega Genesis. The segment pass has not started.

The listing used for transcription is `lst/nhl94.bin.lst` (IDA LST, ASM68K / MRI). It has no address column. `loc_` / `sub_` names are the address. The retail ROM is not in git. Copy it here as `nhl94retail.bin`.

Style source for a segment is the matching file in [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis), then [NHL92Genesis](https://github.com/abdulahmad/NHL92Genesis).

## Segment queue

`src/hockey94.asm` is the include list. `SEGMENT_AGENT.md` is the rule file. `PROMPT.md` is the first Copilot prompt. Placeholder files are comments only. Do not treat them as finished source.

`src/hockey94_draft.asm` is the old commented 92 dump. It is not the queue.

94-only files that 93 did not have:

- `attract94.asm` for `EASportsScreen`, `HiScoreScreen`, and `LoadDefMenuOptions`
- `sram94.asm` starts at `InitSaveRAM`

## Build

Segment builds use `buildseg.bat` and `npm run seg:<name>` once a segment has a stub and a confirmed org. The full `npm run build:retail` path is not ready. It still points at `src/hockey94.asm`, which is now the queue.

`npm run extractassets` runs `extractAssets94.js` against `nhl94retail.bin`.

## Listing export

File, Produce file, Create LST file. Assembler: ASM68K. Leave "Skip unused code/data output" and "Ignore DEL_START/_END tag" unchecked. Do not export a selected range.
