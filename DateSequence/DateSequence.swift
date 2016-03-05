import Foundation
class DateSequence {
    private var targetDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int)
    private var currentDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int, dayOfYear: Int, totalDays: Int)
    private var endOfMonth: [Int]
    init(targetDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int) = (0, 0, 0, 0, 0),
            currentDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int, dayOfYear: Int, totalDays: Int) = (0, 0, 0, 0, 0, 0, 0),
            endOfMonth: [Int] = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) {
        self.targetDateSet = targetDateSet
        self.currentDateSet = currentDateSet
        self.endOfMonth = endOfMonth
    }
    func makeDateSet(targetYear: Int, targetMonth: Int, targetWeek: Int) {
        let now: NSDate = NSDate()
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"ja_JP")
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentComponents: NSDateComponents = calendar.components(
                                [.Year, .Month, .Day, .Weekday, .WeekOfYear], fromDate:now)
        currentDateSet = (year: currentComponents.year, month: currentComponents.month,
                            day: currentComponents.day, weekday: currentComponents.weekday,
                            weekOfYear: currentComponents.weekOfYear, dayOfYear: 0, totalDays: 0)
        if (currentComponents.year % 4) == 0
        && (currentComponents.year % 100) != 0
        || (currentComponents.year % 400) == 0 {
            endOfMonth[2] = 29
        } else {
            endOfMonth[2] = 28
        }
        for (var i = 0; i < 13; i++) {
            if i < currentDateSet.month {
                currentDateSet.dayOfYear += endOfMonth[i]
            }
            currentDateSet.totalDays += endOfMonth[i]
        }
        currentDateSet.dayOfYear += currentDateSet.day
        if targetWeek == -1 {
            targetDateSet = (year: currentComponents.year, month: currentComponents.month,
                                day: currentComponents.day, weekday: currentComponents.weekday,
                                weekOfYear: currentComponents.weekOfYear)
        } else {
            let targetDateString: String = String(targetYear) + "-" + String(targetMonth) + "-1"
            var targetDate: NSDate = formatter.dateFromString(targetDateString)!
            var targetComponents: NSDateComponents = calendar.components(
                                    [.Year, .Month, .Day, .Weekday, .WeekOfYear], fromDate:targetDate)
            if targetWeek > 0 {
                targetComponents.day += targetWeek * 7 - targetComponents.weekday       // 土曜日補正
                targetDate = NSCalendar.currentCalendar().dateFromComponents(targetComponents)!
                targetComponents = calendar.components(
                                        [.Year, .Month, .Day, .Weekday, .WeekOfYear], fromDate:targetDate)
            }
            targetDateSet = (year: targetComponents.year, month: targetComponents.month,
                                day: targetComponents.day, weekday: targetComponents.weekday,
                                weekOfYear: targetComponents.weekOfYear)
            if (targetComponents.year % 4) == 0
            && (targetComponents.year % 100) != 0
            || (targetComponents.year % 400) == 0 {
                endOfMonth[2] = 29
            } else {
                endOfMonth[2] = 28
            }
        }
    }
    func getMonthly(targetYear: Int, targetMonth:Int) -> (year: Int, month: Int,
                                                            monthlySequence: [(day: Int, status: Int)]) {
                        // 生成カレンダー配列（インデックス０が日曜）
                        // dateSequence[0].dayからdateSequence[6]までは曜日ヘッダ
                        // -7:Sun, -6:Mon, -5:Tue, -4:Wed, -3:Thr, -2:Fri, -1:Sat
                        // 今月以外の日付は0
                        // dateSequence[].statusは7bit情報
                        // 本日/その他=1/0, 休日/平日=2/0,（休日フラグは未実装）
                        // 曜日/日付=64/0
        self.makeDateSet(targetYear, targetMonth: targetMonth, targetWeek: 0)
        var monthlySequence: [(day: Int, status: Int)] = Array(count:49, repeatedValue:(0, 0))
        for (var i = 0; i < 7; i++) {
            monthlySequence[i] = (day: i - 7, status: 64)
        }
        for (var i = 0; i < endOfMonth[targetDateSet.month]; i++) {
            monthlySequence[targetDateSet.weekday - 1 + i + 7].day = i + 1
            if (targetDateSet.year == currentDateSet.year)
            && (targetDateSet.month == currentDateSet.month)
            && (i + 1 == currentDateSet.day) {       // インデックスと日付のズレに注意！
                monthlySequence[targetDateSet.weekday - 1 + i + 7].status |= 1
            }
        }
        return (targetDateSet.year, targetDateSet.month, monthlySequence)
    }
    func getWeekly(targetYear: Int, targetWeek: Int) -> (year: Int, month: Int, week: Int,
                                                            weeklySequence: [(day: Int, status: Int)],
                                                            dayOfYear: Int, totalDays: Int) {
                        // 生成カレンダー配列（インデックス０が日曜）
                        // targetWeekに-1をセットするとtargetYearの値を無視して現在週を得る
                        // 指定週表示の場合、土曜日の年月を表示する
                        // dateSequence[0].dayからdateSequence[6]までは曜日ヘッダ
                        // -7:Sun, -6:Mon, -5:Tue, -4:Wed, -3:Thr, -2:Fri, -1:Sat
                        // dateSequence[].statusは7bit情報
                        // 本日/その他=1/0, 休日/平日=2/0,（休日フラグは未実装）
                        // 先月/今月=4/0, 来月/今月=8/0, 去年/今年=16/0, 来年/今年=32/0
                        // 曜日/日付=64/0
        self.makeDateSet(targetYear, targetMonth: 1, targetWeek: targetWeek)
        var weeklySequence: [(day: Int, status: Int)] = Array(count:14, repeatedValue:(0, 0))
        var dateIndex: Int = targetDateSet.day - targetDateSet.weekday + 1
        var previousMonthDate: Int = endOfMonth[targetDateSet.month - 1]
        if previousMonthDate == 0 {
            previousMonthDate = 31
        }
        for (var i = 0; i < 7; i++) {
            weeklySequence[i] = (day: i - 7, status: 64)
            weeklySequence[i + 7].day = dateIndex
            if dateIndex < 1 {
                weeklySequence[i + 7].day += previousMonthDate
                weeklySequence[i + 7].status |= 4
                if targetDateSet.month == 1 {
                    weeklySequence[i + 7].status |= 16
                }
            } else if dateIndex > endOfMonth[targetDateSet.month] {
                weeklySequence[i + 7].day -= endOfMonth[targetDateSet.month]
                weeklySequence[i + 7].status |= 8
                if targetDateSet.month == 12 {
                    weeklySequence[i + 7].status |= 32
                }
            }
            if (targetDateSet.year == currentDateSet.year)
            && (targetDateSet.month == currentDateSet.month)
            && (weeklySequence[i + 7].day == currentDateSet.day) {
                weeklySequence[i + 7].status |= 1
            }
            dateIndex++
        }
        return (targetDateSet.year, targetDateSet.month, targetDateSet.weekOfYear,
                                    weeklySequence, currentDateSet.dayOfYear, currentDateSet.totalDays)
    }
}
