part of telephonist;

class Messager {

  Logger _log = new Logger('Messager');

  Map _message;

  Transport _transport;

  int _nextSendId = 1;

  LinkedHashMap<dynamic, String> _messageBuffer = new LinkedHashMap<dynamic, String>();

  Messager(this._transport, String message) {
    _message = decodeMessage(message);
    confirmIncomingMessage();
  }

  void send(data) {
    String message = JSON.encode({
        'id': _nextSendId,
        'type': 'message',
        'body': data,
    });

    _transport.send(message);
  }

  void confirmIncomingMessage() {
    if (_isIncomingConfirmation()) {
      // TODO incoming confirmation?
    } else {
      _sendConfirmation();
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
    String message = JSON.encode({
      'id': _nextSendId,
      'type': 'confirmation',
      'body': {
        'id': _message['id']
      }
    });

    _transport.send(message);
  }

  bool _isIncomingConfirmation() {
    String messageType = _message['type'];
    var messageId = _message['id'];

    return ((messageType == 'confirmation') && (messageId != null));
  }
}
