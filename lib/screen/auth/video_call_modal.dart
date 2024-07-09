// class VideoCallModal{
//   String time;
//   bool isCalling;
//   String callid;
//   String endingTime;
//   VideoCallModal({
//     required this.time,
//     required this.callid,
//     required this.endingTime,
//     required this.isCalling
// });
//   factory VideoCallModal.fromJson2(Map json){
//     return VideoCallModal(
//       callid: json['callid'],
//
//       endingTime:json['endingTime'] ,
//       isCalling:json['isCalling'] ,
//       time:json['time'] ,
//
//     );
//   }
//   Map<dynamic,dynamic> toJson(){
//     final _data=<dynamic,dynamic>{};
//     _data['endingTime']=endingTime;
//     _data['callid']=callid;
//     _data['time']=time;
//     _data['isCalling']=isCalling;
//
//
//     return _data;
//   }
//
// }