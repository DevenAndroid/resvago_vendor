class MyOrderModel {
  RestaurantInfo? restaurantInfo;
  dynamic? orderStatus;
  dynamic? couponDiscount;
  dynamic? address;
  dynamic? orderId;
  dynamic? fcmToken;
  dynamic? vendorId;
  dynamic? time;
  dynamic? userId;
  dynamic? orderType;

  MyOrderModel(
      {this.restaurantInfo,
        this.orderStatus,
        this.couponDiscount,
        this.address,
        this.orderId,
        this.fcmToken,
        this.vendorId,
        this.time,
        this.userId,
        this.orderType});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    restaurantInfo = json['restaurantInfo'] != null
        ? new RestaurantInfo.fromJson(json['restaurantInfo'])
        : null;
    orderStatus = json['order_status'];
    couponDiscount = json['couponDiscount'];
    address = json['address'];
    orderId = json['orderId'];
    fcmToken = json['fcm_token'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurantInfo != null) {
      data['restaurantInfo'] = this.restaurantInfo!.toJson();
    }
    data['order_status'] = this.orderStatus;
    data['couponDiscount'] = this.couponDiscount;
    data['address'] = this.address;
    data['orderId'] = this.orderId;
    data['fcm_token'] = this.fcmToken;
    data['vendorId'] = this.vendorId;
    data['time'] = this.time;
    data['userId'] = this.userId;
    data['order_type'] = this.orderType;
    return data;
  }
}

class RestaurantInfo {
  RestaurantInfo? restaurantInfo;
  List<MenuList>? menuList;
  String? cartId;
  String? vendorId;
  int? time;
  String? userId;

  RestaurantInfo(
      {this.restaurantInfo,
        this.menuList,
        this.cartId,
        this.vendorId,
        this.time,
        this.userId});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    restaurantInfo = json['restaurantInfo'] != null
        ? new RestaurantInfo.fromJson(json['restaurantInfo'])
        : null;
    if (json['menuList'] != null) {
      menuList = <MenuList>[];
      json['menuList'].forEach((v) {
        menuList!.add(new MenuList.fromJson(v));
      });
    }
    cartId = json['cartId'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurantInfo != null) {
      data['restaurantInfo'] = this.restaurantInfo!.toJson();
    }
    if (this.menuList != null) {
      data['menuList'] = this.menuList!.map((v) => v.toJson()).toList();
    }
    data['cartId'] = this.cartId;
    data['vendorId'] = this.vendorId;
    data['time'] = this.time;
    data['userId'] = this.userId;
    return data;
  }
}

class RestaurantData {
  String? aboutUs;
  String? image;
  String? address;
  String? mobileNumber;
  String? docid;
  Null? latitude;
  String? userID;
  String? password;
  List<String>? restaurantImage;
  String? restaurantName;
  String? confirmPassword;
  List<String>? menuImage;
  String? category;
  String? email;
  Null? longitude;

  RestaurantData(
      {this.aboutUs,
        this.image,
        this.address,
        this.mobileNumber,
        this.docid,
        this.latitude,
        this.userID,
        this.password,
        this.restaurantImage,
        this.restaurantName,
        this.confirmPassword,
        this.menuImage,
        this.category,
        this.email,
        this.longitude});

  RestaurantData.fromJson(Map<String, dynamic> json) {
    aboutUs = json['aboutUs'];
    image = json['image'];
    address = json['address'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
    latitude = json['latitude'];
    userID = json['userID'];
    password = json['password'];
    restaurantImage = json['restaurantImage'].cast<String>();
    restaurantName = json['restaurantName'];
    confirmPassword = json['confirmPassword'];
    menuImage = json['menuImage'].cast<String>();
    category = json['category'];
    email = json['email'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aboutUs'] = this.aboutUs;
    data['image'] = this.image;
    data['address'] = this.address;
    data['mobileNumber'] = this.mobileNumber;
    data['docid'] = this.docid;
    data['latitude'] = this.latitude;
    data['userID'] = this.userID;
    data['password'] = this.password;
    data['restaurantImage'] = this.restaurantImage;
    data['restaurantName'] = this.restaurantName;
    data['confirmPassword'] = this.confirmPassword;
    data['menuImage'] = this.menuImage;
    data['category'] = this.category;
    data['email'] = this.email;
    data['longitude'] = this.longitude;
    return data;
  }
}

class MenuList {
  String? image;
  Null? booking;
  Null? docid;
  String? discount;
  String? vendorId;
  String? description;
  bool? bookingForDining;
  String? price;
  int? qty;
  bool? bookingForDelivery;
  String? menuId;
  String? dishName;
  Null? time;
  String? category;

  MenuList(
      {this.image,
        this.booking,
        this.docid,
        this.discount,
        this.vendorId,
        this.description,
        this.bookingForDining,
        this.price,
        this.qty,
        this.bookingForDelivery,
        this.menuId,
        this.dishName,
        this.time,
        this.category});

  MenuList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    booking = json['booking'];
    docid = json['docid'];
    discount = json['discount'];
    vendorId = json['vendorId'];
    description = json['description'];
    bookingForDining = json['bookingForDining'];
    price = json['price'];
    qty = json['qty'];
    bookingForDelivery = json['bookingForDelivery'];
    menuId = json['menuId'];
    dishName = json['dishName'];
    time = json['time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['booking'] = this.booking;
    data['docid'] = this.docid;
    data['discount'] = this.discount;
    data['vendorId'] = this.vendorId;
    data['description'] = this.description;
    data['bookingForDining'] = this.bookingForDining;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['bookingForDelivery'] = this.bookingForDelivery;
    data['menuId'] = this.menuId;
    data['dishName'] = this.dishName;
    data['time'] = this.time;
    data['category'] = this.category;
    return data;
  }
}
