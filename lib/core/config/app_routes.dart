class AppRoutes {
  AppRoutes._();

  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String registerPasswordName = 'register-password';
  static const String registerNameStepName = 'register-name';
  static const String registerUsernameName = 'register-username';
  static const String registerPhoneNumberName = 'register-phone-number';
  static const String homeName = 'home';
  static const String postPreviewName = 'post-preview';
  static const String logoutName = 'logout';
  static const String widgetsName = 'widgets';

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerPassword = '/register/password';
  static const String registerNameStep = '/register/name';
  static const String registerUsername = '/register/username';
  static const String registerPhoneNumber = '/register/phone-number';
  static const String home = '/home';
  static const String postPreview = '/post-preview';
  static const String logout = '/logout';
  static const String widgets = '/widgets';

  static const List<AppRouteItem> all = [
    AppRouteItem(title: 'Splash', path: splash),
    AppRouteItem(title: 'Onboarding', path: onboarding),
    AppRouteItem(title: 'Login', path: login),
    AppRouteItem(title: 'Register', path: register),
    AppRouteItem(title: 'Register Phone Number', path: registerPhoneNumber),
    AppRouteItem(title: 'Register Password', path: registerPassword),
    AppRouteItem(title: 'Register Name', path: registerNameStep),
    AppRouteItem(title: 'Register Username', path: registerUsername),
    AppRouteItem(title: 'Home', path: home),
    AppRouteItem(title: 'Post Preview', path: postPreview),
    AppRouteItem(title: 'Logout', path: logout),
    AppRouteItem(title: 'Widgets', path: widgets),
  ];
}

class AppRouteItem {
  final String title;
  final String path;

  const AppRouteItem({required this.title, required this.path});
}
