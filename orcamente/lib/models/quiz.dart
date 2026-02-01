/// Enhanced Quiz model with validation and serialization
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final List<int> scores;

  // Business rules constants
  static const int minOptions = 2;
  static const int maxOptions = 10;
  static const int maxQuestionLength = 500;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.scores,
  });

  /// Create from Map (Firestore deserialization)
  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    try {
      return QuizQuestion(
        id: data['id'] as String? ?? '',
        question: data['question'] as String? ?? '',
        options:
            (data['options'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        scores:
            (data['scores'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            [],
      );
    } catch (e) {
      throw FormatException('Invalid quiz question data: $e');
    }
  }

  /// Convert to Map for Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'scores': scores,
    };
  }

  /// Validate quiz question data
  bool isValid() {
    return id.isNotEmpty &&
        question.isNotEmpty &&
        question.length <= maxQuestionLength &&
        options.length >= minOptions &&
        options.length <= maxOptions &&
        scores.length == options.length &&
        options.every((option) => option.isNotEmpty) &&
        scores.every((score) => score >= 0);
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('ID é obrigatório');
    }

    if (question.isEmpty) {
      errors.add('Pergunta é obrigatória');
    } else if (question.length > maxQuestionLength) {
      errors.add('Pergunta deve ter no máximo $maxQuestionLength caracteres');
    }

    if (options.length < minOptions) {
      errors.add('Deve ter no mínimo $minOptions opções');
    } else if (options.length > maxOptions) {
      errors.add('Deve ter no máximo $maxOptions opções');
    }

    if (options.any((option) => option.isEmpty)) {
      errors.add('Todas as opções devem ter texto');
    }

    if (scores.length != options.length) {
      errors.add('Número de pontuações deve ser igual ao número de opções');
    }

    if (scores.any((score) => score < 0)) {
      errors.add('Pontuações devem ser não-negativas');
    }

    return errors;
  }

  /// Copy with method for immutability
  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    List<int>? scores,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      scores: scores ?? this.scores,
    );
  }

  @override
  String toString() {
    return 'QuizQuestion(id: $id, question: $question, options: ${options.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizQuestion &&
        other.id == id &&
        other.question == question &&
        _listEquals(other.options, options) &&
        _listEquals(other.scores, scores);
  }

  @override
  int get hashCode {
    return id.hashCode ^ question.hashCode ^ options.hashCode ^ scores.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

/// Quiz answer model for storing user responses
class QuizAnswer {
  final String questionId;
  final int selectedOption;
  final int score;
  final DateTime answeredAt;

  const QuizAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.score,
    required this.answeredAt,
  });

  factory QuizAnswer.fromMap(Map<String, dynamic> data) {
    return QuizAnswer(
      questionId: data['questionId'] as String? ?? '',
      selectedOption: (data['selectedOption'] as num?)?.toInt() ?? 0,
      score: (data['score'] as num?)?.toInt() ?? 0,
      answeredAt:
          data['answeredAt'] is String
              ? DateTime.parse(data['answeredAt'] as String)
              : (data['answeredAt'] as DateTime? ?? DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
      'score': score,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  bool isValid() {
    return questionId.isNotEmpty && selectedOption >= 0 && score >= 0;
  }
}
