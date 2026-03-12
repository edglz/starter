import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';

/// Success overlay shown after an article has been published.
class SuccessOverlay extends StatefulWidget {
  const SuccessOverlay({Key? key}) : super(key: key);

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: AppDesign.successOverlaySize,
          height: AppDesign.successOverlaySize,
          decoration: BoxDecoration(
            color: AppDesign.surface,
            borderRadius: AppDesign.borderRadiusSheet,
            boxShadow: const [
              BoxShadow(
                color: AppDesign.shadowLight,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  color: AppDesign.primary, size: AppDesign.iconSuccess),
              SizedBox(height: 10),
              Text(
                'Published!',
                style: AppDesign.successOverlayStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
