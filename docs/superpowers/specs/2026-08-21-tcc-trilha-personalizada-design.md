# Design: Trilha de Aprendizado Personalizada (TCC FATEC)

**Data:** 2026-08-21  
**Autor:** Antonio Pires Felipe  
**Prazo:** Novembro 2026  
**Contexto:** Evolução do OrcaMente para TCC FATEC — artigo + apresentação Worktech

---

## 1. Hipótese e Medição

**Hipótese:**  
"Uma trilha de aprendizado personalizada por perfil financeiro e contexto geográfico melhora o conhecimento financeiro de usuários brasileiros."

**Fluxo de medição:**

```
Quiz inicial → perfil + pre_score salvo no Firestore
    ↓
Trilha de módulos gerada por IA (perfil + cidade)
    ↓
Usuário conclui módulos (progresso salvo)
    ↓
Post-quiz ao concluir todos os módulos → post_score salvo
    ↓
Artigo analisa: delta = post_score - pre_score (15–30 usuários)
```

**Dados coletados por usuário (Firestore):**
- `pre_score` + `behaviorProfile` + `knowledgeLevel` + `location` (já existe)
- `completedModuleIds` (novo)
- `postQuizScore` + `postQuizCompletedAt` (novo)

**Meta de usuários para o artigo:** 15–30 pessoas completando o fluxo inteiro.

---

## 2. Modelo de Dados — Firestore

### Estrutura existente (não muda)
```
users/{uid}/
  name, email, quizData: { pre_score, behaviorProfile, knowledgeLevel, location, ... }
```

### Nova subcoleção
```
users/{uid}/generatedCourse (documento único por usuário)
├── generatedAt: timestamp
├── profile: "Gastador" | "Poupador" | "Investidor"
├── location: { city, state }
├── topics: [
│     {
│       id: "topic_1",
│       title: "Controle de Gastos",
│       modules: [
│         { id: "m1", title: "...", content: "...", estimatedTime: "15 min" }
│       ]
│     }
│   ]
├── practicalTips: [string]
├── completedModuleIds: []
└── postQuizScore: null
```

**Regra de negócio:** Se `generatedCourse` já existe no Firestore, carrega sem chamar o Gemini. Só gera de novo se o usuário refizer o quiz.

### Novos modelos Dart
- `GeneratedCourse` — representa o documento acima
- `CourseProgress` — calculado localmente: `completedModuleIds.length / totalModules`

### Campo novo em UserData
- `postQuizCompletedAt: DateTime?` — indica se o ciclo foi concluído

---

## 3. Fluxo de Telas

```
Login/Cadastro
    ↓
QuizPage (já existe)
    ↓
QuizResultPage → botão "Ver Minha Trilha" (substitui "Continuar")
    ↓
CourseListPage (redesenhada)
  ├── Barra de progresso geral (X de Y módulos)
  ├── Card por tópico com progresso individual
  └── Botão "Fazer Quiz Final" (visível só quando todos os módulos concluídos)
       ↓
  CourseModulesPage (atualizada — conteúdo dinâmico da IA)
    └── tap no módulo → ModuleContentPage (nova)
          └── botão "Concluir Módulo" → markModuleComplete() no Firestore
                               ↓ (quando tudo concluído)
                     PostQuizPage (nova — 5 perguntas)
                               ↓
                     PostQuizResultPage (nova — gráfico pré vs pós)
```

### Telas existentes que mudam

| Tela | O que muda |
|---|---|
| `quiz_result.dart` | Botão "Continuar" → "Ver Minha Trilha"; dispara geração do curso |
| `course_page.dart` | Reescrita para carregar curso do Firestore + mostrar progresso real |
| `course_modules_pages.dart` | Módulos vêm da IA, não de `Course.sampleCourses` |

### Telas novas a criar

| Tela | Responsabilidade |
|---|---|
| `module_content_page.dart` | Exibe conteúdo do módulo + botão "Concluir" |
| `post_quiz_page.dart` | Mini-quiz de 5 perguntas geradas por IA |
| `post_quiz_result_page.dart` | Gráfico pré vs pós com `fl_chart` |

**Nota de UI:** Telas novas usam `shadcn_flutter`. Refatoração das telas existentes para `shadcn_flutter` é trabalho futuro pós-TCC.

---

## 4. Novos Subsistemas de Código

### CourseRepository (novo)
```dart
class CourseRepository {
  Future<GeneratedCourse?> getCourse(String userId);
  Future<void> saveCourse(String userId, GeneratedCourse course);
  Future<void> markModuleComplete(String userId, String moduleId);
  Future<void> savePostQuizScore(String userId, int score);
}
```

### CourseController (novo)
- Carrega curso do Firestore via `CourseRepository`
- Se não existe, chama `GeminiService.generatePersonalizedContent()` e salva
- Expõe `CourseProgress` calculado para a UI
- Método `markModuleComplete()` atualiza Firestore e notifica listeners

### GeminiService — método novo
```dart
Future<Result<List<QuizQuestion>>> generatePostQuiz({
  required List<String> studiedTopics,
  required LocationDetails location,
  required String profile,
})
```

Prompt instrui o Gemini a gerar perguntas de **conhecimento objetivo** (certo/errado), não comportamentais. Isso garante que o delta pré vs pós mede aprendizado real.

### Diferença quiz inicial vs post-quiz

| | Quiz inicial | Post-quiz |
|---|---|---|
| Objetivo | Diagnosticar perfil | Medir conhecimento adquirido |
| Tipo de pergunta | Comportamental | Conhecimento objetivo |
| Resultado | Perfil + pre_score | Percentual de acertos |
| Gerado com | Localização | Tópicos estudados + localização |

---

## 5. Pacotes Adicionados

| Pacote | Uso |
|---|---|
| `shadcn_flutter` | Componentes UI das telas novas |
| `fl_chart` | Gráfico de barras pré vs pós no PostQuizResultPage |

Pacotes descartados do escopo TCC: gráficos de trading, OTP/pinput, flutter_credit_card. Ficam como sugestão de trabalhos futuros no artigo.

---

## 6. Fluxo da IA no App

```
1. generateLocalizedQuiz()       → quiz inicial           (já existe)
2. analyzeQuizAnswers()          → perfil + pre_score     (já existe)
3. generatePersonalizedContent() → trilha de módulos      (existe, precisa ser conectado)
4. generatePostQuiz()            → mini-quiz final        (novo)
```

---

## 7. O que Fica Fora do Escopo (Trabalhos Futuros)

- Badges e conquistas por tópico de domínio
- Refatoração das telas existentes para `shadcn_flutter`
- Trilha periódica com re-quiz ao longo do tempo
- Ranking entre usuários
- Notificações push de lembretes de estudo

---

## 8. Riscos

| Risco | Mitigação |
|---|---|
| Dropout de usuários (não completam o fluxo) | Recrutar pessoas comprometidas, não link genérico no WhatsApp |
| Custo de chamadas Gemini | Curso gerado uma vez e salvo no Firestore |
| Prazo solo até novembro | Escopo fixo — features novas vão para trabalhos futuros |
