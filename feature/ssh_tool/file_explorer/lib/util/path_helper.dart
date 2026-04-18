class PathHelper {

    static bool canNavigateUp(String path) {
        final cleanPath = (path.length > 1 && path.endsWith('/'))
            ? path.substring(0, path.length - 1)
            : path;

        return cleanPath.isNotEmpty && cleanPath != "/";
    }

}