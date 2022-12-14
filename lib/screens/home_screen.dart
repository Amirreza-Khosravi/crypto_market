import 'package:crypto_market/data/model/crypto.dart';
import 'package:crypto_market/screens/coin_List.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.png'),
            ),
            SpinKitWave(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.framMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinScreen(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
