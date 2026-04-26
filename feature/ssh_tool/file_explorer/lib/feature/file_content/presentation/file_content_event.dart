sealed class FileContentEvent {}

class FilterContentEvent extends FileContentEvent {
    final String? filter;

    FilterContentEvent({required this.filter});
}

class SearchContentEvent extends FileContentEvent {
    final String? search;

    SearchContentEvent({required this.search});
}