

import 'dart:convert';

enum TypeEvent {createSuccessful}

class Event {
  final TypeEvent typeEvent;
  final String arg1;

  Event(this.typeEvent, this.arg1);


  factory Event.fromCreateSuccessful(String gameId) {
    return Event(TypeEvent.createSuccessful, gameId);
  }


  factory Event.fromEncodedData(String data) {
    
  }

  String encode() {
    return jsonEncode({
      'event': typeEvent,
      'arg': arg1
    });
  }



}