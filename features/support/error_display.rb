class ErrorDisplay
  include PageObject

  page_url "file://#{File.dirname(__FILE__)}/../../results/basic.html"

  element(:error, :tr, :class => 'error')

  def error_background
    error_element.style('background-color')
  end

  def error_text_color
    error_element.style('color')
  end
  
end
