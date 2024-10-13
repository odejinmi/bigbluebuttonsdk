import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'native/virtual_background/index.dart';
import 'strings.dart';

class Virtualbackgroundviews extends StatelessWidget {
  Virtualbackgroundviews({Key? key}) : super(key: key);

  // List<String> get backgroundAssets =>
  //     SizerUtil.isDesktop ? desktopBackgrounds : backgrounds;
  List<String> get backgroundAssets => backgrounds;
  String? _currentBackground;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Strings.virtualBackground.i18n"),
        actions: [
          IconButton(
            onPressed: () {
              Future.microtask(() async {
                final ByteData bytes = await rootBundle.load(
                  _currentBackground!,
                );
                final Uint8List backgroundBuffer = bytes.buffer.asUint8List();

                final MediaStream? segmentedStream = await startVirtualBackground(
                  backgroundImage: backgroundBuffer,
                  textureId: "_mParticipant?.cameraSource?.textureId.toString()",
                );

                if (segmentedStream == null) return;

                _replaceVideoTrack(segmentedStream.getVideoTracks().first);
                startVirtualBackground(
                backgroundImage: backgroundBuffer,

                );
              });
              // AppBloc.meetingBloc.add(
              //   ApplyVirtualBackgroundEvent(_currentBackground),
              // );
              // AppNavigator.pop();
            },
            icon: Icon(
              Icons.check,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 0.66,
        ),
        itemCount: backgroundAssets.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                  _currentBackground = null;
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: _currentBackground == null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.block,
                  size: 20,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            );
          }

          return InkWell(
            onTap: () {
                _currentBackground = backgroundAssets[index - 1];
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: _currentBackground == backgroundAssets[index - 1]
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Image.asset(
                backgroundAssets[index - 1],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _replaceVideoTrack(
      MediaStreamTrack track, {
        List<RTCRtpSender>? sendersList,
      }) async {
    // final List<RTCRtpSender> senders =
    // (sendersList ?? await _mParticipant!.peerConnection.getSenders())
    //     .where(
    //       (sender) => sender.track?.kind == 'video',
    // )
    //     .toList();
    //
    // if (senders.isEmpty) return;
    //
    // final sender = senders.first;
    //
    // sender.replaceTrack(track);

    // await _enableEncryption(_callSetting.e2eeEnabled);
  }
}
