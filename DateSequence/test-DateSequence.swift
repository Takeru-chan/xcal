#! /usr/bin/swift
import Foundation
let testCheckMonthly: [(targetDateString: String, currentDateString: String, previousDays: Int,
                        currentDays: Int, nextDays: Int, currentDate: Int,
                        targetDayOfYear: Int, targetTotalDays: Int,
                        currentDayOfYear: Int, currentTotalDays: Int)] = [
                                ("2009-2-1", "2009-1-1", 0, 28, 14, 1, 32, 365, 1, 365),
                                ("2012-2-1", "2012-1-1", 3, 29, 10, 1, 32, 366, 1, 366),
                                ("2100-2-1", "2100-1-1", 1, 28, 13, 1, 32, 365, 1, 365),
                                ("2400-2-1", "2400-1-1", 2, 29, 11, 1, 32, 366, 1, 366)]
let testCheckWeekly: [(currentDateString: String, currentDateSequence: [(day: Int, status: Int)],
                        currentDayOfYear: Int, currentTotalDays: Int)] = [
                                ("2015-1-1",
                                    [(28, 20), (29, 20), (30, 20), (31, 20), (1, 1), (2, 0), (3, 0)], 1, 365),
                                ("2015-3-30",
                                    [(29, 0), (30, 1), (31, 0), (1, 8), (2, 8), (3, 8), (4, 8)], 89, 365),
                                ("2015-5-1",
                                    [(26, 4), (27, 4), (28, 4), (29, 4), (30, 4), (1, 1), (2, 0)], 121, 365),
                                ("2015-12-29",
                                    [(27, 0), (28, 0), (29, 1), (30, 0), (31, 0), (1, 40), (2, 40)], 363, 365)]
var testTargetDate: NSDate
var testCurrentDate: NSDate
let testFormatter: NSDateFormatter = NSDateFormatter()
testFormatter.dateFormat = "yyyy-MM-dd"
let testCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
print("Monthly Calendar Sequence Test")
for (var i = 0; i < 4; i++) {
    testTargetDate = testFormatter.dateFromString(testCheckMonthly[i].targetDateString)!
    testCurrentDate = testFormatter.dateFromString(testCheckMonthly[i].currentDateString)!
    var testDateIncluded = DateSequence(targetDate: testTargetDate, currentDate: testTargetDate, calendar: testCalendar)
    var testDateExcluded = DateSequence(targetDate: testTargetDate, currentDate: testCurrentDate, calendar: testCalendar)
    var resultIncluded = true
    var resultExcluded = true
    for (var j = 0; j < testCheckMonthly[i].previousDays; j++) {
        if !(testDateIncluded.getMonthly()[j].day == 0
          && testDateIncluded.getMonthly()[j].status == 0) {
            resultIncluded = false
        }
        if !(testDateExcluded.getMonthly()[j].day == 0
          && testDateExcluded.getMonthly()[j].status == 0) {
            resultExcluded = false
        }
    }
    for (var j = testCheckMonthly[i].previousDays; j < 42 - testCheckMonthly[i].nextDays; j++) {
        if testDateIncluded.getMonthly()[j].day != j - testCheckMonthly[i].previousDays + 1 {
            resultIncluded = false
        }
        if testDateIncluded.getMonthly()[j].status != 0 {
            if !(testCheckMonthly[i].currentDate == testDateIncluded.getMonthly()[j].day
              && testDateIncluded.getMonthly()[j].status == 1) {
                resultIncluded = false
            }
        }
        if !(testDateExcluded.getMonthly()[j].day == j - testCheckMonthly[i].previousDays + 1
          && testDateExcluded.getMonthly()[j].status == 0) {
            resultExcluded = false
        }
    }
    for (var j = testCheckMonthly[i].previousDays + testCheckMonthly[i].currentDays; j < 42; j++) {
        if !(testDateIncluded.getMonthly()[j].day == 0
          && testDateIncluded.getMonthly()[j].status == 0) {
            resultIncluded = false
        }
        if !(testDateExcluded.getMonthly()[j].day == 0
          && testDateExcluded.getMonthly()[j].status == 0) {
            resultExcluded = false
        }
    }
    print("Test Date Range:\(testCheckMonthly[i].targetDateString)")
    if resultIncluded {
        print("\u{001B}[0;32mSequence Check (included:\(testCheckMonthly[i].targetDateString)) ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mSequence Check (included:\(testCheckMonthly[i].targetDateString)) ==> NG\u{001B}[0;30m")
        print("\(testDateIncluded.getMonthly())")
    }
    if testDateIncluded.getWeekly().currentDateSet.dayOfYear == testCheckMonthly[i].targetDayOfYear
    && testDateIncluded.getWeekly().currentDateSet.totalDays == testCheckMonthly[i].targetTotalDays {
        print("\u{001B}[0;32mDate Set Check (included:\(testCheckMonthly[i].targetDateString)) ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mDate Set Check (included:\(testCheckMonthly[i].targetDateString)) ==> NG\u{001B}[0;30m")
        print("\(testDateIncluded.getWeekly().currentDateSet)")
    }
    if resultExcluded {
        print("\u{001B}[0;32mSequence Check (excluded:\(testCheckMonthly[i].currentDateString)) ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mSequence Check (excluded:\(testCheckMonthly[i].currentDateString)) ==> NG\u{001B}[0;30m")
        print("\(testDateExcluded.getMonthly())")
    }
    if testDateExcluded.getWeekly().currentDateSet.dayOfYear == testCheckMonthly[i].currentDayOfYear
    && testDateExcluded.getWeekly().currentDateSet.totalDays == testCheckMonthly[i].currentTotalDays {
        print("\u{001B}[0;32mDate Set Check (excluded:\(testCheckMonthly[i].currentDateString)) ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mDate Set Check (excluded:\(testCheckMonthly[i].currentDateString)) ==> NG\u{001B}[0;30m")
        print("\(testDateExcluded.getWeekly().currentDateSet)")
    }
}
print("Weekly Calendar Sequence Test")
for (var i = 0; i < 4; i++) {
    testTargetDate = testFormatter.dateFromString(testCheckWeekly[i].currentDateString)!
    testCurrentDate = testFormatter.dateFromString(testCheckWeekly[i].currentDateString)!
    var testDateIncluded = DateSequence(targetDate: testTargetDate, currentDate: testTargetDate, calendar: testCalendar)
    var resultIncluded = true
    print("Test Date Range:\(testCheckWeekly[i].currentDateString)")
    for (var j = 0; j < 7; j++) {
        if testDateIncluded.getWeekly().weeklySequence[j].day != testCheckWeekly[i].currentDateSequence[j].day
        || testDateIncluded.getWeekly().weeklySequence[j].status != testCheckWeekly[i].currentDateSequence[j].status {
            resultIncluded = false
        }
    }
    if resultIncluded {
        print("\u{001B}[0;32mSequence Check ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mSequence Check ==> NG\u{001B}[0;30m")
        print("\(testDateIncluded.getWeekly())")
    }
    if testDateIncluded.getWeekly().currentDateSet.dayOfYear == testCheckWeekly[i].currentDayOfYear
    && testDateIncluded.getWeekly().currentDateSet.totalDays == testCheckWeekly[i].currentTotalDays {
        print("\u{001B}[0;32mDate Set Check ==> OK\u{001B}[0;30m")
    } else {
        print("\u{001B}[0;37;41mDate Set Check ==> NG\u{001B}[0;30m")
        print("\(testDateIncluded.getWeekly().currentDateSet)")
    }
}
