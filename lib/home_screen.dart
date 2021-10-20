import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorking = false;
  String result = '';
  CameraController? _cameraController;
  CameraImage? imgCamera;

  void initCamera() {
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        _cameraController!.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    });
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/models/mobilenet_v1_1.0_224.txt',
    );
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      result = '';
      recognitions!.forEach((response) {
        result += response['label'] +
            ' ' +
            (response['confidence'] as double).toStringAsFixed(2) +
            '\n\n';
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
    _cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/jarvis.jpg'),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 320.0,
                          width: 360.0,
                          color: Colors.black,
                          child: Image.asset('assets/images/camera.jpg'),
                        ),
                      ),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            initCamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 35.0),
                            height: 270.0,
                            width: 360.0,
                            child: imgCamera == null
                                ? Container(
                                    height: 270.0,
                                    width: 360.0,
                                    child: const Icon(
                                      Icons.photo_camera_front,
                                      color: Colors.lightBlueAccent,
                                      size: 40.0,
                                    ),
                                  )
                                : AspectRatio(
                                    aspectRatio:
                                        _cameraController!.value.aspectRatio,
                                    child: CameraPreview(_cameraController!),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 55.0),
                      child: SingleChildScrollView(
                        child: Text(
                          result,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Lora',
                            color: Colors.redAccent,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
