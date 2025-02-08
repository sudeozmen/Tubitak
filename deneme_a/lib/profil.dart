import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/HomePage.dart';
import 'package:deneme_a/girisekrani.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String kullaniciId="";
  String isim="";
  String email="";
  String sifre="";
  String mmadres="";
  String mmkey="";
  String belgeId="";

  TextEditingController? _isimController;
  TextEditingController? _emailController;
  TextEditingController? _sifreController;
  TextEditingController? _mmadresController;
  TextEditingController? _mmkeyController;
  @override
  void initState() {
    super.initState();
    fetchData();
    _isimController=TextEditingController(text: isim);
    _emailController=TextEditingController(text: email);
    _sifreController=TextEditingController(text: sifre);
    _mmadresController=TextEditingController(text: mmadres);
    _mmkeyController=TextEditingController(text: mmkey);
  }

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    kullaniciId = user!.uid;
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('kayit');
      QuerySnapshot querySnapshot = await users.where('kullaniciId', isEqualTo: kullaniciId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        setState(() {
          belgeId = documentSnapshot.id;
          isim = documentSnapshot['isim'];
          email=documentSnapshot['email'];
          sifre=documentSnapshot['sifre'];
          mmadres=documentSnapshot['adres'];
          mmkey=documentSnapshot['key'];
          print("$belgeId");
          _isimController?.text=isim;
          _emailController?.text=email;
          _sifreController?.text=sifre;
          _mmadresController?.text=mmadres;
          _mmkeyController?.text=mmkey;
        });
      } else {
        print('Document does not exist for user with ID: $kullaniciId');
      }
    } catch (e) {
      print('Error fetching user info from Firestore: $e');
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFİLİ DÜZENLE'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.greenAccent, Colors.green],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/profilfoto.jpg'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: () {
                      },
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            buildTextField("İSİM", _isimController!),
            buildTextField("EMAİL", _emailController!),
            buildTextField("ŞİFRE", _sifreController!),
            buildTextField("META MASK ADRESİ", _mmadresController!),
            buildTextField("META MASK PRIVATE KEY", _mmkeyController!),
            ElevatedButton(
              onPressed: () {
                saveChanges();
              },
              child: Text(
                'Kaydet',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: TextButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text(
                  'Çıkış Yap',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> saveChanges() async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('kayit');
      DocumentSnapshot documentSnapshot = await users.doc(belgeId).get();
      if (documentSnapshot.exists) {
        await users.doc(belgeId).update({
          'isim': _isimController?.text,
          'email': _emailController?.text,
          'sifre': _sifreController?.text,
          'adres': _mmadresController?.text,
          'key': _mmkeyController?.text,
        });
      } else {
        print('Hata: Kullanıcı belgesi bulunamadı. Belge ID: $belgeId');
      }
    } catch (e) {
      print('Firestore\'da belge güncelleme hatası: $e');
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bilgileriniz Güncellendi'),
          content: Text('Bilgileriniz başarıyla güncellendi.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Çıkış Yap'),
          content: Text('Çıkış yapmak istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () async {
                await _signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }
}