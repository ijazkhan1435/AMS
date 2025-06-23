
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const MethodChannel _channel = MethodChannel('rfid');

  String assetTagID = "";
  double rssiValue = -100;
  String trackingStatus = "Not Started";

  @override
  void initState() {
    super.initState();

    List<dynamic> args = Get.arguments ?? [];
    if (args.isNotEmpty && args.length >= 2) {
      assetTagID = args[0].toString();
    } else {
      assetTagID = "Unknown";
    }

    listenForRSSIUpdates();
    startLocating();
  }

  Future<void> startLocating() async {
    try {
      final result = await _channel.invokeMethod(
          'startLocating',
          {"tagId": assetTagID, "range": 1}
      );

      setState(() {
        trackingStatus = result;
      });

    } catch (e) {
      showToast("Error: $e");
      setState(() {
        trackingStatus = "Error: $e";
      });
    }
  }

  void listenForRSSIUpdates() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onTagLocated") {
        double newRssi = (-50 + (call.arguments % 50)).toDouble();

        setState(() {
          rssiValue = newRssi;
        });

        showToast("RSSI Updated: $newRssi");
      }
    });
  }

  @override
  void dispose() {
    _channel.invokeMethod('stopLocating');
    showToast("Tracking Stopped");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locate Asset")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tracking Asset: $assetTagID", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Status: $trackingStatus",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 20),

            /// **Circular RSSI Indicator**
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: (rssiValue + 100) / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getColorForRSSI(rssiValue),
                    ),
                  ),
                ),
                Text(
                  "${rssiValue.toInt()} dBm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: fetchRSSI,
              child: Text("Update RSSI"),
            ),
          ],
        ),
      ),
    );
  }

  /// **RSSI Value ka Color Define**
  Color getColorForRSSI(double rssi) {
    if (rssi > -50) return Colors.green;
    if (rssi > -70) return Colors.orange;
    return Colors.red;
  }

  /// **RSSI Fetch karne ka Function**
  Future<void> fetchRSSI() async {
    try {
      final double? rssi = await _channel.invokeMethod('showRssi');
      if (rssi != null) {
        setState(() {
          rssiValue = rssi;
        });
        showToast("Updated RSSI: $rssi");
      }
    } catch (e) {
      showToast("Error Fetching RSSI");
    }
  }

  /// **Toast Message**
  void showToast(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}







