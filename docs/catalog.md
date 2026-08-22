# Catálogo

Este é o ponto de entrada humano para o catálogo de componentes.

- Inventário completo gerado: [catalog.generated.md](catalog.generated.md)
- Fluxo de uso: [quick-start.md](quick-start.md)
- Exemplos de composição: [examples.md](examples.md)

O catálogo gerado é atualizado por `scripts/generate-adapters.sh` ou
`scripts/generate-adapters.ps1` a partir destes caminhos canônicos:

```text
skills/<name>/SKILL.md
roles/<name>.md
workflows/<name>.md
profiles/<name>.md
rules/<name>.md
```

Não mantenha um segundo inventário manual aqui. Adicione ou edite o arquivo
canônico do componente, rode o gerador e revise `docs/catalog.generated.md`.

O harness canônico usado por agents é em inglês. Para facilitar a leitura em
português sem misturar idiomas nos arquivos dos agents, o gerador usa
`docs/catalog.pt.tsv` como camada opcional de texto humano em português.

As skills globais evitam assumir cloud, provider ou stack de projeto quando a
tecnologia varia muito por contexto. Em domínios onde algumas ferramentas são
conhecimento-base do mercado, como GA4/GTM/sGTM em Web Analytics ou
AppsFlyer/Adjust/GTM/WordPress/VTEX/Shopify em QA de Tracking, o catálogo pode
citá-las sem tornar o harness dependente de um projeto específico.

O próprio gerador mantém `docs/catalog.pt.tsv` sincronizado:

- preserva as descrições em português já revisadas;
- adiciona automaticamente linhas para componentes novos;
- remove linhas de componentes que não existem mais;
- usa fallback em português quando ainda não houver uma descrição melhor.

Depois de criar uma nova skill, role, workflow, profile ou rule, rode o
gerador. O componente aparece no TSV e no catálogo gerado. Se quiser uma
descrição mais precisa para humanos, refine a linha criada no TSV e rode o
gerador novamente.

## Como Ler O Catálogo

| Tipo | O Que Responde | Exemplo |
|---|---|---|
| Role | Como o agent deve operar? | `architect`, `reviewer`, `tech-lead` |
| Skill | Qual especialidade técnica é necessária? | `solution-architect`, `sql-expert`, `devops` |
| Workflow | Qual sequência de execução seguir? | `bugfix`, `review`, `documentation` |
| Profile | Qual profundidade, autonomia e postura de risco usar? | `fast`, `normal`, `deep`, `autonomous` |
| Rule | Qual restrição durável deve permanecer ativa? | `git`, `safety`, `testing` |
| Template | Qual artefato local pode ser criado no projeto? | `SPEC.md`, `TRACKING_PLAN.md`, `ADR.md` |

Use invocação conceitual em descrições de tarefa:

```text
role: architect
skill: solution-architect
workflow: architecture-change
profile: deep
```

Sintaxe específica de vendor pertence a `adapters/`.

Templates não são componentes de runtime do harness. Eles existem para iniciar
artefatos locais de projeto quando fizer sentido, por exemplo uma spec em
`docs/specs/active/` ou um tracking plan em `docs/plans/active/`.
