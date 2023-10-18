class ProfileData {
  String? image;
  String? password;
  String? address;
  String? restaurantName;
  Null? docid;
  String? mobileNumber;
  String? confirmPassword;
  String? category;
  String? userID;
  String? email;

  ProfileData(
      {this.image,
        this.password,
        this.address,
        this.restaurantName,
        this.docid,
        this.mobileNumber,
        this.confirmPassword,
        this.category,
        this.userID,
        this.email});

  ProfileData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    password = json['password'];
    address = json['address'];
    restaurantName = json['restaurantName'];
    docid = json['docid'];
    mobileNumber = json['mobileNumber'];
    confirmPassword = json['confirmPassword'];
    category = json['category'];
    userID = json['userID'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['password'] = this.password;
    data['address'] = this.address;
    data['restaurantName'] = this.restaurantName;
    data['docid'] = this.docid;
    data['mobileNumber'] = this.mobileNumber;
    data['confirmPassword'] = this.confirmPassword;
    data['category'] = this.category;
    data['userID'] = this.userID;
    data['email'] = this.email;
    return data;
  }
}
