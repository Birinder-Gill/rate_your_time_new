import 'package:rate_your_time_new/utils/constants.dart';

const models = <OnBoardingModel>[
  const OnBoardingModel(
      'Welcome to ${Constants.appName}',
      '${Constants.appName} helps you to keep you focused on your long term goals.(Change this line)\n\n'
      // by evaluating how you are spending your time.
          'How can you focus on a few important things when so many things require your attention?\n\n'
      'We can do it in three steps that take less than 10 minutes over an entire workday.',

      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Set Plan for Day',

      'Before turning on your computer, sit down with a blank piece of paper and decide what will make this day highly successful.'
      'What can you realistically accomplish that will further your goals and allow you to leave at the end of the day feeling like you’ve been productive and successful?'
      'Write those things down.',

      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Refocus every hour',

      '${Constants.appName} gives you a reminder notification every hour.\n\n'
      'When it rings, rate your last hour based on if you think you spent it productively.\n\n'
      'Now deliberately recommit to how you are going to use the next hour.\n\n Manage your day hour by hour.',

      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Review every day',

      'At the end of the day, review your day.\n\n'
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
