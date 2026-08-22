# Guia Rápido

Use este harness compondo poucos componentes. Não trate o harness como uma
caixa-preta: escolha a role, skill, workflow, profile e conjunto de rules que
combinam com a tarefa real.

## Modelo Mental

```text
Role
= como o agent opera

Skill
= especialidade técnica

Workflow
= sequência de execução

Profile
= profundidade, autonomia e postura de risco

Rule
= restrição durável

SPEC
= o que / por quê / restrições / critérios de aceite

PLAN
= como / sequência / abordagem de implementação

TASK
= unidade concreta de execução
```

O contexto do projeto é separado do harness global. O harness global define
como os agents trabalham; o projeto define como aquele sistema funciona; a
tarefa define o que precisa ser feito agora.

O harness global deve ser vendor-neutral. Provider, ferramenta, cloud ou stack
específica entram no contexto do projeto (`AGENTS.md`, `PROJECT.md`,
`ARCHITECTURE.md` ou `.agents/overrides/`), não como premissa fixa das skills
globais.

Há uma exceção prática: algumas áreas têm ferramentas-base que fazem parte da
alfabetização normal do especialista, mesmo em um harness global. Web Analytics
deve conhecer GA4, GTM e server-side GTM (`sGTM`); QA de Tracking deve conhecer
AppsFlyer, Adjust, GTM, WordPress, VTEX e Shopify. Isso não prende um projeto a
essas stacks. O projeto pode adicionar ferramentas específicas em
`.agents/overrides/` ou no seu contexto local.

## Fluxo De Decisão

1. Que tipo de trabalho é este?
2. Qual role o agent deve adotar?
3. Qual skill especialista é relevante?
4. Qual workflow combina com a tarefa?
5. Qual profile é adequado?
6. A tarefa precisa de spec antes do plano?
7. Quais rules duráveis são relevantes?

Use invocação conceitual ao descrever o comportamento desejado:

```text
role: architect
skill: solution-architect
workflow: architecture-change
profile: deep
```

A sintaxe específica de vendor fica nos adapters. Prefira a forma conceitual
em docs de projeto, planos e descrições de tarefa.

Isso não é uma configuração permanente e não precisa ser executado antes de
começar um projeto. É apenas uma forma clara de escrever no prompt como você
quer que o agent trabalhe naquela tarefa.

Você pode deixar o agent inferir a composição quando o pedido for óbvio:

```text
Revise este PR e me diga se está pronto para merge.
```

Ou pode explicitar a composição quando quiser mais controle:

```text
Use:
role: reviewer
skill: sql-expert
workflow: review
profile: deep

Revise a query em `models/revenue.sql` procurando erro de grão, joins
perigosos, duplicidade e custo.
```

O bootstrap de projeto (`init-project`) cria contexto local. A composição de
role/skill/workflow/profile é escolhida por tarefa.

Use `workflow: spec-driven-development` quando a tarefa tiver regra de negócio
ambígua, impacto cross-module, mudança arquitetural ou decisão difícil de
reverter. Para correção pequena, edição mecânica ou pedido já bem especificado,
um spec formal tende a ser excesso.

## Exemplos Práticos

```text
role: tech-lead
skill: solution-architect
profile: deep
```

Use quando estiver começando um projeto ou feature grande e precisar de um
plano sequenciado com desenho end-to-end da solução.

Prompt real:

```text
Use:
role: tech-lead
skill: solution-architect
profile: deep

Quero começar um novo sistema. Antes de escrever código, me ajude a definir
a solução end-to-end, principais componentes, riscos, decisões arquiteturais
e ordem de execução.
```

```text
role: architect
skill: analytics-instrumentation
workflow: spec-driven-development
profile: deep
```

Use quando precisar transformar uma necessidade de mensuração em contrato de
eventos, propriedades, identidade, deduplicação, destinos e critérios de
validação antes da implementação.

```text
role: reviewer
skill: skill-evaluation
workflow: evaluate-skill
profile: deep
```

Use ao revisar se uma nova skill realmente melhora o comportamento do agent,
se ativa no momento certo e se não captura tarefas de outras especialidades.

```text
role: architect
skill: software-architect
workflow: refactor
profile: deep
```

Use quando o problema for organização interna de código: módulos, camadas,
boundaries, acoplamento ou uma refatoração estrutural arriscada.

```text
role: reviewer
skill: sql-expert
workflow: review
profile: deep
```

Use ao revisar query, migration, view de warehouse, SQL de dashboard ou diff
com peso grande em banco/dados.

```text
skill: technical-documentation
skill: human-writing-editor
workflow: documentation
profile: normal
```

Use quando o conteúdo precisa estar tecnicamente correto e depois ficar mais
claro, natural ou humano.

## Quando Não Compor Mais

- Não adicione uma role se a tarefa só precisa de uma resposta direta de
  especialista.
- Não adicione várias skills só porque várias parecem relacionadas; escolha a
  que realmente é dona da decisão.
- Não use `deep` para uma edição trivial e reversível.
- Não use Tech Lead como substituto de expertise de arquitetura, dados, IA,
  segurança ou cloud.
- Não copie skills, roles, workflows, profiles ou rules globais para dentro de
  um projeto. Use arquivos do projeto apenas para contexto local e overrides.
