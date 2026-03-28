import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../entity/server_profile_entity.dart';
import '../server_profile_database.dart';

part 'server_profile_dao.g.dart';

@DriftAccessor(tables: [ServerProfiles])
class ServerProfileDao extends DatabaseAccessor<ServerProfileDatabase> with _$ServerProfileDaoMixin {
    ServerProfileDao(ServerProfileDatabase db) : super(db);

    Future<List<ServerProfileEntity>> getAllProfiles() => select(serverProfiles).get();

    Stream<List<ServerProfileEntity>> watchAllProfiles() => select(serverProfiles).watch();

    Future<ServerProfileEntity?> getProfileById(int id) {
        return (select(serverProfiles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    }

    Future<int> insertProfile(ServerProfilesCompanion entry) => into(serverProfiles).insert(entry);

    Future<bool> updateProfile(ServerProfileEntity entry) => update(serverProfiles).replace(entry);

    Future<int> deleteProfile(int id) {
        return (delete(serverProfiles)..where((tbl) => tbl.id.equals(id))).go();
    }

    Future<bool> doesProfileExist({
        required String url,
        required String port,
        required String user,
    }) async {
        final query = select(serverProfiles)
            ..where((tbl) =>
            tbl.url.equals(url) &
            tbl.port.equals(port) &
            tbl.sessionUser.equals(user));

        final result = await query.getSingleOrNull();
        return result != null;
    }

    Future<int?> getProfileByFields({
        required String url,
        required String port,
        required String user,
    }) async {
        final query = select(serverProfiles)
            ..where((tbl) =>
            tbl.url.equals(url) &
            tbl.port.equals(port) &
            tbl.sessionUser.equals(user));

        final result = await query.getSingleOrNull();
        return result?.id;
    }

    Future<void> deletePasswords() {
        return (update(serverProfiles)
            ..where((t) => t.id.isNotNull())
        ).write(
            const ServerProfilesCompanion(
                securedSshKeyPassword: Value(null),
                securedSessionPassword: Value(null),
            ),
        );
    }

}