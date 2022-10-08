import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';

/////////////////////////////////////
//////// Widget to Buttons //////////
/////////////////////////////////////
class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Center(
        child: SpinKitWave(
          color: primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}