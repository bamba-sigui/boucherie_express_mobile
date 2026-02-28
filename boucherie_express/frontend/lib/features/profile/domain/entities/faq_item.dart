import 'package:equatable/equatable.dart';

/// Élément de FAQ (Question fréquente).
///
/// [isExpanded] est un état UI uniquement, il ne fait pas partie
/// de l'identité de l'entité (exclu de props Equatable).
class FaqItem extends Equatable {
  final String id;
  final String question;
  final String answer;
  final bool isExpanded;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [id, question, answer];
}
