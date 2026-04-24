// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_profile_database.dart';

// ignore_for_file: type=lint
class $ServerProfilesTable extends ServerProfiles
    with TableInfo<$ServerProfilesTable, ServerProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverNameMeta = const VerificationMeta(
    'serverName',
  );
  @override
  late final GeneratedColumn<String> serverName = GeneratedColumn<String>(
    'server_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<String> port = GeneratedColumn<String>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionUserMeta = const VerificationMeta(
    'sessionUser',
  );
  @override
  late final GeneratedColumn<String> sessionUser = GeneratedColumn<String>(
    'session_user',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyPathMeta = const VerificationMeta(
    'keyPath',
  );
  @override
  late final GeneratedColumn<String> keyPath = GeneratedColumn<String>(
    'key_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _securedSshKeyPasswordMeta =
      const VerificationMeta('securedSshKeyPassword');
  @override
  late final GeneratedColumn<String> securedSshKeyPassword =
      GeneratedColumn<String>(
        'secured_ssh_key_password',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _securedSessionPasswordMeta =
      const VerificationMeta('securedSessionPassword');
  @override
  late final GeneratedColumn<String> securedSessionPassword =
      GeneratedColumn<String>(
        'secured_session_password',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverName,
    url,
    port,
    sessionUser,
    keyPath,
    securedSshKeyPassword,
    securedSessionPassword,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerProfileEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_name')) {
      context.handle(
        _serverNameMeta,
        serverName.isAcceptableOrUnknown(data['server_name']!, _serverNameMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('session_user')) {
      context.handle(
        _sessionUserMeta,
        sessionUser.isAcceptableOrUnknown(
          data['session_user']!,
          _sessionUserMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionUserMeta);
    }
    if (data.containsKey('key_path')) {
      context.handle(
        _keyPathMeta,
        keyPath.isAcceptableOrUnknown(data['key_path']!, _keyPathMeta),
      );
    } else if (isInserting) {
      context.missing(_keyPathMeta);
    }
    if (data.containsKey('secured_ssh_key_password')) {
      context.handle(
        _securedSshKeyPasswordMeta,
        securedSshKeyPassword.isAcceptableOrUnknown(
          data['secured_ssh_key_password']!,
          _securedSshKeyPasswordMeta,
        ),
      );
    }
    if (data.containsKey('secured_session_password')) {
      context.handle(
        _securedSessionPasswordMeta,
        securedSessionPassword.isAcceptableOrUnknown(
          data['secured_session_password']!,
          _securedSessionPasswordMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerProfileEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_name'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}port'],
      )!,
      sessionUser: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_user'],
      )!,
      keyPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_path'],
      )!,
      securedSshKeyPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secured_ssh_key_password'],
      ),
      securedSessionPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secured_session_password'],
      ),
    );
  }

  @override
  $ServerProfilesTable createAlias(String alias) {
    return $ServerProfilesTable(attachedDatabase, alias);
  }
}

