import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {
  final String message;

  CacheFailure(this.message) : super([message]);
}
class NetworkFailure extends Failure {}
class GeneralFailure extends Failure {
  final String message;

  GeneralFailure(this.message) : super([message]);

  @override
  List<Object> get props => [message];
}