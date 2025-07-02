// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '活动规划师';

  @override
  String get days_PZT => '周一';

  @override
  String get days_SAL => '周二';

  @override
  String get days_CAR => '周三';

  @override
  String get days_PER => '周四';

  @override
  String get days_CUM => '周五';

  @override
  String get days_CMT => '周六';

  @override
  String get days_PAZ => '周日';

  @override
  String get addNewActivity => '添加活动';

  @override
  String get activityList => '活动列表';

  @override
  String get noActivityToday => '今天还没有添加任何活动。';

  @override
  String get editActivity => '编辑活动';

  @override
  String get activityName => '活动名称';

  @override
  String get activityNameHint => '请输入活动名称。';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get selectTime => '选择';

  @override
  String get chooseColor => '选择颜色';

  @override
  String get add => '添加';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get deleteActivityTitle => '删除活动';

  @override
  String get deleteActivityContent => '您确定要删除此活动吗？';

  @override
  String get delete => '删除';

  @override
  String get overlappingActivityTitle => '活动冲突';

  @override
  String get overlappingActivityContent => '此时间段内已有其他活动。是否仍要继续？';

  @override
  String get continueAction => '继续';

  @override
  String get errorSelectAllTimes => '请选择所有时间。';

  @override
  String get errorStartEndTimeSame => '开始时间和结束时间不能相同。';

  @override
  String get timePickerSet => '设置';

  @override
  String get timePickerSelect => '选择时间';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get lightTheme => '浅色主题';

  @override
  String get darkTheme => '深色主题';

  @override
  String get notes => '备注 (可选)';

  @override
  String get copyDay => '复制日期';

  @override
  String get copy => '复制';

  @override
  String copyFromTo(String dayName) {
    return '将 $dayName 的所有活动复制到：';
  }

  @override
  String get targetDayNotEmptyTitle => '目标日期不为空';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return '日期 \'$dayName\' 已有活动。您确定要添加新活动吗？';
  }
}
