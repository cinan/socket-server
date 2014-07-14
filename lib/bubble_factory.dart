part of serverManager;

class BubbleFactory {

  Logger _log = new Logger('BubbleFactory');

  List<Function> _messageTypes = [];

  Manager _manager;

  void registerMessageType(Message message) {
    _messageTypes.add(message);
  }

  void registerManager(Manager manager) {
    _manager = manager;
  }

  Bubble makeBubble(String idClient) {
    _log.info('creating bubble');

    Bubble bubble = new Bubble(idClient);

    bubble.messageTypes = _messageTypes;
    bubble.manager = _manager;

    return bubble;
  }
}