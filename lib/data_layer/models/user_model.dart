class UserDataModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? userImage;
  String? id;
  int? myCoins;


  UserDataModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.userImage,
    this.id,
    this.myCoins
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    userImage = json['userImage'];
    id = json['id'];
    myCoins = json['myCoins'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'email': email,
      'phone': phone,
      'password': password,
      'userImage': userImage,
      'myCoins':myCoins,
      'id':id,
    };
  }
}
