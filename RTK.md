# RTK - Rust Token Killer

RTK is an optional Claude Code output-reduction helper. The Claude adapter
ships a `PreToolUse` hook template that runs:

```bash
rtk hook claude
```

This file exists so the root `CLAUDE.md` import works on a fresh clone. The
hook itself is configured in `adapters/claude/settings.json`; existing local
`~/.claude/settings.json` files are never overwritten by the installer.

## Installation Verification

```bash
rtk --version
rtk gain
which rtk
```

If `rtk gain` fails, verify that the installed binary is the intended RTK
token-reduction tool and not an unrelated package with the same executable
name.

## Useful Commands

```bash
rtk gain              # Show token savings analytics
rtk gain --history    # Show command usage history with savings
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute raw command without filtering
```

## Hook-Based Usage

When the Claude hook is installed, normal shell commands are rewritten through
RTK automatically by Claude Code. Use `rtk proxy <cmd>` when you need raw,
unfiltered command output for debugging.
