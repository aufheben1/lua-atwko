adaptResolution(640, 1136);
adaptOrientation(ORIENTATION_TYPE.PORTRAIT);

dofile(rootDir() .. "Include/Setting.lua")
dofile(rootDir() .. "Include/Utils.lua")

smWaitTime = 0.2

--Initialize
targetCount = tableLength(targetList)
restartTime = {}
lastCubineTime = {}
lastCorpTime = {}
lastHwangsungDay = {}
lastJujangDay = {}
loginedTarget = 0
targetNum = 0

function fullTime()
    now = os.date("*t", os.time())
    hh = now["hour"]
    if hh >= 8 and hh <= 12 then
        return true
    else
        return false
    end
end

function writeFile(index)
  local file = io.open(rootDir().."Tmp/"..nameList[index]..".tmp", "w")
  file:write(restartTime[index] .. "\n")
  file:write(lastCubineTime[index] .. "\n")
  file:write(lastCorpTime[index].. "\n")
  file:write(lastHwangsungDay[index].. "\n")
  file:write(lastJujangDay[index])
  file:close()
end


function touchCorp(targetNum)
  local touchList = {{322, 569}, {213, 685}, {152, 851}, {176, 987}}
  touch(touchList[targetNum][1], touchList[targetNum][2])
end


for i = 1, targetCount do
    file = io.open(rootDir().."Tmp/"..nameList[i]..".tmp", "r")
    if file == nil then
      --파일이 없을 경우 새로 생성
      file = io.open(rootDir().."Tmp/"..nameList[i]..".tmp", "w+")
      file:write(os.time() .. "\n")
      file:write("-1\n")
      file:write("-1\n")
      file:write("-1\n")
      file:close()
      restartTime[i] = os.time()
      lastCubineTime[i] = -1
      lastCorpTime[i] = -1
      lastHwangsungDay[i] = -1
      lastJujangDay[i] = -1
    else
      --파일이 있을경우 읽어옴
      restartTime[i] = tonumber(file:read())
      lastCubineTime[i] = tonumber(file:read())
      lastCorpTime[i] = tonumber(file:read())
      lastHwangsungDay[i] = tonumber(file:read())
      lastJujangDay[i] = tonumber(file:read())
      file:close()
    end
end
appKill("com.digitalcloud.otwko")
sleepSec(1)

