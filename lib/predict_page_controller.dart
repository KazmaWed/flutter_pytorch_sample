import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PredictPageController {
  final Function setState; // ページからsetState()を受け取る
  PredictPageController({required this.setState});

  final picker = ImagePicker();
  final channel = const MethodChannel('Channel');

  XFile? xFile; // 推論する画像ファイル
  String? label; // 推論結果
  var busy = false; // 推論中フラグ

  // 初期化
  void clear() {
    if (busy) return; // 処理中ガード
    xFile = null;
    label = null;
    setState();
  }

  // 画像選択
  Future<void> pickImage() async {
    if (busy) return; // 処理中ガード
    busy = true;

    // 画像選択
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // 無選択ガード
    if (pickedFile == null) {
      busy = false;
      return;
    }
    // 画像表示
    xFile = pickedFile;
    setState();
    // 推論
    await predict(pickedFile);

    busy = false;
  }

  // 推論
  Future<void> predict(XFile xFile) async {
    // Swiftで実装したメソッド呼び出し
    await channel.invokeMethod(
      'classify',
      {'imagePath': xFile.path},
    ).then((result) {
      // 推論結果表示
      label = result.toString();
      setState();
    });
  }
}
