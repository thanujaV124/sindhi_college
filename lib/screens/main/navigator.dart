import 'dart:math';
import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/provider/data_provider.dart';
import 'package:sindhi_college/screens/main/pages/enter_details.dart';
import 'package:sindhi_college/screens/main/pages/home.dart';
import 'package:sindhi_college/screens/main/pages/notification.dart';
import 'package:sindhi_college/screens/main/pages/profile_page.dart';
import 'package:sindhi_college/screens/main/pages/select_avatar.dart';
import 'package:sindhi_college/screens/main/pages/subject_list.dart';
import 'package:sindhi_college/screens/main/pages/theme.dart';
import 'package:sindhi_college/services/auth.dart';
import 'package:sindhi_college/services/database.dart';
import 'package:sindhi_college/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Navigate extends StatefulWidget {
  const Navigate({Key? key}) : super(key: key);

  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate>
    with AutomaticKeepAliveClientMixin<Navigate> {
  @override
  bool get wantKeepAlive => true;

  final AuthService _auth = AuthService();
  final PageStorageBucket _bucket = PageStorageBucket();

  var regex = RegExp(r'[A-Za-z]');

  Stream<UserData>? data;
  MyUser? user;
  String? imgUrl;

  bool loading = false;
  int _currentIndex = 0;
  List<Widget> tabs = [
    Home(),
    const SubjectList(),
    const NotificationList(),
  ];

  @override
  void dispose() {
    // dataProvider!.dispose();
    super.dispose();
  }

  Future _initImg() async {
    List<dynamic> result = await DatabaseService().getImg();
    var randomNames = Random().nextInt(result.length);
    setState(() {
      imgUrl = result[randomNames];
    });
  }

  @override
  void initState() {
    _initImg();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    data = dataProvider.userData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    var buttonStyle = ElevatedButton.styleFrom(
      elevation: 10,
      primary: Theme.of(context).backgroundColor,
      onPrimary: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    super.build(context);

    return loading
        ? Loading()
        : StreamBuilder<UserData?>(
            stream: data,
            builder: (context, snapshot) {
              UserData? userData = snapshot.data;

              if (snapshot.hasData) {
                // ignore: unnecessary_null_comparison
                if (userData!.fullName.isEmpty) {
                  return EnterDetails(userData: userData);
                } else {
                  return Scaffold(
                      extendBody: true,
                      body: IndexedStack(
                        index: _currentIndex,
                        children: tabs,
                      ),
                      bottomNavigationBar: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: BottomNavigationBar(
                          currentIndex: _currentIndex,
                          backgroundColor: Theme.of(context).primaryColor,
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.white.withOpacity(.60),
                          selectedFontSize: 10,
                          selectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          unselectedFontSize: 10,
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home_rounded),
                              title: 'Home'.text.make(),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.article_rounded),
                              title: 'Subjects'.text.make(),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.notifications),
                              title: 'Notification'.text.make(),
                            ),
                          ],
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ).h(80),
                      ).p(20),
                      drawer: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Drawer(
                            child: Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.60,
                                child: DrawerHeader(
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              '${imgUrl}'),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.darken),
                                        )),
                                    child: UserAccountsDrawerHeader(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                        color: Colors.transparent,
                                      ),
                                      accountName:
                                          userData.fullName.text.make(),
                                      accountEmail:
                                          '${user!.email}'.text.make(),
                                      currentAccountPicture: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AvatarSelector()));
                                        },
                                        child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                          '${userData.avatar}',
                                        )),
                                      ),
                                    )),
                              ),
                              Container(
                                  color: Theme.of(context).canvasColor,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                Duration(milliseconds: 200),
                                                () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                            userData: userData,
                                                            imgUrl: imgUrl,
                                                          )));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.person_rounded),
                                            title: 'Profile'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                Duration(milliseconds: 200),
                                                () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ThemeSwitcher()));
                                            });
                                          },
                                          child: ListTile(
                                            leading:
                                                Icon(Icons.palette_rounded),
                                            title: 'Theme'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                Duration(milliseconds: 200),
                                                () {
                                              setState(() {
                                                loading = true;
                                              });
                                              _auth.signOut();
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.logout_rounded),
                                            title: 'Sign Out'.text.make(),
                                          ),
                                        ).p12(),
                                        'Version 1.0.0'
                                            .text
                                            .color(Theme.of(context).hintColor)
                                            .hairLine
                                            .lg
                                            .make()
                                            .p16(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary:
                                                Theme.of(context).primaryColor,
                                            onPrimary: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: const Icon(Icons
                                                    .settings_accessibility_rounded)
                                                .iconColor(Colors.white),
                                            title: 'Devlopers'
                                                .text
                                                .color(Colors.white)
                                                .make(),
                                          ),
                                        ).p12(),
                                      ])).card.elevation(0).rounded.make().p12()
                            ],
                          ),
                        )),
                      ));
                }
              } else {
                return const Loading();
              }
            });
  }
}
