import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woju/model/item/add_item_state_model.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/model/item/location_model.dart';
import 'package:woju/service/debug_service.dart';

/// # ItemModel
///
/// - 상품 정보를 담는 모델
///
/// ### Fields
///
/// - [CategoryModel]? - [itemCategory] : 상품 카테고리 리스트
/// - [List]<[Uint8List]> - [itemImageList] : 상품 이미지 리스트
/// - [String]? - [itemName] : 상품 이름
/// - [String]? - [itemDescription] : 상품 설명
/// - [int]? - [itemPrice] : 상품 가격
/// - [double]? - [itemFeelingOfUse] : 사용감 정보
///
/// ### Methods
///
/// - [ItemModel] -[initial] : 초기 상태 반환
/// - [int] - [countOfItemImage] : 상품 이미지 개수 반환
/// - [bool] - [isValidItemCategory] : 상품 카테고리 리스트 유효성 검사
/// - [bool] - [isValidItemImageList] : 상품 이미지 리스트 유효성 검사
/// - [bool] - [isValidItemName] : 상품 이름 유효성 검사
/// - [bool] - [isValidItemDescription] : 상품 설명 유효성 검사
/// - [bool] - [isValidItemPrice] : 상품 가격 유효성 검사
/// - [bool] - [isValidItemPriceStatic] : 상품 가격 유효성 검사 (static)
/// - [bool] - [isValidFeelingOfUse] : 사용감 정보 유효성 검사
/// - [bool] - [isValidItemModel] : ItemModel 유효성 검사
/// - [String] - [convertFromIntToFormalString] : 상품 가격 표기 변경
/// - [int] - [maxCountOfItemImage] : 상품 이미지 리스트 최대 개수 반환
/// - [double] - [squareHeightOfImage] : 상품 이미지 정사각형 높이 반환
/// - [int] - [crossAxisCountOfImageList] : 상품 이미지 가로 개수 반환
/// - [double] - [containerHeightOfImageList] : 상품 이미지 Container 높이 반환
/// - [String] - [printItemCategoryToString] : 상품 카테고리 리스트 문자열 반환
/// - [void] - [swapItemImageListIndex] : 상품 이미지 리스트 인덱스 변경
/// - [String] - [printItemFeelingOfUseToString] : 사용감 정보 문자열 반환
/// - [Uint8List] - [feelingOfUseExampleImage] : 사용감 정보 예시 이미지 반환
/// - [IconData] - [feelingOfUseIcon] : 사용감 아이콘 반환
/// - [Map]<[String], [dynamic]>] - [toJson] : 모델을 JSON 형태로 변환
/// - [ItemModel] - [fromJson] : JSON 형태를 모델로 변환
///
class ItemModel {
  /// ### 상품 카테고리 리스트
  final CategoryModel? itemCategory;

  /// ### 상품 이미지 리스트
  final List<Uint8List> itemImageList;

  /// ### 상품 이름
  final String? itemName;

  /// ### 상품 설명
  final String? itemDescription;

  /// ### 상품 가격
  ///
  /// - 사용자가 입력하거나 추천된 가격
  ///
  final int? itemPrice;

  /// ### 사용감 정보
  ///
  /// - 0 : 미개봉
  /// - 1 : 단순 개봉
  /// - 2 : 사용감 있음
  /// - 3 : 사용감 많음
  /// - 4 : 파손 흔적 또는 고장 있음
  ///
  final double itemFeelingOfUse;

  ItemModel({
    required this.itemCategory,
    required this.itemImageList,
    this.itemName,
    this.itemDescription,
    this.itemPrice,
    required this.itemFeelingOfUse,
  });

  /// ### 초기 상태 반환
  static ItemModel initial() {
    return ItemModel(
      itemCategory: null,
      itemImageList: [],
      itemFeelingOfUse: 0,
    );
  }

