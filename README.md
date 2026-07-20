# claude-config

Backup pessoal da configuração global do Claude Code: skills de especialista
(code review, engenheiro de dados, IA/ML, DevOps, cientista de dados,
analista de dados) e settings globais.

Repo: https://github.com/paulopestanajunior/claude-config (privado)

## Setup em um computador novo

Escolha a seção do seu sistema operacional.

### macOS

```bash
gh repo clone paulopestanajunior/claude-config ~/claude-config
cd ~/claude-config
chmod +x install.sh
./install.sh
brew install rtk
rtk init -g
```

Sem `gh` instalado, use `git clone https://github.com/paulopestanajunior/claude-config ~/claude-config`.

### Linux (ou WSL no Windows)

Igual ao macOS:

```bash
gh repo clone paulopestanajunior/claude-config ~/claude-config
cd ~/claude-config
chmod +x install.sh
./install.sh
```

Para o RTK, veja [releases](https://github.com/rtk-ai/rtk/releases) (binário
`rtk-x86_64-unknown-linux-gnu`) ou `cargo install --git https://github.com/rtk-ai/rtk`.

Se o Claude Code no Windows roda dentro do WSL (caso mais comum), use este
caminho — `~/.claude` ali é o do WSL, não o do Windows nativo.

### Windows nativo (PowerShell, sem WSL)

```powershell
gh repo clone paulopestanajunior/claude-config "$HOME\claude-config"
cd "$HOME\claude-config"
.\install.ps1
```

O `install.ps1` cria os links equivalentes ao `install.sh` (usa `Junction`
para a pasta `skills` e `SymbolicLink` para `CLAUDE.md`, que não exigem modo
Administrador da mesma forma que outros links no Windows costumam exigir).
Se der erro de permissão, rode o PowerShell **como Administrador** ou ative
o Developer Mode em *Configurações > Privacidade e Segurança > Para
Desenvolvedores*.

Para o RTK: baixe `rtk-x86_64-pc-windows-msvc.zip` em
[releases](https://github.com/rtk-ai/rtk/releases), extraia `rtk.exe` e
adicione ao PATH (ex.: `C:\Users\<você>\.local\bin`). Depois rode
`rtk init -g`.

## O que cada script faz

- `install.sh` / `install.ps1`: cria link de `skills/` e `CLAUDE.md` para
  dentro de `~/.claude/`, e copia `settings.json` se ainda não existir lá
  (nunca sobrescreve um `settings.json` já existente — evita perder
  configuração específica daquela máquina).
- Qualquer arquivo original que já existisse em `~/.claude` é renomeado com
  sufixo `.bak` antes do link ser criado, nunca apagado.

## Reinstalar o RTK (redutor de tokens)

Não versionado neste repo de propósito — é gerado pela própria ferramenta,
não é configuração pessoal.

| SO | Comando |
|---|---|
| macOS | `brew install rtk` |
| Linux/WSL | binário em [releases](https://github.com/rtk-ai/rtk/releases) ou `cargo install --git https://github.com/rtk-ai/rtk` |
| Windows nativo | zip em [releases](https://github.com/rtk-ai/rtk/releases), extrair `rtk.exe` para o PATH |

Depois, em qualquer SO: `rtk init -g` e reinicie o Claude Code. Confirme que
`~/.claude/settings.json` ficou com o hook `PreToolUse` do rtk (comparar com
`settings.json` deste repo).

## Atualizando o backup

Depois de criar ou editar uma skill em `~/.claude/skills/` (que é um link
para este repo), as mudanças já aparecem aqui direto. Só falta:

```bash
git add -A
git commit -m "docs: atualiza skills"
git push
```

Se `settings.json` mudar localmente (ex.: novo hook), sincronize manualmente:

```bash
cp ~/.claude/settings.json ~/claude-config/settings.json   # macOS/Linux
Copy-Item "$HOME\.claude\settings.json" "$HOME\claude-config\settings.json"  # Windows
```

## Usando os mesmos perfis com Codex e GitHub Copilot

Os `SKILL.md` em `skills/` só funcionam no Claude Code — é um formato e
mecanismo de descoberta específicos dele. Codex (`AGENTS.md` na raiz do
repo) e Copilot (`.github/copilot-instructions.md`) não leem
`~/.claude/skills`; cada um só enxerga arquivos dentro do próprio repositório
do projeto.

Para não duplicar conteúdo manualmente, este repo gera uma versão portátil
(Markdown puro, sem frontmatter) a partir das mesmas skills:

```bash
./build-portable.sh
```

Isso popula `portable/profiles/*.md` — os mesmos 5 perfis + code-review, sem
a sintaxe exclusiva do Claude Code. Rode sempre que editar uma skill em
`skills/`.

Para levar os perfis para dentro de um projeto específico (onde você usa
Codex e/ou Copilot):

```bash
./deploy-to-project.sh ~/gedados/algum-projeto
```

Isso copia para dentro do projeto:

- `profiles/*.md` — os 6 perfis em Markdown puro.
- `AGENTS.md` — se ainda não existir no projeto (não sobrescreve; avisa se
  já houver um). Edite a seção "Escopo do Repositório" com o contexto
  daquele projeto específico.
- `.github/copilot-instructions.md` — idem, não sobrescreve se já existir.

Depois de gerado, revise e commite esses arquivos **dentro do repositório do
projeto** (eles não ficam em `claude-config`, viram parte do projeto-alvo).
Se o projeto já usa uma estrutura tipo `.agents/` (como o `ge-core-ai`),
prefira integrar manualmente em vez de rodar o script — ele assume que o
projeto ainda não tem essa estrutura.

Para o Claude Code continuar funcionando nesses mesmos projetos com os
perfis via `AGENTS.md` (em vez de só via skill global), referencie-o no
`CLAUDE.md` do projeto com `@AGENTS.md`.
