import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/billModel.dart';
import 'package:resman_mobile_customer/src/models/cartDishModel.dart';
import 'package:resman_mobile_customer/src/models/cartModel.dart';
import 'package:resman_mobile_customer/src/models/comment.dart';
import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/models/storeModal.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/discountCodeProvider.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/storeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dailyDish.dart';
import '../models/dishModal.dart';
import '../models/userModel.dart';
import '../utils/validateEmail.dart';
import 'dataProviders/billProvider.dart';
import 'dataProviders/dailyDishProvider.dart';
import 'dataProviders/dishProvider.dart';
import 'dataProviders/userProvider.dart';

class Repository {
  static Repository _singleton;

  static Repository get instance {
    if (_singleton == null) {
      print('Initialize Repository ...');
      _singleton = Repository._internal();
    }
    return _singleton;
  }

  factory Repository() {
    return instance;
  }

  Repository._internal();

  static const String PrepsStoreId = 'store-id';
  static const String PrepsTokenKey = 'jwt-login-token';
  static const String PrepsUsernameOrEmail = 'logged-in-username-or-email';
  static const String PrepsCart = 'user-cart';

  final UserProvider _userProvider = UserProvider();
  final DailyDishProvider _dailyDishProvider = DailyDishProvider();
  final DishProvider _dishProvider = DishProvider();
  final DiscountCodeProvider _discountCodeProvider = DiscountCodeProvider();
  final BillProvider _billProvider = BillProvider();
  final StoreProvider _storeProvider = StoreProvider();

  UserModel _currentUser;
  Store _currentStore;
  CartModel _currentCart = CartModel.empty();
  List<DailyDish> _dailyDishes;

  List<DailyDish> get dailyDishes => _dailyDishes;

  CartModel get currentCart => _currentCart;

  UserModel get currentUser => _currentUser;

