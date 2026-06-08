class ProgressModel {
  final int id;
  final int subjectId;
  final int chapterId;
  final bool completed;
  final int quizScore;
  final String? lastAccessed;

  const ProgressModel({
    required this.id,
    required this.subjectId,
    required this.chapterId,
    required this.completed,
    required this.quizScore,
    this.lastAccessed,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      id:           map['id']           as int,
      subjectId:    map['subject_id']   as int,
      chapterId:    map['chapter_id']   as int,
      completed:    (map['completed']   as int) == 1,
      quizScore:    map['quiz_score']   as int,
      lastAccessed: map['last_accessed']as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':           id,
    'subject_id':   subjectId,
    'chapter_id':   chapterId,
    'completed':    completed ? 1 : 0,
    'quiz_score':   quizScore,
    'last_accessed':lastAccessed,
  };

  @override
  String toString() =>
    'ProgressModel(chapterId: $chapterId, completed: $completed)';
}
