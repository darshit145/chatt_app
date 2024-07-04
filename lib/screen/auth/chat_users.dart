class ChatUsers{
  late  String image;
  late  String createdAt;
  late   String push_tocken;
  late  String about;
  late  String name;
  late  bool isOnline;
  late  String id;
  late  String lase_active;
  late  String email;

  ChatUsers({
    required this.isOnline,
    required this.name,
    required this.id,
    required this.email,
    required this.image,
    required this.createdAt,
    required this.about,
    required this.lase_active,
    required  this.push_tocken,
});

  ChatUsers.fromJson(Map<String,dynamic> json){
    image=json["image"];
    push_tocken=json['push_tocken'];
    createdAt=json['createdAt'];
    about=json['about'];
    name=json['name'];
    isOnline=json['isOnline'];
    id=json['id'];
    lase_active=json['lase_active'];
    email=json['email'];
  }

  factory ChatUsers.fromJson2(Map json){
   return ChatUsers(
       isOnline: json['isOnline'],
       name: json['name'],
       id: json['id'],
       email: json['email'],
       image:json["image"],
       createdAt: json['createdAt'],
       about: json['about'],
       lase_active: json['lase_active'],
       push_tocken: json['push_tocken']
   );
  }

  Map<String,dynamic> toJson(){
    final _data=<String,dynamic>{};

    _data['email']=email;
    _data['lase_active']=lase_active;
    _data['id']=id;
    _data['isOnline']=isOnline;
    _data['name']=name;
    _data['about']=about;
    _data['createdAt']=createdAt;
    _data['push_tocken']=push_tocken;
    _data['image']=image;
    return _data;
  }

}

 var cl={
  "image":"4gDHcKzXI6vldWdbFQhd",
   "createdAt":"",
   "push_tocken":"",
   "about":"4gDHcKzXI6vldWdbFQhd",
   "name":"darshit",
   "isOnline":false,
   "id":"4gDHcKzXI6vldWdbFQhd",
   "lase_active":"",
   "email":"dfachara7@gmail.com"
};