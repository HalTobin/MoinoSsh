import 'package:domain/model/server_profile.dart';

abstract interface class ServerProfileRepository {

    Future<int> saveProfile(NewServerProfile profile);

    Future<bool> updateProfile(EditServerProfile profile);

    Future<void> deleteProfile(int profileId);

    Future<List<ServerProfile>> getAllProfiles();

    Stream<List<ServerProfile>> watchAllProfiles();

    Future<bool> doesProfileExist({
        required String url,
        required String port,
        required String user
    });

    Future<int?> getProfileIdByFields({
        required String url,
        required String port,
        required String user
    });

    Future<ServerProfile?> getProfileById(int id);

    Future<void> deletePasswords();

}