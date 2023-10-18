import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resvago_vendor/helper.dart';
import 'package:resvago_vendor/model/menu_model.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';
import 'add_menu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Stream<List<MenuData>> getMenu() {
    return FirebaseFirestore.instance.collection("vendor_menu").doc(FirebaseAuth.instance.currentUser!.phoneNumber).collection("menus").snapshots().map((querySnapshot) {
      List<MenuData> menuList = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          menuList.add(MenuData.fromMap(gg, doc.id.toString()));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return menuList;
    });
  }

  List<MenuData> filterMenus(List<MenuData> menus, String query) {
    if (query.isEmpty) {
      return menus; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return menus.where((menu) {
        if (menu.dishName is String) {
          return menu.dishName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(title: "Menu List", context: context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10),
            child: Column(children: [
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.backgroundcolor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                // offset: Offset(2, 2),
                                blurRadius: 05)
                          ]),
                      child: TextField(
                        maxLines: 1,
                        style: const TextStyle(fontSize: 17),
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => {
                          setState(() {
                            searchQuery = value;
                          })
                        },
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search_rounded,
                                color: const Color(0xFF9DA4BB),
                                size: AddSize.size25,
                              ),
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: AddSize.padding20, vertical: AddSize.padding10),
                            hintText: 'Find for food or restaurant...',
                            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9DA4BB), fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(AddMenuScreen(menuId: DateTime.now().millisecondsSinceEpoch.toString()));
                    },
                    child: Container(
                      height: AddSize.size20 * 2.2,
                      width: AddSize.size20 * 2.2,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.add,
                        color: AppTheme.backgroundcolor,
                        size: AddSize.size25,
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: AddSize.size10,
              ),
              StreamBuilder<List<MenuData>>(
                stream: getMenu(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingAnimationWidget.fourRotatingDots(
                      color: AppTheme.primaryColor,
                      size: 40,
                    );
                  }
                  if(snapshot.hasData){
                    List<MenuData> menu = snapshot.data ?? [];
                    log(menu.toString());
                    final filteredUsers = filterMenus(menu, searchQuery); //
                    return filteredUsers.isNotEmpty
                        ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          var menuItem = filteredUsers[index];
                          return Stack(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: AddSize.size10),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(
                                              .1,
                                              .1,
                                            ),
                                            blurRadius: 19.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                        color: AppTheme.backgroundcolor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: AddSize.size80,
                                            width: AddSize.size80,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: menuItem.image.toString(),
                                                errorWidget: (_, __, ___) => const SizedBox(),
                                                placeholder: (_, __) => const SizedBox(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AddSize.size15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        menuItem.dishName ?? "".toString(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18,
                                                            color: AppTheme.blackcolor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      menuItem.category.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 14,
                                                          color: Color(0xFF8C9BB2)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "\$${menuItem.price.toString()}",
                                                        // '20.00',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 16,
                                                          color: AppTheme.lightBlueColor,
                                                        ),
                                                      )
                                                    ]),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))),
                              Positioned(
                                  right: 10,
                                  top: 20,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => AddMenuScreen(
                                            menuId: menuItem.menuId,
                                            menuItemData: menuItem,
                                          ));
                                        },
                                        child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDFE8F6),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.edit,
                                                color: AppTheme.lightBlueColor,
                                                size: AddSize.size15,
                                              ),
                                            )),
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection('vendor_menu').doc(
                                            FirebaseAuth.instance.currentUser!.phoneNumber)
                                          .collection('menus')
                                              .doc(menuItem.menuId)
                                              .delete()
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(.2),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.delete_outline_sharp,
                                                color: Colors.red,
                                                size: AddSize.size15,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ))
                            ],
                          );
                        })
                        : const Center(child: Text("No Menu Created"),);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ]),
          ),
        ));
  }
}
