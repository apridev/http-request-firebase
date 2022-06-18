import 'package:flutter/material.dart';
import 'package:http_request_firebase/provider/player.dart';
import 'package:provider/provider.dart';

import '../provider/player.dart';

class DetailPlayer extends StatelessWidget {
  static const routeName = "/detail-player";

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Players>(context);
    final playerId = ModalRoute.of(context).settings.arguments as String;
    final selectPlayer = players.selectById(playerId);
    final TextEditingController imageController =
        TextEditingController(text: selectPlayer.imageUrl);
    final TextEditingController nameController =
        TextEditingController(text: selectPlayer.name);
    final TextEditingController positionController =
        TextEditingController(text: selectPlayer.position);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('DETAIL PLAYER'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        image: NetworkImage(imageController.text),
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(labelText: "Nama"),
              textInputAction: TextInputAction.next,
              controller: nameController,
            ),
            TextFormField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(labelText: "Posisi"),
              textInputAction: TextInputAction.next,
              controller: positionController,
            ),
            TextFormField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(labelText: "Image URL"),
              textInputAction: TextInputAction.done,
              controller: imageController,
              onEditingComplete: () {
                players.editPlayer(playerId, nameController.text,
                    positionController.text, imageController.text, context).then((value){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text("Data Berhasil diubah"),
                        duration: Duration(seconds: 2),
                      ));
                Navigator.pop(context);
                    });
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                  onPressed: () {
                    players
                        .editPlayer(
                            playerId,
                            nameController.text,
                            positionController.text,
                            imageController.text,
                            context)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text("Data Berhasil diubah"),
                        duration: Duration(seconds: 2),
                      ));
                    Navigator.pop(context);
                    });
                  },
                  child: Text("Edit")),
            ),
          ],
        )),
      ),
    );
  }
}
