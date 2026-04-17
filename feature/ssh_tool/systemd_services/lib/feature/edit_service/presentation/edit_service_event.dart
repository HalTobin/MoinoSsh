sealed class EditServiceEvent {}

class SaveService extends EditServiceEvent {
    final String alias;
    SaveService({required this.alias});
}

class AskDeleteService extends EditServiceEvent {}

class ExitDeleteMode extends EditServiceEvent {}

class ConfirmDeleteService extends EditServiceEvent {}

class SelectIcon extends EditServiceEvent {
    final int? iconId;
    SelectIcon({required this.iconId});
}