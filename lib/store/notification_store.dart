import 'package:flutter/foundation.dart';
import 'package:azt/controller/notification_controller.dart';
class NotiModel extends ChangeNotifier {
  int totalUnread = 0;

  Future<String> setTotal() async{
    ListNotification notiData = await NotiController.getNoti(1);
    totalUnread = notiData.objs.where((item) => item['readAt'] == null).toList().length;
    notifyListeners();
    return 'Total';
  }
  void readOne(){
    if(totalUnread > 0){
      totalUnread--;
      notifyListeners();
    }
  }
  void readAll(){
    totalUnread = 0;
    notifyListeners();
  }
}