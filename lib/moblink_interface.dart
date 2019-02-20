import 'dart:async';

import 'package:flutter/services.dart';

import 'package:moblink/moblink_defines.dart';

class Moblink {
  static const MethodChannel _channel =
      const MethodChannel('com.yoozoo.mob/moblink');

  static Future<dynamic> getMobId(MLSDKScene scene, Function(String mobid, String domain, MLSDKError error) result)  {
    
    Map args = {"path": scene.path, "params": scene.params};

    Future<dynamic> callback = _channel.invokeMethod(MobLinkMethods.getMobId.name, args);

    callback.then((dynamic response) {
      if (result != null) {
        result(response["mobid"], 
              response["domain"], 
              MLSDKError(rawData: response["error"]));
      }
    });
    return callback;
  }

  static Future<dynamic> restoreScene(Function(MLSDKScene scene) result) {

    Future<dynamic> callback = _channel.invokeMethod(MobLinkMethods.restoreScene.name);
    
    callback.then((dynamic response) {
      if (result != null) {
        MLSDKScene scenes = new MLSDKScene(response["path"], response["params"]);
        scenes.mobid = response["mobid"];
        scenes.className = response["className"];
        scenes.rawURL = response["rawURL"];
        result(scenes);
      }
    });
    return callback;
  }
}

class MLSDKScene {

  // path (required)
  String path;
  // custom parameter (Optional)
  Map params;

  // mobid（Readonly）
  String mobid;
  // class name of the corresponding path（Readonly）
  String className;
  // original link（Readonly）
  String rawURL;

  // create scene
  MLSDKScene(this.path, this.params);

}