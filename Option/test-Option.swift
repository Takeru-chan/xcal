#! /usr/bin/swift
import Foundation
var pass: Int = 0
var fail: Int = 0
let testArguments: [(args:[String], raws:Int, cols:Int, weekFlag:Bool,
        year:Int, month:Int, adjust:Int, error:Int32)] =
    [(["no-option"], 1, 1, false, 0, 0, 0, 0),
    (["current-year", "-y"], 4, 3, false, 0, 1, 0, 0),
    (["specified-year", "-y", "2016"], 4, 3, false, 2016, 1, 0, 0),
    (["error-specified-year-upper", "-y", "10000"], 1, 1, false, 0, 0, 0, 1),
    (["error-specified-year-lower", "-y", "100"], 1, 1, false, 0, 0, 0, 2),
    (["error-specified-year-irregular", "-y", "qwerty"], 1, 1, false, 0, 0, 0, 3),
    (["error-specified-year", "-y", "2016", "extra"], 1, 1, false, 0, 0, 0, 9),
    (["current-month", "-m"], 1, 1, false, 0, 0, 0, 0),
    (["specified-month", "-m", "12"], 1, 1, false, 0, 12, 0, 0),
    (["error-specified-month-upper", "-m", "13"], 1, 1, false, 0, 0, 0, 4),
    (["error-specified-month-lower", "-m", "0"], 1, 1, false, 0, 0, 0, 5),
    (["error-specified-month-irregular", "-m", "qwerty"], 1, 1, false, 0, 0, 0, 6),
    (["specified-month-and-year", "-m", "12", "2016"], 1, 1, false, 2016, 12, 0, 0),
    (["error-specified-month-and-year-upper", "-m", "12", "20016"], 1, 1, false, 0, 0, 0, 1),
    (["error-specified-month-and-year-lower", "-m", "12", "200"], 1, 1, false, 0, 0, 0, 2),
    (["error-specified-month-and-year-irregular", "-m", "12", "qwerty"], 1, 1, false, 0, 0, 0, 3),
    (["error-specified-month-upper-and-year", "-m", "13", "2016"], 1, 1, false, 0, 0, 0, 4),
    (["error-specified-month-lower-and-year", "-m", "0", "2016"], 1, 1, false, 0, 0, 0, 5),
    (["error-specified-month-irregular-and-year", "-m", "qwerty", "2016"], 1, 1, false, 0, 0, 0, 6),
    (["error-specified-month", "-m", "2", "2016", "extra"], 1, 1, false, 0, 0, 0, 9),
    (["current-month-and-befor-after", "-3"], 1, 3, false, 0, 0, -1, 0),
    (["specified-month-and-befor-after", "-3", "2"], 1, 3, false, 0, 2, -1, 0),
    (["error-specified-month-upper-and-befor-after", "-3", "22"], 1, 1, false, 0, 0, 0, 4),
    (["error-specified-month-lower-and-befor-after", "-3", "0"], 1, 1, false, 0, 0, 0, 5),
    (["error-specified-month-irregular-and-befor-after", "-3", "qwerty"], 1, 1, false, 0, 0, 0, 6),
    (["specified-year-month-and-befor-after", "-3", "2", "2016"], 1, 3, false, 2016, 2, -1, 0),
    (["error-month-and-befor-after-year-upper", "-3", "2", "12016"], 1, 1, false, 0, 0, 0, 1),
    (["error-month-and-befor-after-year-lower", "-3", "2", "12"], 1, 1, false, 0, 0, 0, 2),
    (["error-month-and-befor-after-year-irregular", "-3", "2", "20a12"], 1, 1, false, 0, 0, 0, 3),
    (["error-month-upper-and-befor-after", "-3", "52", "2012"], 1, 1, false, 0, 0, 0, 4),
    (["error-month-lower-and-befor-after", "-3", "0", "2012"], 1, 1, false, 0, 0, 0, 5),
    (["error-month-irregular-and-befor-after", "-3", "1.2", "2012"], 1, 1, false, 0, 0, 0, 6),
    (["error-month-and-befor-after", "-3", "2", "2016", "extra"], 1, 1, false, 0, 0, 0, 9),
    (["three-month-from-current", "+3"], 1, 3, false, 0, 0, 0, 0),
    (["specified-three-month-from-current", "+3", "5"], 1, 3, false, 0, 5, 0, 0),
    (["error-specified-three-month-upper-from-current", "+3", "50"], 1, 1, false, 0, 0, 0, 4),
    (["error-specified-three-month-lower-from-current", "+3", "0"], 1, 1, false, 0, 0, 0, 5),
    (["error-specified-three-month-irregular-from-current", "+3", "-8"], 1, 1, false, 0, 0, 0, 6),
    (["specified-year-three-month-from-current", "+3", "5", "2016"], 1, 3, false, 2016, 5, 0, 0),
    (["error-specified-year-upper-three-month-from-current", "+3", "5", "102016"], 1, 1, false, 0, 0, 0, 1),
    (["error-specified-year-lower-three-month-from-current", "+3", "5", "0"], 1, 1, false, 0, 0, 0, 2),
    (["error-specified-year-irregular-three-month-from-current", "+3", "5", "-2020"], 1, 1, false, 0, 0, 0, 3),
    (["error-specified-year-three-month-upper-from-current", "+3", "502", "2020"], 1, 1, false, 0, 0, 0, 4),
    (["error-specified-year-three-month-lower-from-current", "+3", "0", "2020"], 1, 1, false, 0, 0, 0, 5),
    (["error-specified-year-three-month-irregular-from-current", "+3", "10.3", "2020"], 1, 1, false, 0, 0, 0, 6),
    (["error-three-month-from-current", "+3", "5", "2016", "extra"], 1, 1, false, 0, 0, 0, 9),
    (["current-week", "-w"], 1, 1, true, 0, 0, 0, 0),
    (["error-current-week", "-w", "extra"], 1, 1, false, 0, 0, 0, 9),
    (["error", "-x"], 1, 1, false, 0, 0, 0, 9)]
for (var i = 0; i < testArguments.count; i++) {
    print("\(testArguments[i].args) ", terminator:"")
    var options = (raws:0, cols:0, weekFlag:false, year:0, month:0, adjust:0, error:Int32(0))
    options = Option(arguments: testArguments[i].args).getCalendarFormat()
    if testArguments[i].raws == options.raws &&
       testArguments[i].cols == options.cols &&
       testArguments[i].weekFlag == options.weekFlag &&
       testArguments[i].year == options.year &&
       testArguments[i].month == options.month &&
       testArguments[i].adjust == options.adjust &&
       testArguments[i].error == options.error {
        print("\u{001B}[0;32m==> OK\u{001B}[0;30m")
        pass++
    } else {
        print("\u{001B}[0;37;41m==> NG\u{001B}[0;30m")
        print("Raws:\(options.raws), ", terminator:"")
        print("Cols:\(options.cols), ", terminator:"")
        print("WeekFormat:\(options.weekFlag)")
        print("StartYear:\(options.year), ", terminator:"")
        print("StartMonth:\(options.month), ", terminator:"")
        print("AdjustMonth:\(options.adjust), ", terminator:"")
        print("OptionError:\(options.error)")
        fail++
    }
}
print("\u{001B}[0;32mPassed:\(pass)\u{001B}[0;30m, \u{001B}[0;31mFailed:\(fail)\u{001B}[0;30m")
