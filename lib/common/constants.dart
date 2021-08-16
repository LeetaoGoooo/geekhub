import 'package:geekhub/model/post_theme.dart';
import 'package:geekhub/model/tabmodel.dart';
import 'package:flutter/material.dart';

class Constants {
  static final List<TabModel> TABS = <TabModel>[
    TabModel('全部', 'all'),
    TabModel("拍卖", 'auctions'),
    TabModel('闲置', 'second_hands'),
    TabModel('分子', 'molecules'),
    TabModel('拼车', 'group_buys'),
    TabModel('产品', 'works'),
    TabModel('服务', 'services')
  ];

  static final Color primaryColor = Colors.white;
  static final Color secondaryColor = Colors.black;

  static final List<PostTheme> POST_THEMES = <PostTheme>[
    PostTheme(
        index: 0,
        url: "https://www.geekhub.com/posts/new",
        name: "话题",
        title: "发布话题"),
    PostTheme(
        index: 1,
        url: "https://www.geekhub.com/second_hands/new",
        name: "闲置",
        title: "发布二手"),
    PostTheme(
        index: 2,
        url: "https://www.geekhub.com/auctions/new",
        name: "拍卖",
        title: "发布拍卖"),
    PostTheme(
        index: 3,
        url: "https://www.geekhub.com/molecules/new",
        name: "分子",
        title: "发布分子抢楼"),
    PostTheme(
        index: 4,
        url: "https://www.geekhub.com/group_buys/new",
        name: "拼车",
        title: "发布拼车"),
    PostTheme(
        index: 5,
        url: "https://www.geekhub.com/works/new",
        name: "产品",
        title: "发布产品"),
    PostTheme(
        index: 6,
        url: "https://www.geekhub.com/services/new",
        name: "服务",
        title: "发布服务")
  ];

  static Map<String, String> POST_GROUPS = {
    "1": "极客广场",
    "2": "争议终端组",
    "3": "Apple Park",
    "4": "安卓联盟",
    "6": "我要做分子",
    "7": "拍卖会场",
    "8": "拆箱小组",
    "10": "站务管理",
    "11": "文艺复兴™",
    "12": "域名研究所",
    "13": "搞机会社",
    "14": "读书治百病",
    "15": "极客玩家",
    "16": "饮食男女",
    "17": "DIY创意小组",
    "18": "摄影分享",
    "19": "大家都在看什么",
    "20": "geekhub hack",
    "21": "剪羊毛技术研发中心",
    "55": "资源分享小组"
  };
}


enum PostType {
  post,
  secondHands,
  auctions,
  molecules,
  groupBuys,
  works,
  services
}