import 'package:flutter/material.dart';
import '../models/place.dart';
import '../screens/map_screen.dart';
import '../helper/weather_helper.dart';
import '../providers/weather_place.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = 'place_detail_screen';
  @override
  Widget build(BuildContext context) {
    final placeData = ModalRoute.of(context).settings.arguments as Place;
    final locationData = placeData.location;

    return Scaffold(
        appBar: AppBar(
          title: Text(placeData.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.file(
                placeData.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                '${placeData.location.address}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: FutureBuilder(
                    future: Provider.of<WeatherPlace>(context, listen: false)
                        .fetchAndSetWeather(
                      locationData.latitude,
                      locationData.longitude,
                    ),
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Container(
                            child: SpinKitFadingCircle(
                              size: 80,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Consumer<WeatherPlace>(
                            builder: (ctx, currentWeather, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${currentWeather.weather.temperature}°',
                                      style: const TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      Provider.of<WeatherPlace>(context,
                                              listen: false)
                                          .getWeatherIcon(
                                              currentWeather.weather.condition),
                                      style: const TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    Provider.of<WeatherPlace>(context,
                                            listen: false)
                                        .getMessage(
                                            currentWeather.weather.temperature),
                                    style: const TextStyle(
                                      fontSize: 35,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) => MapScreen(
                          isSelecting: false,
                          initialLocation: placeData.location,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.map),
                  label: Text('View on map'),
                  textColor: Theme.of(context).buttonColor,
                ),
                FlatButton.icon(
                  textColor: Theme.of(context).buttonColor,
                  onPressed: () async {},
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh weather'),
                ),
              ],
            ),
          ],
        ));
  }
}
