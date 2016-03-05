#! /usr/bin/swift
import Foundation
struct MonthlyDateSet {
    var monthlyYear: Int
    var monthlyMonth: Int
    var monthlySequence: [(day: Int, status: Int)]
}
struct WeeklyDateSet {
    var weeklyYear: Int
    var weeklyMonth: Int
    var weeklyWeek: Int
    var weeklySequence: [(day: Int, status: Int)]
    var currentWeekOfYear: Int
    var currentDayOfYear: Int
    var currentTotalDays: Int
}
// 月配列評価用データ
let testMonthlyDateSet: [MonthlyDateSet] = [
    MonthlyDateSet(monthlyYear: 2009, monthlyMonth: 2, monthlySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 1, status: 0), (day: 2, status: 0), (day: 3, status: 0), (day: 4, status: 0), (day: 5, status: 0), (day: 6, status: 0), (day: 7, status: 0),
        (day: 8, status: 0), (day: 9, status: 0), (day: 10, status: 0), (day: 11, status: 0), (day: 12, status: 0), (day: 13, status: 0), (day: 14, status: 0),
        (day: 15, status: 0), (day: 16, status: 0), (day: 17, status: 0), (day: 18, status: 0), (day: 19, status: 0), (day: 20, status: 0), (day: 21, status: 0),
        (day: 22, status: 0), (day: 23, status: 0), (day: 24, status: 0), (day: 25, status: 0), (day: 26, status: 0), (day: 27, status: 0), (day: 28, status: 0),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0)]),
    MonthlyDateSet(monthlyYear: 2012, monthlyMonth: 2, monthlySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 1, status: 0), (day: 2, status: 0), (day: 3, status: 0), (day: 4, status: 0),
        (day: 5, status: 0), (day: 6, status: 0), (day: 7, status: 0), (day: 8, status: 0), (day: 9, status: 0), (day: 10, status: 0), (day: 11, status: 0),
        (day: 12, status: 0), (day: 13, status: 0), (day: 14, status: 0), (day: 15, status: 0), (day: 16, status: 0), (day: 17, status: 0), (day: 18, status: 0),
        (day: 19, status: 0), (day: 20, status: 0), (day: 21, status: 0), (day: 22, status: 0), (day: 23, status: 0), (day: 24, status: 0), (day: 25, status: 0),
        (day: 26, status: 0), (day: 27, status: 0), (day: 28, status: 0), (day: 29, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0)]),
    MonthlyDateSet(monthlyYear: 2100, monthlyMonth: 2, monthlySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 0, status: 0), (day: 1, status: 0), (day: 2, status: 0), (day: 3, status: 0), (day: 4, status: 0), (day: 5, status: 0), (day: 6, status: 0),
        (day: 7, status: 0), (day: 8, status: 0), (day: 9, status: 0), (day: 10, status: 0), (day: 11, status: 0), (day: 12, status: 0), (day: 13, status: 0),
        (day: 14, status: 0), (day: 15, status: 0), (day: 16, status: 0), (day: 17, status: 0), (day: 18, status: 0), (day: 19, status: 0), (day: 20, status: 0),
        (day: 21, status: 0), (day: 22, status: 0), (day: 23, status: 0), (day: 24, status: 0), (day: 25, status: 0), (day: 26, status: 0), (day: 27, status: 0),
        (day: 28, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0)]),
    MonthlyDateSet(monthlyYear: 2400, monthlyMonth: 2, monthlySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 0, status: 0), (day: 0, status: 0), (day: 1, status: 0), (day: 2, status: 0), (day: 3, status: 0), (day: 4, status: 0), (day: 5, status: 0),
        (day: 6, status: 0), (day: 7, status: 0), (day: 8, status: 0), (day: 9, status: 0), (day: 10, status: 0), (day: 11, status: 0), (day: 12, status: 0),
        (day: 13, status: 0), (day: 14, status: 0), (day: 15, status: 0), (day: 16, status: 0), (day: 17, status: 0), (day: 18, status: 0), (day: 19, status: 0),
        (day: 20, status: 0), (day: 21, status: 0), (day: 22, status: 0), (day: 23, status: 0), (day: 24, status: 0), (day: 25, status: 0), (day: 26, status: 0),
        (day: 27, status: 0), (day: 28, status: 0), (day: 29, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0),
        (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0), (day: 0, status: 0)])]
// 週配列評価用データ
var testWeeklyDateSet: [WeeklyDateSet] = [
    WeeklyDateSet(weeklyYear: 2015, weeklyMonth: 1, weeklyWeek: 1, weeklySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 28, status: 20), (day: 29, status: 20), (day: 30, status: 20), (day: 31, status: 20), (day: 1, status: 0), (day: 2, status: 0), (day: 3, status: 0)],
        currentWeekOfYear: 0, currentDayOfYear: 0, currentTotalDays: 0),
    WeeklyDateSet(weeklyYear: 2015, weeklyMonth: 5, weeklyWeek: 18, weeklySequence: [
        (day: -7, status: 64), (day: -6, status: 64), (day: -5, status: 64), (day: -4, status: 64), (day: -3, status: 64), (day: -2, status: 64), (day: -1, status: 64),
        (day: 26, status: 4), (day: 27, status: 4), (day: 28, status: 4), (day: 29, status: 4), (day: 30, status: 4), (day: 1, status: 0), (day: 2, status: 0)],
        currentWeekOfYear: 0, currentDayOfYear: 0, currentTotalDays: 0)]
