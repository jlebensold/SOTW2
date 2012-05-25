set :server, :thin
set :port, 80
set :host, '10.126.35.29'
set :public_folder, File.dirname(__FILE__) + '/public'


get '/text/*.txt' do  | file |
  path = File.dirname(__FILE__) +"/text/#{file}.txt"
  IO.readlines(path)
end
get '/search.json/:volume/:query' do
  content_type 'application/json'
  results = []
  query = params[:query].to_s
  Dir.glob(File.dirname(__FILE__) + "/public/#{params[:volume]}/text/*.txt").each_with_index { |f,i| 
    str = IO.readlines(f).to_s
    page =  /[0-9].+/.match(f).to_s.split("_").last().split(".").first()
    words = str.gsub(".","").gsub("!","").gsub("?","").gsub(",","").downcase.split(" ")
    if (words.include? query.downcase)
    #if(/#{query}/i.match(str))
      results << page.to_i
    end
  }
  "{\"results\" : #{results},\"query\": \"#{query}\"}"
end

get '/cfg.json' do
  content_type 'application/x-javascript'
  erb :config
end
get '/' do
  erb :index 
end

