import 'package:flutter/material.dart';
import '../screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../screens/place_detail_screen.dart';
import '../screens/setting_screen.dart';

class PlacesListScreen extends StatelessWidget {
  static const String routeName = 'places_list_screen';

  Future<bool> _onWillPop(BuildContext context) {
    print('action...');
    return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Do you really want to exit the app ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed(SettingScreen.routeName);
          },
        ),
        appBar: AppBar(
          title: Text('Your Places'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                })
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (ctx, index) {
                                var place = greatPlaces.items[index];
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(place.image),
                                    ),
                                    title: Text(place.title),
                                    subtitle: Text(place.location.address),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          PlaceDetailScreen.routeName,
                                          arguments: place);
                                    },
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        onPressed: () async {
                                          return showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                    title: Text('Delete Place'),
                                                    content: Text(
                                                        'Do you really want to detele this place ?'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('No'),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await Provider.of<
                                                                      GreatPlaces>(
                                                                  context,
                                                                  listen: false)
                                                              .deletePlace(
                                                                  place.title);
                                                        },
                                                        child: Text('Yes'),
                                                      )
                                                    ],
                                                  ));
                                        }),
                                  ),
                                );
                              }),
                  child: Center(
                    child: Text('No places, start adding some'),
                  ),
                ),
        ),
      ),
    );
  }
}
