--user setting parameters
targetList = {
    {id = "aaaa@aaa.com", pw = "a", server = 3}       --소닉
    ,{id = "bbbb@bbb.com", pw = "b", server = 3}   --가민      
    ,{id = "cccc@cc.com", pw = "c", server = 3}		--별길
  	,{id = "dddd@dd.net", pw = "dd", server = 3}		--냄새
}
--[[
tag-> 1=투구, 2=갑옷, 3=무기, 4=탈것, 5=보물, 6=장신구
count-> 해당 tag창에 들어가서 몇번째 순서인지
]]--
itemList = {
    {tag = 6, count = 5}   --소닉
    ,{tag = 6, count = 8}   --가민
  	,{tag = 6, count = 4}	--별길
  	,{tag = 1, count = 2}	--냄새
}

--[[
오토 돌리는 계정의 별칭 목록
]]--
nameList = {"소닉", "가민", "별길", "냄새"}