  /// ### 모델 업데이트 메서드
  ItemModel copyWith({
    CategoryModel? itemCategory,
    bool? setToNullItemCategory,
    List<Uint8List>? itemImageList,
    String? itemName,
    String? itemDescription,
    int? itemPrice,
    bool? setToNullItemPrice,
    double? feelingOfUse,
  }) {
    return ItemModel(
      itemCategory: (setToNullItemCategory == true)
          ? null
          : (itemCategory ?? this.itemCategory),
      itemImageList: itemImageList ?? this.itemImageList,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      itemPrice:
          (setToNullItemPrice == true) ? null : (itemPrice ?? this.itemPrice),
      itemFeelingOfUse: feelingOfUse ?? this.itemFeelingOfUse,
    );
  }

  /// ### 상품 이미지 개수 반환
  ///
  /// - 버튼을 고려하여, 상품 이미지 리스트 개수 + 1 반환
  ///
  /// #### Returns
  /// - [int] - 버튼을 고려한 상품 이미지 개수
  ///
  int countOfItemImage() {
    return itemImageList.length + 1;
  }

  /// ### 상품 카테고리 리스트 유효성 검사
  ///
  /// - 상품 카테고리가 null인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemCategory() {
    return itemCategory != null;
  }

  /// ### 상품 이미지 리스트 유효성 검사
  ///
  /// - 상품 이미지 리스트가 비어있는 경우 false 반환
  /// - 상품 이미지 리스트 개수가 최대 개수를 초과하는 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemImageList() {
    return itemImageList.isNotEmpty && !isMaxCountOfItemImageList();
  }

  /// ### 상품 이미지 리스트 최대 개수 초과 여부 반환
  ///
  /// #### Returns
  /// - [bool] - 최대 개수 초과 여부
  ///
  bool isMaxCountOfItemImageList() {
    return countOfItemImage() > maxCountOfItemImage();
  }

  /// ### 상품 이름 유효성 검사
  ///
  /// - 상품 이름이 비어있거나 5글자 미만인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemName() {
    final String? itemName = this.itemName;
    if (itemName == null) return false;

    return itemName.length >= 5 && itemName.length <= 30;
  }

  /// ### 상품 설명 유효성 검사
  ///
  /// - 상품 설명이 비어있거나 10글자 미만인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemDescription() {
    final String? itemDescription = this.itemDescription;

    if (itemDescription == null) return false;

    return itemDescription.length >= 10 && itemDescription.length <= 300;
  }

  /// ### 상품 가격 유효성 검사
  ///
  /// - 상품 가격이 비어있거나 0원 미만, 100,000,000,000원 이상인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemPrice() {
    if (itemPrice == null) {
      return false;
    }

    return isValidItemPriceStatic(itemPrice ?? 0);
  }

  /// ### 상품 가격 유효성 검사 (static)
  /// - 상품 가격이 0원 미만, 100,000,000,000원 이상인 경우 false 반환
  ///
  /// #### Parameters
  /// - [int] - [price] : 상품 가격
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  static bool isValidItemPriceStatic(int price) {
    return price >= 0 && price <= 100000000000;
  }

  /// ### 사용감 정보 유효성 검사
  ///
  /// - 사용감 정보가 비어있거나 0 미만, 4 초과인 경우 false 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidFeelingOfUse() {
    return itemFeelingOfUse >= 0 && itemFeelingOfUse <= 4;
  }

  /// ### ItemModel 유효성 검사
  ///
  /// - 모든 필드가 유효한 경우 true 반환
  ///
  /// #### Returns
  /// - [bool] - 유효성 검사 결과
  ///
  bool isValidItemModel() {
    return isValidItemCategory() &&
        isValidItemImageList() &&
        isValidItemName() &&
        isValidItemDescription() &&
        isValidItemPrice() &&
        isValidFeelingOfUse();
  }

  /// ### 상품 가격 표기 변경
  ///
  /// - 원래 가격이 10000원인 경우, 10,000원으로 반환
  ///
  /// #### Returns
  /// - [String] - 표기 변경된 가격
  ///
  String convertFromIntToFormalString({bool? displayKRW}) {
    String itemPriceString = itemPrice.toString();

    /// 정규식을 사용하여 3자리마다 콤마(,) 추가
    itemPriceString = itemPriceString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    // printd('itemPriceString : $itemPriceString');

    return itemPriceString + (displayKRW == true ? '원' : '');
  }

  /// ### 상품 이미지 리스트 최대 개수 반환
  int maxCountOfItemImage() {
    return 5;
  }

  /// ### 상품 이미지 정사각형 높이 반환
  double squareHeightOfImage() {
    return 130;
  }

  /// ### 상품 이미지 가로 개수 반환
  int crossAxisCountOfImageList(double screenWidth) {
    return (screenWidth / squareHeightOfImage()).floor();
  }

  /// ### 상품 이미지 Container 높이 반환
  ///
  /// - 화면 너비를 입력 받아 상품 이미지 Container 높이 반환
  ///
  /// #### Parameters
  /// - [double] - [screenWidth] : 화면 너비
  ///
  /// #### Returns
  /// - [double] - 상품 이미지 Container 높이
  ///
  double containerHeightOfImageList(double screenWidth) {
    // 정사각형이 몇 개 가로로 들어갈 수 있는지 계산
    int crossAxisCountOfImageList =
        (screenWidth / squareHeightOfImage()).floor();

    // Container 높이 구하기 (현재 아이템 갯수 / 가로 개수 * 정사각형 높이).ceilToDouble() + 16(여백)
    return ((countOfItemImage()) / crossAxisCountOfImageList).ceilToDouble() *
            squareHeightOfImage() +
        16;
  }

  /// ### 상품 카테고리 문자열 반환
  ///
  /// - 상품 카테고리를 문자열로 반환
  ///
  /// #### Returns
  /// - [String] - 상품 카테고리 문자열
  ///
  String printItemCategoryToString() {
    if (itemCategory == null) {
      return "addItem.itemCategory.selectCategory";
    }

    return (itemCategory as CategoryModel).category.localizedName;
  }

  /// ### 사용감 정보 문자열 반환
  ///
  /// - 사용감 정보를 문자열로 반환
  ///
  /// #### Parameters
  /// - [double]? - [index] : 별도의 index가 없는 경우, [itemFeelingOfUse] 사용
  ///
  /// #### Returns
  /// - [String] 사용감 정보 문자열
  ///
  String printItemFeelingOfUseToString(double? index) {
    final double switchIndex = index ?? itemFeelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return "addItem.feelingOfUse.label.unopened.title";
      case 1:
        return "addItem.feelingOfUse.label.simpleUnpack.title";
      case 2:
        return "addItem.feelingOfUse.label.used.title";
      case 3:
        return "addItem.feelingOfUse.label.muchUsed.title";
      case 4:
        return "addItem.feelingOfUse.label.broken.title";
      default:
        return "addItem.feelingOfUse.description";
    }
  }

  /// TODO: 이미지 삽입
  /// ### 사용감 정보 예시 이미지 반환
  ///
  /// - 사용감 정보에 따라 예시 이미지 반환
  ///
  /// #### Returns
  /// - [Uint8List] - 사용감 정보 예시 이미지
  ///
  Uint8List feelingOfUseExampleImage(double? index) {
    final double switchIndex = index ?? itemFeelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return Uint8List.fromList([]);
      case 1:
        return Uint8List.fromList([]);
      case 2:
        return Uint8List.fromList([]);
      case 3:
        return Uint8List.fromList([]);
      case 4:
        return Uint8List.fromList([]);
      default:
        return Uint8List.fromList([]);
    }
  }

  /// ### 사용감 정보 설명 문자열 반환
  ///
  /// #### Parameters
  /// - [double]? - [index] : 별도의 index가 없는 경우, [itemFeelingOfUse] 사용
  ///
  /// #### Returns
  /// - [String] 사용감 정보 설명 문자열
  ///
  String printItemFeelingOfUseDescriptionToString(double? index) {
    final double switchIndex = index ?? itemFeelingOfUse;
    switch (switchIndex.toInt()) {
      case 0:
        return "addItem.feelingOfUse.label.unopened.description";
      case 1:
        return "addItem.feelingOfUse.label.simpleUnpack.description";
      case 2:
        return "addItem.feelingOfUse.label.used.description";
      case 3:
        return "addItem.feelingOfUse.label.muchUsed.description";
      case 4:
        return "addItem.feelingOfUse.label.broken.description";
      default:
        return "addItem.feelingOfUse.description";
    }
  }

  /// TODO: 아이콘 변경
  /// ### 사용감 아이콘 반환
  ///
  /// - 사용감 정보에 따라 아이콘 반환
  ///
  /// #### Parameters
  /// - [double?] - [index] : 사용감 정보
  ///
  /// #### Returns
  /// - [IconData] - 사용감 아이콘
  ///
  IconData feelingOfUseIcon(double? index) {
    final double switchIndex = index ?? itemFeelingOfUse;

    switch (switchIndex) {
      case 0:
        return CupertinoIcons.sparkles;
      case 1:
        return CupertinoIcons.envelope_open_fill;
      case 2:
        return CupertinoIcons.star_lefthalf_fill;
      case 3:
        return CupertinoIcons.star;
      case 4:
        return Icons.broken_image;
      default:
        return Icons.circle;
    }
  }

  /// ### 상품 이미지 리스트 인덱스 변경
  ///
  /// - 상품 이미지 리스트의 인덱스를 변경
  ///
  /// #### Parameters
  ///
  /// - [int] - [oldIndex] : 변경 전 인덱스
  /// - [int] - [newIndex] : 변경 후 인덱스
  ///
  void swapItemImageListIndex(int oldIndex, int newIndex) {
    // newIndex가 oldIndex보다 큰 경우, newIndex를 1 감소
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 상품 이미지 리스트에서 이미지를 꺼내고, 새로운 인덱스에 추가
    final Uint8List image = itemImageList.removeAt(oldIndex);
    itemImageList.insert(newIndex, image);
  }

  /// ### [Map]<[String], [dynamic]> - [toJson]
  /// - 모델을 JSON 형태로 변환
  ///
  /// #### Returns
  /// - [Map]<[String], [dynamic]> - JSON 형태로 변환된 모델
  ///
  Map<String, dynamic> toJson() {
    return {
      'itemCategory': itemCategory?.getItemNameLast(),
      'itemImages': itemImageList.map((e) => e.toList()).toList(),
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemFeelingOfUse': itemFeelingOfUse,
    };
  }

  /// ### [ItemModel] - [fromJson]
  /// - JSON 형태를 모델로 변환
  ///
  /// #### Parameters
  /// - [Map]<[String], [dynamic]> - [json] : JSON 형태
  ///
  /// #### Returns
  /// - [ItemModel] - 모델로 변환된 JSON
  ///
  static ItemModel fromJson(Map<String, dynamic> json) {
    try {
      // buffer 이미지 리스트를 Uint8List로 변환
      final List<Uint8List> imageList =
          (json['itemImages'] as List).map((item) {
        final List<int> data = List<int>.from(item['data']);
        return Uint8List.fromList(data);
      }).toList();
      // printd("imageList.length: ${imageList.length}");

      // TODO: double로 변환
      final feelingOfUse = json['itemFeelingOfUse'].toDouble();

      return ItemModel(
        itemCategory: CategoryModel.fromString(json['itemCategory']),
        itemImageList: imageList,
        itemName: json['itemName'],
        itemDescription: json['itemDescription'],
        itemPrice: json['itemPrice'],
        itemFeelingOfUse: feelingOfUse,
      );
    } catch (e) {
      // printd("fromJson error: $e");
      return ItemModel.initial();
    }
  }
}

