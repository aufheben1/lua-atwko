SCREEN_RESOLUTION="320x568"


function ggetColor(x,y)
    return getColor(x*2, y*2)
end


serarchDelay = 500;

local targetPosition = {{x = 111, y = 220, z = 0}, {x = 138, y = 518, z = 0},{x = 149, y = 439, z = 1}, 	--동탁
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
local dragBuffer = {{x1 = 105, y1 = 309, x2 = 260, y2 = 286}, {x1 = 196, y1 = 306, x2 = 95, y2 = 377},	--이엄
					{x1 = 115, y1 = 409, x2 = 218, y2 = 299}, {x1 = 212, y1 = 228, x2 = 56, y2 = 452}, 	--엄백호
					{x1 = 123, y1 = 434, x2 = 241, y2 = 304}, {x1 = 198, y1 = 298, x2 = 65, y2 = 381},	--정원
					{x1 = 125, y1 = 434, x2 = 250, y2 = 341}, {x1 = 207, y1 = 385, x2 = 45, y2 = 404},	--정보
  					{x1 = 118, y1 = 436, x2 = 215, y2 = 436}, {x1 = 215, y1 = 436, x2 = 118, y2 = 436}	--이궤
					};
--{최초x, 최초y, ~~~};

function TouchColor(x, y, color)
	while true do
		local rgb = ggetColor(x, y);
		if (rgb == color) then
			touchDown(0, x, y);
			usleep(30000);
			touchUp(0, x, y);
			return;
		end
		usleep(serarchDelay);
	end
end

function WaitForMapChange()
	while true do
		tC = ggetColor(220, 100);
		if mapColor ~= tC then
			mapColor = tC;
			return;
		end
		usleep(serarchDelay);
	end
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
	mapColor = ggetColor(220, 100);
end

local dragCount = 1;
local mapColor = 0;

for i, v in ipairs(targetPosition) do
	WaitForMapChange();
	usleep(serarchDelay);
	
	if (v.z == 1) then
		Drag(dragCount);
		dragCount = dragCount + 1;
	end
	
	--버튼클릭
	touchDown(0, v.x, v.y);
	usleep(30000);
	touchUp(0,v.x, v.y);
	
	usleep(30000);
	
	--[[
	--창닫기
	TouchColor(306, 468, 920066);
	usleep(30000);
	]]--
	
	--공격버튼
	TouchColor(69, 417, 0x006fd8);
	usleep(30000);

	--전투중화면
	TouchColor(300, 343, 0x4F0000);		
	usleep(30000);
	
	--전투완료
	TouchColor(30, 423, 0x8BE401);
	usleep(80000);
	
  	mapColor = ggetColor(220, 100);
  	
	--다음맵으로
	TouchColor(44, 210, 16250768);
	usleep(500000);
end

