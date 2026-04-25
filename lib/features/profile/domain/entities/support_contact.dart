import 'package:equatable/equatable.dart';

/// Type de contact support.
enum SupportContactType { phone, whatsapp, email }

/// Représente un canal de contact.
class SupportContact extends Equatable {
  final String id;
  final SupportContactType type;
  final String title;
  final String subtitle;
  final String value; // numéro, url, email
  final bool isOnline;

  const SupportContact({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, type, title, subtitle, value, isOnline];
}
