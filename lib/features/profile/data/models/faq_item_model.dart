import '../../domain/entities/faq_item.dart';

/// Modèle de données pour un élément FAQ.
///
/// Étend [FaqItem] avec la sérialisation JSON.
class FaqItemModel extends FaqItem {
  const FaqItemModel({
    required super.id,
    required super.question,
    required super.answer,
    super.isExpanded,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}
