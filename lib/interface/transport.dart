part of serverManager;

abstract class Transport {

  Stream<String> get onOpen;
  Stream<Map> get onMessage;

  Transport(Stream server, String url);

  void send(String data, String idClient);

  void close(String idClient);
}