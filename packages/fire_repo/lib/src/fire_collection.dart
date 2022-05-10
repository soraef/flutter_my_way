abstract class FireCollection {
  final CollectionIds collectionIds;
  final DocumentIds documentIds;

  FireCollection({
    required this.collectionIds,
    required this.documentIds,
  });
}

class CollectionIds {
  final List<String> values;

  CollectionIds(this.values);

  int get length => values.length;
}

class DocumentIds {
  final List<String> values;

  DocumentIds(this.values);

  int get length => values.length;
}
