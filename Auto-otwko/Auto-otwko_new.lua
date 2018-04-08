adaptResolution(640, 1136);
adaptOrientation(ORIENTATION_TYPE.PORTRAIT);

dofile(rootDir() .. "Include/Setting.lua")
dofile(rootDir() .. "Include/Utils.lua")

--[[
각 상태별 스크립트를 서로 다른 파일로 관리할 예정.
각 스크립트 별 dofile
]]--


--Global values
targetCount = tableLength(targets)
loginedTarget = 0
targetNum = 0


function writeFile(index)
  
end

--Initialize
for i = 1, targetCount do
  --//TODO: read files
end

--//TODO: 강화 할 때마다 총 강화회수 카운트해서 로그에 남길까?