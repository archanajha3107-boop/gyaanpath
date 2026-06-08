import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/language_screen.dart';
import '../screens/onboarding/board_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/textbook/textbook_screen.dart';
import '../screens/solutions/subjects_screen.dart';
import '../screens/solutions/chapters_screen.dart';
import '../screens/solutions/solution_screen.dart';
import '../screens/papers/papers_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/progress/progress_screen.dart';

class AppRoutes {
  // Route names
  static const splash     = '/';
  static const language   = '/language';
  static const board      = '/board';
  static const home       = '/home';
  static const textbook   = '/textbook';
  static const subjects   = '/solutions/subjects';
  static const chapters   = '/solutions/chapters';
  static const solution   = '/solutions/detail';
  static const papers     = '/papers';
  static const quiz       = '/quiz';
  static const progress   = '/progress';

  static final router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final settings = Hive.box('settings');
      final onboardingDone = settings.get('onboarding_done', defaultValue: false);

      if (state.matchedLocation == splash) return null;
      if (!onboardingDone && state.matchedLocation != language && state.matchedLocation != board) {
        return language;
      }
      return null;
    },
    routes: [
      GoRoute(path: splash,   builder: (c, s) => const SplashScreen()),
      GoRoute(path: language, builder: (c, s) => const LanguageScreen()),
      GoRoute(path: board,    builder: (c, s) => const BoardScreen()),
      GoRoute(path: home,     builder: (c, s) => const HomeScreen()),
      GoRoute(
        path: textbook,
        builder: (c, s) => TextbookScreen(
          pdfPath: s.extra as String,
        ),
      ),
      GoRoute(path: subjects,  builder: (c, s) => const SubjectsScreen()),
      GoRoute(
        path: chapters,
        builder: (c, s) => ChaptersScreen(
          subjectId: s.extra as int,
        ),
      ),
      GoRoute(
        path: solution,
        builder: (c, s) => SolutionScreen(
          chapterId: s.extra as int,
        ),
      ),
      GoRoute(path: papers,   builder: (c, s) => const PapersScreen()),
      GoRoute(path: quiz,     builder: (c, s) => const QuizScreen()),
      GoRoute(path: progress, builder: (c, s) => const ProgressScreen()),
    ],
  );
}
