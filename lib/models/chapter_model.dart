class ChapterModel {
  final int id;
  final int subjectId;
  final int number;
  final String title;
  final String? titleMarathi;
  final String? titleHindi;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.number,
    required this.title,
    this.titleMarathi,
    this.titleHindi,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id:            map['id']             as int,
      subjectId:     map['subject_id']     as int,
      number:        map['number']         as int,
      title:         map['title']          as String,
      titleMarathi:  map['title_marathi']  as String?,
      titleHindi:    map['title_hindi']    as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':            id,
    'subject_id':    subjectId,
    'number':        number,
    'title':         title,
    'title_marathi': titleMarathi,
    'title_hindi':   titleHindi,
  };

  String displayTitle(String lang) {
    if (lang == 'mr' && titleMarathi != null) return titleMarathi!;
    if (lang == 'hi' && titleHindi   != null) return titleHindi!;
    return title;
  }

  String get chapterLabel => 'Chapter $number';

  @override
  String toString() => 'ChapterModel(id: $id, number: $number, title: $title)';
}
