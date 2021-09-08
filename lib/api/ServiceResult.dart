import 'package:graphql_flutter/graphql_flutter.dart';

class ServiceResult {
  ServiceResult._();

  factory ServiceResult.Success(dynamic data) = Success;
  factory ServiceResult.Failure(String reason) = Failure;
}

class Success extends ServiceResult {
  Success(this.data): super._();

  final dynamic data;
}

class Failure extends ServiceResult {
  Failure(this.reason): super._();

  final String reason;
}
