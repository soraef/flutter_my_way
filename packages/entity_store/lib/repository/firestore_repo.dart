import 'convert.dart';
import 'id.dart';

abstract class FirestoreRepo<T, Id extends FirestoreId> {
  final RepoConverter<T, Id> converter;

  FirestoreRepo(this.converter);
}
