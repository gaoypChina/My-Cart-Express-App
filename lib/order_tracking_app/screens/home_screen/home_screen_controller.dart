// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_cart_express/e_commerce_app/e_constant/e_storage_key.dart';
import 'package:my_cart_express/e_commerce_app/e_controller/e_theme_controller.dart';
import 'package:my_cart_express/e_commerce_app/e_routes/e_app_pages.dart';
import 'package:my_cart_express/order_tracking_app/constant/storage_key.dart';
import 'package:my_cart_express/order_tracking_app/screens/home/main_home_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/auth_pickup/auth_pickup_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/faqs_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/feedback_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/my_rewards_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/shipping_calculator_screen/shipping_calculator_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/support/support_index_screen.dart';
import 'package:my_cart_express/order_tracking_app/screens/more_screen/transaction_screen.dart';
import 'package:my_cart_express/order_tracking_app/utils/network_dio.dart';
import 'package:my_cart_express/order_tracking_app/constant/app_endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenController extends GetxController {
  Rx<File>? selectedFile;
  var balance = 0.obs;
  RxString catId = ''.obs;
  RxString fileName = ''.obs;
  RxString fullName = ''.obs;
  RxString howItWorks = ''.obs;
  RxList packagesList = [].obs;
  RxList categoriesList = [].obs;
  RxMap usaShippingData = {}.obs;
  RxMap pickuoBranchData = {}.obs;
  GetStorage box = GetStorage();
  RxList imageList = [].obs;
  TextEditingController type = TextEditingController();
  TextEditingController declared = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getBalance(BuildContext context) async {
    Map<String, dynamic>? shippingCount = await NetworkDio.getDioHttpMethod(
      url: ApiEndPoints.apiEndPoint + ApiEndPoints.shippingCount,
      context: context,
    );
    if (shippingCount != null) {
      packageCounts.value = shippingCount['package_counts'];
      availablePackageCounts.value = shippingCount['available_package_counts'];
      overduePackageCounts.value = shippingCount['overdue_package_counts'];

      Map<String, dynamic>? packagesResponse =
          await NetworkDio.getDioHttpMethod(
        url: ApiEndPoints.apiEndPoint + ApiEndPoints.dashboardPackageList,
        context: context,
      );
      if (packagesResponse != null) {
        packagesList.value = packagesResponse['list'] ?? [];

        Map<String, dynamic>? howItWorksResponse =
            await NetworkDio.getDioHttpMethod(
          url: ApiEndPoints.apiEndPoint + ApiEndPoints.howItWorks,
          context: context,
        );
        if (howItWorksResponse != null) {
          howItWorks.value = howItWorksResponse['img_url'];
          Map<String, dynamic>? shippingPickupAddress =
              await NetworkDio.getDioHttpMethod(
            url: ApiEndPoints.apiEndPoint + ApiEndPoints.shippingPickupAddress,
            context: context,
          );
          if (shippingPickupAddress != null) {
            fullName.value = shippingPickupAddress['package_shipping_data']
                    ['firstname'] +
                ' ' +
                shippingPickupAddress['package_shipping_data']['lastname'] +
                ' ' +
                shippingPickupAddress['package_shipping_data']['mce_number'];
            usaShippingData.value =
                shippingPickupAddress['package_shipping_data']
                    ['usa_air_address_details'];
            pickuoBranchData.value =
                shippingPickupAddress['package_shipping_data']['branch_data'];

            Map<String, dynamic>? categoriesListResponse =
                await NetworkDio.getDioHttpMethod(
              url: ApiEndPoints.apiEndPoint + ApiEndPoints.shippingCategories,
              context: context,
            );
            if (categoriesListResponse != null) {
              categoriesList.value = categoriesListResponse['list'];
              Map<String, dynamic>? response =
                  await NetworkDio.getDioHttpMethod(
                url: ApiEndPoints.apiEndPoint + ApiEndPoints.balance,
                context: context,
              );
              if (response != null) {
                balance.value = response['data'];
                Map<String, dynamic>? images =
                    await NetworkDio.getDioHttpMethod(
                  url: ApiEndPoints.apiEndPoint +
                      ApiEndPoints.branchBannerImages,
                  context: context,
                );
                if (images != null) {
                  imageList.value = images['data'];
                }
              }
            }
          }
        }
      }
    }
  }

  void redirectHome(int i) {
    bool isInAppRedirect = imageList[i]['image_link_type'] == "1";
    if (isInAppRedirect && imageList[i]['image_link'] == "1") {
      Get.to(const ShippingCalculatorScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "2") {
      Get.to(() => const TransactionScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "3") {
      Get.to(() => const FAQSScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "4") {
      Get.to(() => const SupportIndexScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "5") {
      Get.to(() => const FeedbackScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "6") {
      Get.to(() => const MyRewardsScreen());
    } else if (isInAppRedirect && imageList[i]['image_link'] == "7") {
      Get.to(() => const AuthPickUpScreen());
    } else if (imageList[i]['image_link_type'] == "2") {
      launchUrl(Uri.parse(imageList[i]['image_link']));
    }
  }

  Future<void> pickFile(FilePickerResult? result) async {
    if (result != null) {
      selectedFile?.value = File(result.files.first.path!);
      fileName.value = result.files.first.name;
    }
  }

  Future<void> submitOnTap(String? packageId, BuildContext context) async {
    final data = dio.FormData.fromMap({
      'files': await dio.MultipartFile.fromFile(
        selectedFile!.value.path,
        filename: fileName.value,
      ),
      'attachment_package_id': packageId,
      'attach_for': 'invoice',
      'customer_input_value': declared.text,
      'category_id': catId.value,
    });
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiEndPoints.apiEndPoint + ApiEndPoints.uploadAttachments,
      data: data,
      context: context,
    );
    if (response != null) {
      Get.back();
      NetworkDio.showSuccess(
          title: 'Success', sucessMessage: response['message']);
    }
  }

  Future<void> changeApp() async {
    Get.find<ThemeController>().isECommerce.value = true;
    box.write(StorageKey.isECommerce, true);
    if (box.read(EStorageKey.eIsLogedIn)) {
      Get.offAllNamed(ERoutes.mainHome);
    } else {
      Get.offAllNamed(ERoutes.firstOnboarding);
    }
  }
}