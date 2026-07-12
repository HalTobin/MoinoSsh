import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

extension FileViewModeIcon on FileViewMode {
    IconData getIcon() {
        switch (this) {
            case FileViewMode.grid:
                return LucideIcons.grid3x3;
            case FileViewMode.list:
                return LucideIcons.list;
        }
    }
}