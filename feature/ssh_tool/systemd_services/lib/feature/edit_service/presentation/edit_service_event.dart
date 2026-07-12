sealed class EditServiceEvent {}

class SaveService extends EditServiceEvent {
    final String alias;
    SaveService({required this.alias});
}

class DeleteService extends EditServiceEvent {}

class SelectIcon extends EditServiceEvent {
    final int? iconId;
    SelectIcon({required this.iconId});
}