import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
  runApp(const KaizenApp());
}

// ═══════════════════════════════════════════════
//  Root App
// ═══════════════════════════════════════════════
class KaizenApp extends StatelessWidget {
  const KaizenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaizen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: kIsWeb ? const WebPhoneFrame() : const AppShell(),
    );
  }
}

// ═══════════════════════════════════════════════
//  Web Preview — Vivo V40 phone shell
// ═══════════════════════════════════════════════
class WebPhoneFrame extends StatelessWidget {
  const WebPhoneFrame({super.key});

  @override
  Widget build(BuildContext context) {
    const double phoneW = 375;
    const double phoneH = 833;
    const double clipR  = 46.0;
    const double shell  = 12.0;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Center(
        child: Container(
          width:  phoneW + shell * 2,
          height: phoneH + shell * 2,
          decoration: BoxDecoration(
            color:        const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(clipR + shell),
            boxShadow: [
              BoxShadow(
                color:        Colors.black.withValues(alpha: 0.85),
                blurRadius:   48,
                spreadRadius: 8,
              ),
            ],
            border: Border.all(color: const Color(0xFF2E2E2E), width: shell),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(clipR),
            child: const SizedBox(
              width:  phoneW,
              height: phoneH,
              child:  AppShell(),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Card Metadata
// ═══════════════════════════════════════════════
class TabCardInfo {
  final String title;
  final String subtitle;
  final IconData icon;

  const TabCardInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

const List<TabCardInfo> kTabCards = [
  TabCardInfo(
    title: 'HOME',
    subtitle: 'Daily Overview & Stats',
    icon: Icons.home_outlined,
  ),
  TabCardInfo(
    title: 'BUILD',
    subtitle: 'Strength & Fitness Plan',
    icon: Icons.bolt_rounded,
  ),
  TabCardInfo(
    title: 'MOVE',
    subtitle: 'Workouts & Live Activity',
    icon: Icons.directions_run_rounded,
  ),
  TabCardInfo(
    title: 'CONNECT',
    subtitle: 'Community & Challenges',
    icon: Icons.groups_outlined,
  ),
];

// ═══════════════════════════════════════════════
//  Card Geometry Helper
// ═══════════════════════════════════════════════
class CardGeometry {
  final double left;
  final double top;
  final double width;
  final double height;
  final double radius;

  const CardGeometry({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.radius,
  });

  static CardGeometry mainCard(double screenW, double screenH) {
    const double left = 28.0;
    const double right = 28.0;
    const double top = 100.0;
    const double bottom = 145.0;
    return CardGeometry(
      left: left,
      top: top,
      width: screenW - left - right,
      height: screenH - top - bottom,
      radius: 22.0,
    );
  }

  static CardGeometry buttonSlot(int index, double screenW, double screenH) {
    const double buttonSize = 64.0;
    final double rowW = screenW - 56.0 - 24.0;
    final double gap = (rowW - (buttonSize * 4)) / 3.0;
    final double left = 28.0 + 12.0 + index * (buttonSize + gap);
    const double bottom = 43.0;
    final double top = screenH - bottom - buttonSize;
    return CardGeometry(
      left: left,
      top: top,
      width: buttonSize,
      height: buttonSize,
      radius: 16.0,
    );
  }

  static CardGeometry lerp(CardGeometry a, CardGeometry b, double t) {
    return CardGeometry(
      left: a.left + (b.left - a.left) * t,
      top: a.top + (b.top - a.top) * t,
      width: a.width + (b.width - a.width) * t,
      height: a.height + (b.height - a.height) * t,
      radius: a.radius + (b.radius - a.radius) * t,
    );
  }
}

// ═══════════════════════════════════════════════
//  Neumorphic Sculpted Components
// ═══════════════════════════════════════════════

/// Sculpted OUT (Elevated / Extruded) Neumorphic Box
class NeumorphicElevatedBox extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? headerLeading;
  final Widget? headerTrailing;
  final EdgeInsetsGeometry padding;

  const NeumorphicElevatedBox({
    super.key,
    required this.title,
    required this.child,
    this.headerLeading,
    this.headerTrailing,
    this.padding = const EdgeInsets.fromLTRB(8, 6, 8, 8),
  });

  static const Color _beige = Color(0xFFEBDDBF); // matte beige matching bezel
  static const Color _darkShadow = Color(0xFF6B5535);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _beige,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Soft ambient top edge (matte, zero white glow)
          BoxShadow(
            color: const Color(0xFFF5EDDC).withValues(alpha: 0.60),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
            spreadRadius: 0,
          ),
          // Bottom-right warm matte depth shadow
          BoxShadow(
            color: _darkShadow.withValues(alpha: 0.22),
            offset: const Offset(3.5, 3.5),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elevated title / header region
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 4, top: 1, right: 2),
            child: Row(
              children: [
                if (headerLeading != null) ...[
                  headerLeading!,
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: headerLeading != null ? TextAlign.center : TextAlign.start,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: Color(0xFF3B2A16),
                    ),
                  ),
                ),
                if (headerTrailing != null) ...[
                  const SizedBox(width: 6),
                  headerTrailing!,
                ],
              ],
            ),
          ),
          // Lower carved-in content region
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Sculpted INSIDE (Carved-in / Inset) Neumorphic Cavity
/// - Matte darker brown than the card (#A8845B vs card #D4B28A)
/// - Matte inner depth shadow (zero white glow)
class NeumorphicCarvedCavity extends StatelessWidget {
  final Widget child;
  final double radius;

  const NeumorphicCarvedCavity({
    super.key,
    required this.child,
    this.radius = 14.0,
  });

  // Darker brown than the card (#D4B28A)
  static const Color _cavityDarkBrown = Color(0xFFA8845B);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cavityDarkBrown,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: const Color(0xFF5E4527).withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Inner shadow overlay simulating matte carved-in depth (no white glow)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF382613).withValues(alpha: 0.32),
                      const Color(0xFF382613).withValues(alpha: 0.08),
                      Colors.transparent,
                      const Color(0xFFB89368).withValues(alpha: 0.20),
                    ],
                    stops: const [0.0, 0.20, 0.65, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            child,
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Home Card Neumorphic Body
// ═══════════════════════════════════════════════
class HomeCardBody extends StatelessWidget {
  const HomeCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ── 1. Top Section: Big Character Display Box ──
          const Expanded(
            child: NeumorphicElevatedBox(
              title: 'CHARACTER',
              child: NeumorphicCarvedCavity(
                // Left blank for pre-rendered character video
                child: SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // ── 2. Bottom Section: Step Count & Calorie Count True Square Boxes ──
          Row(
            children: [
              // Step count box (true square container)
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.94,
                  child: const NeumorphicElevatedBox(
                    title: 'STEP COUNT',
                    child: NeumorphicCarvedCavity(
                      child: _StatProgressContent(
                        percentage: 0.84,
                        percentLabel: '84%',
                        valueLabel: '8,400 / 10,000',
                        activeColor: Color(0xFF3B2A16),
                        trackColor: Color(0x383B2A16),
                        textColor: Color(0xFF3B2A16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Calorie count box (true square container)
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.94,
                  child: const NeumorphicElevatedBox(
                    title: 'CALORIE COUNT',
                    child: NeumorphicCarvedCavity(
                      child: _StatProgressContent(
                        percentage: 0.72,
                        percentLabel: '72%',
                        valueLabel: '540 / 750 KCAL',
                        activeColor: Color(0xFF3B2A16),
                        trackColor: Color(0x383B2A16),
                        textColor: Color(0xFF3B2A16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw an exact, crisp circular progress ring
/// - Starts at top (12 o'clock)
/// - Exact radius and stroke width guaranteed
/// - Smooth rounded caps
class _ProgressRingPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    // 1. Background full track ring
    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Active progress arc
    if (progress > 0.0) {
      final Paint progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const double startAngle = -math.pi / 2; // 12 o'clock
      final double sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// A neat, dedicated progress ring component with centered percentage
class NeatProgressRing extends StatelessWidget {
  final double progress;
  final String percentLabel;
  final Color activeColor;
  final Color trackColor;
  final Color textColor;
  final double size;
  final double strokeWidth;
  final double fontSize;

  const NeatProgressRing({
    super.key,
    required this.progress,
    required this.percentLabel,
    required this.activeColor,
    required this.trackColor,
    required this.textColor,
    required this.size,
    required this.strokeWidth,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: progress,
          trackColor: trackColor,
          progressColor: activeColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            percentLabel,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Content inside each stat card:
/// 1. Large, prominent progress circle (dominates the space)
/// 2. Clean percentage centered neatly inside the circle (with generous breathing room)
/// 3. Accurate progress number below
class _StatProgressContent extends StatelessWidget {
  final double percentage;
  final String percentLabel;
  final String valueLabel;
  final Color activeColor;
  final Color trackColor;
  final Color textColor;

  const _StatProgressContent({
    required this.percentage,
    required this.percentLabel,
    required this.valueLabel,
    required this.activeColor,
    required this.trackColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availH = constraints.maxHeight;
        final double availW = constraints.maxWidth;

        // Ensure circle is truly large and fills the container prominently (~75-80%)
        final double ringSize = math.min(availW - 16.0, availH - 28.0).clamp(36.0, 92.0);
        final double strokeW = (ringSize * 0.095).clamp(5.0, 8.5);
        // Percentage font size is ~18-19% of ring size so it sits comfortably inside with ~18dp clearance
        final double pctFontSize = (ringSize * 0.19).clamp(10.0, 17.5);
        final double valFontSize = (ringSize * 0.135).clamp(8.0, 12.5);
        final double gap = (ringSize * 0.07).clamp(3.0, 8.0);

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Large neat circle with percentage comfortably inside
                NeatProgressRing(
                  progress: percentage,
                  percentLabel: percentLabel,
                  activeColor: activeColor,
                  trackColor: trackColor,
                  textColor: textColor,
                  size: ringSize,
                  strokeWidth: strokeW,
                  fontSize: pctFontSize,
                ),
                SizedBox(height: gap),
                // Accurate progress in number below
                Text(
                  valueLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: valFontSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: activeColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════
//  Build Card Components & Body
// ═══════════════════════════════════════════════

/// Custom painter to draw an XP activity line chart
/// - Smooth bezier curve with filled area beneath
/// - Subtle grid lines
/// - Circular data dots with highlighted peak
/// - X-axis day/date labels
class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  static const Color _lineColor = Color(0xFF3B2A16);
  static const Color _gridColor = Color(0x283B2A16);

  _LineChartPainter({
    required this.values,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const double bottomPadding = 24.0;
    const double topPadding = 24.0;
    const double horizontalPadding = 18.0;

    final double chartWidth = size.width - (horizontalPadding * 2);
    final double chartHeight = size.height - topPadding - bottomPadding;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    final double maxVal = (values.reduce(math.max) * 1.18).clamp(100.0, double.infinity);
    const double minVal = 0.0;

    // 1. Draw subtle horizontal grid lines (3 lines)
    final Paint gridPaint = Paint()
      ..color = _gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i <= 3; i++) {
      final double y = topPadding + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(horizontalPadding, y),
        Offset(size.width - horizontalPadding, y),
        gridPaint,
      );
    }

    // 2. Compute point coordinates
    final List<Offset> points = [];
    final double stepX = values.length > 1
        ? chartWidth / (values.length - 1)
        : chartWidth;

    for (int i = 0; i < values.length; i++) {
      final double x = horizontalPadding + (i * stepX);
      final double normY = (values[i] - minVal) / (maxVal - minVal);
      final double y = topPadding + chartHeight - (normY * chartHeight);
      points.add(Offset(x, y));
    }

    // 3. Draw gradient fill beneath line
    final Path fillPath = Path();
    fillPath.moveTo(points.first.dx, topPadding + chartHeight);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];
      final Offset cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final Offset cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, topPadding + chartHeight);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _lineColor.withValues(alpha: 0.32),
          _lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, topPadding, size.width, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // 4. Draw smooth stroke curve
    final Path strokePath = Path();
    strokePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];
      final Offset cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final Offset cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      strokePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    final Paint strokePaint = Paint()
      ..color = _lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(strokePath, strokePaint);

    // 5. Draw data dots and peak point
    final double maxDataVal = values.reduce(math.max);
    final Paint dotPaint = Paint()..color = _lineColor;
    final Paint dotInnerPaint = Paint()..color = const Color(0xFFEBDDBF);

    for (int i = 0; i < points.length; i++) {
      final bool isPeak = values[i] == maxDataVal;
      final double r = isPeak ? 4.5 : 3.0;

      canvas.drawCircle(points[i], r, dotPaint);
      if (isPeak) {
        canvas.drawCircle(points[i], 2.2, dotInnerPaint);
      }
    }

    // 6. Draw X-axis text labels
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < labels.length && i < points.length; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF3B2A16),
          letterSpacing: 0.3,
        ),
      );
      textPainter.layout();
      final double textX = points[i].dx - (textPainter.width / 2);
      final double textY = size.height - bottomPadding + 6.0;
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}

/// 3D Keycap "ENTER" button matching the 4 menu buttons' tactile extrusion style
class KeycapEnterButton extends StatefulWidget {
  final VoidCallback? onTap;

  const KeycapEnterButton({super.key, this.onTap});

  @override
  State<KeycapEnterButton> createState() => _KeycapEnterButtonState();
}

class _KeycapEnterButtonState extends State<KeycapEnterButton> {
  bool _isPressed = false;

  static const double _width = 54.0;
  static const double _height = 24.0;
  static const double _depth = 3.5;
  static const double _radius = 6.0;

  // Cream / white face with extruded warm brown/taupe base lip
  static const Color _faceColor = Color(0xFFFBF7EE);
  static const Color _baseLipColor = Color(0xFF8C7150);
  static const Color _textColor = Color(0xFF3B2A16);

  @override
  Widget build(BuildContext context) {
    final double pressOffset = _isPressed ? (_depth - 1.0) : 0.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Extruded bottom lip
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: _baseLipColor,
                  borderRadius: BorderRadius.circular(_radius),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C1A0A).withValues(alpha: 0.20),
                      offset: const Offset(0, 1.5),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
              ),
            ),
            // 2. Tactile 3D top face
            Positioned(
              left: 0,
              right: 0,
              top: pressOffset,
              height: _height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: _faceColor,
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(
                    color: const Color(0xFF5E4527).withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ENTER',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: _textColor,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 9.5,
                      color: _textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Neumorphic Range Dropdown Button (7D, 1M, 1Y, 5Y)
class RangeDropdownButton extends StatelessWidget {
  final String selectedRange; // '7D', '1M', '1Y', '5Y'
  final ValueChanged<String> onRangeChanged;

  const RangeDropdownButton({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  static const List<Map<String, String>> _options = [
    {'key': '7D', 'label': '7 Days'},
    {'key': '1M', 'label': '1 Month'},
    {'key': '1Y', 'label': '1 Year'},
    {'key': '5Y', 'label': '5 Years'},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFFEBDDBF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF5E4527).withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
          elevation: 6,
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Select Range',
        initialValue: selectedRange,
        onSelected: onRangeChanged,
        offset: const Offset(0, 26),
        itemBuilder: (context) {
          return _options.map((opt) {
            final bool isSelected = opt['key'] == selectedRange;
            return PopupMenuItem<String>(
              value: opt['key'],
              height: 36,
              child: Row(
                children: [
                  Text(
                    opt['key']!,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? const Color(0xFF3B2A16)
                          : const Color(0xFF5E4527),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    opt['label']!,
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF3B2A16)
                          : const Color(0xFF7A6044),
                    ),
                  ),
                  if (isSelected) ...[
                    const Spacer(),
                    const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Color(0xFF3B2A16),
                    ),
                  ],
                ],
              ),
            );
          }).toList();
        },
        child: Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFDFCEAE),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xFF5E4527).withValues(alpha: 0.35),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B2A16).withValues(alpha: 0.12),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedRange,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3B2A16),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.arrow_drop_down_rounded,
                size: 16,
                color: Color(0xFF3B2A16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Range shifting navigation buttons (< and >)
class RangeShiftControls extends StatelessWidget {
  final String rangeLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  const RangeShiftControls({
    super.key,
    required this.rangeLabel,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left button (<)
        _ShiftButton(
          icon: Icons.chevron_left_rounded,
          onTap: onPrevious,
        ),
        const SizedBox(width: 3),
        // Shift label
        Text(
          rangeLabel,
          style: const TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
            color: Color(0xFF3B2A16),
          ),
        ),
        const SizedBox(width: 3),
        // Right button (>)
        _ShiftButton(
          icon: Icons.chevron_right_rounded,
          onTap: canGoNext ? onNext : null,
          enabled: canGoNext,
        ),
      ],
    );
  }
}

class _ShiftButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _ShiftButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFDFCEAE) : const Color(0xFFE5D8BE),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF5E4527).withValues(alpha: enabled ? 0.35 : 0.15),
            width: 0.8,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14,
          color: enabled ? const Color(0xFF3B2A16) : const Color(0xFF9E8B75),
        ),
      ),
    );
  }
}

/// Horizontal progress bar with debossed track and XP status
class BuildHorizontalProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String percentLabel; // e.g. "50%", "0%"
  final String xpLabel; // e.g. "+500 / 1000 XP"

  const BuildHorizontalProgressBar({
    super.key,
    required this.progress,
    required this.percentLabel,
    required this.xpLabel,
  });

  static const Color _darkBrown = Color(0xFF3B2A16);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // 1. Debossed progress track with fill bar
                      Expanded(
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: _darkBrown.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: _darkBrown.withValues(alpha: 0.25),
                              width: 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _darkBrown,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 2. Percentage text on right
                      SizedBox(
                        width: 38,
                        child: Text(
                          percentLabel,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: _darkBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // 3. XP Label below
                  Text(
                    xpLabel,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: _darkBrown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ═══════════════════════════════════════════════
///  Build Card Neumorphic Body
///  - Activity Line Chart with range dropdown & range shifting
///  - Dailies container with progress bar & 3D keycap enter button
///  - Burn container with progress bar & 3D keycap enter button
/// ═══════════════════════════════════════════════
class BuildCardBody extends StatefulWidget {
  const BuildCardBody({super.key});

  @override
  State<BuildCardBody> createState() => _BuildCardBodyState();
}

class _BuildCardBodyState extends State<BuildCardBody> {
  String _selectedRange = '7D';
  int _rangeOffset = 0; // 0 = current, 1 = previous, etc.

  List<double> get _chartValues {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return const [120, 280, 240, 480, 420, 650, 580];
      if (_rangeOffset == 1) return const [180, 220, 310, 290, 400, 510, 460];
      return const [100, 190, 250, 320, 380, 440, 490];
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return const [1200, 1650, 1980, 2450];
      return const [980, 1400, 1600, 2100];
    } else if (_selectedRange == '1Y') {
      return const [3200, 4500, 5800, 5100, 6900, 8200];
    } else {
      // 5Y
      return const [12000, 24000, 38000, 55000, 72000];
    }
  }

  List<String> get _chartLabels {
    if (_selectedRange == '7D') {
      return const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    } else if (_selectedRange == '1M') {
      return const ['WK 1', 'WK 2', 'WK 3', 'WK 4'];
    } else if (_selectedRange == '1Y') {
      return const ['FEB', 'APR', 'JUN', 'AUG', 'OCT', 'DEC'];
    } else {
      // 5Y
      return const ["'22", "'23", "'24", "'25", "'26"];
    }
  }

  String get _rangeShiftLabel {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return 'THIS WK';
      if (_rangeOffset == 1) return 'LAST WK';
      return '-${_rangeOffset}W';
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return 'THIS MO';
      if (_rangeOffset == 1) return 'LAST MO';
      return '-${_rangeOffset}M';
    } else if (_selectedRange == '1Y') {
      if (_rangeOffset == 0) return '2026';
      return '${2026 - _rangeOffset}';
    } else {
      return '2022-26';
    }
  }

  String get _totalXpLabel {
    final double sum = _chartValues.reduce((a, b) => a + b);
    return '+${sum.toInt()} XP';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ── 1. Top Section: Activity Chart Box ──
          Expanded(
            flex: 52,
            child: NeumorphicElevatedBox(
              title: 'CHART',
              headerLeading: RangeDropdownButton(
                selectedRange: _selectedRange,
                onRangeChanged: (val) {
                  setState(() {
                    _selectedRange = val;
                    _rangeOffset = 0;
                  });
                },
              ),
              headerTrailing: RangeShiftControls(
                rangeLabel: _rangeShiftLabel,
                canGoNext: _rangeOffset > 0,
                onPrevious: () => setState(() => _rangeOffset++),
                onNext: () => setState(() => _rangeOffset = math.max(0, _rangeOffset - 1)),
              ),
              child: NeumorphicCarvedCavity(
                child: Stack(
                  children: [
                    // Line chart canvas
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LineChartPainter(
                          values: _chartValues,
                          labels: _chartLabels,
                        ),
                      ),
                    ),
                    // Total XP pill badge in top-right
                    Positioned(
                      top: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _totalXpLabel,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            color: Color(0xFF3B2A16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 2. Middle Section: Dailies Container ──
          Expanded(
            flex: 24,
            child: NeumorphicElevatedBox(
              title: 'DAILIES',
              headerTrailing: KeycapEnterButton(
                onTap: () {
                  // No-op as requested
                },
              ),
              child: const NeumorphicCarvedCavity(
                child: BuildHorizontalProgressBar(
                  progress: 0.50,
                  percentLabel: '50%',
                  xpLabel: '+500 / 1000 XP',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 3. Bottom Section: Burn Container ──
          Expanded(
            flex: 24,
            child: NeumorphicElevatedBox(
              title: 'BURN',
              headerTrailing: KeycapEnterButton(
                onTap: () {
                  // No-op as requested
                },
              ),
              child: const NeumorphicCarvedCavity(
                child: BuildHorizontalProgressBar(
                  progress: 0.0,
                  percentLabel: '0%',
                  xpLabel: '+0 / 1000 XP',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Satisfying 3D Keycap Action Push Button
/// - Beige / warm ivory face with extruded warm taupe-brown bottom lip
/// - Matches the styling of the Enter button in the Build screen
/// - Physical tactile compression on tap
/// - Bold uppercase label and dark brown icon
class Action3DKeycapButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final double fontSize;
  final double iconSize;
  final double radius;
  final Color? borderColor;

  const Action3DKeycapButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.height = 34.0,
    this.width,
    this.fontSize = 11.5,
    this.iconSize = 15.0,
    this.radius = 11.0,
    this.borderColor,
  });

  @override
  State<Action3DKeycapButton> createState() => _Action3DKeycapButtonState();
}

class _Action3DKeycapButtonState extends State<Action3DKeycapButton> {
  bool _isPressed = false;

  static const double _depth = 4.0; // bottom lip extrusion height

  // Beige color palette matching the Enter button in Build screen
  static const Color _faceColor = Color(0xFFFBF7EE); // Warm ivory / beige face
  static const Color _baseLipColor = Color(0xFF8C7150); // Warm extruded taupe-brown lip
  static const Color _textColor = Color(0xFF3B2A16); // Canonical matte dark brown

  @override
  Widget build(BuildContext context) {
    final double pressOffset = _isPressed ? (_depth - 1.0) : 0.0;
    final double r = widget.radius;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Ambient drop shadow under button
            Positioned(
              left: 2,
              right: 2,
              bottom: 0,
              height: widget.height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C1A0A).withValues(alpha: _isPressed ? 0.12 : 0.22),
                      offset: Offset(0, _isPressed ? 1.5 : 3.0),
                      blurRadius: _isPressed ? 2 : 4,
                    ),
                  ],
                ),
              ),
            ),
            // 2. Extruded taupe-brown bottom lip / base
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: widget.height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: _baseLipColor,
                  borderRadius: BorderRadius.circular(r),
                ),
              ),
            ),
            // 3. Tactile 3D top face with dark brown icon and label
            Positioned(
              left: 0,
              right: 0,
              top: pressOffset,
              height: widget.height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: _faceColor,
                  borderRadius: BorderRadius.circular(r),
                  border: Border.all(
                    color: widget.borderColor ?? const Color(0xFF5E4527).withValues(alpha: 0.25),
                    width: widget.borderColor != null ? 1.5 : 0.8,
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color: _textColor,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        widget.label.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular 3D Keycap Push Button
/// - Tactile round button with extruded taupe lip and beige face
/// - Matches the circular Add Friend button in the Friends header
class Circular3DKeycapButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const Circular3DKeycapButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 26.0,
  });

  @override
  State<Circular3DKeycapButton> createState() => _Circular3DKeycapButtonState();
}

class _Circular3DKeycapButtonState extends State<Circular3DKeycapButton> {
  bool _isPressed = false;

  static const double _depth = 3.0; // bottom lip extrusion height
  static const Color _faceColor = Color(0xFFFBF7EE); // Warm ivory / beige face
  static const Color _baseLipColor = Color(0xFF8C7150); // Warm extruded taupe-brown lip
  static const Color _iconColor = Color(0xFF3B2A16); // Canonical matte dark brown

  @override
  Widget build(BuildContext context) {
    final double pressOffset = _isPressed ? (_depth - 1.0) : 0.0;
    final double faceSize = widget.size - _depth;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Ambient drop shadow
            Positioned(
              left: 1,
              right: 1,
              bottom: 0,
              height: faceSize,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C1A0A).withValues(alpha: _isPressed ? 0.12 : 0.22),
                      offset: Offset(0, _isPressed ? 1.0 : 2.0),
                      blurRadius: _isPressed ? 1.5 : 3.0,
                    ),
                  ],
                ),
              ),
            ),
            // Extruded taupe bottom base
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: faceSize,
              child: Container(
                decoration: const BoxDecoration(
                  color: _baseLipColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Tactile 3D top face
            Positioned(
              left: 0,
              right: 0,
              top: pressOffset,
              height: faceSize,
              child: Container(
                decoration: BoxDecoration(
                  color: _faceColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF5E4527).withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  size: faceSize * 0.65,
                  color: _iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════
///  Move Card Neumorphic Body
///  - Movement Activity Line Chart with range dropdown & shifter
///  - MatchMake container with [Book Slot] & [Play Now] 3D keycap buttons
///  - Solo container with [Start Tracking] 3D keycap button
/// ═══════════════════════════════════════════════
class MoveCardBody extends StatefulWidget {
  const MoveCardBody({super.key});

  @override
  State<MoveCardBody> createState() => _MoveCardBodyState();
}

class _MoveCardBodyState extends State<MoveCardBody> {
  String _selectedRange = '7D';
  int _rangeOffset = 0; // 0 = current, 1 = previous, etc.

  List<double> get _chartValues {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return const [4.2, 6.8, 5.1, 8.4, 7.2, 11.5, 9.6];
      if (_rangeOffset == 1) return const [5.0, 6.1, 7.8, 6.5, 8.9, 10.2, 8.4];
      return const [3.5, 5.2, 6.4, 7.1, 8.0, 9.5, 7.8];
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return const [28.4, 34.2, 41.5, 52.8];
      return const [22.1, 31.0, 36.5, 44.0];
    } else if (_selectedRange == '1Y') {
      return const [120, 155, 180, 165, 210, 245];
    } else {
      // 5Y
      return const [480, 720, 950, 1280, 1640];
    }
  }

  List<String> get _chartLabels {
    if (_selectedRange == '7D') {
      return const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    } else if (_selectedRange == '1M') {
      return const ['WK 1', 'WK 2', 'WK 3', 'WK 4'];
    } else if (_selectedRange == '1Y') {
      return const ['FEB', 'APR', 'JUN', 'AUG', 'OCT', 'DEC'];
    } else {
      // 5Y
      return const ["'22", "'23", "'24", "'25", "'26"];
    }
  }

  String get _rangeShiftLabel {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return 'THIS WK';
      if (_rangeOffset == 1) return 'LAST WK';
      return '-${_rangeOffset}W';
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return 'THIS MO';
      if (_rangeOffset == 1) return 'LAST MO';
      return '-${_rangeOffset}M';
    } else if (_selectedRange == '1Y') {
      if (_rangeOffset == 0) return '2026';
      return '${2026 - _rangeOffset}';
    } else {
      return '2022-26';
    }
  }

  String get _totalMovementLabel {
    final double sum = _chartValues.reduce((a, b) => a + b);
    return '${sum.toStringAsFixed(1)} KM';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ── 1. Top Section: Movement Activity Chart Box ──
          Expanded(
            flex: 46,
            child: NeumorphicElevatedBox(
              title: 'CHART',
              headerLeading: RangeDropdownButton(
                selectedRange: _selectedRange,
                onRangeChanged: (val) {
                  setState(() {
                    _selectedRange = val;
                    _rangeOffset = 0;
                  });
                },
              ),
              headerTrailing: RangeShiftControls(
                rangeLabel: _rangeShiftLabel,
                canGoNext: _rangeOffset > 0,
                onPrevious: () => setState(() => _rangeOffset++),
                onNext: () => setState(() => _rangeOffset = math.max(0, _rangeOffset - 1)),
              ),
              child: NeumorphicCarvedCavity(
                child: Stack(
                  children: [
                    // Line chart canvas
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LineChartPainter(
                          values: _chartValues,
                          labels: _chartLabels,
                        ),
                      ),
                    ),
                    // Total Movement badge in top-right
                    Positioned(
                      top: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _totalMovementLabel,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            color: Color(0xFF3B2A16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 2. Middle Section: MatchMake Container with 2 Push Buttons ──
          Expanded(
            flex: 32,
            child: NeumorphicElevatedBox(
              title: 'MATCHMAKE',
              child: NeumorphicCarvedCavity(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Action3DKeycapButton(
                                label: 'Book Slot',
                                icon: Icons.calendar_month_rounded,
                                height: 34,
                                onTap: () {
                                  // Interactive placeholder
                                },
                              ),
                              const SizedBox(height: 8),
                              Action3DKeycapButton(
                                label: 'Play Now',
                                icon: Icons.bolt_rounded,
                                height: 34,
                                onTap: () {
                                  // Interactive placeholder
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 3. Bottom Section: Solo Container with 1 Push Button ──
          Expanded(
            flex: 22,
            child: NeumorphicElevatedBox(
              title: 'SOLO',
              child: NeumorphicCarvedCavity(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Action3DKeycapButton(
                            label: 'Start Tracking',
                            icon: Icons.play_arrow_rounded,
                            height: 38,
                            onTap: () {
                              // Interactive placeholder
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Connect Card Neumorphic Body
//  - Friends Leaderboard: ordered by 7D XP with circular Add Friend button in header
//    (scrolling strictly isolated inside its carved cavity)
//  - Interactions: people recently met ordered last met to first met with Request buttons
//    (scrolling strictly isolated inside its carved cavity)
//  - Challenge: elevated standalone container with no carved cavity hosting 3D push button
// ═══════════════════════════════════════════════
class ConnectCardBody extends StatefulWidget {
  const ConnectCardBody({super.key});

  @override
  State<ConnectCardBody> createState() => _ConnectCardBodyState();
}

class _ConnectCardBodyState extends State<ConnectCardBody> {
  final Set<int> _sentRequests = {};

  static const List<_FriendLeaderboardItem> _friends = [
    _FriendLeaderboardItem(rank: 1, name: 'Marcus Vance', xp: 5420, avatarText: 'MV'),
    _FriendLeaderboardItem(rank: 2, name: 'Elena Rostova', xp: 4890, avatarText: 'ER'),
    _FriendLeaderboardItem(rank: 3, name: 'Kenji Sato', xp: 4350, avatarText: 'KS'),
    _FriendLeaderboardItem(rank: 4, name: 'You (Alex)', xp: 3920, isUser: true, avatarText: 'YOU'),
    _FriendLeaderboardItem(rank: 5, name: 'Sarah Connor', xp: 3410, avatarText: 'SC'),
    _FriendLeaderboardItem(rank: 6, name: 'Liam Davies', xp: 2980, avatarText: 'LD'),
    _FriendLeaderboardItem(rank: 7, name: 'Chloe Bennett', xp: 2450, avatarText: 'CB'),
    _FriendLeaderboardItem(rank: 8, name: 'David Miller', xp: 1820, avatarText: 'DM'),
  ];

  static const List<_InteractionHistoryItem> _interactions = [
    _InteractionHistoryItem(id: 1, name: 'Rowan Walker', timeAgo: '1h ago', activity: '5KM Run', avatarText: 'RW'),
    _InteractionHistoryItem(id: 2, name: 'Tyler Brooks', timeAgo: '3h ago', activity: 'HIIT Spar', avatarText: 'TB'),
    _InteractionHistoryItem(id: 3, name: 'Maya Patel', timeAgo: 'Yesterday', activity: 'Padel Match', avatarText: 'MP'),
    _InteractionHistoryItem(id: 4, name: 'Kai Takahashi', timeAgo: '2d ago', activity: '10K Cycling', avatarText: 'KT'),
    _InteractionHistoryItem(id: 5, name: 'Lucas Gray', timeAgo: '3d ago', activity: 'Sprint Drills', avatarText: 'LG'),
    _InteractionHistoryItem(id: 6, name: 'Jordan Reed', timeAgo: '5d ago', activity: 'Matchmake', avatarText: 'JR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ── 1. Top Section: Friends Leaderboard Container ──
          Expanded(
            flex: 48,
            child: NeumorphicElevatedBox(
              title: 'FRIENDS',
              headerTrailing: Circular3DKeycapButton(
                icon: Icons.person_add_alt_1_rounded,
                size: 24,
                onTap: () {
                  // Interactive placeholder for Add Friend
                },
              ),
              child: NeumorphicCarvedCavity(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cavity Sub-header: Name & Points
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RANK & NAME',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                            ),
                          ),
                          Text(
                            '7D XP',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                    ),
                    // Strictly inner-scrollable Friends Leaderboard
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Column(
                          children: _friends.map((friend) {
                            return _buildFriendRow(friend);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 2. Middle Section: Interactions Container ──
          Expanded(
            flex: 38,
            child: NeumorphicElevatedBox(
              title: 'INTERACTIONS',
              child: NeumorphicCarvedCavity(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cavity Sub-header: Player & Action
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PLAYER',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                            ),
                          ),
                          Text(
                            'SEND REQUEST',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                    ),
                    // Strictly inner-scrollable Interactions List
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Column(
                          children: _interactions.map((interaction) {
                            return _buildInteractionRow(interaction);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 3. Bottom Section: Challenge Button (Elevated Standalone, NO Carved Cavity) ──
          Expanded(
            flex: 14,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEBDDBF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF5EDDC).withValues(alpha: 0.60),
                    offset: const Offset(-1.5, -1.5),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0xFF6B5535).withValues(alpha: 0.22),
                    offset: const Offset(3.5, 3.5),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Action3DKeycapButton(
                        label: 'CHALLENGE',
                        icon: Icons.emoji_events_rounded,
                        height: 38,
                        fontSize: 12.0,
                        iconSize: 18.0,
                        onTap: () {
                          // Interactive placeholder for Challenge
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRow(_FriendLeaderboardItem friend) {
    Color rankBadgeColor;
    const Color rankTextColor = Color(0xFF3B2A16);
    if (friend.rank == 1) {
      rankBadgeColor = const Color(0xFFD4A017); // Gold
    } else if (friend.rank == 2) {
      rankBadgeColor = const Color(0xFFC0C0C0); // Silver
    } else if (friend.rank == 3) {
      rankBadgeColor = const Color(0xFFCD7F32); // Bronze
    } else {
      rankBadgeColor = const Color(0xFFDFCEB1).withValues(alpha: 0.40);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: friend.isUser
            ? const Color(0xFFFBF7EE).withValues(alpha: 0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: friend.isUser
            ? Border.all(
                color: const Color(0xFF3B2A16).withValues(alpha: 0.25),
                width: 0.8,
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 22,
            height: 20,
            decoration: BoxDecoration(
              color: rankBadgeColor,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              '#${friend.rank}',
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: rankTextColor,
              ),
            ),
          ),
          const SizedBox(width: 7),
          // Avatar circle
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: friend.isUser ? const Color(0xFF3B2A16) : const Color(0xFFDFCEB1),
            ),
            alignment: Alignment.center,
            child: Text(
              friend.avatarText,
              style: TextStyle(
                fontSize: friend.avatarText.length > 2 ? 6.5 : 8.5,
                fontWeight: FontWeight.w900,
                color: friend.isUser ? const Color(0xFFFBF7EE) : const Color(0xFF3B2A16),
              ),
            ),
          ),
          const SizedBox(width: 7),
          // Name
          Expanded(
            child: Text(
              friend.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: friend.isUser ? FontWeight.w900 : FontWeight.w700,
                color: const Color(0xFF3B2A16),
              ),
            ),
          ),
          // Points
          Text(
            '${friend.xp} XP',
            style: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
              color: Color(0xFF3B2A16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionRow(_InteractionHistoryItem interaction) {
    final bool isSent = _sentRequests.contains(interaction.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFDFCEB1),
            ),
            alignment: Alignment.center,
            child: Text(
              interaction.avatarText,
              style: const TextStyle(
                fontSize: 9.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3B2A16),
              ),
            ),
          ),
          const SizedBox(width: 7),
          // Player details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  interaction.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B2A16),
                  ),
                ),
                Text(
                  '${interaction.timeAgo} • ${interaction.activity}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Action button
          Action3DKeycapButton(
            label: isSent ? 'SENT' : 'REQUEST',
            icon: isSent ? Icons.check_rounded : Icons.person_add_alt_1_rounded,
            height: 26,
            width: 76,
            fontSize: 8.5,
            iconSize: 11.0,
            onTap: isSent
                ? null
                : () {
                    setState(() {
                      _sentRequests.add(interaction.id);
                    });
                  },
          ),
        ],
      ),
    );
  }
}

class _FriendLeaderboardItem {
  final int rank;
  final String name;
  final int xp;
  final bool isUser;
  final String avatarText;

  const _FriendLeaderboardItem({
    required this.rank,
    required this.name,
    required this.xp,
    this.isUser = false,
    required this.avatarText,
  });
}

class _InteractionHistoryItem {
  final int id;
  final String name;
  final String timeAgo;
  final String activity;
  final String avatarText;

  const _InteractionHistoryItem({
    required this.id,
    required this.name,
    required this.timeAgo,
    required this.activity,
    required this.avatarText,
  });
}

// ═══════════════════════════════════════════════
//  Kaizen Card Component
// ═══════════════════════════════════════════════
class KaizenCard extends StatelessWidget {
  final TabCardInfo info;
  final CardGeometry geometry;
  final double progress; // 0.0 = docked in button slot, 1.0 = fully expanded main card
  final bool ignoring;

  const KaizenCard({
    super.key,
    required this.info,
    required this.geometry,
    required this.progress,
    this.ignoring = false,
  });

  @override
  Widget build(BuildContext context) {
    // Reveal content when the card has expanded to a comfortable width (>65%)
    final double contentOpacity = progress > 0.65
        ? ((progress - 0.65) / 0.35).clamp(0.0, 1.0)
        : 0.0;

    return Positioned(
      left:   geometry.left,
      top:    geometry.top,
      width:  geometry.width,
      height: geometry.height,
      child: IgnorePointer(
        ignoring: ignoring,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD4B28A),
            borderRadius: BorderRadius.circular(geometry.radius),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2A3414).withValues(
                  alpha: 0.25 + (0.12 * progress),
                ),
                offset: Offset(0, 4.0 + 6.0 * progress),
                blurRadius: 10.0 + 14.0 * progress,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(geometry.radius),
            child: contentOpacity > 0.0
                ? Opacity(
                    opacity: contentOpacity,
                    child: ClipRect(
                      child: SizedBox(
                        width: geometry.width,
                        height: geometry.height,
                        child: info.title == 'HOME'
                            ? const HomeCardBody()
                            : info.title == 'BUILD'
                                ? const BuildCardBody()
                                : info.title == 'MOVE'
                                    ? const MoveCardBody()
                                    : const ConnectCardBody(),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

enum MenuMode {
  none,
  profile,
  credits,
}

// ═══════════════════════════════════════════════
//  App Shell — Single-page Card Stage
// ═══════════════════════════════════════════════
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  static const Color _bg = Color(0xFF6B7A47); // olive green

  int _activeTabIndex = 0; // Starts at HOME (0)
  int? _previousTabIndex;  // Outgoing tab
  final List<int> _tabHistory = [0];
  late AnimationController _animController;
  late Animation<double> _curvedAnim;

  // Fly-out animation controller for the 4 menu buttons
  late AnimationController _flyAnimController;
  late Animation<double> _flyCurvedAnim;
  MenuMode _activeMenuMode = MenuMode.none;
  MenuMode _displayedMenuMode = MenuMode.profile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyImmersiveMode();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );

    _flyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _flyCurvedAnim = CurvedAnimation(
      parent: _flyAnimController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animController.dispose();
    _flyAnimController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyImmersiveMode();
    }
  }

  void _applyImmersiveMode() {
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _onSelectTab(int newIndex) {
    if (newIndex == _activeTabIndex) return;
    if (_animController.isAnimating) {
      _animController.stop();
    }
    setState(() {
      _tabHistory.add(newIndex);
      _previousTabIndex = _activeTabIndex;
      _activeTabIndex = newIndex;
    });
    _animController.forward(from: 0.0);
  }

  void _handleBackPress() {
    if (_activeMenuMode != MenuMode.none) {
      setState(() {
        _activeMenuMode = MenuMode.none;
      });
      _flyAnimController.reverse();
    } else if (_tabHistory.length > 1) {
      if (_animController.isAnimating) {
        _animController.stop();
      }
      setState(() {
        _tabHistory.removeLast();
        final int prev = _tabHistory.last;
        _previousTabIndex = _activeTabIndex;
        _activeTabIndex = prev;
      });
      _animController.forward(from: 0.0);
    }
  }

  void _onToggleProfile() {
    setState(() {
      if (_activeMenuMode == MenuMode.profile) {
        _activeMenuMode = MenuMode.none;
        _flyAnimController.reverse();
      } else {
        _activeMenuMode = MenuMode.profile;
        _displayedMenuMode = MenuMode.profile;
        if (!_flyAnimController.isCompleted && !_flyAnimController.isAnimating) {
          _flyAnimController.forward();
        } else if (_flyAnimController.status == AnimationStatus.reverse || _flyAnimController.value < 1.0) {
          _flyAnimController.forward();
        }
      }
    });
  }

  void _onToggleCredits() {
    setState(() {
      if (_activeMenuMode == MenuMode.credits) {
        _activeMenuMode = MenuMode.none;
        _flyAnimController.reverse();
      } else {
        _activeMenuMode = MenuMode.credits;
        _displayedMenuMode = MenuMode.credits;
        if (!_flyAnimController.isCompleted && !_flyAnimController.isAnimating) {
          _flyAnimController.forward();
        } else if (_flyAnimController.status == AnimationStatus.reverse || _flyAnimController.value < 1.0) {
          _flyAnimController.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenW = constraints.maxWidth;
        final double screenH = constraints.maxHeight;

        final CardGeometry mainGeo = CardGeometry.mainCard(screenW, screenH);

        return AnimatedBuilder(
          animation: Listenable.merge([_curvedAnim, _flyCurvedAnim]),
          builder: (context, child) {
            final double t = _curvedAnim.value;
            final bool isAnimating =
                _animController.isAnimating || (_previousTabIndex != null && t < 1.0);

            // Fly-out progression: when menu card glides up, slide main card down off screen
            final double flyT = _flyCurvedAnim.value;
            final double mainDownT = ((flyT - 0.20) / 0.80).clamp(0.0, 1.0);
            final double mainDownCurved = Curves.easeInOutCubic.transform(mainDownT);
            final double mainSlideDownDist = (screenH - mainGeo.top + 80.0) * mainDownCurved;

            final CardGeometry activeMainGeo = CardGeometry(
              left: mainGeo.left,
              top: mainGeo.top + mainSlideDownDist,
              width: mainGeo.width,
              height: mainGeo.height,
              radius: mainGeo.radius,
            );

            CardGeometry adjustedSlot(int index) {
              final CardGeometry base =
                  CardGeometry.buttonSlot(index, screenW, screenH);
              final double slotDownDist = (screenH - base.top + 80.0) * mainDownCurved;
              return CardGeometry(
                left: base.left,
                top: base.top + slotDownDist,
                width: base.width,
                height: base.height,
                radius: base.radius,
              );
            }

            final List<Widget> cardWidgets = [];

            if (isAnimating && _previousTabIndex != null) {
              // 1. Outgoing card: moves from mainCard -> its button slot
              final CardGeometry outgoingSlot = adjustedSlot(_previousTabIndex!);
              final CardGeometry outgoingGeo =
                  CardGeometry.lerp(activeMainGeo, outgoingSlot, t);
              cardWidgets.add(
                KaizenCard(
                  key: ValueKey('card_$_previousTabIndex'),
                  info: kTabCards[_previousTabIndex!],
                  geometry: outgoingGeo,
                  progress: 1.0 - t,
                  ignoring: mainDownCurved > 0.05,
                ),
              );

              // 2. Incoming card: moves from its button slot -> mainCard
              final CardGeometry incomingSlot = adjustedSlot(_activeTabIndex);
              final CardGeometry incomingGeo =
                  CardGeometry.lerp(incomingSlot, activeMainGeo, t);
              cardWidgets.add(
                KaizenCard(
                  key: ValueKey('card_$_activeTabIndex'),
                  info: kTabCards[_activeTabIndex],
                  geometry: incomingGeo,
                  progress: t,
                  ignoring: mainDownCurved > 0.05,
                ),
              );
            } else {
              // Idle state:
              // Render docked sub cards under inactive button slots (slide down off-screen when menu opens)
              if (mainDownCurved < 1.0) {
                for (int i = 0; i < kTabCards.length; i++) {
                  if (i != _activeTabIndex) {
                    final CardGeometry slotGeo = adjustedSlot(i);
                    cardWidgets.add(
                      KaizenCard(
                        key: ValueKey('slot_$i'),
                        info: kTabCards[i],
                        geometry: slotGeo,
                        progress: 0.0,
                        ignoring: mainDownCurved > 0.05,
                      ),
                    );
                  }
                }
              }

              // Active card at main card position (slides smoothly down off screen when menu opens)
              cardWidgets.add(
                KaizenCard(
                  key: ValueKey('main_$_activeTabIndex'),
                  info: kTabCards[_activeTabIndex],
                  geometry: activeMainGeo,
                  progress: 1.0,
                  ignoring: mainDownCurved > 0.05,
                ),
              );
            }

            return PopScope(
              canPop: _activeMenuMode == MenuMode.none && _tabHistory.length <= 1,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleBackPress();
              },
              child: Scaffold(
                backgroundColor: _bg,
                body: Stack(
                  clipBehavior: Clip.hardEdge,
                  fit: StackFit.expand,
                  children: [
                    // ── Cards Layer (Outgoing, Incoming, Active, Docked) ──
                    ...cardWidgets,

                    // ── Menu Card (displayed on top of every card) ──
                    MenuCard(
                      selectedIndex: _activeTabIndex,
                      onTabSelected: _onSelectTab,
                      flyAnimation: _flyCurvedAnim,
                      screenH: screenH,
                      menuMode: _displayedMenuMode,
                    ),

                    // ── Bezel — always topmost frame ──
                    const Positioned.fill(child: KaizenBezel()),

                    // ── Credits pill on top-left bezel ──
                    CreditsPill(
                      onTap: _onToggleCredits,
                      isToggled: _activeMenuMode == MenuMode.credits,
                    ),

                    // ── Profile button on top-right bezel ──
                    ProfileButton(
                      onTap: _onToggleProfile,
                      isToggled: _activeMenuMode == MenuMode.profile,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════
//  Menu Card
//  - Width has 7dp spacing from 23dp inner bezel (left=30, right=30)
//  - Full height = 710 dp
// ═══════════════════════════════════════════════
//  Menu Raised Platform Button
//  - Sculpted elevated beige platform matching the wireframe
//  - Tactile spring compression on tap
//  - Bold dark brown centered typography
// ═══════════════════════════════════════════════
class MenuRaisedPlatformButton extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final double? height;

  const MenuRaisedPlatformButton({
    super.key,
    required this.title,
    this.onTap,
    this.height,
  });

  @override
  State<MenuRaisedPlatformButton> createState() => _MenuRaisedPlatformButtonState();
}

class _MenuRaisedPlatformButtonState extends State<MenuRaisedPlatformButton> {
  bool _isPressed = false;

  static const Color _beige = Color(0xFFEBDDBF); // matte beige matching bezel & cards
  static const Color _darkShadow = Color(0xFF6B5535);
  static const Color _textColor = Color(0xFF3B2A16);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 75),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: widget.height ?? double.infinity,
          decoration: BoxDecoration(
            color: _beige,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF5E4527).withValues(alpha: 0.25),
              width: 1.0,
            ),
            boxShadow: [
              // Top-left ambient light reflection
              BoxShadow(
                color: const Color(0xFFF5EDDC).withValues(alpha: _isPressed ? 0.25 : 0.65),
                offset: const Offset(-1.5, -1.5),
                blurRadius: 3.5,
                spreadRadius: 0,
              ),
              // Bottom-right warm matte depth shadow
              BoxShadow(
                color: _darkShadow.withValues(alpha: _isPressed ? 0.12 : 0.25),
                offset: Offset(_isPressed ? 1.5 : 3.5, _isPressed ? 1.5 : 3.5),
                blurRadius: _isPressed ? 2.5 : 6.5,
                spreadRadius: 0,
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Profile Card Extended Content
//  - 7 Sculpted Raised Platforms covering entire card
// ═══════════════════════════════════════════════
class ProfileCardContent extends StatelessWidget {
  const ProfileCardContent({super.key});

  static const List<String> _menuItems = [
    'Account',
    'About User',
    'Theme',
    'App lock',
    'Intrest Engine',
    'Eco System',
    'Audio and Haptics',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _menuItems.length; i++) ...[
          Expanded(
            child: MenuRaisedPlatformButton(
              title: _menuItems[i],
              onTap: () {
                // Interactive placeholder
              },
            ),
          ),
          if (i < _menuItems.length - 1)
            const SizedBox(height: 8),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════
//  Credits Card Extended Content
//  - 1. Earning Graph (Range dropdown + shifter + Line chart)
//  - 2. Credits History (Scrollable inside carved cavity)
//  - 3. Redeem (Supliments + Gym push buttons with white borders)
// ═══════════════════════════════════════════════
class CreditsCardContent extends StatefulWidget {
  const CreditsCardContent({super.key});

  @override
  State<CreditsCardContent> createState() => _CreditsCardContentState();
}

class _CreditsCardContentState extends State<CreditsCardContent> {
  String _selectedRange = '7D';
  int _rangeOffset = 0;
  String? _redeemToast;

  List<double> get _chartValues {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return const [80, 140, 110, 220, 190, 310, 260];
      if (_rangeOffset == 1) return const [95, 120, 180, 160, 240, 280, 210];
      return const [60, 100, 140, 190, 210, 250, 290];
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return const [950, 1420, 1860, 2300];
      return const [800, 1150, 1500, 1950];
    } else if (_selectedRange == '1Y') {
      return const [2800, 4100, 5200, 4700, 6300, 7500];
    } else {
      // 5Y
      return const [11000, 21000, 34000, 48000, 64000];
    }
  }

  List<String> get _chartLabels {
    if (_selectedRange == '7D') {
      return const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    } else if (_selectedRange == '1M') {
      return const ['WK 1', 'WK 2', 'WK 3', 'WK 4'];
    } else if (_selectedRange == '1Y') {
      return const ['FEB', 'APR', 'JUN', 'AUG', 'OCT', 'DEC'];
    } else {
      // 5Y
      return const ["'22", "'23", "'24", "'25", "'26"];
    }
  }

  String get _rangeShiftLabel {
    if (_selectedRange == '7D') {
      if (_rangeOffset == 0) return 'THIS WK';
      if (_rangeOffset == 1) return 'LAST WK';
      return '-${_rangeOffset}W';
    } else if (_selectedRange == '1M') {
      if (_rangeOffset == 0) return 'THIS MO';
      if (_rangeOffset == 1) return 'LAST MO';
      return '-${_rangeOffset}M';
    } else if (_selectedRange == '1Y') {
      if (_rangeOffset == 0) return '2026';
      return '${2026 - _rangeOffset}';
    } else {
      return '2022-26';
    }
  }

  String get _totalEarnedLabel {
    final double sum = _chartValues.reduce((a, b) => a + b);
    return '+${sum.toInt()} CR';
  }

  static const List<_CreditHistoryItem> _historyItems = [
    _CreditHistoryItem(
      title: 'Daily Streak 7/7',
      subtitle: 'Today • 10:30 AM',
      amount: 120,
      icon: Icons.bolt_rounded,
    ),
    _CreditHistoryItem(
      title: 'Gym Day Pass',
      subtitle: 'Yesterday • 4:15 PM',
      amount: -250,
      icon: Icons.fitness_center_rounded,
    ),
    _CreditHistoryItem(
      title: '10K Steps Goal',
      subtitle: 'Yesterday • 8:00 PM',
      amount: 80,
      icon: Icons.directions_walk_rounded,
    ),
    _CreditHistoryItem(
      title: 'Supliments Voucher',
      subtitle: '2 days ago • 1:20 PM',
      amount: -150,
      icon: Icons.medication_rounded,
    ),
    _CreditHistoryItem(
      title: 'Weekend Challenge',
      subtitle: '3 days ago • 6:45 PM',
      amount: 300,
      icon: Icons.emoji_events_rounded,
    ),
    _CreditHistoryItem(
      title: 'Hydration Recovery',
      subtitle: '4 days ago • 11:10 AM',
      amount: -75,
      icon: Icons.local_drink_rounded,
    ),
    _CreditHistoryItem(
      title: 'Leaderboard Top 3',
      subtitle: '5 days ago • 7:00 PM',
      amount: 200,
      icon: Icons.military_tech_rounded,
    ),
    _CreditHistoryItem(
      title: 'Monthly Locker Pass',
      subtitle: 'Last week • 2:00 PM',
      amount: -400,
      icon: Icons.lock_clock_rounded,
    ),
  ];

  void _showRedeemFeedback(String reward) {
    setState(() => _redeemToast = 'Redeemed $reward!');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _redeemToast = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. Top Section: Earning Graph ──
        Expanded(
          flex: 40,
          child: NeumorphicElevatedBox(
            title: 'EARNING GRAPH',
            headerLeading: RangeDropdownButton(
              selectedRange: _selectedRange,
              onRangeChanged: (val) {
                setState(() {
                  _selectedRange = val;
                  _rangeOffset = 0;
                });
              },
            ),
            headerTrailing: RangeShiftControls(
              rangeLabel: _rangeShiftLabel,
              canGoNext: _rangeOffset > 0,
              onPrevious: () => setState(() => _rangeOffset++),
              onNext: () => setState(() => _rangeOffset = math.max(0, _rangeOffset - 1)),
            ),
            child: NeumorphicCarvedCavity(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LineChartPainter(
                        values: _chartValues,
                        labels: _chartLabels,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _totalEarnedLabel,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          color: Color(0xFF3B2A16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── 2. Middle Section: Credits History (Scrollable inside cavity) ──
        Expanded(
          flex: 38,
          child: NeumorphicElevatedBox(
            title: 'CREDITS HISTORY',
            child: NeumorphicCarvedCavity(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ACTIVITY & DATE',
                          style: TextStyle(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                          ),
                        ),
                        Text(
                          'EARN / SPEND',
                          style: TextStyle(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.8,
                    color: const Color(0xFF3B2A16).withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Column(
                        children: _historyItems.map((item) => _buildHistoryRow(item)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── 3. Bottom Section: Redeem (2 Push Buttons) ──
        Expanded(
          flex: 22,
          child: NeumorphicElevatedBox(
            title: 'REDEEM',
            headerTrailing: _redeemToast != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B7A47),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _redeemToast!,
                      style: const TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFBF7EE),
                      ),
                    ),
                  )
                : null,
            child: NeumorphicCarvedCavity(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Action3DKeycapButton(
                      label: 'Supliments',
                      icon: Icons.medication_liquid_rounded,
                      height: 32,
                      fontSize: 12.0,
                      borderColor: Colors.white,
                      onTap: () => _showRedeemFeedback('Supliments'),
                    ),
                    const SizedBox(height: 5),
                    Action3DKeycapButton(
                      label: 'Gym',
                      icon: Icons.fitness_center_rounded,
                      height: 32,
                      fontSize: 12.0,
                      borderColor: Colors.white,
                      onTap: () => _showRedeemFeedback('Gym'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryRow(_CreditHistoryItem item) {
    final bool isEarn = item.amount > 0;
    final String amountStr = isEarn ? '+${item.amount} CR' : '${item.amount} CR';

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEBDDBF).withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6B5535).withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEarn
                  ? const Color(0xFF6B7A47).withValues(alpha: 0.20)
                  : const Color(0xFF8C7150).withValues(alpha: 0.20),
            ),
            child: Icon(
              item.icon,
              size: 13,
              color: isEarn ? const Color(0xFF3F4F24) : const Color(0xFF5E492B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B2A16),
                  ),
                ),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B2A16).withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
            decoration: BoxDecoration(
              color: isEarn
                  ? const Color(0xFF6B7A47).withValues(alpha: 0.20)
                  : const Color(0xFF8C7150).withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              amountStr,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
                color: isEarn ? const Color(0xFF2C3B12) : const Color(0xFF4A341E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditHistoryItem {
  final String title;
  final String subtitle;
  final int amount;
  final IconData icon;

  const _CreditHistoryItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
  });
}

// ═══════════════════════════════════════════════
//  Menu Card
//  - Width has 5dp spacing from 23dp inner bezel (left=28, right=28)
//  - Full height = 640 dp
//  - Moved to bottom: 100 dp visible above bottom inner bezel
//  - Extended form in center: Profile (7 platforms) or Credits (Graph + History + Redeem)
// ═══════════════════════════════════════════════
class MenuCard extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Animation<double>? flyAnimation;
  final double screenH;
  final MenuMode menuMode;

  const MenuCard({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.flyAnimation,
    this.screenH = 833.0,
    this.menuMode = MenuMode.profile,
  });

  static const double _left        = 28.0; // 5dp from 23dp side bezel (matches mainCard)
  static const double _right       = 28.0; // 5dp from 23dp side bezel (matches mainCard)
  static const double _visibleH    = 100.0; // top visible height when docked
  static const double _radius      = 22.0;

  Widget _buildFlyingButton(int index, Widget button) {
    if (flyAnimation == null) return button;

    return AnimatedBuilder(
      animation: flyAnimation!,
      builder: (context, child) {
        final double t = flyAnimation!.value;
        if (t == 0.0) return button;

        // Phase 1: Staggered fly out between t=0.0 and t=0.35
        final double start = index * 0.04;
        final double end = math.min(0.35, start + 0.22);
        final double progress = ((t - start) / (end - start)).clamp(0.0, 1.0);
        final double curved = Curves.easeInOutCubic.transform(progress);

        // Fly out downwards off the bottom bezel
        final double translateY = 120.0 * curved;
        final double opacity = (1.0 - (curved * 1.35)).clamp(0.0, 1.0);
        final double scale = 1.0 - (0.15 * curved);

        return IgnorePointer(
          ignoring: curved > 0.3,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: button,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Leftover space inside the bezel:
    // Top bezel is 80.0dp, bottom bezel is 23.0dp
    final double innerH = screenH - 80.0 - 23.0; // Leftover space between top & bottom bezel
    // Elegant margin from top bezel and bottom bezel (16dp)
    const double verticalMargin = 16.0;
    final double cardH = innerH - (verticalMargin * 2.0);

    final double bottomTucked = -(cardH - 23.0 - _visibleH);
    final double bottomCentered = 23.0 + verticalMargin;

    double cardProgress = 0.0;
    if (flyAnimation != null) {
      final double t = flyAnimation!.value;
      // Phase 2: card glides up to center between t=0.25 and t=1.00
      cardProgress = ((t - 0.25) / 0.75).clamp(0.0, 1.0);
      cardProgress = Curves.easeInOutCubic.transform(cardProgress);
    }

    final double currentBottom =
        bottomTucked + (bottomCentered - bottomTucked) * cardProgress;

    return Positioned(
      bottom: currentBottom,
      left:   _left,
      right:  _right,
      height: cardH,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD4B28A),
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A3414).withValues(alpha: 0.40),
              offset: const Offset(0, -6), // shadow cast upward onto cards above
              blurRadius: 22,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Extended Menu Card Content (Animated between Profile and Credits)
            if (cardProgress > 0.0)
              Positioned.fill(
                child: Opacity(
                  opacity: cardProgress,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      children: [
                        // Top horizontal pill grab handle
                        Container(
                          width: 48,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B5535).withValues(alpha: 0.40),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Dynamic Content: Profile (7 platforms) or Credits (Graph + History + Redeem)
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: menuMode == MenuMode.credits
                                ? const CreditsCardContent(key: ValueKey('credits_content'))
                                : const ProfileCardContent(key: ValueKey('profile_content')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // The 4 Action Buttons (Fly out in Phase 1)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Home (Home)
                    _buildFlyingButton(
                      0,
                      Olive3DKeycapButton(
                        icon: Icons.home_outlined,
                        label: 'HOME',
                        isSelected: selectedIndex == 0,
                        onTap: () => onTabSelected(0),
                      ),
                    ),
                    // 2. Fitness (Build)
                    _buildFlyingButton(
                      1,
                      Olive3DKeycapButton(
                        icon: Icons.bolt_rounded,
                        label: 'BUILD',
                        isSelected: selectedIndex == 1,
                        onTap: () => onTabSelected(1),
                      ),
                    ),
                    // 3. Sports (Move)
                    _buildFlyingButton(
                      2,
                      Olive3DKeycapButton(
                        icon: Icons.directions_run_rounded,
                        label: 'MOVE',
                        isSelected: selectedIndex == 2,
                        onTap: () => onTabSelected(2),
                      ),
                    ),
                    // 4. Community (Connect)
                    _buildFlyingButton(
                      3,
                      Olive3DKeycapButton(
                        icon: Icons.groups_outlined,
                        label: 'CONNECT',
                        isSelected: selectedIndex == 3,
                        onTap: () => onTabSelected(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Olive 3D Keycap Button
//  - Matches the reference image:
//    - Smooth rounded squircle shape (18dp radius)
//    - Straight-on / slight top-down view angle
//    - Olive green surface with darker extruded bottom lip
//    - Physically pushes down on tap with tactile spring release
//    - Pure white outline icon & bold uppercase label
// ═══════════════════════════════════════════════
class Olive3DKeycapButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const Olive3DKeycapButton({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<Olive3DKeycapButton> createState() => _Olive3DKeycapButtonState();
}

class _Olive3DKeycapButtonState extends State<Olive3DKeycapButton> {
  bool _isPressed = false;

  static const double _width  = 64.0;
  static const double _height = 64.0;
  static const double _depth  = 5.5; // bottom lip extrusion height
  static const double _radius = 16.0;

  // Olive green color palette
  static const Color _faceColor     = Color(0xFF4A6B32); // Lush olive green
  static const Color _selectedFace  = Color(0xFF537838); // Highlighted olive when selected
  static const Color _baseLipColor  = Color(0xFF2C421C); // Darker extruded bottom base lip

  @override
  Widget build(BuildContext context) {
    final double pressOffset = _isPressed ? (_depth - 1.5) : 0.0;
    final Color currentColor = widget.isSelected ? _selectedFace : _faceColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width:  _width,
        height: _height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Ambient drop shadow under the button
            Positioned(
              left: 2,
              right: 2,
              bottom: 0,
              height: _height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF222B0E).withValues(alpha: _isPressed ? 0.20 : 0.38),
                      offset: Offset(0, _isPressed ? 2 : 5),
                      blurRadius: _isPressed ? 3 : 6,
                    ),
                  ],
                ),
              ),
            ),

            // 2. Extruded dark olive bottom lip / base
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: _baseLipColor,
                  borderRadius: BorderRadius.circular(_radius),
                ),
              ),
            ),

            // 3. Main top face (pushes down on press)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 65),
              curve: Curves.easeOut,
              top: pressOffset,
              left: 0,
              right: 0,
              height: _height - _depth,
              child: Container(
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: BorderRadius.circular(_radius),
                  border: widget.isSelected
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.2,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      widget.icon,
                      size: 22,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 3),
                    // Label
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Credits Pill
//  - Pill-shaped badge on top-left of the bezel
//  - Holds credits value with token icon
//
//  Tweakable dimensions:
//    _height : height of the pill (dp)
//    _top    : distance from top of screen (dp)
//    _left   : distance from left of screen (dp)
// ═══════════════════════════════════════════════
class CreditsPill extends StatelessWidget {
  const CreditsPill({
    super.key,
    this.credits = '1,250',
    this.onTap,
    this.isToggled = false,
  });

  final String credits;
  final VoidCallback? onTap;
  final bool isToggled;

  static const double _height = 40.0; // matches profile button height
  static const double _top    = 20.0; // centered in 80dp top bezel
  static const double _left   = 32.0; // moved inward to match 23dp side bezel

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:  _top,
      left: _left,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isToggled ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            height: _height,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: isToggled
                  ? const Color(0xFFCBB694)
                  : const Color(0xFFDFCEB1), // warm matte tone matching bezel
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isToggled
                    ? const Color(0xFF4A371F)
                    : const Color(0xFF6B5535).withValues(alpha: 0.35),
                width: isToggled ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B5535).withValues(alpha: isToggled ? 0.08 : 0.15),
                  offset: Offset(0, isToggled ? 1 : 2),
                  blurRadius: isToggled ? 2 : 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Token / Coin icon
                Icon(
                  Icons.stars_rounded,
                  size: 21,
                  color: isToggled ? const Color(0xFF5E492B) : const Color(0xFF8C6D3B),
                ),
                const SizedBox(width: 7),
                // Credits value
                Text(
                  credits,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isToggled ? const Color(0xFF2C1A0A) : const Color(0xFF5E492B),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Profile Button
//  - Circular button with border & user icon
//  - Positioned on the top-right of the bezel
//
//  Tweakable dimensions:
//    _size  : diameter of button (dp)
//    _top   : distance from top of screen (dp)
//    _right : distance from right of screen (dp)
// ═══════════════════════════════════════════════
class ProfileButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isToggled;

  const ProfileButton({
    super.key,
    this.onTap,
    this.isToggled = false,
  });

  static const double _size  = 40.0;
  static const double _top   = 20.0; // centered in 80dp top bezel
  static const double _right = 32.0; // moved inward to match 23dp side bezel

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:   ProfileButton._top,
      right: ProfileButton._right,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: Container(
            width:  ProfileButton._size,
            height: ProfileButton._size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isToggled
                  ? const Color(0xFFCBB694)
                  : const Color(0xFFDFCEB1), // warm matte tone matching bezel
              border: Border.all(
                color: widget.isToggled
                    ? const Color(0xFF4A371F)
                    : const Color(0xFF6B5535).withValues(alpha: 0.35),
                width: widget.isToggled ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B5535).withValues(alpha: _isPressed ? 0.08 : 0.15),
                  offset: Offset(0, _isPressed ? 1 : 2),
                  blurRadius: _isPressed ? 2 : 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 25, // enlarged icon
                color: widget.isToggled
                    ? const Color(0xFF3B2A16)
                    : const Color(0xFF5E492B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  Bezel Overlay
// ═══════════════════════════════════════════════
class KaizenBezel extends StatelessWidget {
  const KaizenBezel({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _BezelPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BezelPainter extends CustomPainter {
  static const _bezel     = Color(0xFFEBDDBF);
  static const _edgeShade = Color(0xFFCFBF9F);
  static const _innerRim  = Color(0xFF6B5535);

  static const double _topH  = 80.0; // 10dp thicker (was 70)
  static const double _side  = 23.0; // 10dp thicker (was 13)
  static const double _innerR = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final innerRRect = RRect.fromLTRBAndCorners(
      _side,       _topH,
      w - _side,   h - _side,
      topLeft:     const Radius.circular(_innerR),
      topRight:    const Radius.circular(_innerR),
      bottomLeft:  const Radius.circular(_innerR),
      bottomRight: const Radius.circular(_innerR),
    );

    final bezelPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, w, h))
      ..addRRect(innerRRect);

    canvas.drawPath(bezelPath, Paint()
      ..color = _bezel
      ..style = PaintingStyle.fill);

    canvas.save();
    canvas.clipPath(bezelPath);

    _edgeGrad(canvas, Rect.fromLTWH(0, 0, w, _topH),
        Alignment.topCenter,    Alignment.bottomCenter);
    _edgeGrad(canvas, Rect.fromLTWH(0, 0, _side, h),
        Alignment.centerLeft,   Alignment.centerRight);
    _edgeGrad(canvas, Rect.fromLTWH(w - _side, 0, _side, h),
        Alignment.centerRight,  Alignment.centerLeft);
    _edgeGrad(canvas, Rect.fromLTWH(0, h - _side, w, _side),
        Alignment.bottomCenter, Alignment.topCenter);

    canvas.restore();

    canvas.drawRRect(innerRRect, Paint()
      ..color       = _innerRim.withValues(alpha: 0.30)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 2.0));
  }

  void _edgeGrad(Canvas canvas, Rect rect, Alignment begin, Alignment end) {
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(
        begin: begin, end: end,
        colors: [_edgeShade, _bezel.withValues(alpha: 0.0)],
        stops: const [0.0, 0.45],
      ).createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
