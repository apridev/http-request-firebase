import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_request_firebase/model/player.dart';
import 'package:intl/intl.dart';

class Players with ChangeNotifier {
  final List<Player> _allPlayer = [];

  List<Player> get allPlayer => _allPlayer;
  // !Menghitung banyaknya data
  int get jumlahPlayer => _allPlayer.length;

  Player selectById(String id) =>
      _allPlayer.firstWhere((element) => element.id == id);

  // ? ADD DATA

  Future<void> addPlayer(
      String name, String position, String image, BuildContext context) {
    DateTime datetimeNow = DateTime.now();

    // ! Di Proses Pertama
    // print("SEBELUM HTTP");

    Uri url = Uri.parse(
        "https://http-request-883ec-default-rtdb.firebaseio.com/players.json");
   return http
        .post(url,
            body: json.encode({
              "name": name,
              "position": position,
              "imageUrl": image,
              "createdAt": datetimeNow.toString()
            }))
        .then((response) {
          // !Di proses kedua
      // print("THEN FUNCTION");
      _allPlayer.add(
        Player(
            id: json.decode(response.body)["name"].toString(),
            name: name,
            position: position,
            imageUrl: image,
            createdAt: datetimeNow),
      );
    // !Di proses ketiga
    // print("SETELAH HTTP");
      notifyListeners();
    });

  }

  // ? EDIT DATA

 Future<void> editPlayer(String id, String name, String position, 
  String image,
      BuildContext context) {

    Uri url = Uri.parse(
        "https://http-request-883ec-default-rtdb.firebaseio.com/players/$id.json");
    
    // Todo Patch hanya meninpa data sebelumnya tanpa menghapus data yang ada sebelumnya.
    // Todo Put menghapus/mengantikan data sebelumnya
    return http
        .patch(url,
            body: json.encode({
              "name": name,
              "position": position,
              "imageUrl": image,
            }))
        .then((response) {
          // !Di proses kedua
      // print("THEN FUNCTION");
      Player selectPlayer = _allPlayer.firstWhere((element) => element.id == id);
      selectPlayer.name = name;
    selectPlayer.position = position;
    selectPlayer.imageUrl = image;
    // !Di proses ketiga
    // print("SETELAH HTTP");
      notifyListeners();
    });
  }

  // ? DELETE DATA

  Future<void> deletePlayer(String id, BuildContext context) {
     Uri url = Uri.parse(
        "https://http-request-883ec-default-rtdb.firebaseio.com/players/$id.json");
    
    return http.delete(url).then((value){
    _allPlayer.removeWhere((element) => element.id == id);
    notifyListeners();
    });
  }

  Future<void> initialData() async {
     Uri url = Uri.parse(
        "https://http-request-883ec-default-rtdb.firebaseio.com/players.json");
     
     var hasilGetData = await http.get(url);

    var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;
        // print(dataResponse);
        // !untuk menghilangkan error apabila database kosong
        if(dataResponse != null){
        dataResponse.forEach((key, value) {
          // print(value["createdAt"]);
          var dateTimeParse =  DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["createdAt"]);
          // print(dateTimeParse);
          _allPlayer.add(
            Player(
              id: key,
              createdAt: dateTimeParse,
              imageUrl: value["imageUrl"],
              name: value["name"],
              position: value["position"]
            ),
          );
         });
        }
        //  print("berhasil Masukan data list");
     notifyListeners();
  }
}
