# Exemplos De Composição

Estes exemplos usam invocação conceitual. Eles são portáveis entre vendors e
evitam sintaxe específica como `$skill`.

Você não precisa rodar esses blocos antes do projeto. Eles são exemplos de
como escrever o pedido no chat quando quiser direcionar o comportamento do
agent para uma tarefa específica. O agent também pode inferir uma composição
quando o pedido for claro.

## Produto Novo Ou Feature Grande

```text
role: tech-lead
skill: solution-architect
workflow: feature
profile: deep
```

Cenário: um novo projeto, integração ou feature grande precisa de planejamento
antes da implementação.

Por que combina: Tech Lead sequencia o trabalho e delega decisões; Solution
Architect desenha como aplicação, dados, IA, cloud, segurança e operação se
encaixam.

Saída esperada: enquadramento do problema, fases de execução, solução de alto
nível, dependências, riscos, handoffs para especialistas e validações iniciais.

Prompt real:

```text
Use:
role: tech-lead
skill: solution-architect
workflow: feature
profile: deep

Quero começar um novo produto. Antes de codar, monte o plano de execução,
a arquitetura end-to-end, as principais decisões e o que precisa ser validado
primeiro.
```

## Review De Arquitetura Interna

```text
role: architect
skill: software-architect
workflow: architecture-change
profile: deep
```

Cenário: boundary de módulo, estrutura de pastas, dependência entre camadas,
split de monorepo ou boundary de serviço precisa de revisão.

Por que combina: Architect força raciocínio de trade-off; Software Architect
é dono da estrutura interna de código e acoplamento.

Saída esperada: avaliação da estrutura atual, riscos de acoplamento,
alternativas, trade-offs, candidatos a ADR e plano de migração escopado.

Prompt real:

```text
Use:
role: architect
skill: software-architect
workflow: architecture-change
profile: deep

Revise a estrutura atual do projeto e proponha uma reorganização mínima para
reduzir acoplamento sem mudar comportamento.
```

## Review De SQL Ou Mudança Pesada Em Dados

```text
role: reviewer
skill: sql-expert
workflow: review
profile: deep
```

Cenário: revisão de query, modelo dbt/Dataform, migration, definição de
métrica ou SQL de dashboard.

Por que combina: Reviewer prioriza corretude e risco de regressão; SQL Expert
é dono de semântica da query, joins, grão de agregação, performance e edge
cases.

Saída esperada: findings primeiro, referências de linha/path quando
disponíveis, riscos de corretude, problemas de performance e correções
concretas.

Prompt real:

```text
Use:
role: reviewer
skill: sql-expert
workflow: review
profile: deep

Revise esta query procurando erro de grão, joins perigosos, duplicidade,
tratamento de nulos e custo.
```

## Investigação De Qualidade De Dados

```text
role: data-quality-auditor
skill: data-analyst
profile: deep
```

Cenário: uma métrica mudou inesperadamente, um pipeline produziu dados
incompletos ou uma tabela não bate mais com o grão esperado.

Por que combina: Data Quality Auditor estabelece evidência, checks, grão,
freshness, completude e reconciliação; Data Analyst interpreta o significado
dos dados para o negócio.

Saída esperada: árvore de hipóteses, checks a executar, pontos prováveis de
falha, evidência de qualidade de dados e próximos passos de remediação.

## Tracking Plan E Contrato De Mensuração

```text
role: architect
skill: analytics-instrumentation
workflow: spec-driven-development
profile: deep
```

Cenário: antes de implementar eventos de produto, campanhas, ecommerce ou
conversões, você precisa definir nomes, gatilhos, propriedades, identidade,
source of truth, destinos, consentimento e deduplicação.

Por que combina: Architect força consistência de contrato; Analytics
Instrumentation define como o comportamento vira evento/propriedade/identity;
Spec-Driven Development evita que o agent invente regra de negócio.

Saída esperada: spec ou tracking plan com eventos, owners, client/server
ownership, propriedades obrigatórias/opcionais, destinos, dedup key,
classificação de consentimento e critérios de validação.

