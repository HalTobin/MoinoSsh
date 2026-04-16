import 'package:data/db/server_profile_database.dart';
import 'package:data/db/dao/server_profile_dao.dart';
import 'package:data/db/dao/favorite_service_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DbProvider extends StatelessWidget {
  final Widget child;

  const DbProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => (ServerProfileDatabase())),
          Provider(create: (context) => (ServerProfileDao(context.read()))),
          Provider(create: (context) => (FavoriteServiceDao(context.read())))
        ],
        child: child
    );
  }
}