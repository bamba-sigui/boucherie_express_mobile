import 'package:injectable/injectable.dart';

import '../models/faq_item_model.dart';
import '../models/support_contact_model.dart';
import '../../domain/entities/support_contact.dart';

/// Source de données locale pour le support.
///
/// Fournit les FAQ et contacts en mock.
/// Remplaçable par une source distante (API / Firebase) ultérieurement.
@injectable
class SupportLocalDatasource {
  /// Retourne les FAQ par défaut.
  Future<List<FaqItemModel>> getFaqs() async {
    // Simule un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      FaqItemModel(
        id: 'faq_1',
        question: 'Comment suivre ma commande ?',
        answer:
            'Vous pouvez suivre l\'état de votre livraison en temps réel dans '
            'la section "Commandes" de l\'application. Une notification vous '
            'sera envoyée à chaque étape.',
      ),
      FaqItemModel(
        id: 'faq_2',
        question: 'Quels sont les délais de livraison ?',
        answer:
            'Nos livreurs s\'efforcent de vous livrer en moins de 45 minutes '
            'pour toute commande passée dans nos zones de couverture habituelles.',
      ),
      FaqItemModel(
        id: 'faq_3',
        question: 'Zone de livraison couverte',
        answer:
            'Nous livrons actuellement dans tout Abidjan (Cocody, Marcory, '
            'Plateau, Riviera, etc.). De nouvelles zones seront bientôt disponibles.',
      ),
      FaqItemModel(
        id: 'faq_4',
        question: 'Moyens de paiement acceptés',
        answer:
            'Nous acceptons le paiement en espèces à la livraison, ainsi que '
            'les paiements mobiles (Orange Money, MTN MoMo, Wave).',
      ),
    ];
  }

  /// Retourne les contacts support par défaut.
  Future<List<SupportContactModel>> getSupportContacts() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const [
      SupportContactModel(
        id: 'contact_phone',
        type: SupportContactType.phone,
        title: 'Appeler le support',
        subtitle: 'Disponible de 8h à 20h',
        value: '+2250700000000',
      ),
      SupportContactModel(
        id: 'contact_whatsapp',
        type: SupportContactType.whatsapp,
        title: 'WhatsApp Support',
        subtitle: 'Réponse rapide par message',
        value: '+2250700000000',
        isOnline: true,
      ),
    ];
  }
}
