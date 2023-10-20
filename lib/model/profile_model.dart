class ProfileData {
  List<String>? restaurantImage;
  List<String>? menuGalleryImages;
  String? password;
  String? address;
  String? restaurantName;
  Null? docid;
  String? mobileNumber;
  String? confirmPassword;
  String? category;
  String? userID;
  String? email;
  String? aboutUs;
  String? image;

  ProfileData(
      {
        this.restaurantImage,
        this.menuGalleryImages,
        this.password,
        this.image,
        this.address,
        this.restaurantName,
        this.docid,
        this.mobileNumber,
        this.confirmPassword,
        this.category,
        this.userID,
        this.email,
        this.aboutUs});

  ProfileData.fromJson(Map<String, dynamic> json) {
    restaurantImage = json['restaurantImage'] != null ? json['restaurantImage'].cast<String>() : [];
    menuGalleryImages = json['menuImage'] != null ? json['menuImage'].cast<String>() : [];
    password = json['password'];
    image = json['image'];
    address = json['address'];
    restaurantName = json['restaurantName'];
    docid = json['docid'];
    mobileNumber = json['mobileNumber'];
    confirmPassword = json['confirmPassword'];
    category = json['category'];
    userID = json['userID'];
    email = json['email'];
    aboutUs = json['aboutUs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['restaurantImage'] = this.restaurantImage;
    data['menuImage'] = this.menuGalleryImages;
    data['password'] = this.password;
    data['address'] = this.address;
    data['restaurantName'] = this.restaurantName;
    data['docid'] = this.docid;
    data['mobileNumber'] = this.mobileNumber;
    data['confirmPassword'] = this.confirmPassword;
    data['category'] = this.category;
    data['userID'] = this.userID;
    data['email'] = this.email;
    data['aboutUs'] = this.aboutUs;
    return data;
  }
}
