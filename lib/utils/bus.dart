import 'package:event_bus/event_bus.dart';

class EventbusUtil {
  static EventBus _eventBus;

  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = new EventBus();
    }
    return _eventBus;
  }
}

class LoginEvent {
  String status;
  LoginEvent(this.status);
}

class SettingEvent {
  String status;
  SettingEvent(this.status);
}

class StarTabEvent {
  String type;
  String key;
  dynamic value;
  StarTabEvent(this.type, this.key, this.value);
}

class TestEvent {
  String status;
  TestEvent(this.status);
}
