import 'package:sindhi_college/models/notificationdata.dart';
import 'package:sindhi_college/provider/data_provider.dart';
import 'package:sindhi_college/screens/main/reusable_widget/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:sindhi_college/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool loading = false;
  Stream<List<NotificationData?>?>? notificationData;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    notificationData = dataProvider.notifications;

    // _notificationData = _dataProvider.notifications;

    super.initState();
  }

  @override
  void dispose() {
    // _dataProvider!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
                elevation: 0, title: 'Notification'.text.xl3.bold.make()),
            body: StreamBuilder<List<NotificationData?>?>(
                stream: notificationData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return NotificationWidget(notification: data)
                              .px(20); // passing into widget constructor
                        });
                  } else {
                    return const Loading();
                  }
                }));
  }
}
