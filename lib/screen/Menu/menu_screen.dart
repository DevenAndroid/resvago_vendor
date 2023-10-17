import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController searchController = TextEditingController();
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
                        controller: searchController,
                        style: const TextStyle(fontSize: 17),
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => {},
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
                      Get.toNamed(MyRouters.addMenuScreen);
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
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
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
                                          imageUrl:
                                              "https://images.unsplash.com/photo-1564671165093-20688ff1fffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fG1lYWx8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60",
                                          errorWidget: (_, __, ___) => const SizedBox(),
                                          placeholder: (_, __) => const SizedBox(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AddSize.size15,
                                    ),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Paneer",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500, fontSize: 18, color: AppTheme.blackcolor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Veg",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300, fontSize: 14, color: Color(0xFF8C9BB2)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "\$20",
                                                  // '20.00',
                                                  style: TextStyle(
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
                            bottom: 45,
                            top: 45,
                            child: GestureDetector(
                              onTap: () {},
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
                            ))
                      ],
                    );
                  })
            ]),
          ),
        ));
  }
}
