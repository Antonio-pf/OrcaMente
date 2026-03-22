import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../models/quiz.dart';
import 'location_service.dart';
import 'dart:convert';

/// Service to interact with Google Gemini AI for quiz generation
class GeminiService {
  late final GenerativeModel _model;
  final String _apiKey;

  GeminiService({required String apiKey}) : _apiKey = apiKey {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 4096,
      ),
    );
    print('✅ [GeminiService] Modelo inicializado: gemini-flash-latest');
  }

  /// Generate localized quiz questions based on user location
  Future<Result<List<QuizQuestion>>> generateLocalizedQuiz({
    required LocationDetails location,
    required String topic,
    int questionCount = 5,
  }) async {
    print('🤖 [GeminiService] Iniciando geração de quiz...');
    print('📍 [GeminiService] Localização: ${location.city}, ${location.state}');
    try {
      final prompt = _buildQuizPrompt(
        location: location,
        topic: topic,
        questionCount: questionCount,
      );

      print('📝 [GeminiService] Prompt criado, enviando para Gemini...');
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      print('📥 [GeminiService] Resposta recebida do Gemini');
      print('📄 [GeminiService] Tamanho da resposta: ${text?.length} caracteres');

      if (text == null || text.isEmpty) {
        print('❌ [GeminiService] Resposta vazia do Gemini');
        return Failure(
          'IA não retornou resposta válida',
          DataException('ai-empty-response'),
        );
      }

      // Parse JSON response
      print('🔍 [GeminiService] Parseando JSON...');
      final questions = _parseQuizResponse(text);

      if (questions.isEmpty) {
        print('❌ [GeminiService] Nenhuma pergunta válida gerada');
        return Failure(
          'Não foi possível gerar perguntas válidas',
          DataException('ai-parsing-failed'),
        );
      }

      print('✅ [GeminiService] ${questions.length} perguntas geradas com sucesso!');
      return Success(questions);
    } catch (e) {
      print('❌ [GeminiService] Erro ao gerar quiz: $e');
      return Failure(
        'Erro ao gerar quiz com IA: $e',
        DataException('ai-generation-error'),
      );
    }
  }

  /// Generate personalized learning content based on quiz results
  Future<Result<Map<String, dynamic>>> generatePersonalizedContent({
    required Map<String, dynamic> quizResults,
    required LocationDetails location,
    required List<String> weakTopics,
  }) async {
    try {
      final prompt = _buildContentPrompt(
        quizResults: quizResults,
        location: location,
        weakTopics: weakTopics,
      );

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        return Failure(
          'IA não retornou conteúdo válido',
          DataException('ai-empty-response'),
        );
      }

      // Parse content response
      final content = _parseContentResponse(text);

      return Success(content);
    } catch (e) {
      return Failure(
        'Erro ao gerar conteúdo personalizado: $e',
        DataException('ai-generation-error'),
      );
    }
  }

  /// Build prompt for quiz generation
  String _buildQuizPrompt({
    required LocationDetails location,
    required String topic,
    required int questionCount,
  }) {
    return '''
Você é um especialista em educação financeira no Brasil.

CONTEXTO DO USUÁRIO:
- Cidade: ${location.city}
- Estado: ${location.state}
- País: ${location.country}

TAREFA:
Gere $questionCount perguntas de múltipla escolha sobre "$topic" ULTRA-PERSONALIZADAS para a realidade ESPECÍFICA de ${location.city}, ${location.state}.

REQUISITOS OBRIGATÓRIOS:
1. LOCALIZAÇÃO EXTREMA: Use exemplos hiperlocais da cidade de ${location.city}:
   - Custos de vida específicos (ex: preço médio do aluguel, combustível, transporte público)
   - Impostos municipais e estaduais (IPTU, IPVA, ISS específicos da região)
   - Estabelecimentos e serviços conhecidos da cidade
   - Desafios econômicos regionais (inflação local, desemprego regional)

2. LINGUAGEM E DIALETO LOCAL:
   - Use expressões e gírias típicas de ${location.city}/${location.state}
   - Adapte exemplos ao sotaque e vocabulário regional
   - Mencione contextos culturais e econômicos da região

3. ESTRUTURA DAS PERGUNTAS:
   - Cada pergunta deve ter 3 opções de resposta
   - Pontuações refletem nível de conhecimento:
     * Pontuação 2: baixo conhecimento financeiro
     * Pontuação 1: conhecimento intermediário
     * Pontuação 0: alto conhecimento financeiro

4. TIPOS DE PERGUNTAS:
   - Misture perguntas de comportamento financeiro
   - Inclua perguntas de conhecimento técnico adaptadas à realidade local

EXEMPLOS DE PERSONALIZAÇÃO:
- Em vez de "Como você paga suas contas?", use "Como você organiza o pagamento do IPTU de ${location.city}?"
- Mencione custo de transporte específico (ex: "tarifa do ônibus", "preço do metrô", "pedágio da região")
- Use referências locais (ex: "feira da cidade", "supermercado regional", "banco popular da região")

FORMATO DE RESPOSTA (JSON válido):
{
  "questions": [
    {
      "id": "q1",
      "question": "Texto da pergunta com contexto HIPERLOCAL de ${location.city}",
      "options": ["Opção 1 com expressão local", "Opção 2", "Opção 3"],
      "scores": [2, 1, 0]
    }
  ]
}

IMPORTANTE: Retorne APENAS o JSON, sem texto adicional antes ou depois.
''';
  }

  /// Build prompt for content generation
  String _buildContentPrompt({
    required Map<String, dynamic> quizResults,
    required LocationDetails location,
    required List<String> weakTopics,
  }) {
    return '''
Você é um tutor de educação financeira personalizado.

CONTEXTO DO USUÁRIO:
- Localização: ${location.city}, ${location.state}
- Perfil: ${quizResults['behaviorProfile'] ?? 'Desconhecido'}
- Nível de Conhecimento: ${quizResults['knowledgeLevel'] ?? 'Desconhecido'}
- Pontuação Total: ${quizResults['totalScore'] ?? 0}

TÓPICOS QUE PRECISAM DE REFORÇO:
${weakTopics.map((t) => '- $t').join('\n')}

TAREFA:
Crie um plano de aprendizado PERSONALIZADO com conteúdo específico para ${location.city}, ${location.state}.

FORMATO DE RESPOSTA (JSON válido):
{
  "learningPath": [
    {
      "topic": "Nome do tópico",
      "description": "Descrição adaptada à realidade local",
      "modules": [
        {
          "title": "Título do módulo",
          "content": "Conteúdo educativo com exemplos locais",
          "estimatedTime": "15 minutos"
        }
      ]
    }
  ],
  "practicalTips": [
    "Dica prática 1 contextualizada para ${location.city}",
    "Dica prática 2"
  ],
  "localResources": [
    "Recursos financeiros disponíveis em ${location.city}"
  ]
}

IMPORTANTE: Retorne APENAS o JSON, sem texto adicional.
''';
  }

  /// Parse quiz JSON response
  List<QuizQuestion> _parseQuizResponse(String response) {
    try {
      print('🔧 [GeminiService] Limpando resposta...');
      // Remove markdown code blocks if present
      String cleanResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      print('🔧 [GeminiService] Decodificando JSON...');
      final json = jsonDecode(cleanResponse) as Map<String, dynamic>;
      final questionsJson = json['questions'] as List<dynamic>;

      print('🔧 [GeminiService] Validando perguntas...');
      final questions = questionsJson
          .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
          .where((q) => q.isValid())
          .toList();

      print('✅ [GeminiService] ${questions.length} perguntas válidas parseadas');
      return questions;
    } catch (e) {
      print('❌ [GeminiService] Erro ao parsear resposta: $e');
      print('📄 [GeminiService] Resposta original: $response');
      // Fallback: return empty list
      return [];
    }
  }

  /// Parse content JSON response
  Map<String, dynamic> _parseContentResponse(String response) {
    try {
      // Remove markdown code blocks if present
      String cleanResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanResponse) as Map<String, dynamic>;
    } catch (e) {
      // Fallback: return minimal structure
      return {
        'learningPath': [],
        'practicalTips': [],
        'localResources': [],
      };
    }
  }

  /// Analyze quiz answers using AI to determine financial profile
  Future<Result<Map<String, String>>> analyzeQuizAnswers({
    required List<QuizQuestion> questions,
    required List<int> selectedAnswers,
    required LocationDetails location,
  }) async {
    print('🤖 [GeminiService] Analisando respostas do quiz com IA...');
    try {
      final prompt = _buildAnalysisPrompt(
        questions: questions,
        selectedAnswers: selectedAnswers,
        location: location,
      );

      print('📝 [GeminiService] Enviando respostas para análise...');
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      print('📥 [GeminiService] Análise recebida do Gemini');

      if (text == null || text.isEmpty) {
        print('❌ [GeminiService] Resposta vazia do Gemini');
        return Failure(
          'IA não retornou análise válida',
          DataException('ai-empty-response'),
        );
      }

      // Parse analysis response
      print('🔍 [GeminiService] Parseando análise...');
      final analysis = _parseAnalysisResponse(text);

      if (analysis.isEmpty) {
        print('❌ [GeminiService] Análise inválida');
        return Failure(
          'Não foi possível analisar as respostas',
          DataException('ai-parsing-failed'),
        );
      }

      print('✅ [GeminiService] Análise completa realizada!');
      return Success(analysis);
    } catch (e) {
      print('❌ [GeminiService] Erro ao analisar respostas: $e');
      return Failure(
        'Erro ao analisar respostas com IA: $e',
        DataException('ai-analysis-error'),
      );
    }
  }

  /// Build prompt for quiz answers analysis
  String _buildAnalysisPrompt({
    required List<QuizQuestion> questions,
    required List<int> selectedAnswers,
    required LocationDetails location,
  }) {
    // Build the questions and answers text
    final questionsAndAnswers = StringBuffer();
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selectedIndex = selectedAnswers[i];
      final selectedOption = question.options[selectedIndex];
      
      questionsAndAnswers.writeln('''
Pergunta ${i + 1}: ${question.question}
Resposta escolhida: $selectedOption
''');
    }

    return '''
Você é um especialista em psicologia financeira e análise comportamental.

CONTEXTO DO USUÁRIO:
- Localização: ${location.city}, ${location.state}
- Total de perguntas respondidas: ${questions.length}

RESPOSTAS DO QUIZ:
$questionsAndAnswers

TAREFA:
Analise PROFUNDAMENTE as respostas do usuário e determine:

1. PERFIL FINANCEIRO (escolha UM dos perfis):
   - Gastador: Pessoa que prioriza consumo imediato, tem dificuldade em poupar, tende a gastos impulsivos
   - Poupador: Pessoa cautelosa com dinheiro, prioriza economia, prefere segurança financeira, evita riscos
   - Investidor: Pessoa que busca fazer o dinheiro trabalhar, entende de investimentos, aceita riscos calculados

2. NÍVEL DE CONHECIMENTO FINANCEIRO (escolha UM):
   - Iniciante: Pouco conhecimento sobre finanças, precisa de orientação básica
   - Intermediário: Conhecimento médio, entende conceitos básicos mas precisa aprofundar
   - Avançado: Bom conhecimento, entende conceitos complexos de finanças

3. JUSTIFICATIVA: Explique em 2-3 frases POR QUE você classificou a pessoa assim, baseado nas respostas específicas.

FORMATO DE RESPOSTA (JSON válido):
{
  "profile": "Gastador" | "Poupador" | "Investidor",
  "knowledgeLevel": "Iniciante" | "Intermediário" | "Avançado",
  "justification": "Explicação detalhada do por quê dessa classificação, mencionando padrões observados nas respostas."
}

IMPORTANTE: 
- Seja criterioso e preciso na análise
- Base sua decisão nos padrões de comportamento observados
- Retorne APENAS o JSON, sem texto adicional
''';
  }

  /// Parse analysis JSON response
  Map<String, String> _parseAnalysisResponse(String response) {
    try {
      print('🔧 [GeminiService] Limpando resposta da análise...');
      // Remove markdown code blocks if present
      String cleanResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Remove trailing commas before closing braces/brackets (common AI mistake)
      cleanResponse = cleanResponse
          .replaceAll(RegExp(r',\s*}'), '}')
          .replaceAll(RegExp(r',\s*]'), ']');

      // Remove line breaks within string values that can break JSON parsing
      cleanResponse = cleanResponse.replaceAllMapped(
        RegExp(r'"[^"]*"'),
        (match) => match.group(0)!.replaceAll('\n', ' '),
      );

      print('🔧 [GeminiService] Decodificando JSON da análise...');
      final json = jsonDecode(cleanResponse) as Map<String, dynamic>;

      final result = {
        'profile': json['profile'] as String? ?? 'Poupador',
        'knowledgeLevel': json['knowledgeLevel'] as String? ?? 'Intermediário',
        'justification': json['justification'] as String? ?? 'Análise baseada nas respostas fornecidas.',
      };

      print('✅ [GeminiService] Análise parseada: ${result['profile']} - ${result['knowledgeLevel']}');
      return result;
    } catch (e) {
      print('❌ [GeminiService] Erro ao parsear análise: $e');
      print('📄 [GeminiService] Resposta original: $response');
      // Fallback: return default values
      return {
        'profile': 'Poupador',
        'knowledgeLevel': 'Intermediário',
        'justification': 'Análise baseada nas respostas fornecidas.',
      };
    }
  }
}
