dofile(rootDir() .. "Include/Utils.lua")

--[[
웅패천지 자동 스크립트 ver 2.0.0

제작자: 최진우(aufheben_1@naver.com
기기: iPhone 5, iPhone 5c, iPhone 5s, iPhone SE
Autotouch 버전: v3.5.3 이상

기능
1. 자동강화
2. 태학원 학습
3. 자동징수(by Wifi On/Off)
4. 
]]

--account setting
local accountList = {"소닉", "가민", "별길", "냄새"}
--[[
account list: 
]]

-- Resolution = 1136x640

local result = findImage("Resource/01_MainScreen.png", 0, 1, nil, nil)
for i, v in pairs(result) do
    alert(string.format("Found rect at: x:%f, y:%f", v[1], v[2]));
end