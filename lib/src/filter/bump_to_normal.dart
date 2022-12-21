import 'dart:math';

import '../image/image.dart';

/// Generate a normal map from a heightfield bump image.
///
/// The red channel of the [src] image is used as an input, 0 represents a low
/// height and 1 a high value. The optional [strength] parameter allows to set
/// the strength of the normal image.
Image bumpToNormal(Image src, { num strength = 2.0 }) {
  final dest = Image.from(src);

  final mx = src.maxChannelValue;
  for (var y = 0; y < src.height; ++y) {
    for (var x = 0; x < src.width; ++x) {
      final height = src.getPixel(x, y).r / mx;
      var du = (height -
              src.getPixel(x < src.width - 1 ? x + 1 : x, y).r / mx) *
              strength;
      var dv = (height -
              src.getPixel(x, y < src.height - 1 ? y + 1 : y).r / mx) *
              strength;
      final z = du.abs() + dv.abs();

      if (z > 1) {
        du /= z;
        dv /= z;
      }

      final dw = sqrt(1.0 - du * du - dv * dv);
      final nX = du * 0.5 + 0.5;
      final nY = dv * 0.5 + 0.5;
      final nZ = dw;

      dest.setPixelColor(x, y, nX * mx, nY * mx, nZ * mx);
    }
  }

  return dest;
}
