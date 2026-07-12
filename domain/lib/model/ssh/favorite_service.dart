class FavoriteService {
    final int id;
    final int profileId;
    final String name;
    final String? alias;
    final int? iconId;

    FavoriteService({
        required this.id,
        required this.profileId,
        required this.name,
        required this.alias,
        required this.iconId
    });

    @override
    String toString() {
        return "{ "
            "id: $id, "
            "profileId: $profileId, "
            "name: $name, "
            "alias: $alias, "
            "iconId: $iconId"
            " }";
    }
}

class NewFavoriteService {
    final int profileId;
    final String name;
    final String? alias;
    final int? iconId;

    const NewFavoriteService({
        required this.profileId,
        required this.name,
        required this.alias,
        required this.iconId
    });
}

class UpdateFavoriteService {
    final int id;
    final int profileId;
    final String name;
    final String? alias;
    final int? iconId;

    const UpdateFavoriteService({
        required this.id,
        required this.profileId,
        required this.name,
        required this.alias,
        required this.iconId
    });
}