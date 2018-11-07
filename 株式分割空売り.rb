require "selenium-webdriver"
require 'rubygems'
#時間指定をわすれないように

require 'time'

def timer(arg, &proc)
  x = case arg
  when Numeric then arg
  when Time    then arg - Time.now
  when String  then Time.parse(arg) - Time.now
  else raise
  end

  sleep x if block_given?
  yield
end

timer(Time.parse("10:10")) do

#時間指定





  #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  wait = Selenium::WebDriver::Wait.new(:timeout => 100)
  wd = Selenium::WebDriver.for :chrome # ブラウザ起動
  wd.get "https://trade.smbcnikko.co.jp/Logout/95C2K0006681/login/ipan_logout/exec"
  element = wd.find_element(:class, "btn-gray-login").click
  element = wd.find_element(:name, "koza1")
  element.send_keys('255')
  element = wd.find_element(:name, "koza2")
  element.send_keys("568112")
  element = wd.find_element(:name, "passwd")
  element.send_keys("KGS777")

  element = wd.find_element(:class, "inputBtn").click
  element = wd.find_element(:name,"meigNm")
  #---------------------------------------------------------------------------------------------------------------------------
  wd.find_element(:name, "menu03").click #「お取引ボタン」
  wd.find_element(:link, "建玉一覧（返済・現引・現渡）").click
  line=wait.until{wd.find_element(:xpath, "//div[@id='printzone']/div[2]/table/tbody/tr/td/table/tbody/tr/td/div/form/div[2]/table[2]/tbody")}.find_elements(:tag_name,"tr").size()
  num=0
  #xpath そのままコピーしても行数確認は使えた。
  #---------------------------------------------------------------------------------------------------------------------------
  while num<line-1 #2
    wd.find_element(:name, "menu03").click #「お取引ボタン」
    wd.find_element(:link, "建玉一覧（返済・現引・現渡）").click
    wd.find_element(:link, "返済").click
    repayment_quantity= wd.find_element(:xpath,"//*[@id='printzone']/div[2]/table/tbody/tr/td/form/div[1]/table/tbody/tr/td/table/tbody/tr[2]/td[4]/span/b").text #返済数量の取得
    wd.find_element(:name, "suryo").send_keys "#{repayment_quantity}"
    wd.find_element(:id, "j").click
    wd.find_element(:id, "tojit").click
    wd.find_element(:name, "autotukeUrl").click
    wd.find_element(:css, "td > div > input[type=\"image\"]").click  #以上で返済終了
    num=num+1
  end
  

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

mount=100
number=8104


wait = Selenium::WebDriver::Wait.new(:timeout => 100)
wd = Selenium::WebDriver.for :chrome # ブラウザ起動
wd.get "https://trade.smbcnikko.co.jp/Logout/95C2K0006681/login/ipan_logout/exec"
element = wd.find_element(:class, "btn-gray-login").click

element = wd.find_element(:name, "koza1")
element.send_keys('255')
element = wd.find_element(:name, "koza2")
element.send_keys("568112")
element = wd.find_element(:name, "passwd")
element.send_keys("KGS777")
element = wd.find_element(:class, "inputBtn").click
element = wd.find_element(:name,"meigNm")
element.send_keys("#{number}")
#☝変数で銘柄名を指定することができればいいのかな
element = wd.find_element(:xpath,"/html/body/div[1]/table/tbody/tr/td[2]/form/table/tbody/tr/td[4]/input").click
#☝株価のコピー
    wd.find_element(:xpath, "(//img[@alt='信用取引'])[2]").click
    wd.find_element(:link, "信用新規買い").click
    wd.find_element(:id, "seido").click
element=wd.find_element(:xpath, "//*[@id='isuryo']/table/tbody/tr[1]/td[1]/input")
element.send_keys("#{mount}")
    wd.find_element(:id, "j").click
    wd.find_element(:xpath, "//td[@id='ikikan']/table/tbody/tr/td[2]/label/span").click
    wd.find_element(:id, "execUrl").click
    wd.find_element(:xpath, "(//input[@type='image'])[3]").click