let now: NSDate = NSDate()
let testFormatter: NSDateFormatter = NSDateFormatter()
let testCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
let testComponents: NSDateComponents = testCalendar.components([.Year, .Month, .Day, .WeekOfYear], fromDate:now)
var endOfMonth: [Int] = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
if (testComponents.year % 4) == 0 && (testComponents.year % 100) != 0 || (testComponents.year % 400) == 0 {
    endOfMonth[2] = 29
} else {
    endOfMonth[2] = 28
}
var testCurrentDayOfYear: Int = 0;
var testCurrentTotalDays: Int = 0;
for (var i = 0; i < 13; i++) {
    if i < testComponents.month {
        testCurrentDayOfYear += endOfMonth[i]
    }
    testCurrentTotalDays += endOfMonth[i]
}
testCurrentDayOfYear += testComponents.day

print("[Monthly Sequence Test]")
for (var i = 0; i < 4; i++) {
var testMonthlySequence = DateSequence().getMonthly(testMonthlyDateSet[i].monthlyYear,
            targetMonth: testMonthlyDateSet[i].monthlyMonth)
    var result = true
    for (var j = 0; j < 49; j++) {
        if testMonthlySequence.monthlySequence[j].day !=
            testMonthlyDateSet[i].monthlySequence[j].day {
            result = false
        }
        if testMonthlySequence.monthlySequence[j].status !=
            testMonthlyDateSet[i].monthlySequence[j].status {
            result = false
        }
    }
    if testMonthlySequence.year != testMonthlyDateSet[i].monthlyYear {
        result = false
    }
    if testMonthlySequence.month != testMonthlyDateSet[i].monthlyMonth {
        result = false
    }
    print("\(testMonthlySequence.year)-\(testMonthlySequence.month)", terminator:"")
    if result {
        print("\u{001B}[0;32m ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41m ==> NG\u{001B}[0;30m")
    }
    print(testMonthlySequence)
}
var testMonthlySequence = DateSequence().getMonthly(testComponents.year, targetMonth: testComponents.month)
var todayFlag: Int = 0
for (var i = 0; i < 49; i++) {
    if (testMonthlySequence.monthlySequence[i].status & 1) == 1
    && testMonthlySequence.monthlySequence[i].day == testComponents.day {
        todayFlag++
    }
}
print("Current month", terminator:"")
if todayFlag == 1 {
    print("\u{001B}[0;32m ==> OK\u{001B}[0;30m")
} else {
    print("\u{001B}[0;37;41m ==> NG\u{001B}[0;30m")
}
print(testMonthlySequence)

print("[Weekly Sequence Test]")
for (var i = 0; i < 2; i++) {
var testWeeklySequence = DateSequence().getWeekly(testWeeklyDateSet[i].weeklyYear,
            targetWeek: testWeeklyDateSet[i].weeklyWeek)
    var result = true
    for (var j = 0; j < 14; j++) {
        if testWeeklySequence.weeklySequence[j].day !=
            testWeeklyDateSet[i].weeklySequence[j].day {
            result = false
        }
        if testWeeklySequence.weeklySequence[j].status !=
            testWeeklyDateSet[i].weeklySequence[j].status {
            result = false
        }
    }
    if testWeeklySequence.year != testWeeklyDateSet[i].weeklyYear {
        result = false
    }
    if testWeeklySequence.month != testWeeklyDateSet[i].weeklyMonth {
        result = false
    }
    if testWeeklySequence.week != testWeeklyDateSet[i].weeklyWeek {
        result = false
    }
    print("\(testWeeklySequence.year) W\(testWeeklySequence.week)", terminator:"")
    if result {
        print("\u{001B}[0;32m ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41m ==> NG\u{001B}[0;30m")
    }
    print(testWeeklySequence)
}
var testWeeklySequence = DateSequence().getWeekly(testComponents.year, targetWeek: -1)
todayFlag = 0
for (var i = 0; i < 14; i++) {
    if (testWeeklySequence.weeklySequence[i].status & 1) == 1
    && testWeeklySequence.weeklySequence[i].day == testComponents.day {
        todayFlag++
    }
}
var result = true
if testWeeklySequence.dayOfYear != testCurrentDayOfYear {
    result = false
}
if testWeeklySequence.totalDays != testCurrentTotalDays {
    result = false
}
print("Current week", terminator:"")
if todayFlag == 1 && result {
    print("\u{001B}[0;32m ==> OK\u{001B}[0;30m")
} else {
    print("\u{001B}[0;37;41m ==> NG\u{001B}[0;30m")
}
print(testWeeklySequence)
