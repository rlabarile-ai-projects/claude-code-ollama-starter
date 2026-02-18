# Claude Code + Ollama — Local App Builder Starter

A **technology-agnostic** starter repo for building apps with [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) running against [Ollama](https://ollama.com) locally.

No paid API key needed. No cloud. Full control over the model.

---

## How it works

```
You write APP.md  →  Claude Code reads it  →  App is generated
     ↑
(describes what to build, what stack, what features)
```

Claude Code runs as an agentic loop that reads, writes, and executes code — all driven by your spec and guided by `CLAUDE.md`.

---

## Prerequisites

| Tool | Min version | Install |
|---|---|---|
| [Node.js](https://nodejs.org) | 18+ | via nvm or https://nodejs.org |
| [Ollama](https://ollama.com) | 0.14+ | https://ollama.com/download |
| [Claude Code](https://www.npmjs.com/package/@anthropic-ai/claude-code) | latest | installed by `setup.sh` |

Any additional tools (Java, Python, Docker, etc.) are only needed depending on the app you're building.

---

## Quick start

```bash
# 1. Clone this repo — use your actual app name as the folder
git clone https://github.com/rlabarile-ai-projects/claude-code-ollama-starter.git <your-app-name>
cd <your-app-name>

# 2. (Optional) pick your model in .env before setup
cp .env.example .env
# Edit .env → set OLLAMA_MODEL=qwen3-coder (or your preference)

# 3. Bootstrap everything
chmod +x scripts/*.sh
./scripts/setup.sh

# 4. Describe your app
cp APP.md.example APP.md
# Edit APP.md — fill in your stack, features, data model, etc.

# 5. Activate env & start Claude Code
source .env.sh
claude --model $OLLAMA_MODEL
```

Inside Claude Code, just say:

> "Read APP.md and CLAUDE.md, then build the application."

---

## Switching models

```bash
./scripts/switch-model.sh
# → interactive menu to pick and pull a new model

source .env.sh   # reload env after switching
```

Or edit `.env` directly:

```bash
OLLAMA_MODEL=deepseek-coder-v2
```

---

## Recommended models

| Model | Best for | Pull command |
|---|---|---|
| `qwen3-coder` | General coding, large context | `ollama pull qwen3-coder` |
| `gpt-oss` | Broad reasoning tasks | `ollama pull gpt-oss` |
| `glm-4-9b` | Fast responses, REST APIs | `ollama pull glm-4-9b` |
| `deepseek-coder-v2` | Backend / algorithm heavy | `ollama pull deepseek-coder-v2` |
| `codellama:34b` | Java / Python projects | `ollama pull codellama:34b` |

---

## Repo structure

```
claude-code-ollama-starter/
├── .claude/
│   └── settings.json      # Claude Code permissions
├── scripts/
│   ├── setup.sh           # Bootstrap script
│   └── switch-model.sh    # Model switcher
├── .env.example           # Config template (copy → .env)
├── .gitignore
├── APP.md.example         # App spec template (copy → APP.md)
├── CLAUDE.md              # Instructions for Claude Code
└── README.md
```

Generated app code will live in its own subfolder (e.g. `./my-app/`) as specified in `APP.md`.

---

## Tips

- **Context window**: Use models with ≥128k context for large apps. `qwen3-coder` and `deepseek-coder-v2` support this.
- **Slow generation**: This is normal for local inference. Larger models are slower but produce better code.
- **Iterative building**: You don't need a perfect `APP.md`. Start with the basics and refine as Claude Code asks questions.
- **CLAUDE.md is your rulebook**: Edit it to enforce coding standards, preferred libraries, naming conventions, etc.

---

## Contributing

Contributions are welcome! Before submitting a PR, please read [CONTRIBUTING.md](CONTRIBUTING.md).

Good first contributions: adding tested model profiles, improving scripts for Windows/WSL, or sharing real-world `APP.md` examples for different stacks.

- 🐛 [Report a bug](../../issues/new?template=bug_report.md)
- 💡 [Request a feature](../../issues/new?template=feature_request.md)
- 💬 [Start a discussion](../../discussions)

---

## License

MIT — see [LICENSE](LICENSE) for details.
