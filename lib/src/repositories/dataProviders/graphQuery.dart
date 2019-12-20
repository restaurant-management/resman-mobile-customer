class GraphQuery {
  static String me = 
  '''
  {
    meAsCustomer {
      uuid
      username
      settings
      password
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
}
