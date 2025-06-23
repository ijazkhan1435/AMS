import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata/appImages.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void nextTab() {
    int nextIndex = (_tabController.index + 1) % _tabController.length;
    _tabController.animateTo(nextIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF3067A2),
          labelColor: Color(0xFF3067A2),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "About"),
            Tab(text: "Privacy"),
            Tab(text: "Contact"),
          ],
        ),
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: [
          // About Tab
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Get.height / 9),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/logos/about.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Asset Management System, your trusted partner in efficient asset tracking and management. Our app leverages the power of RFID technology to provide seamless, real-time tracking of assets in your organization. Whether you\'re managing equipment, tools, or other valuable assets, our solution offers an easy-to-use interface that simplifies asset tracking and enhances operational efficiency.\n\n'
                            'With RFID-enabled scanning, you can quickly identify, track, and verify the location of your assets, minimizing the risk of loss and ensuring accurate data. Our system is designed to work with both handheld RFID readers and mobile devices, providing flexibility for all types of asset management needs.\n\n',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Key Features:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Real-time tracking of assets\nRFID-based scanning for quick identification\nCustomizable asset categorization and location tracking\nUser-friendly interface for managing asset data\nReports and export options to keep track of assets efficiently\nAt Asset Management, we are committed to helping you streamline your asset management processes, saving time and improving accuracy. Our app is the perfect solution for businesses and organizations looking for a reliable and secure way to track and manage their assets.\n'
                              'Thank you for choosing Asset Management – where innovation meets efficiency.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImage.logo4,
                        height: Get.height / 12, width: Get.width / 15),
                    Text(
                      'EmergTech Pvt. Ltd.',
                      style: TextStyle(color: Color(0xFF3067A2)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Privacy Tab
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/logos/privacy.jpg',
                  width: Get.width,
                  ),
                  Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  Text(
                    'Your privacy is important to us. At EmergTech Pvt. Ltd., we ensure that your personal data is secure and never shared without your consent. Our app follows strict data protection standards.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Contact Tab
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logos/contact.jpg',
                  height: Get.height/3,
                  ),
                  Text('Contact Us',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text(
                    'For inquiries or support, please contact us at:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: support@emergtech.com\nPhone: +123 456 7890\nAddress: 1234 Tech Street, Innovation City',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: nextTab, // Calls the nextTab method to switch tabs
        backgroundColor: Colors.blue.shade200,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
