import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/basvuru.dart';
import 'package:deneme_a/kayitekrani.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'as fire;
import 'basvuruGecmisi.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String kullaniciId="";
  String adres="";

  List<String> hashList = [];
  List<List<String>> transactionLogsList = []; // Değişiklik burada
  String contractAddress = "0x1A07c26ad65B60F26646ef979c466EAbD3866823";
  String apiKey = "6K387FT1K9NUE9VASS8WYQIGBDS8PMIFPH"; // Gerçek API anahtarınız ile değiştirin
  //String address = "0x7222233601152dd45b85FBc95126b29a7461e260";


  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    kullaniciId = user!.uid;

    try {
      fire.CollectionReference users = fire.FirebaseFirestore.instance.collection('kayit');
      fire.QuerySnapshot querySnapshot = await users.where('kullaniciId', isEqualTo: kullaniciId).get();
      if (querySnapshot.docs.isNotEmpty) {
        fire.DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        setState(() {
          adres = documentSnapshot['adres'];
        });
        fetchData();
      } else {
        print('Document does not exist for user with ID: $kullaniciId');
      }
    } catch (e) {
      print('Error fetching user info from Firestore: $e');
    }
  }


  Future<void> fetchData() async {
    await listTransactions(apiKey, adres);
    await getTransactionLogs(apiKey, hashList);
  }

  Future<void> listTransactions(String apiKey, String adres) async {
    final apiUrl =
        "https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$adres&apikey=$apiKey";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final parsedResult = json.decode(response.body);

        var transactions = parsedResult["result"];

        if (transactions != null && transactions is Iterable) {
          print("Kontrat İşlemleri:");

          for (var transaction in transactions) {
            var tempAddress = transaction["to"];

            if (tempAddress != null && tempAddress.toString().toLowerCase() == contractAddress.toLowerCase()) {
              var transactionHash = transaction["hash"];
              var blockNumber = transaction["blockNumber"];
              hashList.add(transactionHash.toString());

              var transactionLink = "https://sepolia.etherscan.io/tx/$transactionHash";

              print("- Block: $blockNumber, Transaction Link: $transactionLink");
            }
          }

          setState(() {});
        } else {
          print("Hata: Kullanıcının işlem geçmişi bulunamadı.");
        }
      } else {
        print("Hata: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> getTransactionLogs(String apiKey, List<String> transactionHashes) async {
    for (var transactionHash in transactionHashes) {
      final apiUrl =
          "https://api-sepolia.etherscan.io/api?module=proxy&action=eth_getTransactionReceipt&txhash=$transactionHash&apikey=$apiKey";

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final parsedResult = json.decode(response.body);

          var receipt = parsedResult["result"];

          if (receipt != null) {
            var logs = receipt["logs"];

            if (logs != null) {
              print("Transaction Hash için Loglar: $transactionHash");
              cleanAndPrintLogs(logs);
            } else {
              print("Transaction Hash için log bulunamadı: $transactionHash");
            }
          } else {
            print("Hata: Receipt bilgisi bulunamadı.");
          }
        } else {
          print("Hata: ${response.statusCode} - ${response.reasonPhrase}");
        }
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  void cleanAndPrintLogs(dynamic logs) {
    List<String> logsList = [];

    for (var log in logs) {
      var data = log["data"].toString();
      var cleanedData = cleanUnwantedCharacters(hexToAscii(data));
      logsList.add(addSpaceAfterEachWord(cleanedData));
    }

    // Doğrudan atama yerine her bir elemanı içeren bir listeyi ekleyin
    transactionLogsList.add(List.from(logsList));

    // State'i güncelleyerek widget'ın yeniden oluşturulmasını tetikle
    setState(() {});
  }

  int parseHexByte(String hexByte) {
    return int.parse(hexByte, radix: 16) & 0xFF;
  }

  String hexToAscii(String hex) {
    StringBuffer ascii = StringBuffer();

    for (int i = 0; i < hex.length; i += 2) {
      String hexByte = hex.substring(i, i + 2);
      try {
        int asciiByte = parseHexByte(hexByte);
        String asciiChar = String.fromCharCode(asciiByte);
        ascii.write(asciiChar);
      } catch (e) {
        ascii.write(" ");
      }
    }
    return ascii.toString();
  }

  String cleanUnwantedCharacters(String input) {
    var cleaned = String.fromCharCodes(input.codeUnits.where((c) => c >= 32 && c < 127));

    return cleaned.trim();
  }

  String addSpaceAfterEachWord(String input) {
    StringBuffer result = StringBuffer();

    for (var c in input.runes) {
      if (String.fromCharCode(c).toUpperCase() == String.fromCharCode(c)) {
        result.write(' ');
      }
      result.write(String.fromCharCode(c));
    }

    return result.toString();
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Blockchain İşlem Geçmişi'),
      ),
      body: ListView.builder(
        itemCount: transactionLogsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İşlem ${index + 1} Logs:'),
                  SizedBox(height: 9.0),
                  // Liste içerisindeki logları alt alta sıralamak için bir alt ListView
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactionLogsList[index].length,
                    itemBuilder: (context, subIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(transactionLogsList[index][subIndex]),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
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
