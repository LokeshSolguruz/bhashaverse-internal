import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:mic_stream/mic_stream.dart';

class MicStreamer extends GetxService {
  late Rx<Int32List> micData = Int32List(0).obs;
  late StreamSubscription<Uint8List>? streamSub;
  int silenceSize = 20;

  startMicStreaming() async {
    MicStream.microphone(
            audioSource: AudioSource.DEFAULT,
            sampleRate: 44100,
            channelConfig: ChannelConfig.CHANNEL_IN_MONO,
            audioFormat: AudioFormat.ENCODING_PCM_16BIT)
        .then((value) {
      List<int> checkSilenceList = List.generate(silenceSize, (i) => 0);
      streamSub = value?.listen((value) {
        double meanSquared = meanSquare(value.buffer.asInt8List());

        micData.value = value.buffer.asInt32List();

        if (meanSquared >= 0.3) {
          checkSilenceList.add(0);
        }
        if (meanSquared < 0.3) {
          checkSilenceList.add(1);

          if (checkSilenceList.length > silenceSize) {
            checkSilenceList =
                checkSilenceList.sublist(checkSilenceList.length - silenceSize);
          }
          int sumValue =
              checkSilenceList.reduce((value, element) => value + element);
          if (sumValue == silenceSize) {
            micData.value = Int32List(0);
          }
        }
      });
    });
  }

  double meanSquare(Int8List value) {
    var sqrValue = 0;
    for (int indValue in value) {
      sqrValue = indValue * indValue;
    }
    return (sqrValue / value.length) * 1000;
  }

  void clearMicStream() async {
    await streamSub?.cancel();
    streamSub = null;
    micData.value = Int32List(0);
  }
}
