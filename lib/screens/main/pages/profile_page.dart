import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/screens/main/pages/select_avatar.dart';
import 'package:sindhi_college/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  final UserData? userData;
  final String? imgUrl;
  const ProfilePage({Key? key, required this.userData, required this.imgUrl})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: 'Profile'.text.white.center.make(),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 250.0,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: widget.imgUrl!,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        enabled: false,
                        initialValue: widget.userData!.usn.toUpperCase(),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'USN', counter: SizedBox.shrink()),
                      ).py(10),
                      TextFormField(
                        enabled: false,
                        initialValue: widget.userData!.branch,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Branch', counter: SizedBox.shrink()),
                      ).py(10),
                      TextFormField(
                        enabled: false,
                        initialValue: widget.userData!.sem.toString(),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Sem', counter: SizedBox.shrink()),
                      ).py(10),
                      TextFormField(
                        enabled: false,
                        initialValue: widget.userData!.section,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Section', counter: SizedBox.shrink()),
                      ).py(10),
                    ],
                  ).px24(),
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 200.0, // (background container size) - (circle height / 2)
            child: Column(
              children: [
                Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(widget.userData!.avatar),
                    )),
                widget.userData!.fullName.text.bold.make().p12()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
