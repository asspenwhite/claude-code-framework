# Bootstrap — Zero to Claude Code on QwenCloud

For someone who has (or is about to get) a QwenCloud Token Plan seat key
and no Claude Code installed yet. Two ways through:

1. **Follow this doc yourself** — it's short.
2. **Paste the setup prompt at the bottom into any chat AI** (in your
   browser) and let it drive. Useful when Claude Code isn't installed yet,
   so there's no terminal AI to ask.

What you need before either path:

- A QwenCloud account with a Token Plan subscription and a **seat API
  key**. On a Team plan, a seat IS an API key: assign it to a member and
  click Generate. Docs:
  https://docs.qwencloud.com/token-plan/team-management
- A terminal: Terminal on macOS, any shell on Linux, PowerShell or WSL
  on Windows.

---

## Step 1 — Install Claude Code

One command. Native installs auto-update in the background.

```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://claude.ai/install.ps1 | iex
```

Fallback (needs Node 22+; installs the same native binary):

```bash
npm install -g @anthropic-ai/claude-code
```

Verify in a **new** terminal: `claude --version`.

## Step 2 — Wire the endpoint

QwenCloud's Token Plan endpoint speaks the Anthropic API, so Claude Code
only needs env vars. Two wirings — pick by situation:

### Path A: QwenCloud is your only backend (simplest)

Put the vars in Claude Code's settings file: `~/.claude/settings.json`
on macOS/Linux, `%USERPROFILE%\.claude\settings.json` on Windows. Merge
into whatever is already there:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "YOUR_KEY_HERE",
    "ANTHROPIC_BASE_URL": "https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic",
    "ANTHROPIC_MODEL": "glm-5.2",
    "ANTHROPIC_DEFAULT_FABLE_MODEL": "qwen3.8-max",
    "ANTHROPIC_DEFAULT_FABLE_MODEL_NAME": "qwen3.8-max",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5.2",
    "ANTHROPIC_DEFAULT_OPUS_MODEL_NAME": "glm-5.2",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "qwen3.7-max",
    "ANTHROPIC_DEFAULT_SONNET_MODEL_NAME": "qwen3.7-max",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "kimi-k2.7-code",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME": "kimi-k2.7-code",
    "ANTHROPIC_CUSTOM_MODEL_OPTION": "deepseek-v4-pro",
    "ANTHROPIC_CUSTOM_MODEL_OPTION_NAME": "deepseek-v4-pro",
    "CLAUDE_CODE_SUBAGENT_MODEL": "qwen3.7-max"
  }
}
```

Trade-off, stated plainly: the key sits in that file in plaintext. On a
personal machine that's the same posture as any CLI config; if it
bothers you, use Path B and keep the key in your secret store of choice,
decrypted only at launch.

### Path B: you also use Anthropic (keep both side by side)

Don't touch settings.json — it's global and would repoint your real
Anthropic sessions too. Instead put the same vars in a wrapper shell
function (`qlaude`) in your `~/.bashrc` or `~/.zshrc`: the full pattern,
with fail-fast key handling and per-launch overrides, is in
[QWENCLOUD.md](QWENCLOUD.md).

## Step 3 — Verify

New terminal, then:

```bash
claude -p "hello"        # Path A
qlaude -p "hello"        # Path B
```

Any answer means key + URL + model all line up. If it doesn't:

| Symptom | Cause |
|---------|-------|
| 401 / auth error | Key and plan URL disagree. Token Plan keys only work on the `token-plan...` URL above; Coding Plan keys only on their own URL. The key prefix does NOT tell you which plan a key is for — test, don't guess. |
| 404 on a model | Catalog churn. Current list: https://docs.qwencloud.com/token-plan/team/token-plan-team-overview |
| `claude: command not found` | PATH — close and reopen the terminal, or reinstall |

Two gotchas worth knowing up front: the base URL ends at
`/apps/anthropic` — adding `/v1` breaks it; and Claude Code will warn
that these are unknown models and assume a 200k context window. The
warning is cosmetic.

## The picker you end up with

`/model` inside a session shows five configurable slots, now pointed at
real models:

| Slot | Model | Role |
|------|-------|------|
| Fable | `qwen3.8-max` | Flagship — the hard 5% of tasks |
| Opus (and Default) | `glm-5.2` | Daily workhorse; also the launch default |
| Sonnet | `qwen3.7-max` | Subagent default |
| Haiku | `kimi-k2.7-code` | Fast iterations |
| Custom | `deepseek-v4-pro` | Specialist |
| *(no slot)* | `deepseek-v4-flash` | `/model deepseek-v4-flash` mid-session |

Why glm-5.2 is the default and not the flagship: on a flat subscription
the flagship burns allowance fastest, so it lives in the Fable slot and
gets reached for deliberately. Volume on the workhorse, judgment on the
flagship. The roster as a working playbook: [QLAUDE.md](QLAUDE.md).

---

## The Setup Prompt

Starting from a browser with no Claude Code installed? Paste everything
in the box below into any chat AI and follow along. It's written as
instructions to the AI, not to you.

```text
You are helping me set up Claude Code (Anthropic's terminal coding
agent) to run on my QwenCloud Token Plan API key instead of an
Anthropic key. I have, or am about to create, a QwenCloud account with
a Token Plan subscription and a seat API key. Drive the entire setup.

