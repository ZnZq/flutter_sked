import 'dart:async';
import 'dart:collection';

import 'package:date_util/date_util.dart';
import 'package:flutter_sked/models/Lesson.dart';
import 'package:flutter_sked/models/LessonTime.dart';
import 'package:flutter_sked/models/LessonType.dart';
import 'package:flutter_sked/models/Name.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:html/dom.dart';
import 'package:meta/meta.dart';
import 'package:jiffy/jiffy.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:date_format/date_format.dart';

class ERozkladAPI {
  static var _dateUtility = new DateUtil();
  static Map<DateTime, List<Lesson>> cache = {};
  static String group, groupName;
  static bool login;

  static var filterForm = RegExp(r'<form.*id="filter-form".*\/form>');

  static init() {
    var box = Hive.box('cache');
    group = box.get('group', defaultValue: '');
    groupName = box.get('groupName', defaultValue: '');

    var hashMap = box.get('cache', defaultValue: <DateTime, List<Lesson>>{})
        as LinkedHashMap;

    cache = hashMap.map((k, v) =>
        MapEntry<DateTime, List<Lesson>>(k as DateTime, v.cast<Lesson>()));
  }

  static final StreamController<Map<DateTime, List<Lesson>>> _rozklad =
      StreamController.broadcast();
  static Stream<Map<DateTime, List<Lesson>>> get rozkladStream =>
      _rozklad.stream;

  static final StreamController<Map<String, Map<String, String>>> _groupData =
      StreamController.broadcast();
  static Stream<Map<String, Map<String, String>>> get groupDataStream =>
      _groupData.stream;

  static var _isUpdate = false;

  static getInitialData(DateTime time) {
    if (cache.isEmpty || !cache.containsKey(time)) return null;
    return cache;
  }

