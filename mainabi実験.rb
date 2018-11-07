require 'win32ole' #contl+F11で実行
require "json"
require 'rubygems'
require "selenium-webdriver"
#begin # do_something
module Excel; end


excel = WIN32OLE.new('Excel.Application')
excel.visible = true #Excelの表示／非表示設定
excel.displayAlerts = true #アラートメッセージを表示／非表示設定
WIN32OLE.const_load(excel, Excel)
wait = Selenium::WebDriver::Wait.new(:timeout => 120)

book = excel.Workbooks.Open('C:\Users\光\Desktop\マクロ付株式検証.xlsm')#Excelブックを開く
date = 1
sheet = book.worksheets(3)#Excelの1番のシートを取得
#blank = sheet.Rows.count #列の最終行数習得⇒OK
wd = Selenium::WebDriver.for :chrome
while date != 0 do
last = sheet.cells(1,18).End(Excel::XlDown).row #.cells...行・列を数字で指定する。(英語｛横｝が後)　.row..行番号を表す整数を返すプロパティ .end...contlキーかな？
name = sheet.cells(last+1,1).value#価格ペースト A列
date = sheet.cells(last+1,18).value
puts name
#for num in 1..100 do


wd.get "https://info.finance.yahoo.co.jp/search/?query"

wd.find_element(:id, "searchText").send_keys name
wd.find_element(:id, "searchButton").click
wd.find_element(:xpath, "//div[@id='sr']/div/ul/li/h2/a/span").click

sleep 8
tell =wd.find_element(:xpath,"//*[@id='deal']/div/span").text
puts tell
sheet.cells(last+1,18).value = tell#価格ペースト A列
end

#wd.find_element(:id, "corpNameLink[#{num}]").click
#wd.switch_to.window(wd.window_handles.last) #操作ウィンドウの変更
#
#name = wd.find_element(:xpath, "//div[@id='companyHead']/div/h1").text
#url = wd.current_url
#tell =wd.find_element(:xpath, "//form[@id='displayOutlineForm']/div[2]/div[8]/div/table/tbody/tr/td").text
#
#begin
#mail=wd.find_element(:xpath,"//br[contains(text(), '@')]") .text#E-mailを検索
#
# # 例外が起こるかも知れないコード
##mail=wd.find_elements(:xpath,"//*[contains(text(), '19saiyou@biccamera.com')]") #E-mailを検索
#
#rescue => error # 変数(例外オブジェクトの代入)
##   例外が発生した時のコード
#  begin
#    mail=wd.find_elements(:xpath,"//br[contains(text(), '@')]") .text#E-mailを検索
#    rescue => error
#    puts name+"アドレスなし"
#    mail = "なし"
#  end
#
#end
##print(name)
##print(url)
##print(tell)
#print(mail)
#
#
#
#sheet = book.worksheets(1)#Excelの1番のシートを取得
#blank = sheet.Rows.count #列の最終行数習得⇒OK
#last = sheet.cells(blank,1).End(Excel::XlUp).row #.cells...行・列を数字で指定する。(英語｛横｝が後)　.row..行番号を表す整数を返すプロパティ .end...contlキーかな？
#
#sheet.cells(last+1,1).value = name#価格ペースト A列
#sheet.cells(last+1,2).value =tell #B
#sheet.cells(last+1,3).value =url
#sheet.cells(last+1,4).value =mail
#num+=1
#
#if num == 100
#  wd.find_element(:id, "upperNextPage").click
#  next_url = wd.current_url #次の移動先保存
#
#end