currentJJCount = 1
mapColor = 0
dragCount = 1

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
    corpTryCount = 0
        
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
            writeFile(targetNum)
            break
        end
        
        --다른 기기에서 접속했을 시, 15분 대기
        if getColor(544,1006) == 6965814 and getColor(440, 80) ==7428934 and state ~= 0 and state ~= 4 and state ~= 8 then --access from other device
            log(state)
            log("access from other device")
            restartTime[targetNum] = os.time() + 900 --wait for 15 minute
            writeFile(targetNum)
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
              now = os.date("*t", os.time())
              hh = now["hour"]
              dd = now["day"]
            
              if (hh % 8 == 0) and (hh ~= lastCubineTime[targetNum]) then --후궁을 해야할 경우
                touch(327, 1132)   --후궁 버튼
                state = 11
              elseif hh == 4 and dd ~= lastJujangDay[targetNum] then  -- 주장 잡아야함
                touch(85, 668)  --출정 버튼
                state = 23
              else
                touch(94, 1080)
                state = 5
              end
              
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
                writeFile(targetNum)
                
                now = os.date("*t", os.time())
                hh = now["hour"]
                dd = now["day"]
                if hh == 20 and dd ~= lastHwangsungDay[targetNum] then
                  touch(412, 913)
                  sleepSec(0.5)
                  touch(605,970)
                  sleepSec(0.5)
                  touch(592, 956)
                  sleepSec(0.2)
                  lastHwangsungDay[targetNum] = dd
                  writeFile(targetNum)
                  state = 19

                elseif corpMode[targetNum] == true and  (hh % 2 == 1) and hh ~= lastCorpTime[targetNum] then
                  touch(412, 913)
                  sleepSec(0.5)
                  touch(605,970)
                  sleepSec(0.2)
                  state = 13
                else
                  break
                end
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
        elseif state == 11 then --후궁 창
          sleepSec(2.0)
          touch(56, 636)
          sleepSec(1.0)
          touch(182, 691)
          sleepSec(1.0)
          touch(590, 987)
          sleepSec(0.5)
          
          now = os.date("*t", os.time())
          hh = now["hour"]
          lastCubineTime[targetNum] = hh
          writeFile(targetNum)
          
          state = 4
          sleepSec(smWaitTime)
        elseif state == 12 then --다시 기능창 누르고 군단전으로
          if getColor(94, 1080) == 16773152 then --option button
            touch(94, 1080)
            state = 13
          end
          sleepSec(smWaitTime)
        elseif state == 13 then --기능창에서 강화버튼이 보이면 군단전버튼 누르기
          --if getColor(350, 826) == 6105858 then   --enchant button
          if getColor(425, 881) == 16643992 then
            touch(431, 876)
            corpTryCount = 0
            state = 14
          end
          sleepSec(smWaitTime)
        elseif state == 14 then --군단전 화면, 바닥 초록색타일 확인 후 원하는 군단 버튼 누르기
          if corpTryCount >= 20 then
            now = os.date("*t", os.time())
            hh = now["hour"]
            lastCorpTime[targetNum] = hh
            writeFile(targetNum)
            break
          elseif getColor(210, 433) == 7701540 or getColor(210,433) == 4409649 then
            touchCorp(corpTarget[targetNum])
            --touch(213, 685) --일단은 테스트용, 두건덕 좌표
            state = 15
          end
          sleepSec(smWaitTime)
        elseif state == 15 then --집결버튼 뜨면 누르기
          if getColor(115, 839) == 12761010 then
            touch(115, 839)
            state = 16
          end
          sleepSec(smWaitTime)        
        elseif state == 16 then --공격버튼 뜨면 누르기, 만약 군단 끝났을 경우 시간 기록 후 break
          if getColor(122, 888) == 131592 then
            touch(122, 888)
            state = 17
          elseif getColor(438, 920) == 65792 then
            now = os.date("*t", os.time())
            hh = now["hour"]
            lastCorpTime[targetNum] = hh
            writeFile(targetNum)
            break
          end
          sleepSec(smWaitTime)        
        elseif state == 17 then --결과 버튼 누르기, 군단 카운트 증가
          if getColor(37, 1029) == 6117236 then
            touch(37, 1029)
            corpTryCount = corpTryCount + 1
            state = 18
          end
          sleepSec(smWaitTime)     
        elseif state == 18 then --돌아가기 버튼 누르기, 상태는 14번으로
          if getColor(32, 865) == 9225796 then
            touch(32, 865)
            state = 14
          end
          sleepSec(smWaitTime)
        elseif state == 19 then --기능 버튼이 보이면 이벤트 버튼 클릭
          if getColor(94, 1080) == 16773152 then --기능 버튼
            touch(209, 40)
            state = 20
          end
          sleepSec(smWaitTime)
        elseif state == 20 then --황성버튼이 보이면 클릭
          if getColor(415, 719) == 9379111 then --황성버튼
            touch(415, 719)
            state = 21
          end
          sleepSec(smWaitTime)
        elseif state == 21 then --함락버튼이 보이면 클릭
          if getColor(122, 852) == 9603226 then --황성버튼
            touch(122, 852)
            state = 22
          end
          sleepSec(smWaitTime)
        elseif state == 22 then --황성 입장, 공격버튼 누른 후 앱 종료
          if getColor(90, 950) == 16710905 then
            touch(90, 950)
            sleepSec(1.0)
            break
          end
          sleepSec(smWaitTime)
        elseif state == 23 then -- 주장 잡아야 해서 출정 버튼 누름
          sleepSec(0.8)
          if getColor(78, 28) == 15394686 then --좌측 화살표가 있을 경우 누른 후 대기
            touch(71, 18)
          else  --기다려도 좌측 화살표가 안나옴
            touch(74, 772)     --주성 한번 갔다가 다시 돌아올것.
            sleepSec(0.5)
            touch(85, 668)
            sleepSec(0.5)
            currentJJCount = 1
            mapColor = 0
            dragCount = 1
            state = 24
          end
          sleepSec(smWaitTime)
        elseif state == 24 then --주장 잡기1 - 맵 변화 감지 / 버튼 클릭
          if currentJJCount > tableLength(targetPosition) then
            now = os.date("*t", os.time())
            dd = now["day"]
            lastJujangDay[targetNum] = dd
            writeFile(targetNum)
            break
          end
          
          tC = getColor(440, 200)
          if mapColor ~= tC then
            mapColor = tC
            
            if targetPosition[currentJJCount].z == 1 then
              Drag(dragCount)
              dragCount = dragCount + 1
            end
            
            touch(targetPosition[currentJJCount].x, targetPosition[currentJJCount].y)
            
            state = 25
          end
          sleepSec(smWaitTime)
        elseif state == 25 then --주장잡기2 - 공격 버튼
          if getColor(138, 834) == 0x006fd8 then
            touch(138, 834)
            state = 26
          end
          sleepSec(smWaitTime)
        elseif state == 26 then --주장잡기3 - 전투중 화면
          if getColor(600, 686) == 0x4F0000 then
            touch(600, 686)
            state = 27
          end
          sleepSec(smWaitTime)
        elseif state == 27 then --주장잡기3 - 전투완료
          if getColor(60, 846) == 0x8BE401 then
            touch(60, 846)
            state = 28
            sleepSec(0.1)
            mapColor = getColor(440, 200)
          end
          sleepSec(smWaitTime)
        elseif state == 28 then --주장잡기3 - 다음 맵으로
          if getColor(88, 420) == 16250768 then
            touch(88, 420)
            state = 24
            currentJJCount = currentJJCount + 1
            sleepSec(0.5)
          end
          sleepSec(smWaitTime)
        else
            break
        end
    end
    
    
    appKill("com.digitalcloud.otwko")
    sleepSec(1)
    
end
