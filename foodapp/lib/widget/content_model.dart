class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description:
          'Chọn món ăn của bạn hơn 30 món\n       từ thực đơn của chúng tôi.',
      image: "images/screen1.png",
      title: '      Lựa chọn món ngon\ntừ thực đơn của chúng tôi!'),
  UnboardingContent(
      description: 'Bạn có thể thanh toán bằng thẻ',
      image: "images/screen2.png",
      title: '  Thanh toán dễ dàng\n        và trực tuyến'),
  UnboardingContent(
      description:
          '   Vận chuyển món ăn của bạn\n   thật nhanh chóng và an toàn',
      image: "images/screen3.png",
      title: 'Giao hàng nhanh')
];
