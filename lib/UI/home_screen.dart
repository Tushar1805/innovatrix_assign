import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:innovatrix_assign/UI/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://countries.trevorblades.com/',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
          link: httpLink, cache: GraphQLCache(dataIdFromObject: null)),
    );
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text("GraphQL Data"),
        ),
        body: Query(
          options: QueryOptions(
            document: gql(r""" 
         query ReadCountries {
                  countries {
                    code
                    name
                    currency
                    emoji
                  }
              }
          """),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text('Loading');
            }

            List? repositories = result.data?['countries'];

            if (repositories == null) {
              return const Text('No repositories');
            }

            return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repository = repositories[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.deepPurple.shade200,
                  child: ListTile(
                    leading: Text(
                      repository["emoji"],
                      style: TextStyle(fontSize: 30),
                    ),
                    title: Text(
                      repository["name"],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Currency: ${repository["currency"]}',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      repository["code"],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
