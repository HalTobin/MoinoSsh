sealed class FileContentEvent {}

class FilterContent extends FileContentEvent {
    final String? filter;

    FilterContent({required this.filter});
}

class SearchContent extends FileContentEvent {
    final String? search;

    SearchContent({required this.search});
}