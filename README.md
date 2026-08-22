# agents-config

Harness global e vendor-neutral para coding agents.

O harness define como os agentes trabalham entre repositórios: investigação,
planejamento, implementação, debugging, review, validação, segurança de Git,
skills reutilizáveis, roles, workflows, profiles, rules, templates e adapters
de vendor.

Cada projeto define apenas o seu próprio contexto: arquitetura, stack,
comandos, regras de domínio, serviços externos, decisões, planos e overrides.

```text
GLOBAL HARNESS -> PROJECT CONTEXT -> CURRENT TASK
```

## Conceitos

- `skills/<name>/SKILL.md`: especialidade técnica.
- `roles/<name>.md`: postura operacional.
- `workflows/<name>.md`: sequência de execução.
- `profiles/<name>.md`: profundidade e autonomia.
- `rules/<name>.md`: restrição durável.
- `adapters/`: compatibilidade fina por vendor.
- `templates/`: arquivos iniciais para contexto local de projeto.

Os componentes são descobertos pela estrutura de diretórios. Adicionar
`skills/example-skill/SKILL.md`, `roles/example.md` ou
`workflows/example.md` não deve exigir editar scripts de instalação, build ou
listas de adapters.

## Como Escolher Role, Skill, Workflow E Profile

Use o harness compondo poucos elementos:

```text
role: architect
skill: solution-architect
workflow: architecture-change
profile: deep
```

Isso não é um comando nem uma configuração permanente do projeto. É uma forma
curta de orientar o agent no prompt da tarefa atual. Quando o pedido for óbvio,
o agent pode inferir a composição; quando você quiser mais controle, escreva a
composição explicitamente no pedido.

Guias rápidos:

- [docs/quick-start.md](docs/quick-start.md): modelo mental e fluxo de
  decisão.
- [docs/catalog.md](docs/catalog.md): catálogo humano com link para o
  inventário gerado.
- [docs/examples.md](docs/examples.md): combinações práticas por cenário.

## Instalação

Clone o repositório uma vez:

```bash
git clone https://github.com/paulopestanajunior/agents-config.git ~/.agents-config
cd ~/.agents-config
scripts/install.sh
```

No Windows PowerShell:

```powershell
git clone https://github.com/paulopestanajunior/agents-config.git "$HOME\.agents-config"
cd "$HOME\.agents-config"
.\scripts\install.ps1
```

O instalador:

- gera adapters a partir dos componentes canônicos;
- cria link para o harness em `~/.agents-config` quando possível;
- cria links de compatibilidade para Claude Code;
- cria link para o `AGENTS.md` global do Codex;
- cria links para instruções/perfis gerados do Copilot;
- cria links para instruções e skills globais do Kimi Code;
- cria links para instruções e skills globais do ZCode;
- nunca sobrescreve `~/.claude/settings.json` silenciosamente.

Se um caminho existente não for link, o instalador move para `.bak` antes de
criar o link. Se `~/.claude/settings.json` já existir, ele fica intacto;
compare manualmente com `adapters/claude/settings.json` se precisar do hook
do RTK.

## Atualização

```bash
cd ~/.agents-config
git pull
scripts/generate-adapters.sh
scripts/install.sh
```

PowerShell:

```powershell
cd "$HOME\.agents-config"
.\scripts\generate-adapters.ps1
.\scripts\install.ps1
```

Projetos já inicializados não precisam de novo bootstrap quando uma nova
skill, role, workflow, profile ou rule global for adicionada. Atualize o
harness global, regenere adapters, e o novo componente fica disponível pelos
links globais.

## Bootstrap De Projeto

Inicialize um projeto com apenas contexto local:

```bash
scripts/init-project.sh --target /path/to/project
scripts/init-project.sh --target /path/to/project --dry-run
```

O bootstrap cria somente contexto local do projeto: `AGENTS.md`, `PROJECT.md`,
`ARCHITECTURE.md`, `docs/decisions/`, `docs/plans/`, `docs/specs/` e
`.agents/overrides/`. Ele não copia skills, roles, workflows, profiles ou
rules globais para dentro do projeto.

PowerShell:

```powershell
.\scripts\init-project.ps1 -Target C:\path\to\project
.\scripts\init-project.ps1 -Target C:\path\to\project -DryRun
```

O bootstrap cria somente arquivos e diretórios locais ausentes:

```text
AGENTS.md
PROJECT.md
ARCHITECTURE.md
docs/decisions/
docs/plans/active/
docs/plans/completed/
docs/specs/active/
docs/specs/completed/
.agents/overrides/
```

