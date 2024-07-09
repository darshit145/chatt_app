class ChatModal{
  String formId;
  String msg;
  String read;
  String told;
  Type type;
  String sent;
  bool? isCallEnd;
  ChatModal({
    required this.msg,
     this.isCallEnd,
    required this.read,
    required this.formId,
    required this.sent,
    required this.told,
    required this.type,

});

  factory ChatModal.fromJson2(Map json){
    return ChatModal(
      isCallEnd: json['isCallEnd']??null,
      type: json['type'].toString()==Type.image.name?Type.image:Type.text,
      formId: json['formId'].toString(),
      msg: json['msg'],
      read: json["read"],
      sent: json['sent'],
      told: json['told'],
    );
  }
  Map<String,dynamic> toJson(){
    final _data=<String,dynamic>{};
    _data['type']=type.name;

    _data['formId']=formId;
    _data['msg']=msg;
    _data['read']=read;
    _data['sent']=sent;
    _data['told']=told;
    if(isCallEnd!=null){
      _data['isCallEnd']=isCallEnd;
    }

    return _data;
  }

}

enum Type{
  text,
  image,
  video,
}
//{formId: vv, msg: sdsd, read: dc, told: sdv, type: dc, sent: dvd}