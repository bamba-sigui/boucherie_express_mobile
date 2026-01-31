import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class WatchAuthChanges {
  final AuthRepository repository;

  WatchAuthChanges(this.repository);

  Stream<User?> call() {
    return repository.authStateChanges;
  }
}
