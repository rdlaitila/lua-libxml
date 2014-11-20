function libxml.dom.createDocument()    
    local self = libxml.dom.createNode(9)
    
    --===================================================================
    -- PROPERTIES                                                       =
    --===================================================================    
    self.nodeName             = "#document"    
    ---------------------------------------------------------------------    
    
    --===================================================================
    -- MUTATORS                                                         =
    --===================================================================
    self.mutators.getDocumentElement = function()
        return self.firstChild
    end
    ---------------------------------------------------------------------
    
    --====================================================================
    -- METHODS                                                             =    
    --====================================================================
    self.createElement         = function(pTagName)
        local elementNodeObj = libxml.dom.createElementNodeObj(pTagName)        
        return elementNodeObj
    end
    ---------------------------------------------------------------------
    self.createAttribute     = function(pAttributeName)
        local attributeNode = libxml.dom.createAttributeNodeObj(pAttributeName)
        return attributeNode
    end
    ---------------------------------------------------------------------
    self.createTextNode      = function(pText)
        local textNode = libxml.dom.createTextNodeObj(pText)
        return textNode
    end
    ---------------------------------------------------------------------
    self.createCDATASection = function(pCDATAText)
        local CDATASectionNode = libxml.dom.createCharacterDataNodeObj(pCDATAText)
        return CDATASectionNode
    end
    ---------------------------------------------------------------------
    self.createComment         = function(pCommentText)
        local commentNode = libxml.dom.createCommentNodeObj(pCommentText)
        return commentNode
    end    
    ---------------------------------------------------------------------    
    
    return self
end