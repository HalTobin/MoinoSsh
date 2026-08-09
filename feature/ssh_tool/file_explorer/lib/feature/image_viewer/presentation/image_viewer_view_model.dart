import 'dart:async';

import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_event.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_state.dart';
import 'package:feature_file_explorer/feature/image_viewer/use_case/image_viewer_use_cases.dart';
import 'package:flutter/foundation.dart';

class ImageViewerViewModel extends ChangeNotifier {
    final String filePath;

    ImageViewerViewModel({
        required ImageViewerUseCases imageViewerUseCases,
        required this.filePath,
    }) : _useCases = imageViewerUseCases {
        if (kDebugMode) {
            print("[$_tag] init()");
        }
        _init();
    }

    final ImageViewerUseCases _useCases;

    ImageViewerState _state = const ImageViewerState();
    ImageViewerState get state => _state;

    final StreamController<ImageViewerUiEvent> _uiEventController =
        StreamController<ImageViewerUiEvent>.broadcast();
    Stream<ImageViewerUiEvent> get uiEvent => _uiEventController.stream;

    Future<void> _init() async {
        _state = _state.copyWith(filePath: filePath);
        await _loadImage(filePath);
    }

    Future<void> onEvent(ImageViewerEvent event) async {
        switch (event) {
            case ReloadImage():
                await _loadImage(filePath);
            case ShowImageInfo():
                _uiEventController.add(OpenImageInfoModal());
        }
    }

    Future<void> _loadImage(String path) async {
        _state = _state.copyWith(loading: true, errorMessage: null);
        notifyListeners();

        try {
            final file = await _useCases.loadImageBytesUseCase.execute(path);
            if (file == null) {
                _state = _state.copyWith(
                    loading: false,
                    file: null,
                    metadata: null,
                    errorMessage: "Unable to load image",
                );
                notifyListeners();
                return;
            }

            final metadata = await _useCases.parseImageMetadataUseCase.execute(file.bytes);
            _state = _state.copyWith(
                loading: false,
                file: file,
                metadata: metadata,
                errorMessage: null,
            );
            notifyListeners();
        } catch (e) {
            if (kDebugMode) {
                print("[$_tag] Failed to load image: $e");
            }
            _state = _state.copyWith(
                loading: false,
                errorMessage: e.toString(),
            );
            notifyListeners();
        }
    }

    @override
    void dispose() {
        _uiEventController.close();
        super.dispose();
    }

    static final String _tag = "ImageViewerViewModel";
}

sealed class ImageViewerUiEvent {}

class OpenImageInfoModal extends ImageViewerUiEvent {}
