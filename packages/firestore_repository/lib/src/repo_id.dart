import 'package:firestore_repository/src/repo.dart';

abstract class FireRepoId implements RepoId {
  final String docId;
  FireRepoId(this.docId);

  List<String> get collectionIds;
  List<String> get documentIds;
}

abstract class CollectionInfo {}

class RepoId1 extends FireRepoId {
  final String collectionId1;
  final String docId1;

  RepoId1({
    required this.collectionId1,
    required this.docId1,
  }) : super(docId1);

  @override
  List<String> get documentIds => [];

  @override
  List<String> get collectionIds => [collectionId1];
}

class RepoId2 extends FireRepoId {
  final String collectionId1;
  final String collectionId2;

  final String docId1;
  final String docId2;

  RepoId2({
    required this.collectionId1,
    required this.collectionId2,
    required this.docId1,
    required this.docId2,
  }) : super(docId2);

  @override
  List<String> get documentIds => [docId1, docId2];

  @override
  List<String> get collectionIds => [collectionId1, collectionId2];
}
