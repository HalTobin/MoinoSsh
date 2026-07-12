class SearchResult {
    final String keyword;
    final List<int> linesWithMatch;

    const SearchResult({required this.keyword, required this.linesWithMatch});
}