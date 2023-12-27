import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LocationManager.dart';
import 'package:satietyfrontend/pages/Screens/login_phone_otp_screen.dart';
import 'package:satietyfrontend/pages/Screens/verify_phone_otp_screen.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://satiety-ad.s3.ap-south-1.amazonaws.com/trimmed-satiety-ad-removed-audio.mp4',
      ),
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      showControls: false,
      showControlsOnInitialize: false,
      showOptions: false,
      //aspectRatio: 16 / 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          Expanded(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                  text: 'Get Started',
                  buttonFont: 20,
                  onPressed: () {
                    _videoPlayerController.pause();
                    LocationManager.requestForUserPermission();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPhoneOTPScreen(
                            showSkipButton: true,
                          ),
                        ));
                  }),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _chewieController.play();
    }
  }
}
