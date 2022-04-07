import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CharacterNameWidget extends StatelessWidget {
  const CharacterNameWidget(
      {Key? key, required this.name, this.avatarUrl, this.onTap})
      : super(key: key);

  final String name;
  final String? avatarUrl;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -10,
              )
            ]),
        height: 80,
        width: double.infinity,
        child: Row(
          children: [
            if (avatarUrl != null)
              CachedNetworkImage(
                height: 40,
                width: 40,
                fit: BoxFit.contain,
                imageUrl: avatarUrl ?? '',
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.transparent,
                ),
                placeholder: (context, url) => const Icon(Icons.person),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            else
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.error),
              ),
            const SizedBox(
              width: 20,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
