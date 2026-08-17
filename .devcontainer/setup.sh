#!/usr/bin/env bash
set -euo pipefail

echo "==> [1/5] httpie"
sudo apt-get update -qq && sudo apt-get install -y -qq httpie

echo "==> [2/5] Angular CLI + opencode"
npm install -g @angular/cli opencode-ai

echo "==> [3/5] k.to (fork de gentle-ai)"
export GOPRIVATE=github.com/LimiteRoche/kto-ai/v2
export PATH="$PATH:$(go env GOPATH)/bin:$HOME/.local/bin"
go install github.com/LimiteRoche/kto-ai/v2/cmd/gentle-ai@main

echo "==> [4/5] Configurar k.to (opencode + Engram)"
timeout 300 gentle-ai install --agent opencode --persona gentleman --preset full-gentleman --scope global --opencode-background-subagents=off || echo "WARN: gentle-ai install no completó en 300s"

echo "==> [5/5] Credenciales (desde secrets de Codespaces)"
echo "  DEEPSEEK_API_KEY presente: $([ -n "${DEEPSEEK_API_KEY}" ] && echo SI || echo NO)"
echo "  OPENCODE_GO_API_KEY presente: $([ -n "${OPENCODE_GO_API_KEY}" ] && echo SI || echo NO)"
mkdir -p ~/.local/share/opencode
cat > ~/.local/share/opencode/auth.json <<EOF
{
  "deepseek": {"type": "api", "key": "${DEEPSEEK_API_KEY}"},
  "opencode-go": {"type": "api", "key": "${OPENCODE_GO_API_KEY}"}
}
EOF

echo "==> Verificación final"
node --version
dotnet --version
http --version
opencode --version
gentle-ai version
