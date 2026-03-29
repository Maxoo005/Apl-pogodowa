import "package:flutter_riverpod/flutter_riverpod.dart";

final isCelsiusProvider = StateProvider<bool>((_) => true);
final is24hProvider = StateProvider<bool>((_) => true);

double toDisplayTemp(double tC, bool isC) => isC ? tC : (tC * 9 / 5 + 32);
