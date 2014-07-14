part of serverManager;

class DataMessageProcessor implements MessageProcessorInterface {

  Logger _log = new Logger('DataMessageProcessor');

  Manager _manager;

  void set manager(Manager manager) {
    _manager = manager;
  }

  bool canProcess(Message message, String idClient) {
    Bubble bubble = _manager.bubbleForClient(idClient);
    if (bubble != null) {
      return _manager._bubbles[idClient].acceptMessageType(message);
    }

    return false;
  }

  void process(Message message, String idClient) {
    if (_manager != null) {
      Bubble bubble = _manager.bubbleForClient(idClient);

      if (bubble != null) {
        bubble.add(message);
      }

      _log.fine('message for bubble processed');
    }
  }
}