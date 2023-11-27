class MenuData {
   dynamic dishName;
   dynamic menuId;
   dynamic vendorId;
   dynamic category;
   dynamic price;
   dynamic docid;
   dynamic discount;
   dynamic description;
   String? image;
   dynamic booking;
   dynamic time;
   dynamic bookingForDelivery;
   dynamic bookingForDining;

  MenuData({this.dishName, this.bookingForDelivery,this.bookingForDining,this.category, this.price, this.docid, this.discount, this.description, this.image, this.booking,this.time,this.menuId,this.vendorId});

  Map<String, dynamic> toMap() {
    return {
      "menuId": menuId,
      "vendorId": vendorId,
      "dishName": dishName,
      "category": category,
      "price": price,
      "docid": docid,
      "discount": discount,
      "description": description,
      "image": image,
      "booking": booking,
      "time": time,
      "bookingForDelivery": bookingForDelivery,
      "bookingForDining": bookingForDining,
    };
  }

  factory MenuData.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuData(
      dishName: map['dishName'],
      vendorId: map['vendorId'],
      menuId: menuId,
      category: map['category'],
      price: map['price'],
      discount: map['discount'],
      docid: map['docid'],
      description: map['description'],
      image: map['image'],
      booking: map['booking'],
      time: map['time'],
      bookingForDelivery: map['bookingForDelivery'],
      bookingForDining: map['bookingForDining'],
    );
  }
}
