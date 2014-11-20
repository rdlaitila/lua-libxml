libxml.dom             = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.init()
    -- NODE TYPE DEFINITIONS
    libxml.dom.nodeTypes         = {}
    libxml.dom.nodeTypes[1]        =  "ELEMENT_NODE" 
    libxml.dom.nodeTypes[2]        =  "ATTRIBUTE_NODE"
    libxml.dom.nodeTypes[3]        =  "TEXT_NODE"
    libxml.dom.nodeTypes[4]        =  "CDATA_SECTION_NODE"
    libxml.dom.nodeTypes[5]        =  "ENTITY_REFERENCE_NODE"
    libxml.dom.nodeTypes[6]        =  "ENTITY_NODE"
    libxml.dom.nodeTypes[7]        =  "PROCESSING_INSTRUCTION_NODE"
    libxml.dom.nodeTypes[8]        =  "COMMENT_NODE"
    libxml.dom.nodeTypes[9]        =  "DOCUMENT_NODE" 
    libxml.dom.nodeTypes[10]    =  "DOCUMENT_TYPE_NODE"
    libxml.dom.nodeTypes[11]    =  "DOCUMENT_FRAGMENT_NODE"
    libxml.dom.nodeTypes[12]    =  "NOTATION_NODE"
    libxml.dom.nodeTypes[13]    =  "NODE_LIST"    
    
    -- DOM DEPENDENCIES
    require(libxml.require_path .. "dom//objects//libxml_dom_domparser")
    require(libxml.require_path .. "dom//objects//libxml_dom_node")
    require(libxml.require_path .. "dom//objects//libxml_dom_nodelist")
    require(libxml.require_path .. "dom//objects//libxml_dom_namednodemap")
    require(libxml.require_path .. "dom//objects//libxml_dom_document")
    require(libxml.require_path .. "dom//objects//libxml_dom_element")
    require(libxml.require_path .. "dom//objects//libxml_dom_attribute")
    require(libxml.require_path .. "dom//objects//libxml_dom_cdata")
    require(libxml.require_path .. "dom//objects//libxml_dom_text")
    require(libxml.require_path .. "dom//objects//libxml_dom_comment")    
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.domTreeDump(pRootDomNode)
    local indent = "--"
    local indent_count = 0
    
    libxml.throw(1, "calling libxml.dom.domTreeDump()")
    print("-----------------------------------------")
    recurseOutput = function(pDomNode)
        local curr_indent = ""
        for a=1, indent_count do curr_indent = curr_indent .. indent end
        
        print(curr_indent .. tostring(pDomNode.nodeDesc))    
        if pDomNode.hasChildNodes() then
            indent_count = indent_count + 1
            for b=1, pDomNode.childNodes.length do
                recurseOutput(pDomNode.childNodes[b])
            end
            indent_count = indent_count - 1
        end                
    end    
    recurseOutput(pRootDomNode)
    print("-----------------------------------------")
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.searchDomPath(pObjRef, pTagName)
    local self = pObjRef
    local tag  = pTagName    
    local nodeCollec = libxml.dom.createNodeList()
    
    if self.nodeType == 1 or self.nodeType == 9 then
        if self.hasChildNodes() then            
            for a=1, self.childNodes.length do
                local child = self.childNodes[a]
                --print(a .. " searching ".. tostring(child).. " for ".. tostring(tag) .."")
                if child.tagName == tag then
                    --print("tag match!")
                    nodeCollec.addItem(child)
                end
            end
        end
    end
    
    if #nodeCollec.nodes > 1 then
        return nodeCollec
    elseif #nodeCollec.nodes == 1 then
        return nodeCollec[1]
    else
        libxml.throw(3, "libxml.dom.searchDomPath()::No node with tagName: " .. tostring(tag))
        return libxml.dom.createNode(1)
    end    
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.searchDomXPath(pXPath)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.getAllElements(pObjRef)
    local self = pObjRef
    local returnList = libxml.dom.createNodeList()
    
    recurse = function(pSearchNode)    
        if pSearchNode.nodeType == 1 then returnList.addItem( pSearchNode ) end
        if pSearchNode.hasChildNodes() then
            for a=1, pSearchNode.childNodes.length do
                recurse(pSearchNode.childNodes[a])
            end
        end
    end
    recurse(self)
    return returnList
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.getElementById(pObjRef, pId)
    local self = pObjRef
    local returnnode = nil
    local stopsearch = false
    local checkId = nil
    local search = {}
    search = function(pSearchNode, pSearchId)
        if stopsearch == false then
            if self.getAttribute ~= nil then 
                checkId = pSearchNode.getAttribute("id") 
            end
            if checkId ~= nil and checkId == pSearchId  then
                returnnode = pSearchNode
                stopsearch = true
            else
                if pSearchNode.hasChildNodes() then
                    for i=1, pSearchNode.childNodes.length do
                        if pSearchNode.childNodes[i].getAttribute ~= nil then
                            search(pSearchNode.childNodes[i], pId)
                        end
                    end
                end                
            end
        end
    end    
    search(self, pId)
    return returnnode
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.getElementsByTagName(pObjRef, pTagName)    
    local self                 = pObjRef
    local returnnodelist     = libxml.dom.createNodeList()
    local stopsearch         = false
    local checkTag             = nil
    local search             = {}
    
    search = function(pSearchNode, pSearchTag)        
        if pSearchNode ~= nil then
            if pSearchNode.tagName ~= nil then
                checkTag = pSearchNode.tagName
                if checkTag ~= nil and checkTag == pSearchTag  then
                    returnnodelist.addItem(pSearchNode)
                end
            end                
            if pSearchNode.hasChildNodes ~= nil then
                if pSearchNode.hasChildNodes() then
                    for i=1, pSearchNode.childNodes.length do
                        search(pSearchNode.childNodes[i], pTagName)
                    end                
                end
            end
        end
    end        
    search(self, pTagName)
    
    return returnnodelist
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.getElementsByClassName(pObjRef, pClassName)
    local self = pObjRef
    local returnnodelist = libxml.dom.createNodeList()
    local stopsearch = false
    local checkClass = nil
    local search = {}        
    search = function(pSearchNode, pSearchClass)
        if stopsearch == false then
            if pSearchNode.getAttribute ~= nil then
                checkClass = pSearchNode.getAttribute("class")
                if checkClass ~= nil then
                    for class in string.gmatch(checkClass, "[%a%d]+") do
                        if class ~= nil and libxml.trim(class) == libxml.trim(pSearchClass)  then                    
                            returnnodelist.addItem(pSearchNode)
                        end
                    end
                end
            end            
            if pSearchNode.hasChildNodes() then
                for i=1, pSearchNode.childNodes.length do
                    search(pSearchNode.childNodes[i], pClassName)
                end                
            end
        end
    end        
    search(self, pClassName)
    return returnnodelist
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function libxml.dom.getElementsByAttributeName( pObjRef, pAttrName )
    local self = pObjRef
    local returnnodelist = libxml.dom.createNodeList()
    local stopsearch = false
    local checkAttr = nil
    local search = {}        
    search = function(pSearchNode, pSearchAttr)
        if stopsearch == false then
            if pSearchNode.getAttribute ~= nil then
                checkAttr = pSearchNode.getAttribute(pAttrName)
                if checkAttr ~= nil  then                    
                    returnnodelist.addItem(pSearchNode)
                end
            end
            
            if pSearchNode.hasChildNodes() then
                for i=1, pSearchNode.childNodes.length do
                    search(pSearchNode.childNodes[i], pAttrName)
                end                
            end
        end
    end        
    search(self, pAttrName)
    return returnnodelist
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
libxml.dom.init()