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

  @override
  String get deleteAll => '全部删除';

  @override
  String get deleteAllActivitiesTitle => '删除所有活动';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return '您确定要删除 $dayName 的所有活动吗？';
  }

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notificationsOff => '关闭通知';

  @override
  String get notifyOnTime => '准时通知';

  @override
  String get notify5MinBefore => '5分钟前';

  @override
  String get notify15MinBefore => '15分钟前';

  @override
  String notificationBody(String activityName, String time) {
    return '您的活动“$activityName”计划于$time开始。';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return '已从$fromDay复制到$toDay。';
  }

  @override
  String allDeleted(Object dayName) {
    return '已删除$dayName的所有活动。';
  }

  @override
  String get copyMode => '复制模式';

  @override
  String get copyModeMerge => '与现有活动合并';

  @override
  String get copyModeOverwrite => '覆盖现有活动';

  @override
  String get overwriteConfirmationTitle => '确认覆盖';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return '这将删除“$dayName”上所有现有的活动并替换它们。您确定吗？';
  }

  @override
  String get overwrite => '覆盖';

  @override
  String get pendingNotificationsTitle => '待处理的通知';

  @override
  String get noPendingNotifications => '没有待处理的通知。';

  @override
  String get noTitle => '无标题';

  @override
  String get noBody => '无内容';

  @override
  String get cancelAll => '全部取消';

  @override
  String get close => '关闭';

  @override
  String get allNotificationsCancelled => '所有待处理的通知已被取消。';

  @override
  String get viewPendingNotifications => '查看待处理的通知';

  @override
  String get unknown => '未知';

  @override
  String get activityTime => '活动时间';

  @override
  String get notificationType => '通知类型';

  @override
  String get scheduledFor => '计划于';

  @override
  String get editTemplate => '编辑模板';

  @override
  String get addTemplate => '添加新模板';

  @override
  String get templateName => '模板名称';

  @override
  String get templateNameHint => '请输入模板名称。';

  @override
  String get durationInMinutes => '持续时间（分钟）';

  @override
  String get durationHint => '请输入持续时间。';

  @override
  String get durationInvalidHint => '请输入一个有效的正数。';

  @override
  String get templateManagerTitle => '模板管理器';

  @override
  String get noTemplates => '尚未创建模板。点击“+”添加。';

  @override
  String durationLabel(Object minutes) {
    return '持续时间：$minutes分钟';
  }

  @override
  String get manageTemplates => '管理活动模板';

  @override
  String get deleteTemplateTitle => '删除模板';

  @override
  String deleteTemplateContent(Object templateName) {
    return '您确定要删除模板“$templateName”吗？';
  }

  @override
  String get durationMaxHint => '持续时间不能超过1440分钟（24小时）。';

  @override
  String get addFromTemplate => '从模板添加';

  @override
  String get noTemplatesToUse => '没有可用的模板。请在设置中创建一个。';

  @override
  String get selectTemplate => '选择一个模板';

  @override
  String get tagsLabel => '标签（用逗号分隔）';

  @override
  String get tagsHint => '例如：工作, 运动, 个人';

  @override
  String get statisticsPageTitle => '统计数据';

  @override
  String get statisticsButtonTooltip => '查看统计数据';

  @override
  String get tagDistributionTitle => '按标签的时间分布';

  @override
  String get dailyActivityTitle => '按天统计的总活动时间';

  @override
  String get noDataForStatistics => '没有活动数据可用于显示统计信息。开始规划你的一天吧！';

  @override
  String get untagged => '未标记';

  @override
  String todayIs(String dayName) {
    return '今天是$dayName';
  }

  @override
  String get fullDay_monday => '星期一';

  @override
  String get fullDay_tuesday => '星期二';

  @override
  String get fullDay_wednesday => '星期三';

  @override
  String get fullDay_thursday => '星期四';

  @override
  String get fullDay_friday => '星期五';

  @override
  String get fullDay_saturday => '星期六';

  @override
  String get fullDay_sunday => '星期日';

  @override
  String get repeatNotificationWeekly => '每周重复';

  @override
  String get recurringNotificationHint => '在活动时间重复';

  @override
  String get error_appCouldNotStart => '无法启动应用';

  @override
  String get error_unexpectedError => '发生未知错误，请尝试重启应用。';

  @override
  String get error_restart => '重启';

  @override
  String get error_detailsForDeveloper => '错误详情（开发者适用）：';

  @override
  String get pomodoro_startFocusSession => '开始专注时段';

  @override
  String get pomodoro_sessionStateWork => '工作';

  @override
  String get pomodoro_sessionStateShortBreak => '短暂休息';

  @override
  String get pomodoro_sessionStateLongBreak => '长时间休息';

  @override
  String get pomodoro_sessionStatePaused => '已暂停';

  @override
  String pomodoro_completedSessions(int count) {
    return '已完成时段：$count';
  }

  @override
  String get pomodoro_endSessionTitle => '结束时段';

  @override
  String pomodoro_endSessionContent(
      Object sessionCount, Object minutes, Object activityName) {
    return '要将 $sessionCount 个番茄时段（$minutes 分钟）添加到活动“$activityName”吗？';
  }

  @override
  String get pomodoro_dontSave => '不保存';

  @override
  String get pomodoro_saveAndExit => '是的，添加';

  @override
  String get tapPlusToStart => '点击“+”按钮开始计划。';
}
