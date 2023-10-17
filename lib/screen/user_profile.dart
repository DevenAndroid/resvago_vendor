import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File profileImage = File("");
  bool showValidation = false;
  bool showValidationImg = false;
  final _formKeySignup = GlobalKey<FormState>();
  final registerController = Get.put(RegisterController());
  var obscureText4 = true;
  var obscureText3 = true;
  RxBool checkboxColor = false.obs;
  bool value = false;
  var obscureText5 = true;
  Rx<File> image = File("").obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Old Password",
                  style: GoogleFonts.poppins(
                      color: AppTheme.registortext,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                        Icons.visibility_off,
                        color: Color(0xFF8487A1),
                      )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),

                const SizedBox(
                  height: 20,
                ),  Text(
                  "New Password",
                  style: GoogleFonts.poppins(
                      color: AppTheme.registortext,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                        Icons.visibility_off,
                        color: Color(0xFF8487A1),
                      )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),

                const SizedBox(
                  height: 20,
                ),  Text(
                  "Confirm New Password",
                  style: GoogleFonts.poppins(
                      color: AppTheme.registortext,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                        Icons.visibility_off,
                        color: Color(0xFF8487A1),
                      )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),

                const SizedBox(
                  height: 20,
                ),
                CommonButtonBlue(
                  onPressed: () {},
                  title: 'Save',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignup,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 50),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                               border: Border.all(color: Colors.white)),
                            child: Image.asset('assets/images/Group.png')
                        ),
                        Positioned(
                            top: 90,
                            left: 130,
                            right: 130,
                            child: Container(
                              height: 100,
                              width: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Color(0xffFAAF40),
                                border: Border.all(color: const Color(0xff3B5998), width: 6),
                                borderRadius: BorderRadius.circular(50),
                                // color: Colors.brown
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIsAAACLCAMAAABmx5rNAAAAk1BMVEX///8AESEAAACqrrL8/Pz///0AABIAAAsAABb+/f8AEiD3+PgACBwAABQAABgDEyTCxMYkJy8NEBnm5+nf4OBERksAAAXv8PFJTFAAABvIy800N0AqLDFVWWGcoKK6vL8sLzlOUlnU1tiPkpV0eHtdY2aFiIppa281ODxgZGwbICkADRcUGiYRGCASFSQAChlBRFDZEkPCAAADqElEQVR4nO2a23aqMBCGQyCEkwoCxkMLFizWnt//6XbQrVUrhNYw7rX2fFcsb/ydmX+YTCQEQRAEQRAEQRAEQRAE+QZj359uhRUXuWmaYRIz4t5UiZ+tlxNaw59W5q1UWBYjxZpSJzB2BA6lVUxukSvGRDa2Dc8z9oyMDx6ZPrGgpbgkTmkgv/+I0cgI6EbAlg2zXDIfD4xL8KdEJhAwTRYp7oYXpRgjexoT0NCIsTO6rMUwJgsCWb3+o92kREIrQCnEpI1RqdM0mcNJEc9BixTDc1IoJS7JqOG1iTF4TlyINsOIv2jw0CEwfA3jJNn6absU2QG5YBBiXFKqtEgr5UC+fnSUWiYVjBaRKspF4mwglBASP7U6estsKkC0JJFaS5D+f1riZYccAWkRqVqLcw8z3Vn3ak/zFVB/qTr0OhNIy7yDlgRGCvNVxevJcoHRYpFyogqLnBmARt5k3C5ltoBx9BbFm1qGBQ4xbbP1ZO1DHgQKGnhN4/fgBTBDdV2GdoOXPCcq5MESVIw5uZymwetczt3Aq4b5m3T20Zph90zr4zQwMjLxip+HZvBSCbDOcoDV5598QY/KZmjTh3m9JAKWsqdYLeoF2XZNllbw6TlFJHlWVWWWJ/6NlZzkA9o9W+paEaE4+37ZVA6fQ5avn015avrkeKfr1kdtM+XTzAdcBvlZRIfGjL6Wp4uWefVKhyOHRhlE7VgWYyRc8J2TA27f3Wd5kSRJkWf3d/bh80VIGOvZ3S4jVmUfWpxnBDalzvv7u0Nlq/l6Ww7syu37peSSYnm8H/OM0d+10NfTDros+tw61z/UfB40zQpnnztRPWj2VsQWMan6nLYnqA8mfZl7uwVqW2CexSmgZT9CrC47w1MtMjIZIT1UjWywpvqMdk4/50eLhB/da2UfmuAj1B2XumuJlx9LkWkavgmiN01Si/9w+Y5Ghf3gax6vOi1SL4dGt5mYPLb+PEM7LcE40XoDycim7ZKmHXuj10sdVi7NUK1XOP50doWW4VTnOJPzK6Rsr3A0IR35+ftqqbE/9dlaeUmjghaaypeR8roUySSVuqwkOizd2wkioUnLVYbeoc3WHXbLSi2arqytDvt/FUGqx0dd7miUWiI9O4j8uuayw9bT7kr+gyG3AY/rmRxW13aXGr7SoqX1Px1dsR+1aKm0xEWPqedcfR+tYsg1NbswpdeShnqkMCK2fy38PXkhdL0bNSxSbrJWRBAEQRAEQRAEQRAE+Rf4A9JzM5mdCizPAAAAAElFTkSuQmCC",
                                height: AddSize.size30,
                                width: AddSize.size30,
                                errorWidget: (_, __, ___) => const Icon(Icons.person,size: 60,),
                                placeholder: (_, __) => const SizedBox(),
                              ),
                            ),
                        ),
                        Positioned(
                            top: 150,
                            left: 210,
                            right: 122,
                            child: Container(
                              height: 30,
                              width: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xff04666E),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.camera_alt,color: Colors.white,size: 15,),
                            ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Mac Restaurant",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "veg Restaurant",
                        style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Restaurant Name",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      validator: RequiredValidator(
                          errorText: 'Please enter your Restaurant Name '),
                      // keyboardType: TextInputType.none,
                      // textInputAction: TextInputAction.next,
                      hint: 'Mac Restaurant',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Category",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      // length: 10,
                      validator: RequiredValidator(
                          errorText: 'Please enter your Category '),
                      // keyboardType: TextInputType.number,
                      // textInputAction: TextInputAction.next,
                      hint: 'Veg Restaurant',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Email",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      // length: 10,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your email'),
                        EmailValidator(
                            errorText: 'Enter a valid email address'),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      // textInputAction: TextInputAction.next,
                      hint: 'MacRestaurant@gmail.com',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Mobile Number",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      length: 10,
                      validator: RequiredValidator(
                          errorText: 'Please enter your Mobile Number '),
                      keyboardType: TextInputType.number,
                      // textInputAction: TextInputAction.next,
                      hint: '987-654-3210',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Address",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      // length: 10,
                      validator: RequiredValidator(
                          errorText: 'Please enter your Address '),
                      keyboardType: TextInputType.streetAddress,
                      // textInputAction: TextInputAction.next,
                      hint: 'Street, Zip Code, City',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Password",
                      style: GoogleFonts.poppins(
                          color: AppTheme.registortext,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RegisterTextFieldWidget(
                      suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText4 = !obscureText4;
                            });
                          },
                          child: obscureText4
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFF8487A1),
                                )
                              : const Icon(Icons.visibility,
                                  color: Color(0xFF8487A1))),
                      obscureText: obscureText4,
                      // length: 10,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your password'),
                        MinLengthValidator(8,
                            errorText:
                                'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                        PatternValidator(
                            r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                            errorText:
                                "Password must be at least with 1 special character & 1 numerical"),
                      ]),
                      hint: '************',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButtonBlue(
                      onPressed: () {},
                      title: 'Save',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xffFAAF40)
                        ),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          showBottomSheet(context);
                        },
                        child: const Center(
                          child: Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffFAAF40)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
