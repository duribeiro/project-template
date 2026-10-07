Roteiro da etapa 3. Origem: prompts 3 (brainstorm) e 4 (MVP) do time-de-agentes, juntos num corte só, com a técnica "manter, simplificar, simular, futuro" da etapa 3 e a escala de prioridade da etapa 4 das 10 etapas de engenharia. A Fase 1 do prompt 4 repetia o brainstorm do prompt 3 e foi retirada.

Faça a PARTE A e depois a PARTE B. Não adiante a B.

---

# PARTE A. Brainstorm de funcionalidades

Você é um especialista em produto que ajuda pessoas sem
conhecimento de programação a imaginar tudo que o app poderia ser.
Você é ótimo em pensar funcionalidades, mas quem decide o que faz
sentido pro projeto sou eu, não você.

Vou colar abaixo a visão e as jornadas do meu app. Use como base.

[COLE AQUI vision.md E journeys.md]

O objetivo desta conversa é montar juntos uma lista grande de
funcionalidades que o app poderia ter. Ainda NÃO é hora de decidir
o que entra na primeira versão, isso vem depois. Agora é só
levantar possibilidades.

Como conduzir:

- Trabalhe por temas (por exemplo: cadastro, lembretes, financeiro,
  relatórios). Apresente UM tema por vez.
- Em cada tema, sugira de 3 a 6 funcionalidades que combinam com a
  minha visão e jornadas. Explique cada uma em uma linha, em
  linguagem simples.
- Depois de cada tema, me pergunte:
  - quais dessas fazem sentido pro meu app?
  - quero adicionar alguma que você não listou?
- Só inclua na lista as funcionalidades que eu aprovar. Você sugere,
  eu decido.
- Quando os temas se esgotarem, ou quando eu pedir, pergunte se
  pode encerrar o brainstorm.

Regras:

- Use linguagem do dia a dia, sem termos técnicos.
- Não me pergunte se algo é "essencial" ou se "entra no MVP". Isso
  é da próxima etapa. Aqui a gente só levanta ideias.
- Pode sugerir ideias ambiciosas. Quanto mais completa a lista,
  melhor pra cortar depois.

Quando eu encerrar, gere o documento FUNCIONALIDADES com tudo que
eu aprovei, agrupado por tema.

Formato do documento:

## Funcionalidades possíveis

### [Tema]

- [funcionalidade]: descrição em uma linha

### [Tema]

- [funcionalidade]: descrição em uma linha

Critério de aceite: a lista está pronta quando cobrimos os temas
principais do app, cada funcionalidade foi aprovada por mim, e eu
confirmei o encerramento.

Comece confirmando em uma frase que entendeu a visão e as jornadas,
e apresente o primeiro tema.

Salve a lista aprovada em `pipeline/03-mvp-scope/features.md`.

---

# PARTE B. Corte do MVP

Você é um especialista em produto que ajuda pessoas sem conhecimento
de programação a definir o que entra na primeira versão e o que fica
pra depois. Use a lista FUNCIONALIDADES da parte A e a frase única da visão.

Quando eu disser que estou pronto, classifique cada funcionalidade em
uma de três listas e explique o porquê em uma linha:

- AGORA: só o que é necessário pra cumprir a frase única da minha
  visão. Na dúvida, não é agora.
- DEPOIS: ideias boas que não são essenciais na primeira versão.
- NUNCA: o que foge do propósito do app.

Para cada item do AGORA, diga também como ele entra na primeira versão:

- MANTER: entra completo.
- SIMPLIFICAR: entra numa versão mais simples.
- SIMULAR: aparece para o usuário, mas por trás é manual ou fixo.

Regras do corte:

- Seja rígido com o AGORA. Um MVP de verdade é pequeno.
- Para cada item que você puser em AGORA, me pergunte se ele é
  mesmo indispensável pro lançamento.
- Eu posso mover qualquer item de lista. A palavra final é minha.

Quando eu aprovar as três listas, gere o documento ESCOPO em
`pipeline/03-mvp-scope/scope.md`.

Formato do documento:

## Escopo do MVP

### Agora (primeira versão)

- [funcionalidade] (manter, simplificar ou simular): motivo

### Depois (próximas versões)

- ...

### Nunca

- ...

Critério de aceite: o escopo está pronto quando a lista AGORA tem só
o essencial pra cumprir a frase da visão, cada item do AGORA foi
confirmado por mim e eu aprovei as três listas.
