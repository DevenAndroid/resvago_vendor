class ProfileData {
  List<String>? restaurantImage;
  List<String>? menuGalleryImages;
  dynamic password;
  dynamic address;
  dynamic restaurantName;
  dynamic latitude;
  dynamic longitude;
  dynamic docid;
  dynamic mobileNumber;
  dynamic confirmPassword;
  dynamic category;
  dynamic userID;
  dynamic email;
  dynamic aboutUs;
  dynamic image;
  dynamic preparationTime;
  dynamic averageMealForMember;
  dynamic setDelivery;
  dynamic cancellation;
  dynamic menuSelection;

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
        this.aboutUs,
        this.preparationTime,
        this.averageMealForMember,
        this.setDelivery,
        this.cancellation,
        this.menuSelection,
        this.latitude,
        this.longitude,

      });

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
    preparationTime = json['preparationTime'];
    averageMealForMember = json['averageMealForMember'];
    setDelivery = json['setDelivery'];
    cancellation = json['cancellation'];
    menuSelection = json['menuSelection'];
    aboutUs = json['aboutUs'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['restaurantImage'] = restaurantImage;
    data['menuImage'] = menuGalleryImages;
    data['password'] = password;
    data['address'] = address;
    data['restaurantName'] = restaurantName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['confirmPassword'] = confirmPassword;
    data['category'] = category;
    data['userID'] = userID;
    data['email'] = email;
    data['aboutUs'] = aboutUs;
    data['preparationTime'] = preparationTime;
    data['averageMealForMember'] = averageMealForMember;
    data['setDelivery'] = setDelivery;
    data['cancellation'] = cancellation;
    data['menuSelection'] = menuSelection;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
