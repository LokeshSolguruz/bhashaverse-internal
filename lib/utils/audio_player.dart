import 'dart:convert';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/app_constants.dart';

class AudioPlayer {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

  void playAudioFromBase64(String base64Text) async {
    var maleFileAsBytes = base64Decode(base64Text);
    Directory? appDocDir = await getExternalStorageDirectory();
    String maleTTSAudioFileName = '${appDocDir!.path}/$defaultTTSPlayName';
    final maleAudioFile = File(maleTTSAudioFileName);
    await maleAudioFile.writeAsBytes(maleFileAsBytes);

    await _audioPlayer.openPlayer();
    await _audioPlayer.startPlayer(
        fromURI: maleTTSAudioFileName,
        whenFinished: () {
          stopPlayback();
        });
  }

  Future stopPlayback() async {
    await _audioPlayer.stopPlayer();
    _disposePlayer();
  }

  void _disposePlayer() {
    !_audioPlayer.isPlaying ? _audioPlayer.closePlayer() : null;
  }
}
