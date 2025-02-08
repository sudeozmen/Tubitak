import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/basvuru.dart';
import 'package:deneme_a/islemGecmisi.dart';
import 'package:deneme_a/main.dart';
import 'package:deneme_a/sifreyenileme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'basvuruGecmisi.dart';
import 'kayitekrani.dart';

class toplayiciGiris extends StatefulWidget {
  @override
  State<toplayiciGiris> createState() => _toplayiciGirisState();
}

class _toplayiciGirisState extends State<toplayiciGiris> {
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
                  SizedBox(height: 50,),
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
            label: 'Giriş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'İşlem Geçmişi',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => toplayiciGiris()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => islemGecmisi()));
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Future<void> GirisYap() async {
    if (_formAnahtari.currentState!.validate()) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('toplayici')
            .where('email', isEqualTo: email)
            .where('sifre', isEqualTo: sifre)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: sifre,
          );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => islemGecmisi()),
                      );
                    },
                  ),
                ],
              );
            },
          );

        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Hata'),
                content: Text('Giriş bilgileri hatalı. Lütfen tekrar deneyin.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Kapat'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Giriş sırasında hata oluştu: $e');
      }
    }
  }

}
