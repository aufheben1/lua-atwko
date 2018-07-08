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

broadState = -1
narrowState = -1
stateCount = -1

function writeFile(index)
  
end

--Initialize
for i = 1, targetCount do
  --//TODO: read files
end

appKill("com.digitalcloud.otwko")
sleepSec(1)

--주장 관련 파라미터들
--currentJJCount = 1
--mapColor = 0
--dragCount = 1

--//TODO: 강화 할 때마다 총 강화회수 카운트해서 로그에 남길까?

--Main Loop
while true do
    
  --wait until target time
  while true do
    targetNum, mode = findTargetAgent(agent)
	
	if targetNum ~= -1 then
		break
    else
      usleep(1000000) --wait 1 second
    end
  end




    if os.time() > minTargetTime then
      break
    else
      usleep(1000000) --wait 1 second
    end
  end
  
  
  --State machine for target
  --//TODO: 앱 실행 전 홈 버튼 누르는 것 추가는 어떨지?
  appRun("com.digitalcloud.otwko")
  
  broadState = 0
  prevBrodState = 0
  stateCount = 0
  
  --State machine loop
  while true do
    if AnyState() then break end
    
    --출책 공지는 어떤 state로?
    --switch case문이 루아엔 없음
    
    if      broadState == 0 then LoginState()       --게임 실행에서 로그인 후 접속 과정까지
    elseif  broadState == 1 then PostLoginState()   --접속 후 공지/출책 처리, 조건에 따른 다음 broadState 결정
    elseif  broadState == 2 then EnchantState()     --강화, 주장, 황성, 일퀘, 등등
    end
    
  end
end


function AnyState()
  -- do something
  -- if state change, narrowState = 0
  --if 끝내야 할 조건 then return true end
  --return false  
end

function LoginState()
  
end
