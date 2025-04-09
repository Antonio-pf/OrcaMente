import 'dart:convert';

class PiggyBankModel {
  final String id;
  final String name;
  final double goal;
  double saved;

  PiggyBankModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.saved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'saved': saved,
    };
  }

  factory PiggyBankModel.fromMap(Map<String, dynamic> map) {
    return PiggyBankModel(
      id: map['id'],
      name: map['name'],
      goal: (map['goal'] as num).toDouble(),
      saved: (map['saved'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PiggyBankModel.fromJson(String source) =>
      PiggyBankModel.fromMap(json.decode(source));
}
