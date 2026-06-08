class SolutionModel {
  final int id;
  final int questionId;
  final String solutionText;
  final String? diagramSvg;
  final String difficulty;

  const SolutionModel({
    required this.id,
    required this.questionId,
    required this.solutionText,
    this.diagramSvg,
    this.difficulty = 'medium',
  });

  factory SolutionModel.fromMap(Map<String, dynamic> map) {
    return SolutionModel(
      id:           map['id']           as int,
      questionId:   map['question_id']  as int,
      solutionText: map['solution_text']as String,
      diagramSvg:   map['diagram_svg']  as String?,
      difficulty:   map['difficulty']   as String? ?? 'medium',
    );
  }

  Map<String, dynamic> toMap() => {
    'id':            id,
    'question_id':   questionId,
    'solution_text': solutionText,
    'diagram_svg':   diagramSvg,
    'difficulty':    difficulty,
  };

  bool get hasDiagram => diagramSvg != null && diagramSvg!.isNotEmpty;

  bool get isEasy   => difficulty == 'easy';
  bool get isMedium => difficulty == 'medium';
  bool get isHard   => difficulty == 'hard';

  @override
  String toString() =>
    'SolutionModel(id: $id, questionId: $questionId)';
}
