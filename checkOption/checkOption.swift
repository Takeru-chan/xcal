class checkOption {
    private var arguments: [String]
    private var calendarRaws: Int   // 表示月行数
    private var calendarCols: Int   // 表示月列数
    private var weekFormat: Bool    // 週表示指示 = true
    private var startYear: Int      // 年指定なし = 0 (1800...9999)
    private var startMonth: Int     // 月指定なし = 0 (1...12)
    private var adjustMonth: Int    // 表示開始月調整値
    private var optionError: Int32  // エラーなし = 0
                                    // 指定年上限越え = 1, 指定年下限越え = 2, 指定年変換エラー = 3,
                                    // 指定月上限越え = 4, 指定月下限越え = 5, 指定月変換エラー = 6,
                                    // 引数エラー = 9、エラー時は他の全てのプロパティがデフォルト値
    init(arguments: [String], calendarRaws: Int = 1, calendarCols: Int = 1, weekFormat: Bool = false,
            startYear: Int = 0, startMonth: Int = 0, adjustMonth: Int = 0, optionError: Int32 = 0) {
        self.arguments = arguments
        self.calendarRaws = calendarRaws
        self.calendarCols = calendarCols
        self.weekFormat = weekFormat
        self.startYear = startYear
        self.startMonth = startMonth
        self.adjustMonth = adjustMonth
        self.optionError = optionError
    }
    func checkSwitch() {
        var checkString: (value: Int, status: Int32)
        if arguments.count > 4 {
            optionError = 9
        } else if arguments.count != 1 {
            switch arguments[1] {
            case "-y":
                if arguments.count == 4 {
                    optionError = 9
                    break
                } else if arguments.count == 3 {
                    checkString = checkNaturalNumber(arguments[2], maxValue:9999, minValue:1800)
                    if checkString.status == 0 {
                        startYear = checkString.value
                    } else {
                        optionError = checkString.status
                        break
                    }
                }
                calendarRaws = 4
                calendarCols = 3
                startMonth = 1
            case "-m", "-3", "+3":
                if arguments.count == 4 {
                    checkString = checkNaturalNumber(arguments[2], maxValue:12, minValue:1)
                    if checkString.status == 0 {
                        startMonth = checkString.value
                    } else {
                        optionError = checkString.status + 3
                        break
                    }
                    checkString = checkNaturalNumber(arguments[3], maxValue:9999, minValue:1800)
                    if checkString.status == 0 {
                        startYear = checkString.value
                    } else {
                        startMonth = 0
                        optionError = checkString.status
                        break
                    }
                } else if arguments.count == 3 {
                    checkString = checkNaturalNumber(arguments[2], maxValue:12, minValue:1)
                    if checkString.status == 0 {
                        startMonth = checkString.value
                    } else {
                        optionError = checkString.status + 3
                        break
                    }
                }
                if arguments[1] != "-m" {
                    calendarCols = 3
                }
                if arguments[1] == "-3" {
                    adjustMonth = -1
                }
            case "-w":
                if arguments.count > 2 {
                    optionError = 9
                } else {
                    weekFormat = true
                }
            default:
                optionError = 9
            }
        }
    }
    func checkNaturalNumber(target: String, maxValue: Int, minValue: Int) -> (Int, Int32) {
        var value: Int = 0      // OKなら変換値、NGなら-1を返す
        var status: Int32 = 0   // 0:変換および範囲OK、1:上限値越えエラー、2:下限値越えエラー、3:変換エラー
        checkCharacters: for char in target.characters {
            switch char {
            case "0"..."9":
                status = 0
            default:
                status = 3
                value = -1
                break checkCharacters
            }
        }
        if status != 3 {
            value = Int(target)!
            if value > maxValue {
                status = 1
            } else if value < minValue {
                status = 2
            }
        }
        return (value, status)
    }
    func getCalendarFormat() -> (Int, Int, Bool, Int, Int, Int, Int32) {
        self.checkSwitch()
        return (calendarRaws, calendarCols, weekFormat, startYear, startMonth, adjustMonth, optionError)
    }
}
