import 'package:flutter/foundation.dart';

/// Global reactive notifiers for citizen profile state in DocuSewa Mobile
class ProfileState {
  static const String defaultAvatar =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80';

  static final ValueNotifier<String> avatarNotifier =
      ValueNotifier<String>(defaultAvatar);

  static final ValueNotifier<String> fullNameNotifier =
      ValueNotifier<String>('Dilkhush Kumar');

  static final ValueNotifier<String> phoneNotifier =
      ValueNotifier<String>('+91 98765 43210');

  static final ValueNotifier<String> emailNotifier =
      ValueNotifier<String>('dilkhush.citizen@docusewa.gov.in');

  static final ValueNotifier<String> fatherNameNotifier =
      ValueNotifier<String>('Rajendra Kumar');

  static final ValueNotifier<String> addressNotifier =
      ValueNotifier<String>('H-42, Sector 62, Electronic City, Noida');
}
