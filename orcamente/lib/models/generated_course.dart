class CourseContentModule {
  final String id;
  final String title;
  final String content;
  final String estimatedTime;

  const CourseContentModule({
    required this.id,
    required this.title,
    required this.content,
    required this.estimatedTime,
  });

  factory CourseContentModule.fromMap(Map<String, dynamic> map) {
    return CourseContentModule(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      estimatedTime: map['estimatedTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'estimatedTime': estimatedTime,
      };
}

class CourseTopic {
  final String id;
  final String title;
  final String description;
  final List<CourseContentModule> modules;

  const CourseTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.modules,
  });

  factory CourseTopic.fromMap(Map<String, dynamic> map) {
    return CourseTopic(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      modules: (map['modules'] as List<dynamic>? ?? [])
          .map((m) => CourseContentModule.fromMap(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'modules': modules.map((m) => m.toMap()).toList(),
      };
}

class GeneratedCourse {
  final String profile;
  final String city;
  final String state;
  final List<CourseTopic> topics;
  final List<String> practicalTips;
  final List<String> completedModuleIds;
  final int? postQuizScore;
  final DateTime generatedAt;

  const GeneratedCourse({
    required this.profile,
    required this.city,
    required this.state,
    required this.topics,
    required this.practicalTips,
    required this.completedModuleIds,
    required this.generatedAt,
    this.postQuizScore,
  });

  int get totalModules =>
      topics.fold(0, (sum, t) => sum + t.modules.length);

  double get progressPercent =>
      totalModules == 0 ? 0.0 : completedModuleIds.length / totalModules;

  bool get isFullyCompleted =>
      totalModules > 0 && completedModuleIds.length >= totalModules;

  factory GeneratedCourse.fromMap(Map<String, dynamic> map) {
    return GeneratedCourse(
      profile: map['profile'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      generatedAt: DateTime.tryParse(map['generatedAt'] as String? ?? '') ??
          DateTime.now(),
      practicalTips: (map['practicalTips'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      completedModuleIds: (map['completedModuleIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      postQuizScore: (map['postQuizScore'] as num?)?.toInt(),
      topics: (map['topics'] as List<dynamic>? ?? [])
          .map((t) => CourseTopic.fromMap(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'profile': profile,
        'city': city,
        'state': state,
        'generatedAt': generatedAt.toIso8601String(),
        'practicalTips': practicalTips,
        'completedModuleIds': completedModuleIds,
        'postQuizScore': postQuizScore,
        'topics': topics.map((t) => t.toMap()).toList(),
      };

  GeneratedCourse copyWith({
    String? profile,
    String? city,
    String? state,
    List<CourseTopic>? topics,
    List<String>? practicalTips,
    List<String>? completedModuleIds,
    int? postQuizScore,
    DateTime? generatedAt,
  }) {
    return GeneratedCourse(
      profile: profile ?? this.profile,
      city: city ?? this.city,
      state: state ?? this.state,
      topics: topics ?? this.topics,
      practicalTips: practicalTips ?? this.practicalTips,
      completedModuleIds: completedModuleIds ?? this.completedModuleIds,
      postQuizScore: postQuizScore ?? this.postQuizScore,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
