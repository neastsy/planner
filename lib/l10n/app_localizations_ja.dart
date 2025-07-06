// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'アクティビティプランナー';

  @override
  String get days_PZT => '月';

  @override
  String get days_SAL => '火';

  @override
  String get days_CAR => '水';

  @override
  String get days_PER => '木';

  @override
  String get days_CUM => '金';

  @override
  String get days_CMT => '土';

  @override
  String get days_PAZ => '日';

  @override
  String get addNewActivity => 'アクティビティを追加';

  @override
  String get activityList => '活動リスト';

  @override
  String get noActivityToday => '今日の活動はまだ追加されていません。';

  @override
  String get editActivity => '活動を編集';

  @override
  String get activityName => '活動名';

  @override
  String get activityNameHint => '活動名を入力してください。';

  @override
  String get startTime => '開始時間';

  @override
  String get endTime => '終了時間';

  @override
  String get selectTime => '選択';

  @override
  String get chooseColor => '色を選択';

  @override
  String get add => '追加';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get deleteActivityTitle => '活動を削除';

  @override
  String get deleteActivityContent => 'この活動を削除してもよろしいですか？';

  @override
  String get delete => '削除';

  @override
  String get overlappingActivityTitle => '重複する活動';

  @override
  String get overlappingActivityContent => 'この時間帯には他の活動があります。続行しますか？';

  @override
  String get continueAction => '続行';

  @override
  String get errorSelectAllTimes => 'すべての時間を選択してください。';

  @override
  String get errorStartEndTimeSame => '開始時間と終了時間を同じにすることはできません。';

  @override
  String get timePickerSet => '設定';

  @override
  String get timePickerSelect => '時間を選択';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get settings => '設定';

  @override
  String get theme => 'テーマ';

  @override
  String get lightTheme => 'ライトテーマ';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get notes => 'メモ (任意)';

  @override
  String get copyDay => '曜日をコピー';

  @override
  String get copy => 'コピー';

  @override
  String copyFromTo(String dayName) {
    return '$dayNameのすべてのアクティビティをコピー先:';
  }

  @override
  String get targetDayNotEmptyTitle => 'ターゲット日が空ではありません';

  @override
  String targetDayNotEmptyContent(String dayName) {
    return '曜日 \'$dayName\' にはすでにアクティビティがあります。新しいアクティビティを追加してもよろしいですか？';
  }

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get deleteAllActivitiesTitle => 'すべてのアクティビティを削除';

  @override
  String deleteAllActivitiesContent(String dayName) {
    return '$dayNameのすべてのアクティビティを削除してもよろしいですか？';
  }

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationsOff => '通知オフ';

  @override
  String get notifyOnTime => '時間通りに通知';

  @override
  String get notify5MinBefore => '5分前';

  @override
  String get notify15MinBefore => '15分前';

  @override
  String notificationBody(String activityName, String time) {
    return 'アクティビティ「$activityName」は$timeに開始予定です。';
  }

  @override
  String dayCopied(Object fromDay, Object toDay) {
    return '$fromDayから$toDayにコピーしました。';
  }

  @override
  String allDeleted(Object dayName) {
    return '$dayNameのすべてのアクティビティが削除されました。';
  }

  @override
  String get copyMode => 'コピーモード';

  @override
  String get copyModeMerge => '既存のアクティビティと統合';

  @override
  String get copyModeOverwrite => '既存のアクティビティを上書き';

  @override
  String get overwriteConfirmationTitle => '上書きの確認';

  @override
  String overwriteConfirmationContent(Object dayName) {
    return 'これにより、\'$dayName\'の既存のすべてのアクティビティが削除され、置き換えられます。よろしいですか？';
  }

  @override
  String get overwrite => '上書き';
}
