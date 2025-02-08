import 'package:deneme_a/basvuru.dart';
import 'package:deneme_a/sifreyenileme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'basvuruGecmisi.dart';
import 'kayitekrani.dart';

class GirisEkrani extends StatefulWidget {
  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  String email = "";
  String sifre = "";
  int _currentIndex = 1;
  var _formAnahtari= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DÖNÜŞTÜR KAZAN"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formAnahtari,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    onChanged: (alinanMail) {
                      setState(() {
                        email = alinanMail;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                      onChanged: (alinanSifre) {
                        setState(() {
                          sifre = alinanSifre;
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Şifre",
                          border: OutlineInputBorder()
                      )
                  ),
                  SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        child: TextButton(
                            child: Text('Şifremi Unuttum'),

                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SifreYenileme()),);
                            }
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600)
                      ),
                      onPressed: () {
                        GirisYap();
                      },
                      child: Text("GİRİŞ YAP"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Kayıt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Başvuru',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Başvuru Geçmişi',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => KayitEkrani()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => basvuru()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => basvuruGecmisi()));
              break;
            default:
              break;
          }
        },
      ),
    );
  }


  Future GirisYap() async{
    if(_formAnahtari.currentState!.validate()){
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: sifre.trim()).then((value){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Giriş Yapıldı'),
              content: Text('Giriş işlemi başarıyla yapıldı.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_)=>basvuru()),(route)=> true);
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }
}
