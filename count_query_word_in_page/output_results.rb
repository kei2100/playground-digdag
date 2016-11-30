require 'bundler/setup'
require 'json'

def output_results
  queries.each do |query|
    puts "「#{query}」の出現回数\n"
    results = Dir.glob("./tmp/results/#{query}/*.json").map {|path| JSON.parse(File.read(path), symbolize_names: true)}
    results.each do |result|
      puts "ページタイトル: #{result[:title]}"
      puts "URL: #{result[:url]}"
      puts "出現回数 #{result[:query_word_appearance_num]}"
      puts "\n"
    end
    puts '-----'
  end
end

def queries
  Digdag.env.params['queries']
end
