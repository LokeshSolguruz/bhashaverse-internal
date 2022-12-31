import 'dart:convert';
import 'dart:io';

import 'package:bhashaverse/utils/snackbar_utils.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/app_constants.dart';

class VoiceRecorder {
  final FlutterSoundRecorder _audioRec = FlutterSoundRecorder();
  String appDocPath = "";
  String recordedAudioFileName = defaultAudioRecordingName;
  File? audioWavInputFile;
  String _speechToBase64 = '';

  Future<void> startRecordingVoice() async {
    await _audioRec.openRecorder();
    Directory? appDocDir = await getExternalStorageDirectory();
    appDocPath = appDocDir!.path;
    await _audioRec.startRecorder(
      toFile: '$appDocPath/$recordedAudioFileName',
    );
  }

  Future<String?> stopRecordingVoiceAndGetOutput() async {
    if (_audioRec.isRecording) {
      await _audioRec.stopRecorder();
      _disposeRecorder();
    }
    audioWavInputFile = File('$appDocPath/$recordedAudioFileName');
    if (audioWavInputFile != null && !await audioWavInputFile!.exists()) {
      showDefaultSnackbar(message: errorRetrievingRecordingFile);
      return null;
    }
    final bytes = audioWavInputFile?.readAsBytesSync();
    _speechToBase64 = base64Encode(bytes!);
    _disposeRecorder();
    return _speechToBase64;
  }

  String? getAudioFilePath() {
    return audioWavInputFile?.path;
  }

  void deleteRecordedFile() async {
    await audioWavInputFile?.delete();
  }

  void _disposeRecorder() {
    _audioRec.isRecording ? _audioRec.closeRecorder() : null;
  }
}
