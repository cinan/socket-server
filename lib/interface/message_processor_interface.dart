part of serverManager;

abstract class MessageProcessorInterface {

  MessageProcessorInterface();

  void set manager(Manager manager);

  bool canProcess(Message msg, String idClient);

  void process(Message msg, String idClient);
}