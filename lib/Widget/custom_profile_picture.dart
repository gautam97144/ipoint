import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:ipoint/Screen/menu_page.dart';
import 'package:ipoint/global/images.dart';

class CustomProfilePicture extends StatelessWidget {
  String? url;
  Function()? onTap;
  int? status;
  CustomProfilePicture({Key? key, required this.url, this.onTap, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (status != 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuPage()));
          } else {
            print("no navigation");
          }
        },
        child: CachedNetworkImage(
          imageUrl: url ?? "",
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: 35,
              backgroundImage: imageProvider,
            );
          },
          placeholder: (context, url) => CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(Images.profileImage),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(Images.profileImage),
          ),
        )

        // CircleAvatar(
        //   backgroundImage: CachedNetworkImageProvider(url!),
        // ),
        );
  }
}
