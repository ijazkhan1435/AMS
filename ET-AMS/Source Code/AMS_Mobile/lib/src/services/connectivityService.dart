
import 'package:flutter_application_1/src/utils/helpers/api_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConnectivityService extends GetxService {
  RxBool ServerStatus = false.obs;
  RxBool DatabaseStatus = false.obs;

  connectivityCheck() async {
    ServerStatus.value = false;
    DatabaseStatus.value = false;

    try {
      dynamic ServerRes = await apiFetcher(
        'Get',
        '/api/Dashboard/ServerConnectivity',
      );
      // if (ServerRes != null && ServerRes['server_accessible'] != null) {
      //   ServerStatus.value = ServerRes['server_accessible']}
      if( ServerRes['status']== 'Success' ) {
        ServerStatus.value = true;
      }
    } catch (e) {
      print("Server connectivity error: $e");
    }

    try {
      dynamic DbRes = await apiFetcher(
        'Get',
        '/api/Dashboard/DbStatus',
      );
      // var a=DbRes['status'];
      // print(a);
      if( DbRes['status']== 'Success' ) {
        DatabaseStatus.value = true;
      }
    } catch (e) {
      print("Database connectivity error: $e");
    }
  }
}
