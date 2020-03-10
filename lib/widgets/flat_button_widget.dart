import 'package:flutter/material.dart';
import '../models/place.dart';
import '../screens/map_screen.dart';

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({
    Key key,
    @required this.placeData,
  }) : super(key: key);

  final Place placeData;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
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
      textColor: Theme.of(context).primaryColor,
    );
  }
}
