class StoreError implements Exception {
  final String message;
  StoreError(this.message);

  @override
  String toString() => "StoreError: $message";
}