/// # [ItemDetailModel]
/// - 서버로부터 받아온 상품 상세 정보를 담는 모델
/// - [ItemModel]을 extends하여 사용
///
/// ### Fields
/// - [String] - [itemUUID] : 상품 UUID
/// - [CategoryModel] - [itemCategory] : 상품 카테고리
/// - [String] - [itemName] : 상품 이름
/// - [List]<[Uint8List]> - [itemImageList] : 상품 이미지 리스트
/// - [String] - [itemDescription] : 상품 설명
/// - [int] - [itemPrice] : 상품 가격
/// - [double] - [itemFeelingOfUse] : 사용감 정보
/// - [Location] - [itemBarterPlace] : 교환 장소
/// - [String] - [itemOwnerUUID] : 상품 소유자 UUID
/// - [DateTime] - [createdAt] : 상품 생성 시간
/// - [DateTime] - [updatedAt] : 상품 업데이트 시간
/// - [int] - [itemStatus] : 상품 등록 상태
/// - [int] - [itemViews] : 상품 조회 수
/// - [List<String>] - [itemLikedUsers] : 상품에 좋아요를 누른 사용자 UUID 리스트
///
/// ### Methods
/// - [ItemDetailModel] - [initial] : 초기 상태 반환
/// - [Map]<[String], [dynamic]> - [toJson] : 모델을 JSON 형태로 변환
/// - [ItemDetailModel] - [fromJson] : JSON 형태를 모델로 변환
/// - [ItemDetailModel] - [copyWith] : 상태를 복사하여 새로운 상태를 반환한다.
/// - [String] - [createItemDateToString] : 상품 생성 시간 문자열 반환
/// - [String] - [getItemStatusToString] : 상품 등록 상태 문자열 반환
/// - [ItemDetailModel] - [itemDetailModelFromAddItemStateModel] : AddItemStateModel를 ItemDetailModel로 변환
///
class ItemDetailModel extends ItemModel {
  /// ### 상품 UUID
  final String itemUUID;

