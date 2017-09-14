#!/usr/bin/ruby

# class String
#   def remove_lines(i)
#     split("\n")[i..-1].join("\n")
#   end
# end

require 'rubygems'
require 'fileutils'
require 'json'
# require 'pp'
# require 'erb'
# require 'unidecoder'

def init
  html = File.read('application.html')

  layout = ['head', 'scene', 'nav', 'content_footer', 'footer']

  layout.each {|l|
    tmp = File.read("layout/#{l}.html")

    html = html.gsub("__#{l}__", tmp)

  }

  pages = [
    { slug: 'about', title: '', description: 'About Description' },
    { slug: 'agenda', title: 'Agenda', description: 'Agenda Description' },
    { slug: 'speakers', title: 'Speakers', description: 'Speakers Description' },
    { slug: 'partners', title: 'Partners', description: 'Partners Description' },
    { slug: 'team', title: 'Team', description: 'Team Description' }
  ]

  description = 'DataFest Tbilisi is the first annual international data event in South Caucasus supporting cross-sector and cross-border cooperation, strengthening communities and inspiring individuals to pursue and explore opportunities created by data and technology.'

  page_titles = ['', 'Agenda', '', '', 'Team']
  pages.each {|page|
    File.open("../public/#{page}.html", "w") { |file|
      file.write(
        html
          .gsub('__title__', " #{page[:title]}")
          .gsub('__description__', " #{page[:description]}")
          .gsub("data-ruby-nav=\"#{page[:slug]}\"", " class=\"active\"")
          .gsub(/data\-ruby\-nav\=\".*\"/, "")
          .gsub('__content__', File.read("page/#{page[:slug]}.html")))
    }
    File.open("../public/partial/#{page[:slug]}.json", "w") { |file|
      file.write("{\"title\":\"#{page[:title]}\", \"description\":\"#{page[:description]}\", \"html\":" + File.read("page/#{page[:slug]}.html").to_json + "}")
    }
  }
  # locales = ["en", "ka", "ru"]
  # story_count = 10 # WARNING this should be changed to actual story count
  # key_mapper = key_map
  # story_titles = []

  # locales.each_with_index{|loc, loc_i|
  #   # next if loc != "en" # comment on production
  #   @locale = loc
  #   begin
  #     json = JSON.parse(File.read("../assets/locale/#{loc}.js", :quirks_mode => true).remove_lines(1)[0...-1])
  #   rescue JSON::ParserError => e
  #     pp "#{loc} file is damaged"
  #   end

  #   fld = "../#{loc}/share"
  #   FileUtils.remove_dir fld if File.directory?(fld)
  #   FileUtils.mkdir_p fld

  #   url = json["domain"]
  #   url_with_locale_orig = url + "/" + loc

  #   share_dir_url = url_with_locale_orig + "/" + json["share_path"]

  #   url_with_locale_orig += "/?story=" # add / to match url rules

  #   @sitename = json["sitename"]

  #   renderer = ERB.new(share_template)

  #   for story_index in 1..story_count
  #     story_data = json["stories"]["s" + story_index.to_s]
  #     id = story_data["title"].to_ascii(key_mapper).downcase.gsub(" ", "-")
  #     if loc == "en"
  #       story_titles.push([id,id,id]);
  #     else
  #       story_titles[story_index-1][loc_i] = id
  #     end
  #     @title = story_data["title"]
  #     @descr = story_data["quote"].gsub('\\', "").gsub('"', "")
  #     @share_url = share_dir_url + "/" + id + ".html"
  #     # if each story wlll have it's own file use this @image = url + "/assets/images/share/#{story_index}.jpg"
  #     @image = url + "/assets/images/share/#{loc}.jpg?v=1478327947603"

  #     @url_with_locale = url_with_locale_orig + id

  #     File.open("../#{loc}/share/#{id}.html", "w") { |file| file.write(renderer.result()) }

  #   end
  #   File.open("../assets/js/meta.js", "w") { |file| file.write("var js = { story_titles: " + story_titles.to_s + "};") }
  # }
end

init
