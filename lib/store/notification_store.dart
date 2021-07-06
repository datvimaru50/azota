import 'package:flutter/foundation.dart';
import 'package:azt/controller/notification_controller.dart';
class NotiModel extends ChangeNotifier {
  int totalUnread = 0;

  Future<ListNotification> setTotal({String accType='teacher'}) async{
    ListNotification notiData = await NotiController.getNoti(1);
    totalUnread =  notiData.objs.length == 0 ? 0 : notiData.objs.where((item) => item['readAt'] == null).toList().length;
    notifyListeners();
    return notiData;
  }
}