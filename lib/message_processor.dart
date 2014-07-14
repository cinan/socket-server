part of serverManager;

class MessageProcessor {

  Logger _log = new Logger('MessageProcessor');

  Manager _manager;

  List<MessageProcessorInterface> _processors = [];

  MessageProcessor(Manager this._manager);

  void registerProcessor(MessageProcessorInterface mp) {
    mp.manager = _manager;
    _processors.add(mp);
  }

  void process(Message message, String idClient) {
    for (var processor in _processors) {
      if (processor.canProcess(message, idClient)) {
        processor.process(message, idClient);
      }
    }
  }
}