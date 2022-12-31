import 'dart:convert';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/app_constants.dart';

class AudioPlayer {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

  File? _audioFile;
  Directory? appDocDir;
  String _ttsAudioFileName = '';

  void playAudioFromBase64(String base64Text) async {
    var fileAsBytes = base64Decode(base64Text);
    appDocDir = await getExternalStorageDirectory();
    _ttsAudioFileName = '${appDocDir!.path}/$defaultTTSPlayName';
    _audioFile = File(_ttsAudioFileName);
    if (_audioFile != null && !await _audioFile!.exists()) {
      await _audioFile!.writeAsBytes(fileAsBytes);
    }

    await _audioPlayer.openPlayer();
    await _audioPlayer.startPlayer(
        fromURI: _ttsAudioFileName,
        whenFinished: () {
          stopPlayback();
        });
  }

  void playAudioFromFile(String filePath) async {
    await _audioPlayer.openPlayer();
    await _audioPlayer.startPlayer(
        fromURI: filePath,
        whenFinished: () {
          stopPlayback();
        });
  }

  Future stopPlayback() async {
    await _audioPlayer.stopPlayer();
    _disposePlayer();
  }

  void deleteTTSFile() async {
    await _audioFile?.delete();
  }

  void _disposePlayer() {
    !_audioPlayer.isPlaying ? _audioPlayer.closePlayer() : null;
  }
}
