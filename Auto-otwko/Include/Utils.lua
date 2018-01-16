
function tableLength(T)
    local count = 0
    if T == nil then return count end
    for _ in pairs(T) do count = count + 1 end
    return count
end

function sleepSec(t)
    usleep(t * 1000000)
end

function touch(x,y)
    touchDown(0, x, y)
    sleepSec(0.03)
    touchUp(0, x, y)
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