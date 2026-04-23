import 'package:domain/model/preferences/file_view_mode.dart';

extension FileViewModeText on FileViewMode {
    String getText() {
        switch (this) {
            case FileViewMode.grid:
                return "Grid";
            case FileViewMode.list:
                return "List";
        }
    }
}