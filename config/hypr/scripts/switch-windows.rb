#!/usr/bin/env ruby

require 'json'

windows = JSON.parse(`hyprctl -j clients`)

output = windows.reverse.map do |window|
  [window['title'], window['class'], window['pid']].select { _1 != '' }.join(' - ')
end.join("\n")

result = `echo "#{output}" | fuzzel --match-mode=exact --dmenu`

pid = result.split(' ').last
puts pid
`hyprctl dispatch focuswindow pid:#{pid}`
`hyprctl dispatch alterzorder top,pid:#{pid}`
