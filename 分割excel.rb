require 'win32ole' #contl+F11で実行
require "json"
require 'rubygems'
require "selenium-webdriver"
#begin # do_something
require "selenium-webdriver"

#Excel VBA定数のロード
module Excel; end

#Excelの初期化
excel = WIN32OLE.new('Excel.Application')
excel.visible = true #Excelの表示／非表示設定
excel.displayAlerts = true #アラートメッセージを表示／非表示設定
WIN32OLE.const_load(excel, Excel)

book = excel.Workbooks.Open('C:\Users\光\Desktop\Book1.xlsx')#Excelブックを開く
sheet = book.worksheets(1)#Excelの3番のシートを取得


blank = sheet.Rows.count #列の最終行数習得⇒OK
last2 = sheet.cells(blank,1).End(Excel::XlUp).row #.cells...行・列を数字で指定する。(英語｛横｝が後)　.row..行番号を表す整数を返すプロパティ .end...contlキーかな？


while last2 > 1 do
yearth = (sheet.cells(last2,2).value).to_i
monthth = sheet.cells(last2,3).value.to_i
dayth =  sheet.cells(last2,4).value.to_i
number = sheet.cells(last2,1).value.to_i
management =sheet.cells(last2,6).value.to_i
aliquots = sheet.cells(last2,5).value.to_i

  #number=銘柄番号,aliquots=分割量,management(1東証一部,2東証二部,3ジャスダック,4マザーズ,5その他)
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
      a=monthth
      dayths=18
    end

  wait = Selenium::WebDriver::Wait.new(:timeout => 120)
  wd = Selenium::WebDriver.for :chrome
  wd.get "https://finance.yahoo.co.jp/"
  wd.find_element(:name, "query").click
  wd.find_element(:name, "query").clear
  wd.find_element(:name, "query").send_keys "#{number}"
  wd.find_element(:id, "searchButton").click
  wait.until{wd.find_element(:link, "時系列")}.click


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

  #wd.find_element(:xpath,"//div[@id='main']/div[5]/table/tbody/tr[20]/td[2]").click
  line=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody")}.find_elements(:tag_name,"tr").size()
  #line=wd.find_element(:xpath,"//div[@id='main']/div[5]/table/tbody").find_elements(:tag_name,"tr").size()#行数を取得 #sizeは要素数をカウントする。
  yesterday_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}]/td[5]")}.text
  #名前が違う　xpathの一部指定方法➡.css.xpathとメソッドの二重指定⇒メソッドチェーン？で解決
  first_1_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-1]/td[2]")}.text
  stock=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}]/td[6]")}.text #出来高
  first_high_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-1]/td[3]")}.text
  first_low_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-1]/td[4]")}.text
  first_last_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-1]/td[5]")}.text
  second_1_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-2]/td[2]")}.text
  second_last_price=wait.until{wd.find_element(:css,"table.boardFin.yjSt.marB6 > tbody").find_element(:xpath,"tr[#{line}-2]/td[5]")}.text
  split_date="#{yearth}年#{monthth}月#{dayth}日"
  stock_name=wait.until{wd.find_element(:css,"th.symbol")
  wd.find_element(:tag_name,"h1")}.text

  book2 = excel.Workbooks.Open('C:\Users\光\Desktop\マクロ付株式検証.xlsm')#Excelブックを開く
  sheet2 = book2.worksheets(3)#Excelの3番のシートを取得

  blank = sheet2.Rows.count #列の最終行数習得⇒OK
  last = sheet2.cells(blank,1).End(Excel::XlUp).row #.cells...行・列を数字で指定する。(英語｛横｝が後)　.row..行番号を表す整数を返すプロパティ .end...contlキーかな？
  sheet2.cells(last+1,1).value = stock_name#価格ペースト A列
  sheet2.cells(last+1,2).value =split_date #B
  sheet2.cells(last+1,3).value =stock
  sheet2.cells(last+1,4).value = yesterday_price
  sheet2.cells(last+1,5).value = first_1_price
  sheet2.cells(last+1,6).value = first_high_price
  sheet2.cells(last+1,7).value= first_low_price
  sheet2.cells(last+1,8).value= first_last_price
  sheet2.cells(last+1,9).value = second_1_price
  sheet2.cells(last+1,10).value = second_last_price
  sheet2.cells(last+1,23).value = aliquots
  if management==1
    sheet2.cells(last+1,21).value = "東証1部"
  elsif management==2
    sheet2.cells(last+1,21).value = "東証2部"
  elsif  management==3
    sheet2.cells(last+1,21).value = "ジャスダック"
  elsif  management==4
      sheet2.cells(last+1,21).value = "マザーズ"
  elsif  management==5
        sheet2.cells(last+1,21).value = "その他"
  end

  book2.save
  book.save#保存
  #bookを閉じる　book.close
#   excel.quit()#Excelを閉じる


last2 = last2 - 1
print(last2)
end


 #ensure
 #end