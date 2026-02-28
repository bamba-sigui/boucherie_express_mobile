import '../../domain/entities/support_contact.dart';

/// Modèle de données pour un contact support.
///
/// Étend [SupportContact] avec la sérialisation JSON.
class SupportContactModel extends SupportContact {
  const SupportContactModel({
    required super.id,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.value,
    super.isOnline,
  });

  factory SupportContactModel.fromJson(Map<String, dynamic> json) {
    return SupportContactModel(
      id: json['id'] as String,
      type: SupportContactType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SupportContactType.phone,
      ),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      value: json['value'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'isOnline': isOnline,
    };
  }
}
