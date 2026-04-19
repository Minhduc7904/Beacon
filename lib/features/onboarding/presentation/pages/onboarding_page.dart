import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/providers/providers.dart';
import '../controllers/onboarding_state.dart';
import '../widgets/onboarding_action_section.dart';
import '../widgets/onboarding_content_section.dart';
import '../widgets/onboarding_progress_indicator.dart';
import '../widgets/onboarding_slide_content.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
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
      title: 'Một chạm báo bình an',
      description:
          'Check-in bằng ảnh hoặc tâm trạng (mood) cực nhanh, hoàn toàn không áp lực',
    ),
    _OnboardingSlideData(
      imagePath: AppImages.onboarding3,
      title: '"Lá chắn" tự động 24/7',
      description:
          'Tự động nhắc nhở và thông báo cho người thân khi bạn lỡ hẹn check-in',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final nextIndex = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeAndGoLogin() async {
    await ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
  }

  Future<void> _onLoginPressed() async {
    await _completeAndGoLogin();
    if (!mounted) {
      return;
    }
    context.pushNamed(AppRoutes.loginName);
  }

  Future<void> _onRegisterPressed() async {
    await _completeAndGoLogin();
    if (!mounted) {
      return;
    }
    context.pushNamed(AppRoutes.registerName);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final isLoading = onboardingState is OnboardingLoading;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Image(
                          image: AssetImage(AppImages.logoText),
                          width: 120,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height *
                            0.4, // Chiếm 45% chiều cao màn hình
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _slides.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return OnboardingSlideContent(
                              imagePath: _slides[index].imagePath,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),
                      OnboardingProgressIndicator(
                        currentIndex: _currentIndex,
                        total: _slides.length,
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Column(
                          children: [
                            OnboardingContentSection(
                              title: _slides[_currentIndex].title,
                              description: _slides[_currentIndex].description,
                            ),
                            const SizedBox(height: 32),
                            OnboardingActionSection(
                              isLoading: isLoading,
                              primaryLabel: 'Đăng nhập',
                              secondaryLabel: 'Đăng kí',
                              onPrimaryPressed: _onLoginPressed,
                              onSecondaryPressed: _onRegisterPressed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
