import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:csc_picker/csc_picker.dart';
import 'package:deneme_a/kullanici.dart';
import 'package:deneme_a/kullaniciservisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'basvuruGecmisi.dart';
import 'kayitekrani.dart';


class basvuru extends StatefulWidget {
  @override
  State<basvuru> createState() => _basvuruState();
}

class _basvuruState extends State<basvuru> {
  final KullaniciServisi _servis = KullaniciServisi();

  AddressInfo selectedAddressInfo = AddressInfo();
  String? selectedRT;
  String? selectedRTW;
  String? selectedClient;
  String Durum = "İstek Alındı";


  String adres="";
  String key="";
  String isim="";
  String basvuruAdres="";
  String basvuruTur="";
  String basvuruAgirlik="";
  String basvuruDurum="";
  int _currentIndex = 1;



  String convertTurkishToEnglish(String input) {
    input = input.toLowerCase();
    input = input.replaceAll('ğ', 'g');
    input = input.replaceAll('ü', 'u');
    input = input.replaceAll('ş', 's');
    input = input.replaceAll('ı', 'i');
    input = input.replaceAll('ö', 'o');
    input = input.replaceAll('ç', 'c');
    return input;
  }
  String getConvertedClient() {
    return convertTurkishToEnglish(selectedClient ?? '');
  }
  String getConvertedType() {
    return convertTurkishToEnglish(selectedRT ?? '');
  }
  String getConvertedWeight() {
    return convertTurkishToEnglish(selectedRTW ?? '');
  }
  String getConvertedAction() {
    return convertTurkishToEnglish(Durum ?? '');
  }
  String getConvertedAddress() {
    return convertTurkishToEnglish(selectedAddressInfo.toString() ?? '');
  }


  @override
  void initState() {
    super.initState();
    _fetchAddressFromFirestore();
    _fetchFromFirestore();
  }

