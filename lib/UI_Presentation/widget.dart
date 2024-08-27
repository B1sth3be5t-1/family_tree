import 'package:family_tree/Config_and_Extras/Material-theme/color_schemes.g.dart';
import 'package:family_tree/Config_and_Extras/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Mainbutton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String? image;
  final Color? txtColor;
  final Color btnColor;
  const Mainbutton({
    super.key,
    required this.onTap,
    required this.text,
    this.image,
    this.txtColor,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                'assets/image/$image',
                height: 25.0,
                width: 60.0,
              ),
            Text(
              text,
              style: txtColor != null ? headline2.copyWith(color: txtColor) : headline2,
            )
          ],
        ),
      ),
    );
  }
}

Widget textField({
  required String hintTxt,
  required String image,
  required TextEditingController controller,
  bool isObs = false,
  TextInputType? keyBordType,
}) {
  return Container(
    height: 70.0,
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    margin: const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    decoration: BoxDecoration(
      color: currentColorScheme.shadow,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 270.0,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObs,
            keyboardType: keyBordType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: hintStyle,
            ),
            style: headline2,
          ),
        ),
        SvgPicture.asset(
          'assets/icon/$image',
          height: 20.0,
          color: currentColorScheme.outline,
        )
      ],
    ),
  );
}

class SpaceVH extends StatelessWidget {
  final double? width;
  final double? height;
  const SpaceVH({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0.0,
      width: width ?? 0.0,
    );
  }
}
