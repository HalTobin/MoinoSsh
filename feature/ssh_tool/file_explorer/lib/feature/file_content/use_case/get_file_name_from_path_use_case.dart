class GetFileNameFromPathUseCase {

    String? execute(String filePath) {
        return filePath.split("/").lastOrNull;
    }

}