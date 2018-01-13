SCREEN_RESOLUTION="320x568"

fullCount = 4

--user setting parameters
targetList = {
    {id = "sonichk@naver.com", pw = "a", server = 3}       --소닉
    ,{id = "haneurl@hotmail.com", pw = "kip7817", server = 3}   --가민      
    ,{id = "woonrak@nate.com", pw = "1234", server = 3}		--별길
  	,{id = "aufheben_1@hanmail.net", pw = "6977", server = 3}		--냄새
}
--[[
tag-> 1=투구, 2=갑옷, 3=무기, 4=탈것, 5=보물, 6=장신구
count-> 해당 tag창에 들어가서 몇번째 순서인지
]]--
itemList = {
    {tag = 6, count = 6}   --소닉
    ,{tag = 6, count = 8}   --가민
  	,{tag = 6, count = 5}	--별길
  	,{tag = 6, count = 1}	--냄새
}


function sleepLong(timer)  
  for i = 1, timer do
        sleepSec(1)
    end
end

function ggetColor(x,y)
    return getColor(x*2, y*2)
end

wifiOn = true

function SetWifi()
	wifiOn = not wifiOn
	keyDown(KEY_TYPE.VOLUME_UP_BUTTON);
	sleepSec(1.0)
	keyUp(KEY_TYPE.VOLUME_UP_BUTTON);
	sleepSec(0.5)
end


jingsu = true   --true 일시 08시~16시 사이에 주성에 들어가서 징수버튼을 누른다, 하시 싫으면 false

smWaitTime = 0.2

function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function hSleep(t)
    usleep(t)
end
function sleepSec(t)
    hSleep(t * 1000000)
end
function sleepMin(t)
    hSleep(t * 60000000)
end
function touch(x,y)
    touchDown(0, x, y)
    sleepSec(0.03)
    touchUp(0, x, y)
end

function touchServer(targetNum)
    if targetList[targetNum].server == 1 then
        touch(210, 195)
    elseif targetList[targetNum].server == 2 then
        touch(210, 336)
    elseif targetList[targetNum].server == 3 then
        touch(177, 195)
    elseif targetList[targetNum].server == 4 then
        touch(177,336)
    end
end
function touchTag(t)
    if t == 1 then
        touch(12, 168)
    elseif t == 2 then
        touch(12, 225)
    elseif t == 3 then
        touch(12, 292)
    elseif t == 4 then
        touch(12, 361)
    elseif t == 5 then
        touch(12, 412)
    elseif t == 6 then
        touch(12, 470)
    end
end
function touchItem(t)
    if t == 1 then
        touch(78, 123)
    elseif t == 2 then
        touch(78, 194)
    elseif t == 3 then
        touch(78, 256)
    elseif t == 4 then
        touch(78, 327)
    elseif t == 5 then
        touch(78, 396)
    elseif t == 6 then
        touch(78, 460)
    end
end

function fullTime()
    now = os.date("*t", os.time())
    hh = now["hour"]
    if hh >= 8 and hh <= 12 then
        return true
    else
        return false
    end
end

--os.difftime(t2, t1)

--Initialize
targetCount = tableLength(targetList)
delayedBefore = {}
restartTime = {}
loginedTarget = 0
targetNum = 0

