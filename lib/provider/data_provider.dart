import 'package:sindhi_college/models/notificationdata.dart';
import 'package:sindhi_college/models/subjects.dart';
import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/services/database.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final String? branch;
  final String? sem;
  DataProvider({   this.branch,  this.sem});
  

  Stream<UserData> get userData =>
      DatabaseService().curUserData();
  Stream<List<Subjects?>?> get usersubjects =>
      DatabaseService(branch: branch, sem: sem).getSubjects();

  Stream<List<NotificationData?>?> get notifications =>
      DatabaseService().getNotifications();
}
