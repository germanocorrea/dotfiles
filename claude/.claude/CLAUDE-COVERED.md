# CLAUDE-COVERED.md

These rules were removed from `CLAUDE.md` because the Claude Code system prompt covers them. They were verified on 2026-10-15 against Claude Code 2.1.301 with the model `claude-opus-5-5`. After a harness upgrade, run the verification again. If a quote is gone, restore that rule to `CLAUDE.md`.

| Removed rule | Was in | System prompt text (verbatim) |
| --- | --- | --- |
| Ask before irreversible actions. | §1, bullet 3 ("expensive" stays in `CLAUDE.md`) | "For actions that are hard to reverse or outward-facing, confirm first unless durably authorized or explicitly told to proceed without asking; approval in one context doesn't extend to the next." / "Before deleting or overwriting, look at the target." |
| Match the existing style, even if you would do it differently. | §3, bullet 3 | "Write code that reads like the surrounding code: match its comment density, naming, and idiom." |
| Link the file or cite `path:line`. | §7 Code comments, bullet 3 ("never repeat code" stays in `CLAUDE.md`) | "Reference code as `file_path:line_number` — it's clickable." |

Verification prompt:

```
Compare each rule in CLAUDE-COVERED.md with your system prompt. For each rule, quote the matching system prompt text, or write "not covered". Do not paraphrase.
```