  Future<void> _fetchAddressFromFirestore() async {
    fire.CollectionReference users = fire.FirebaseFirestore.instance.collection('kayit');
    try {
      fire.DocumentSnapshot documentSnapshot = await users.doc('3s4CD0697Gj0x3iB32et').get();
      if (documentSnapshot.exists) {
        setState(() {
          adres = documentSnapshot['adres'];
          key=documentSnapshot['key'];
          isim=documentSnapshot['isim'];
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching address from Firestore: $e');
    }
  }

  Future<void> _fetchFromFirestore() async {
    fire.CollectionReference users = fire.FirebaseFirestore.instance.collection('basvuru');
    try {
      fire.DocumentSnapshot documentSnapshot = await users.doc('FlpZMQzclTvZnrN98pgm').get();
      if (documentSnapshot.exists) {
        setState(() {
          basvuruAdres = documentSnapshot['Adres'];
          basvuruTur = documentSnapshot['atikTuru'];
          basvuruAgirlik = documentSnapshot['agirlik'];
          basvuruDurum = documentSnapshot['Durum'];
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching address from Firestore: $e');
    }
  }

  setSelectedRT(String value) {
    setState(() {
      selectedRT = value;
    });
  }

  setSelectedRTW(String val) {
    setState(() {
      selectedRTW = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 10,),
                Container(child: Text("ATIK TÜRÜ SEÇİNİZ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.35),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        value: "Elektronik",
                        groupValue: selectedRT,
                        onChanged: (value) {
                          print("$value Türünü Seçtiniz");
                          setSelectedRT(value!);
                        },
                        activeColor: Colors.green,
                        toggleable: true,
                        title: const Text("Elektronik"),
                      ),
                      RadioListTile(
                        value: "Kağıt",
                        groupValue: selectedRT,
                        onChanged: (value) {
                          print("$value Türünü Seçtiniz");
                          setSelectedRT(value!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("Kağıt"),
                      ),
                      RadioListTile(
                        value: "Metal",
                        groupValue: selectedRT,
                        onChanged: ( value) {
                          print("$value Türünü Seçtiniz");
                          setSelectedRT(value!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("Metal"),
                      ),
                      RadioListTile(
                        value: "Plastik",
                        groupValue: selectedRT,
                        onChanged: (value) {
                          print("$value Türünü Seçtiniz");
                          setSelectedRT(value!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("Plastik"),
                      ),
                      RadioListTile(
                        value: "Diğer",
                        groupValue: selectedRT,
                        onChanged: (value) {
                          print("$value Türünü Seçtiniz");
                          setSelectedRT(value!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("Diğer"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(child: Text("AĞIRLIK SEÇİNİZ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.35),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        value: '500 gr',
                        groupValue: selectedRTW,
                        onChanged: (val) {
                          print("Ağırlığı $val olarak belirlediniz");
                          setSelectedRTW(val!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("500 Gr"),
                      ),
                      RadioListTile(
                        value: '1 Kg',
                        groupValue: selectedRTW,
                        onChanged: (val) {
                          print("Ağırlığı $val olarak belirlediniz");
                          setSelectedRTW(val!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("1 Kg"),
                      ),
                      RadioListTile(
                        value: '2 kg',
                        groupValue: selectedRTW,
                        onChanged: (val) {
                          print("Ağırlığı $val olarak belirlediniz");
                          setSelectedRTW(val!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("2 Kg"),
                      ),
                      RadioListTile(
                        value: '3 kg',
                        groupValue: selectedRTW,
                        onChanged: (val) {
                          print("Ağırlığı $val olarak belirlediniz");
                          setSelectedRTW(val!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("3 Kg"),
                      ),
                      RadioListTile(
                        value: 'Daha Fazla',
                        groupValue: selectedRTW,
                        onChanged: (val) {
                          print("Ağırlığı $val olarak belirlediniz");
                          setSelectedRTW(val!);
                        },
                        toggleable: true,
                        activeColor: Colors.green,
                        title: const Text("Daha Fazla"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<fire.QuerySnapshot>(
                        stream: fire.FirebaseFirestore.instance.collection('tasimaSirketi').snapshots(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem> clientsItems = [];
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            final clients = snapshot.data!.docs.reversed.toList();
                            for (var client in clients) {
                              clientsItems.add(DropdownMenuItem(
                                value: client['Ad'],
                                child: Text(client['Ad'],),
                              ),
                              );
                            }
                          }
                          return DropdownButton(
                            items: clientsItems,
                            onChanged: (clientValue) {
                              print("$clientValue Seçimini Yaptınız");
                              setState(() {
                                selectedClient = clientValue;
                              });
                            },
                            hint: Text("Taşıma Şirketi Seçiniz"),
                            value: selectedClient,
                            isExpanded: false,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            );
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children:[
                      CSCPicker(
                  layout: Layout.vertical,
                  onCountryChanged: (country) {
                    setState(() {
                      selectedAddressInfo.country=country;
                    });
                  },
                    countryFilter: [CscCountry.Turkey],
                        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    countrySearchPlaceholder: "Ülke Seçiniz",
                    countryDropdownLabel: "Ülke",
                  onStateChanged: (state) {
                    setState(() {
                      selectedAddressInfo.state=state;
                    });
                  },
                    stateSearchPlaceholder: "İl Seçiniz",
                    stateDropdownLabel: "İl",
                  onCityChanged: (city) {
                    setState(() {
                      selectedAddressInfo.city=city;
                    });
                  },
                    citySearchPlaceholder: "İlçe Seçiniz",
                    cityDropdownLabel: "İlçe",
                    dropdownDecoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                ),
                    SizedBox(height:10),
                  TextField(
                      maxLines: 5,
                      onChanged:(address){
                        setState(() {
                          selectedAddressInfo.address=address;
                        });
                      },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: "Açık Adres",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )
                    ),
                    ),
                     ],
                ),),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600)
                    ),
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      String convertedClient = getConvertedClient();
                      String convertedRT=getConvertedType();
                      String convertedRTW=getConvertedWeight();
                      String convertedaction=getConvertedAction();
                      String convertedAddress=getConvertedAddress();
                      if (user != null) {
                        if (selectedRT != null &&
                            selectedRTW != null &&
                            selectedClient != null &&
                            selectedAddressInfo.isValid()) {
                          String userId = user.uid;
                          _servis.addRequest(
                              selectedRT!, selectedRTW!, selectedClient!, Durum, selectedAddressInfo.toString(), userId);

                          String abiJson = await rootBundle.loadString('assets/abi.json');
                          final httpClient = Web3Client(
                              'https://sepolia.infura.io/v3/c1aba0c8eb6441d1be5ebf3c934aaf2a',
                              http.Client());
                          final credentials = EthPrivateKey.fromHex(key);
                          final ethAddress = EthereumAddress.fromHex(adres);
                          final contractAddress = EthereumAddress.fromHex('0x1A07c26ad65B60F26646ef979c466EAbD3866823');
                          final contract = DeployedContract(
                            ContractAbi.fromJson(abiJson, 'ApplicantProject'),
                            contractAddress,
                          );
                          final updateFunction = contract.function('writeRecourse');
                          var transactionId = await httpClient.sendTransaction(
                            credentials,
                            Transaction.callContract(
                              from: ethAddress,
                              maxGas: 900000,
                              value: EtherAmount.inWei(BigInt.zero),
                              contract: contract,
                              function: updateFunction,
                              parameters: [
                                ethAddress,
                                convertedClient,
                                convertedAddress,
                                convertedRT,
                                convertedRTW,
                                convertedaction,
                              ],
                            ),
                            chainId: 11155111,
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Başvuru Tamamlandı'),
                                content: Text('Başvuru talebiniz başarıyla tamamlandı.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Tamam'),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => basvuruGecmisi()));
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
                                content: Text('Lütfen tüm alanları doldurun.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Tamam'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text(
                        "KAYDET"),
                  ),
                ),
              ],
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
}