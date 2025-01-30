// Importing necessary packages
import 'dart:io'; // For platform detection
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:get/get.dart'; // GetX package for state management and routing
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package for custom fonts
import 'package:neo_crypto/dashboard/view/dashboard.dart'; // Importing the dashboard page
import 'package:toastification/toastification.dart'; // Toast notifications package
import 'package:window_manager/window_manager.dart'; // Window management package

// Function to check if the platform is mobile
bool get isMobile => Platform.isAndroid || Platform.isIOS;

// Main function to run the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
  // If the platform is not mobile, initialize the window manager
  if(!isMobile){
    await windowManager.ensureInitialized(); // Ensure window manager is initialized
    const WindowOptions windowOptions = WindowOptions(
      size: Size(800, 500), // Set window size
      backgroundColor: Colors.transparent, // Set background color
      titleBarStyle: TitleBarStyle.hidden, // Hide title bar
    );

    // Wait until the window is ready to show
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setSize(const Size(800, 500)); // Set window size
      await windowManager.setMinimumSize(const Size(800, 500)); // Set minimum size
      await windowManager.setMaximumSize(const Size(800, 500)); // Set maximum size
      await windowManager.center(); // Center the window
      await windowManager.show(); // Show the window
      await windowManager.focus(); // Focus on the window
    });
  }

  runApp(const MyApp()); // Run the MyApp widget
}

// MyApp class which is the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Building the app with Toastification and GetMaterialApp
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false, // Disable debug banner
        title: 'Neo Crypto', // App title
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(), // Custom text theme
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3935FF)), // Color scheme
          useMaterial3: true, // Use Material 3 design
        ),
        home:  DashboardPage(), // Set the home page to DashboardPage
      ),
    );
  }
}
