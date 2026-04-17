class EditServiceState {
    final int profileId;
    final String serviceName;
    final int serviceId;
    final String alias;
    final int iconId;
    final bool deleteMode;
    final bool loading;

    const EditServiceState({
        this.profileId = -1,
        this.serviceName = "",
        this.serviceId = -1,
        this.alias = "",
        this.iconId = -1,
        this.deleteMode = false,
        this.loading = false
    });

    EditServiceState copyWith({
        int? profileId,
        String? serviceName,
        int? serviceId,
        String? alias,
        int? iconId,
        bool? deleteMode,
        bool? loading
    }) {
        return EditServiceState(
            profileId: profileId ?? this.profileId,
            serviceName: serviceName ?? this.serviceName,
            serviceId: serviceId ?? this.serviceId,
            alias: alias ?? this.alias,
            iconId: iconId ?? this.iconId,
            deleteMode: deleteMode ?? this.deleteMode,
            loading: loading ?? this.loading
        );
    }
}