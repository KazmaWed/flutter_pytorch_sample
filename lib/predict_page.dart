import 'dart:io';
import 'package:flutter/material.dart';
import 'predict_page_controller.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  late PredictPageController pageController;
  @override
  void initState() {
    super.initState();
    // コントローラー初期化
    pageController = PredictPageController(setState: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PyTorch Sample'),
      ),
      body: Stack(
        children: [
          // 画像＆ラベル
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // プレイスホルダー
                        if (pageController.xFile == null)
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              alignment: Alignment.center,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: const Text('Pick an image...'),
                            ),
                          ),
                        // 画像
                        if (pageController.xFile != null)
                          Image.file(File(pageController.xFile!.path)),
                        // 推論結果
                        if (pageController.label != null)
                          Text(pageController.label!),
                      ],
                    ),
                  ),
                ),
              ),
              // ボタン
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(12),
                child: SafeArea(
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: pageController.clear,
                        child: const Text('Clear'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: pageController.pickImage,
                          child: const Text('Image Classification'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // プログレス表示
          if (pageController.busy)
            Container(
              alignment: Alignment.center,
              color: Colors.black45,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
