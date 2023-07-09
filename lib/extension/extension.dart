extension DateExtension on String {
  String getDateFormat() {
    final year = this.substring(0, 4).toString();
    final month = this.substring(4, 6).toString();
    final date = this.substring(6, 8).toString();
    final hour = this.substring(8, 10).toString();
    final minute = this.substring(10, 12).toString();
    final second = this.substring(12, 14).toString();

    return "$month/$date/$year  $hour:$minute:$second";
  }
}
