import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/toplayiciGiris.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basvuru.dart';
import 'basvuruGecmisi.dart';
import 'kayitekrani.dart';
import 'kullaniciservisi.dart';

class islemGecmisi extends StatefulWidget {
  const islemGecmisi({Key? key}) : super(key: key);

  @override
  State<islemGecmisi> createState() => _islemGecmisiState();
}

class _islemGecmisiState extends State<islemGecmisi> {

  KullaniciServisi _kullaniciServisi = KullaniciServisi();
  String ddValue='İstek Alındı';
  String userCompanyName='';
  int _currentIndex = 1;


  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userCompanyName = await _kullaniciServisi.getCompanyName();
    print("Employee Company Name: $userCompanyName");
    setState(() {});
  }
  Stream<QuerySnapshot> getActForCompany() async* {
    await _getData();
    if (userCompanyName.isNotEmpty) {
      var ref = FirebaseFirestore.instance.collection("basvuru").where('tasimaSirketi',isEqualTo: userCompanyName).snapshots();
      yield* ref;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        title:Center(child: Text("İŞLEM GEÇMİŞİ",style: TextStyle(fontSize: 22),),),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:getActForCompany(),
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
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          content: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  Container(
                                    height: 40,
                                    width: 300,
                                    child:DropdownButton<String>(
                                      value: ddValue,
                                      items: <String>["İstek Alındı","Yola Çıkıldı","Teslim Alındı","Atık Merkezine Gidiyor","Tamamlandı"].map<DropdownMenuItem<String>>((String value){
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue){
                                        setState(() {
                                          ddValue=newValue!;
                                        });
                                      },
                                      isExpanded:true,
                                    ),),
                                  SizedBox(height: 20,),
                                  GestureDetector(
                                    onTap: () {
                                      _kullaniciServisi.updateDurum(mypost.id,ddValue);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Güncelle",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Vazgeç",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),),],),), ),);
                      });}
                return SingleChildScrollView(
                  child:Material(
                    child:Padding(
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
                                      height: 10,
                                    ),
                                    Container(
                                      alignment:Alignment.bottomLeft,
                                      child:Text(
                                        "DURUM: ${mypost['Durum']}",
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),],
                                ),
                              ),)
                        ),
                      ),
                    ),
                  ),  );
              });
        },
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
}
