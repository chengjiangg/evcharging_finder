import 'package:flutter/material.dart';
import 'package:evcharging_finder/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "Charging @ Where",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: Color(0xff123456),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
        Spacer(),
        Image.asset(image,
            height: getProportionateScreenHeight(265),
            width: getProportionateScreenWidth(235))
      ],
    );
  }
}