Ele é idempotente e não copia skills, rules, roles, workflows ou profiles
globais para dentro do projeto.

Use `templates/SPEC.md` como ponto de partida para specs locais em
`docs/specs/active/` quando a tarefa tiver regra de negócio ambígua, impacto
cross-module, mudança arquitetural ou decisão difícil de reverter.

Use `templates/TRACKING_PLAN.md` para tracking plans locais quando precisar
definir eventos, propriedades, identidade, consentimento, destinos,
deduplicação e critérios de validação antes da implementação.

## Claude Code

Instale o Claude Code separadamente seguindo a documentação oficial da
Anthropic. Um caminho comum de instalação via CLI tem sido:

```bash
npm install -g @anthropic-ai/claude-code
claude doctor
```

Autentique com sua conta Claude quando solicitado.

Integração com o harness:

- `~/.claude/CLAUDE.md` aponta para o `CLAUDE.md` da raiz;
- o `CLAUDE.md` da raiz referencia `AGENTS.md` e
  `adapters/claude/CLAUDE.md`;
- `~/.claude/skills` aponta para `skills/`;
- `adapters/claude/settings.json` preserva o template do hook RTK.

O `~/.claude/settings.json` existente não é sobrescrito. A configuração local
pode conter campos específicos da máquina, como tema, modelo ou TUI, além de
`rtk hook claude`.

## Codex

Instale o Codex separadamente pela extensão oficial do VS Code ou CLI
disponível para sua conta. Faça login com a conta ChatGPT com acesso ao Codex
e abra um workspace antes de esperar comportamento consciente do repositório.

Integração com o harness:

- `scripts/generate-adapters.sh` gera `adapters/codex/AGENTS.md`;
- `scripts/install.sh` cria link para `~/.codex/AGENTS.md`;
- `AGENTS.md` locais de projeto adicionam contexto e overrides do projeto.

## GitHub Copilot

Instale o GitHub Copilot no VS Code e faça login com a conta GitHub correta.

Integração com o harness:

- instruções de usuário geradas ficam em `adapters/copilot/instructions/`;
- perfis Markdown de skills ficam em `adapters/copilot/profiles/`;
- instaladores criam links para `~/.copilot/` quando a versão local do
  Copilot/VS Code suporta esse fluxo.

## ZCode / GLM, Kimi, Kilo / OpenRouter

Instale e autentique cada agente pelo fluxo oficial de distribuição,
assinatura ou API key.

Adapters com conteúdo real existem para Kimi Code e ZCode porque ambos têm
pontos globais documentados para instruções e skills.

Integração com o Kimi Code:

- `scripts/generate-adapters.sh` gera `adapters/kimi/AGENTS.md`;
- `scripts/install.sh` cria link para `$KIMI_CODE_HOME/AGENTS.md`, ou
  `~/.kimi-code/AGENTS.md` quando `KIMI_CODE_HOME` não estiver definido;
- `scripts/install.sh` cria link de `skills/` para `$KIMI_CODE_HOME/skills`.

Integração com o ZCode:

- `scripts/generate-adapters.sh` gera `adapters/zcode/AGENTS.md`;
- `scripts/install.sh` cria link para `~/.zcode/AGENTS.md`;
- `scripts/install.sh` cria link de `skills/` para `~/.zcode/skills`.

Kilo / OpenRouter continuam sem adapter próprio até haver um ponto de
integração global útil e validável. Esses agentes devem consumir o
`AGENTS.md` comum do projeto e os recursos globais expostos pelo ambiente do
usuário.

## Versionamento

O harness usa SemVer em `VERSION`.

- `MAJOR`: quebra de layout, contrato de scripts, paths de adapters ou
  comportamento de bootstrap de projeto.
- `MINOR`: nova skill, role, workflow, profile, rule, template, adapter ou
  capacidade compatível de instalador.
- `PATCH`: documentação, texto ou correções de script sem quebra.

Registre mudanças visíveis ao usuário em `CHANGELOG.md`.

## Fluxo Diário

1. Abra o repositório alvo.
2. Carregue os defaults globais do harness.
3. Leia `AGENTS.md`, `PROJECT.md` e `ARCHITECTURE.md` do projeto quando
   existirem.
4. Escolha role, skill, profile e workflow apenas quando necessário.
5. Implemente ou analise a tarefa atual.
6. Valide.
7. Resuma mudanças, validação e risco residual.

Exemplos:

- `architect + deep + architecture-change`
- `implementer + normal + feature`
- `debugger + deep + bugfix`
- `reviewer + normal + review`
- `implementer + fast + small fix`
