import 'package:flutter/material.dart';

/// Centralized design tokens: colors, spacing, radii, typography and sizes.
/// Used across the app to avoid hard‑coded values and keep visual consistency.
class AppDesign {
  AppDesign._();

  // ─── Colors ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFCBA8EA);
  static const Color primaryLight = Color(0xFFEDE7F6);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color placeholder = Color(0xFFF5F5F5);
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF616161); // grey[700]
  static const Color textHint = Color(0xFF9E9E9E); // grey
  static const Color textMuted = Colors.black54;
  static const Color textMutedLight = Colors.black38;
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFBDBDBD);
  static const Color error = Colors.red;
  static const Color divider = Colors.black12;
  static const Color overlayBarrier = Colors.black38;
  static const Color shadowLight = Color(0x1F000000); // black 12%
  static const Color appBarIcon = Color(0xFF8B8B8B);
  static const Color shimmerBase = Color(0xFFE0E0E0); // grey.shade300
  static const Color shimmerHighlight = Color(0xFFF5F5F5); // grey.shade100

  // ─── Spacing ─────────────────────────────────────────────────────────────
  static const double pagePaddingH = 16.0;
  static const double pagePaddingV = 12.0;
  static const double sectionHeaderPaddingTop = 16.0;
  static const double sectionHeaderPaddingBottom = 4.0;
  static const double tilePaddingH = 16.0;
  static const double tilePaddingV = 12.0;
  static const double gapImageText = 16.0;
  static const double spaceXs = 4.0;
  static const double spaceS = 6.0;
  static const double spaceM = 8.0;
  static const double spaceL = 12.0;
  static const double spaceXL = 16.0;
  static const double spaceXXL = 20.0;
  static const double spaceSection = 24.0;
  static const double loadingFooterHeight = 80.0;
  static const double communitySectionHeight = 170.0;
  static const double communitySectionBottomGap = 4.0;
  /// Community card width = screen width - communityCardHorizontalMargin * 2.
  static const double communityCardHorizontalMargin = 16.0;
  static const double sheetPaddingH = 24.0;
  static const double sheetPaddingTop = 28.0;
  static const double sheetPaddingBottom = 32.0;
  static const double profileHandleWidth = 40.0;
  static const double profileHandleHeight = 4.0;
  static const double profileHandleMarginBottom = 20.0;
  static const double profileAvatarRadius = 34.0;
  static const double profileSpacingAfterAvatar = 12.0;
  static const double profileSpacingBeforeButton = 24.0;
  static const double profileButtonPaddingV = 14.0;
  static const double caughtUpPaddingV = 24.0;
  static const double caughtUpLineWidth = 40.0;
  static const double caughtUpLineHeight = 1.0;
  static const double loadingMorePaddingV = 20.0;

  // Predefined EdgeInsets helpers
  static const EdgeInsets sectionHeaderPadding = EdgeInsets.fromLTRB(
    pagePaddingH,
    sectionHeaderPaddingTop,
    pagePaddingH,
    sectionHeaderPaddingBottom,
  );
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(
    horizontal: tilePaddingH,
    vertical: tilePaddingV,
  );
  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(
    sheetPaddingH,
    sheetPaddingTop,
    sheetPaddingH,
    sheetPaddingBottom,
  );

  // ─── Corner radii ───────────────────────────────────────────────────────
  static const double radiusTile = 24.0;
  static const double radiusCard = 12.0;
  static const double radiusSheet = 24.0;
  static const double radiusLine = 4.0;
  static const double radiusSmall = 2.0;
  static const double radiusPill = 30.0;
  static const double radiusAvatarSmall = 16.0;

  static BorderRadius get borderRadiusTile => BorderRadius.circular(radiusTile);
  static BorderRadius get borderRadiusCard => BorderRadius.circular(radiusCard);
  static BorderRadius get borderRadiusSheet => BorderRadius.circular(radiusSheet);
  static BorderRadius get borderRadiusLine => BorderRadius.circular(radiusLine);
  static BorderRadius get borderRadiusSheetTop =>
      const BorderRadius.vertical(top: Radius.circular(radiusSheet));

  // ─── Sizes (icons, images, avatars) ─────────────────────────────────────
  static const double tileImageSize = 130.0;
  static const double iconXs = 16.0;
  static const double iconS = 18.0;
  static const double iconM = 20.0;
  static const double iconL = 22.0;
  static const double iconXL = 28.0;
  static const double iconPlaceholder = 30.0;
  static const double iconSuccess = 56.0;
  static const double appBarIconSize = 20.0;
  static const double profileAvatarIconSize = 34.0;
  static const double successOverlaySize = 140.0;
  static const double detailBodyPaddingH = 22.0;
  static const double detailImageHeight = 250.0;
  static const double detailImagePlaceholderHeight = 200.0;
  static const double detailDescriptionPaddingH = 14.0;
  static const double detailDescriptionPaddingV = 18.0;
  static const double detailPlaceholderIconSize = 64.0;
  static const double publishImagePickerHeight = 140.0;
  static const double publishFormPaddingH = 20.0;
  static const double publishFormSpacing = 20.0;
  static const double publishBackIconSize = 28.0;
  static const double primaryWithAlpha = 0.45; // for attach‑image button background

  // ─── Typography ─────────────────────────────────────────────────────────
  static const double fontSizeSectionTitle = 15.0;
  static const double fontSizeTitle = 18.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeBodySmall = 14.0;
  static const double fontSizeCaption = 12.0;
  static const double fontSizeAppBarTitle = 20.0;
  static const double fontSizeAppBarSubtitle = 13.0;
  static const double fontSizeInput = 16.0;
  static const double fontSizeInputSmall = 15.0;
  static const double fontSizeButton = 18.0;
  static const double fontSizeOverlay = 15.0;
  static const double fontSizeCaughtUp = 12.0;

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: fontSizeSectionTitle,
    fontWeight: FontWeight.w700,
    color: textMuted,
    letterSpacing: 0.2,
  );
  static const TextStyle titleStyle = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.2,
  );
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeBody,
    color: textPrimary,
  );
  static const TextStyle bodySmallStyle = TextStyle(
    fontSize: fontSizeBodySmall,
    color: textSecondary,
    height: 1.4,
  );
  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeCaption,
    color: textHint,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle caughtUpStyle = TextStyle(
    color: textMutedLight,
    fontSize: fontSizeCaughtUp,
  );
  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: fontSizeButton,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static const TextStyle inputStyle = TextStyle(
    fontSize: fontSizeInput,
    color: textPrimary,
  );
  static const TextStyle inputHintStyle = TextStyle(
    color: borderLight,
  );
  static const TextStyle profileTitleStyle = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle profileSubtitleStyle = TextStyle(
    fontSize: fontSizeCaption + 1,
    color: textMuted,
  );
  static const TextStyle signOutStyle = TextStyle(color: error);
  static const TextStyle successOverlayStyle = TextStyle(
    fontSize: fontSizeOverlay,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static const TextStyle detailTitleStyle = TextStyle(
    fontFamily: 'Butler',
    fontSize: fontSizeAppBarTitle,
    fontWeight: FontWeight.w900,
  );
}
