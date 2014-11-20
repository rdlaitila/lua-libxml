function libxml.dom.createElement(pTagName)
    local tagName = libxml.trim(pTagName:lower())
    self = libxml.dom.createNode(1)
    
    --===================================================================
    -- PROPERTIES                                                       =
    --===================================================================        
    self.nodeName         = string.upper(pTagName)
    ---------------------------------------------------------------------
    self.tagName         = libxml.trim(pTagName)
    ---------------------------------------------------------------------    
    self.isSelfClosing     = false
    ---------------------------------------------------------------------    
        
    return self
end