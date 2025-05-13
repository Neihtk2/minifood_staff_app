import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Chọn ảnh từ gallery và tự động nén ảnh nếu chọn thành công.
/// Trả về [XFile] đã nén hoặc null nếu không chọn gì.
Future<XFile?> pickAndCompressImage() async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return null;

  final bytes = await pickedFile.readAsBytes();
  final originalImage = img.decodeImage(bytes);
  if (originalImage == null) return pickedFile;

  // Resize: max chiều rộng 800px, giữ nguyên tỉ lệ
  final resized = img.copyResize(originalImage, width: 600);

  // Encode lại dưới dạng JPEG với chất lượng 75%
  final compressedBytes = img.encodeJpg(resized, quality: 60);

  // Tạo file tạm để lưu ảnh nén
  final tempDir = await getTemporaryDirectory();
  final compressedPath =
      '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final compressedFile = File(compressedPath)
    ..writeAsBytesSync(compressedBytes);

  return XFile(compressedFile.path);
}
