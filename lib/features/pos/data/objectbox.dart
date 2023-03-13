import 'package:single_machine_cashier_ui/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

import '../domain/entities/cart.dart';
import '../domain/entities/item.dart';
import '../domain/entities/category.dart';
import '../domain/entities/user.dart';

class ObjectBox {
  late final Store store;
  late final Box<Item> itemBox;
  late final Box<Category> categoryBox;
  late final Box<Cart> cartBox;
  late final Box<User> userBox;
  ObjectBox._create(this.store) {
    itemBox = Box<Item>(store);
    categoryBox = Box<Category>(store);
    cartBox = Box<Cart>(store);
    userBox = Box<User>(store);
    if (itemBox.isEmpty()) {
      _putDemoData();
    }
    if (userBox.isEmpty()) {
      _putDemoUserData();
    }
  }

  void _putDemoData() {
    Category category1 = Category(name: 'grocery');
    Category category2 = Category(name: 'dairy');
    Category category3 = Category(name: 'games');

    Item item1 = Item(
        PLU_EAN: 'acc',
        name: 'tomato',
        unit: 'kg',
        category: 3,
        price: 10.0,
        kilo: true);
    item1.underCategory.target = category1;
    Item item2 = Item(
        PLU_EAN: 'bcc',
        name: "potato",
        unit: 'kg',
        category: 1,
        price: 20.0,
        kilo: true);
    item2.underCategory.target = category1;
    Item item3 = Item(
        PLU_EAN: 'bb',
        name: 'orange',
        unit: 'kg',
        category: 1,
        price: 15.5,
        kilo: true);
    item3.underCategory.target = category2;
    Item item4 = Item(
        PLU_EAN: 'acc',
        name: 'banana',
        unit: 'kg',
        category: 2,
        price: 10.0,
        kilo: true);
    item4.underCategory.target = category2;
    Item item5 = Item(
        PLU_EAN: 'acc',
        name: 'milk',
        unit: 'L',
        category: 2,
        price: 10.0,
        kilo: false);
    item5.underCategory.target = category2;
    Item item6 = Item(
        PLU_EAN: 'dd',
        name: 'eggs',
        unit: 'Piece',
        category: 2,
        price: 3.0,
        kilo: false);
    item6.underCategory.target = category1;
    Item item7 = Item(
        PLU_EAN: 'acc',
        name: 'cheese',
        unit: 'KG',
        category: 2,
        price: 15.0,
        kilo: true);
    item7.underCategory.target = category3;
    itemBox.putMany([item1, item2, item3, item4, item5, item6, item7]);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void addItem(String name, double price, bool kilo, String PLU_EAN,
      int categorynum, String unit, Category category) {
    Item item = Item(
        PLU_EAN: PLU_EAN,
        name: name,
        unit: unit,
        category: categorynum,
        price: price,
        kilo: kilo);
    item.underCategory.target = category;
  }

  int addCategory(String name) {
    Category category = Category(name: name);
    int newObjectId = categoryBox.put(category);
    return newObjectId;
  }

  Stream<List<Item>> getItems() {
    final builder = itemBox.query()..order(Item_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void _putDemoUserData() {
    User user1 = User(
        userName: 'Ahmed',
        role: 'ADMIN',
        password: 'po',
        fullname: 'Ahmed mostafa');
    User user2 = User(
        userName: 'Mohamed',
        role: 'Cashier',
        password: 'iu',
        fullname: 'Mohamed ahmed');
    userBox.putMany([user1, user2]);
  }

  Stream<List<User>> getUsers() {
    final builder = userBox.query()..order(User_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  int addUser(String username, String role, String password, String fullname) {
    User user = User(
        userName: username, role: role, password: password, fullname: fullname);
    int newObjectId = userBox.put(user);
    return newObjectId;
  }
}
