import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../widgets/animated_switcher_with_transition.dart';
import '../widgets/expanded_section.dart';
import 'widgets/auth_method_card.dart';
import 'widgets/email_auth_widgets.dart';
import 'widgets/phone_auth_widgets.dart';

class AuthPage extends GetView<AuthPageController> {
  AuthPage({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bool keyboardVisible = context.mediaQueryViewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            AuthPageAppBar(keyboardVisible: keyboardVisible),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExpandedSection(
                    expand: !keyboardVisible, // if keyboard is not visible -> expand
                    child: Center(
                      child: Obx(() => Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            alignment: WrapAlignment.center,
                            children: controller
                                .getAuthConfigs()
                                .map((c) => AuthMethodCard(
                                      method: c.method,
                                      backgroundColor: c.backgroundColor,
                                      onTap: c.onTap,
                                    ))
                                .toList(),
                          )),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email / Phone auth body
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Obx(() => AnimatedSwitcherWithTransition(
                    showFirst: controller.isEmailChosen.value,
                    firstChildKey: 'first',
                    firstChild: EmailAuthBody(keyboardVisible: keyboardVisible, key: const Key('first')),
                    secondChild: PhoneAuthBody(keyboardVisible: keyboardVisible),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPageAppBar extends StatelessWidget {
  final bool keyboardVisible;
  const AuthPageAppBar({Key? key, required this.keyboardVisible}) : super(key: key);
  final double appBarHegiht = 100;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: AnimatedCrossFade(
        duration: 200.milliseconds,
        firstChild: SizedBox(
          height: appBarHegiht - 16, // Don't know why, but it aligned with title
          child: FittedBox(
            child: IconButton(
              icon: Icon(Icons.expand_less_rounded, size: 35, color: context.theme.iconTheme.color),
              onPressed: () => Get.focusScope?.unfocus(), // If not working after phoneCodeFocusNode requests focus, then add Get.forceAppUpdate before unfocus
            ),
          ),
        ),
        secondChild: Container(),
        crossFadeState: keyboardVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
      backgroundColor: Colors.transparent,
      pinned: true,
      collapsedHeight: appBarHegiht,
      toolbarHeight: appBarHegiht,
      expandedHeight: appBarHegiht,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: SizedBox(
          child: AuthMethodTitle(),
          height: appBarHegiht,
        ),
      ),
    );
  }
}
