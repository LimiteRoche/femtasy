# femtasy

Pair programming challenge environment.

## Stack

- **Frontend**: Angular 22 (Node 22)
- **Backend**: .NET 10
- **HTTP testing**: `httpie`

## Codespace

The devcontainer installs everything automatically on start:

- Node 22 + Angular CLI
- .NET SDK 10
- Go 1.25
- `httpie`
- `opencode` + the k.to assistant (persona, agents, Engram memory)

Provider credentials (DeepSeek + OpenCode Go) are read from Codespaces
secrets at runtime and are never stored in this repository.

## Local usage

```bash
# frontend
cd frontend && ng serve

# backend
cd backend && dotnet run
```
