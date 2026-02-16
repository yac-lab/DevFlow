import 'dart:convert';

class Flashcard {
  String id;
  String category;
  String question;
  String answer;
  String explanation;
  String docUrl;
  String logoUrl;

  Flashcard({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.explanation,
    required this.docUrl,
    required this.logoUrl,
  });
  factory Flashcard.fromMap(Map<String, dynamic> m) {
    return Flashcard(
      id: m['id'] ?? '',
      category: m['category'] ?? '',
      question: m['question'] ?? '',
      answer: m['answer'] ?? '',
      explanation: m['explanation'] ?? '',
      docUrl: m['docUrl'] ?? '',
      logoUrl: m['logoUrl'] ?? '',
    );
  }
  static List<Flashcard> listFromJson(String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString);
    List<Flashcard> flashcards = [];

    for (var item in jsonList) {
      flashcards.add(Flashcard.fromMap(item));
    }

    return flashcards;
  }
}
