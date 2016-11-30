require 'bundler/setup'
require 'selenium-webdriver'
require 'json'

def get_pages
  driver = Selenium::WebDriver.for(:chrome)
  driver.manage.timeouts.implicit_wait = 0.3

  begin
    navigate_and_wait(driver, "https://www.google.co.jp/#q=#{query}")

    search_results = driver.find_elements(css: 'div[class="srg"] h3[class="r"] a:first-child')
    top_3_page_urls = search_results.take(3).map {|link| link.attribute('href') }

    page_paths =
      top_3_page_urls.map.with_index do |url, index|
        navigate_and_wait(driver, url)
        save_page("#{index}.json", url, driver.page_source)
      end

    store_page_paths(page_paths)
  ensure
    driver.quit
  end
end

def query
  Digdag.env.params['query']
end

def navigate_and_wait(driver, url)
  driver.navigate.to(url)
  sleep 1
  Timeout.timeout(10) do
    loop do
      begin
        driver.find_element(tag_name: 'html')
      rescue
        sleep 0.3
        next
      end
      break
    end
  end
end

def save_page(page_name, url, page_source)
  dir = "./tmp/got_tmp/pages/#{query}"
  page_path = "#{dir}/#{page_name}"

  FileUtils.mkdir_p(dir)
  File.write(page_path, {url: url, page_source: page_source}.to_json)

  page_path
end

def store_page_paths(paths)
  Digdag.env.store(page_paths: paths)
end
