// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'locale_bloc_bloc.dart';

@immutable
class LocaleBlocState extends Equatable {
  final Locale locale;

  LocaleBlocState({required this.locale});
  factory LocaleBlocState.initial() => LocaleBlocState(locale: Locale('en'));
  LocaleBlocState copywith({Locale? locale}) =>
      LocaleBlocState(locale: locale ?? this.locale);

  @override
  List<Object> get props => [locale];
}