for i = 1, targetCount do
    delayedBefore[i] = false
    restartTime[i] = os.time()
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
      
      log("minTargetTime: " .. minTargetTime .. "/ osTime: " .. os.time())
      if os.time() > minTargetTime then
        log("break")
        break
      else
        log("wait")
        usleep(1000000) --wait 1 second
      end
    end
        
    --state machine for target
    appRun("com.digitalcloud.otwko")
    state = 0
    stateCount = 0
    prevState = 0
    touchCount = 0
    
    --state machine loop
    while true do
        --from any state
        if state ~= prevState then	--state 변경시 이전 state 저장
            stateCount = 0
            prevState = state
        end
        stateCount = stateCount + 1	--state가 변경되지 않는 시간을 카운트
        if stateCount > (20/smWaitTime) then        --state doesn't move for 20 sec
            restartTime[targetNum] = os.time() + 120  --wait for 2 minute
            break
        end
        
        --다른 기기에서 접속했을 시, 15분 대기
        if ggetColor(272,503) == 13668970 and ggetColor(220, 40) ==14594953 and state ~= 0 and state ~= 4 and state ~= 8 then --access from other device
            restartTime[targetNum] = os.time() + 900 --wait for 15 minute
            delayedBefore[targetNum] = false
            break
        end

        if ggetColor(69,426) == 2973324 then	--출첵!
        	sleepSec(1.0)
        	touch(69,426)
        	sleepSec(4.0)
        	touch(290, 478)
        	sleepSec(2.0)
            if fullTime() then
                state = 8
            else
                state = 4
            end
        end

        if ggetColor(54,433) == 3705129 then	--공지
        	sleepSec(1.0)
        	touch(59,433)
        	sleepSec(4.0)
        	touch(290,465)
        	sleepSec(2.0)
            if fullTime() then
                state = 8
            else
                state = 4
            end
        end
        
        --for state
        if state == 0 then      --웅패 메인화면
            if ggetColor(272,503) == 13668970 and ggetColor(220, 40) == 14594953 then --check main screen
                touch(291, 82)  --메인화면 내 서버선택 버튼
                state = 1
            end
            sleepSec(smWaitTime)
        elseif state == 1 then  --서버선택 창
            --if ggetColor(210, 195) == 530439 then    --1 server button
            --if ggetColor(210, 195) == 9539985 then --1 server button
            if ggetColor(210, 195) == 1118481 then --1 server button
                if targetNum == loginedTarget then	--현재 로그인된 대상이 대상 아이디일 시
                    touchServer(targetNum)
                    if fullTime() then
                        state = 8
                    else
                        state = 4
                    end
                else
                    touch(254, 372)     --계정설정 버튼
                    state = 2
                end
            end
            sleepSec(smWaitTime)
        elseif state == 2 then  --로그인
            if ggetColor(156, 322) == 1009577 then	--누군가 로그인 되어 있을 시
                touch(156, 322) --로그아웃
            elseif ggetColor(154, 259) == 16777215 then	--로그인 된 대상이 없을시
               sleepSec(0.3)
                touch(154, 259) --id slot
                sleepSec(1)
                inputText(targetList[targetNum].id) --input id
                sleepSec(1)
                touch(20, 495)  --enter
                sleepSec(0.5)
                touch(125, 255) --pw slot
                sleepSec(0.5)
                inputText(targetList[targetNum].pw)
                touch(20, 495)  --enter
                sleepSec(0.5)
                touch(56, 303)
                state = 3
            end
            sleepSec(smWaitTime)
        elseif state == 3 then  --다시 서버 선택창으로
            --//add function to relogin when login failed
            if ggetColor(156, 322) == 1009577 then   --로그인 되었을시
                touch(252, 186)
                loginedTarget = targetNum
                state = 1
            end
            sleepSec(smWaitTime)
        elseif state == 4 then  --게임 접속, 강화창으로
            --//add function to stop when server check
            --//add function to close windows on first access of day        
            if ggetColor(47, 540) == 16773152 then --option button
                touch(47, 540)
                state = 5
            end
            sleepSec(smWaitTime)
        elseif state == 5 then  --option window
            --if ggetColor(151, 363) == 3707975 then --enchant window button
            if ggetColor(151, 363) == 3642438 then --enchant window button
                touch(151, 363)
                state = 6
            end
            sleepSec(smWaitTime)
        elseif state == 6 then  --enchant window
            if ggetColor(175, 413) == 6105858 then   --enchant button
                touchTag(itemList[targetNum].tag)
                sleepSec(2.0)
                iCount = itemList[targetNum].count
                while iCount > 6 do
                    touch(79, 500)
                    sleepSec(0.5)
                    iCount = iCount - 6
                end
                touchItem(iCount)
                sleepSec(smWaitTime)
                touchCount = 0
                state = 7
            end
            sleepSec(smWaitTime)
        elseif state == 7 then  --enchant window;item selected
            if delayedBefore[targetNum] == false then
                --if ggetColor(188, 407) == 15584313 then --enchant button touchable
                if ggetColor(188, 407) == 15518777 then --enchant button touchable
                    touch(188, 407)
                end
                sleepSec(2)
                --if ggetColor(188, 407) == 15584313 then --enchant button touchable
                if ggetColor(238, 441) == 11045167 then  --enchant boost window
                    restartTime[targetNum] = os.time() + 120  --wait for 2 minute
                    break
                else
                    delayedBefore[targetNum] = true
                end
            else
                --if ggetColor(188, 407) == 15584313 then --enchant button touchable
                if ggetColor(188, 407) == 15518777 then --enchant button touchable
                    touch(188, 407)
                end
                if ggetColor(238, 441) == 11045167 then  --enchant boost window
                    restartTime[targetNum] = os.time() + 900  --wait for 15 minute
                    break
                end
            end
            sleepSec(0.4)
        elseif state == 8 then  --게임 접속, 태학원으로
            if ggetColor(47, 540) == 16773152 then --option button
                touch(95, 311)
                state = 9
            end
            sleepSec(smWaitTime)
        elseif state == 9 then  --태학원 창
            if ggetColor(63, 297) == 10718284 then --jingsu button
                touch(63, 297)
                state = 10
            end
            sleepSec(smWaitTime)
        elseif state == 10 then --태학강당 창
        	sleepSec(3.0)
        	touch(75,130)
        	sleepSec(0.5)
        	touch(75,200)
        	sleepSec(0.5)
        	touch(75,260)
        	sleepSec(0.5)
        	touch(75,330)
        	sleepSec(0.5)
        	touch(75,380)
        	sleepSec(0.5)
        	touch(75,460)
        	sleepSec(2.0)
        	touch(150,295)
        	sleepSec(3.0)
        	touch(213,457)
        	sleepSec(0.5)
        	touch(305,480)
        	state = 4
            sleepSec(smWaitTime)
        else
            break
        end
    end
    
    
    appKill("com.digitalcloud.otwko")
    sleepSec(1)
    
end
