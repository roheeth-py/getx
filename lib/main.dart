import "package:flutter/material.dart";
import "package:get/route_manager.dart";
import "package:google_fonts/google_fonts.dart";
import "package:myapp/features/main_screen/details_screen.dart";
import "package:myapp/features/main_screen/home_screen.dart";

import "utils.dart";

void main() async {
  await registerServices();
  await registerController();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Flutter Demo",
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      routes: {
        "/home": (context) => HomeScreen(),
        "/details": (context) => DetailsScreen(),
      },
      initialRoute: "/home",
    );
  }
}
