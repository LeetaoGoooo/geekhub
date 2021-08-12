

import 'package:geekhub/model/tabmodel.dart';
import 'package:flutter/material.dart';

List<TabModel> TABS = <TabModel>[
    TabModel('全部', 'all'),
    TabModel("拍卖", 'auctions'),
    TabModel('闲置', 'second_hands'),
    TabModel('分子', 'molecules'),
    TabModel('拼车', 'group_buys'),
    TabModel('产品', 'works'),
    TabModel('服务', 'services')
];

final Color primaryColor = Colors.white;
final Color secondaryColor  = Colors.black;