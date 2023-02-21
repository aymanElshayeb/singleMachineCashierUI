part of 'locale_bloc_bloc.dart';

@immutable
abstract class LocaleBlocEvent {}

class LoadLanguage extends LocaleBlocEvent {
  final Locale locale;

  LoadLanguage({this.locale});
}
