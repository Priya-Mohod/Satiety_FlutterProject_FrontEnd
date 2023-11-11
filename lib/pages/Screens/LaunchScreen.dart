import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Screens/LoginScreen.dart';
import 'package:satietyfrontend/pages/Screens/VerifyOTPScreen.dart';
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
    // _videoPlayerController =
    //     VideoPlayerController.asset('assets/SatietyAd.mp4');
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowMuting: false,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
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
}
