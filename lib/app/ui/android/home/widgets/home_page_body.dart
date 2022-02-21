import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
