
color_code = {
  ["메인화면"] = {{x = 544, y = 1006, color = 13668970}, {x = 440, y = 80, color = 14594953}},
  ["서버선택"] = {{x = 420, y = 390, color = 1118481}},
  ["메일등록/로그인"] = {{x = 312, y = 644, color = 1009577}},
  ["메일등록/노로그인"] = {{x = 308, y = 518, color = 16777215}},
  ["로그인/완료"] = {{x = 312, y = 644, color = 1009577}},
  ["출첵"] = {{x = 138, y = 852, color = 2973324}},
  ["공지"] = {{x = 108, y = 866, color = 3705129}},
  ["주성"] = {{x = 94, y = 1080, color = 16773152}},
  ["기능"] = {{x = 302, y = 726, color = 3642438}},
  -- TODO: check 기능/군단전 - how state is 12?
  ["강화"] = {{x = 350, y = 826, color = 6105858}},
  ["강화/가능"] = {{x = 376, y = 814, color = 15518777}},
  ["강화/풀강"] = {{x = 380, y = 659, color = 3450947}},
  ["강화/완료"] = {{x = 476, y = 882, color = 11045167}},
  ["태학원"] = {{x = 126, y = 594, color = 10718284}},
}

button_list = {
  ["메인/서버선택"] = {x = 582, y = 164},
  -- TODO: 서버 별 버튼 (touchServer)
  ["서버선택/메일등록"] = {x = 508, y = 744},
  ["메일등록/로그아웃"] = {x = 312, y = 644},
  ["로그인/id"] = {x = 308, y = 518},
  ["로그인/enter"] = {x = 40, y = 990},
  ["로그인/pw"] = {x = 250, y = 510},
  ["로그인/로그인"] = {x = 112, y = 606},
  ["로그인완료/서버선택"] = {x = 504, y = 372},
  ["주성/임무"] = {x = 440, y = 55},
  ["주성/기능"] = {x = 94, y = 1080},
  ["주성/후궁"] = {x = 327, y = 1132},
  ["주성/태학원"] = {x = 94, y = 1080},
  ["주성/출정"] = {x = 85, y = 668},
  ["기능/강화"] = {x = 302, y = 726},
  ["기능/군단전"] = {x = 431, y = 876},
  -- TODO: 강화 touchTag
  ["강화/다음"] = {x = 158, y = 1000},
  -- TODO: 강화 touchItem
  ["강화/강화"] = {x = 376, y = 814},
  ["태학원/태학"] = {x = 126, y = 594},
  -- TODO: 태학강당 클릭 후 닫기 state == 10
  -- TODO: 후궁 지낭 클릭 후 닫기
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
