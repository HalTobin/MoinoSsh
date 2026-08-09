class ImageMetadata {
    final int? width;
    final int? height;
    final DateTime? captureTime;
    final String? location;
    final String? colorSpace;

    const ImageMetadata({
        this.width,
        this.height,
        this.captureTime,
        this.location,
        this.colorSpace,
    });

    String? get resolution {
        if (width == null || height == null) return null;
        return "$width × $height";
    }
}
