part of telephonist;

abstract class Transport {

  static const int CLOSED     = 0;
  static const int CLOSING    = 1;
  static const int CONNECTING = 2;
  static const int OPEN       = 3;

  Stream get onMessage;

  Transport(HttpRequest req);

  void send(data);
}