  static Future update([bool toast = true]) async {
    if (_isUpdate) return;
    _isUpdate = true;

    _rozklad.add(null);

    try {
      var r = await rozklad(group: group);

      if (r == null) {
        Fluttertoast.showToast(
          msg: 'Не удалось обновить расписание',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 2,
        );
        throw 'Не удалось обновить расписание';
      }
      cache.addAll(r);

      var now = DateTime.now();
      var week = now.weekday;
      var oldDate =
          DateTime(now.year, now.month, now.day).add(Duration(days: -week));

      cache.removeWhere((k, v) => k.isBefore(oldDate));

      var box = Hive.box('cache');
      box.put('cache', cache);

      if (toast) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: 'Расписание обновлено',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 1);
      }
    } catch (e) {}

    _rozklad.add(cache);
    _isUpdate = false;
  }

  static Future getfilterFormHtml(url) async {
    var response = await http.get(url);

    var doc = html.parse(response.body);
    var filter = doc.querySelector('#filter-form');

    return filter;
  }

  static Map<String, String> _parseSelect(Element filter, selectId) {
    var data = <String, String>{'': 'Не указано'};
    try {
      if (filter == null) return data;
      var select = filter.querySelector('#$selectId');
      for (var option in select.children) {
        if (option.text.trim().isNotEmpty)
          data[option.attributes['value']] = option.text;
      }
    } catch (e) {}
    return data;
  }

  static bool _isOptions = false;

  static Future getOptions({faculty = '', course = ''}) async {
    if (_isOptions) return;
    _isOptions = true;
    var data = {
      'faculty': {'': 'Не указано'},
      'course': {'': 'Не указано'},
      'group': {'': 'Не указано'},
    };
    _groupData.add(null);
    try {
      var formHtml = await getfilterFormHtml(
          'http://e-rozklad.dut.edu.ua/timeTable/group?TimeTableForm[faculty]=$faculty&TimeTableForm[course]=$course');

      data.addAll({
        'faculty': _parseSelect(formHtml, 'TimeTableForm_faculty'),
        'course': _parseSelect(formHtml, 'TimeTableForm_course'),
        'group': _parseSelect(formHtml, 'TimeTableForm_group'),
      });
    } catch (e) {
      print(e);
    }
    _isOptions = false;
    _groupData.add(data);
  }

  static faculties() async => _parseSelect(
      await getfilterFormHtml('http://e-rozklad.dut.edu.ua/timeTable/group'),
      'TimeTableForm_faculty');

  static cources(faculty) async => _parseSelect(
      await getfilterFormHtml(
          'http://e-rozklad.dut.edu.ua/timeTable/group?TimeTableForm[faculty]=$faculty'),
      'TimeTableForm_course');

  static groups(faculty, course) async => _parseSelect(
      await getfilterFormHtml(
          'http://e-rozklad.dut.edu.ua/timeTable/group?TimeTableForm[faculty]=$faculty&TimeTableForm[course]=$course'),
      'TimeTableForm_group');

  static rozklad(
      {@required group, DateTime timeStart, DateTime timeEnd}) async {
    try {
      timeStart = timeStart ?? DateTime.now();
      var week = timeStart.weekday;
      var now = DateTime.now();
      timeStart =
          DateTime(now.year, now.month, now.day).add(Duration(days: 1 - week));

      timeEnd = timeEnd ?? timeStart.add(Duration(days: 7 * 5 - 1));

      var start = formatDate(timeStart, [dd, '.', mm, '.', yyyy]);
      var end = formatDate(timeEnd, [dd, '.', mm, '.', yyyy]);

      var response = (await http.get(
              'http://e-rozklad.dut.edu.ua/timeTable/group?'
              'TimeTableForm[group]=$group&TimeTableForm[date1]=$start&TimeTableForm[date2]=$end'))
          .body;

      // var response = await File(r"E:\ZnZ\Dart\bin\index.html").readAsString();

      var lessonList = <DateTime, List<Lesson>>{};

      var document = html.parse(response);

      var table = document.getElementById('timeTableGroup');

      var trows = table.querySelectorAll('tr');

      var weekdayTimes = <int, List<LessonTime>>{};
      var lessonNumbers = <int, List<int>>{};
      var weekNumber = 1;
      for (var weekday in trows.map((e) => e.children[0])) {
        weekdayTimes[weekNumber] = [];
        lessonNumbers[weekNumber] = [];
        for (var times in weekday.children.skip(1)) {
          lessonNumbers[weekNumber].add(
              int.parse(times.querySelector('.lesson').text.split(' ')[0]));
          weekdayTimes[weekNumber].add(LessonTime(
            start: Jiffy(times.querySelector('.start').text, "HH:mm").dateTime,
            end: Jiffy(times.querySelector('.finish').text, "HH:mm").dateTime,
          ));
        }
        weekNumber++;
      }

      var weekStart = getWeek(timeStart.month, timeStart.day, timeStart.year);
      var weekEnd = getWeek(timeEnd.month, timeEnd.day, timeEnd.year);

      if (weekStart >= 52 && weekStart > weekEnd) weekEnd += 52;

      var dWeek = weekEnd - weekStart;

      for (int week = 0; week < dWeek; week++) {
        var weekDay = 1;
        for (var tdLessons in trows.map((e) => e.children[1 + week])) {
          if (tdLessons.classes.contains('closed')) continue;

          var lessonNumber = -1;

          DateTime date =
              Jiffy(tdLessons.children[0].text, "dd.MM.yyyy").dateTime;
          var lessons = <Lesson>[];
          bool hasFirstLesson = false;
          for (var lessonCell in tdLessons.children.skip(1)) {
            lessonNumber++;
            var dataContent = lessonCell.attributes['data-content'];
            if (dataContent.trim().isEmpty) {
              if (hasFirstLesson)
                lessons.add(Lesson.window(
                    number: lessonNumbers[weekDay][lessonNumber],
                    time: weekdayTimes[weekDay][lessonNumber]));
              continue;
            }

            var data = dataContent
                .split('\n')
                .map((v) => v.trim().replaceAll('<br>', ''))
                .toList();

            var lessonName =
                data[0].substring(0, data[0].length - 1).split('[');

            LessonType type = getLessonTypeFromString(lessonName[1]);

            lessons.add(
              Lesson(
                number: lessonNumbers[weekDay][lessonNumber],
                time: weekdayTimes[weekDay][lessonNumber],
                type: type,
                name: Name(
                  fullName: lessonName[0],
                  shortName:
                      lessonCell.children[0].children[0].text.split('[')[0],
                ),
                groupName: data[1],
                hall: data[2],
                teacher: Name(
                  fullName: data[3],
                  shortName: lessonCell.children[0].nodes[5].text.trim(),
                ),
                info: data[4],
                date: date,
              ),
            );
            hasFirstLesson = true;
          }
          lessonList[date] = lessons;
          weekDay++;
        }
      }

      return lessonList;
    } catch (e) {
      print(e);
      print(e.stackTrace);
      return null;
    }
  }

  static getWeek(int monthNum, int dayNum, int year) =>
      (_dateUtility.daysPastInYear(monthNum, dayNum, year) ~/ 7) + 1;

  static LessonType getLessonTypeFromString(String text) {
    switch (text.toLowerCase()) {
      case "пз":
        return LessonType.practical;
      case "лб":
        return LessonType.laboratory;
      case "зач":
        return LessonType.offset;
      case "экз":
        return LessonType.exam;
      default:
        return LessonType.lecture;
    }
  }

  static String lessonTypeToString(LessonType type) {
    switch (type) {
      case LessonType.practical:
        return "Пр";
      case LessonType.laboratory:
        return "Лаб";
      case LessonType.offset:
        return "Зач";
      case LessonType.exam:
        return "Экз";
      case LessonType.lecture:
        return "Лк";
      case LessonType.window:
        return "Окно";
      default:
        return "???";
    }
  }
}
