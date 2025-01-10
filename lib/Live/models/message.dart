class UserMsg {
  UserMsg({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.fromId,
    required this.sent,
    required this.sessionid
  });
  late final String msg;
  late final String read;
  late final String told;
  late final Type type;
  late final String fromId;
  late final String sent;
  late final String sessionid;

  UserMsg.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    sessionid=json['sessionId'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['read'] = read;
    _data['told'] = told;
    _data['type'] = type.name;
    _data['fromId'] = fromId;
    _data['sent'] = sent;
    _data['sessionId']=sessionid;
    return _data;
  }
}

enum Type { text, image }
