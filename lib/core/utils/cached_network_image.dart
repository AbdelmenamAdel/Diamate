// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class CachedNetworkImageWidget extends StatelessWidget {
//   const CachedNetworkImageWidget({super.key, required this.imageUrl});
//   final String imageUrl;
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return CachedNetworkImage(
//         imageUrl: imageUrl.isEmpty
//             ? 'https://via.placeholder.com/150' // Default placeholder image URL
//             : imageUrl,
//         height: 170.h,
//         width: double.infinity,
//         fit: BoxFit.fill,

//         placeholder: (context, url) => Skeletonizer(
//           enabled: true,
//           child: Container(
//             height: 170.h,
//             width: double.infinity,
//             color: Colors.grey[300],
//           ),
//         ),

//         errorWidget: (context, url, error) =>
//             const Icon(Icons.info, size: 40, color: Colors.redAccent),
//       );
//     } catch (e) {
//       return const Icon(Icons.info, size: 40, color: Colors.redAccent);
//     }
//   }
// }
