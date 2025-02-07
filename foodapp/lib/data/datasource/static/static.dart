import 'package:foodapp/core/constant/imgassets.dart';
import 'package:foodapp/data/model/onboardingmodel.dart';

List<OnBoardingModel> onBoardingList = [
  OnBoardingModel(
      image: AppImageAsset.onBoardingImgOne,
      title: 'Lựa chọn món ngon',
      body: 'Chọn món ăn của bạn hơn 30 món \n từ thực đơn của chúng tôi'),
  OnBoardingModel(
      image: AppImageAsset.onBoardingImgTwo,
      title: 'Thanh toán dễ dàng \n và trực tuyến',
      body: 'Bạn có thể thanh toán bằng thẻ'),
  OnBoardingModel(
      image: AppImageAsset.onBoardingImgThree,
      title: 'Giao hàng nhanh',
      body: 'Vận chuyển món ăn của bạn \n thật nhanh chóng và an toàn'),
];
