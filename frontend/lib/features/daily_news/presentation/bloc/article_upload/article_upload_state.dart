abstract class ArticleUploadState {}

class ArticleUploadInitial extends ArticleUploadState {}

class ArticleUploadLoading extends ArticleUploadState {}

class ArticleUploadSuccess extends ArticleUploadState {}

class ArticleUploadError extends ArticleUploadState {
  final String message;
  ArticleUploadError(this.message);
}
