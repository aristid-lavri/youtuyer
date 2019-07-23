import 'dart:async';
import 'package:flutter/services.dart';
import 'package:youtuyer/you_tube_player_listener.dart';
import 'package:youtuyer/youtuyer.dart';

class FlutterYoutubeViewController {
  final MethodChannel _channel;
  final YouTubePlayerListener _listener;

  FlutterYoutubeViewController.of(int id, YouTubePlayerListener listener)
      : _channel = new MethodChannel('plugins.hoanglm.com/youtube_$id'),
        _listener = listener {
    if (_listener != null) {
      _channel.setMethodCallHandler(handleEvent);
    }
  }

  Future<void> initialization() async {
    await _channel.invokeMethod('initialization');
  }

  Future<void> loadOrCueVideo(String videoId, double startSeconds) async {
    assert(videoId != null);
    var params = <String, dynamic>{
      "videoId": videoId,
      "startSeconds": startSeconds
    };
    await _channel.invokeMethod('loadOrCueVideo', params);
  }

  Future<void> play() async {
    await _channel.invokeMethod('play', null);
  }

  Future<void> pause() async {
    await _channel.invokeMethod('pause', null);
  }

  Future<void> seekTo(double time) async {
    await _channel.invokeMethod('seekTo', time);
  }

  Future<void> setVolume(int volumePercent) async {
    await _channel.invokeMethod('setVolume', volumePercent);
  }

  Future<void> setMute() async {
    await _channel.invokeMethod('mute', null);
  }

  Future<void> setUnMute() async {
    await _channel.invokeMethod('unMute', null);
  }

  Future<void> changeScaleMode(YoutubeScaleMode mode) async {
    await _channel.invokeMethod('scaleMode', mode.index);
  }

  Future<dynamic> handleEvent(MethodCall call) async {
    switch (call.method) {
      case 'onReady':
        _listener.onReady();
        break;
      case 'onStateChange':
        _listener.onStateChange(call.arguments as String);
        break;
      case 'onError':
        _listener.onError(call.arguments as String);
        break;
      case 'onVideoDuration':
        _listener.onVideoDuration(call.arguments as double);
        break;
      case 'onCurrentSecond':
        _listener.onCurrentSecond(call.arguments as double);
        break;
    }
    return null;
  }
}
