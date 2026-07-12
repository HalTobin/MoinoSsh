import 'package:domain/model/ssh/pinned_folder.dart';

abstract interface class PinnedFolderRepository {

    Future<int> pinFolder(NewPinnedFolder folder);

    Future<bool> updateFolder(UpdatePinnedFolder folder);

    Future<void> unpinFolder(int folderId);

    Future<void> deleteByProfileId(int profileId);

    Future<PinnedFolder?> getByProfileIdAndPath(int profileId, String path);

    Future<List<PinnedFolder>> getFoldersByProfileId(int profileId);

    Stream<PinnedFolder?> watchFolder(int folderId);

    Stream<List<PinnedFolder>> watchFoldersByProfileId(int profileId);

}