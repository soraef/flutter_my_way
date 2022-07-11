import 'package:entity_store/repository/firestore_repo.dart';
import 'package:entity_store/repository/id.dart';

abstract class RepoGet<R, RepoId> {
  Future<R?> get(RepoId id);
}

mixin FireRepoGet<T, Id extends FirestoreId>
    implements FirestoreRepo<T, Id>, RepoGet<T, Id> {
  @override
  Future<T?> get(Id id) async {
    final doc = await converter.doc(id).get();
    return doc.data();
  }
}
