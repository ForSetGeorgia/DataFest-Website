#!/usr/bin/ruby

def grid(page, items)
  items = items + items + [items[0], items[1], items[2]]
  html = "<div class=\"grid\">"
  fade_n = 2
  items.each_with_index {|item, item_i|
    klass = item_i+1 > 6 ? " more" : ""
    fade_id = ""
    if item_i+1 < 6 && item_i % 3 == 0
      fade_id = " data-fade-id=\"#{fade_n}\""
      fade_n += 1
    end
    html +=
      (item_i % 3 == 0 ? "<div class=\"row#{klass}\"#{fade_id}>" : "") +
      "<div class=\"card\">" +
        "<div class=\"info\">" +
          "<div class='photo'><img src='assets/images/#{page}/#{item[:photo]}'/></div>" +
          "<div class='name'>#{item[:name]}</div>" +
          "<div class='position'>#{item[:position]}</div>" +
            socials(page, item) +
        "</div>" +
        "<div class='summary fadeIn animated'>#{item[:summary]}</div>" +
      "</div>" +
      (item_i % 3 == 2 ? "</div>" : "")
  }
  html += "</div>"

  if items.length >= 6
    html += "<div id=\"viewMore\" class=\"view-more\">View More</div>"
  end
end

def socials(page, item)
  html = ""
  [:facebook, :twitter, :instagram, :linkedin].each {|social|
    if item.key?(social)
      html += "<a href=\"#{item[social]}\" target=\"_blank\"><i class=\"#{social}\"></i></a>"
    end
  }
  html != "" ? "<div class=\"grid-social social-#{page}\">#{html}</div>" : ""
end
