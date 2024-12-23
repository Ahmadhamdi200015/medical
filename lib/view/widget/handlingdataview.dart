import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/constant/imageasset.dart';
import '../../core/function/staterequest.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;

  const HandlingDataView(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.lodaing
        ? const Center(
        child: CircularProgressIndicator())
        : statusRequest == StatusRequest.offlinefailure
        ? Center(
        child:
        Lottie.asset(Imageasset.Offline, width: 250, height: 250))
        : statusRequest == StatusRequest.serverfailure
        ? Center(
        child: Lottie.asset(Imageasset.Offline,
            width: 250, height: 250))
        : statusRequest == StatusRequest.failure
        ? Center(
        child: Lottie.asset(Imageasset.NoData,
            width: 250, height: 250))
        : widget;
  }
}
