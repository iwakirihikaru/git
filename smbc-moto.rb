require "selenium-webdriver"
require 'rubygems'
#時間指定をわすれないように

require 'time'

def timer(arg, &proc)
  x = case arg
  when Numeric then arg
  when Time    then arg - Time.now
  when String  then Time.parse(arg) - Time.now
  else raise   end

  sleep x if block_given?
  yield
end


timer(Time.parse("22:12")) do
#時間指定


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mount=100
  number=3316
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

    sleep 3

# この後に処理を書けばその要素が現れてからその処理を行ってくれるalt="検索" border="0">
end