# claude-config

Backup pessoal da configuração global do Claude Code: skills de especialista
(code review, engenheiro de dados, IA/ML, DevOps, cientista de dados,
analista de dados) e settings globais.

## Setup em um computador novo

```bash
git clone <url-deste-repo> ~/gedados/paulo-git/claude-config
cd ~/gedados/paulo-git/claude-config
./install.sh
```

O script cria symlinks de `skills/` e `CLAUDE.md` para `~/.claude/`, e faz
merge do `settings.json` se já existir um lá (avisa em vez de sobrescrever
silenciosamente).

## Reinstalar o RTK (redutor de tokens)

Não versionado aqui de propósito — é gerado pela própria ferramenta.

```bash
brew install rtk
rtk init -g
```

Depois confira se `~/.claude/settings.json` tem o hook `PreToolUse` do rtk
(ver `settings.json` deste repo como referência).

## Atualizando o backup

Depois de criar/editar uma skill em `~/.claude/skills/`, rode:

```bash
./sync.sh
git add -A
git commit -m "docs: atualiza skills"
git push
```
