class QuestionModel {
  final int id;
  final int chapterId;
  final String exerciseName;
  final String questionNumber;
  final String questionText;
  final String questionType;

  const QuestionModel({
    required this.id,
    required this.chapterId,
    required this.exerciseName,
    required this.questionNumber,
    required this.questionText,
    required this.questionType,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id:             map['id']              as int,
      chapterId:      map['chapter_id']      as int,
      exerciseName:   map['exercise_name']   as String,
      questionNumber: map['question_number'] as String,
      questionText:   map['question_text']   as String,
      questionType:   map['question_type']   as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':              id,
    'chapter_id':      chapterId,
    'exercise_name':   exerciseName,
    'question_number': questionNumber,
    'question_text':   questionText,
    'question_type':   questionType,
  };

  // Question types
  bool get isMCQ     => questionType == 'mcq';
  bool get isShort   => questionType == 'short';
  bool get isLong    => questionType == 'long';
  bool get isFillIn  => questionType == 'fillin';

  @override
  String toString() =>
    'QuestionModel(id: $id, exercise: $exerciseName, q: $questionNumber)';
}
