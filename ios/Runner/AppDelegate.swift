import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  // クラス分類モデルのロード
  private lazy var module: TorchModule = {
    if let filePath = Bundle.main.path(forResource: "model", ofType: "pt"),
        let module = TorchModule(fileAtPath: filePath) {
        return module
    } else {
        fatalError("Can't find the model file!")
    }
  }()
  // クラスラベルのロード
  private lazy var labels: [String] = {
    if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
        let labels = try? String(contentsOfFile: filePath) {
        return labels.components(separatedBy: .newlines)
    } else {
        fatalError("Can't find the text file!")
    }
  }()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Flutterメソッドチャンネル
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "Channel", binaryMessenger: controller as! FlutterBinaryMessenger)
    
    methodChannel.setMethodCallHandler({
      (call:FlutterMethodCall, result:FlutterResult) -> Void in

      let arguments = call.arguments as? [String: Any]
      
      switch call.method {
      case "classify" :
        result(Classify(arguments))
      default :
        result(nil)
      }
    })

    // 画像分類
    func Classify(_ arguments: [String: Any]?) -> String {
      let imagePath: String? = arguments?["imagePath"] as? String
      if imagePath != nil {
        let image = UIImage(named: imagePath!)!
        let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
        guard var pixelBuffer = resizedImage.normalized() else {
            return "Error 3"
        }
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
            return "Error 2"
        }
        let zippedResults = zip(labels.indices, outputs)

        // 上位3件を取得
        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(3)
        // 出力テキスト
        var text = ""
        for result in sortedResults {
          text += "\(labels[result.0])\n"
        }
        return text
      } else {
        return "Error 1"
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
