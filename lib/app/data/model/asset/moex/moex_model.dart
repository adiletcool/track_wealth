import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../asset_model.dart';

abstract class SearchMoexModel implements AssetModel {
  final String? isin;
  final String primaryBoardId;
  final String secId;
  final String shortName;
  final String name;

  @override
  String get subtitle => secId;

  @override
  String get displayName => shortName;

  SearchMoexModel.fromMap(Map<String, dynamic> map)
      : isin = map['isin'] ?? map['ISIN'],
        primaryBoardId = map['primary_boardid'] ?? map['BOARDID'],
        secId = map['secid'] ?? map['SECID'],
        shortName = map['shortname'] ?? map['SHORTNAME'],
        name = map['name'] ?? map['SECNAME'];

  Map<String, dynamic> toMap() => {
        "isin": isin,
        "primary_boardid": primaryBoardId,
        "secid": secId,
        "shortname": shortName,
        "name": name,
      };
}

abstract class MoexModelWithMarketData extends SearchMoexModel implements AssetModelWithMarketData {
  final Map<String, dynamic> _map;

  @override
  String get updateTime => DateFormat.yMMMEd(Get.deviceLocale?.languageCode).format(lastWorkingDay) + ' ' + _map['UPDATETIME'];

  int get weekday => DateTime.now().weekday;

  DateTime get lastWorkingDay => DateTime.now().subtract(Duration(days: weekday <= 5 ? 0 : weekday - 5));

  MoexModelWithMarketData.fromMap(this._map) : super.fromMap(_map);
}