Prompt real:

```text
Use:
role: architect
skill: analytics-instrumentation
workflow: spec-driven-development
profile: deep

Preciso criar o tracking plan de checkout. Antes de implementar, defina os
eventos, propriedades, identity, deduplicação, destinos e validações.
```

## QA De Tracking Server-Side

```text
role: reviewer
skill: qa-tracking-integrations
workflow: review
profile: deep
```

Cenário: revisar uma integração com browser pixel, sGTM, CAPI/postback, MMP ou
CDP antes de publicar.

Por que combina: Reviewer prioriza risco e regressão; QA Tracking valida ponta
a ponta, deduplicação, ambientes, identidade, consentimento e divergência
browser vs server.

Saída esperada: matriz de testes, riscos de duplicidade, checks de event ID,
currency/timezone/attribution window, validação de sandbox vs produção e
critérios para aceitar ou bloquear o release.

## Spec Antes De Feature Ambígua

```text
role: tech-lead
skill: solution-architect
workflow: spec-driven-development
profile: deep
```

Cenário: feature grande, regra de negócio ambígua, integração crítica ou
mudança difícil de reverter.

Por que combina: Tech Lead separa decisão, sequência e risco; Solution
Architect conecta aplicação, dados, integrações, segurança, operação e custo;
Spec-Driven Development obriga critérios de aceite antes de implementar.

Saída esperada: `SPEC.md` inicial com contexto, problema, goals, non-goals,
contratos, edge cases, solução proposta, riscos, critérios de aceite e
validação.

## Avaliação De Agent Ou Skill

```text
role: researcher
skill: agent-evaluation
workflow: evaluate-agent
profile: research
```

Cenário: comparar se uma mudança de prompt, adapter, workflow ou harness
melhorou o comportamento do agent em tarefas reais.

Por que combina: Researcher separa evidência de impressão; Agent Evaluation
mede task completion, tool behavior, validação, segurança, latência e custo.

Saída esperada: baseline vs versão nova, critérios explícitos, resultados por
tarefa, regressões encontradas e recomendações concretas.

```text
role: reviewer
skill: skill-evaluation
workflow: evaluate-skill
profile: deep
```

Cenário: revisar uma nova `SKILL.md` antes de considerar que ela melhora o
harness.

Por que combina: Skill Evaluation testa ativação, boundary e benefício
comparado ao baseline sem skill.

Saída esperada: tarefas que devem ativar, tarefas que não devem ativar,
comparação baseline vs skill, problemas de descrição/body/boundaries e patch
recomendado.

## Pesquisa Ou Investigação Estatística

```text
role: researcher
skill: data-scientist
profile: research
```

Cenário: avaliar se um experimento, resultado de modelo, afirmação causal ou
conclusão estatística é válida.

Por que combina: Researcher separa fatos, claims, premissas, hipóteses e
inferências; Data Scientist é dono de modelagem, validação de hipótese,
desenho experimental, leakage, incerteza e raciocínio causal.

Saída esperada: premissas, ameaças à validade, checks estatísticos, análise de
sensibilidade e próximos testes recomendados.

## Documentação Com Edição Humana

```text
skill: technical-documentation
skill: human-writing-editor
workflow: documentation
profile: normal
```

Cenário: escrever ou revisar README, ADR, runbook, guia de integração, doc de
arquitetura ou guia de migração.

Por que combina: Technical Documentation ancora o conteúdo em arquivos e
comportamento reais; Human Writing Editor melhora clareza, tom e leitura sem
alterar o significado técnico.

Saída esperada: documentação precisa, com audiência clara, paths ou comandos
concretos, significado técnico preservado e prosa menos mecânica.

## Review De Deploy Produção Ou IaC

```text
role: reviewer
skill: devops
workflow: review
profile: deep
```

Cenário: revisar CI/CD, configuração de deploy Tsuru, mudanças de
Docker/build, Terraform/OpenTofu, pinning de provider, state, locking, imports
ou drift.

