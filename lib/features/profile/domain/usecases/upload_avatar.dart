import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

@injectable
class UploadAvatar {
  final AuthRepository repository;
  UploadAvatar(this.repository);

  Future<Either<Failure, String>> call(File imageFile) =>
      repository.uploadAvatar(imageFile.path);
}
