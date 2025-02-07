class User {
  int user_id;
  String name;
  String user_name;
  String user_email;
  String user_password;
  String user_address;

  User(
    this.user_id,
    this.name,
    this.user_name,
    this.user_email,
    this.user_password,
    this.user_address,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
      int.parse(json['id']),
      json['name'],
      json['username'],
      json['email'],
      json['pass'],
      json['address']);

  Map<String, dynamic> toJson() {
    return {
      'id': this.user_id.toString(),
      'name': this.name,
      'username': this.user_name,
      'email': this.user_email,
      'pass': this.user_password,
      'address': this.user_address,
    };
  }
}
