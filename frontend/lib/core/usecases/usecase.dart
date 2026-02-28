import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases
///
/// [Output] is the return type of the use case
/// [Params] is the parameters type for the use case
abstract class UseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<Output> {
  Future<Either<Failure, Output>> call();
}

/// Use case with stream return type
abstract class StreamUseCase<Output, Params> {
  Stream<Either<Failure, Output>> call(Params params);
}

/// No parameters class
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
