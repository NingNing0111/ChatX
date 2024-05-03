
import 'package:chat_all/db/boxes.dart';
import 'package:chat_all/model/message.dart';

/**
 * key-value
 * key_histories 存储所有的HistoryMessage
 */
class MessageDatabase {

  // 单例对象
  static final MessageDatabase _instance = MessageDatabase._internal();

  // 私有构造函数
  MessageDatabase._internal();

  // 工厂构造函数，用于返回单例对象
  factory MessageDatabase() {
    return _instance;
  }

  // 读取所有的history
  List<HistoryMessage> readAll(){
    var values = historyBox.get("key_histories");

    List<HistoryMessage> histories = [];
    if(values == null){
      return histories;
    }
    for (var element in values) {
      histories.add(HistoryMessage(id: element.id, title: element.title, messages: element.messages, createTime: element.createTime));
    }
    print(histories);
    return histories;

  }
  
  // 添加HistoryMessage
  void addHistoryMessage(HistoryMessage message){
    var histories = readAll();
    histories.add(message);
    historyBox.put("key_histories", histories);
  }

  // 删除HistoryMessage
  void deleteHistoryMessage(String id){
    var histories = readAll();
    int len = histories.length;
    int deleteIndex = 0;
    while(deleteIndex < len && histories[deleteIndex].id != id) {
      deleteIndex++;
    }
    if(deleteIndex == len) return;
    histories.removeAt(deleteIndex);
    historyBox.put("key_histories", histories);
  }

  // 清空HistoryMessage
  void clearHistoryMessage(){
    var histories = readAll();
    histories.clear();
    historyBox.put("key_histories", histories);
  }

  // 更新某个HistoryMessage
  void updateHistoryMessage(HistoryMessage historyMessage) {
    var histories = readAll();
    int len = histories.length;
    int updateIndex = 0;
    while(updateIndex < len && histories[updateIndex].id != historyMessage.id){
      updateIndex++;
    }
    if(updateIndex == len)return;
    histories[updateIndex] = historyMessage;
    historyBox.put("key_histories", histories);
  }

  // 保存
  void saveHistory(List<HistoryMessage> histories){
    historyBox.put("key_histories", histories);
  }

}
