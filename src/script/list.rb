#!/usr/bin/ruby

def list(page, items)
  html = "<div class=\"list\">"
  fade_n = 2

  items.each_with_index {|item, item_i|
    # klass = item_i+1 > 3 ? " more" : ""
    fade_id = ""
    if item_i+1 < 3
      fade_id = " data-fade-id=\"#{fade_n}\""
      fade_n += 1
    end


    html +=
      "<div class=\"list-category\"#{fade_id} data-category=\"#{item[:slug]}\">" +
        "<h2><span>#{item[:caption]}</span></h2>" +
        sublist(page, item[:entities]) +
      "</div>"
  }

  # html += items.length > 3 ? "<div id=\"viewMore\" class=\"view-more\">View More</div>" : "<div class=\"space\"></div>"
  html += "</div>"
end

def sublist(page, items)
  html = "<ul>"

  items.each {|item|
    html +=
      "<li><a href=\"#{item[:url]}\" title=\"#{item[:name]} - #{item[:description]}\" target=\"_blank\">" +
        "<img src=\"assets/images/#{page}/#{item[:logo]}\" alt=\"#{item[:name]} - #{item[:description]}\" />" +
        "</a></li>"
  }
  html += "</ul>"

end
