import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOpacity extends StatelessWidget {
  const LoadingOpacity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(
        color: Colors.black,
        size: 30,
      ),
    );
  }
}
