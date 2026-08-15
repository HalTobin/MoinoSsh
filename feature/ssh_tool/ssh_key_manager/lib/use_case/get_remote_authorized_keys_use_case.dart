import 'package:domain/model/response_result.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:util/text/content_digest.dart';

import '../model/authorized_keys_file.dart';
import 'resolve_authorized_keys_path_use_case.dart';

class GetRemoteAuthorizedKeysUseCase {
    GetRemoteAuthorizedKeysUseCase({
        required ResolveAuthorizedKeysPathUseCase resolveAuthorizedKeysPathUseCase,
        required SftpService sftpService,
    }) : _resolveAuthorizedKeysPathUseCase = resolveAuthorizedKeysPathUseCase,
         _sftpService = sftpService;

    final ResolveAuthorizedKeysPathUseCase _resolveAuthorizedKeysPathUseCase;
    final SftpService _sftpService;

    Future<ResponseResult<RemoteAuthorizedKeysSnapshot>> execute() async {
        final pathResult = await _resolveAuthorizedKeysPathUseCase.execute();
        final String authorizedKeysPath;
        switch (pathResult) {
            case ResponseFailed(error: final error):
                return ResponseFailed(error: error);
            case ResponseSucceed(data: final path):
                authorizedKeysPath = path;
        }

        final fileResult = await _sftpService.readTextFileIfExists(authorizedKeysPath);
        switch (fileResult) {
            case ResponseFailed(error: final error):
                return ResponseFailed(error: error);
            case ResponseSucceed(data: final file):
                return ResponseSucceed(
                    RemoteAuthorizedKeysSnapshot(
                        authorizedKeysPath: authorizedKeysPath,
                        file: file == null
                            ? AuthorizedKeysFile.empty
                            : AuthorizedKeysFile.parse(file.content),
                        fileExists: file != null,
                        contentHash: file == null
                            ? ''
                            : ContentDigest.of(file.content),
                    ),
                );
        }
    }
}
