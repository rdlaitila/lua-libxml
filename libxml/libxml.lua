-- Generate global variable to hold our path
LIBXML_REQUIRE_PATH = (...):match("(.-)[^%.]+$")

-- Require upperclass dependency 
LIBXML_UPPERCLASS = require(LIBXML_REQUIRE_PATH .. 'upperclass') 

--
-- Class libxml
--
local libxml = LIBXML_UPPERCLASS:define("libxml")

--
-- Holds our utils class
--
property : utils { require(LIBXML_REQUIRE_PATH .. 'utils.ns_libxml_utils') ; get='public' ; set='nobody' }

--
-- Holds our dom class
--
property : dom { require(LIBXML_REQUIRE_PATH .. 'dom.ns_libxml_dom') ; get='public' ; set='nobody' }

--
-- Loads an XML document
--
function public:load(XML_FILE)
    local parser = self.dom.createDomParser()
    
    if love ~= nil then
        return parser.parseFromString( love.filesystem.read(XML_FILE, all) )
    else
        local f = io.open(XML_FILE, "rb")
        local content = f:read("*all")
        f:close()
        return parser.parseFromString( content )
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
-- Return class
--
return LIBXML_UPPERCLASS:compile(libxml, {ALLOW_INSTANCE = false, ALLOW_STATIC = true, STRICT_TYPES = true})