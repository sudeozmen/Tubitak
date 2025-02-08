import 'package:deneme_a/basvuru.dart';
import 'package:deneme_a/takipsayfasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';


enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class verifyPhone extends StatefulWidget {
  @override
  _verifyPhoneState createState() => _verifyPhoneState();
}

class _verifyPhoneState extends State<verifyPhone> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential?.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> basvuru()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(currentState as BuildContext).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        Container(
          child: Text('Kimliğinizi Doğruyabilmemiz İçin Lütfen Telefon Numaranızı Girin',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 25,
                fontWeight:
                FontWeight.bold),),),
        SizedBox(height: 40,),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "+905005005050",
            labelText: "Telefon Numarası",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          height: 60,
          child:ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600)
            ),
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  //signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  ScaffoldMessenger.of(currentState as BuildContext).showSnackBar(SnackBar(content: Text(verificationFailed.toString())));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("GÖNDER"),
          ),),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        Container(
          child: Text('Telefonunuza Gelen Doğrulama Kodunu Girin',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 25,
                fontWeight: FontWeight.bold),),),
        SizedBox(height: 40,),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            labelText: "Telefonunuza Gelen Doğrulama Kodu",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          height: 60,
          child:ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600)
            ),
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpController.text);

              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text("DOĞRULA"),
          ),),
        Container(
          child: TextButton(onPressed: () {

          },
            child: Text("Tekrar Gönder",),style: TextButton.styleFrom(
                primary: Colors.blue
            ),),
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}