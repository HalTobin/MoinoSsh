String getProfileTitle({
  required String user,
  required String url,
  required String port
}) {
  return "$user@$url:$port";
}