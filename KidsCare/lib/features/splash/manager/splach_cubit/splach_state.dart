// تحديد حالات شاشة الـ Splash
abstract class SplashState {}

class SplashInitial extends SplashState {
  // حالة البداية عندما تبدأ شاشة الـ Splash
}

class SplashCompleted extends SplashState {
  // حالة عند اكتمال الـ Splash ويمكنك الانتقال إلى الشاشة التالية
}
