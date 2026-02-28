import 'package:equatable/equatable.dart';

/// Types de moyens de paiement disponibles.
enum PaymentMethodType { wave, orangeMoney, momo, card, cash }

/// Statut de configuration d'un moyen de paiement.
enum PaymentMethodStatus { connected, notConfigured }

/// Entité domaine représentant un moyen de paiement.
class PaymentMethod extends Equatable {
  final String id;
  final PaymentMethodType type;
  final String providerName;
  final String? phoneNumber;
  final String? cardLastDigits;
  final String? expiryDate;
  final bool isDefault;
  final PaymentMethodStatus status;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.providerName,
    this.phoneNumber,
    this.cardLastDigits,
    this.expiryDate,
    this.isDefault = false,
    this.status = PaymentMethodStatus.notConfigured,
  });

  PaymentMethod copyWith({
    String? id,
    PaymentMethodType? type,
    String? providerName,
    String? phoneNumber,
    String? cardLastDigits,
    String? expiryDate,
    bool? isDefault,
    PaymentMethodStatus? status,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      providerName: providerName ?? this.providerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cardLastDigits: cardLastDigits ?? this.cardLastDigits,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
      status: status ?? this.status,
    );
  }

  /// Numéro masqué pour l'affichage (ex: +225 07 •••• 11).
  String get maskedPhone {
    if (phoneNumber == null || phoneNumber!.length < 6) return '';
    final digits = phoneNumber!.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 6) return phoneNumber!;
    final prefix = digits.substring(0, 5);
    final suffix = digits.substring(digits.length - 2);
    return '+225 ${prefix.substring(0, 2)} •••• $suffix';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        providerName,
        phoneNumber,
        cardLastDigits,
        expiryDate,
        isDefault,
        status,
      ];
}
