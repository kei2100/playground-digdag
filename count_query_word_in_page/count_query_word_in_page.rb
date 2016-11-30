require 'bundler/setup'
require 'nokogiri'
require 'json'

def count_query_word_in_page
  doc = Nokogiri::HTML.parse(page_obj[:page_source])
  body = doc.css('body')

  texts = extract_texts(body.children)
  query_word_appearance_num = texts.reduce(0) {|sum, text| text.upcase.match(/#{query.upcase}/) ? sum + 1 : sum }

  results_dir = "./tmp/results/#{query}"
  results_path = "#{results_dir}/#{Pathname.new(page_path).basename.to_s}"

  FileUtils.mkdir_p(results_dir)
  File.write(results_path, {
    title: doc.css('title').text,
    url: page_obj[:url],
    query_word_appearance_num: query_word_appearance_num
  }.to_json)
end

def page_obj
  @page_obj ||=
    JSON.parse(File.read(page_path), symbolize_names: true)
end

def page_path
  Digdag.env.params['page_path']
end

def query
  Digdag.env.params['query']
end

def extract_texts(nodes)
  text_tree = nodes.map do |node|
    if node.class == ::Nokogiri::XML::Text
      node.text
    else
      extract_texts(node.children)
    end
  end

  text_tree.flatten
end
