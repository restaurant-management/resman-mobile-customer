import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/cartDishModel.dart';

class GraphQuery {
  static String me() {
    return '''
    {
      meAsCustomer {
        uuid
        username
        settings
        phoneNumber
        fullName
        email
        birthday
        avatar
        addresses {
          address
          id
          latitude
          longitude
        }
        favouriteDishes {
          id
        }
        voucherCodes {
          code
          isActive
          isPercent
          name
          description
          image
          startAt
          endAt
          minBillPrice
          maxPriceDiscount
          value
          stores {
            id
          }
        }
      }
    }
  ''';
  }

  static String favouriteDishes() {
    return '''
    {
      meAsCustomer {
        favouriteDishes {
          id
          name
          description
          images
          defaultPrice
          price
        }
      }
    }
    ''';
  }

  static String changePassword(String oldPassword, String newPassword) {
    return '''
    mutation {
      changePasswordAsCustomer(newPassword: "$newPassword", oldPassword: "$oldPassword")
    }
    ''';
  }

  static String login(String usernameOrEmail, String password) {
    return '''
    {
      loginAsCustomer(password: "$password" usernameOrEmail: "$usernameOrEmail")
    }
    ''';
  }

  static String getStore(int id) {
    return '''
    {
      getStore(id: $id) {
        address
        amountDishes
        closeTime
        description
        id
        hotline
        logo
        name
        openTime
        rating
      }
    }
    ''';
  }

  static String getAllStore() {
    return '''
    {
      stores {
        id
        address
        amountDishes
        closeTime
        description
        hotline
        logo
        name
        openTime
        rating
      }
    }
    ''';
  }

  static String changeProfile(
      {String avatar = '',
      String fullName = '',
      String phoneNumber = '',
      DateTime birthday,
      List<Address> addresses}) {
    final query = '''
    mutation {
      changeProfileAsCustomer(
        avatar: "$avatar", 
        fullName: "$fullName", 
        phoneNumber: "$phoneNumber", 
        ${birthday != null ? 'birthday: "$birthday"' : ''}
        addresses: ${addresses.map((e) => e.toGraphQL()).toList()}
      ) {
        uuid
      }
    }
    ''';
    return query;
  }

  static String createComment(int dishId, String content, [double rating]) {
    return '''
    mutation {
      createComment(dishId: $dishId, rating: ${rating ?? 5}, content: "$content") {
        id
        createAt
        createBy {
          username
          fullName
          uuid
          avatar
        }
        rating
        content
      }
    }
    ''';
  }

  static String getAllDishComment(int dishId) {
    return '''
    {
      dishComments(dishId: $dishId) {
        id
        createAt
        createBy {
          uuid
          username
          fullName
          avatar
        }
        content
        rating
      }
    }
    ''';
  }

  static String favouriteDish(int dishId) {
    return '''
    mutation {
      favouriteDish(id: $dishId)
    }
    ''';
  }

  static String unFavouriteDish(int dishId) {
    return '''
    mutation {
      unFavouriteDish(id: $dishId)
    }
    ''';
  }

  static String createDeliveryBill(
      int addressId, List<CartDishModel> cartDishModels, int storeId,
      {String discountCode = '', String note = '', String voucherCode = ''}) {
    final query = '''
    mutation {
      createDeliveryBill(
        addressId: ${addressId ?? -1}
        dishIds: ${cartDishModels.map((e) => e.dishId).toList().toString()}
        dishNotes: ${cartDishModels.map((e) => e.note ?? '""').toList().toString()}
        storeId: $storeId,
        dishQuantities: ${cartDishModels.map((e) => e.quantity).toList().toString()}
        discountCode: "$discountCode"
        note: "$note"
        voucherCode: "$voucherCode"
      ) {
        id
        createAt
        prepareAt
        preparedAt
        shipAt
        collectAt
        collectValue
        voucherCode
        voucherValue
        voucherIsPercent
        discountCode
        discountValue
        address
        longitude
        latitude
        rating
        note
        dishes {
          dish {
            id
            name
            description
            images
            defaultPrice
          }
          quantity
          price
        }
      }
    }
    ''';
    return query;
  }

  static String deliveryBills() {
    return ''' 
    {
      deliveryBills {
        id
        createAt
        prepareAt
        preparedAt
        shipAt
        collectAt
        collectValue
        address
        voucherCode
        voucherValue
        voucherIsPercent
        discountCode
        discountValue
        rating
        store {
          id
        }
        longitude
        latitude
        rating
        note
        dishes {
          dish {
            id
            name
            description
            images
            defaultPrice
          }
          quantity
          price
        }
      }
    }
    ''';
  }

  static String getDiscountCode(String code) {
    return '''
      {
        getDiscountCode(code: "$code") {
          code
          isActive
          name
          description
          startAt
          endAt
          minBillPrice
          maxPriceDiscount
          maxNumber
          discount
          stores {
            id
          }
        }
      }
    ''';
  }

  static String todayDish(int storeId) {
    final query = '''
    {
      todayDish(storeId: $storeId) {
        day
        session
        storeId
        dish {
          id
          name
          description
          images
          defaultPrice
          price
        }
      }
    }
    ''';
    return query;
  }
}
