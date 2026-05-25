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
  static const String cameraScreenName = 'camera-screen';
  static const String profileName = 'profile';
  static const String editProfileName = 'edit-profile';
  static const String safetySettingsName = 'safety-settings';
  static const String postPreviewName = 'post-preview';
  static const String logoutName = 'logout';
  static const String widgetsName = 'widgets';
  static const String messageListName = 'message-list';
  static const String chatDetailName = 'chat-detail';
  static const String messageGroupInfoName = 'message-group-info';
  static const String messageGroupMembersName = 'message-group-members';
  static const String messageGroupNicknamesName = 'message-group-nicknames';
  static const String messageGroupAddMembersName = 'message-group-add-members';
  static const String addFriendsName = 'add-friends';

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerPassword = '/register/password';
  static const String registerNameStep = '/register/name';
  static const String registerUsername = '/register/username';
  static const String registerPhoneNumber = '/register/phone-number';
  static const String home = '/home';
  static const String cameraScreen = '/camera-screen';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String safetySettings = '/profile/safety-settings';
  static const String postPreview = '/post-preview';
  static const String logout = '/logout';
  static const String widgets = '/widgets';
  static const String messageList = '/messages';
  static const String chatDetail = '/messages/chat';
  static const String messageGroupInfo = '/messages/chat/info';
  static const String messageGroupMembers = '/messages/chat/members';
  static const String messageGroupNicknames = '/messages/chat/nicknames';
  static const String messageGroupAddMembers = '/messages/chat/members/add';
  static const String addFriends = '/friends/add';

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
    AppRouteItem(title: 'Camera Screen', path: cameraScreen),
    AppRouteItem(title: 'Profile', path: profile),
    AppRouteItem(title: 'Edit Profile', path: editProfile),
    AppRouteItem(title: 'Safety Settings', path: safetySettings),
    AppRouteItem(title: 'Post Preview', path: postPreview),
    AppRouteItem(title: 'Logout', path: logout),
    AppRouteItem(title: 'Widgets', path: widgets),
    AppRouteItem(title: 'Messages', path: messageList),
    AppRouteItem(title: 'Chat Detail', path: chatDetail),
    AppRouteItem(title: 'Message Group Info', path: messageGroupInfo),
    AppRouteItem(title: 'Message Group Members', path: messageGroupMembers),
    AppRouteItem(
      title: 'Message Group Nicknames',
      path: messageGroupNicknames,
    ),
    AppRouteItem(
      title: 'Message Group Add Members',
      path: messageGroupAddMembers,
    ),
    AppRouteItem(title: 'Add Friends', path: addFriends),
  ];
}

class AppRouteItem {
  final String title;
  final String path;

  const AppRouteItem({required this.title, required this.path});
}
