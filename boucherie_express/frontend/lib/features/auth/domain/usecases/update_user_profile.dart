import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfileParams {
  final String? name;
  final String? phone;
  final List<String>? addresses;

  const UpdateUserProfileParams({this.name, this.phone, this.addresses});
}

@injectable
class UpdateUserProfile implements UseCase<User, UpdateUserProfileParams> {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      phone: params.phone,
      addresses: params.addresses,
    );
  }
}
