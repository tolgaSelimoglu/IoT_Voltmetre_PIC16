
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:picoxiloscope/models/user_model.dart';



class FirebaseServices {

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final  ref = FirebaseDatabase.instance.ref().child("voltage");


  // SignIn
  static  Future<void> signInUser(String email, String password ) async {
    try {   
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);  
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }



  static Future<void> signUpUser(String name ,String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((currentUser) async{
        if (currentUser.user?.uid != null) {
          String uid = currentUser.user!.uid;

            createUser(name, email, uid);
           // registerUser(name, email);
           //createRecord();
           

            
          
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }



  static Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  static Future<void> signOut() async => await firebaseAuth.signOut();


  static Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;


  static Future<void> createUser(String name ,String email, String uid ) async {

    final userCollection = firebaseFirestore.collection("users");

    //final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
          uid: uid,
          name: name,
          email: email,       
      ).toDocument();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((e) {
      print(e.message);
    });
  }


static  readVoltage(){
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("voltage");
  String data = (ref.onValue as DatabaseEvent).snapshot.value.toString() ;
return data ;

}


}















// class AuthService {
//   static final FirebaseAuth auth = FirebaseAuth.instance;

//   static Future<User> signUp(String email, String password, String name)  async {
    
//     UserCredential result = await auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
//     final User user = result.user!;
//     await user.updateDisplayName(name);

//     return user;
//   }

//   // static Either<Failure, Future> resetPassword(String email)  {
//   //   try {
//   //     await auth.sendPasswordResetEmail(email: email);
//   //     return true;
//   //   } on FirebaseAuthException catch (e) {
//   //     throw CustomFirebaseException(getExceptionMessage(e));
//   //   } catch (e) {
//   //     throw Exception(e);
//   //   }
//   // }

//   static Future<User?> signIn(String email, String password) async {
//     try {
//       final UserCredential result = await auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//       final User? user = result.user;

//       if (user == null) {
//         throw Exception("User not found");
//       }

//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw CustomFirebaseException(getExceptionMessage(e));
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   static Future<void> signOut() async {
//     await auth.signOut();
//   }
// }

// String getExceptionMessage(FirebaseAuthException e) {
//   print(e.code);
//   switch (e.code) {
//     case 'user-not-found':
//       return 'User not found';
//     case 'wrong-password':
//       return 'Password is incorrect';
//     case 'requires-recent-login':
//       return 'Log in again before retrying this request';
//     default:
//       return e.message ?? 'Error';
//   }
// }

