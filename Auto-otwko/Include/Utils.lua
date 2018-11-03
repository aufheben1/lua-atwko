
function tableLength(T)
	local count = 0
	if T == nil then return count end
	for _ in pairs(T) do count = count + 1 end
	return count
end

function checkScreen(T)
	for key, item in pairs(T) do
		if getColor(item.x, item.y) == item.color then
			return false
		end
	end
	return true
end

function sleepSec(t)
    usleep(t * 1000000)
end

function touch(x,y)
	local id = math.random(100)
	touchDown(id, x, y)
	sleepSec(0.03)
	touchUp(id, x, y)
end

function touchServer(serverIndex)
  local touchList = {{420, 390}, {420, 672}, {354, 390}, {354,672}}
  touch(touchList[serverIndex][1], touchList[serverIndex][2]) 
end

function touchTag(itemType)
  local touchList = {{24, 336}, {24, 450}, {24, 584}, {24, 722}, {24, 824}, {24, 940}}
  touch(touchList[itemType][1], touchList[itemType][2])
end

function touchItem(itemIndex)
  local touchList = {{156, 246}, {156, 388}, {156, 512}, {156, 654}, {156, 792}, {156, 920}}
  touch(touchList[itemIndex][1], touchList[itemIndex][2])
end

function isCorpTime(tType, hour)
  if tType == 1 then 
    return true 
  elseif tType == 2 then
    return hour % 2 == 1
  elseif tType == 3 then
    return hour % 2 == 0
  else 
    return false
  end
end

function getTime(code)
	now = os.date("*t", os.time())
	return now[code]
end

function findTargetAgent(agent)
	hour = getTime("hour")
	min = getTime("min")

	--[[
	-- 황성 시간이 가까웠을 경우 접속제한
	if hour == 19 and min == 58 then
		return -1, -1
	end
	if hour == 19 and min == 59 then
		return 1, "황성첫타"
	end
	-- TODO: 황성 첫타 이후 다른 계정들 첫타용 접속
	-- TODO: 다른 계정들 첫타 완료 후 메인계정 황성자동
	]]--

	--TODO:: if 군단이벤 중 and 군단 리세시간 근처일 경우 군단용 접속
	--TODO:: if 황성시간 가까울 경우 황성 첫타용 접속

	size = tableLength(agent)
	minRemainTime = 9999999
	-- 기본모드 강화 (mode = 1)
	for i = 1, size do
		-- 최저 시간 체크해서 일정 시간 이하 남았을 경우 mode 2 이하는 아예 접속 제한
		if restartTime[i] - os.time() < minRemainTime then
			minRemainTime = restartTime[i] - os.time()
		end

		if agent.mode == 1 and restartTime[i] < os.time() then
			return i, "강화"
		end
	end

	-- 심플모드 강화 (mode = 2)
	for i = 1, size do
		if agent[i].mode == 2 then
			--강화를 위한 접속
			--
			-- agent 정보에 강화를 위한 카운터를 따로 넣는 것은?
		end
	end

	-- 


	--기본: 강화를 해야할 시간
	--추가: 강화 10번만 하면 되는 친구, 강화 안할 친구
		-- 이 경우 추가로 해야할 일들
		-- 기본 수령 (주성에서)
		-- 주장
		-- 탐방도 할지?
		-- 
	-- 추가: 황성 첫타 및 황성 레이스
	return -1, -1
end


