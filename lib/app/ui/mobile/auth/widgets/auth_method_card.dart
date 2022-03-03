import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/enums/auth.dart';

class AuthMethodCard extends StatelessWidget {
  final AuthMethod method;
  final Color backgroundColor;
  final void Function()? onTap;

  const AuthMethodCard({
    required this.method,
    required this.backgroundColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedContainer(
        duration: 400.milliseconds,
        color: backgroundColor,
        child: Padding(
          // horizontal padding -> x; left, right padding -> 10; runSpacing = 5
          // 4x = context.width - 2*50 - 2*10 - 5 <=> x = (context.width - 125) / 4
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: (context.width - 125) / 4),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              'assets/images/auth/${method.name}.png',
              filterQuality: FilterQuality.medium,
              isAntiAlias: true,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
