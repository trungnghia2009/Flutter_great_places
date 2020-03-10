import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/place_detail_screen.dart';
import 'screens/places_list_screen.dart';
import 'screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import 'providers/great_places.dart';
import 'providers/weather_place.dart';
import 'providers/theme_notifier.dart';
import 'value/theme.dart';
import 'screens/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? false;
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GreatPlaces>(
              create: (ctx) => GreatPlaces(),
            ),
            ChangeNotifierProvider<WeatherPlace>(
              create: (ctx) => WeatherPlace(),
            ),
            ChangeNotifierProvider<ThemeNotifier>(
              create: (ctx) =>
                  ThemeNotifier(darkModeOn ? darkTheme : normalTheme),
            ),
          ],
          child: MyMaterialApp(),
        ),
      );
    });
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

// TODO: Do not use
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GreatPlaces>(
          create: (ctx) => GreatPlaces(),
        ),
        ChangeNotifierProvider<WeatherPlace>(
          create: (ctx) => WeatherPlace(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (ctx) => ThemeNotifier(normalTheme),
        ),
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      title: 'Creat Place',
      home: PlacesListScreen(),
      routes: {
        PlacesListScreen.routeName: (ctx) => PlacesListScreen(),
        AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
        PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        SettingScreen.routeName: (ctx) => SettingScreen(),
      },
    );
  }
}
