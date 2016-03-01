import Foundation
class DateSequence {
    private var targetDate: NSDate          // カレンダー生成対象日
    private var currentDate: NSDate         // コード実行日
    private var calendar: NSCalendar        // コード実行環境カレンダー
    private var monthlySequence: [(day: Int, status: Int)]
    private var weeklySequence: [(day: Int, status: Int)]
                                            // 生成カレンダー配列（インデックス０が日曜）
                                            // dateSequence[].statusは6bit情報
                                            // 本日/その他=1/0, 休日/平日=2/0,
                                            // 以下はweeklyDateSequenceのみ
                                            // 先月/今月=4/0, 来月/今月=8/0, 去年/今年=16/0, 来年/今年=32/0
    private var targetDateSet: (year: Int, month: Int, weekday: Int, weekOfYear: Int)
    private var currentDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int, dayOfYear: Int, totalDays: Int)
    private var endOfMonth: [Int]
    init(targetDate: NSDate, currentDate: NSDate, calendar: NSCalendar,
            monthlySequence: [(day: Int, status: Int)] = Array(count:42, repeatedValue:(0, 0)),
            weeklySequence: [(day: Int, status: Int)] = Array(count:7, repeatedValue:(0, 0)),
            targetDateSet: (year: Int, month: Int, weekday: Int, weekOfYear: Int) = (0, 0, 0, 0),
            currentDateSet: (year: Int, month: Int, day: Int, weekday: Int, weekOfYear: Int, dayOfYear: Int, totalDays: Int) = (0, 0, 0, 0, 0, 0, 0),
            endOfMonth: [Int] = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) {
        self.targetDate = targetDate
        self.currentDate = currentDate
        self.calendar = calendar
        self.monthlySequence = monthlySequence
        self.weeklySequence = weeklySequence
        self.targetDateSet = targetDateSet
        self.currentDateSet = currentDateSet
        self.endOfMonth = endOfMonth
    }
    func makeDateSet() {
        let targetComponents: NSDateComponents = calendar.components(
                                [.Year, .Month, .Day, .Weekday, .WeekOfYear], fromDate:targetDate)
        let currentComponents: NSDateComponents = calendar.components(
                                [.Year, .Month, .Day, .Weekday, .WeekOfYear], fromDate:currentDate)
        if (targetComponents.year % 4) == 0
        && (targetComponents.year % 100) != 0
        || (targetComponents.year % 400) == 0 {
            endOfMonth[2] = 29
        } else {
            endOfMonth[2] = 28
        }
        targetDateSet = (year: targetComponents.year, month: targetComponents.month,
                            weekday: targetComponents.weekday, weekOfYear: targetComponents.weekOfYear)
        currentDateSet = (year: currentComponents.year, month: currentComponents.month,
                            day: currentComponents.day, weekday: currentComponents.weekday,
                            weekOfYear: currentComponents.weekOfYear, dayOfYear: 0, totalDays: 0)
        for (var i = 0; i < currentDateSet.month; i++) {
            currentDateSet.dayOfYear += endOfMonth[i]
        }
        currentDateSet.dayOfYear += currentDateSet.day
        for (var i = 1; i < 13; i++) {
            currentDateSet.totalDays += endOfMonth[i]
        }
    }
    func getMonthly() -> [(day: Int, status: Int)] {
        makeDateSet()
        for (var i = 0; i < endOfMonth[targetDateSet.month]; i++) {
            monthlySequence[targetDateSet.weekday - 1 + i].day = i + 1
            if (targetDateSet.year == currentDateSet.year)
            && (targetDateSet.month == currentDateSet.month)
            && (i + 1 == currentDateSet.day) {       // インデックスと日付のズレに注意！
                monthlySequence[targetDateSet.weekday - 1 + i].status |= 1
            }
        }
        return monthlySequence
    }
    func getWeekly() -> (weeklySequence: [(day: Int, status: Int)],
            currentDateSet: (year: Int, month: Int, day: Int, weekday: Int,
                            weekOfYear: Int, dayOfYear: Int, totalDays: Int)) {
        makeDateSet()
        var dateIndex: Int = currentDateSet.day - currentDateSet.weekday + 1
        var previousMonthDate: Int = endOfMonth[currentDateSet.month - 1]
        if previousMonthDate == 0 {
            previousMonthDate = 31
        }
        for (var i = 0; i < 7; i++) {
            weeklySequence[i].day = dateIndex
            if dateIndex < 1 {
                weeklySequence[i].day += previousMonthDate
                weeklySequence[i].status |= 4
                if currentDateSet.month == 1 {
                    weeklySequence[i].status |= 16
                }
            } else if dateIndex > endOfMonth[currentDateSet.month] {
                weeklySequence[i].day -= endOfMonth[currentDateSet.month]
                weeklySequence[i].status |= 8
                if currentDateSet.month == 12 {
                    weeklySequence[i].status |= 32
                }
            }
            if (targetDateSet.year == currentDateSet.year)
            && (targetDateSet.month == currentDateSet.month)
            && (weeklySequence[i].day == currentDateSet.day) {
                weeklySequence[i].status |= 1
            }
            dateIndex++
        }
        return (weeklySequence, currentDateSet)
    }
}
