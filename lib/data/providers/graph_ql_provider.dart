import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/helpers/environment.dart';

class GraphQLLinkProvider extends GetxService {
  late GraphQLClient client;

  @override
  void onInit() {
    super.onInit();
    initGraphQL();

  }

  void initGraphQL({String? token}){
    final HttpLink httpLink = HttpLink(Environment().config.memberApi,
      defaultHeaders: {
        'apollo-require-preflight': 'true',
        'Authorization':'Bearer $token'
      },
    );

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }


  Future<GraphQLLinkProvider> init({String? token}) async {
    initGraphQL(token: token);
    return this;
  }

  Future<QueryResult> query(String query,
      {Map<String, dynamic>? variables}) async {
    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
    );

    final result = await client.query(options);
    return result;
  }

  Future<QueryResult> mutate(String mutation,
      {Map<String, dynamic>? variables}) async {
    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
    );

    final result = await client.mutate(options);
    return result;
  }
}
