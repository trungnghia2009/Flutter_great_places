import 'package:flutter/foundation.dart';
import '../models/place.dart';
import 'dart:io';
import '../helper/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: pickedLocation,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    // TODO: The keys use here have to match the fields that you set up in the CREATE TABLE
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_long': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> deletePlace(String title) async {
    final dataList = await DBHelper.get('user_places');
    await DBHelper.delete(title);
    final itemIndex = _items.indexWhere((item) => item.title == title);
    _items.removeAt(itemIndex);
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.get('user_places');
//    await Future.delayed(Duration(seconds: 1));
    final db = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_long'],
                address: item['address'],
              ),
              image: File(item['image']),
            ))
        .toList();
    _items = db;
    notifyListeners();
  }
}