class ServerProfileEntity extends DataClass
    implements Insertable<ServerProfileEntity> {
  final int id;
  final String? serverName;
  final String url;
  final String port;
  final String sessionUser;
  final String keyPath;
  final String? securedSshKeyPassword;
  final String? securedSessionPassword;
  const ServerProfileEntity({
    required this.id,
    this.serverName,
    required this.url,
    required this.port,
    required this.sessionUser,
    required this.keyPath,
    this.securedSshKeyPassword,
    this.securedSessionPassword,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverName != null) {
      map['server_name'] = Variable<String>(serverName);
    }
    map['url'] = Variable<String>(url);
    map['port'] = Variable<String>(port);
    map['session_user'] = Variable<String>(sessionUser);
    map['key_path'] = Variable<String>(keyPath);
    if (!nullToAbsent || securedSshKeyPassword != null) {
      map['secured_ssh_key_password'] = Variable<String>(securedSshKeyPassword);
    }
    if (!nullToAbsent || securedSessionPassword != null) {
      map['secured_session_password'] = Variable<String>(
        securedSessionPassword,
      );
    }
    return map;
  }

  ServerProfilesCompanion toCompanion(bool nullToAbsent) {
    return ServerProfilesCompanion(
      id: Value(id),
      serverName: serverName == null && nullToAbsent
          ? const Value.absent()
          : Value(serverName),
      url: Value(url),
      port: Value(port),
      sessionUser: Value(sessionUser),
      keyPath: Value(keyPath),
      securedSshKeyPassword: securedSshKeyPassword == null && nullToAbsent
          ? const Value.absent()
          : Value(securedSshKeyPassword),
      securedSessionPassword: securedSessionPassword == null && nullToAbsent
          ? const Value.absent()
          : Value(securedSessionPassword),
    );
  }

  factory ServerProfileEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerProfileEntity(
      id: serializer.fromJson<int>(json['id']),
      serverName: serializer.fromJson<String?>(json['serverName']),
      url: serializer.fromJson<String>(json['url']),
      port: serializer.fromJson<String>(json['port']),
      sessionUser: serializer.fromJson<String>(json['sessionUser']),
      keyPath: serializer.fromJson<String>(json['keyPath']),
      securedSshKeyPassword: serializer.fromJson<String?>(
        json['securedSshKeyPassword'],
      ),
      securedSessionPassword: serializer.fromJson<String?>(
        json['securedSessionPassword'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverName': serializer.toJson<String?>(serverName),
      'url': serializer.toJson<String>(url),
      'port': serializer.toJson<String>(port),
      'sessionUser': serializer.toJson<String>(sessionUser),
      'keyPath': serializer.toJson<String>(keyPath),
      'securedSshKeyPassword': serializer.toJson<String?>(
        securedSshKeyPassword,
      ),
      'securedSessionPassword': serializer.toJson<String?>(
        securedSessionPassword,
      ),
    };
  }

  ServerProfileEntity copyWith({
    int? id,
    Value<String?> serverName = const Value.absent(),
    String? url,
    String? port,
    String? sessionUser,
    String? keyPath,
    Value<String?> securedSshKeyPassword = const Value.absent(),
    Value<String?> securedSessionPassword = const Value.absent(),
  }) => ServerProfileEntity(
    id: id ?? this.id,
    serverName: serverName.present ? serverName.value : this.serverName,
    url: url ?? this.url,
    port: port ?? this.port,
    sessionUser: sessionUser ?? this.sessionUser,
    keyPath: keyPath ?? this.keyPath,
    securedSshKeyPassword: securedSshKeyPassword.present
        ? securedSshKeyPassword.value
        : this.securedSshKeyPassword,
    securedSessionPassword: securedSessionPassword.present
        ? securedSessionPassword.value
        : this.securedSessionPassword,
  );
  ServerProfileEntity copyWithCompanion(ServerProfilesCompanion data) {
    return ServerProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      serverName: data.serverName.present
          ? data.serverName.value
          : this.serverName,
      url: data.url.present ? data.url.value : this.url,
      port: data.port.present ? data.port.value : this.port,
      sessionUser: data.sessionUser.present
          ? data.sessionUser.value
          : this.sessionUser,
      keyPath: data.keyPath.present ? data.keyPath.value : this.keyPath,
      securedSshKeyPassword: data.securedSshKeyPassword.present
          ? data.securedSshKeyPassword.value
          : this.securedSshKeyPassword,
      securedSessionPassword: data.securedSessionPassword.present
          ? data.securedSessionPassword.value
          : this.securedSessionPassword,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfileEntity(')
          ..write('id: $id, ')
          ..write('serverName: $serverName, ')
          ..write('url: $url, ')
          ..write('port: $port, ')
          ..write('sessionUser: $sessionUser, ')
          ..write('keyPath: $keyPath, ')
          ..write('securedSshKeyPassword: $securedSshKeyPassword, ')
          ..write('securedSessionPassword: $securedSessionPassword')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverName,
    url,
    port,
    sessionUser,
    keyPath,
    securedSshKeyPassword,
    securedSessionPassword,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerProfileEntity &&
          other.id == this.id &&
          other.serverName == this.serverName &&
          other.url == this.url &&
          other.port == this.port &&
          other.sessionUser == this.sessionUser &&
          other.keyPath == this.keyPath &&
          other.securedSshKeyPassword == this.securedSshKeyPassword &&
          other.securedSessionPassword == this.securedSessionPassword);
}

class ServerProfilesCompanion extends UpdateCompanion<ServerProfileEntity> {
  final Value<int> id;
  final Value<String?> serverName;
  final Value<String> url;
  final Value<String> port;
  final Value<String> sessionUser;
  final Value<String> keyPath;
  final Value<String?> securedSshKeyPassword;
  final Value<String?> securedSessionPassword;
  const ServerProfilesCompanion({
    this.id = const Value.absent(),
    this.serverName = const Value.absent(),
    this.url = const Value.absent(),
    this.port = const Value.absent(),
    this.sessionUser = const Value.absent(),
    this.keyPath = const Value.absent(),
    this.securedSshKeyPassword = const Value.absent(),
    this.securedSessionPassword = const Value.absent(),
  });
  ServerProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.serverName = const Value.absent(),
    required String url,
    required String port,
    required String sessionUser,
    required String keyPath,
    this.securedSshKeyPassword = const Value.absent(),
    this.securedSessionPassword = const Value.absent(),
  }) : url = Value(url),
       port = Value(port),
       sessionUser = Value(sessionUser),
       keyPath = Value(keyPath);
  static Insertable<ServerProfileEntity> custom({
    Expression<int>? id,
    Expression<String>? serverName,
    Expression<String>? url,
    Expression<String>? port,
    Expression<String>? sessionUser,
    Expression<String>? keyPath,
    Expression<String>? securedSshKeyPassword,
    Expression<String>? securedSessionPassword,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverName != null) 'server_name': serverName,
      if (url != null) 'url': url,
      if (port != null) 'port': port,
      if (sessionUser != null) 'session_user': sessionUser,
      if (keyPath != null) 'key_path': keyPath,
      if (securedSshKeyPassword != null)
        'secured_ssh_key_password': securedSshKeyPassword,
      if (securedSessionPassword != null)
        'secured_session_password': securedSessionPassword,
    });
  }

  ServerProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? serverName,
    Value<String>? url,
    Value<String>? port,
    Value<String>? sessionUser,
    Value<String>? keyPath,
    Value<String?>? securedSshKeyPassword,
    Value<String?>? securedSessionPassword,
  }) {
    return ServerProfilesCompanion(
      id: id ?? this.id,
      serverName: serverName ?? this.serverName,
      url: url ?? this.url,
      port: port ?? this.port,
      sessionUser: sessionUser ?? this.sessionUser,
      keyPath: keyPath ?? this.keyPath,
      securedSshKeyPassword:
          securedSshKeyPassword ?? this.securedSshKeyPassword,
      securedSessionPassword:
          securedSessionPassword ?? this.securedSessionPassword,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverName.present) {
      map['server_name'] = Variable<String>(serverName.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (port.present) {
      map['port'] = Variable<String>(port.value);
    }
    if (sessionUser.present) {
      map['session_user'] = Variable<String>(sessionUser.value);
    }
    if (keyPath.present) {
      map['key_path'] = Variable<String>(keyPath.value);
    }
    if (securedSshKeyPassword.present) {
      map['secured_ssh_key_password'] = Variable<String>(
        securedSshKeyPassword.value,
      );
    }
    if (securedSessionPassword.present) {
      map['secured_session_password'] = Variable<String>(
        securedSessionPassword.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('serverName: $serverName, ')
          ..write('url: $url, ')
          ..write('port: $port, ')
          ..write('sessionUser: $sessionUser, ')
          ..write('keyPath: $keyPath, ')
          ..write('securedSshKeyPassword: $securedSshKeyPassword, ')
          ..write('securedSessionPassword: $securedSessionPassword')
          ..write(')'))
        .toString();
  }
}

class $FavoriteServicesTable extends FavoriteServices
    with TableInfo<$FavoriteServicesTable, FavoriteServiceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES server_profiles (id)',
    ),
  );
  static const VerificationMeta _serviceNameMeta = const VerificationMeta(
    'serviceName',
  );
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
    'service_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  @override
  late final GeneratedColumn<int> iconId = GeneratedColumn<int>(
    'icon_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    serviceName,
    alias,
    iconId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteServiceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(
        _serviceNameMeta,
        serviceName.isAcceptableOrUnknown(
          data['service_name']!,
          _serviceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('icon_id')) {
      context.handle(
        _iconIdMeta,
        iconId.isAcceptableOrUnknown(data['icon_id']!, _iconIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteServiceEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteServiceEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      serviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_name'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      iconId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_id'],
      ),
    );
  }

  @override
  $FavoriteServicesTable createAlias(String alias) {
    return $FavoriteServicesTable(attachedDatabase, alias);
  }
}