  Future<String> authenticate(
      {@required String usernameOrEmail, @required String password}) async {
    return await _userProvider.login(usernameOrEmail, password);
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrepsTokenKey); // Delete token
    await prefs.remove(PrepsUsernameOrEmail); // Delete username or email
    _currentUser = null;
    return;
  }

  Future<void> persistToken(String token, String usernameOrEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrepsTokenKey, token); // Save token
    await prefs.setString(
        PrepsUsernameOrEmail, usernameOrEmail); // Save username or email
    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrepsTokenKey) != null;
  }

  Future<void> register(String username, String email, String password) async {
    await _userProvider.register(username, email, password);
  }

  Future<void> fetchCurrentUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final usernameOrEmail = prefs.getString(PrepsUsernameOrEmail);
    final token = prefs.getString(PrepsTokenKey);
    if (validateEmail(usernameOrEmail)) {
      _currentUser =
          await _userProvider.getProfileByEmail(usernameOrEmail, token);
    } else {
      _currentUser =
          await _userProvider.getProfileByUsername(usernameOrEmail, token);
    }
    print(_currentUser);
  }

  Future<List<DailyDish>> fetchAllDishToday() async {
    _dailyDishes = await _dailyDishProvider.getAllDishToday();
    return _dailyDishes;
  }

  Future<DishModal> getDishDetail(int dishId) async {
    return await _dishProvider.getDishDetail(dishId);
  }

  Future<List<DishModal>> getAllDish() async {
    return await _dishProvider.getAll();
  }

  Future<List<BillModel>> getAllBill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.getAll(token);
  }

  Future<List<BillModel>> getAllCurrentUserBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.getAllUserBills(token, currentUser.username);
  }

  /// Return bill model.
  Future<BillModel> createBill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    final storeId = prefs.getInt(PrepsStoreId);

    return await _billProvider.createBill(
      token,
      currentCart.address?.id,
      currentCart.listDishes,
      storeId,
      discountCode: currentCart.discountCode?.code ?? '',
      note: currentCart.note ?? '',
      voucherCode: currentCart.voucherCode?.code ?? '',
    );
  }

  Future<BillModel> updatePaidBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updatePaidBillStatus(token, billId);
  }

  Future<BillModel> updatePreparingBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updatePreparingBillStatus(token, billId);
  }

  Future<BillModel> updatePrepareDoneBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updatePrepareDoneBillStatus(token, billId);
  }

  Future<BillModel> updateShippingBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updateShippingBillStatus(token, billId);
  }

  Future<BillModel> updateDeliveringBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updateDeliveringBillStatus(token, billId);
  }

  Future<BillModel> updateCompleteBillStatus(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.updateCompleteBillStatus(token, billId);
  }

  Future<BillModel> getBill(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _billProvider.getBill(token, billId);
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_currentCart.toJson());
    await prefs.setString(PrepsCart, json);
  }

  CartDishModel addDishIntoCart(DailyDish dish) {
    int quantity = 1;

    // Remove dish if it existed, then add a same new one with quantity increase one.
    int index = _currentCart.listDishes
        .indexWhere((_cartDish) => _cartDish.dishId == dish.dish.dishId);
    if (index >= 0) {
      quantity = _currentCart.listDishes[index].quantity + 1;
      _currentCart.listDishes.removeAt(index);
    }

    var cartDish = CartDishModel.fromDailyDish(dish, quantity: quantity);
    _currentCart.listDishes.add(cartDish);
    return cartDish;
  }

  void removeDishFromCart(int dishId) {
    _currentCart.listDishes
        .removeWhere((cartDish) => cartDish.dishId == dishId);
  }

  void changeDistQuantityInCart(int dishId, int quantity) {
    // Remove dish if it existed, then add a same new one with new quantity.
    CartDishModel cartDish = _currentCart.listDishes
        .firstWhere((e) => e.dishId == dishId, orElse: () => null);
    if (cartDish != null) {
      cartDish.quantity = quantity;
      _currentCart.listDishes.removeWhere((e) => e.dishId == dishId);
      _currentCart.listDishes.add(cartDish);
    }
  }

  void changeVoucherCodeInCart(VoucherCode voucherCode) {
    _currentCart.voucherCode = voucherCode;
  }

  void changeDiscountCodeInCart(DiscountCode discountCode) {
    _currentCart.discountCode = discountCode;
  }

  void changeAddressInCart(Address address) {
    _currentCart.address = address;
  }

  Future<void> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringCart = prefs.getString(PrepsCart);
    if (stringCart == null) {
      _currentCart = CartModel.empty();
    } else {
      final json = jsonDecode(stringCart);
      _currentCart = CartModel.fromJson(json);
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentCart = CartModel.empty();
    await prefs.setString(PrepsCart, jsonEncode(_currentCart.toJson()));
  }

  Future<String> uploadAvatar(File imageFile, String username) async {
    String fileName = username + '-' + DateTime.now().toString();
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(await taskSnapshot.ref.getDownloadURL());
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<UserModel> saveProfile(
      {String fullName, String email, DateTime birthday, String avatar}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _userProvider.editUserProfile(
        avatar: avatar,
        birthday: birthday,
        email: email,
        fullName: fullName,
        token: token);
  }

  Future changeUserPassword(
      UserModel user, String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    await _userProvider.changePassword(
        token, user.username, oldPassword, newPassword);
  }

  Future<List<Store>> getAllStore() async {
    return await _storeProvider.getAll();
  }

  Future<Store> getStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt(PrepsStoreId);

    if (storeId == null) return null;

    if (_currentStore == null) {
      try {
        _currentStore = await _storeProvider.fetchStore(storeId);
      } catch (e) {
        print('Get store failed: $e');
        return null;
      }
    }

    return _currentStore;
  }

  Future selectStore(Store store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentStore = store;
    prefs.setInt(PrepsStoreId, store.id);
  }

  Future<List<Comment>> getCommentsOfDish(int dishId) async {
    return await _dishProvider.getComments(dishId);
  }

  Future<Comment> createComment(
      int dishId, String content, double rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _dishProvider.createComment(token, dishId, content, rating);
  }

  Future<String> favouriteDish(int dishId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _dishProvider.favourite(token, dishId);
  }

  Future<String> unFavouriteDish(int dishId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrepsTokenKey);
    return await _dishProvider.unFavourite(token, dishId);
  }

  Future<DiscountCode> getDiscountCode(String code) async {
    return await _discountCodeProvider.getDiscountCode(code);
  }
}
