import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionService {
  late PoseDetector _poseDetector;

  PoseDetectionService() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream, // Real-time
      model: PoseDetectionModel.accurate, // or .fast
    );
    _poseDetector = PoseDetector(options: options);
  }

  Future<List<Pose>> detectPoses(InputImage inputImage) async {
    return await _poseDetector.processImage(inputImage);
  }

  void dispose() {
    _poseDetector.close();
  }
}
