import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/faq_item.dart';
import '../../domain/entities/support_contact.dart';
import '../../domain/usecases/get_faqs.dart';
import '../../domain/usecases/get_support_contacts.dart';

// ─── Events ──────────────────────────────────────────────────────

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

/// Charge les FAQ et les contacts support.
class LoadSupport extends SupportEvent {}

/// Bascule l'état d'expansion d'un FAQ (accordéon exclusif).
class ToggleFaq extends SupportEvent {
  final String faqId;
  const ToggleFaq(this.faqId);

  @override
  List<Object?> get props => [faqId];
}

// ─── States ──────────────────────────────────────────────────────

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<FaqItem> faqs;
  final List<SupportContact> contacts;

  const SupportLoaded({required this.faqs, required this.contacts});

  @override
  List<Object?> get props => [faqs, contacts];

  /// Copie avec mise à jour partielle.
  SupportLoaded copyWith({
    List<FaqItem>? faqs,
    List<SupportContact>? contacts,
  }) {
    return SupportLoaded(
      faqs: faqs ?? this.faqs,
      contacts: contacts ?? this.contacts,
    );
  }
}

class SupportError extends SupportState {
  final String message;
  const SupportError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Bloc ────────────────────────────────────────────────────────

@injectable
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetFaqs _getFaqs;
  final GetSupportContacts _getSupportContacts;

  SupportBloc(this._getFaqs, this._getSupportContacts)
      : super(SupportInitial()) {
    on<LoadSupport>(_onLoadSupport);
    on<ToggleFaq>(_onToggleFaq);
  }

  Future<void> _onLoadSupport(
    LoadSupport event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());

    final faqsResult = await _getFaqs();
    final contactsResult = await _getSupportContacts();

    // Si les deux échouent, afficher l'erreur
    if (faqsResult.isLeft() && contactsResult.isLeft()) {
      emit(const SupportError('Impossible de charger les données'));
      return;
    }

    final faqs = faqsResult.getOrElse(() => []);
    final contacts = contactsResult.getOrElse(() => []);

    emit(SupportLoaded(faqs: faqs, contacts: contacts));
  }

  void _onToggleFaq(ToggleFaq event, Emitter<SupportState> emit) {
    final currentState = state;
    if (currentState is! SupportLoaded) return;

    // Accordéon exclusif : un seul item ouvert à la fois.
    final updatedFaqs = currentState.faqs.map((faq) {
      if (faq.id == event.faqId) {
        return faq.copyWith(isExpanded: !faq.isExpanded);
      }
      // Ferme les autres items
      return faq.isExpanded ? faq.copyWith(isExpanded: false) : faq;
    }).toList();

    emit(currentState.copyWith(faqs: updatedFaqs));
  }
}
