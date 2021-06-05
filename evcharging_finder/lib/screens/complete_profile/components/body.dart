import 'package:flutter/material.dart';
import 'package:evcharging_finder/components/custom_surffix_icon.dart';
import 'package:evcharging_finder/components/default_button.dart';
import 'package:evcharging_finder/components/form_error.dart';
import 'package:evcharging_finder/constants.dart';
import 'package:evcharging_finder/size_config.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "Complete Profile",
            style: headingStyle,
          ),
          Text(
            "Complete your details",
            textAlign: TextAlign.center,
          ),
          CompleteProfileForm(),
        ],
      ),
    );
  }
}