Rules:
- First ask which OS I'm on: macOS, Linux, Windows (native), or WSL.
  Give commands only for that OS.
- One step at a time. Wait for me to paste the output before moving on.
- NEVER ask me to paste my API key into this chat. In any command or
  config that needs it, use the placeholder YOUR_KEY_HERE and tell me
  to replace it locally myself.
- If a step fails, diagnose from the actual error output before
  retrying. Don't guess.

Plan:
1. Install Claude Code.
   macOS / Linux / WSL:  curl -fsSL https://claude.ai/install.sh | bash
   Windows PowerShell:   irm https://claude.ai/install.ps1 | iex
   Fallback (needs Node 22+): npm install -g @anthropic-ai/claude-code
   Verify with: claude --version   (open a new terminal if not found)

2. Wire the QwenCloud endpoint. First ask whether I also use
   Anthropic's own API or subscription:
   - If NO (QwenCloud only): merge the env block from step 3 into
     ~/.claude/settings.json (%USERPROFILE%\.claude\settings.json on
     Windows), keeping any existing settings.
   - If YES: instead write a shell function named qlaude into my
     ~/.bashrc or ~/.zshrc that exports the same variables and ends
     with: claude "$@"   — so plain `claude` stays on Anthropic.

3. The variables, either path:
   ANTHROPIC_AUTH_TOKEN = YOUR_KEY_HERE   (my QwenCloud seat key)
   ANTHROPIC_BASE_URL = https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic
     — the URL ends at /apps/anthropic. Do NOT add /v1.
   ANTHROPIC_MODEL = glm-5.2              (session default; best
                                           value on the plan)
   ANTHROPIC_DEFAULT_FABLE_MODEL and ANTHROPIC_DEFAULT_FABLE_MODEL_NAME
     = qwen3.8-max                        (flagship, via the Fable row)
   ANTHROPIC_DEFAULT_OPUS_MODEL and _NAME = glm-5.2
   ANTHROPIC_DEFAULT_SONNET_MODEL and _NAME = qwen3.7-max
   ANTHROPIC_DEFAULT_HAIKU_MODEL and _NAME = kimi-k2.7-code
   ANTHROPIC_CUSTOM_MODEL_OPTION and _NAME = deepseek-v4-pro
   CLAUDE_CODE_SUBAGENT_MODEL = qwen3.7-max

4. Verify in a NEW terminal: claude -p "hello"   (or qlaude -p "hello"
   for the wrapper path). Any response means success.
   If 401: the key and base URL disagree. Token Plan keys work only on
   the token-plan URL; Coding Plan keys only on their own URL. The key
   prefix does not identify the plan — check which subscription I
   actually bought.
   If command not found: PATH problem; reopen the terminal.

5. Explain the /model picker I now have: qwen3.8-max is the flagship
   (Fable row, for hard tasks), glm-5.2 is the daily default,
   qwen3.7-max covers subagents, kimi-k2.7-code is the fast one,
   deepseek-v4-pro is the custom row, and deepseek-v4-flash is
   reachable anytime via /model deepseek-v4-flash.

6. Tell me to cd into a project folder and run claude (or qlaude) to
   start my first session. Done.

Context for debugging: QwenCloud's Token Plan endpoint implements the
Anthropic Messages API. Model IDs on the plan include qwen3.8-max,
qwen3.7-max, qwen3.6-flash, glm-5.2, glm-5.1, kimi-k2.7-code,
deepseek-v4-pro, deepseek-v4-flash, deepseek-v3.2. Claude Code warns
"unknown model context" for these — harmless; it assumes 200k.
```
