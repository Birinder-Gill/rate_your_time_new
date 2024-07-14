import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';

class DataCache {
  static const int CACHE_SIZE = 3;

  final Map<String, AverageDataModel> _cachedAverages = {};
  final Map<String, AverageAppUsageModel> _cachedAppData = {};

  bool _addToDataCache(String key, AverageDataModel value) {
    try {
      if (_cachedAverages.length == CACHE_SIZE) {
        _cachedAverages.remove(_cachedAverages.keys.first);
      }
      _cachedAverages[key] = value;
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _addToAppsCache(String key, AverageAppUsageModel value) {
    try {
      if (_cachedAppData.length == CACHE_SIZE) {
        _cachedAppData.remove(_cachedAppData.keys.first);
      }
      _cachedAppData[key] = value;
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addAverageCache(DateTime to, DateTime from, AverageDataModel data) {
    return _addToDataCache(_makeKey(to, from), data);
  }

  bool addAppDataCache(DateTime to, DateTime from, AverageAppUsageModel data) {
    return _addToAppsCache(_makeKey(to, from), data);
  }

  String _makeKey(DateTime to, DateTime from) {
    return "${from.day}${from.month}${from.year}-${to.day}${to.month}${to.year}";
  }

  AverageDataModel getAverageData(DateTime to, DateTime from) {
    final key = _makeKey(to, from);
    if (_cachedAverages.containsKey(key))
      return _cachedAverages[key]!;
    else
      return AverageDataModel();
  }

  AverageAppUsageModel getAppsData(DateTime to, DateTime from) {
    final key = _makeKey(to, from);
    if (_cachedAppData.containsKey(key))
      return _cachedAppData[key]!;
    else
      return AverageAppUsageModel();
  }

  void clear({bool clearAppData = false}) {
    _cachedAverages.clear();
    if(clearAppData)
      _cachedAppData.clear();
  }

}
