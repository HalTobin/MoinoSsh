import 'package:domain/model/server_profile.dart';
import 'package:flutter/material.dart';

class ProfilesDropdown extends StatelessWidget {
  final String title;
  final ServerProfile currentProfile;
  final List<ServerProfile> profiles;
  final Function(ServerProfile) onProfileSelect;

  const ProfilesDropdown({
    super.key,
    required this.title,
    required this.currentProfile,
    required this.profiles,
    required this.onProfileSelect
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: (profiles.isNotEmpty && profiles.contains(currentProfile))
          ? DropdownButtonHideUnderline(
            child: DropdownButton<ServerProfile>(
              isExpanded: true,
              value: currentProfile,
              padding: EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onChanged: (ServerProfile? newProfile) {
                if (newProfile != null) {
                  onProfileSelect(newProfile);
                }
              },
              items: profiles.map((profile) {
                return DropdownMenuItem<ServerProfile>(
                  value: profile,
                  child: Center(
                    child: Text(
                      profile.getIdentifier(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }).toList(),
            )
        )
          : Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
      ),
    );
  }
}