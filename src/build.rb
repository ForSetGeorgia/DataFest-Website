#!/usr/bin/ruby

# class String
#   def remove_lines(i)
#     split("\n")[i..-1].join("\n")
#   end
# end

require 'rubygems'
require 'fileutils'
require 'json'
require './script/grid.rb'
require './script/list.rb'
# require 'pp'
# require 'erb'
# require 'unidecoder'


def init

  html = File.read('layout/application.html') # main layout file

  layout_partials = ['head', 'scene', 'nav', 'content_footer', 'footer'] # list of layout partials to embed into main layout

  layout_partials.each {|l|
    tmp = File.read("layout/#{l}.html").chomp('')
    html = html.gsub("__#{l}__", tmp)
  }

  description = 'DataFest Tbilisi is the first annual international data event in South Caucasus supporting cross-sector and cross-border cooperation, strengthening communities and inspiring individuals to pursue and explore opportunities created by data and technology.'

  pages = ['home', 'agenda', 'speakers', 'partners', 'team'] # pages that require generation
  pages_with_grid = ['speakers', 'team'] # pages that have grid
  pages_with_list = ['partners'] # pages that have list

  # for each generated page two files are generated one with full html for page first load
  # and second is json partial which will be xhr-ed by browser and inserted on request
  pages.each {|page_slug|

    page = JSON.parse(File.read("./data/#{page_slug}.json"), :symbolize_names => true) # preload page data

    content = File.read("page/#{page[:slug]}.html").chomp('')


    # if page require grid
    content.gsub!("__#{page_slug}__", grid(page_slug, page[:items])) if pages_with_grid.include?(page_slug)
    # if page require list

    content.gsub!("__#{page_slug}__", list(page_slug, page[:items])) if pages_with_list.include?(page_slug)

    page_html = html
        .gsub('__title__', " #{page[:title]}")
        .gsub('__description__', " #{page[:description]}")
        .gsub('__data-page__', " data-page=\"#{page[:slug]}\"")
        .gsub("data-ruby-nav=\"#{page[:slug]}\"", " class=\"active\"")
        .gsub(/data\-ruby\-nav\=\".*\"/, "")
        .gsub('__content__', content)

    # create full page
    File.open("../public/#{page[:slug]}.html", "w") { |file|
      file.write(page_html)
    }

    # create partial json page
    File.open("../public/partial/#{page[:slug]}.json", "w") { |file|
      file.write("{\"title\":\"#{page[:title]} | DataFest Tbilisi\", \"description\":\"#{page[:description]}\", \"html\":" + content.to_json + "}")
    }
  }
end

init
