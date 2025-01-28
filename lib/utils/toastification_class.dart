import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MessagingClass {
  void showMessage(String message, bool isError) async {

    toastification.show(
      context: Get.context,
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        isError ? 'Error' : 'Success',
        style: const TextStyle(color: Colors.white),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: message,
              style: const TextStyle(
                  color: Colors.white))),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: isError
          ? const Icon(
        Icons.error_outline,
        color: Colors.white,
      )
          : const Icon(
        Icons.check,
        color: Colors.white,
      ),
      showIcon: true,
      primaryColor: Colors.green,
      backgroundColor: isError ? Colors.red : Colors.green,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}