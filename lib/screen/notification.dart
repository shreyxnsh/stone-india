import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:stoneindia/contants.dart';
import 'package:stoneindia/model/notification.dart';
import 'package:stoneindia/utils/restapi.dart';
import 'package:stoneindia/widget/appcommon.dart';
import 'package:stoneindia/widget/nodatafound.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(scaffoldBgColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name: 'Notification'),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Observer(
            builder: (_) => FutureBuilder<NotificationListModel>(
              future: getnotification(user_id: getIntAsync(USER_ID)),
              builder: (_, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
                      itemCount: snap.data!.notificationData?.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index){
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            Card(
                              color: Colors.white,
                              shadowColor: Colors.blueGrey,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text("${snap.data!.notificationData?[index].notification}",
                                        style: const TextStyle(color: kPrimaryColor, fontSize: 16),
                                        maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.only(top: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text("${snap.data!.notificationData?[index].date?.split("T")[0]}", textAlign: TextAlign.right, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            8.height
                          ],
                        );
                      }
                  ).visible(
                    snap.data!.status == true,
                    defaultWidget: const NoDataFoundWidget(iconSize: 120).center(),
                  );
                }
                return snapWidgetHelper(snap, errorWidget: noDataWidget(text: errorMessage, isInternet: true));
              },
            ),
          ),
        ).paddingAll(16),
      ),
    );
  }
}
