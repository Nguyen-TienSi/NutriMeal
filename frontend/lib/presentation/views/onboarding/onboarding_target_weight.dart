import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';

class OnboardingTargetWeight extends StatefulWidget {
  final UserCreateData userCreateData;
  const OnboardingTargetWeight({super.key, required this.userCreateData});

  @override
  State<OnboardingTargetWeight> createState() => _OnboardingTargetWeightState();
}

class _OnboardingTargetWeightState extends State<OnboardingTargetWeight>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _kgController;
  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;
  int _currentWeight = 60;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.userCreateData.targetWeight = 60;
    _kgController = TextEditingController(text: _currentWeight.toString());
    _kgController.addListener(_onWeightChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onWeightChanged() {
    final text = _kgController.text;
    final weight = int.tryParse(text);
    if (weight != null) {
      setState(() {
        _currentWeight = weight;
        widget.userCreateData.targetWeight = weight;
      });
    }
  }

  void _updateWeight(int change) {
    final newWeight = (_currentWeight + change).clamp(40, 150);
    if (newWeight != _currentWeight) {
      setState(() {
        _currentWeight = newWeight;
        _kgController.text = newWeight.toString();
        widget.userCreateData.targetWeight = newWeight;
      });
      _animateBounce();
    }
  }

  void _animateBounce() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _kgController.removeListener(_onWeightChanged);
    _kgController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What is your target weight?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "Select your desired weight in kilograms",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildWeightSelector(),
        ],
      ),
    );
  }

  Widget _buildWeightSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlButton(
            icon: Icons.remove,
            onPressed: () => _updateWeight(-1),
          ),
          const SizedBox(width: 24),
          ScaleTransition(
            scale: _bounceAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _currentWeight.toString(),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "kg",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _buildControlButton(
            icon: Icons.add,
            onPressed: () => _updateWeight(1),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              icon == Icons.add ? "+" : "-",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w300,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
