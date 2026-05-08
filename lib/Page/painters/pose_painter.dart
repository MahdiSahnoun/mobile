import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final bool isFrontCamera;
  final Color color; // New parameter

  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.color, // Required color
    this.isFrontCamera = true,
  });

  Paint get _jointPaint => Paint()
    ..color = color
    ..strokeWidth = 10
    ..style = PaintingStyle.fill;

  Paint get _bonePaint => Paint()
    ..color = color.withOpacity(0.8)
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke;

  // Define which landmarks to connect (bones)
  static const _connections = [
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
    [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
    [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final pose in poses) {
      // Draw bones
      for (final connection in _connections) {
        final p1 = pose.landmarks[connection[0]];
        final p2 = pose.landmarks[connection[1]];
        if (p1 != null && p2 != null) {
          canvas.drawLine(
            _scale(p1, size),
            _scale(p2, size),
            _bonePaint,
          );
        }
      }

      // Draw joints
      for (final landmark in pose.landmarks.values) {
        canvas.drawCircle(_scale(landmark, size), 6, _jointPaint);
      }
    }
  }

  Offset _scale(PoseLandmark landmark, Size canvasSize) {
    final double x = landmark.x * canvasSize.width / imageSize.width;
    final double y = landmark.y * canvasSize.height / imageSize.height;

    // Si c'est la caméra frontale, on inverse l'axe X (effet miroir)
    return Offset(isFrontCamera ? canvasSize.width - x : x, y);
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}
