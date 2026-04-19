class PinnedFolder {
    final int id;
    final int profileId;
    final String path;
    final String? alias;
    final int customIndex;

    const PinnedFolder({
        required this.id,
        required this.profileId,
        required this.path,
        required this.alias,
        required this.customIndex
    });

    @override
    bool operator ==(Object other) {
        return other is PinnedFolder &&
            other.profileId == profileId &&
            other.path == path;
    }

}

class NewPinnedFolder {
    final int profileId;
    final String path;
    final String? alias;
    final int customIndex;

    const NewPinnedFolder({
        required this.profileId,
        required this.path,
        required this.alias,
        required this.customIndex
    });
}

class UpdatePinnedFolder {
    final int id;
    final int profileId;
    final String path;
    final String? alias;
    final int customIndex;

    const UpdatePinnedFolder({
        required this.id,
        required this.profileId,
        required this.path,
        required this.alias,
        required this.customIndex
    });
}