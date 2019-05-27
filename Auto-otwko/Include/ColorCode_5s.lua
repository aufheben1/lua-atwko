
color_code = {
  ["메인화면"] = {{x = 544, y = 1006, color = 13668970}, {x = 440, y = 80, color = 14594953}},
  ["출첵"] = {{x = 138, y = 852, color = 2973324}},
  ["공지"] = {{x = 108, y = 866, color = 3705129}}
}

-- For test
function checkScreen(name)
  log(name .. ": ")
  for key, item in pairs(color_code[name]) do
    log("         " .. tostring(item.x) .. " " .. tostring(item.y) .. ": " .. tostring(item.color) .. " vs " .. tostring(getColor(item.x, item.y)))
		if getColor(item.x, item.y) ~= item.color then
			return false
		end
	end
	return true
end

if checkScreen("공지") then
  alert("T")
else
  alert("F")
end