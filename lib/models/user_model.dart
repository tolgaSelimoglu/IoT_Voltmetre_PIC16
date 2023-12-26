
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String uid;

  UserModel({required this.name, 
  required this.email,
  required this.uid
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
 


  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot['name'],
      email: snapshot['email'],
      uid: snapshot['uid'],
     
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
    };
  }

}