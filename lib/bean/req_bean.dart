
class UserReq {
  UserReq (this.username, this.password);

  String username;
  String password;

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
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
        '}';
  }

  String toUrl() => "username=" + username + "&password=" + password;


}