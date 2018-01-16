adaptResolution(640, 1136);
adaptOrientation(ORIENTATION_TYPE.PORTRAIT);

dofile(rootDir() .. "Include/Setting.lua")
dofile(rootDir() .. "Include/Utils.lua")

smWaitTime = 0.2


function fullTime()
    now = os.date("*t", os.time())
    hh = now["hour"]
    if hh >= 8 and hh <= 12 then
        return true
    else
        return false
    end
end

function writeTime(index, time)
  local file = io.open(rootDir().."Tmp/"..nameList[index]..".tmp", "w")
  file:write(time)
  file:close()
end

--Initialize
targetCount = tableLength(targetList)
restartTime = {}
loginedTarget = 0
targetNum = 0

for i = 1, targetCount do
    file = io.open(rootDir().."Tmp/"..nameList[i]..".tmp", "r")
    if file == nil then
      --파일이 없을 경우 새로 생성
      file = io.open(rootDir().."Tmp/"..nameList[i]..".tmp", "w+")
      file:write(os.time())
      file:close()
      restartTime[i] = os.time()
    else
      --파일이 있을경우 읽어옴
      restartTime[i] = tonumber(file:read())
      file:close()
    end
end
appKill("com.digitalcloud.otwko")
sleepSec(1)

--loop
while true do
    
    --wait until target time
    while true do
      --find minimum target time
      minTargetTime = restartTime[1]
      targetNum = 1
      for i = 1, targetCount do
        if restartTime[i] < minTargetTime then
          minTargetTime = restartTime[i]
          targetNum = i
        end
      end
      
      if os.time() > minTargetTime then
        break
      else
        usleep(1000000) --wait 1 second
      end
    end
        
    --state machine for target
    appRun("com.digitalcloud.otwko")
    state = 0
    stateCount = 0
    prevState = 0
        
    --state machine loop
    while true do
        --from any state
        if state ~= prevState then	--state 변경시 이전 state 저장
            stateCount = 0
            prevState = state
        end
        stateCount = stateCount + 1	--state가 변경되지 않는 시간을 카운트
        if stateCount > (20/smWaitTime) then        --state doesn't move for 20 sec
          log("state 변경 안됨")
            restartTime[targetNum] = os.time() + 120  --wait for 2 minute
            writeTime(targetNum, os.time() + 120)
            break
        end
        
        --다른 기기에서 접속했을 시, 15분 대기
        if getColor(544,1006) == 13668970 and getColor(440, 80) ==14594953 and state ~= 0 and state ~= 4 and state ~= 8 then --access from other device
            log(state)
            log("access from other device")
            restartTime[targetNum] = os.time() + 900 --wait for 15 minute
            writeTime(targetNum, os.time() + 900)
            break
        end

        if getColor(138,852) == 2973324 then	--출첵!
        	sleepSec(1.0)
        	touch(138,852)
        	sleepSec(4.0)
        	touch(580, 956)
        	sleepSec(2.0)
            if fullTime() then
                state = 8
            else
                state = 4
            end
        end

        if getColor(108,866) == 3705129 then	--공지
        	sleepSec(1.0)
        	touch(118,866)
        	sleepSec(4.0)
        	touch(580,930)
        	sleepSec(2.0)
            if fullTime() then
                state = 8
            else
                state = 4
            end
        end
        
        --for state
        if state == 0 then      --웅패 메인화면
            if getColor(544,1006) == 13668970 and getColor(440, 80) == 14594953 then --check main screen
                touch(582, 164)  --메인화면 내 서버선택 버튼
                state = 1
            end
            sleepSec(smWaitTime)
        elseif state == 1 then  --서버선택 창
            if getColor(420, 390) == 1118481 then --1 server button
                if targetNum == loginedTarget then	--현재 로그인된 대상이 대상 아이디일 시
                    touchServer(targetList[targetNum].server)
                    if fullTime() then
                        state = 8
                    else
                        state = 4
                    end
                else
                    touch(508, 744)     --계정설정 버튼
                    state = 2
                end
            end
            sleepSec(smWaitTime)
        elseif state == 2 then  --로그인
            if getColor(312, 644) == 1009577 then	--누군가 로그인 되어 있을 시
                touch(312, 644) --로그아웃
            elseif getColor(308, 518) == 16777215 then	--로그인 된 대상이 없을시
               sleepSec(0.3)
                touch(308, 518) --id slot
                sleepSec(1)
                inputText(targetList[targetNum].id) --input id
                sleepSec(1)
                touch(40, 990)  --enter
                sleepSec(0.5)
                touch(250, 510) --pw slot
                sleepSec(0.5)
                inputText(targetList[targetNum].pw)
                touch(40, 990)  --enter
                sleepSec(0.5)
                touch(112, 606)
                state = 3
            end
            sleepSec(smWaitTime)
        elseif state == 3 then  --다시 서버 선택창으로
            --//add function to relogin when login failed
            if getColor(312, 644) == 1009577 then   --로그인 되었을시
                touch(504, 372)
                loginedTarget = targetNum
                state = 1
            end
            sleepSec(smWaitTime)
        elseif state == 4 then  --게임 접속, 강화창으로
            --//add function to stop when server check
            --//add function to close windows on first access of day        
            if getColor(94, 1080) == 16773152 then --option button
                touch(94, 1080)
                state = 5
            end
            sleepSec(smWaitTime)
        elseif state == 5 then  --option window
            if getColor(302, 726) == 3642438 then --enchant window button
                touch(302, 726)
                state = 6
            end
            sleepSec(smWaitTime)
        elseif state == 6 then  --enchant window
            if getColor(350, 826) == 6105858 then   --enchant button
                touchTag(itemList[targetNum].tag)
                sleepSec(2.0)
                iCount = itemList[targetNum].count
                while iCount > 6 do
                    touch(158, 1000)
                    sleepSec(0.5)
                    iCount = iCount - 6
                end
                touchItem(iCount)
                sleepSec(smWaitTime)
                state = 7
            end
            sleepSec(smWaitTime)
        elseif state == 7 then  --enchant window;item selected
            if getColor(376, 814) == 15518777 then --enchant button touchable
                touch(376, 814)
            end
            if getColor(476, 882) == 11045167 then  --enchant boost window
                restartTime[targetNum] = os.time() + 900  --wait for 15 minute
                writeTime(targetNum, os.time() + 900)
                break
            end
            sleepSec(0.4)
        elseif state == 8 then  --게임 접속, 태학원으로
            if getColor(94, 1080) == 16773152 then --option button
                touch(190, 622)
                state = 9
            end
            sleepSec(smWaitTime)
        elseif state == 9 then  --태학원 창
            if getColor(126, 594) == 10718284 then --jingsu button
                touch(126, 594)
                state = 10
            end
            sleepSec(smWaitTime)
        elseif state == 10 then --태학강당 창
        	sleepSec(3.0)
        	touch(150,260)
        	sleepSec(0.5)
        	touch(150,400)
        	sleepSec(0.5)
        	touch(150,520)
        	sleepSec(0.5)
        	touch(150,660)
        	sleepSec(0.5)
        	touch(150,760)
        	sleepSec(0.5)
        	touch(150,920)
        	sleepSec(2.0)
        	touch(300,590)
        	sleepSec(3.0)
        	touch(426,914)
        	sleepSec(0.5)
        	touch(610,960)
        	state = 4
            sleepSec(smWaitTime)
        else
            break
        end
    end
    
    
    appKill("com.digitalcloud.otwko")
    sleepSec(1)
    
end
