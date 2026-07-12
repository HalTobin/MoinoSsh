import 'package:domain/model/moino_ssh_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

extension MoinoSshIconIconData on MoinoSshIcon {
  IconData get icon {
    switch (this) {
      case MoinoSshIcon.admin: return LucideIcons.shieldUser;
      case MoinoSshIcon.public: return LucideIcons.earth;
      case MoinoSshIcon.user: return LucideIcons.user;
      case MoinoSshIcon.web: return LucideIcons.globe;
      case MoinoSshIcon.database: return LucideIcons.database;
      case MoinoSshIcon.mail: return LucideIcons.mail;
      case MoinoSshIcon.storage: return LucideIcons.hardDrive;
      case MoinoSshIcon.compute: return LucideIcons.cpu;
      case MoinoSshIcon.analytics: return LucideIcons.chartColumn;
      case MoinoSshIcon.unknown: return LucideIcons.messageCircleQuestionMark;
      case MoinoSshIcon.terminal: return LucideIcons.terminal;
      case MoinoSshIcon.cloud: return LucideIcons.cloud;
      case MoinoSshIcon.security: return LucideIcons.lock;
      case MoinoSshIcon.container: return LucideIcons.container;
      case MoinoSshIcon.monitoring: return LucideIcons.activity;
      case MoinoSshIcon.network: return LucideIcons.network;
      case MoinoSshIcon.server: return LucideIcons.server;
      case MoinoSshIcon.script: return LucideIcons.fileCode;
      case MoinoSshIcon.firewall: return LucideIcons.brickWall;
      case MoinoSshIcon.backup: return LucideIcons.archive;
      case MoinoSshIcon.genericFile: return LucideIcons.file;
      case MoinoSshIcon.text: return LucideIcons.fileText;
      case MoinoSshIcon.image: return LucideIcons.fileImage;
      case MoinoSshIcon.video: return LucideIcons.fileVideoCamera;
      case MoinoSshIcon.audio: return LucideIcons.fileMusic;
      case MoinoSshIcon.archive: return LucideIcons.fileArchive;
      case MoinoSshIcon.code: return LucideIcons.fileCodeCorner;
      case MoinoSshIcon.spreadsheet: return LucideIcons.fileSpreadsheet;
      case MoinoSshIcon.log: return LucideIcons.scrollText;
    }
  }

  String get label {
    return toString().split('.').last;
  }
}