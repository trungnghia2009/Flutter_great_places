import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../helper/location_helper.dart';
import 'dart:math';
import '../screens/map_screen.dart';
import '../models/place.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImage;
  var _zoom = 16.0;
  String _address;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locationData = await Location().getLocation();
      final pickedAddress = await LocationHelper.getPlaceAddress(
          locationData.latitude, locationData.longitude);
      setState(() {
        _previewImage = LocationHelper.generateLocationReviewImage(
          lat: locationData.latitude,
          long: locationData.longitude,
        );
        _address = pickedAddress;
      });
      widget.onSelectPlace(PlaceLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          address: _address));
    } catch (error) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Something\'s wrong'),
                content: Text('There is no permission to get location'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  )
                ],
              ));
    }
  }

  // TODO: Callback data, using await key to wait data from pop
  Future<void> _selectMap() async {
    final locationData = await Location().getLocation();
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
          initialLocation: PlaceLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
          ),
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    final pickedAddress = await LocationHelper.getPlaceAddress(
        selectedLocation.latitude, selectedLocation.longitude);

    setState(() {
      _previewImage = LocationHelper.generateLocationReviewImage(
        lat: selectedLocation.latitude,
        long: selectedLocation.longitude,
      );
      _address = pickedAddress;
    });
    widget.onSelectPlace(PlaceLocation(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: _address));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _previewImage == null
              ? Center(
                  child: Text('No Location chosen'),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    _previewImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
        _address != null
            ? Text(
                'Address: $_address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SizedBox(
                height: 10,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {
                _getCurrentUserLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).buttonColor,
            ),
            FlatButton.icon(
              onPressed: _selectMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).buttonColor,
            ),
          ],
        )
      ],
    );
  }
}

//_previewImage != null
//? Positioned(
//right: -(deviceSize.width * 0.50),
//child: Container(
//width: 170,
//transform: Matrix4.identity()..rotateZ(90 * pi / 180),
//child: Slider(
//divisions: 8,
//value: _zoom.toDouble(),
//min: 12.0,
//max: 20.0,
//onChanged: (double newValue) {
//setState(() {
//_zoom = newValue;
//_getCurrentUserLocation();
//});
//print(_zoom);
//},
//),
//),
//)
//: Container(),
