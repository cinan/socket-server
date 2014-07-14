part of serverManager;

class ReceivedMemory {

  Map<int, Message> _received = {};

  void add(Message message) {
    if (message.data['id'] is int) {
      _received[message.data['id']] = message;
    }
  }

  bool exists(Message message) {
    if (message.id != null) {
      return _received.containsKey(message.data['id']);
    }

    return false;
  }

}