class FavoriteServiceEntity extends DataClass
    implements Insertable<FavoriteServiceEntity> {
  final int id;
  final int profileId;
  final String serviceName;
  final String? alias;
  final int? iconId;
  const FavoriteServiceEntity({
    required this.id,
    required this.profileId,
    required this.serviceName,
    this.alias,
    this.iconId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['service_name'] = Variable<String>(serviceName);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    return map;
  }

  FavoriteServicesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteServicesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      serviceName: Value(serviceName),
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      iconId: iconId == null && nullToAbsent
          ? const Value.absent()
          : Value(iconId),
    );
  }

  factory FavoriteServiceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteServiceEntity(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      alias: serializer.fromJson<String?>(json['alias']),
      iconId: serializer.fromJson<int?>(json['iconId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'serviceName': serializer.toJson<String>(serviceName),
      'alias': serializer.toJson<String?>(alias),
      'iconId': serializer.toJson<int?>(iconId),
    };
  }

  FavoriteServiceEntity copyWith({
    int? id,
    int? profileId,
    String? serviceName,
    Value<String?> alias = const Value.absent(),
    Value<int?> iconId = const Value.absent(),
  }) => FavoriteServiceEntity(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    serviceName: serviceName ?? this.serviceName,
    alias: alias.present ? alias.value : this.alias,
    iconId: iconId.present ? iconId.value : this.iconId,
  );
  FavoriteServiceEntity copyWithCompanion(FavoriteServicesCompanion data) {
    return FavoriteServiceEntity(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      serviceName: data.serviceName.present
          ? data.serviceName.value
          : this.serviceName,
      alias: data.alias.present ? data.alias.value : this.alias,
      iconId: data.iconId.present ? data.iconId.value : this.iconId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteServiceEntity(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('serviceName: $serviceName, ')
          ..write('alias: $alias, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, serviceName, alias, iconId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteServiceEntity &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.serviceName == this.serviceName &&
          other.alias == this.alias &&
          other.iconId == this.iconId);
}

class FavoriteServicesCompanion extends UpdateCompanion<FavoriteServiceEntity> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> serviceName;
  final Value<String?> alias;
  final Value<int?> iconId;
  const FavoriteServicesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.alias = const Value.absent(),
    this.iconId = const Value.absent(),
  });
  FavoriteServicesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String serviceName,
    this.alias = const Value.absent(),
    this.iconId = const Value.absent(),
  }) : profileId = Value(profileId),
       serviceName = Value(serviceName);
  static Insertable<FavoriteServiceEntity> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? serviceName,
    Expression<String>? alias,
    Expression<int>? iconId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (serviceName != null) 'service_name': serviceName,
      if (alias != null) 'alias': alias,
      if (iconId != null) 'icon_id': iconId,
    });
  }

  FavoriteServicesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? serviceName,
    Value<String?>? alias,
    Value<int?>? iconId,
  }) {
    return FavoriteServicesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      serviceName: serviceName ?? this.serviceName,
      alias: alias ?? this.alias,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteServicesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('serviceName: $serviceName, ')
          ..write('alias: $alias, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }
}

class $PinnedFolderTable extends PinnedFolder
    with TableInfo<$PinnedFolderTable, PinnedFolderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedFolderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES server_profiles (id)',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customIndexMeta = const VerificationMeta(
    'customIndex',
  );
  @override
  late final GeneratedColumn<int> customIndex = GeneratedColumn<int>(
    'custom_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconIdMeta = const VerificationMeta('iconId');
  @override
  late final GeneratedColumn<int> iconId = GeneratedColumn<int>(
    'icon_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    path,
    alias,
    customIndex,
    iconId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_folder';
  @override
  VerificationContext validateIntegrity(
    Insertable<PinnedFolderEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('custom_index')) {
      context.handle(
        _customIndexMeta,
        customIndex.isAcceptableOrUnknown(
          data['custom_index']!,
          _customIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customIndexMeta);
    }
    if (data.containsKey('icon_id')) {
      context.handle(
        _iconIdMeta,
        iconId.isAcceptableOrUnknown(data['icon_id']!, _iconIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedFolderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedFolderEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      customIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_index'],
      )!,
      iconId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_id'],
      ),
    );
  }

  @override
  $PinnedFolderTable createAlias(String alias) {
    return $PinnedFolderTable(attachedDatabase, alias);
  }
}

class PinnedFolderEntity extends DataClass
    implements Insertable<PinnedFolderEntity> {
  final int id;
  final int profileId;
  final String path;
  final String? alias;
  final int customIndex;
  final int? iconId;
  const PinnedFolderEntity({
    required this.id,
    required this.profileId,
    required this.path,
    this.alias,
    required this.customIndex,
    this.iconId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    map['custom_index'] = Variable<int>(customIndex);
    if (!nullToAbsent || iconId != null) {
      map['icon_id'] = Variable<int>(iconId);
    }
    return map;
  }

  PinnedFolderCompanion toCompanion(bool nullToAbsent) {
    return PinnedFolderCompanion(
      id: Value(id),
      profileId: Value(profileId),
      path: Value(path),
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      customIndex: Value(customIndex),
      iconId: iconId == null && nullToAbsent
          ? const Value.absent()
          : Value(iconId),
    );
  }

  factory PinnedFolderEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedFolderEntity(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      path: serializer.fromJson<String>(json['path']),
      alias: serializer.fromJson<String?>(json['alias']),
      customIndex: serializer.fromJson<int>(json['customIndex']),
      iconId: serializer.fromJson<int?>(json['iconId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'path': serializer.toJson<String>(path),
      'alias': serializer.toJson<String?>(alias),
      'customIndex': serializer.toJson<int>(customIndex),
      'iconId': serializer.toJson<int?>(iconId),
    };
  }

  PinnedFolderEntity copyWith({
    int? id,
    int? profileId,
    String? path,
    Value<String?> alias = const Value.absent(),
    int? customIndex,
    Value<int?> iconId = const Value.absent(),
  }) => PinnedFolderEntity(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    path: path ?? this.path,
    alias: alias.present ? alias.value : this.alias,
    customIndex: customIndex ?? this.customIndex,
    iconId: iconId.present ? iconId.value : this.iconId,
  );
  PinnedFolderEntity copyWithCompanion(PinnedFolderCompanion data) {
    return PinnedFolderEntity(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      path: data.path.present ? data.path.value : this.path,
      alias: data.alias.present ? data.alias.value : this.alias,
      customIndex: data.customIndex.present
          ? data.customIndex.value
          : this.customIndex,
      iconId: data.iconId.present ? data.iconId.value : this.iconId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedFolderEntity(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('path: $path, ')
          ..write('alias: $alias, ')
          ..write('customIndex: $customIndex, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, path, alias, customIndex, iconId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedFolderEntity &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.path == this.path &&
          other.alias == this.alias &&
          other.customIndex == this.customIndex &&
          other.iconId == this.iconId);
}

class PinnedFolderCompanion extends UpdateCompanion<PinnedFolderEntity> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> path;
  final Value<String?> alias;
  final Value<int> customIndex;
  final Value<int?> iconId;
  const PinnedFolderCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.path = const Value.absent(),
    this.alias = const Value.absent(),
    this.customIndex = const Value.absent(),
    this.iconId = const Value.absent(),
  });
  PinnedFolderCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String path,
    this.alias = const Value.absent(),
    required int customIndex,
    this.iconId = const Value.absent(),
  }) : profileId = Value(profileId),
       path = Value(path),
       customIndex = Value(customIndex);
  static Insertable<PinnedFolderEntity> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? path,
    Expression<String>? alias,
    Expression<int>? customIndex,
    Expression<int>? iconId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (path != null) 'path': path,
      if (alias != null) 'alias': alias,
      if (customIndex != null) 'custom_index': customIndex,
      if (iconId != null) 'icon_id': iconId,
    });
  }

  PinnedFolderCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? path,
    Value<String?>? alias,
    Value<int>? customIndex,
    Value<int?>? iconId,
  }) {
    return PinnedFolderCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      path: path ?? this.path,
      alias: alias ?? this.alias,
      customIndex: customIndex ?? this.customIndex,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (customIndex.present) {
      map['custom_index'] = Variable<int>(customIndex.value);
    }
    if (iconId.present) {
      map['icon_id'] = Variable<int>(iconId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedFolderCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('path: $path, ')
          ..write('alias: $alias, ')
          ..write('customIndex: $customIndex, ')
          ..write('iconId: $iconId')
          ..write(')'))
        .toString();
  }
}

