import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entity_store/repository/firestore_repo.dart';
import 'package:entity_store/repository/id.dart';

abstract class ListParams {}

abstract class RepoList<P extends ListParams, R> {
  Future<List<R>> list(P params);
}

class FireListParams implements ListParams {
  final CollectionId collection;
  final int? limit;
  final String? orderByField;
  FireListParams({
    required this.collection,
    this.limit,
    this.orderByField,
  });
}

mixin FireRepoList<T, Id extends FirestoreId>
    implements FirestoreRepo<T, Id>, RepoList<FireListParams, T> {
  @override
  Future<List<T>> list(FireListParams params) async {
    Query<T?> query = converter.collection(params.collection);

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
