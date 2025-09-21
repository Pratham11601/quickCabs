import 'package:QuickCab/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  final String? networkUrl;
  final String? defaultImagePath;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool? isShowBorder;
  final BoxShape boxShape;
  final BoxFit? fit;
  final bool? isAssetImage;
  final Color? imageColor;

  const CacheImage({
    super.key,
    required this.networkUrl,
    this.defaultImagePath,
    this.borderColor,
    this.borderRadius,
    this.isShowBorder = true,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.isAssetImage = false,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    if (networkUrl != null && networkUrl!.isNotEmpty && networkUrl != '') {
      bool isSvgImage = networkUrl!.contains('.svg');
      if (isSvgImage == true) {
        return isAssetImage! == true
            ? SvgPicture.asset(networkUrl!)
            : SvgPicture.network(
                networkUrl != null && networkUrl!.isNotEmpty ? networkUrl! : '',
                fit: fit!,
                placeholderBuilder: (context) => Shimmer.fromColors(
                  baseColor: ColorsForApp.shimmerBaseColor,
                  highlightColor: ColorsForApp.shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsForApp.whiteColor,
                      shape: boxShape,
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: isShowBorder == true
                            ? borderColor ??
                                ColorsForApp.grey.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: isShowBorder == true ? 1 : 0,
                      ),
                    ),
                  ),
                ),
              );
      } else {
        return isAssetImage! == true
            ? Image.asset(networkUrl!, color: imageColor)
            : CachedNetworkImage(
                imageUrl: networkUrl != null && networkUrl!.isNotEmpty
                    ? networkUrl!
                    : '',
                fit: fit,
                color: imageColor,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: boxShape,
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: isShowBorder == true
                          ? borderColor ??
                              ColorsForApp.grey.withValues(alpha: 0.5)
                          : Colors.transparent,
                      width: isShowBorder == true ? 1 : 0,
                    ),
                    image: DecorationImage(image: imageProvider, fit: fit),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: ColorsForApp.shimmerBaseColor,
                  highlightColor: ColorsForApp.shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsForApp.whiteColor,
                      shape: boxShape,
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: isShowBorder == true
                            ? borderColor ??
                                ColorsForApp.grey.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: isShowBorder == true ? 1 : 0,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    shape: boxShape,
                    border: Border.all(
                      color: isShowBorder == true
                          ? borderColor ??
                              ColorsForApp.grey.withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: isShowBorder == true ? 1 : 0,
                    ),
                    image: DecorationImage(
                      image: AssetImage(defaultImagePath ?? ''),
                      fit: fit,
                    ),
                  ),
                ),
              );
      }
    } else {
      return Container(
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor.withValues(alpha: 0.1),
          shape: boxShape,
          borderRadius: borderRadius,
          border: Border.all(
            color: isShowBorder == true
                ? borderColor ?? ColorsForApp.grey.withValues(alpha: 0.2)
                : Colors.transparent,
            width: isShowBorder == true ? 1 : 0,
          ),
          image: DecorationImage(
            image: AssetImage(defaultImagePath ?? ''),
            fit: fit,
          ),
        ),
      );
    }
  }
}