abstract class _$ServerProfileDatabase extends GeneratedDatabase {
  _$ServerProfileDatabase(QueryExecutor e) : super(e);
  $ServerProfileDatabaseManager get managers =>
      $ServerProfileDatabaseManager(this);
  late final $ServerProfilesTable serverProfiles = $ServerProfilesTable(this);
  late final $FavoriteServicesTable favoriteServices = $FavoriteServicesTable(
    this,
  );
  late final $PinnedFolderTable pinnedFolder = $PinnedFolderTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serverProfiles,
    favoriteServices,
    pinnedFolder,
  ];
}

typedef $$ServerProfilesTableCreateCompanionBuilder =
    ServerProfilesCompanion Function({
      Value<int> id,
      Value<String?> serverName,
      required String url,
      required String port,
      required String sessionUser,
      required String keyPath,
      Value<String?> securedSshKeyPassword,
      Value<String?> securedSessionPassword,
    });
typedef $$ServerProfilesTableUpdateCompanionBuilder =
    ServerProfilesCompanion Function({
      Value<int> id,
      Value<String?> serverName,
      Value<String> url,
      Value<String> port,
      Value<String> sessionUser,
      Value<String> keyPath,
      Value<String?> securedSshKeyPassword,
      Value<String?> securedSessionPassword,
    });