  /// ### 교환 장소
  final Location itemBarterPlace;

  /// ### 상품 소유자 UUID
  final String itemOwnerUUID;

  /// ### 상품 생성 시간
  final DateTime createdAt;

  /// ### 상품 업데이트 시간
  final DateTime updatedAt;

  /// ### 상품 등록 상태
  /// - 0 : 예약 없음
  /// - 1 : 거래 중
  /// - 2 : 거래 완료
  ///
  final int itemStatus;

  /// ### 상품 조회 수
  final int itemViews;

  /// ### 상품에 좋아요를 누른 사용자 UUID 리스트
  final Map<String, String> itemLikedUsers;

  /// ### 상품에 싫어요를 누른 사용자 UUID 리스트
  final List<String> itemUnlikedUsers;

  /// ### 상품에 매칭된 사용자 UUID 리스트
  final Map<String, String> itemMatchedUsers;

  ItemDetailModel({
    required this.itemUUID,
    required this.itemBarterPlace,
    required this.itemOwnerUUID,
    required this.createdAt,
    required this.updatedAt,
    required this.itemStatus,
    required this.itemViews,
    required this.itemLikedUsers,
    required this.itemUnlikedUsers,
    required this.itemMatchedUsers,
    required CategoryModel super.itemCategory,
    required super.itemImageList,
    required String super.itemName,
    required String super.itemDescription,
    required int super.itemPrice,
    required super.itemFeelingOfUse,
  });

