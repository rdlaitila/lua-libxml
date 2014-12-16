--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass    = require(RP..'lib.upperclass')
local utils         = require(RP..'lib.utils')
local Document      = require(RP..'dom.document')
local Text          = require(RP..'dom.text')

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
private.document = Document()

--
-- Last Node Reference
--
private.lastNodeReference = {}

--
-- Class Constructor
--
function private:__construct()  
    print(self.textNodeCharBuffer)
end

--
-- ParseFromString
--
function public:parseFromString(XML_STRING)
    local charindex = 1
    
    self.srcText = string.gsub(XML_STRING, "[\t]", "")
    
    --self.srcText = string.gsub(pSrcText, "[\r\n]", "")        
    
    while charindex <= self.srcText:len() do   
        print(charindex)
        if self:char(charindex) == "<" then                
            if self.textNodeCharBuffer ~= nil then                    
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
            if self.textNodeCharBuffer == nil then self.textNodeCharBuffer = "" end
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
    local nI = nil --nodeIndex
    local rI = NODE_INDEX --returnIndex        
    -----------------------------------------------------------------
    if NODE_TYPE == "tag" then            
        local tagContent = string.match(self.srcText, "<(.-)>", NODE_INDEX)
        local tagName = libxml.trim(string.match(tagContent, "([%a%d]+)%s?", 1))            
            
        table.insert(self.openNodes, libxml.dom.createElement(tagName))                    
            
        -- get attributes from tagContent            
        for matchedAttr in string.gmatch(string.sub(tagContent,tagName:len()+1), "(.-=\".-\")") do            
            for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do
                self.openNodes[#self.openNodes].setAttribute(libxml.trim(attr), libxml.trim(value))                    
            end                
        end
            
        -- append new node to document
        if #self.openNodes == 1 then                
            self.lastNodeReference = self.document.appendChild(self.openNodes[#self.openNodes])                    
        else                
            self.lastNodeReference = self.lastNodeReference.appendChild(self.openNodes[#self.openNodes])                
        end            
            
        -- check to see if the tag is self closing, else check against self.selfCloseElements            
        if string.match(tagContent, "/$") then                
            self.openNodes[#self.openNodes].isSelfClosing = true
            self.closeNode(NODE_INDEX)            
        end
        
        return NODE_INDEX + string.match(self.srcText, "(<.->)", NODE_INDEX):len()
    -----------------------------------------------------------------
    elseif NODE_TYPE == "comment" then
        local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", pIndex)                        
          
        -- Check for lastNodeReference being nil
        -- if lastNodeReference is nil, we may be encountering 
        -- a top-level comment, which we will have to drop
        if self.lastNodeReference ~= nil then
            local newTextNode = self.lastNodeReference.appendChild(libxml.dom.createCommentNodeObj(utils:trim(commentText)))            
        end
        
        rI = pIndex + string.match(self.srcText, "(<!%-%-.-%-%->)", pIndex):len()
        return rI
    -----------------------------------------------------------------
    elseif NODE_TYPE == "text" then
        local text = utils:trim(textNodeCharBuffer)
        if text ~= "" then
            self.lastNodeReference.appendChild(Text(text))            
        end        
        textNodeCharBuffer = ""            
    -----------------------------------------------------------------
    elseif NODE_TYPE == "CDATASection" then
        local cdataText = string.match(self.srcText, "<!%[CDATA%[(.-)%]%]>", pIndex)            
        local newNode = libxml.dom.createCharacterData(cdataText)                                                
        self.lastNodeReference.appendChild(newNode)            
        return pIndex + string.match(self.srcText, "(<!%[CDATA%[.-%]%]>)", pIndex):len()
    end
    -----------------------------------------------------------------
end

--
-- CloseNode
--
function private:closeNode(NODE_INDEX)
    local tagname = libxml.trim(string.match(self.srcText, "/?([%a%d]+)%s?", pIndex))        
    local nI = #self.openNodes
    if libxml.trim(self.openNodes[nI].tagName:upper()) == libxml.trim(tagname):upper() then            
        table.remove(self.openNodes, #self.openNodes)            
        self.lastNodeReference = self.lastNodeReference.parentNode
    end            
    return pIndex + string.match(self.srcText, "(<.->)", pIndex):len()
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
return upperclass:compile(DOMParser, {ALLOW_INSTANCE = true, ALLOW_STATIC = false, STRICT_TYPES = true})