#!/usr/bin/ruby

def list(items)
  html = "<ul>"
  items.each {|item|
    html += "<li>#{item[:name]}</li>"
  }
  html += "</ul>"
end
