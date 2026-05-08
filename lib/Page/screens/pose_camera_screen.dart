import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../servives/pose_deection_service.dart';
import '../painters/pose_painter.dart';
import '../servives/exercice_counter_service.dart';

import '../servives/history_service.dart';

class PoseCameraScreen extends StatefulWidget {
  const PoseCameraScreen({super.key});

  @override
  State<PoseCameraScreen> createState() => _PoseCameraScreenState();
}

class _PoseCameraScreenState extends State<PoseCameraScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  int _cameraIndex = 0;
  
  final PoseDetectionService _poseService = PoseDetectionService();
  final ExerciseCounterService _counter = ExerciseCounterService();

  List<Pose> _poses = [];
  bool _isProcessing = false;
  int _repCount = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    // Trouver la caméra frontale par défaut
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == CameraLensDirection.front) {
        _cameraIndex = i;
        break;
      }
    }
    _startCamera();
  }

  Future<void> _startCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
    _cameraController!.startImageStream(_processFrame);
    if (mounted) setState(() {});
  }

  Future<void> _toggleCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _startCamera();
  }

  Future<void> _processFrame(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return;

      final poses = await _poseService.detectPoses(inputImage);

      if (mounted) {
        setState(() {
          _poses = poses;
          if (poses.isNotEmpty) {
            _repCount = _counter.countSquatReps(poses.first);
          }
        });
      }
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final camera = _cameras[_cameraIndex];
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'POSE ANALYSIS',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_ios_rounded, color: primaryColor),
            onPressed: _toggleCamera,
          ),
          const SizedBox(width: 10),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () async {
            final int duration = _startTime != null
                ? DateTime.now().difference(_startTime!).inMinutes
                : 0;
            await HistoryService().saveSession("Squats", _repCount, duration: duration);
            if (mounted) Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Camera preview and Skeleton
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.all(constraints.maxWidth * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: AspectRatio(
                      aspectRatio: 1 / _cameraController!.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_cameraController!),
                          if (_poses.isNotEmpty)
                            IgnorePointer(
                              child: CustomPaint(
                                painter: PosePainter(
                                  poses: _poses,
                                  imageSize: Size(
                                    _cameraController!.value.previewSize!.height,
                                    _cameraController!.value.previewSize!.width,
                                  ),
                                  color: primaryColor,
                                  isFrontCamera: _cameras[_cameraIndex].lensDirection == CameraLensDirection.front,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Rep counter UI
              Positioned(
                bottom: constraints.maxHeight * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.08,
                      vertical: constraints.maxHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: primaryColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, color: primaryColor, size: constraints.maxWidth * 0.07),
                        SizedBox(width: constraints.maxWidth * 0.04),
                        Text(
                          'REPS: ',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: constraints.maxWidth * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_repCount',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: constraints.maxWidth * 0.09,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseService.dispose();
    super.dispose();
  }
}
