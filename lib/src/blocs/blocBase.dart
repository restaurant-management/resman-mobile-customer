abstract class BlocEventBase {
  @override
  String toString() => runtimeType.toString();
}

abstract class BlocStateBase {
  @override
  String toString() => runtimeType.toString();
}

abstract class BlocErrorStateBase extends BlocStateBase {
  final String error;

  BlocErrorStateBase(this.error);
  @override
  String toString() => '$runtimeType ($error)';
}
