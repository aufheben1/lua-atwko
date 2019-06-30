
color_code = {
  ["메인화면"] = {{x = 646, y = 1002, color = 11831174}, {x = 435, y = 94, color = 15114326}},
  ["서버선택"] = {{x = 436, y = 884, color = 11140926}},
  ["메일등록/로그인"] = {{x = 368, y = 739, color = 2262703}},
  ["메일등록/노로그인"] = {{x = 154, y = 739, color = 1271719}},
  ["로그인/완료"] = {{x = 368, y = 739, color = 2262703}},
  -- ["출첵"] = {{x = 138, y = 852, color = 2973324}},
  -- ["공지"] = {{x = 108, y = 866, color = 3705129}},
  -- ["주성"] = {{x = 94, y = 1080, color = 16773152}},
  -- ["기능"] = {{x = 302, y = 726, color = 3642438}}
}

button_list = {
  ["메인/서버선택"] = {x = 732, y = 177},
  -- -- TODO: 서버 별 버튼 (touchServer)
  ["서버선택/메일등록"] = {x = 597, y = 1008},
  ["메일등록/로그아웃"] = {x = 368, y = 739},
  ["로그인/id"] = {x = 383, y = 498},
  ["로그인/enter"] = {x = 463, y = 1134}, 
  ["로그인/pw"] = {x = 297, y = 503},
  ["로그인/로그인"] = {x = 154, y = 739},
  ["로그인완료/서버선택"] = {x = 604, y = 429},
}

-- 와룡봉추 436 884

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
