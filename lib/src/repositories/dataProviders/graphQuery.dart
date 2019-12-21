import 'package:resman_mobile_customer/src/models/address.dart';

class GraphQuery {
  static String me = '''
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
        defaultPrice
        description
        id
        name
        price
        images
      }
    }
  }
  ''';

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
    return '''
    mutation {
      changeProfileAsCustomer(
        avatar: "$avatar", 
        fullName: "$fullName", 
        phoneNumber: "$phoneNumber", 
        ${birthday != null ? 'birthday: "$birthday"' : ''}
      ) {
        uuid
      }
    }
    ''';
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
}
