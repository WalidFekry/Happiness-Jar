import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../../../constants/app_colors.dart';
import '../../../widgets/custom_circular_progress_Indicator.dart';

class AudioWaveformPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioWaveformPlayerWidget({super.key, required this.audioPath});

  @override
  _AudioWaveformPlayerWidgetState createState() => _AudioWaveformPlayerWidgetState();
}

class _AudioWaveformPlayerWidgetState extends State<AudioWaveformPlayerWidget> {
  late PlayerController _playerController;
  bool isPlaying = false;
  List<double>? waveformData;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _loadWaveformData();
  }

  Future<void> _loadWaveformData() async {
    await _playerController.preparePlayer(path: widget.audioPath);
    _playerController.setFinishMode(finishMode: FinishMode.pause);
    _playerController.onCompletion.listen((_) {
      setState(() {
        isPlaying = !isPlaying;
      });
    });
    final data = await _playerController.extractWaveformData(
      path: widget.audioPath,
      noOfSamples: 100,
    );
    setState(() {
      waveformData = data;
    });
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.gray300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 32, color: Theme.of(context).iconTheme.color),
            onPressed: togglePlayPause,
          ),
          Expanded(
            child: waveformData == null
                ? const Center(child: CustomCircularProgressIndicator(visible: true,strokeWidth: 2.5,)) // عرض تحميل حتى يتم تجهيز الموجات
                : AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width * 0.6, 40),
              playerController: _playerController,
              waveformType: WaveformType.long,
              waveformData: waveformData!,
              playerWaveStyle: PlayerWaveStyle(
                liveWaveColor: Theme.of(context).iconTheme.color!,
                fixedWaveColor: Colors.blueGrey,
                spacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
