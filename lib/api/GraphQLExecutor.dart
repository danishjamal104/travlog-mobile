
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/api/ApiConfig.dart';
import 'package:travlog/api/ServiceResult.dart';

class GraphQLExecutor {

  static GraphQLExecutor _graphQLExecutor;

  static GraphQLExecutor getInstance() {
    if(_graphQLExecutor == null) {
      _graphQLExecutor = GraphQLExecutor();
    }
    return _graphQLExecutor;
  }

  final HttpLink _httpLink = HttpLink(uri: ApiConfig.baseUrl);
  GraphQLClient _graphQLClient;

  GraphQLExecutor() {
    _graphQLClient = GraphQLClient(
        link: _httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject)
    );
  }

  Future<ServiceResult> mutation(String mutation) async {
    final MutationOptions options = MutationOptions(documentNode: gql(mutation));
    QueryResult result = await _graphQLClient.mutate(options);
    if(result.hasException) {
      return ServiceResult.Failure(result.exception.toString());
    }
    return ServiceResult.Success(result.data);
  }

  HttpLink getHttpLink() {
    return _httpLink;
  }

}