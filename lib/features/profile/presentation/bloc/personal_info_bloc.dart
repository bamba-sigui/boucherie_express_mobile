import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../auth/domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_avatar.dart';

// ─── Events ──────────────────────────────────────────────────────────

abstract class PersonalInfoEvent extends Equatable {
  const PersonalInfoEvent();
  @override
  List<Object?> get props => [];
}

/// Charge les données utilisateur au montage.
class LoadPersonalInfo extends PersonalInfoEvent {}

/// Met à jour un champ en mémoire (pas encore sauvegardé).
class FieldChanged extends PersonalInfoEvent {
  final String fieldName;
  final String value;

  const FieldChanged({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

/// Envoie les modifications au backend.
class SavePersonalInfo extends PersonalInfoEvent {}

/// Lance l'upload de la photo de profil.
class UploadAvatarRequested extends PersonalInfoEvent {
  final XFile file;
  const UploadAvatarRequested(this.file);

  @override
  List<Object?> get props => [file.path];
}

// ─── States ──────────────────────────────────────────────────────────

abstract class PersonalInfoState extends Equatable {
  const PersonalInfoState();
  @override
  List<Object?> get props => [];
}

class PersonalInfoInitial extends PersonalInfoState {}

class PersonalInfoLoading extends PersonalInfoState {}

/// Données chargées — contient l'utilisateur original et les valeurs éditées.
class PersonalInfoLoaded extends PersonalInfoState {
  final User user;
  final String editedName;
  final String editedPhone;
  final String editedEmail;
  final bool hasChanges;
  final bool isSaving;
  final String? nameError;
  final String? emailError;

  const PersonalInfoLoaded({
    required this.user,
    required this.editedName,
    required this.editedPhone,
    required this.editedEmail,
    this.hasChanges = false,
    this.isSaving = false,
    this.nameError,
    this.emailError,
  });

  PersonalInfoLoaded copyWith({
    User? user,
    String? editedName,
    String? editedPhone,
    String? editedEmail,
    bool? hasChanges,
    bool? isSaving,
    String? nameError,
    String? emailError,
    bool clearNameError = false,
    bool clearEmailError = false,
  }) {
    return PersonalInfoLoaded(
      user: user ?? this.user,
      editedName: editedName ?? this.editedName,
      editedPhone: editedPhone ?? this.editedPhone,
      editedEmail: editedEmail ?? this.editedEmail,
      hasChanges: hasChanges ?? this.hasChanges,
      isSaving: isSaving ?? this.isSaving,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
    );
  }

  @override
  List<Object?> get props => [
    user,
    editedName,
    editedPhone,
    editedEmail,
    hasChanges,
    isSaving,
    nameError,
    emailError,
  ];
}

class PersonalInfoError extends PersonalInfoState {
  final String message;
  const PersonalInfoError(this.message);
  @override
  List<Object?> get props => [message];
}

class PersonalInfoSaved extends PersonalInfoState {
  final User user;
  const PersonalInfoSaved(this.user);
  @override
  List<Object?> get props => [user];
}

// ─── BLoC ────────────────────────────────────────────────────────────

@injectable
class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  final GetCurrentUser getCurrentUser;
  final UpdateUserProfile updateUserProfile;
  final UploadAvatar uploadAvatar;

  PersonalInfoBloc({
    required this.getCurrentUser,
    required this.updateUserProfile,
    required this.uploadAvatar,
  }) : super(PersonalInfoInitial()) {
    on<LoadPersonalInfo>(_onLoad);
    on<FieldChanged>(_onFieldChanged);
    on<SavePersonalInfo>(_onSave);
    on<UploadAvatarRequested>(_onUploadAvatar);
  }

  Future<void> _onLoad(
    LoadPersonalInfo event,
    Emitter<PersonalInfoState> emit,
  ) async {
    emit(PersonalInfoLoading());
    final result = await getCurrentUser();
    result.fold((failure) => emit(PersonalInfoError(failure.message)), (user) {
      if (user != null) {
        emit(
          PersonalInfoLoaded(
            user: user,
            editedName: user.name,
            editedPhone: user.phone ?? '',
            editedEmail: user.email,
          ),
        );
      } else {
        emit(const PersonalInfoError('Utilisateur non trouvé'));
      }
    });
  }

  void _onFieldChanged(FieldChanged event, Emitter<PersonalInfoState> emit) {
    final current = state;
    if (current is! PersonalInfoLoaded) return;

    String name = current.editedName;
    String phone = current.editedPhone;
    String email = current.editedEmail;

    switch (event.fieldName) {
      case 'name':
        name = event.value;
      case 'phone':
        phone = event.value;
      case 'email':
        email = event.value;
    }

    final user = current.user;
    final changed =
        name != user.name || phone != (user.phone ?? '') || email != user.email;

    emit(
      current.copyWith(
        editedName: name,
        editedPhone: phone,
        editedEmail: email,
        hasChanges: changed,
        clearNameError: event.fieldName == 'name',
        clearEmailError: event.fieldName == 'email',
      ),
    );
  }

  Future<void> _onSave(
    SavePersonalInfo event,
    Emitter<PersonalInfoState> emit,
  ) async {
    final current = state;
    if (current is! PersonalInfoLoaded) return;
    if (!current.hasChanges) return;

    // Validation
    String? nameError;
    String? emailError;

    if (current.editedName.trim().isEmpty) {
      nameError = 'Le nom est obligatoire';
    }

    if (current.editedEmail.isNotEmpty && !_isValidEmail(current.editedEmail)) {
      emailError = 'Adresse email invalide';
    }

    if (nameError != null || emailError != null) {
      emit(current.copyWith(nameError: nameError, emailError: emailError));
      return;
    }

    emit(
      current.copyWith(
        isSaving: true,
        clearNameError: true,
        clearEmailError: true,
      ),
    );

    final result = await updateUserProfile(
      UpdateUserProfileParams(
        name: current.editedName.trim(),
        phone: current.editedPhone.trim(),
      ),
    );

    result.fold((failure) {
      emit(current.copyWith(isSaving: false));
      emit(PersonalInfoError(failure.message));
      // Re-emit loaded state so UI doesn't stay on error
      emit(current.copyWith(isSaving: false));
    }, (updatedUser) => emit(PersonalInfoSaved(updatedUser)));
  }

  Future<void> _onUploadAvatar(
    UploadAvatarRequested event,
    Emitter<PersonalInfoState> emit,
  ) async {
    final current = state;
    if (current is! PersonalInfoLoaded) return;

    emit(current.copyWith(isSaving: true));

    final result = await uploadAvatar(File(event.file.path));

    result.fold(
      (failure) {
        emit(current.copyWith(isSaving: false));
        emit(PersonalInfoError(failure.message));
        emit(current.copyWith(isSaving: false));
      },
      (photoUrl) => emit(
        current.copyWith(
          user: current.user.copyWith(photoUrl: photoUrl),
          isSaving: false,
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email);
  }
}
