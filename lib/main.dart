import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PermissionWidget(),
    );
  }
}

class PermissionWidget extends StatefulWidget {
  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  PermissionStatus _microphonePermissionStatus = PermissionStatus.undetermined;
  PermissionStatus _storagePermissionStatus = PermissionStatus.undetermined;
  bool gotMicPerms = false;
  bool gotStoragePerms = false;

  @override
  void initState() {
    super.initState();

    _listenForMicrophonePermissionStatus();
    _listenForStoragePermissionStatus();
  }

  void _listenForMicrophonePermissionStatus() async {
    final status = await Permission.microphone.status;
    setState(() {
      _microphonePermissionStatus = status;
      if (status == PermissionStatus.granted) {
        gotMicPerms = true;
      }
    });
  }

  void _listenForStoragePermissionStatus() async {
    final status = await Permission.storage.status;
    setState(() {
      _storagePermissionStatus = status;
      if (status == PermissionStatus.granted) {
        gotStoragePerms = true;
      }
    });
  }


  String recImage() {
    String denied = "assets/recgrey.png";
    String granted = "assets/rec.png";
    if (_microphonePermissionStatus == _storagePermissionStatus) {
      switch (_microphonePermissionStatus) {
        case PermissionStatus.denied:
          return denied;
        case PermissionStatus.granted:
          return granted;
        default:
          return denied;
      }
    }
    return denied;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FlatButton(
          onPressed: () {
            requestPermission();
          },
          child: Image.asset(recImage()),
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    setState(() {
      _microphonePermissionStatus = statuses[Permission.microphone];
      _storagePermissionStatus = statuses[Permission.storage];
    });
  }
}
