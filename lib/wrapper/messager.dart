part of telephonist;

/**
 * TODO: rename
 */
class Messager {

  Logger _log = new Logger('Messager');

  Map _rawMessage;

  Transport _transport;

  int _nextSendId = 1;

  LinkedHashMap<dynamic, String> _messageBuffer = new LinkedHashMap<dynamic, String>();

  get message => (_rawMessage == null) ? null : _rawMessage['body'];

  Messager(this._transport, String message) {
    _rawMessage = decodeMessage(message);
    processMessage();
  }

  void send(data) {
    String message = JSON.encode({
      // TODO move nextSendId outside, must be global
        'id': _nextSendId,
        'type': 'message',
        'body': data,
    });

    _transport.send(message);
  }

  void processMessage() {
    if (_isIncomingConfirmation()) {
      // TODO incoming confirmation?
    } else if (_isPing()) {
      _sendPong();
    } else {
//      _sendConfirmation();
    }
  }

  Map decodeMessage(String message) {
    Map result = null;
    try {
      result = JSON.decode(message);
    } on FormatException {
      _log.warning('Malformatted message received');
      result = null;
    }

    return result;
  }

  void _sendConfirmation() {
    var id = _rawMessage['id'];

    /**
     * TODO: what if id is null?
     */

    String message = JSON.encode({
      'id': _nextSendId,
      'type': 'confirmation',
      'body': {
        'id': id
      }
    });

    _transport.send(message);
  }

  void _sendPong() {
    String message = JSON.encode({
      'type': 'pong'
    });
    _transport.send(message);
  }

  bool _isIncomingConfirmation() {
    String messageType = _rawMessage['type'];
    var messageId = _rawMessage['id'];

    return ((messageType == 'confirmation') && (messageId != null));
  }

  bool _isPing() {
    return (_rawMessage['type'] == 'ping');
  }
}