  /// ### 초기 상태 반환
  static ItemDetailModel initial() {
    return ItemDetailModel(
      itemUUID: '',
      itemCategory: CategoryModel.categories.first,
      itemBarterPlace: Location.defaultLocation,
      itemOwnerUUID: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemStatus: 0,
      itemViews: 0,
      itemLikedUsers: {},
      itemUnlikedUsers: [],
      itemMatchedUsers: {},
      itemImageList: [],
      itemName: '',
      itemDescription: '',
      itemPrice: 0,
      itemFeelingOfUse: 0,
    );
  }

  /// ### [Map]<[String], [dynamic]> - [toJson]
  /// - 모델을 JSON 형태로 변환
  ///
  /// #### Returns
  /// - [Map]<[String], [dynamic]> - JSON 형태로 변환된 모델
  ///
  @override
  Map<String, dynamic> toJson() {
    return {
      'itemUUID': itemUUID,
      'itemCategory': itemCategory?.getItemNameLast(),
      'itemImages': itemImageList.map((e) => e.toList()).toList(),
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemFeelingOfUse': itemFeelingOfUse,
      'itemBarterPlace': itemBarterPlace.toJson(),
      'itemOwnerUUID': itemOwnerUUID,
      'itemCreatedAt': createdAt.toIso8601String(),
      'itemUpdatedAt': updatedAt.toIso8601String(),
      'itemStatus': itemStatus,
      'itemViews': itemViews,
      'itemLikedUsers': itemLikedUsers.toString(),
      'itemUnlikedUsers': itemUnlikedUsers.toString(),
      'itemMatchedUsers': itemMatchedUsers.toString(),
    };
  }

