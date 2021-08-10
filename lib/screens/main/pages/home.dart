import 'dart:async';

import 'package:sindhi_college/models/subjects.dart';
import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/provider/data_provider.dart';
import 'package:sindhi_college/screens/main/wiget/recent_notification.dart';

import 'package:sindhi_college/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _timeString;
  Timer? timer;

  bool loading = false;

  // late User user;
  String? avatar;
  Stream<UserData>? data;
  Future<Subjects?>? subjectList;
  DataProvider? dataProvider;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    data = dataProvider.userData;
    _getTime();
    timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('home called');
    return loading
        ? const Loading()
        : StreamBuilder<UserData?>(
            stream: data,
            builder: (context, snapshot) {
              UserData? userData = snapshot.data;
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Row(children: [
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(userData!.avatar),
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'Hi, ${userData.fullName}'.text.lg.bold.make(),
                            '${userData.usn}'.text.uppercase.sm.make(),
                          ]).pOnly(left: 12),
                    ]),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.sort_rounded,
                            size: 30,
                          ))
                    ],
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              image: DecorationImage(
                                image: const CachedNetworkImageProvider(
                                    'https://firebasestorage.googleapis.com/v0/b/brindavan-student-app.appspot.com/o/assets%2Fdrawer_bg%2Fteacher.jpg?alt=media&token=6e8780c9-0269-4203-b176-41047ef6bbdc'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken),
                              )),
                          child: _timeString!.text.bold
                              .letterSpacing(3)
                              .white
                              .xl5
                              .make()
                              .p(25),
                        ).py(20),
                        'Notification'
                            .text
                            .size(30)
                            .bold
                            .letterSpacing(1.5)
                            .make()
                            .py12(),
                        const RecentNotification(),
                      ],
                    ).px(20),
                  ),
                );
              } else {
                return const Loading();
              }
            });
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('h:mma\ndd/MM/yyyy').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }
}
