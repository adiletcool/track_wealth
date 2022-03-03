import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EmptySearchResult extends StatelessWidget {
  const EmptySearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/empty.json', height: 100, fit: BoxFit.fitHeight),
            const SizedBox(height: 10),
            Text('nothing_found'.tr, style: const TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
