part of "messaging.dart";

extension MessagingUtil on Object {
  /// is String or int or double or bool
  bool get isDefaultType =>
      this is String || this is int || this is double || this is bool;
}
