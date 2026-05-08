import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ExerciseCounterService {
  int _repCount = 0;
  bool _isDown = false; // Tracks squat "down" position

  int countSquatReps(Pose pose) {
    final leftHip   = pose.landmarks[PoseLandmarkType.leftHip];
    final leftKnee  = pose.landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (leftHip == null || leftKnee == null || leftAnkle == null) {
      return _repCount;
    }

    final angle = _calculateAngle(leftHip, leftKnee, leftAnkle);

    // Down position: knee angle < 90°
    if (angle < 90 && !_isDown) {
      _isDown = true;
    }

    // Up position: knee angle > 160° → rep completed
    if (angle > 160 && _isDown) {
      _isDown = false;
      _repCount++;
    }

    return _repCount;
  }

  double _calculateAngle(
    PoseLandmark a, PoseLandmark b, PoseLandmark c,
  ) {
    // Angle at point B (knee), between A (hip) and C (ankle)
    final radians = atan2(c.y - b.y, c.x - b.x) -
                    atan2(a.y - b.y, a.x - b.x);
    double angle = radians * 180 / pi;
    if (angle < 0) angle += 360;
    if (angle > 180) angle = 360 - angle;
    return angle;
  }

  void reset() => _repCount = 0;
}
