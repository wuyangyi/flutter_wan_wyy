
class UserRegister {
  UserRegister (this.username, this.password, this.repassword);

  String username;
  String password;
  String repassword;

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'repassword': repassword,
  };

  @override
  String toString() {
    return '{' +
        " \"username\":\"" +
        username +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        ", \"repassword\":\"" +
        repassword +
        "\"" +
        '}';
  }

  String toUrl() => "username=" + username + "&password=" + password + "&repassword=" + repassword;


}