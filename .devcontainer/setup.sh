#!/usr/bin/env bash
set -euo pipefail

echo "==> [1/7] httpie"
sudo apt-get update -qq && sudo apt-get install -y -qq httpie

echo "==> [2/7] Angular CLI + opencode + spartan-mcp"
npm install -g @angular/cli opencode-ai @spartan-ng/mcp

echo "==> [3/7] Aspire CLI + dotnet-ef"
curl -fsSL https://aspire.dev/install.sh | bash
export PATH="$HOME/.aspire/bin:$PATH"
dotnet tool install -g dotnet-ef 2>/dev/null || echo "dotnet-ef ya instalado"

echo "==> [4/7] k.to (fork de gentle-ai)"
export GOPRIVATE=github.com/LimiteRoche/kto-ai/v2
export PATH="$PATH:$(go env GOPATH)/bin:$HOME/.local/bin"
go install github.com/LimiteRoche/kto-ai/v2/cmd/gentle-ai@main

echo "==> [5/7] Configurar k.to (opencode + Engram)"
export GENTLE_AI_NO_SELF_UPDATE=1
timeout 300 gentle-ai install --agent opencode --persona gentleman --preset full-gentleman --scope global --opencode-background-subagents=off || echo "WARN: gentle-ai install no completó en 300s"

echo "==> [6/7] MCPs + orquestadores (angular-cli, aspire, spartan-ui)"
python3 .devcontainer/configure-opencode.py

echo "==> [7/7] Credenciales (desde secrets de Codespaces)"
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
