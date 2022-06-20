import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http_request_firebase/pages/add-player-page.dart';
import 'package:http_request_firebase/pages/detail-player-page.dart';
import 'package:http_request_firebase/provider/player.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/player.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // !Mengambil data dari provider
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Players>(context).initialData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isInit = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allPlayerProvider = Provider.of<Players>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Data"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddPlayer.routeName);
              },
              icon: Icon(Icons.add)),
          IconButton(
            onPressed: clearCache, 
            icon: Icon(Icons.clear)
          )
          // IconButton(
          //   onPressed: () {
          //     allPlayerProvider.initialData().then((value) {
          //       setState(() {});
          //     });
          //   },
          //   icon: Icon(Icons.remove_red_eye_outlined),
          // ),
        ],
      ),
      body: (allPlayerProvider.jumlahPlayer == 0)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Data Masih Kosong!',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddPlayer.routeName);
                      },
                      child: const Text(
                        "Tambah Data",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            )
          : ListView.builder(
              itemCount: allPlayerProvider.jumlahPlayer,
              itemBuilder: (context, index) {
                var id = allPlayerProvider.allPlayer[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, DetailPlayer.routeName,
                        arguments: id);
                  },
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       allPlayerProvider.allPlayer[index].imageUrl),
                  // ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: allPlayerProvider.allPlayer[index].imageUrl,
                        placeholder: (context, url) => Container(
                          color: Colors.black12,
                        ),
                        errorWidget: (context, url, error) => Container( color: Colors.black12,
                        child: Icon(Icons.error, color: Colors.redAccent,),
                        ),
                      ),
                    ),
                  ),

                  title: Text(allPlayerProvider.allPlayer[index].name),
                  subtitle: Text(DateFormat.yMMMd()
                      .format(allPlayerProvider.allPlayer[index].createdAt)),
                  trailing: IconButton(
                      onPressed: () {
                        allPlayerProvider.deletePlayer(id, context).then((_) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text("Berhasil Menghapus Data"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      },
                      icon: Icon(Icons.delete)),
                );
              }),
    );
  }
  
  void clearCache(){
    DefaultCacheManager().emptyCache();
    
    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {
      
    });
  }
}
