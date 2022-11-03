import 'package:crypto_market/data/constant/constants.dart';
import 'package:crypto_market/data/model/crypto.dart';


import 'package:crypto_market/screens/search_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoinScreen extends StatefulWidget {
  CoinScreen({Key? key, this.cryptoList}) : super(key: key);

  List<Crypto>? cryptoList;

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  List<Crypto>? cryptoList;
  bool isSearchLoadingVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text(
          'کیریپتو بازار',
          style: TextStyle(fontFamily: 'mr'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                              cryptoList: cryptoList,
                            )));
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: isSearchLoadingVisible,
              child: Text(
                '...در حال اپدیت اطلاعات رمز ارزها',
                style: TextStyle(color: greenColor, fontFamily: 'mr'),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  List<Crypto> freshData = await _getData();
                  setState(() {
                    cryptoList = freshData;
                  });
                },
                child: ListView.builder(
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _getListTile(cryptoList![index]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getListTile(Crypto crypto) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        title: Text(
          crypto.name,
          style: TextStyle(
            color: greenColor,
          ),
        ),
        subtitle: Text(
          crypto.symbol,
          style: TextStyle(
            color: greyColor,
          ),
        ),
        leading: SizedBox(
          width: 30,
          child: Center(
            child: Text(
              crypto.rank.toString(),
              style: TextStyle(color: greyColor),
            ),
          ),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    crypto.priceUsd.toStringAsFixed(2),
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    crypto.changePercent24Hr.toStringAsFixed(2),
                    style: TextStyle(
                      color: _getColorChangePercent(crypto.changePercent24Hr),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
                child: Center(
                  child: _getIconChangePercent(crypto.changePercent24Hr),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 26,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 26,
            color: greenColor,
          );
  }

  Color _getColorChangePercent(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.framMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _filterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }
    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