  /// ### [ItemDetailModel] - [fromJson]
  /// - JSON 형태를 모델로 변환
  ///
  /// #### Parameters
  /// - [Map]<[String], [dynamic]> - [json] : JSON 형태
  ///
  /// #### Returns
  /// - [ItemDetailModel] - 모델로 변환된 JSON
  ///
  static ItemDetailModel fromJson(Map<String, dynamic> json) {
    try {
      // buffer 이미지 리스트를 Uint8List로 변환
      List<Uint8List> imageList = [];
      try {
        if (json['itemImages'] != null) {
          imageList = (json['itemImages'] as List).map((item) {
            final List<int> data = List<int>.from(item['data']);
            return Uint8List.fromList(data);
          }).toList();
          // printd("imageList.length: ${imageList.length}");
        } else {
          // printd("itemImages is null");
        }
      } catch (e) {
        // printd("imageList error: $e");
      }

      final itemUUID = json['itemUUID'];
      // printd("itemUUID: $itemUUID");
      final itemName = json['itemName'];
      // printd("itemName: $itemName");
      final itemDescription = json['itemDescription'];
      // printd("itemDescription: $itemDescription");
      final itemPrice = json['itemPrice'];
      // printd("itemPrice: $itemPrice");
      final itemOwnerUUID = json['itemOwnerUUID'];
      // printd("itemOwnerUUID: $itemOwnerUUID");
      final itemStatus = json['itemStatus'];
      // printd("itemStatus: $itemStatus");
      final itemViews = json['itemViews'];
      // printd("itemViews: $itemViews");
      final createdAt = DateTime.parse(json['createdAt']);
      // printd("createdAt: $createdAt");
      final updatedAt = DateTime.parse(json['updatedAt']);
      // printd("updatedAt: $updatedAt");
      final itemFeelingOfUse = (json['itemFeelingOfUse'] as int).toDouble();
      // printd("feelingOfUse: $itemFeelingOfUse");
      final itemCategory = CategoryModel.fromString(json['itemCategory']);
      // printd("itemCategory: $itemCategory");
      final itemBarterPlace = Location.fromJson(json['itemBarterPlace']);
      // printd("itemBarterPlace: $itemBarterPlace");
      final itemLikedUsers = Map<String, String>.from(json['itemLikedUsers']);
      // printd("itemLikedUsers: $itemLikedUsers");
      final itemUnlikedUsers = List<String>.from(json['itemUnlikedUsers']);
      // printd("itemUnlikedUsers: $itemUnlikedUsers");
      final itemMatchedUsers =
          Map<String, String>.from(json['itemMatchedUsers']);
      // printd("itemMatchedUsers: $itemMatchedUsers");

      return ItemDetailModel(
        itemUUID: itemUUID,
        itemCategory: itemCategory,
        itemImageList: imageList,
        itemName: itemName,
        itemDescription: itemDescription,
        itemPrice: itemPrice,
        itemFeelingOfUse: itemFeelingOfUse,
        itemBarterPlace: itemBarterPlace,
        itemOwnerUUID: itemOwnerUUID,
        createdAt: createdAt,
        updatedAt: updatedAt,
        itemStatus: itemStatus,
        itemViews: itemViews,
        itemLikedUsers: itemLikedUsers,
        itemUnlikedUsers: itemUnlikedUsers,
        itemMatchedUsers: itemMatchedUsers,
      );
    } catch (e) {
      printd("fromJson error: $e");
      return ItemDetailModel.initial();
    }
  }

