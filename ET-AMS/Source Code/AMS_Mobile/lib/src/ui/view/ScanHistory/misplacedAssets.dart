// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/src/ui/view/ScanHistory/bottombar.dart';
// class Misplaced extends StatefulWidget {
//   const Misplaced({super.key});
//
//   @override
//   State<Misplaced> createState() => _MisplacedState();
// }
//
// class _MisplacedState extends State<Misplaced> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text('Misplaced Assets',),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.all(0.0), // Adjust padding as needed
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children:const [
//                       Icon(Icons.lightbulb, color: Colors.yellow),
//                       SizedBox(width: 8), // Add space between Icon and Text
//                       Expanded(child: Text('List of assets that do not belong in this Site or location')),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15,),
//
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   children:const [
//                     Text('Result:',style: TextStyle(fontWeight: FontWeight.bold),),
//                     SizedBox(width: 5,),
//                     Text('0 Assets',style: TextStyle(color: Colors.grey),),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Center(child: Text('There are not misplaced assets present in the selected Site or location ',
//               style: TextStyle(fontSize: 15),)),
//           )
//         ],
//       ),
//       bottomNavigationBar: historyBottom(2),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/foundAssetsController.dart';
import '../../../controllers/misplaced_controller.dart';
import 'bottombar.dart';

class Misplaced extends StatelessWidget {
  final MisplacedController controller = Get.put(MisplacedController());
  final FoundAssetsController foundController = Get.find<FoundAssetsController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.setMissingAssets(foundController.getMisplacedAssets());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Misplaced Assets'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            // padding: EdgeInsets.all(0.0),
            child: Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.yellow),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'List of assets that are Notfound in the selected Site or Location.')),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.misplaced.isEmpty
                ? Center(child: Container(
              width: Get.width *0.9,
                child: const Text('There are not misplaced assets present in the selected Site and Location.')))
                : ListView.builder(
              itemCount: controller.misplaced.length,
              itemBuilder: (context, index) {
                final asset = controller.misplaced[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Tag ID: ${asset['assetTagID']}'),
                    leading: const Icon(Icons.error, color: Colors.yellow),
                  ),
                );
              },
            )),
          ),
        ],
      ),
      bottomNavigationBar: historyBottom(2),
    );
  }
}


