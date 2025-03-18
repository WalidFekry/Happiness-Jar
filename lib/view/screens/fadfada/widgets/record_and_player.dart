import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/view/screens/fadfada/view_model/fadfada_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../helpers/spacing.dart';

class RecordAndPlayerWidget extends StatelessWidget {
  const RecordAndPlayerWidget({super.key, required this.viewModel});

  final FadfadaViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return viewModel.isRecording
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AudioWaveforms(
                      enableGesture: true,
                      size: Size(MediaQuery.of(context).size.width * 0.6, 50),
                      recorderController: viewModel.recorderController,
                      waveStyle: WaveStyle(
                        waveColor: Theme.of(context).iconTheme.color!,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        viewModel.isPaused ? Icons.play_arrow : Icons.pause,
                        color: Theme.of(context).iconTheme.color,
                        size: 30),
                    onPressed: () async {
                      if (viewModel.isPaused) {
                        await viewModel.resumeRecording();
                      } else {
                        await viewModel.pauseRecording();
                      }
                    },
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.delete_forever, color: Theme.of(context).cardColor, size: 30),
                    onPressed: () => viewModel.stopRecording(save: false),
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Theme.of(context).unselectedWidgetColor, size: 30),
                    onPressed: () => viewModel.stopRecording(save: true),
                  ),
                ],
              ),
            ),
          )
        : viewModel.audioPath != null
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Theme.of(context).iconTheme.color,
                          size: 30,
                        ),
                        onPressed: () async {
                          if (viewModel.isPlaying) {
                            await viewModel.pauseAudio();
                          } else {
                            await viewModel.playAudio();
                          }
                        },
                      ),
                      Expanded(
                        child: AudioFileWaveforms(
                          size:
                              Size(MediaQuery.of(context).size.width * 0.6, 40),
                          playerController: viewModel.player,
                          waveformType: WaveformType.long,
                          playerWaveStyle: PlayerWaveStyle(
                            liveWaveColor: Theme.of(context).iconTheme.color!,
                            fixedWaveColor: Colors.blueGrey,
                            spacing: 4,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 30),
                        onPressed: () => viewModel.deleteAudio(),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => viewModel.startRecording(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ContentTextWidget(
                      label: "لا تحتاج للكتابة؟ سجّل صوتك الآن! 🔊",
                      fontSize: 14,
                    ),
                    horizontalSpace(10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).iconTheme.color,
                      child:
                          const Icon(Icons.mic, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              );
  }
}
