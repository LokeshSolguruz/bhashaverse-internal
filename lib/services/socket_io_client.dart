import 'dart:async';

import 'package:bhashaverse/enums/socket_io_event_enum.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOClient {
  Socket? _socket;
  StreamController<dynamic> _responseStream = StreamController();

  void socketEmit(
      {required String emittingStatus,
      required dynamic emittingData,
      required bool isDataToSend}) {
    isDataToSend
        ? _socket?.emit(emittingStatus, emittingData)
        : _socket?.emit(emittingStatus);
  }

  void socketConnect({
    required String apiCallbackURL,
    required String languageCode,
  }) {
    _socket = io(
        apiCallbackURL,
        OptionBuilder()
            .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
            .disableAutoConnect()
            .setQuery({
              'language': languageCode,
              'EIO': 4,
              'transport': 'websocket',
            })
            .build());

    setSocketMethods();
    _socket?.connect();
  }

  void disconnect() {
    _socket?.close();
  }

  void setSocketMethods() {
    _socket?.onConnect((receivedData) {});

    _socket?.on('connect-success', (data) {
      _responseStream.sink.add({'type': SocketIOEvent.connectSuccess});
    });

    _socket?.on('response', (data) {
      if (data[0].isNotEmpty) {
        _responseStream.sink
            .add({'type': SocketIOEvent.streamResponse, 'response': data[0]});
      }
    });

    _socket?.on('terminate', (data) {});

    _socket?.onDisconnect((data) {});
  }

  bool isConnected() {
    return _socket != null && _socket!.connected;
  }

  Stream<dynamic> getResponseStream() {
    return _responseStream.stream;
  }

  void disposeStream() {
    _responseStream.close();
    _responseStream = StreamController();
  }
}
