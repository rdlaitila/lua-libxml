local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMDocument   = require(LIBXML_REQUIRE_PATH..'dom.document')
local DOMText       = require(LIBXML_REQUIRE_PATH..'dom.text')
local DOMElement    = require(LIBXML_REQUIRE_PATH..'dom.element')
local DOMComment    = require(LIBXML_REQUIRE_PATH..'dom.comment')

--
-- Define class
--
local DOMParser = upperclass:define('DOMParser')

--
-- Parse Debug
--
public.parsedebug = false

--
-- Source Text
--
private.srcText = ""

--
-- Open Nodes
--
private.openNodes = {}

--
-- Text Node Character Buffer
--
private.textNodeCharBuffer = ""

--
-- DOM Document
--
private.document = DOMDocument()

--
-- Last Node Reference
--
private.lastNodeReference = nil

--
-- Class Constructor
--
function private:__construct()    
    self.lastNodeReference = self.document      
end

--
-- ParseFromString
--
function public:parseFromString(XML_STRING)    
    local charindex = 1
    
    self.srcText = string.gsub(XML_STRING, "[\t]", "")
    
    --self.srcText = string.gsub(pSrcText, "[\r\n]", "")        
    
    while charindex <= self.srcText:len() do        
        if self:char(charindex) == "<" then                
            if self.textNodeCharBuffer:len() > 0 then                    
                self:openNode(charindex, "text")                                 
            elseif self:char(charindex + 1) == "/" then                    
                charindex = self:closeNode(charindex)                
            elseif self.srcText:sub(charindex+1, charindex+3) == "!--" then                    
                charindex = self:openNode(charindex, "comment")
            elseif self.srcText:sub(charindex+1, charindex+8) == "![CDATA[" then                    
                charindex = self:openNode(charindex, "CDATASection")                    
            else                    
                charindex = self:openNode(charindex, "tag")
            end
        else
            self.textNodeCharBuffer = self.textNodeCharBuffer .. self:char(charindex)                
            charindex = charindex +1
        end            
    end                
        
    return self.document
end

--
-- OpenNode
--
function private:openNode(NODE_INDEX, NODE_TYPE)    
    if NODE_TYPE == "tag" then            
        local tagContent = string.match(self.srcText, "<(.-)>", NODE_INDEX)
        local tagName = utils:trim(string.match(tagContent, "([%a%d]+)%s?", 1))            
            
        table.insert(self.openNodes, DOMElement(tagName))                    
            
        -- get attributes from tagContent            
        for matchedAttr in string.gmatch(string.sub(tagContent,tagName:len()+1), "(.-=\".-\")") do            
            for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do                
                self.openNodes[#self.openNodes]:setAttribute(utils:trim(attr), utils:trim(value))                    
            end                
        end
            
        self.lastNodeReference = self.lastNodeReference:appendChild(self.openNodes[#self.openNodes])                        
            
        -- check to see if the tag is self closing, else check against self.selfCloseElements            
        if string.match(tagContent, "/$") then                
            self.openNodes[#self.openNodes].isSelfClosing = true
            self.closeNode(NODE_INDEX)            
        end
        
        return NODE_INDEX + string.match(self.srcText, "(<.->)", NODE_INDEX):len()    
    elseif NODE_TYPE == "comment" then
        local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", pIndex)                        
          
        -- Check for lastNodeReference being nil
        -- if lastNodeReference is nil, we may be encountering 
        -- a top-level comment, which we will have to drop
        if self.lastNodeReference ~= nil then
            local newTextNode = self.lastNodeReference:appendChild(DOMComment(utils:trim(commentText)))            
        end
        
        return NODE_INDEX + string.match(self.srcText, "(<!%-%-.-%-%->)", NODE_INDEX):len()
    elseif NODE_TYPE == "text" then
        local text = utils:trim(self.textNodeCharBuffer)        
        self.lastNodeReference:appendChild(DOMText(text))                    
        self.textNodeCharBuffer = ""               
    elseif NODE_TYPE == "CDATASection" then
        local cdataText = string.match(self.srcText, "<!%[CDATA%[(.-)%]%]>", pIndex)            
        local newNode = libxml.dom.createCharacterData(cdataText)                                                
        self.lastNodeReference:appendChild(newNode)            
        return NODE_INDEX + string.match(self.srcText, "(<!%[CDATA%[.-%]%]>)", NODE_INDEX):len()
    end
    -----------------------------------------------------------------
end

--
-- CloseNode
--
function private:closeNode(NODE_INDEX)
    local tagname = utils:trim(string.match(self.srcText, "/?([%a%d]+)%s?", NODE_INDEX))            
    if utils:trim(self.openNodes[#self.openNodes].tagName:upper()) == utils:trim(tagname):upper() then            
        table.remove(self.openNodes, #self.openNodes)            
        self.lastNodeReference = self.lastNodeReference.parentNode
    end            
    return NODE_INDEX + string.match(self.srcText, "(<.->)", NODE_INDEX):len()
end

--
-- Char
--
function private:char(INDEX)
    return self.srcText:sub(INDEX, INDEX)
end

--
-- Compile
--
return upperclass:compile(DOMParser)