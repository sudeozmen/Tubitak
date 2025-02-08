import 'package:cloud_firestore/cloud_firestore.dart'as fire;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String adres="";
  String key="";
  String isim="";
  String basvuruAdres="";
  String basvuruTur="";
  String basvuruAgirlik="";
  String basvuruDurum="";



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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ethereum Akıllı Sözleşme Bağlantısı'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
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
                  isim,
                  basvuruAdres,
                  basvuruTur,
                  basvuruAgirlik,
                  basvuruDurum,
                ],
              ),
              chainId: 11155111,
            );
          },
          child: Text('Bağlan'),
        ),
      ),
    );
  }
}
