# Contributing

Thanks for your interest in contributing! This repo is a starter template — contributions that keep it lean, flexible, and tech-agnostic are most welcome.

---

## What we welcome

- **New model profiles** — tested configurations for Ollama models not yet listed
- **Script improvements** — better error handling, cross-platform support (Windows/WSL), etc.
- **`APP.md` examples** — real-world specs for different stacks (Next.js, FastAPI, Go, etc.)
- **`CLAUDE.md` improvements** — better conventions that produce higher-quality generated code
- **Bug fixes** — anything broken in setup or switch-model scripts
- **Documentation** — clearer explanations, better examples, typo fixes

## What we won't merge

- App source code (this is a starter template, not an app repo)
- Lock-in to a specific tech stack
- Paid API dependencies
- Heavy tooling that breaks the "clone and go" simplicity

---

## How to contribute

1. **Fork** the repo and create a branch from `main`:
   ```bash
   git checkout -b feat/my-improvement
   ```

2. **Make your changes** — keep them focused and small.

3. **Test your changes** locally:
   - Run `./scripts/setup.sh` on a clean clone and verify it completes without errors
   - If you changed `switch-model.sh`, verify the model switch works end to end
   - If you updated `CLAUDE.md` or `APP.md.example`, do a quick Claude Code run to confirm the output quality

4. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: add glm-5 to supported models list
   fix: handle missing .env gracefully in setup.sh
   docs: add FastAPI APP.md example
   ```

5. **Open a Pull Request** against `main` with a clear description of what and why.

---

## Reporting issues

Use [GitHub Issues](../../issues) and include:

- Your OS and shell
- Ollama version (`ollama --version`)
- Node.js version (`node -v`)
- The model you were using
- The full error output

---

## Code style

- Shell scripts: follow the existing style (strict mode, `set -euo pipefail`, colored output)
- Markdown: sentence case for headings, consistent table formatting
- Keep everything readable by someone who just cloned the repo for the first time

---

## Questions?

Open a [Discussion](../../discussions) rather than an issue if you're unsure about something or want to propose a larger change before investing time in it.
