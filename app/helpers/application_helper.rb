module ApplicationHelper
  
  #カスタムヘルパー　page_name ="" で指定文字をビューに入力することで反映できるようになる。
  def full_title(page_name ="")
    base_title = "AttendanceApp"
    if page_name.empty?
      base_title
    else
      page_name + "|" + base_title
    end
  end
end
