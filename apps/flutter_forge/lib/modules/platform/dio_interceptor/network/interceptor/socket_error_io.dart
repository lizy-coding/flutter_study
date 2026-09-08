import 'dart:io';

bool isSocketError(Object? error) => error is SocketException;
