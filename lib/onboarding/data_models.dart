import 'package:rate_your_time_new/utils/constants.dart';

const models = <OnBoardingModel>[
  const OnBoardingModel(
      'Welcome to ${Constants.appName}',
      // TODO://
      'A flana flana trick to keep you focused and improve your productivity.\n\n'
          // '${Constants.appName} helps you to keep you focused on your long term goals.(Change this line)\n\n'
          'Examine how you spend your day by breaking it down and evaluating every hour.\n\n',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  //TODO:UNCOMMENT WHEN AND IF GOALS ADDED
  // const OnBoardingModel(
  //     'Set Plan for Day',
  //     'Use your morning to focus on yourself and set your goal for the day.\n\n'
  //         'What can you realistically accomplish that will further your goals and allow you to leave at the end of the day feeling like you’ve been productive and successful?',
  //     'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),
  //
  const OnBoardingModel(
      'Refocus every hour',
      '${Constants.appName} gives you a notification every hour asking for a rating.\n\n'
          'When it rings, rate your last hour based on how you think you spent it and deliberately recommit to how you are going to use the next hour.\n\n',
          // 'Your hourly ratings are saved and beautifully presented for you to monitor and improve.',
      // '\n\n Manage your day hour by hour.',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),


  const OnBoardingModel(
      'Review every day',
      'At the end of the day, review your ratings.\n\n'
          'Where did you focus? Where did you get distracted?\n\n'
          'Which hours were the most productive.\n\n'
          'What did you learn that will help you be more productive tomorrow?',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png')
];

class OnBoardingModel {
  final String title;
  final String desc;
  final String imagePath;

  const OnBoardingModel(this.title, this.desc, this.imagePath);
}
