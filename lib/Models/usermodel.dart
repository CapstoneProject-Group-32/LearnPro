class UserModel {
  //schema of the users collections

  final String uid;
  final String email;
  final String userName;
  final String major;
  final String profilePic;
  final List<String> friends;
  final List<String> sentRequests;
  final List<String> receivedRequests;

  UserModel({
    required this.uid,
    required this.email,
    required this.userName,
    required this.major,
    required this.profilePic,
    required this.friends,
    required this.sentRequests,
    required this.receivedRequests,
  });

  //when storing the data

  Map<String, dynamic> toJSON() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'major': major,
      'profilePic': profilePic,
      'friends': friends,
      'sentRequests': sentRequests,
      'receivedRequests': receivedRequests,
    };
  }
  //this methode will convert the json object to user data

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        userName: json['userName'],
        major: json['major'],
        profilePic: json['profilePic'],
        friends: List<String>.from(json['friends']),
        sentRequests: List<String>.from(json['sentRequests']),
        receivedRequests: List<String>.from(json['receivedRequests']));
  }
}
