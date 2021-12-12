import 'package:rate_your_time_new/utils/constants.dart';

//TODO:UNCOMMENT WHEN AND IF GOALS ADDED
// const OnBoardingModel(
//     'Set Plan for Day',
//     'Use your morning to focus on yourself and set your goal for the day.\n\n'
//         'What can you realistically accomplish that will further your goals and allow you to leave at the end of the day feeling like you’ve been productive and successful?',
//     'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),
//

const models = <OnBoardingModel>[
  const OnBoardingModel(
      'Welcome to ${Constants.appName}',
      'A simple trick to keep you focused and improve your productivity.\n\n'
      'Examine how you spend your day by breaking it down and evaluating every hour.\n\n',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Refocus every hour',
      '${Constants.appName} gives you a notification every hour asking for a rating between 1 and 5.\n\n'
      'When it rings, honestly rate your last hour based on how you think you spent it, now recommit to how you are going to use the next hour.\n\n',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Review every day',
      'At the end of the day, review your ratings.\n\n'
      'Which hours were the most productive?\n\n'
      'What was the average rating for the day?\n\n'
      'What did you learn that will help you be more productive and have better ratings for tomorrow?\n\n'
      "We save these hourly ratings and provide daily, weekly and monthly averages.\n\n",
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),

  const OnBoardingModel(
      'Train your brain',
      'Use the hourly notification as a reminder to use the next hour more productively.\n\n'
      'Once you commit to improving your ratings, the brain automatically starts to train itself to stop wasting time and be more productive\n\n'
      'Reach your life goals hour by hour\n',
      'https://www.freeiconspng.com/uploads/calendar-image-png-3.png'),
];

class OnBoardingModel {
  final String title;
  final String desc;
  final String imagePath;

  const OnBoardingModel(this.title, this.desc, this.imagePath);
}
