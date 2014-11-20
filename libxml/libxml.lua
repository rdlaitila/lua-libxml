-- Filename: libxml
-- Author: Regan Laitila
-- Date: N/A
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
libxml = {} -- :D
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.init()    

    -- SET COMMON CONFIGS
    libxml.require_path         = "libxml//"    
    libxml.debug                 = false
    
    -- BASE DEPENDENCIES    
    require(libxml.require_path .. "dom//ns_libxml_dom")
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.load(pObj)
    local parser = libxml.dom.createDomParser()
    
    if love ~= nil then
        return parser.parseFromString( love.filesystem.read(pObj, all) )
    else
        local f = io.open(pObj, "rb")
        local content = f:read("*all")
        f:close()
        return parser.parseFromString( content )
    end
    
    return parser.parseFromString(  ) 
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.save(pDomObj, pFilePath)
    local xmltext     = ""
    local indentc     = 0
    local indent     = function() 
        local i = ""
        for a=1, indentc do  
            i = i .. "    " 
        end
        return i
    end    
    recurseOutput = function(pDomNode)                
        if pDomNode.nodeType == 1 or pDomNode.nodeType == 9 then
            local attrstring     = ""
            local tagName        = tostring(libxml.trim(pDomNode.tagName))
            if pDomNode.hasAttributes() then
                attrstring = ""
                for a=1, pDomNode.attributes.length do
                    attrstring = attrstring .. " " .. pDomNode.attributes[a].name .. "=\"" .. pDomNode.attributes[a].value .. "\""
                end
            end
            if pDomNode.isSelfClosing then
                xmltext = xmltext .. indent() .. "<" .. tagName .. attrstring .. " />\n"
            else
                xmltext = xmltext .. indent() .. "<" .. tagName .. attrstring .. ">\n"
            end
            if pDomNode.hasChildNodes() then
                indentc = indentc + 1
                for b=1, pDomNode.childNodes.length do
                    recurseOutput(pDomNode.childNodes[b])
                end
                indentc = indentc -1
            end
            if pDomNode.isSelfClosing ~= true then
                xmltext = xmltext .. indent() .. "</" .. tagName .. ">\n"
            end
        elseif pDomNode.nodeType == 3 or pDomNode.nodeType == 4 then
            if pDomNode.nodeType == 3 then
                local text = pDomNode.data
                if text:len() > 20 then
                    xmltext = xmltext .. indent() .. tostring(pDomNode.data) .. "\n"                    
                else
                    xmltext = string.gsub(xmltext, "[\n]$", "")
                    xmltext = xmltext .. libxml.trim(tostring(pDomNode.data))                    
                end
            elseif pDomNode.nodeType == 4 then
                local text = pDomNode.data
                if text:len() > 20 then
                    xmltext = xmltext .. indent() ..  "<![CDATA[ \n" .. indent() .. tostring(pDomNode.data) .. "\n" .. indent() ..  "]]>\n"                    
                else                    
                    xmltext = xmltext .. indent() .. "<![CDATA[ " .. tostring(pDomNode.data) .. " ]]>\n"
                end
            end
        end        
    end    
    recurseOutput(pDomObj.documentElement)
    if pFilePath ~= nil then
        love.filesystem.write( pFilePath, xmltext, all )
    end
    return xmltext
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.throw(pErrorType, pErrorText)
    local errorTypes = {}
    errorTypes[1] = "INFORMATION"
    errorTypes[2] = "WARNING"
    errorTypes[3] = "ERROR"
    errorTypes[4] = "FATAL ERROR"
    
    print("libxml::"..errorTypes[pErrorType] .. "::"..pErrorText)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.sleep(n)  -- seconds
    local clock = os.clock
    local t0 = clock()
    while clock() - t0 <= n do end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.trim(s)
    if s ~= nil then
        return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
    end    
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- tserial v1.23, a simple table serializer which turns tables into Lua script
-- by Taehl (SelfMadeSpirit@gmail.com)

-- Usage: table = libxml.tserial.unpack( libxml.tserial.pack(table) )
libxml.tserial = {}
function libxml.tserial.pack(t)
    assert(type(t) == "table", "Can only tserial.pack tables.")
    local s = "{"
    for k, v in pairs(t) do
        local tk, tv = type(k), type(v)
        if tk == "boolean" then k = k and "[true]" or "[false]"
        elseif tk == "string" then if string.find(k, "[%c%p%s]") then k = '["'..k..'"]' end
        elseif tk == "number" then k = "["..k.."]"
        elseif tk == "table" then k = "["..libxml.tserial.pack(k).."]"
        else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
        end
        if tv == "boolean" then v = v and "true" or "false"
        elseif tv == "string" then v = string.format("%q", v)
        elseif tv == "number" then    -- no change needed
        elseif tv == "table" then v = libxml.tserial.pack(v)
        else error("Attempted to Tserialize a table with an invalid value: "..tostring(v))
        end
        s = s..k.."="..v..","
    end
    return s.."}"
end

function libxml.tserial.unpack(s)
    assert(type(s) == "string", "Can only tserial.unpack strings.")
    assert(loadstring("libxml.tserial.table="..s))()
    local t = libxml.tserial.table
    libxml.tserial.table = nil
    return t
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
module(..., package.seeall);
 
pcall(require,"BinDecHex")
local Hex2Dec, BMOr, BMAnd, Dec2Hex
if(BinDecHex)then
    Hex2Dec, BMOr, BMAnd, Dec2Hex = BinDecHex.Hex2Dec, BinDecHex.BMOr, BinDecHex.BMAnd, BinDecHex.Dec2Hex
end 
 
--- Returns a UUID/GUID in string format - this is a "random"-UUID/GUID at best or at least a fancy random string which looks like a UUID/GUID. - will use BinDecHex module if present to adhere to proper UUID/GUID format according to RFC4122v4.
--@Usage after require("UUID"), then UUID.UUID() will return a 36-character string with a new GUID/UUID.
--@Return String - new 36 character UUID/GUID-complient format according to RFC4122v4.
function libxml.UUID()
    local chars = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
    local uuid = {[9]="-",[14]="-",[15]="4",[19]="-",[24]="-"}
    local r, index
    for i = 1,36 do
        if(uuid[i]==nil)then
            -- r = 0 | Math.random()*16;
            r = math.random (16)
            if(i == 20 and BinDecHex)then 
                -- (r & 0x3) | 0x8
                index = tonumber(Hex2Dec(BMOr(BMAnd(Dec2Hex(r), Dec2Hex(3)), Dec2Hex(8))))
                if(index < 1 or index > 16)then 
                    print("WARNING Index-19:",index)
                    return UUID() -- should never happen - just try again if it does ;-)
                end
            else
                index = r
            end
            uuid[i] = chars[index]
        end
    end
    return table.concat(uuid)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.literalize(str)
    text, occur =  str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)        
        return "%" .. c 
    end)
    return libxml.trim(text)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.trace (event, line, delay)
    local a = debug.getinfo(2).name
    local b = debug.getinfo(2).source
    print(tostring(a) .. ":::" .. tostring(b))
    libxml.sleep(delay or .05)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
libxml.init()
