import 'package:data/db/dao/pinned_folder_dao.dart';
import 'package:data/db/server_profile_database.dart';
import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:drift/drift.dart';

class PinnedFolderRepositoryImpl implements PinnedFolderRepository {

    final PinnedFolderDao _dao;

    static PinnedFolderRepositoryImpl? _instance;

    factory PinnedFolderRepositoryImpl({
        required PinnedFolderDao dao,
    }) {
        _instance ??= PinnedFolderRepositoryImpl._internal(dao);
        return _instance!;
    }

    PinnedFolderRepositoryImpl._internal(this._dao);

    @override
    Future<int> pinFolder(NewPinnedFolder folder) async {
        final PinnedFolderCompanion folderEntity = PinnedFolderCompanion(
            id: Value.absent(),
            profileId: Value(folder.profileId),
            path: Value(folder.path),
            alias: Value(folder.alias),
            customIndex: Value(folder.customIndex)
        );
        return _dao.insertFolder(folderEntity);
    }

    @override
    Future<bool> updateFolder(UpdatePinnedFolder folder) async {
        final entity = PinnedFolderEntity(
            id: folder.id,
            profileId: folder.profileId,
            path: folder.path,
            alias: folder.alias,
            customIndex: folder.customIndex,
            iconId: folder.iconId
        );
        return await _dao.updateFolder(entity);
    }

    @override
    Future<void> unpinFolder(int folderId) async {
        _dao.deleteFolder(folderId);
    }

    @override
    Future<void> deleteByProfileId(int profileId) async {
        final folders = await _dao.getFoldersByServerId(profileId);
        for (final folder in folders) {
            await _dao.deleteFolder(folder.id);
        }
    }

    @override
    Future<PinnedFolder?> getByProfileIdAndPath(int profileId, String path) async {
        final folder = await _dao.getByProfileIdAndPath(profileId, path);
        return folder?.toDomain();
    }

    @override
    Future<List<PinnedFolder>> getFoldersByProfileId(int profileId) {
        return _dao.getFoldersByServerId(profileId).then((entities) =>
            entities.map((entity) => entity.toDomain()).toList()
        );
    }

    @override
    Stream<PinnedFolder?> watchFolder(int folderId) {
        return _dao.watchFolder(folderId).map((entity) => entity?.toDomain());
    }

    @override
    Stream<List<PinnedFolder>> watchFoldersByProfileId(int profileId) {
        return _dao.watchFoldersByProfileId(profileId).map((entities) =>
            entities.map((entity) => entity.toDomain()).toList()
        );
    }

}

extension on PinnedFolderEntity {
    PinnedFolder toDomain() =>
        PinnedFolder(
            id: this.id,
            profileId: this.profileId,
            path: this.path,
            alias: this.alias,
            customIndex: this.customIndex,
            iconId: this.iconId
        );
}