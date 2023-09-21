part of 'ean_bloc.dart';

sealed class EanEvent extends Equatable {
  const EanEvent();

  @override
  List<Object> get props => [];
}

class EmptyEan extends EanEvent {}

class LoadEanItems extends EanEvent {
  final String keyWord;

  const LoadEanItems(this.keyWord);
}
