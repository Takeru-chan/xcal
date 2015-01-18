#The eXtended Calendar for OSX
Macのcalコマンドは今日の日付がハイライトされないので、今日の日付がハイライトされる拡張calコマンドを作りました。
OSXにはない３ヶ月表示オプションを追加したついでに、通常のcalコマンドにはない「今月/来月/再来月」表示オプションも追加しました。

さらに環境変数を設定することで休日をマゼンタ色で表示します。
##Usage | 使い方
ターミナルでxcal.shと入力します。  
- オプションなし  
 今月のカレンダーを表示します。
- -mオプション  
 任意の月のカレンダーを表示します。月に続けて年を指定すると任意の年月のカレンダーを表示します。（1902年以降）
- -yオプション  
 任意の年のカレンダーを表示します。年指定を省略すると今年のカレンダーを表示します。（1902年以降）
- -3オプション  
 先月/今月/来月の３ヶ月カレンダーを表示します。
- +3オプション  
 今月/来月/再来月の３ヶ月カレンダーを表示します。

休日を設定する環境変数は13個あります。
- XCALWEEK
 指定した曜日を休日に設定します。  
 0:日曜日、1:月曜日、...、6:土曜日  
 例）XCALWEEK=0,6：土日休みの場合
- XCALJAN
 １月の休日を設定します。
- XCALFEB
 ２月の休日を設定します。
- XCALMAR
 ３月の休日を設定します。
- XCALAPR
 ４月の休日を設定します。
- XCALMAY
 ５月の休日を設定します。
- XCALJUN
 ６月の休日を設定します。
- XCALJUL
 ７月の休日を設定します。
- XCALAUG
 ８月の休日を設定します。
- XCALSEP
 ９月の休日を設定します。
- XCALOCT
 10月の休日を設定します。
- XCALNOV
 11月の休日を設定します。
- XCALDEC
 12月の休日を設定します。

各月の休日は年ごとに指定することもできます。
また、稼働日数の都合で曜日で休日設定した日を稼働日に指定し直すこともできます。  
例）XCALJAN=+1:2014+2+3:2015+2+12-31  
元旦のように毎年日付が固定されているものは直接日付を指定します。
成人の日のように年ごとに日付が変わるものは西暦に続けて指定します。  
休日指定は日付の前に+を、稼働日指定は日付の前に-を付けます。
年ごとの日付指定は:で区切ります。  
指定の日付が競合した場合、個別休日指定&gt;個別稼働日指定&gt;曜日別休日指定の順に優先されます。
##License
This script has released under the MIT license.  
[http://opensource.org/licenses/MIT](http://opensource.org/licenses/MIT)
