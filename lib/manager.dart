library serverManager;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:messages/messages.dart';
import 'package:uuid/uuid_server.dart';
import 'package:json_object/json_object.dart';
import 'package:http_server/http_server.dart';

export 'package:messages/messages.dart';

part 'interface/transport.dart';
part 'interface/message_processor_interface.dart';
part 'transport/websocket_transport.dart';
part 'transport/polling_transport.dart';
part 'bubble_factory.dart';
part 'bubble.dart';
part 'received_memory.dart';
part 'message_queue.dart';
part 'message_processor.dart';
part 'message_processors/data_message_processor.dart';
part 'message_processors/ping_message_processor.dart';
part 'message_processors/confirmable_message_processor.dart';
part 'message_processors/confirmation_message_processor.dart';

class Manager {

  Logger _log = new Logger('Manager');

  List<Transport> _transports = [];

  ReceivedMemory _receivedMemory = new ReceivedMemory();

  List<Function> _messageMatchers = [
    (map) => ConfirmationMessage.matches(map) ? new ConfirmationMessage.fromMap(map) : null,
    (map) => DataMessage.matches(map) ? new DataMessage.fromMap(map) : null,
    (map) => PingMessage.matches(map) ? new PingMessage.fromMap(map) : null,
  ];

  BubbleFactory _bubbleFactory = new BubbleFactory();

  Map<String, Bubble> _bubbles = {};

  Map<String, Transport> _idClientToTransport = {};

  MessageProcessor _messageProcessor;

  StreamController<Bubble> _onOpenController = new StreamController<Bubble>();
  Stream<Bubble> get onOpen => _onOpenController.stream;

  LinkedHashMap<int, Message> _messageBuffer    = new LinkedHashMap<int, Message>();
  Map<int, Completer>         _completers       = {};

  MessageQueue _messageQueue = new MessageQueue();

  int _nextMessageId = 0;
  int get nextMessageId => _nextMessageId++;

  Manager(List<Transport> this._transports, BubbleFactory this._bubbleFactory) {
    _bubbleFactory.registerManager(this);

    _messageProcessor = new MessageProcessor(this);
    _messageProcessor..registerProcessor(new PingMessageProcessor())
      ..registerProcessor(new ConfirmableMessageProcessor())
      ..registerProcessor(new DataMessageProcessor())
      ..registerProcessor(new ConfirmationMessageProcessor());
  }

  void start() {
    for (Transport transport in _transports) {
      transport.onOpen.listen((String idClient) => _onOpenAction(transport, idClient));
      transport.onMessage.listen((Map pair) => _onMessageAction(transport, pair));
    }
  }

  void close(Transport transport, String idClient) {
    _messageQueue.getClient(idClient).forEach((Message msg) {
      msg.pending = false;
    });

    transport.close(idClient);

    if (bubbleForClient(idClient) == null)
      return;

    _bubbles[idClient].close();
  }

  void send(Message message, String idClient) {
    if (message.confirmableFlag) {
      if (message.id == null) {
        message.id = nextMessageId;
      }
      _createCompleter(message, idClient);
    }

    if (!message.volatileFlag) {
      _messageQueue.add(message, idClient);
    }

    List<Message> queue = _messageQueue.getClient(idClient).where((Message msg) {
      if (!msg.pending) {
        msg.pending = true;
        return true;
      }

      return false;
    }).toList();

    message.pending = true;

    MessageContainer container = new MessageContainer();
    queue.add(message);
    container.addAll(queue);

    String data;

    if (container.length > 1) {
      data = container.wrapped.toString();
    } else if (container.length == 1) {
      data = container.first.toString();
    } else {
      return;
    }

    _log.info('passing data to transport');
    _sendToTransport(data, idClient);
  }

  void sendLater(Message message, String idClient) {
    _messageQueue.getClient(idClient).add(message);
  }

  void complete(int messageId, String idClient) {
    Completer<int> completer = _completers[messageId];

    if (completer != null) {
      completer.complete(messageId);
      _completers.remove(messageId);
    }

    _messageQueue.remove(messageId, idClient);
  }

  Bubble bubbleForClient(String idClient) {
    return _bubbles[idClient];
  }

  Future<int> messageFuture(int messageId) {
    Completer completer = _completers[messageId];
    if (completer != null) {
      return completer.future;
    }

    return null;
  }

  void _onOpenAction(Transport transport, String idClient) {
    _log.info('on open');

    if (bubbleForClient(idClient) == null) {
      _bubbles[idClient] = _bubbleFactory.makeBubble(idClient);
    }

    Bubble bubble = bubbleForClient(idClient);

    _onOpenController.add(bubble);

    if ((_idClientToTransport[idClient] != null)
    && (_idClientToTransport[idClient] != transport)) {
      close(_idClientToTransport[idClient], idClient);
    }

    _idClientToTransport[idClient] = transport;

    // TODO check heartbeat
    // TODO client tells me heartbeat interval
  }

  void _onMessageAction(Transport transport, Map pair) {
    _log.info('on message');

    String idClient = pair['idClient'];
    if (bubbleForClient(idClient) == null)
      return;

    MessageContainer messages = _toMessageContainer(pair['data']);

    for (Message message in messages) {
      bool received = _receivedMemory.exists(message);
      if (!received) {
        _receivedMemory.add(message);
      }

      _messageProcessor.process(message, idClient);
    }
  }

  Future _createCompleter(Message message, String idClient) {
    if (message.id != null) {
      Completer completer = new Completer();
      _completers[message.id] = completer;

      return completer.future;
    }

    return null;
  }

  void _sendToTransport(String data, String idClient) {
    Transport transport = _idClientToTransport[idClient];
    if (transport != null) {
      transport.send(data, idClient);
    }
  }

  MessageContainer _toMessageContainer(Map data) {
    MessageContainer mc = new MessageContainer();

    List messages = [];

    if (MessageContainer.matches(data)) {
      messages = data['messages'];
    } else {
      messages.add(data);
    }

    Message message;

    for (var m in messages) {
      if (! (m is Map)) {
        continue;
      }

      message = null;

      for (var matcher in _messageMatchers) {
        message = matcher(m);
        if (message != null) {
          break;
        }
      }

      if (message != null) {
        mc.add(message);
      }
    }

    return mc;
  }
}