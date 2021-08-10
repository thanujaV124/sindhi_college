import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/provider/data_provider.dart';
import 'package:sindhi_college/screens/authentication/authenticate.dart';
import 'package:sindhi_college/screens/authentication/verify.dart';
import 'package:sindhi_college/screens/main/navigator.dart';
import 'package:sindhi_college/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    final auth = FirebaseAuth.instance;
    late User? curUser;
    curUser = auth.currentUser;
    // ignore: avoid_print
    print('user:' + user.toString());

    if (user == null) {
      return const Authenticate();
    } else if (curUser!.emailVerified) {
      return StreamBuilder<UserData?>(
          stream: DataProvider().userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ChangeNotifierProvider(
                  create: (context) => DataProvider(
                      branch: snapshot.data!.branch,
                      sem: snapshot.data!.sem.toString()),
                  child: const Navigate());
            } else {
              return const Loading();
            }
          });
    } else {
      return const VerifyScreen();
    }
  }
}
