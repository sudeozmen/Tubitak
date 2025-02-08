import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/kullanici.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class KullaniciServisi{

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  // konum bilgisi ekle
  Future add(String kullaniciID,String telefon, GeoPoint konum ) async {
    var ref= _firestore.collection("kullanici");
    var kullaniciref= await ref.add({
      'telefon':telefon,
      'konum':konum,
    });
    return Kullanici(kullaniciID:kullaniciref.id,telefon:telefon,konum:konum);
  }

  // kullanıcı kaydı ekle
  Future addUser(String isim, String email, String sifre,String adres,String key,String kullaniciId) async {
    var ref=_firestore.collection("kayit");
    var kayitref=await ref.add({
      'isim':isim,
      'email':email,
      'sifre':sifre,
      'adres' :adres,
      'key' :key,
      'kullaniciId':kullaniciId,
    });
    return Kayit(isim: isim,email: email,sifre: sifre,adres: adres,key: key,kullaniciId:kullaniciId);
  }

  // basvuru ekle
  Future addRequest(String atikTuru, String agirlik, String tasimaSirketi, String Durum, String Adres, String userId) async {
    var ref = _firestore.collection("basvuru");
    DocumentReference basvururef = await ref.add({
      'agirlik': agirlik,
      'atikTuru': atikTuru,
      'tasimaSirketi': tasimaSirketi,
      'Durum': Durum,
      'Adres': Adres,
      'userId': userId,
    });
    print("Oluşturulan Başvuru ID: ${basvururef.id}");
    return Basvuru(
      basvuruID: basvururef.id, // Oluşturulan belge ID'sini al
      atikTuru: atikTuru,
      agirlik: agirlik,
      tasimaSirketi: tasimaSirketi,
      Durum: Durum,
      Adres: Adres,
      userId: userId,
    );
  }

  //konum bilgisi al
  Future getData() async {
    GeoPoint g;
    FirebaseFirestore.instance
        .collection("kullanici").doc('8a7T602KRvQcJMhH8sBf')
        .get()
        .then((value){
      g=value.data()!["konum"];
      LatLng latLng=LatLng(g.latitude, g.longitude);
      print(latLng) ;
    });
  }

  //basvuru gecmisini al
  Stream<QuerySnapshot> getAct() {
    var ref = _firestore.collection("basvuru").snapshots();
    return ref;
  }
  //basvuru gecmisini sil
  Future<void> removeAct(String docId) {
    var ref = _firestore.collection("basvuru").doc(docId).delete();
    return ref;
  }

  //şirket bilgisi al
  Future<String> getCompanyName() async{
    User? user = FirebaseAuth.instance.currentUser;
    String kullaniciId="";
    String comp= "";
    kullaniciId = user!.uid;
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('toplayici');
      QuerySnapshot querySnapshot = await users.where('userId', isEqualTo: kullaniciId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        comp=documentSnapshot["sirket"].toString(); }
      else{
        print('Document does not exist for user with ID: $kullaniciId');
      }
    }
    catch (e){
      print('Error fetching user info from Firestore: $e');
    }
    return comp;
  }

  //durum güncelle
  Future<void> updateDurum(String documentId, String newDurum) async {
    try {
      await _firestore
          .collection('basvuru')
          .doc(documentId)
          .update({'Durum': newDurum});
      print('Durum güncellendi.');
    } catch (e) {
      print('Durum güncelleme hatası: $e');
    }
  }

}