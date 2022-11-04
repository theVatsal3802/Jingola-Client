import 'package:flutter/material.dart';

import '../screens/voucher_screen.dart';
import '../models/voucher_model.dart';

class PromoBox extends StatelessWidget {
  final Voucher voucher;
  const PromoBox({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          VoucherScreen.routeName,
          arguments: false,
        );
      },
      child: Stack(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.75,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  voucher.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ClipPath(
            clipper: PromoCustomClipper(),
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width * 0.7,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 125,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.code,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      voucher.description,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                          ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromoCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(175, size.height);
    path.lineTo(225, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
