class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      userId: map['userId'] as String,
    );
  }
}
