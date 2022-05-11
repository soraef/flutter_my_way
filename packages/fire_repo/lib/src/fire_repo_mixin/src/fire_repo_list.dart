import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_repo/fire_repo.dart';

abstract class ListParams {}

abstract class RepoList<P extends ListParams, R> {
  Future<List<R>> list(P params);
}

class FireListParams<C extends FireCollection> implements ListParams {
  final C collection;
  final int? limit;
  final String? orderByField;
  FireListParams({
    required this.collection,
    this.limit,
    this.orderByField,
  });
}

mixin FireRepoList<T, Id extends FireRepoId<C>, C extends FireCollection>
    implements FireRepo<T, Id, C>, RepoList<FireListParams<C>, T> {
  @override
  Future<List<T>> list(FireListParams<C> params) async {
    Query<T?> query = config.collection(params.collection);

    if (params.orderByField != null) {
      query = query.orderBy(params.orderByField!);
    }

    if (params.limit != null) {
      query = query.limit(params.limit!);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((e) => e.data()).whereType<T>().toList();
  }
}