Por que combina: Reviewer foca risco operacional e regressão; DevOps é dono
de deploy e segurança de execução de IaC.

Saída esperada: riscos de mudança destrutiva, problemas de secret/IAM,
preocupações de plan/apply, perguntas de rollback/recovery e passos de
validação antes do deploy.

## Começar Um Projeto Do Zero

```text
role: tech-lead
workflow: project-kickoff
profile: deep
```

Cenário: uma ideia, um briefing ou um repositório vazio, e você não sabe por
onde começar.

Por que combina: Tech Lead sequencia decisões e delega aos especialistas;
`project-kickoff` transforma o briefing em escopo de MVP, não-objetivos e
decisões bloqueantes, e termina preenchendo `PROJECT.md`, `ARCHITECTURE.md` e
`WORKING_CONTEXT.md`.

Saída esperada: problema reformulado, escopo de MVP com não-objetivos
explícitos, decisões bloqueantes com dono, ordem de execução e plano em
`docs/plans/active/`.

## Entrar Em Um Repositório Desconhecido

```text
role: researcher
workflow: codebase-onboarding
profile: deep
```

Cenário: `git clone` de um projeto que você nunca trabalhou e precisa entender
antes de mudar qualquer coisa.

Por que combina: Researcher separa evidência de suposição; o workflow lê
entrypoints, comandos, boundaries reais e fluxos de dado antes de concluir.

Saída esperada: `PROJECT.md` e `ARCHITECTURE.md` preenchidos a partir do
código, invariantes e áreas frágeis identificadas, e a lista do que não foi
possível inferir e precisa de resposta humana.

## Mudança Em Pipeline De Dados

```text
role: implementer
skill: data-engineer
workflow: pipeline-change
profile: deep
```

Cenário: alterar ingestão, transformação, tabela ou mart com consumidores já
existentes.

Por que combina: Data Engineer é dono de pipeline, lineage e layout de
armazenamento; o workflow força mapear consumidores, idempotência e backfill
antes da mudança.

Saída esperada: contrato atual declarado, impacto downstream, estratégia de
backfill, validação de grão e completude, e lineage atualizado.

## Número Divergente Entre Plataforma E Warehouse

```text
role: data-quality-auditor
workflow: metric-discrepancy
profile: deep
```

Cenário: a métrica do GA4, da plataforma de mídia ou do dashboard não bate com
o warehouse e alguém precisa decidir em cima disso.

Por que combina: o role tem postura de auditoria e trilha de evidência; o
workflow compara camada a camada em vez de adivinhar a causa.

Saída esperada: as duas definições confrontadas, a primeira camada onde
divergem, o quanto do gap está explicado, o dono da correção e se a métrica é
segura para a decisão agora.

## Promoção De Modelo Com Suspeita De Drift

```text
skill: ml-lifecycle-engineer
workflow: model-promotion
profile: deep
```

Cenário: existe um modelo candidato, ou o modelo em produção parece ter
degradado, e é preciso decidir promover, segurar ou reverter.

Por que combina: ML Lifecycle Engineer é dono de registry, promoção, rollback e
drift em produção; Data Scientist explica a causa, mas não é dono do gate.

Saída esperada: linhagem da versão, gate declarado com threshold, verificação
de skew treino/serving, resultado da comparação online, decisão registrada e
gatilho de rollback definido.

## Instrumentação De Tracking Ponta A Ponta

```text
skill: analytics-instrumentation
workflow: tracking-implementation
profile: deep
```

Cenário: uma necessidade de mensuração que precisa virar evento implementado,
validado e reconciliado.

Por que combina: o workflow encadeia contrato (Analytics Instrumentation),
implementação (Web Analytics Engineer) e prova de disparo (QA Tracking
Integrations) na ordem certa.

Saída esperada: contrato de evento com identidade, consentimento e chave de
deduplicação; disparo verificado em não-produção; contagem reconciliada; e o
contrato versionado onde os consumidores acham.