final class $$ServerProfilesTableReferences
    extends
        BaseReferences<
          _$ServerProfileDatabase,
          $ServerProfilesTable,
          ServerProfileEntity
        > {
  $$ServerProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $FavoriteServicesTable,
    List<FavoriteServiceEntity>
  >
  _favoriteServicesRefsTable(_$ServerProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.favoriteServices,
        aliasName: $_aliasNameGenerator(
          db.serverProfiles.id,
          db.favoriteServices.profileId,
        ),
      );

  $$FavoriteServicesTableProcessedTableManager get favoriteServicesRefs {
    final manager = $$FavoriteServicesTableTableManager(
      $_db,
      $_db.favoriteServices,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _favoriteServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PinnedFolderTable, List<PinnedFolderEntity>>
  _pinnedFolderRefsTable(_$ServerProfileDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pinnedFolder,
        aliasName: $_aliasNameGenerator(
          db.serverProfiles.id,
          db.pinnedFolder.profileId,
        ),
      );

  $$PinnedFolderTableProcessedTableManager get pinnedFolderRefs {
    final manager = $$PinnedFolderTableTableManager(
      $_db,
      $_db.pinnedFolder,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pinnedFolderRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServerProfilesTableFilterComposer
    extends Composer<_$ServerProfileDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverName => $composableBuilder(
    column: $table.serverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionUser => $composableBuilder(
    column: $table.sessionUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyPath => $composableBuilder(
    column: $table.keyPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get securedSshKeyPassword => $composableBuilder(
    column: $table.securedSshKeyPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get securedSessionPassword => $composableBuilder(
    column: $table.securedSessionPassword,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> favoriteServicesRefs(
    Expression<bool> Function($$FavoriteServicesTableFilterComposer f) f,
  ) {
    final $$FavoriteServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteServices,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteServicesTableFilterComposer(
            $db: $db,
            $table: $db.favoriteServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pinnedFolderRefs(
    Expression<bool> Function($$PinnedFolderTableFilterComposer f) f,
  ) {
    final $$PinnedFolderTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pinnedFolder,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PinnedFolderTableFilterComposer(
            $db: $db,
            $table: $db.pinnedFolder,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServerProfilesTableOrderingComposer
    extends Composer<_$ServerProfileDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverName => $composableBuilder(
    column: $table.serverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionUser => $composableBuilder(
    column: $table.sessionUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyPath => $composableBuilder(
    column: $table.keyPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get securedSshKeyPassword => $composableBuilder(
    column: $table.securedSshKeyPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get securedSessionPassword => $composableBuilder(
    column: $table.securedSessionPassword,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServerProfilesTableAnnotationComposer
    extends Composer<_$ServerProfileDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverName => $composableBuilder(
    column: $table.serverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get sessionUser => $composableBuilder(
    column: $table.sessionUser,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyPath =>
      $composableBuilder(column: $table.keyPath, builder: (column) => column);

  GeneratedColumn<String> get securedSshKeyPassword => $composableBuilder(
    column: $table.securedSshKeyPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get securedSessionPassword => $composableBuilder(
    column: $table.securedSessionPassword,
    builder: (column) => column,
  );

  Expression<T> favoriteServicesRefs<T extends Object>(
    Expression<T> Function($$FavoriteServicesTableAnnotationComposer a) f,
  ) {
    final $$FavoriteServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteServices,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoriteServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.favoriteServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pinnedFolderRefs<T extends Object>(
    Expression<T> Function($$PinnedFolderTableAnnotationComposer a) f,
  ) {
    final $$PinnedFolderTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pinnedFolder,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PinnedFolderTableAnnotationComposer(
            $db: $db,
            $table: $db.pinnedFolder,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServerProfilesTableTableManager
    extends
        RootTableManager<
          _$ServerProfileDatabase,
          $ServerProfilesTable,
          ServerProfileEntity,
          $$ServerProfilesTableFilterComposer,
          $$ServerProfilesTableOrderingComposer,
          $$ServerProfilesTableAnnotationComposer,
          $$ServerProfilesTableCreateCompanionBuilder,
          $$ServerProfilesTableUpdateCompanionBuilder,
          (ServerProfileEntity, $$ServerProfilesTableReferences),
          ServerProfileEntity,
          PrefetchHooks Function({
            bool favoriteServicesRefs,
            bool pinnedFolderRefs,
          })
        > {
  $$ServerProfilesTableTableManager(
    _$ServerProfileDatabase db,
    $ServerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverName = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> port = const Value.absent(),
                Value<String> sessionUser = const Value.absent(),
                Value<String> keyPath = const Value.absent(),
                Value<String?> securedSshKeyPassword = const Value.absent(),
                Value<String?> securedSessionPassword = const Value.absent(),
              }) => ServerProfilesCompanion(
                id: id,
                serverName: serverName,
                url: url,
                port: port,
                sessionUser: sessionUser,
                keyPath: keyPath,
                securedSshKeyPassword: securedSshKeyPassword,
                securedSessionPassword: securedSessionPassword,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverName = const Value.absent(),
                required String url,
                required String port,
                required String sessionUser,
                required String keyPath,
                Value<String?> securedSshKeyPassword = const Value.absent(),
                Value<String?> securedSessionPassword = const Value.absent(),
              }) => ServerProfilesCompanion.insert(
                id: id,
                serverName: serverName,
                url: url,
                port: port,
                sessionUser: sessionUser,
                keyPath: keyPath,
                securedSshKeyPassword: securedSshKeyPassword,
                securedSessionPassword: securedSessionPassword,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServerProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({favoriteServicesRefs = false, pinnedFolderRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (favoriteServicesRefs) db.favoriteServices,
                    if (pinnedFolderRefs) db.pinnedFolder,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (favoriteServicesRefs)
                        await $_getPrefetchedData<
                          ServerProfileEntity,
                          $ServerProfilesTable,
                          FavoriteServiceEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ServerProfilesTableReferences
                              ._favoriteServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).favoriteServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pinnedFolderRefs)
                        await $_getPrefetchedData<
                          ServerProfileEntity,
                          $ServerProfilesTable,
                          PinnedFolderEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ServerProfilesTableReferences
                              ._pinnedFolderRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServerProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).pinnedFolderRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerProfileDatabase,
      $ServerProfilesTable,
      ServerProfileEntity,
      $$ServerProfilesTableFilterComposer,
      $$ServerProfilesTableOrderingComposer,
      $$ServerProfilesTableAnnotationComposer,
      $$ServerProfilesTableCreateCompanionBuilder,
      $$ServerProfilesTableUpdateCompanionBuilder,
      (ServerProfileEntity, $$ServerProfilesTableReferences),
      ServerProfileEntity,
      PrefetchHooks Function({bool favoriteServicesRefs, bool pinnedFolderRefs})
    >;
typedef $$FavoriteServicesTableCreateCompanionBuilder =
    FavoriteServicesCompanion Function({
      Value<int> id,
      required int profileId,
      required String serviceName,
      Value<String?> alias,
      Value<int?> iconId,
    });
typedef $$FavoriteServicesTableUpdateCompanionBuilder =
    FavoriteServicesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> serviceName,
      Value<String?> alias,
      Value<int?> iconId,
    });

final class $$FavoriteServicesTableReferences
    extends
        BaseReferences<
          _$ServerProfileDatabase,
          $FavoriteServicesTable,
          FavoriteServiceEntity
        > {
  $$FavoriteServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServerProfilesTable _profileIdTable(_$ServerProfileDatabase db) =>
      db.serverProfiles.createAlias(
        $_aliasNameGenerator(
          db.favoriteServices.profileId,
          db.serverProfiles.id,
        ),
      );

  $$ServerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ServerProfilesTableTableManager(
      $_db,
      $_db.serverProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoriteServicesTableFilterComposer
    extends Composer<_$ServerProfileDatabase, $FavoriteServicesTable> {
  $$FavoriteServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconId => $composableBuilder(
    column: $table.iconId,
    builder: (column) => ColumnFilters(column),
  );

  $$ServerProfilesTableFilterComposer get profileId {
    final $$ServerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteServicesTableOrderingComposer
    extends Composer<_$ServerProfileDatabase, $FavoriteServicesTable> {
  $$FavoriteServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconId => $composableBuilder(
    column: $table.iconId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServerProfilesTableOrderingComposer get profileId {
    final $$ServerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteServicesTableAnnotationComposer
    extends Composer<_$ServerProfileDatabase, $FavoriteServicesTable> {
  $$FavoriteServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<int> get iconId =>
      $composableBuilder(column: $table.iconId, builder: (column) => column);

  $$ServerProfilesTableAnnotationComposer get profileId {
    final $$ServerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoriteServicesTableTableManager
    extends
        RootTableManager<
          _$ServerProfileDatabase,
          $FavoriteServicesTable,
          FavoriteServiceEntity,
          $$FavoriteServicesTableFilterComposer,
          $$FavoriteServicesTableOrderingComposer,
          $$FavoriteServicesTableAnnotationComposer,
          $$FavoriteServicesTableCreateCompanionBuilder,
          $$FavoriteServicesTableUpdateCompanionBuilder,
          (FavoriteServiceEntity, $$FavoriteServicesTableReferences),
          FavoriteServiceEntity,
          PrefetchHooks Function({bool profileId})
        > {
  $$FavoriteServicesTableTableManager(
    _$ServerProfileDatabase db,
    $FavoriteServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> serviceName = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<int?> iconId = const Value.absent(),
              }) => FavoriteServicesCompanion(
                id: id,
                profileId: profileId,
                serviceName: serviceName,
                alias: alias,
                iconId: iconId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String serviceName,
                Value<String?> alias = const Value.absent(),
                Value<int?> iconId = const Value.absent(),
              }) => FavoriteServicesCompanion.insert(
                id: id,
                profileId: profileId,
                serviceName: serviceName,
                alias: alias,
                iconId: iconId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoriteServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$FavoriteServicesTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$FavoriteServicesTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoriteServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerProfileDatabase,
      $FavoriteServicesTable,
      FavoriteServiceEntity,
      $$FavoriteServicesTableFilterComposer,
      $$FavoriteServicesTableOrderingComposer,
      $$FavoriteServicesTableAnnotationComposer,
      $$FavoriteServicesTableCreateCompanionBuilder,
      $$FavoriteServicesTableUpdateCompanionBuilder,
      (FavoriteServiceEntity, $$FavoriteServicesTableReferences),
      FavoriteServiceEntity,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$PinnedFolderTableCreateCompanionBuilder =
    PinnedFolderCompanion Function({
      Value<int> id,
      required int profileId,
      required String path,
      Value<String?> alias,
      required int customIndex,
      Value<int?> iconId,
    });
typedef $$PinnedFolderTableUpdateCompanionBuilder =
    PinnedFolderCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> path,
      Value<String?> alias,
      Value<int> customIndex,
      Value<int?> iconId,
    });

final class $$PinnedFolderTableReferences
    extends
        BaseReferences<
          _$ServerProfileDatabase,
          $PinnedFolderTable,
          PinnedFolderEntity
        > {
  $$PinnedFolderTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServerProfilesTable _profileIdTable(_$ServerProfileDatabase db) =>
      db.serverProfiles.createAlias(
        $_aliasNameGenerator(db.pinnedFolder.profileId, db.serverProfiles.id),
      );

  $$ServerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ServerProfilesTableTableManager(
      $_db,
      $_db.serverProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PinnedFolderTableFilterComposer
    extends Composer<_$ServerProfileDatabase, $PinnedFolderTable> {
  $$PinnedFolderTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customIndex => $composableBuilder(
    column: $table.customIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconId => $composableBuilder(
    column: $table.iconId,
    builder: (column) => ColumnFilters(column),
  );

  $$ServerProfilesTableFilterComposer get profileId {
    final $$ServerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PinnedFolderTableOrderingComposer
    extends Composer<_$ServerProfileDatabase, $PinnedFolderTable> {
  $$PinnedFolderTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customIndex => $composableBuilder(
    column: $table.customIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconId => $composableBuilder(
    column: $table.iconId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServerProfilesTableOrderingComposer get profileId {
    final $$ServerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PinnedFolderTableAnnotationComposer
    extends Composer<_$ServerProfileDatabase, $PinnedFolderTable> {
  $$PinnedFolderTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<int> get customIndex => $composableBuilder(
    column: $table.customIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get iconId =>
      $composableBuilder(column: $table.iconId, builder: (column) => column);

  $$ServerProfilesTableAnnotationComposer get profileId {
    final $$ServerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.serverProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.serverProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PinnedFolderTableTableManager
    extends
        RootTableManager<
          _$ServerProfileDatabase,
          $PinnedFolderTable,
          PinnedFolderEntity,
          $$PinnedFolderTableFilterComposer,
          $$PinnedFolderTableOrderingComposer,
          $$PinnedFolderTableAnnotationComposer,
          $$PinnedFolderTableCreateCompanionBuilder,
          $$PinnedFolderTableUpdateCompanionBuilder,
          (PinnedFolderEntity, $$PinnedFolderTableReferences),
          PinnedFolderEntity,
          PrefetchHooks Function({bool profileId})
        > {
  $$PinnedFolderTableTableManager(
    _$ServerProfileDatabase db,
    $PinnedFolderTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedFolderTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedFolderTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedFolderTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<int> customIndex = const Value.absent(),
                Value<int?> iconId = const Value.absent(),
              }) => PinnedFolderCompanion(
                id: id,
                profileId: profileId,
                path: path,
                alias: alias,
                customIndex: customIndex,
                iconId: iconId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String path,
                Value<String?> alias = const Value.absent(),
                required int customIndex,
                Value<int?> iconId = const Value.absent(),
              }) => PinnedFolderCompanion.insert(
                id: id,
                profileId: profileId,
                path: path,
                alias: alias,
                customIndex: customIndex,
                iconId: iconId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PinnedFolderTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$PinnedFolderTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$PinnedFolderTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PinnedFolderTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerProfileDatabase,
      $PinnedFolderTable,
      PinnedFolderEntity,
      $$PinnedFolderTableFilterComposer,
      $$PinnedFolderTableOrderingComposer,
      $$PinnedFolderTableAnnotationComposer,
      $$PinnedFolderTableCreateCompanionBuilder,
      $$PinnedFolderTableUpdateCompanionBuilder,
      (PinnedFolderEntity, $$PinnedFolderTableReferences),
      PinnedFolderEntity,
      PrefetchHooks Function({bool profileId})
    >;

class $ServerProfileDatabaseManager {
  final _$ServerProfileDatabase _db;
  $ServerProfileDatabaseManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(_db, _db.serverProfiles);
  $$FavoriteServicesTableTableManager get favoriteServices =>
      $$FavoriteServicesTableTableManager(_db, _db.favoriteServices);
  $$PinnedFolderTableTableManager get pinnedFolder =>
      $$PinnedFolderTableTableManager(_db, _db.pinnedFolder);
}
