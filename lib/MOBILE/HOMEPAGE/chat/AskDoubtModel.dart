class AskDoubtMsg {
  AskDoubtMsg({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  late final String msg;
  late final String read;
  late final String told;
  late final MsgType type;
  late final String fromId;
  late final String sent;

  AskDoubtMsg.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == MsgType.image.name ? MsgType.image : MsgType.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['read'] = read;
    _data['told'] = told;
    _data['type'] = type.name;
    _data['fromId'] = fromId;
    _data['sent'] = sent;
    return _data;
  }
}

enum MsgType { text, image }
