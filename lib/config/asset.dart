class Assets {
  static const fontPoppins = 'Poppins';

  static const _assets = 'assets/';
  static const _images = '${_assets}images/';

  static const imageLogo = '${_images}logo.png';
  static const image1 = '${_images}img1.jpg';

  String image(String name) => '$_images$name.png';
}
