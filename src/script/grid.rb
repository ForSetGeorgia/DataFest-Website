#!/usr/bin/ruby

def grid(page, items)
  items = items
  html = "<div class=\"grid\" data-fade-id=\"2\">"
  fade_n = 2
  with_end = false
  items.each_with_index {|item, item_i|
    with_end = false
    # klass = item_i+1 > 6 ? " more" : ""
    fade_id = ""
    if item_i+1 < 6 && item_i % 3 == 0
      fade_id = " data-fade-id=\"#{fade_n}\""
      fade_n += 1
    end
    html +=
      # (item_i % 3 == 0 ? "<div class=\"row\"#{fade_id}>" : "") +
      "<div class=\"card\">" +
        "<div class=\"info\">" +
          "<div class='photo'><img src='assets/images/#{page}/#{item[:photo]}'/></div>" +
          "<div class='name'>#{item[:name]}</div>" +
            country(item) +
          "<div class='position'>#{item[:position]}</div>" +
            organization(item) +
            socials(page, item) +
            talk_icons(item) +
        "</div>" +
        summary(item) +
      "</div>"
    # if item_i % 3 == 2
    #   html += "</div>"
    #   with_end = true
    # end
  }
  # html += "</div>" if !with_end

  # html += items.length > 6 ? "<div id=\"viewMore\" class=\"view-more\">View More</div>" : "<div class=\"space\"></div>"

  html += "</div>"
end

def country(item)
  html = ""
  key = :country
  if item.key?(key) && !item[key].empty?
    html += "#{item[key]}"
  end
  html != "" ? "<div class=\"country\">#{html}</div>" : ""
end

def organization(item)
  html = ""
  key = :organization
  if item.key?(key) && !item[key].empty?
    html += "#{item[key]}"
  end
  html != "" ? "<div class=\"organization\">#{html}</div>" : ""
end

def socials(page, item)
  html = ""
  [:facebook, :twitter, :instagram, :linkedin].each {|key|
    if item.key?(key) && !item[key].empty?
      html += "<a href=\"#{item[key]}\" target=\"_blank\"><i class=\"#{key}\"></i></a>"
    end
  }
  # html != "" ? "<div class=\"grid-social social-#{page}\">#{html}</div>" : ""
  html = "<a><i class=\"filler\"></i></a>" if html.empty?
  "<div class=\"grid-social social-#{page}\">#{html}</div>"
end

def talk_icons(item)
  html = ""
  [:talk, :workshop].each {|key|
    if item.key?(key) && !item[key].empty? && item[key] == "TRUE"
      html += "<img src=\"assets/images/#{key}.svg\" class=\"#{key}\" title=\"#{key}\"/>"
    end
  }
  html != "" ? "<div class=\"talk-icons\">#{html}</div>" : ""
end

def summary(item)
  html = ""
  key = :summary
  if item.key?(key) && !item[key].empty?
    html += "#{item[key]}"
  end
  close = "<div class=\"close\"><img src=\"assets/images/close.svg\" title=\"Close\"/></div>"
  html != "" ? "<div class=\"summary fadeIn animated\"><div class=\"text\">#{html}</div>#{close}</div>" : ""
end