  // TODO : Localizing 해야 함
  /// # [createItemDateToString]
  /// - 아이템 등록 날짜와 현 시간을 비교하여, 차이를 문자열로 반환한다.
  ///
  /// ### Returns
  /// - [String] : 아이템 등록 날짜와 현 시간의 차이 (ex. 1시간 전, Localized String)
  ///
  String createItemDateToString() {
    final now = DateTime.now();
    final uploadDate = createdAt.toLocal();

    final diff = now.difference(uploadDate);

    if (diff.inDays > 365) {
      return 'common.elapsedTime.year'
          .tr(namedArgs: {'year': (diff.inDays ~/ 365).toString()});
    } else if (diff.inDays > 30) {
      return 'common.elapsedTime.month'
          .tr(namedArgs: {'month': (diff.inDays ~/ 30).toString()});
    } else if (diff.inDays > 0) {
      return 'common.elapsedTime.day'
          .tr(namedArgs: {'day': diff.inDays.toString()});
    } else if (diff.inHours > 0) {
      return 'common.elapsedTime.hour'
          .tr(namedArgs: {'hour': diff.inHours.toString()});
    } else if (diff.inMinutes > 0) {
      return 'common.elapsedTime.minute'
          .tr(namedArgs: {'minute': diff.inMinutes.toString()});
    } else {
      return 'common.elapsedTime.now'.tr();
    }
  }

  /// # [getItemStatusToString]
  /// - 아이템 상태를 문자열로 반환한다.
  ///
  /// ### Parameters (Optional)
  /// - [int]? - [itemStatus] : 아이템 상태 (default: [itemStatus])
  ///
  /// ### Returns
  /// - [String] : 아이템 상태 문자열 (Localized String)
  ///
  String getItemStatusToString({int? itemStatus}) {
    itemStatus ??= this.itemStatus;
    switch (itemStatus) {
      case 0:
        return 'myItem.myItemList.filterStatus.no_reservation'.tr();
      case 1:
        return 'myItem.myItemList.filterStatus.reserved'.tr();
      case 2:
        return 'myItem.myItemList.filterStatus.completed'.tr();
      default:
        return 'common.itemStatus.all'.tr();
    }
  }

  /// # [itemDetailModelFromAddItemStateModel]
  /// - AddItemStateModel를 ItemDetailModel로 변환
  ///
  /// ### Parameters
  /// - [AddItemStateModel] - [addItemModel] : AddItemStateModel
  /// - [String] - [itemOwnerUUID] : 상품 소유자 UUID
  /// - [int] - [itemStatus] : 상품 상태
  ///
  /// ### Returns
  /// - [ItemDetailModel] : ItemDetailModel
  ///
  static ItemDetailModel itemDetailModelFromAddItemStateModel(
      AddItemStateModel addItemModel, String itemOwnerUUID, int itemStatus) {
    return ItemDetailModel(
      itemUUID: addItemModel.itemUUID ?? '',
      itemCategory:
          addItemModel.itemModel.itemCategory ?? CategoryModel.categories.first,
      itemImageList: addItemModel.itemModel.itemImageList,
      itemName: addItemModel.itemModel.itemName ?? '',
      itemDescription: addItemModel.itemModel.itemDescription ?? '',
      itemPrice: addItemModel.itemModel.itemPrice ?? 0,
      itemFeelingOfUse: addItemModel.itemModel.itemFeelingOfUse,
      itemBarterPlace: addItemModel.barterPlace ?? Location.defaultLocation,
      itemOwnerUUID: itemOwnerUUID,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemStatus: itemStatus,
      itemViews: 0,
      itemLikedUsers: {},
      itemUnlikedUsers: [],
      itemMatchedUsers: {},
    );
  }
}
