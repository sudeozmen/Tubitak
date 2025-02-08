import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici{
  String? kullaniciID;
  String? telefon;
  GeoPoint? konum;

  Kullanici({this.kullaniciID,this.telefon,this.konum});

  factory Kullanici.fromSnapshot(DocumentSnapshot snapshot){
    return Kullanici(
      kullaniciID: snapshot.id,
      telefon: snapshot["telefon"],
      konum: snapshot["konum"],
    );
  }
}

class Basvuru{
  String? basvuruID;
  String? atikTuru;
  String? agirlik;
  String? tasimaSirketi;
  String? Durum;
  String? Adres;
  String? userId;

  Basvuru({this.basvuruID,this.atikTuru,this.agirlik,this.tasimaSirketi,this.Durum,this.Adres,this.userId});

  factory Basvuru.fromSnapshot(DocumentSnapshot snapshot){
    return Basvuru(
      basvuruID: snapshot.id,
      atikTuru: snapshot["atikTuru"],
      agirlik: snapshot["agirlik"],
      tasimaSirketi: snapshot["tasimaSirketi"],
      Durum:snapshot ["Durum"],
      Adres: snapshot ["Adres"],
      userId:snapshot ["userId"],
    );
  }
}

class Kayit{
  String? isim;
  String? email;
  String? sifre;
  String? adres;
  String? key;
  String? kullaniciId;
  Kayit({this.isim,this.email,this.sifre,this.adres,this.key,this.kullaniciId});
  factory Kayit.fromSnapshot(DocumentSnapshot snapshot){
    return Kayit(
      isim: snapshot["isim"],
      email: snapshot["email"],
      sifre: snapshot["sifre"],
      adres: snapshot["adres"],
      key: snapshot["key"],
      kullaniciId: snapshot["kullaniciId"],
    );
  }
}

class AddressInfo {
  String? country;
  String? state;
  String? city;
  String? address;

  AddressInfo({this.country, this.state, this.city, this.address});

  bool isValid() {
    return country != null && state != null && city != null && address != null;
  }

  @override
  String toString() {
    return '$address $city/$state/$country';
  }
}
