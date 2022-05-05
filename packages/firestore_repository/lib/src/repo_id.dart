import 'package:firestore_repository/firestore_repository.dart';
import 'package:firestore_repository/src/repo.dart';

// class Collection {
//   final String name;
//   final Collection? subCollection;

//   Collection({
//     required this.name,
//     required this.subCollection,
//   });

//   Document getDocument(String id) {
//     return Document(collection: this, id: id);
//   }
// }

// class Document {
//   final Collection collection;
//   final String id;

//   Document({
//     required this.collection,
//     required this.id,
//   });
// }

// final user = Collection(name: "users", subCollection: todo);
// final todo = Collection(
//   name: "users",
//   subCollection: Collection(
//     name: "todos",
//     subCollection: null,
//   ),
// ).getDocument("userId").subCollection;

abstract class FireRepoId implements RepoId {
  final CollectionPath path;
  final String docId;

  FireRepoId(this.path, this.docId);
}

class CollectionPathFactory {
  final FireIdList collectionIds;

  CollectionPathFactory(this.collectionIds);
}

class CollectionPathFactory1 extends CollectionPathFactory {
  CollectionPathFactory1(String layer1) : super(FireIdList.level1(layer1));

  CollectionPath create() {
    return CollectionPath(collectionIds, FireIdList.none());
  }
}

class CollectionPathFactory2 extends CollectionPathFactory {
  CollectionPathFactory2(String layer1, String layer2)
      : super(FireIdList.level2(level1: layer1, level2: layer2));

  /// /layer1/docId1/layer2/docId2
  CollectionPath create(String docId1) {
    return CollectionPath(collectionIds, FireIdList.level1(docId1));
  }
}

/// users/(user_id)/todo/のようなコレクションのPathを表現する
class CollectionPath {
  final FireIdList collectionIds;
  final FireIdList documentIds;

  CollectionPath(this.collectionIds, this.documentIds);

  DocumentPath doc(FireIdList documentIds) {
    return DocumentPath(collectionPath: this, documentIds: documentIds);
  }
}

/// users/(user_id)/todo/(todo_id)のようなドキュメントのパスを表現する
class DocumentPath {
  final CollectionPath collectionPath;
  final FireIdList documentIds;

  DocumentPath({
    required this.collectionPath,
    required this.documentIds,
  });
}

class FireIdList {
  final List<String> values;

  FireIdList._(this.values);

  factory FireIdList.none() {
    return FireIdList._([]);
  }

  factory FireIdList.level1(String level1) {
    return FireIdList._([level1]);
  }

  factory FireIdList.level2({
    required String level1,
    required String level2,
  }) {
    return FireIdList._([level1, level2]);
  }

  int get length => values.length;
  String getString(int level) {
    return values[level];
  }

  String get last => values.last;
}

// class RepoId1 implements FireRepoId {
//   final String collection1;
//   final String document1;

//   RepoId1({
//     required this.collection1,
//     required this.document1,
//   })

//   @override
//   DocumentPath get path => 
// }

// class RepoId2 extends FireRepoId {
//   final String collectionId1;
//   final String collectionId2;

//   final String docId1;
//   final String docId2;

//   RepoId2({
//     required this.collectionId1,
//     required this.collectionId2,
//     required this.docId1,
//     required this.docId2,
//   }) : super(docId2);

//   @override
//   List<String> get documentIds => [docId1, docId2];

//   @override
//   List<String> get collectionIds => [collectionId1, collectionId2];
// }
