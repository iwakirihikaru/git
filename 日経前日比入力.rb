require 'win32ole' #contl+F11で実行
require "json"
require 'rubygems'
require "selenium-webdriver"
module Excel; end

excel = WIN32OLE.new('Excel.Application')
excel.visible = true #Excelの表示／非表示設定
excel.displayAlerts = true #アラートメッセージを表示／非表示設定
WIN32OLE.const_load(excel, Excel)
wait = Selenium::WebDriver::Wait.new(:timeout => 120)

book = excel.Workbooks.Open('C:\Users\光\Desktop\マクロ付株式検証.xlsm')#Excelブックを開く
sheet = book.worksheets(3)#Excelの3番のシートを取得

date=1

while date != 0 do

blank = sheet.Rows.count
last = sheet.cells(blank,20).End(Excel::XlUp).row #.cells...行・列を数字で指定する。(英語｛横｝が後)　.row..行番号を表す整数を返すプロパティ .end...contlキーかな？　行4習得
date=sheet.cells(last+1,2).value #value はデータの値のコピーにも使える。
date_a=date.to_s.split("-")
day_of_the_week=sheet.cells(last+1,15).value
yearth,monthth,dayth=date_a[0].to_i,date_a[1].to_i,date_a[2].to_i-1


  if dayth == 0
    monthth = monthth-1
    if monthth == 1
    dayth =28
    elsif monthth == 3 or monthth ==5 or monthth ==8 or monthth ==10
    dayth =30
    else
      dayth =31


    end
  end
dayths,a,b=dayth-10,0,0
  if monthth==12
    a=1
    else a=monthth+1
  end

  if monthth==12
      b=yearth+1
  else b=yearth
  end

  
  
  if dayth<=10
    a = monthth
    dayths = dayth +10
  end

print yearth,monthth,dayth

wd = Selenium::WebDriver.for :chrome
wd.get "https://stocks.finance.yahoo.co.jp/stocks/history/?code=998407.O"

wait.until{wd.find_element(:id, "selYear")}.click #wait指定。
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selYear")).select_by(:text, yearth.to_s)
wd.find_element(:id, "selYear").click
wd.find_element(:id, "selMonth").click
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selMonth")).select_by(:text, monthth.to_s)
wd.find_element(:id, "selMonth").click
wd.find_element(:id, "selDay").click
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selDay")).select_by(:text, dayth.to_s)
wd.find_element(:id, "selDay").click
wd.find_element(:id, "selYearT").click
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selYearT")).select_by(:text,b.to_s)
wd.find_element(:id, "selYearT").click
wd.find_element(:id, "selMonthT").click
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selMonthT")).select_by(:text,a.to_s)
wd.find_element(:id, "selMonthT").click
wd.find_element(:id, "selDayT").click
Selenium::WebDriver::Support::Select.new(wd.find_element(:id, "selDayT")).select_by(:text,dayths.to_s)
wd.find_element(:css, "input.submit").click

line=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody")}.find_elements(:tag_name,"tr").size()
more_yesterday_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}]/td[5]")}.text
yesterday_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line-1}]/td[5]")}.text
today_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line-2}]/td[5]")}.text
next_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line-3}]/td[5]")}.text

more_yesterday_price.slice!(2)
yesterday_price.slice!(2) # , が邪魔だったので　sliceで3文字目を削除。
today_price.slice!(2)
next_price.slice!(2)

zero_dailychange=yesterday_price.to_i-more_yesterday_price.to_i
first_dailychange=today_price.to_i-yesterday_price.to_i
second_dailychange=next_price.to_i-today_price.to_i

if day_of_the_week =="月曜日"
  zero_dailychange = 0
  first_dailychange = 0
  second_dailychange =0
end
sheet.cells(last+1,20).value=zero_dailychange
sheet.cells(last+1,21).value=first_dailychange
sheet.cells(last+1,22).value=second_dailychange
wd.close
end