targetPosition = {{x = 111, y = 220, z = 0}, {x = 138, y = 518, z = 0},{x = 149, y = 439, z = 1}, 	--동탁
						{x = 214, y = 464, z = 0}, {x = 223, y = 162, z = 0}, {x = 150, y = 318, z = 0}, 	--원술
						{x = 115, y = 333, z = 0}, {x = 92, y = 90, z = 0}, {x = 204, y = 180, z = 1}, 		--이엄
						{x = 160, y = 326, z = 1}, {x = 327, y = 339, z = 0}, {x = 145, y = 193, z = 0}, 	--유대
						{x = 105, y = 125, z = 0}, {x = 204, y = 157, z = 0}, {x = 137, y = 340, z = 0},	--한수
						{x = 230, y = 150, z = 1}, {x = 88, y = 172, z = 0}, {x = 159, y = 356, z = 1}, 	--
						{x = 68, y = 216, z = 0}, {x = 86, y = 94, z = 0}, {x = 172, y = 464, z = 0},
						{x = 203, y = 199, z = 0}, {x = 241, y = 47, z = 0}, {x = 324, y = 394, z = 0},		--유언
						{x = 228, y = 118, z = 0}, {x = 133, y = 186, z = 1}, {x = 120, y = 388, z = 0},
						{x = 220, y = 560, z = 0}, {x = 219, y = 423, z = 0}, {x = 185, y = 448, z = 0},
						{x = 186, y = 353, z = 0}, {x = 160, y = 153, z = 0}, {x = 77, y = 405, z = 1},		--등애
						{x = 137, y = 194, z = 0}, {x = 247, y = 101, z = 0}, {x = 217, y = 414, z = 1}, 	--정보	
						{x = 195, y = 415, z = 0}, {x = 158, y = 144, z = 0}, {x = 93, y = 408, z = 1},     --여포
  						{x = 110, y = 155, z = 0}, {x = 243, y = 462, z = 0}, {x = 318.24, y = 449, z = 0},	--조조
  						{x = 325, y = 442, z = 0}, {x = 199, y = 91, z = 0}, {x = 326, y = 239, z = 0},		--손호
  						{x = 200, y = 380, z = 0}, {x = 163, y = 315, z = 1}, {x = 203, y = 212, z = 0},		--소선
  						{x = 100, y = 230, z = 0}, {x = 178, y = 234, z = 0}, {x = 191, y = 435, z = 0}, 
  						{x = 155, y = 71, z = 0}
  						--{x = 336, y = 490, z = 0}, {x = 467, y = 457, z = 0}, {x = 486, y = 905, z = 0},
  						--{x = 436, y = 141, z = 0}
						};
--{x,y, 드래깅 여부}
dragBuffer = {{x1 = 105, y1 = 309, x2 = 260, y2 = 286}, {x1 = 196, y1 = 306, x2 = 95, y2 = 377},	--이엄
					{x1 = 115, y1 = 409, x2 = 218, y2 = 299}, {x1 = 212, y1 = 228, x2 = 56, y2 = 452}, 	--엄백호
					{x1 = 123, y1 = 434, x2 = 241, y2 = 304}, {x1 = 198, y1 = 298, x2 = 65, y2 = 381},	--정원
					{x1 = 125, y1 = 434, x2 = 250, y2 = 341}, {x1 = 207, y1 = 385, x2 = 45, y2 = 404},	--정보
  					{x1 = 118, y1 = 436, x2 = 215, y2 = 436}, {x1 = 215, y1 = 436, x2 = 118, y2 = 436}	--이궤
					};
          
local l = tableLength(targetPosition)
for i = 1, l do
  targetPosition[i].x = targetPosition[i].x * 2
  targetPosition[i].y = targetPosition[i].y * 2
end

l = tableLength(dragBuffer)
for i = 1, l do
  dragBuffer[i].x1 = dragBuffer[i].x1 * 2
  dragBuffer[i].x2 = dragBuffer[i].x2 * 2
  dragBuffer[i].y1 = dragBuffer[i].y1 * 2
  dragBuffer[i].y2 = dragBuffer[i].y2 * 2
end

function Drag(count)
  x1 = dragBuffer[count].x1;
	x2 = dragBuffer[count].x2;
	y1 = dragBuffer[count].y1;
	y2 = dragBuffer[count].y2;
	dx = (x2 - x1) / 5;
	dy = (y2 - y1) / 5;
	
	touchDown(1, x1, y1);
	usleep(15000);
	for j = 1, 5 do
		touchMove(1, x1 + j * dx, y1 + j * dy);
		usleep(15000);
	end
	touchUp(1, x2, y2);
	usleep(200000);
	mapColor = getColor(440, 200);
end
