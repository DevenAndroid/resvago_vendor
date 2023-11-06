import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/screen/delivery_oders_details_screen.dart';
import 'package:resvago_vendor/widget/apptheme.dart';

import '../../model/order_details_modal.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../oder_details_screen.dart';

class OderListScreen extends StatefulWidget {
  const OderListScreen({super.key});

  @override
  State<OderListScreen> createState() => _OderListScreenState();
}

class _OderListScreenState extends State<OderListScreen> {
  RxString dropDownValue1 = ''.obs;
  RxString dropDownValue2 = ''.obs;
  String searchQuery = '';


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,

        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
            height: 320,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage(AppAssets.oderlistbg))),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              AppAssets.backWhite,
                              height: AddSize.size25,
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Oder List",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(.35)),
                      color: Colors.white.withOpacity(.10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$450.00",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28),
                            ),
                            Text(
                              "Your earning this month",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Withdrawal",
                            style: GoogleFonts.poppins(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: size.width * .4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          child: PopupMenuButton<int>(
                            constraints: const BoxConstraints(maxHeight: 300),
                            position: PopupMenuPosition.under,
                            offset: Offset.fromDirection(1, 1),
                            onSelected: (value) {
                              setState(() {});
                            },
                            // icon: Icon(Icons.keyboard_arrow_down),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      dropDownValue1.value = 'No';
                                    },
                                    child: const Text('No',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),
                              PopupMenuItem(
                                  child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        dropDownValue1.value = 'Yes';
                                      });
                                    },
                                    child: const Text('Yes',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),
                            ],
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withOpacity(.35)),
                                color: Colors.white.withOpacity(.10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            dropDownValue1.value
                                                    .toString()
                                                    .isEmpty
                                                ? "Filter"
                                                : dropDownValue1.value.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: size.width * .4,
                        child: PopupMenuButton<int>(
                          constraints: const BoxConstraints(maxHeight: 300),
                          position: PopupMenuPosition.under,
                          offset: Offset.fromDirection(1, 1),
                          onSelected: (value) {
                            setState(() {});
                          },
                          // icon: Icon(Icons.keyboard_arrow_down),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    dropDownValue2.value = 'False';
                                    Get.back();
                                  },
                                  child: const Text('False',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )),
                            PopupMenuItem(
                                child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      dropDownValue2.value = 'True';
                                      Get.back();
                                    });
                                  },
                                  child: const Text('True',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )),
                          ],
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white.withOpacity(.35)),
                              color: Colors.white.withOpacity(.10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          dropDownValue2.value.toString().isEmpty
                                              ? "Status"
                                              : dropDownValue2.value.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(.35)),
                      color: Colors.white.withOpacity(.10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 10),
                        focusColor: Colors.white,
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          textStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          fontSize: 14,
                          // fontFamily: 'poppins',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

              ]),
            ),
          ),
              const TabBar(
                  labelColor: Color(0xFF454B5C),

                  indicatorColor: Color(0xFF3B5998),
                  indicatorWeight: 4,
                  tabs: [
                Tab(text: "Dining Orders",),
                Tab(text: "Delivery Orders",),
              ]),
              Expanded(
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Order No.", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              const SizedBox(width: 1,),
                              Text("Status", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("Earning", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          StreamBuilder<List<MyOrderModel>>(
                            stream: getOrdersStreamFromFirestore(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<MyOrderModel> users = snapshot.data ?? [];
                                final filteredUsers = filterUsers(users, searchQuery); // Apply the search filter

                                return filteredUsers.isNotEmpty
                                    ? ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: filteredUsers.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final item = filteredUsers[index];

                                      return InkWell(
                                        onTap: (){
                                          Get.to(()=> OderDetailsScreen(myOrderModel: item,));
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(item.orderId.toString(), style: GoogleFonts.poppins(
                                                        color: const Color(0xFF454B5C),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14),),
                                                    Text(item.time.toString(), style: GoogleFonts.poppins(
                                                        color: const Color(0xFF8C9BB2),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 11),),
                                                  ],
                                                ),
                                                Text(item.orderStatus, style: GoogleFonts.poppins(
                                                    color: const Color(0xFFFFB26B),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),),
                                                Text("\$450.00", style: GoogleFonts.poppins(
                                                    color: const Color(0xFF454B5C),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.black12.withOpacity(0.09),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    : const Center(
                                  child: Text("No User Found"),
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          )





                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Order No.", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              const SizedBox(width: 1,),
                              Text("Status", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("Earning", style: GoogleFonts.poppins(
                                  color: const Color(0xFF3B5998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,),
                          InkWell(
                            onTap:(){
                              Get.to(DeliveryOderDetailsScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("#1234", style: GoogleFonts.poppins(
                                        color: const Color(0xFF454B5C),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),),
                                    Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                        color: const Color(0xFF8C9BB2),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11),),
                                  ],
                                ),
                                Text("Processing", style: GoogleFonts.poppins(
                                    color: const Color(0xFFFFB26B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),),
                                Text("\$450.00", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Completed", style: GoogleFonts.poppins(
                                  color: const Color(0xFF65CD90),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Reject", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFF557E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Processing", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Processing", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 10,), Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Processing", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          const SizedBox(height: 40,),



                        ],
                      ),
                    ),
                  ),



                ]),
              )
            ],
          ),
        ));
  }
  List<MyOrderModel> filterUsers(List<MyOrderModel> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users.where((user) {
        if (user.orderId is String) {
          return user.orderId!.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }
  Stream<List<MyOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data()));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
}
