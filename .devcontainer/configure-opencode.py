#!/usr/bin/env python3
"""Configure opencode with the user MCPs and explicit orchestrator models.

Runs AFTER `gentle-ai install` (which generates opencode.json with engram +
context7). This script adds the project-specific MCPs and makes the orchestrator
model assignments explicit. Idempotent.
"""
import json
import os
import sys


def main() -> int:
    path = os.path.expanduser("~/.config/opencode/opencode.json")
    if not os.path.exists(path):
        print(f"opencode.json not found at {path}; skipping")
        return 0

    with open(path, encoding="utf-8") as f:
        cfg = json.load(f)

    mcp = cfg.setdefault("mcp", {})

    mcp["spartan-ui"] = {"command": ["spartan-mcp"], "type": "local", "enabled": True}
    mcp["angular-cli"] = {
        "command": ["npx", "-y", "@angular/cli", "mcp"],
        "type": "local",
        "enabled": True,
    }
    mcp["aspire"] = {"command": ["aspire", "agent", "mcp"], "type": "local", "enabled": True}

    agents = cfg.get("agent", {})
    if "kto-orchestrator" in agents:
        agents["kto-orchestrator"]["model"] = "opencode-go/deepseek-v4-pro"

    with open(path, "w", encoding="utf-8") as f:
        json.dump(cfg, f, indent=2)

    print(f"configured MCPs: {list(mcp.keys())}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
