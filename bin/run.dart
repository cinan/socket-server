import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:server/telephonist_manager.dart';

final SERVER_HOST = InternetAddress.LOOPBACK_IP_V6.address;
final SERVER_PORT = 4040;

main() {
  runZoned(() {
//    var timer;

    HttpServer.bind(SERVER_HOST, SERVER_PORT).then((HttpServer server) {
      TelephonistManager cm = new TelephonistManager(server);

      cm.actions = {
        'onData': (msg) {
          print('message received: $msg');

//          new Timer(new Duration(seconds: 3), () {
            var decodedMsg = JSON.decode(msg);
            cm.connection.add(JSON.encode({'type': 'confirmation', 'id': decodedMsg['id']}));
//          });

//          new Timer.periodic(new Duration(seconds: 3), (_) {
//            timer = _;
//            cm.connection.add(JSON.encode({'type': 'message', 'body': 'what is?'}));
//            cm.connection.add('dddd');
//          });
        },
        'onError': (_) => print('error occured'),
        'onClose': () => print('connection closed'),
        'cancelOnError': false
      };

      print("Listening on $SERVER_HOST:$SERVER_PORT");
    });
  }, onError: (e) {
    print(e);
  });
}