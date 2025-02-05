import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cart_express/staff_app/staff_controller/staff_main_home_controller.dart';

import '../../e_commerce_app/e_theme/e_app_colors.dart';

class StaffMainHome extends GetView<StaffMainHomeController> {
  const StaffMainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pageList[controller.page.value]),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          key: controller.bottomNavigationKey,
          currentIndex: controller.page.value,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Warehouse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'POS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Pickup Request',
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.background,
          onTap: (int index) {
            controller.navIconTap(index);
          },
        );
      }),
    );
  }

  Color iconColor(int index) {
    return controller.page.value == index ? whiteColor : blackColor;
  }
}
