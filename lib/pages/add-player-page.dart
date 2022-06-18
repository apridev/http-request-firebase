import 'package:flutter/material.dart';
import 'package:http_request_firebase/provider/player.dart';
import 'package:provider/provider.dart';

class AddPlayer extends StatelessWidget {
  static const routeName = "/add-player";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Players>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ADD PLAYER"),
        actions: [
          IconButton(
              onPressed: () {
                players
                    .addPlayer(nameController.text, positionController.text,
                        imageController.text, context)
                    .then((response) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Berhasil menambahkan data"),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.save),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            child: Column(
          children: [
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
              decoration: InputDecoration(
                labelText: "Image URL",
              ),
              textInputAction: TextInputAction.done,
              controller: imageController,
              onEditingComplete: () {
                players.addPlayer(nameController.text, positionController.text,
                    imageController.text, context). then((response){
                      players.addPlayer(
                        nameController.text,
                        positionController.text,
                        imageController.text,
                        context). then((response){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                        content: Text("Berhasil menambahkan data"),
                        duration: Duration(seconds: 2),
                      ));
                      Navigator.pop(context);
                        });
                    });
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                  onPressed: () {
                    players
                        .addPlayer(nameController.text, positionController.text,
                            imageController.text, context)
                        .then((response) {
                      // !Kembali ke home dan munculkan notif
                      // print("Kembali ke home & munculkan notif berhasil");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Berhasil menambahkan data"),
                        duration: Duration(seconds: 2),
                      ));
                      Navigator.pop(context);
                    });
                    // !Keluar pada saat diproses
                    // print("Sudah kembali ke home");
                  },
                  child: Text('Submit')),
            ),
          ],
        )),
      ),
    );
  }
}
