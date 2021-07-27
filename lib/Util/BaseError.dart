class BaseError implements Exception {
    final String msg;
    const BaseError(this.msg);
    String toString() => this.msg;
}