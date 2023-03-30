import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cart_express/e_commerce_app/constant/divider.dart';
import 'package:my_cart_express/e_commerce_app/constant/sizedbox.dart';
import 'package:my_cart_express/e_commerce_app/controller/profile/profile_screen_controller.dart';
import 'package:my_cart_express/e_commerce_app/controller/theme_controller.dart';
import 'package:my_cart_express/e_commerce_app/theme/app_colors.dart';
import 'package:my_cart_express/e_commerce_app/theme/app_text_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileScreenController>(
        init: ProfileScreenController(),
        builder: (_) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: Get.width,
                color: Theme.of(context).colorScheme.primary,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      height20,
                      profileView(context, _),
                    ],
                  ),
                ),
              ),
              height20,
              bodyView(context, _),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileView(BuildContext context, ProfileScreenController _) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: whiteColor,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://engineering.princeton.edu/wp-content/uploads/2020/06/Meggers_450x600.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        height15,
        Text(
          'Mathew Andrey',
          style: regularText16.copyWith(
            color: whiteColor,
          ),
        ),
        height5,
        Text(
          'mathew654@gmail.com',
          style: regularText14.copyWith(
            color: whiteColor,
          ),
        ),
        height15,
      ],
    );
  }

  Widget bodyView(BuildContext context, ProfileScreenController _) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Get.find<ThemeController>().isDarkTheme.value
            ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
            : Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: Get.find<ThemeController>().isDarkTheme.value
            ? <BoxShadow>[]
            : <BoxShadow>[
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        children: <Widget>[
          rowDecorationView(
            title: 'Account info',
            onTap: () {
              _.accountInfo();
            },
          ),
          dividers(0),
          rowDecorationView(
            title: 'Cupons',
            onTap: () {},
          ),
          dividers(0),
          rowDecorationView(
            title: 'Settings',
            onTap: () {},
          ),
          dividers(0),
          rowDecorationView(
            title: 'Share App',
            onTap: () {},
          ),
          dividers(0),
          rowDecorationView(
            title: 'Help Ceter',
            onTap: () {},
          ),
          dividers(0),
          rowDecorationView(
            title: 'Log out',
            onTap: () {
              _.logoutPressed();
            },
          ),
        ],
      ),
    );
  }

  Widget rowDecorationView({required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Text(
              title,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
