#!/usr/bin/ruby


def timetable(page, items)
  current_day = 1
  html = ""

  items.each_with_index {|item, item_i|
    day_ind = item_i+1
    klass = (current_day == day_ind ? 'active' : '')
    html +=
      "<li class=\"timetable-day-content #{klass}\" data-day=\"#{day_ind}\">" +
        day(day_ind, item) +
      "</li>"
  }
  html
end

def day(day_ind, item)
  html = before(item[:before])
  html += day_ind == 1 ? day_one(item[:timetable]) : day_rest(item[:timetable])
  html += after(item[:after])

  html
end

def before(items)
  html = "<ul class=\"timetable-day-before\">"

  items.each_with_index {|item, item_i|
    highlight_class = item.key?(:highlight) && item[:highlight] ? "class=\"highlight\"" : ""
    html += "<li #{highlight_class}>#{item[:time]}&nbsp;&nbsp;-&nbsp;&nbsp;<b>#{item[:title]}</b></li>"
  }
  html += "</ul>"
end

def after(items)
  html = "<ul class=\"timetable-day-after\">"
  items.each_with_index {|item, item_i|
    highlight_class = item.key?(:highlight) && item[:highlight] ? "class=\"highlight\"" : ""
    html += "<li #{highlight_class}>#{item[:time]}&nbsp;&nbsp;-&nbsp;&nbsp;<b>#{item[:title]}</b></li>"
  }
  html += "</ul>"
end

def day_one(items)
  titles = items[:title]
  data = items[:data]

  html = "<ul class=\"timetable-day-plan first\"><li class=\"header\">"

  titles.each_with_index {|e, e_i|
    html += "<div class=\"#{e_i == 0 ? 'time' : 'title fit'}\"><p>#{e}</p></div>"
  }
  html += "</li>"


  data.each {|d|

    if d.key?(:break) && d[:break]
      html += (
          "<li>" +
            "<div class=\"row highlight\">" +
              "<div class=\"time\"><p>#{d[:time]}</p></div>" +
              "<div class=\"break\"><p>#{d[:title]}</p></div>" +
            "</div>" +
          "</li>"
        )
    else
      has_description = d.key?(:description) && d[:description] != ""
      has_highlight = d.key?(:highlight) && d[:highlight]
      html += (
        "<li>" +
          "<div class=\"row#{has_highlight ? ' highlight' : ''}\">" +
            "<div class=\"time\"><p>#{d[:time]}</p></div>" +
            "<div class=\"author\"><p>#{d[:author]}</p></div>" +
            "<div class=\"title#{has_description ? ' has_descr' : ''}\"><p>#{d[:title]}</p></div>" +
          "</div>" +
          (has_description ? "<div class=\"description\">#{d[:description]}</div>" : "") +
        "</li>"
      )
    end

  }

  html += "</ul>"
end

def day_rest(items)
  titles = items[:title]
  data = items[:data]

  html = "<ul class=\"timetable-day-plan rest\"><li class=\"header\">"

  titles.each_with_index {|e, e_i|
    html += "<div class=\"#{e_i == 0 ? 'time' : 'title'}\"><p>#{e}</p></div>"
  }
  html += "</li>"


  data.each {|d|

    if d.key?(:break) && d[:break]
      html += (
          "<li>" +
            "<div class=\"row highlight\">" +
              "<div class=\"time\"><p>#{d[:time]}</p></div>" +
              "<div class=\"break\"><p>#{d[:title]}</p></div>" +
            "</div>" +
          "</li>"
        )
    else
      title_html = ""
      descr_html = ""

      d[:items].each_with_index.map {|item, item_i|
        ind = item_i+1
        has_description = item.key?(:description) && item[:description] != ""

        title_html += "<div class=\"title#{has_description ? ' has_descr' : ''}\" #{has_description ? "data-room=\"#{ind}\"" : ''}><p>#{item[:title]}</p></div>"
        descr_html += has_description ? "<div class=\"description\" data-room=\"#{ind}\">#{item[:description]}</div>" : ''
      }
      html += (
        "<li>" +
          "<div class=\"row\">" +
            "<div class=\"time\"><p>#{d[:time]}</p></div>" +
            title_html +
          "</div>" +
          "<div class=\"descriptions\">" +
            descr_html +
          "</div>" +
        "</li>"
      )
    end


  }

  html += "</ul>"
end
# def sublist(page, items)
#   html = "<ul>"

#   items.each {|item|
#     html +=
#       "<li><a href=\"#{item[:url]}\" title=\"#{item[:name]}\" target=\"_blank\">" +
#         "<img src=\"assets/images/#{page}/#{item[:logo]}\" alt=\"#{item[:name]}\" />" +
#         "</a></li>"
#   }
#   html += "</ul>"

# end
