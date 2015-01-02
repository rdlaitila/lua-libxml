--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass = require(RP..'lib.upperclass')


--
-- Define class
--
local libxml = upperclass:define("libxml")

--
-- Holds our utils class
--
property : utils { 
    require(RP.."lib.utils"); 
    get='public'; 
    set='nobody' 
}

--
-- Holds our dom class
--
property : dom { 
    {
        Node        = require(RP..'dom.node'),
        DOMParser   = require(RP..'dom.domparser')
    }; 
    get='public'; 
    set='nobody' 
}

--
-- Loads an XML document
--
function public:load(XML_FILE)
    local parser = self.dom.DOMParser()
    
    if love ~= nil then
        return parser:parseFromString( love.filesystem.read(XML_FILE, all) )
    else
        local f = io.open(XML_FILE, "rb")
        local content = f:read("*all")
        f:close()
        return parser:parseFromString( content )
    end
end

-- 
-- Saves an XML document
--
function public:save(XML_DOM, FILE_PATH)
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

-- 
-- Compile Class
--
return upperclass:compile(libxml)