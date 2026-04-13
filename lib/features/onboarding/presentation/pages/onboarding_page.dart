import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/logo_image.dart';
import '../controllers/onboarding_state.dart';
import '../widgets/onboarding_action_section.dart';
import '../widgets/onboarding_progress_indicator.dart';
import '../widgets/onboarding_slide_content.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  static const _slides = [
    _OnboardingSlideData(
      imagePath: AppImages.onboarding1,
      title: 'Tự lập nhưng không cô độc',
      description:
          'Tự do sống chất và luôn giữ kết nối thầm lặng với người thân mỗi ngày',
    ),
    _OnboardingSlideData(
      imagePath: AppImages.onboarding2,
      title: 'Tự lập nhưng không cô độc',
      description:
          'Tự do sống chất và luôn giữ kết nối thầm lặng với người thân mỗi ngày',
    ),
    _OnboardingSlideData(
      imagePath: AppImages.onboarding3,
      title: 'Tự lập nhưng không cô độc',
      description:
          'Tự do sống chất và luôn giữ kết nối thầm lặng với người thân mỗi ngày',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeAndGoLogin() async {
    await ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
  }

  Future<void> _goToPage(int index) async {
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onPrimaryPressed() async {
    if (_currentIndex < _slides.length - 1) {
      await _goToPage(_currentIndex + 1);
      return;
    }

    await _completeAndGoLogin();
  }

  Future<void> _onSecondaryPressed() async {
    if (_currentIndex < _slides.length - 1) {
      await _completeAndGoLogin();
      return;
    }

    await _goToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnboardingState>(onboardingNotifierProvider, (_, state) {
      if (state is OnboardingCompleted) {
        context.go(AppRoutes.login);
      }
    });

    final onboardingState = ref.watch(onboardingNotifierProvider);
    final isLoading = onboardingState is OnboardingLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Center(child: AppLogoImage(width: 120, height: 40)),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return OnboardingSlideContent(
                      imagePath: slide.imagePath,
                      title: slide.title,
                      description: slide.description,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              OnboardingProgressIndicator(
                currentIndex: _currentIndex,
                total: _slides.length,
              ),
              const SizedBox(height: 38),
              OnboardingActionSection(
                isLoading: isLoading,
                primaryLabel: _currentIndex == _slides.length - 1
                    ? 'Bắt đầu ngay'
                    : 'Tiếp theo',
                secondaryLabel: _currentIndex == _slides.length - 1
                    ? 'Quay lại'
                    : 'Bỏ qua',
                onPrimaryPressed: _onPrimaryPressed,
                onSecondaryPressed: _onSecondaryPressed,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  final String imagePath;
  final String title;
  final String description;

  const _OnboardingSlideData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
