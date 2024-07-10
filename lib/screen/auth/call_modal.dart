class CallModal{
  String reciverId,callId,connectionLine;
  bool isVideoCall,isRightNoe;
  CallModal({
    required this.callId,
    required this.isRightNoe,
    required this.connectionLine,
    required this.isVideoCall,
    required this.reciverId
});

  factory CallModal.fromJson(Map<String,dynamic> json){
    return CallModal(
        isRightNoe: json['isRightNoe'],
        callId: json['callId'],
        connectionLine: json['connectionLine'],
        isVideoCall: json['isVideoCall'],
        reciverId: json['reciverId']
    );
  }

  Map<String,dynamic> toJson(){
    final _data=<String,dynamic>{};
    _data['callId']=callId;
    _data['connectionLine']=connectionLine;
    _data['isVideoCall']=isVideoCall;
    _data['reciverId']=reciverId;
    _data['isRightNoe']=isRightNoe;

    return _data;
  }
}