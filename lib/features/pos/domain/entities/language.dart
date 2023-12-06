// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String name;
  final String flag;
  final String languagecode;
  Language({
    required this.name,
    required this.flag,
    required this.languagecode,
  });

  @override
  List<Object> get props => [name, flag, languagecode];
  static List<Language> languagelist() => <Language>[
        Language(name: 'English', flag: '', languagecode: 'en'),
        Language(name: 'German', flag: '', languagecode: 'de'),
        Language(name: 'العربية', flag: '', languagecode: 'ar')
      ];
}
