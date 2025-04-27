class UnnamedException implements Exception {
  final String message;

  UnnamedException(this.message);

  @override
  String toString() => message;
}
