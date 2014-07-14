import 'dart:io';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:server/manager.dart';

main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName} ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Logger logger = new Logger('app');

  HttpServer.bind('dartserver.dev', 4040).then((HttpServer server) {
    Stream serverStream = server.asBroadcastStream();

    List<Transport> transports = [
      new WebsocketTransport(serverStream, '/ws'),
      new PollingTransport(serverStream, '/polling'),
    ];

    BubbleFactory bubbleFactory = new BubbleFactory();
    bubbleFactory.registerMessageType(new DataMessage());

    Manager manager = new Manager(transports, bubbleFactory);

    Map<String, Bubble> bubbles = {};

    manager.onOpen.listen((Bubble bubble) {
      if (!bubbles.containsKey(bubble.idClient)) {
        logger.info('new client');

        bubbles[bubble.idClient] = bubble;

        bubble.onMessage.listen((var msg) {
          logger.info('got message ${msg['body']}');
          bubble.send(new DataMessage(body: 'response')).then((id) {
            logger.fine('client received sent message with id $id');
          });
        });

        bubble.onClose.listen((_) {
          logger.info('bubble closed');
        });
      } else {
        logger.info('client reconnected');
      }
    });

    manager.start();

    logger.info('server is up');
  });
}