import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addsize.dart';
import 'appassets.dart';
import 'apptheme.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hint;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool? readOnly;
  final dynamic value = 0;
  final dynamic minLines;
  final dynamic maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const CommonTextFieldWidget({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: TextStyle(color: Colors.white),
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: AppTheme.backgroundcolor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
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
          filled: true,
          fillColor: Colors.white.withOpacity(.10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(.35), width: 3.0),
              borderRadius: BorderRadius.circular(15.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CommonButton({Key? key, required this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: ElevatedButton(
          onPressed: onPressed,
          onLongPress: null,
          style: ElevatedButton.styleFrom(

            minimumSize: Size(AddSize.screenWidth, AddSize.size50 * 1.2),
            backgroundColor: Colors.white,

            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, color: AppTheme.primaryColor, letterSpacing: .5, fontSize: 20))),
    );
  }
}

AppBar backAppBar(
    {required title,
    required BuildContext context,
    String dispose = "",
    Color? backgroundColor = AppTheme.backgroundcolor,
    Color? textColor = Colors.black,
    Widget? icon,
      Widget? icon2,
    disposeController}) {
  return AppBar(
    toolbarHeight: 60,
    elevation: 0,
    leadingWidth: AddSize.size22 * 1.6,
    backgroundColor: backgroundColor,
    surfaceTintColor: AppTheme.backgroundcolor,
    title: Text(
      title,
      style: GoogleFonts.poppins(color: Color(0xFF423E5E), fontWeight: FontWeight.w600, fontSize: 17),
    ),
    actions: [
      icon2 ?? SizedBox.shrink()
    ],
    leading: Padding(
      padding: EdgeInsets.only(left: AddSize.padding10),
      child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: icon ??
              Image.asset(
                AppAssets.back,
                height: AddSize.size15,
              )),
    ),
  );
}
