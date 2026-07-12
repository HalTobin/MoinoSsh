import 'package:drift/drift.dart';

import '../entity/pinned_folder_entity.dart';
import '../server_profile_database.dart';

part 'pinned_folder_dao.g.dart';

@DriftAccessor(tables: [PinnedFolder])
class PinnedFolderDao extends DatabaseAccessor<ServerProfileDatabase> with _$PinnedFolderDaoMixin {
    PinnedFolderDao(ServerProfileDatabase db) : super(db);

    Future<int> insertFolder(PinnedFolderCompanion entry) => into(pinnedFolder).insert(entry);

    Future<bool> updateFolder(PinnedFolderEntity entry) => update(pinnedFolder).replace(entry);

    Future<int> deleteFolder(int id) {
        return (delete(pinnedFolder)..where((tbl) => tbl.id.equals(id))).go();
    }

    Stream<PinnedFolderEntity?> watchFolder(int folderId) {
        final folder = select(pinnedFolder)..where((tbl) => tbl.id.equals(folderId));
        return folder.watchSingleOrNull();
    }

    Future<List<PinnedFolderEntity>> getFoldersByServerId(int profileId) async {
        final folders = select(pinnedFolder)..where((tbl) => tbl.profileId.equals(profileId));
        return await folders.get();
    }

    Future<PinnedFolderEntity?> getByProfileIdAndPath(int profileId, String path) async {
        final folder = select(pinnedFolder)..where((tbl) => tbl.profileId.equals(profileId) & tbl.path.equals(path));
        return await folder.getSingleOrNull();
    }

    Stream<List<PinnedFolderEntity>> watchFoldersByProfileId(int profileId) {
        final folders = select(pinnedFolder)..where((tbl) => tbl.profileId.equals(profileId));
        return folders.watch();
    }

}