# Claude Code — Local Ollama Starter

## Purpose

This repository is a **technology-agnostic starter** for building apps with Claude Code running on Ollama locally.
It contains no app source code. Instead, it provides the environment scaffolding and conventions so you can
clone it, describe what you want to build, and let Claude Code generate the app from scratch.

---

## Environment

- **LLM backend**: Ollama (local, no paid API required)
- **Model**: configured via `OLLAMA_MODEL` in `.env` (default: `qwen3-coder`)
- **Claude Code**: connected via `ANTHROPIC_BASE_URL` pointing to Ollama

Before running Claude Code, ensure you have sourced the environment:

```bash
source .env.sh
claude --model $OLLAMA_MODEL
```

---

## How to define what to build

Create or edit the file `APP.md` at the root of this repo before starting Claude Code.
This file is your product specification. Claude Code will read it and build accordingly.

`APP.md` should describe:

1. **What the app does** — a short, clear description
2. **Technology stack** — be explicit (e.g. "Spring Boot + PostgreSQL", "Next.js + SQLite", "FastAPI + Redis")
3. **Key features** — list the main capabilities
4. **Data model** — describe your entities/schemas
5. **API or UI contract** — endpoints, pages, or components needed
6. **Infrastructure needs** — Docker Compose services, env vars, ports
7. **Quality requirements** — testing approach, auth, logging expectations

See `APP.md.example` for a reference template.

---

## Project conventions Claude Code must follow

### Code quality
- Always write production-quality code, not demo/placeholder code
- Include proper error handling and input validation
- Add comments for non-obvious logic

### Testing
- Write unit tests for business logic
- Write integration tests for API endpoints
- Tests must pass before considering a task done

### Docker
- Every app must include a `docker-compose.yml` for local development
- Services must use health checks
- Use named volumes for persistent data

### Git
- Write meaningful commit messages (conventional commits preferred)
- Don't commit `.env` files — only `.env.example`

### Structure
- Keep generated app code inside a subfolder named after the app (e.g. `./my-app/`)
- Do not pollute the repo root with app source files

---

## Switching models

To switch the Ollama model mid-project:

```bash
./scripts/switch-model.sh
```

Or manually edit `.env` and re-source:

```bash
# In .env:
OLLAMA_MODEL=deepseek-coder-v2

source .env.sh
claude --model $OLLAMA_MODEL
```

---

## Available scripts

| Script | Purpose |
|---|---|
| `scripts/setup.sh` | Bootstrap full local env (install Claude Code, pull model, verify Ollama) |
| `scripts/switch-model.sh` | Interactively swap the active Ollama model |

---

## Supported models (tested)

| Model | Strengths | Size |
|---|---|---|
| `qwen3-coder` | Best overall coding, strong context | 7B–32B |
| `gpt-oss` | Broad reasoning, OpenAI-compatible | varies |
| `glm-4-9b` | Fast, capable, good for REST APIs | 9B |
| `deepseek-coder-v2` | Excellent for backend logic | 16B |
| `codellama:34b` | Reliable for Java/Python | 34B |

> Tip: Prefer models with 128k context window for large codebases.
