import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:camera/camera.dart';

abstract class ITTDCameraService {
  Future<String?> scan();
}

/*class TTDCameraService implements ITTDCameraService {
  TTDCameraService();

  @override
  Future<String?> scan() async {
    final scanResult = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: if()
      )
    );
    String? result = scanResult.rawContent;

    if (result == "") {
      result = null;
    }

    return result;
  }
}*/

class TTDCameraService implements ITTDCameraService {
  TTDCameraService() {
    _initializeCameras();
  }

  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
  }

  Future<void> setCamera(CameraLensDirection direction) async {
    selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == direction,
      orElse: () => selectedCamera,
    );
  }

  @override
  Future<String?> scan() async {
    final scanResult = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: cameras.indexOf(selectedCamera),
      ),
    );
    String? result = scanResult.rawContent;

    if (result.isEmpty) {
      result = null;
    }

    return result;
  }
}