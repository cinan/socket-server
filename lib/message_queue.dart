part of serverManager;

class MessageQueue {

  Map<String, Queue<Message>> _queue = {};

  void add(Message message, String idClient) {
    _createClient(idClient);

    _queue[idClient].addLast(message);
  }

  void addLast(Message message, String idClient) {
    add(message, idClient);
  }

  void addFirst(Message message, String idClient) {
    _createClient(idClient);

    _queue[idClient].addFirst(message);
  }

  void remove(int idMessage, String idClient) {
    if (_queue.containsKey(idClient)) {
      _queue[idClient].removeWhere((Message msg) {
        return (msg.id == idMessage);
      });
    }
  }

  Queue<Message> getClient(String idClient) {
    _createClient(idClient);

    return _queue[idClient];
  }

  void _createClient(String idClient) {
    if (!_queue.containsKey(idClient)) {
      _queue[idClient] = new Queue<Message>();
    }
  }
}
