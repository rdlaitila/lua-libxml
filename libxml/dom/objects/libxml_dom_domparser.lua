-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.createDomParser()
    local self = {}
    
    --===================================================================
    -- PROPERTIES                                                       =
    --===================================================================
    self.parsedebug         = false
    ---------------------------------------------------------------------    
    self.srcText            = nil
    ---------------------------------------------------------------------    
    self.openNodes          = {}    
    ---------------------------------------------------------------------        
    self.textNodeCharBuffer = nil
    ---------------------------------------------------------------------
    self.document           = libxml.dom.createDocument()
    ---------------------------------------------------------------------
    self.lastNodeReference  = nil
    ---------------------------------------------------------------------    
    
    --====================================================================
    -- METHODS                                                             =    
    --====================================================================    
    self.parseFromString = function(pSrcText)
        local index = 1
        local char = function(charIndex) return  self.srcText:sub(charIndex,charIndex) end    
        self.srcText = string.gsub(pSrcText, "[\t]", "")
        --self.srcText = string.gsub(pSrcText, "[\r\n]", "")        
        while index <= self.srcText:len() do            
            if char(index) == "<" then                
                if textNodeCharBuffer ~= nil then                    
                    self.openNode(index, "text")                                 
                elseif char(index + 1) == "/" then                    
                    index = self.closeNode(index)                
                elseif self.srcText:sub(index+1, index+3) == "!--" then                    
                    index = self.openNode(index, "comment")
                elseif self.srcText:sub(index+1, index+8) == "![CDATA[" then                    
                    index = self.openNode(index, "CDATASection")                    
                else                    
                    index = self.openNode(index, "tag")
                end
            else                
                if textNodeCharBuffer == nil then textNodeCharBuffer = "" end
                textNodeCharBuffer = textNodeCharBuffer .. char(index)                
                index = index +1
            end            
        end                
        
        return self.document
    end    
    ---------------------------------------------------------------------        
    self.openNode = function(pIndex, pType)
        local nI = nil --nodeIndex
        local rI = pIndex --returnIndex        
        -----------------------------------------------------------------
        if pType == "tag" then            
            local tagContent = string.match(self.srcText, "<(.-)>", pIndex)
            local tagName = libxml.trim(string.match(tagContent, "([%a%d]+)%s?", 1))            
            
            table.insert(self.openNodes, libxml.dom.createElement(tagName))            
            nI = #self.openNodes
            
            -- get attributes from tagContent            
            for matchedAttr in string.gmatch(string.sub(tagContent,tagName:len()+1), "(.-=\".-\")") do            
                for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do
                    self.openNodes[nI].setAttribute(libxml.trim(attr), libxml.trim(value))                    
                end                
            end
            
            -- append new node to document
            if nI == 1 then                
                self.lastNodeReference = self.document.appendChild(self.openNodes[nI])                    
            else                
                self.lastNodeReference = self.lastNodeReference.appendChild(self.openNodes[nI])                
            end            
            
            -- check to see if the tag is self closing, else check against self.selfCloseElements            
            if string.match(tagContent, "/$") then                
                self.openNodes[nI].isSelfClosing = true
                self.closeNode(pIndex)
                nI = #self.openNodes
            end
            
            rI = rI + string.match(self.srcText, "(<.->)", pIndex):len()
            
            return rI            
        -----------------------------------------------------------------
        elseif pType == "comment" then
            local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", pIndex)                        
            
            -- Check for lastNodeReference being nil
            -- if lastNodeReference is nil, we may be encountering 
            -- a top-level comment, which we will have to drop
            if self.lastNodeReference ~= nil then
                local newTextNode = self.lastNodeReference.appendChild(libxml.dom.createCommentNodeObj(libxml.trim(commentText)))            
            end
            
            rI = pIndex + string.match(self.srcText, "(<!%-%-.-%-%->)", pIndex):len()
            return rI
        -----------------------------------------------------------------
        elseif pType == "text" then
            local text = libxml.trim(textNodeCharBuffer)
            if text ~= "" then
                self.lastNodeReference.appendChild(libxml.dom.createText(text))            
            end        
            textNodeCharBuffer = nil            
        -----------------------------------------------------------------
        elseif pType == "CDATASection" then
            local cdataText = string.match(self.srcText, "<!%[CDATA%[(.-)%]%]>", pIndex)            
            local newNode = libxml.dom.createCharacterData(cdataText)                                                
            self.lastNodeReference.appendChild(newNode)            
            return pIndex + string.match(self.srcText, "(<!%[CDATA%[.-%]%]>)", pIndex):len()
        end
        -----------------------------------------------------------------
    end
    ---------------------------------------------------------------------    
    self.closeNode = function(pIndex)        
        local tagname = libxml.trim(string.match(self.srcText, "/?([%a%d]+)%s?", pIndex))        
        local nI = #self.openNodes
        if libxml.trim(self.openNodes[nI].tagName:upper()) == libxml.trim(tagname):upper() then            
            table.remove(self.openNodes, #self.openNodes)            
            self.lastNodeReference = self.lastNodeReference.parentNode
        end            
        return pIndex + string.match(self.srcText, "(<.->)", pIndex):len()
    end        
    ---------------------------------------------------------------------        
    
    return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::