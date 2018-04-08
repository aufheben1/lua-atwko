--user setting parameters
targetList = {
    {id = "sonichk@naver.com", pw = "a", server = 3}       --소닉
    ,{id = "75j-s@hanmail.net", pw = "123456", server = 3}       --종성
    ,{id = "haneurl@hotmail.com", pw = "kip7817", server = 3}   --가민      
  	,{id = "aufheben_1@hanmail.net", pw = "6977", server = 3}		--냄새
}
--[[
tag-> 1=투구, 2=갑옷, 3=무기, 4=탈것, 5=보물, 6=장신구
count-> 해당 tag창에 들어가서 몇번째 순서인지
]]--
itemList = {
    {tag = 6, count = 5}   --소닉
    ,{tag = 6, count = 31}   --종성
    ,{tag = 6, count = 8}   --가민
  	,{tag = 4, count = 2}	--냄새
}

nameList = {"소닉", "종성", "가민", "냄새"}

--[[
테스트중, 군단 여부
]]--
corpMode ={true, true, true, false}

corpTarget = {1, 2, 3, 0} --양광, 두건덕, 두복위

targets = 
{
  {
    tag = "소닉",
    account = {id = "sonichk@naver.com", pw = "a", server = 3},
    item = {itemType = 6, itemIndex = 5},
    extras = {school = true, cubine = true, corp = true, hwangsung = true},
    corp = {timeType = 1, target = 1},   --timeType: 1=모든시간, 2=홀수시간, 3=짝수시간 / target: 1=양광, 2=두건덕, 3=두복위
    jujang = {hour = 4}
  },
  {
    tag = "종성",
    account = {id = "75j-s@hanmail.net", pw = "123456", server = 3},
    item = {itemType = 6, itemIndex = 10},
    extras = {school = true, cubine = true, corp = true, hwangsung = true},
    corp = {timeType = 2, target = 2},   --timeType: 1=모든시간, 2=홀수시간, 3=짝수시간 / target: 1=양광, 2=두건덕, 3=두복위
    jujang = {hour = 4}
  }
}