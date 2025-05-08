import 'dart:convert';

/// A class that implements JSON Patch operations following RFC 6902 specification.
class JsonPatch {
  final List<Map<String, dynamic>> _operations = [];

  /// Creates a new JSON Patch document
  JsonPatch();

  /// Adds a new value at the specified path
  JsonPatch add(String path, dynamic value) {
    _operations.add({
      'op': 'add',
      'path': path,
      'value': value,
    });
    return this;
  }

  /// Removes the value at the specified path
  JsonPatch remove(String path) {
    _operations.add({
      'op': 'remove',
      'path': path,
    });
    return this;
  }

  /// Replaces the value at the specified path with a new value
  JsonPatch replace(String path, dynamic value) {
    _operations.add({
      'op': 'replace',
      'path': path,
      'value': value,
    });
    return this;
  }

  /// Copies a value from one location to another
  JsonPatch copy(String from, String path) {
    _operations.add({
      'op': 'copy',
      'from': from,
      'path': path,
    });
    return this;
  }

  /// Moves a value from one location to another
  JsonPatch move(String from, String path) {
    _operations.add({
      'op': 'move',
      'from': from,
      'path': path,
    });
    return this;
  }

  /// Tests if the value at the specified path matches the given value
  JsonPatch test(String path, dynamic value) {
    _operations.add({
      'op': 'test',
      'path': path,
      'value': value,
    });
    return this;
  }

  /// Returns the JSON Patch document as a list of operations
  List<Map<String, dynamic>> get operations => List.unmodifiable(_operations);

  /// Returns the JSON Patch document as a JSON string
  String toJson() => jsonEncode(operations);

  @override
  String toString() => toJson();

  /// Creates a JsonPatch instance from a JSON string
  static JsonPatch fromJson(String json) {
    final patch = JsonPatch();
    final List<dynamic> operations = jsonDecode(json);
    for (var operation in operations) {
      patch._operations.add(Map<String, dynamic>.from(operation));
    }
    return patch;
  }

  /// Returns true if the patch document is empty
  bool get isEmpty => _operations.isEmpty;

  /// Returns the number of operations in the patch document
  int get length => _operations.length;

  /// Clears all operations from the patch document
  void clear() {
    _operations.clear();
  }
}
