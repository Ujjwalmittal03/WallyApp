import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
//import 'package:share/share.dart';
import 'package:wallyapp/config/config.dart';

class WallpaperViewPage extends StatefulWidget {
  final DocumentSnapshot data;

  WallpaperViewPage({this.data});

  @override
  _WallpaperViewPageState createState() => _WallpaperViewPageState();
}

class _WallpaperViewPageState extends State<WallpaperViewPage> {
  final  _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.data["tags"].toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: widget.data["url"],
                  child: CachedNetworkImage(
                    placeholder: (ctx, url) => Image(
                      image: AssetImage("assets/placeholder.jpg"),
                    ),
                    imageUrl: widget.data["url"],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 80,
                ),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MaterialButton(
                      child: Icon(Icons.file_download),
                      onPressed: _launchURL,
                    ),
                    MaterialButton(
                      onPressed: () {  },
                      child: Icon(Icons.share),
                      // onPressed: _createDynamicLink,
                    ),
                    MaterialButton(
                      child: Icon(Icons.favorite_border),
                      onPressed: _addToFavorite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    try {
      await launch(widget.data["url"],
          customTabsOption: CustomTabsOption(toolbarColor: primaryColor));
    } catch (e) {}
  }

  void _addToFavorite() async {
    User user = await _auth.currentUser;

    String uid = user.uid;

    _db
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(widget.data.id)
        .set(widget.data.data());
  }

  // void _createDynamicLink() async {
  //   DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
  //     link: Uri.parse("https://wallyapp.page.link/${widget.data.documentID}"),
  //     uriPrefix: "https://wallyapp.page.link",
  //     androidParameters: AndroidParameters(
  //       packageName: "com.wallyapp.app",
  //       minimumVersion: 0,
  //     ),
  //     iosParameters: IosParameters(
  //       bundleId: "com.wallyapp.app",
  //       minimumVersion: "0",
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //         title: "WallyApp",
  //         description: "An app for cool wallpapers",
  //         imageUrl: Uri.parse(widget.data["url"])),
  //   );

  //   Uri uri = await dynamicLinkParameters.buildUrl();

  //   String url = uri.toString();
  //   print(url);

  //   Share.share(url);
  // }
}
