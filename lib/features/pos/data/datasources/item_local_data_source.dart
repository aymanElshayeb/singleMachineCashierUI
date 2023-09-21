import '../../../../core/error/exceptions.dart';
import '../../domain/entities/item.dart';

abstract class ItemLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<Item>> getItems();
}

const CACHED_ITEMS = 'CACHED_ITEMS';

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  ItemLocalDataSourceImpl();

  @override
  Future<List<Item>> getItems() async {
    List<Item> items2 = [];
    return Future.value(items2);
  }
}