sleep 3

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#mount=100
#number=1739
#
#
#wait = Selenium::WebDriver::Wait.new(:timeout => 100)
#wd = Selenium::WebDriver.for :chrome # ブラウザ起動
#wd.get "https://trade.smbcnikko.co.jp/Logout/95C2K0006681/login/ipan_logout/exec"
#element = wd.find_element(:class, "btn-gray-login").click
#
#element = wd.find_element(:name, "koza1")
#element.send_keys('255')
#element = wd.find_element(:name, "koza2")
#element.send_keys("568112")
#element = wd.find_element(:name, "passwd")
#element.send_keys("KGS777")
#element = wd.find_element(:class, "inputBtn").click
#element = wd.find_element(:name,"meigNm")
#element.send_keys("#{number}")
##☝変数で銘柄名を指定することができればいいのかな
#element = wd.find_element(:xpath,"/html/body/div[1]/table/tbody/tr/td[2]/form/table/tbody/tr/td[4]/input").click
##☝株価のコピー
#    wd.find_element(:xpath, "(//img[@alt='信用取引'])[2]").click
#    wd.find_element(:link, "信用新規買い").click
#    wd.find_element(:id, "seido").click
#element=wd.find_element(:xpath, "//*[@id='isuryo']/table/tbody/tr[1]/td[1]/input")
#element.send_keys("#{mount}")
#    wd.find_element(:id, "j").click
#    wd.find_element(:xpath, "//td[@id='ikikan']/table/tbody/tr/td[2]/label/span").click
#    wd.find_element(:id, "execUrl").click
#    wd.find_element(:xpath, "(//input[@type='image'])[3]").click
#sleep 3

#mount=100
#number=4565
#
#
#wait = Selenium::WebDriver::Wait.new(:timeout => 100)
#wd = Selenium::WebDriver.for :chrome # ブラウザ起動
#wd.get "https://trade.smbcnikko.co.jp/Logout/95C2K0006681/login/ipan_logout/exec"
#element = wd.find_element(:class, "btn-gray-login").click
#
#element = wd.find_element(:name, "koza1")
#element.send_keys('255')
#element = wd.find_element(:name, "koza2")
#element.send_keys("568112")
#element = wd.find_element(:name, "passwd")
#element.send_keys("KGS777")
#element = wd.find_element(:class, "inputBtn").click
#element = wd.find_element(:name,"meigNm")
#element.send_keys("#{number}")
##☝変数で銘柄名を指定することができればいいのかな
#element = wd.find_element(:xpath,"/html/body/div[1]/table/tbody/tr/td[2]/form/table/tbody/tr/td[4]/input").click
##☝株価のコピー
#    wd.find_element(:xpath, "(//img[@alt='信用取引'])[2]").click
#    wd.find_element(:link, "信用新規買い").click
#    wd.find_element(:id, "seido").click
#element=wd.find_element(:xpath, "//*[@id='isuryo']/table/tbody/tr[1]/td[1]/input")
#element.send_keys("#{mount}")
#    wd.find_element(:id, "j").click
#    wd.find_element(:xpath, "//td[@id='ikikan']/table/tbody/tr/td[2]/label/span").click
#    wd.find_element(:id, "execUrl").click
#    wd.find_element(:xpath, "(//input[@type='image'])[3]").click
#sleep 3
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# =bigin～=end で複数行のコメントアウト
=begin
mount=100
number=6565


wait = Selenium::WebDriver::Wait.new(:timeout => 100)
wd = Selenium::WebDriver.for :chrome # ブラウザ起動
wd.get "https://trade.smbcnikko.co.jp/Logout/95C2K0006681/login/ipan_logout/exec"
element = wd.find_element(:class, "btn-gray-login").click

element = wd.find_element(:name, "koza1")
element.send_keys('255')
element = wd.find_element(:name, "koza2")
element.send_keys("568112")
element = wd.find_element(:name, "passwd")
element.send_keys("KGS777")
element = wd.find_element(:class, "inputBtn").click
element = wd.find_element(:name,"meigNm")
element.send_keys("#{number}")
#☝変数で銘柄名を指定することができればいいのかな
element = wd.find_element(:xpath,"/html/body/div[1]/table/tbody/tr/td[2]/form/table/tbody/tr/td[4]/input").click
#☝株価のコピー
    wd.find_element(:xpath, "(//img[@alt='信用取引'])[2]").click
    wd.find_element(:link, "信用新規買い").click
    wd.find_element(:id, "seido").click
element=wd.find_element(:xpath, "//*[@id='isuryo']/table/tbody/tr[1]/td[1]/input")
element.send_keys("#{mount}")
    wd.find_element(:id, "j").click
    wd.find_element(:xpath, "//td[@id='ikikan']/table/tbody/tr/td[2]/label/span").click
    wd.find_element(:id, "execUrl").click
    wd.find_element(:xpath, "(//input[@type='image'])[3]").click
sleep 3
=end
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end

