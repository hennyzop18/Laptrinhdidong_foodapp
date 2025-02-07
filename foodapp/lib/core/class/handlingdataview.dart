import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodapp/core/class/statusrequest.dart';
import 'package:foodapp/core/constant/imgassets.dart';
import 'package:lottie/lottie.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataView(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Center(child: Lottie.asset(AppImageAsset.loading))
        : statusRequest == StatusRequest.offlinefailure
            ? Center(child: Lottie.asset(AppImageAsset.offline))
            : statusRequest == StatusRequest.serverfailure
                ? Center(child: Lottie.asset(AppImageAsset.server))
                : statusRequest == StatusRequest.failure
                    ? Center(child: Lottie.asset(AppImageAsset.nodata))
                    : widget;
  }
}

class HandlingDataRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataRequest(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Center(child: Lottie.asset(AppImageAsset.loading))
        : statusRequest == StatusRequest.offlinefailure
            ? Center(child: Lottie.asset(AppImageAsset.offline))
            : statusRequest == StatusRequest.serverfailure
                ? Center(child: Lottie.asset(AppImageAsset.server))
                : widget;
  }
}
