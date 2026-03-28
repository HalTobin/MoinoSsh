import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../db/dao/server_profile_dao.dart';
import '../db/server_profile_database.dart';

class ServerProfileRepositoryImpl implements ServerProfileRepository {

    final ServerProfileDao _dao;

    static ServerProfileRepositoryImpl? _instance;

    factory ServerProfileRepositoryImpl({
        required ServerProfileDao dao,
    }) {
        _instance ??= ServerProfileRepositoryImpl._internal(dao);
        return _instance!;
    }

    ServerProfileRepositoryImpl._internal(this._dao);

    @override
    Future<int> saveProfile(NewServerProfile profile) async {
        final ServerProfilesCompanion profileEntity = ServerProfilesCompanion(
            id: Value.absent(),
            serverName: Value(profile.name),
            url: Value(profile.url),
            port: Value(profile.port),
            sessionUser: Value(profile.user),
            keyPath: Value(profile.keyPath),
            securedSshKeyPassword: Value(null),
            securedSessionPassword: Value(null)
        );
        return _dao.insertProfile(profileEntity);
    }

    @override
    Future<bool> updateProfile(EditServerProfile profile) async {
        final entity = ServerProfileEntity(
            id: profile.id,
            serverName: profile.name,
            url: profile.url,
            port: profile.port,
            sessionUser: profile.user,
            keyPath: profile.keyPath,
            securedSshKeyPassword: profile.securedSshKeyPassword,
            securedSessionPassword: profile.securedSessionPassword
        );
        return _dao.updateProfile(entity);
    }

    @override
    Future<void> deleteProfile(int profileId) async {
        _dao.deleteProfile(profileId);
    }

    @override
    Future<List<ServerProfile>> getAllProfiles() async {
        final profiles = await _dao.getAllProfiles();
        return profiles
            .map((profile) => profile.toDomain())
            .toList();
    }

    @override
    Stream<List<ServerProfile>> watchAllProfiles() {
        return _dao.watchAllProfiles().map((profiles) =>
            profiles.map((profile) => profile.toDomain()).toList()
        );
    }

    @override
    Future<bool> doesProfileExist({
        required String url,
        required String port,
        required String user
    }) async {
        return _dao.doesProfileExist(url: url, port: port, user: user);
    }

    @override
    Future<int?> getProfileIdByFields({
        required String url,
        required String port,
        required String user
    }) async {
        final profileId = await _dao.getProfileByFields(url: url, port: port, user: user);
        return profileId;
    }

    @override
    Future<ServerProfile?> getProfileById(int id) async {
       final ServerProfileEntity? entity = await _dao.getProfileById(id);
       return entity?.toDomain();
    }

    @override
    Future<void> deletePasswords() async {
        if (kDebugMode) {
            print("clearing all passwords");
        }
        await _dao.deletePasswords();
    }

}

extension on ServerProfileEntity {
    ServerProfile toDomain() =>
        ServerProfile(
            id: this.id,
            name: this.serverName,
            url: this.url,
            port: this.port,
            user: this.sessionUser,
            keyPath: this.keyPath,
            securedSshKeyPassword: this.securedSshKeyPassword,
            securedSessionPassword: this.securedSessionPassword
        );
}