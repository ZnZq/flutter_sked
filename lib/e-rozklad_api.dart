import 'dart:async';

import 'package:date_util/date_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart';
import 'package:meta/meta.dart';
import 'package:jiffy/jiffy.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ERozkladAPI {
  static var _dateUtility = new DateUtil();
  static var cache = <DateTime, List<Lesson>>{};
  static SharedPreferences storage;
  static String group = "1268";
  static String groupName;
  static bool login;

  static var filterForm = RegExp(r'<form.*id="filter-form".*\/form>');

  static init() {
    group = storage.getString('group') ?? '1268';
    groupName = storage.getString('groupName');
    if (cache.isEmpty)
      update();
  }

  static final _rozklad = StreamController<Map<DateTime, List<Lesson>>>();
  static Stream<Map<DateTime, List<Lesson>>> get rozkladStream =>
      _rozklad.stream;

  static update() async {
    var r = await rozklad(group: group);

    if (r == null) {
      Fluttertoast.showToast(
        msg: 'Не удалось обновить расписание',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIos: 2,
      );
      return;
    }
    cache.addAll(r);

    var now = DateTime.now();
    var week = now.weekday;
    var oldDate =
        DateTime(now.year, now.month, now.day).add(Duration(days: -week));

    cache.removeWhere((k, v) => k.isBefore(oldDate));
    _rozklad.add(cache);

    Fluttertoast.showToast(
        msg: 'Расписание обновлено',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIos: 2);
  }

  static Future getfilterFormHtml(url) async {
    var response = await http.get(url);

    var doc = html.parse(response.body);
    var filter = doc.querySelector('#filter-form');

    return filter;
  }

  static Map<String, String> _parseSelect(Element filter, selectId) {
    var data = <String, String>{'empty': ''};
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

  static Future getOptions({faculty, course}) async {
    var formHtml = await getfilterFormHtml(
        'http://e-rozklad.dut.edu.ua/timeTable/group?TimeTableForm[faculty]=$faculty&TimeTableForm[course]=$course');

    return {
      'faculty': _parseSelect(formHtml, 'TimeTableForm_faculty'),
      'course': _parseSelect(formHtml, 'TimeTableForm_course'),
      'group': _parseSelect(formHtml, 'TimeTableForm_group'),
    };
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

      timeEnd = timeEnd ?? timeStart.add(Duration(days: 7 * 4 - 1));

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
      var weekNumber = 1;
      for (var weekday in trows.map((e) => e.children[0])) {
        weekdayTimes[weekNumber] = [];
        for (var times in weekday.children.skip(1)) {
          weekdayTimes[weekNumber].add(LessonTime(
            start: Jiffy(times.querySelector('.start').text, "HH:mm").dateTime,
            end: Jiffy(times.querySelector('.finish').text, "HH:mm").dateTime,
          ));
        }
        weekNumber++;
      }

      var weekStart =
          _dateUtility.getWeek(timeStart.month, timeStart.day, timeStart.year);
      var weekEnd =
          _dateUtility.getWeek(timeEnd.month, timeEnd.day, timeEnd.year);

      if (weekStart >= 52 && weekStart > weekEnd) weekEnd += 52;

      var dWeek = weekEnd - weekStart;

      for (int week = 0; week <= dWeek; week++) {
        var weekDay = 1;
        for (var tdLessons in trows.map((e) => e.children[1 + week])) {
          if (tdLessons.classes.contains('closed')) continue;

          var lessonNumber = 0;

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
                    number: lessonNumber,
                    time: weekdayTimes[weekDay][lessonNumber - 1]));
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
                  number: lessonNumber,
                  time: weekdayTimes[weekDay][lessonNumber - 1],
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
                  info: data[4]),
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
      return null;
    }
  }

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

class Lesson {
  int number;
  LessonTime time;
  LessonType type = LessonType.window;
  Name name = Name(fullName: '', shortName: '');
  String groupName = '';
  String hall = '';
  Name teacher = Name(fullName: '', shortName: '');
  String info = '';
  Lesson(
      {@required this.number,
      @required this.time,
      this.type,
      this.groupName,
      this.hall,
      this.info,
      this.name,
      this.teacher});

  Lesson.window({this.number, this.time});

  @override
  String toString() {
    return '${time.start} ${name.shortName}';
  }
}

class Name {
  String shortName;
  String fullName;
  Name({this.fullName, this.shortName});
}

class LessonTime {
  DateTime start, end;
  LessonTime({this.start, this.end});
  @override
  String toString() {
    return '$start - $end';
  }
}

enum LessonType { lecture, laboratory, practical, offset, exam, window }
