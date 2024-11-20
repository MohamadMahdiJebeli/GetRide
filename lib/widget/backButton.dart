import 'package:flutter/material.dart';
import 'package:getride/constant/dimens.dart';


// ignore: must_be_immutable
class MyBackButton extends StatelessWidget {

  Function() onPressed;
  MyBackButton ({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: Dimens.large+5,
        left: Dimens.medium,
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(3, 2),
                blurRadius: 18
              )
            ]
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_back)),
        ),
      );
  }
}