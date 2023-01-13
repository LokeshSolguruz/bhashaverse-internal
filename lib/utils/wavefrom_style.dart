import 'package:audio_waveforms/audio_waveforms.dart';
import 'theme/app_colors.dart';

class WaveformStyle {
  PlayerWaveStyle defaultPlayerStyle = PlayerWaveStyle(
      fixedWaveColor: primaryColor.withOpacity(0.3),
      liveWaveColor: primaryColor,
      scaleFactor: 70,
      waveThickness: 2);
}
