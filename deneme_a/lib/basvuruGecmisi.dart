import 'package:deneme_a/api.dart';
import 'package:deneme_a/girisekrani.dart';
import 'package:deneme_a/kullaniciservisi.dart';
import 'package:deneme_a/profil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'basvuru.dart';
import 'kayitekrani.dart';

class basvuruGecmisi extends StatefulWidget {
  @override
  _basvuruGecmisiState createState() => _basvuruGecmisiState();
}

class _basvuruGecmisiState extends State<basvuruGecmisi> {

  KullaniciServisi _kullaniciServisi = KullaniciServisi();
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        title:Center(child: Text("BAŞVURU GEÇMİŞİ",style: TextStyle(fontSize: 22),),),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.api),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          IconButton(onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }, icon: Icon(Icons.person))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('basvuru')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? CircularProgressIndicator()
              : ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot mypost = snapshot.data!.docs[index];
                Future<void> _showChoiseDialog(BuildContext context) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text(
                              "Silmek istediğinize emin misiniz?",
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                            content: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _kullaniciServisi
                                            .removeAct(mypost.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Evet",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Vazgeç",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )));
                      });
                }
                return SingleChildScrollView(
                  child:Material(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          _showChoiseDialog(context);
                        },
                        child: Container(
                          height: size.height * .3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green, width: 2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ADRES: ${mypost['Adres']}",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "ATIK: ${mypost['atikTuru']}",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "AĞIRLIK: ${mypost['agirlik']}",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "ŞİRKET: ${mypost['tasimaSirketi']}",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child:Text(
                                      "DURUM: ${mypost['Durum']}",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),],
                              ),
                            ),),
                        ),
                      ),
                    ),
                  ),);
              });
        },
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
}