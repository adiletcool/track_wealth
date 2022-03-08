import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/enums/market_types.dart';
import '../../data/enums/operation.dart';
import '../../data/model/asset/asset_model.dart';
import '../../data/model/asset/coinmarketcap/coinmarketcap_model.dart';
import '../../data/model/asset/moex/stock_model.dart';
import '../../utils/formatters.dart';
import 'operation_controller.dart';

class TradeOperationPageController extends OperationController {
  TradeOperationPageController();

  AssetModelWithMarketData mdAsset = Get.arguments;

  AssetType get assetType => mdAsset.assetType;

  bool get isStock => assetType == AssetType.stocks;
  bool get isCrypto => assetType == AssetType.crypto;
  bool get isCurrency => assetType == AssetType.currencies;
  bool get isBond => assetType == AssetType.bonds;

  int get assetPriceDecimals => mdAsset.priceDecimals;

  late num assetPrice;
  late int assetLotSize;

  @override
  late List<String> actions;

  @override
  RxString selectedAction = TradeAction.buy.name.obs;

  bool get isPurchase => selectedAction.value == 'buy';
  bool get isDividends => selectedAction.value == 'dividends';

  @override
  void selectAction(String action) => selectedAction.value = action;

  late TradeOperationData data;

  void updateData({bool isDividends = false}) => data.update(isDividends);
  void validateData() => data.validate();

  @override
  void addOperation() {
    // TODO
  }

  @override
  void onInit() {
    data = TradeOperationData(assetType, selectedAction);

    switch (assetType) {
      case AssetType.stocks:
        StockModelWithMarketData mdStock = mdAsset as StockModelWithMarketData;
        assetPrice = mdStock.lastPrice;
        actions = [TradeAction.buy, TradeAction.sell, MoneyAction.dividends].map((e) => e.name).toList();
        assetLotSize = mdStock.lotSize;
        data.price = assetPrice.toStringAsFixed(assetPriceDecimals);
        break;

      case AssetType.crypto:
        assetPrice = (mdAsset as CoinmarketcapModelWithMarketData).lastPrice;
        actions = TradeAction.values.map((a) => a.name).toList();
        assetLotSize = 1;
        data.price = assetPrice.toStringAsFixed(assetPriceDecimals);

        break;

      default:
        throw UnimplementedError(); // TODO
    }

    super.onInit();
  }
}

class TradeOperationData {
  final AssetType assetType;
  final RxString selectedAction;

  TradeOperationData(this.assetType, this.selectedAction);

  bool get isStock => assetType == AssetType.stocks;
  bool get isCrypto => assetType == AssetType.crypto;
  bool get isCurrency => assetType == AssetType.currencies;
  bool get isBond => assetType == AssetType.bonds;

  bool get isPurchase => selectedAction.value == 'buy';
  bool get isDividends => selectedAction.value == 'dividends';

  GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> quantityFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> feeFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> dividendsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> divFeeFormKey = GlobalKey<FormState>();

  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<TextEditingController> quantityController = TextEditingController().obs;
  Rx<TextEditingController> feeController = TextEditingController().obs;

  Rx<TextEditingController> dividendsController = TextEditingController().obs;
  Rx<TextEditingController> divFeeController = TextEditingController().obs;

  String get currencySymbol => isCrypto ? '\$' : '₽';

  // BUY SELL
  String get price => priceController.value.text;
  set price(value) => priceController.value.text = value;
  num get numPrice => num.tryParse(price) ?? 0;
  String get priceFormatted => numPrice.currencyFormat(symbol: currencySymbol);

  String get quantity => quantityController.value.text;
  set quantity(value) => quantityController.value.text = value;
  num get numQuantity => num.tryParse(quantity) ?? 0;

  String get fee => feeController.value.text;
  set fee(value) => feeController.value.text = value;
  num get numFee => fee == '' ? 0 : num.tryParse(fee) ?? 0;

  // DIVIDENDS

  String get dividends => dividendsController.value.text;
  set dividends(value) => dividendsController.value.text = value;
  num get numDividends => num.tryParse(dividends) ?? 0;
  String get dividendsFormatted => numDividends.currencyFormat(symbol: '₽');

  String get divFee => divFeeController.value.text;
  set divFee(value) => divFeeController.value.text = value;
  num get numDivFee => divFee == '' ? 0 : num.tryParse(divFee) ?? 0;

  // TOTAL
  num get operationTotal {
    if (isDividends) return numDividends - numDivFee;
    return numPrice * numQuantity + numFee * (isPurchase ? 1 : -1);
  }

  String get operationTotalFormatted => operationTotal.currencyFormat(symbol: currencySymbol);

  void update(bool isDividends) {
    // updates with when user changes textfield

    if (!isDividends) {
      priceController.update((val) {});
      quantityController.update((val) {});
      feeController.update((val) {});
    } else {
      dividendsController.update((val) {});
    }
  }

  String? validateQuantity(String? value, {String onNull = 'Введите количество'}) {
    if ([null, ''].contains(value)) return 'enter_the_quantity'.tr;
    if (int.parse(value!) == 0) return 'enter_positive_number'.tr;
    return null;
  }

  String? validatePrice(String? value) {
    if ([null, ''].contains(value)) return 'enter_the_price'.tr;
    if (num.parse(value!) == 0) return 'enter_positive_number'.tr;
    return null;
  }

  String? validateDividends(String? value) {
    if ([null, ''].contains(value)) return 'enter_the_price'.tr;
    if (num.parse(value!) == 0) return 'enter_positive_number'.tr;
    return null;
  }
  // TODO: validate operationTotal > 0

  void validate() {}
}
