-- 如果当前不是服务器或者为第二服务器实例则回调
if (not GLOBAL.TheNet:GetIsServer()) or GLOBAL.TheShard:IsSecondary() then
    return
end

local urls = {
    "https://github.com/ylk2534246654/dst-mod-joint-ban/raw/main/docs/blacklist.json",
    "https://gitlab.com/ylk2534246654/dst-mod-joint-ban/-/raw/main/docs/blacklist.json",
    "https://gitcode.net/Cynric_Yx/dst-mod-joint-ban/-/raw/main/docs/blacklist.json"
}

--添加黑名单
local function ban(blacklist, netid, userid, timestamp)
    local netidBlacklist = {}
    local userBlacklist = {}
    local netid_len = string.len(netid)
    local userid_len = string.len(userid)
    for i, o1 in pairs(blacklist) do
        if o1.netid == netid and o1.userid == userid then
            --print("黑名单已存在 netid:"..netid..",userid:"..userid)
            return
        end
        if netid ~= nil and netid_len > 0 and o1.netid == netid then
            table.insert(netidBlacklist, i)
        end
        if userid ~= nil and userid_len > 0 and o1.userid == userid then
            table.insert(userBlacklist, i)
        end
    end

    if netid == nil then
        netid = ""
    end
    if userid == nil then
        userid = ""
    end
    if timestamp == nil then
        timestamp = ""
    end

    if #netidBlacklist == 0 and #userBlacklist == 0 then
        if userid_len == 0 then
            userid = "KU_JointBan"
        end

        --print("添加黑名单 netid:"..netid..",userid:"..userid)
        
        table.insert(blacklist, {
            servername = "joint-ban",
            character = "",
            date = "",
            serverdescription = "mod",
            netid = tostring(netid),
            userid = tostring(userid),
            timestamp = tostring(timestamp),
            netprofilename = ""
        })
    else
        --print("已存在黑名单，补充黑名单信息 netid:"..netid..",userid:"..userid)
        for i = #netidBlacklist, 1, -1 do
            blacklist[i].netid = tostring(netid)
            blacklist[i].userid = tostring(userid)
        end
        for i = #userBlacklist, 1, -1 do
            blacklist[i].netid = tostring(netid)
            blacklist[i].userid = tostring(userid)
        end
    end
    --print("更新黑名单 -> "..GLOBAL.json.encode(blacklist))
end

--恢复白名单
local function clear(blacklist)
    local clearBlacklist = {}
    for i, o1 in pairs(blacklist) do
        if o1.servername == "joint-ban" then
            table.insert(clearBlacklist, i)
        end
    end

    for i = #clearBlacklist, 1, -1 do
        table.remove(blacklist, clearBlacklist[i])
    end
    
    --print("恢复白名单 -> "..GLOBAL.json.encode(blacklist))
end

--修复黑名单
local function repair(blacklist)
    for i, o1 in pairs(blacklist) do
        if (o1.netid ~= nil and string.len(o1.netid) > 0) and (o1.userid == nil or string.len(o1.userid) == 0) then
            o1.userid = o1.netid --转移id
            o1.netid = "" --清空netid
        end
    end
    --print("修复黑名单 -> "..GLOBAL.json.encode(blacklist))
end

local function requestUrl(urls, index)
    if index > #urls then
        return -- 如果已经请求完所有网址，则停止
    end
    local url = urls[index]
    local success = false -- 请求是否成功标志
    GLOBAL.TheSim:QueryServer(url, function(result, isSuccessful, resultCode)
        local resultLen = string.len(result)
        if isSuccessful and resultLen > 1 and resultCode == 200 then
            local blacklist = GLOBAL.json.decode(result)
            if type(blacklist) == "table" then
                success = true
                print("使用节点："..url)
                local sy_blacklist = GLOBAL.TheNet:GetBlacklist();
                clear(sy_blacklist) --清理旧黑名单
                for i, o in pairs(blacklist) do
                    if (o.netid ~= nil and string.len(o.netid) > 0) or (o.userid ~= nil and string.len(o.userid) > 0) then
                        ban(sy_blacklist, o.netid, o.userid, o.timestamp)
                    end
                end
                repair(sy_blacklist)
                GLOBAL.TheNet:SetBlacklist(sy_blacklist);
                print("已封禁"..#blacklist.."位")
            end
        end
    end, "GET")
    
    local timeout = 5 -- 默认为 5 秒
    local timer = GLOBAL.TheWorld:DoTaskInTime(timeout, function()
        if not success then
            print("节点请求超时："..url)
            -- 请求超时，尝试请求下一个网址
            requestUrl(urls, index + 1)
        end
    end)
end

AddPrefabPostInit("world", function(inst)
    inst:DoTaskInTime(0, function()
        requestUrl(urls, 1) -- 从第一个网址开始请求
    end)
end)
