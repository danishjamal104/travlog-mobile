class Queries {

  static Queries _queries = null;

  static Queries getInstance() {
    if(_queries == null) {
      _queries = Queries();
    }
    return _queries;
  }

  String loginUser(String username, String password) {
    return '''mutation{
    tokenAuth(username:"$username", password:"$password") {
    token
    }
    }
    ''';
  }

  String profileUpdate(String username, String password, String firstName, String lastName, String mobileNumber, String bio) {
    return '''mutation{
    tokenAuth(username:"$username", password:"$password") {
    token
    }
    updateProfile(phoneNo:"$mobileNumber", firstName:"$firstName", lastName: "$lastName", bio: "$bio") {
    __typename
    }
    }
    ''';
  }

  String registerUser(String username, String password, String email) {
    return '''mutation{
    createUser(username:"$username", password:"$password", email: "$email") {
    __typename
    }
    }
    ''';
  }

}
