/// @file   :   second_hands_model
/// @author :   leetao
/// @date   :   2021/8/18 7:51 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class SecondHands {
  String title;
  String image;
  String productName;
  String quality;
  int price;
  int normalPrice;
  String express; // wuliu;
  String contact;
  String content;
  String clubId;
  String shopId = "0";
  String authenticityToken;

  SecondHands({this.title,
    this.image,
    this.productName,
    this.quality,
    this.price,
    this.normalPrice,
    this.express,
    this.contact,
    this.content,
    this.clubId,
    this.shopId,
    this.authenticityToken});

  Map toJson() {
    return {
      "authenticity_token":this.authenticityToken,
      "second_hand[title]":this.title,
      "second_hand[product_name]":this.productName,
      "second_hand[quality]":this.quality,
      "second_hand[price]":this.price,
      "second_hand[normal_price]":this.normalPrice,
      "second_hand[wuliu]":this.express,
      "second_hand[contact]":this.contact,
      "second_hand[content]":this.content,
      "second_hand[image]":this.image,
      "second_hand[club_id]":this.clubId,
      "second_hand[shop_id]":this.shopId
    };
  }
}