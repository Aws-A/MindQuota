import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

Future<Uint8List?> cropImageIfNeeded(String assetPath) async {
  // Load image bytes from assets
  ByteData data = await rootBundle.load(assetPath);
  Uint8List imageBytes = data.buffer.asUint8List();

  // Decode image to get its width and height
  ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  ui.Image image = frameInfo.image;

  int width = image.width;
  int height = image.height;

  // If height is greater than width, crop the height to 2/3 of the width
  if (height > width) {
    // Calculate new height to be 2/3 of the width
    int newHeight = (width * 2) ~/ 3;

    // Calculate how much to crop from the top and bottom to center the crop
    int topCrop = (height - newHeight) ~/ 2;

    // Adjust the top crop if it's negative
    topCrop = topCrop < 0 ? 0 : topCrop;

    // Create the cropped image with the new height
    ui.Image croppedImage = await _cropImage(image, 0, topCrop, width, newHeight);

    // Convert cropped image to byte data
    ByteData? byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? croppedBytes = byteData?.buffer.asUint8List();

    return croppedBytes;
  }

  // Return the original image bytes if no cropping is needed
  return imageBytes;
}

// Helper function to crop the image
Future<ui.Image> _cropImage(ui.Image image, int left, int top, int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(width.toDouble(), height.toDouble())));

  // Paint object to draw the image
  final paint = ui.Paint();

  // Draw the image on the canvas, cropping the part we want
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(left.toDouble(), top.toDouble(), width.toDouble(), height.toDouble()), // Source rectangle (cropped area)
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), // Destination rectangle (canvas size)
    paint,
  );

  // End the picture recording and return the cropped image
  final picture = recorder.endRecording();
  return picture.toImage(width, height);
}