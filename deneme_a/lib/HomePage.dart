import 'package:deneme_a/kayitekrani.dart';
import 'package:deneme_a/toplayiciGiris.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void navigateToUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KayitEkrani()),
    );
  }
  void navigateToCollector() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => toplayiciGiris()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:Center(child:Text("DÖNÜŞTÜR KAZAN'A HOŞGELDİNİZ",style: GoogleFonts.breeSerif(
          textStyle: TextStyle(
            fontSize: 24,
            color: Colors.grey[800],
          ),
        ),),),
      ),
      body: SafeArea(
        child: Container(
          child:SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/kullanici.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                       Text(
                        "KULLANICI GİRİŞİ",
                         style: GoogleFonts.breeSerif(
                           textStyle: TextStyle(
                             fontSize: 35,
                             color: Colors.white,
                           ),
                         ),
                      ),
                      const SizedBox(height: 50,),
                      GestureDetector(
                        onTap: navigateToUser,
                        child:Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: Center(
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ),],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/toplayici.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                       Text(
                        "TOPLAYICI GİRİŞİ",
                        style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      GestureDetector(
                        onTap: navigateToCollector,
                        child:Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: Center(
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ), ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),);
  }
}
