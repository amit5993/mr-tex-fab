import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td/utils/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import 'dart:io' show Platform;

class PreLogin extends StatefulWidget {
  const PreLogin({super.key});

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  final String instagramUrl = 'https://www.instagram.com/m.r.texfab?igsh=MXR6cm10NHY1NmQxdA%3D%3D&utm_source=qr';
  final String facebookUrl = 'https://www.facebook.com/mrtex.fab?mibextid=ZbWKwL';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: colorApp, // Set status bar color to blue
      statusBarIconBrightness: Brightness.light, // Set status bar icons to light color
    ));
  }

  void _openMap() async {
    // Location coordinates
    double latitude = 21.185722;
    double longitude = 72.835472;

    String url;

    // Use platform-specific map URLs for best experience
    if (Platform.isIOS) {
      // Apple Maps URL format for iOS
      url = 'https://maps.apple.com/?q=$latitude,$longitude';
    } else {
      // Google Maps URL format for Android and others
      url = 'https://maps.google.com/?q=$latitude,$longitude';
    }

    try {
      // Launch URL with explicit external application mode
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        // Show error if launch fails
        Get.snackbar(
          'Error',
          'Could not open map',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions
      print('Error opening map: $e');
      Get.snackbar(
        'Error',
        'Could not open map: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Direct phone call function
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      print('Could not launch $phoneUri: $e');
    }
  }

  Future<void> _makeWhatsapp(String phone) async {
    String url = '';

    if (Platform.isAndroid) {
      url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull('Hello')}";
    } else {
      url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull('Hello')}";
    }
    await launchUrl(Uri.parse(url));
  }

  void _openSocialMedia(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        Get.snackbar(
          'Error',
          'Could not open link',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error opening social media: $e');
      Get.snackbar(
        'Error',
        'Could not open link',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                // Blue background that extends down
                Container(
                  color: colorApp,
                  height: 350, // Extend the blue background to overlap with the card
                  width: double.infinity,
                ),

                // Content column
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      verticalViewBig(),
                      // Logo and description section
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder: appIcon,
                                  image: appIcon,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(appIcon);
                                  },
                                ),
                              ),
                            ),

                            verticalViewBig(),
                            // Text descriptions
                            Text(
                              'Cloth Merchant & Commison Agent',
                              style: bodyText4(colorWhite),
                            ),
                            verticalViewSmall(),
                            Text(
                              'Deals in Sarees, Suits, Lahenga & Kurtis',
                              style: heading3(colorWhite),
                            ),
                          ],
                        ),
                      ),

                      // Address and contact section - with curved top corners
                      Container(
                        //margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on, color: colorApp, size: 24),
                                horizontalView(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'C-530, 5th Floor, Elbee Apartments,',
                                        style: bodyText4(colorApp),
                                      ),
                                      Text(
                                        'Ring Road, Surat - 395003,',
                                        style: bodyText4(colorApp),
                                      ),
                                      Text(
                                        'Gujarat, India',
                                        style: bodyText4(colorApp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            verticalView(),

                            // View on map button
                            Container(
                              margin: const EdgeInsets.only(left: 30),
                              child: ElevatedButton(
                                onPressed: _openMap,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorApp,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'VIEW ON MAP',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            verticalView(),
                            // Phone number - now clickable
                            InkWell(
                              onTap: () => _makePhoneCall('02613542615'),
                              child: Row(
                                children: [
                                  Icon(Icons.phone, color: colorApp, size: 24),
                                  SizedBox(width: 15),
                                  Text(
                                    '0261-3542615',
                                    style: bodyText4(colorApp),
                                  ),
                                ],
                              ),
                            ),

                            verticalViewSmall(),

                            // WhatsApp number - now clickable
                            InkWell(
                              onTap: () => _makeWhatsapp('9316678026'),
                              child: Row(
                                children: [
                                  Image.asset(
                                    icWhatsapp,
                                    width: 24,
                                    height: 24,
                                    color: colorApp,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '93166 78026',
                                    style: bodyText4(colorApp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Contact with Us section
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact with Us:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: colorApp,
                              ),
                            ),
                            verticalViewSmall(),

                            // Social media icons - use actual social media icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => _openSocialMedia(facebookUrl),
                                  child: _socialButton(Icons.facebook, colorApp),
                                ),
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () => _openSocialMedia(instagramUrl),
                                  child: _socialButton(Icons.camera_alt, colorApp),
                                ), // Instagram
                                const SizedBox(width: 15),
                                _socialButton(Icons.flutter_dash, colorApp), // Twitter/X
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () => _makeWhatsapp('9316678026'),
                                  child: _socialButton(Icons.abc, colorApp),
                                ),
                                _socialButton(Icons.abc, colorApp), // WhatsApp - fixed icon
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Navigation buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _navButton(Icons.people, 'About us'),
                                _navButton(Icons.handshake, 'Suppliers'),
                                _navButton(Icons.location_city, 'Cities'),
                                _navButton(Icons.image, 'Gallery'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      verticalViewBig(),

                      // Login button
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorApp,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'LOGIN IN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _navButton(IconData icon, String label) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          verticalViewSmall(),
          Icon(
            icon,
            color: colorApp,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: bodyText1(colorApp),
          ),
        ],
      ),
    );
  }
}
