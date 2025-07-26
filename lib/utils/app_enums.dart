import 'package:flutter/material.dart';

enum ImageType { svg, png, other }

enum FileType { asset, network, file, other }

enum StorageKey {
  user,
  userid,
  token,
  userLocation,
  ;

  String get name => switch (this) {
        StorageKey.user => 'username',
        StorageKey.userid => 'userid',
        StorageKey.token => 'token',
        StorageKey.userLocation => 'userLocation',
      };
}

enum MediaType { image, video }

enum NotificationStatus {
  granted,
  denied,
  permanentlyDenied;
}

enum HelpLine {
  police('Police', '100', Icons.local_police),
  ambulance('Ambulance', '108', Icons.local_hospital),
  fireBrigade('Fire Brigade', '101', Icons.fire_truck),
  pmc('PMC', '18001030222', Icons.location_city),
  childHelpline('Child Helpline', '1098', Icons.child_care),
  womenHelpline('Women Helpline', '1091', Icons.woman);

  final String name;
  final String number;
  final IconData icon;

  const HelpLine(this.name, this.number, this.icon);
}
