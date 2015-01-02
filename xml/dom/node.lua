--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass    = require(RP..'lib.upperclass')
local NamedNodeMap  = require(RP..'dom.namednodemap')
local NodeList      = require(RP..'dom.nodelist')

--
-- Define class
--
local Node = upperclass:define('Node')

--
-- Nodetype
--
property : nodeType { 
    nil; 
    get='public'; 
    set='private'
}

--
-- nodeDesc
-- set on __construct()
--
property : nodeDesc { nil ; get='public' ; set='private' }

--
-- Attributes
--
property : attributes { NamedNodeMap() ; get='public' ; set='private' }

--
-- ChildNodes
--
property : childNodes { NodeList() ; get='public' ; set='private' }

--
-- ParentNode
--
property : parentNode { nil ; get='public' ; set='public' }

--
-- Id
--
property : id { nil ; get='public' ; set='public' }

--
-- Firstchild
--
property : firstChild { nil ; get='public' ; set='private' }

--
-- LastChild
--
property : lastChild { nil ; get='public' ; set='private' }

--
-- Class Construct
--
function private:__construct(NODE_TYPE, NODE_DESCRIPTION)
    self.nodeType = NODE_TYPE
    self.nodeDesc = NODE_DESCRIPTION
end

--
-- Index metamethod
--
function private:__index(KEY, MEMBER_LOOKUP)
    if KEY == "blah" then
        print("Special COndition")
    else
        return MEMBER_LOOKUP.current_value
    end
end

--
-- Newindex metamethod
--
function private:__newindex(TABLE, KEY, VALUE, MEMBER_LOOKUP)
end

--
-- Appendchild
--
function public:appendChild(DOM_NODE)
    local newNode = self.childNodes:addItem(DOM_NODE)
    newNode.parentNode = self
    return newNode
end

--
-- RemoveChild
--
function public:removeChild(DOM_NODE)
    local removedNode = self.childNodes.removeItem(DOM_NODE)
    
    return removedNode
end

--
-- SetAttribute
--
function public:setAttribute(ATTR_NAME, ATTR_VALUE)
    local attribute = Attribute(ATTR_NAME, ATTR_VALUE)        
    self.attributes:setNamedItem(attribute)
end

--
-- RemoveAttribute
--
function public:removeAttribute(ATTR_NAME)
    local attribute = self.attributes.removeNamedItem(self.attributes.getNamedItem(pAttributeName).nodeName)
        
    libxml.dom.hasChanged = true
    return attribute        
end
    
--
-- GetAttribute
--
function public:getAttribute(ATTR_NAME)
    if self.attributes ~= nil then
        local attribute = self.attributes.getNamedItem(pAttributeName)        
        if attribute == nil then
            return nil
        else
            return attribute.nodeValue
        end
    else
        return nil
    end
end
    
--
-- HasChildNodes
--
function public:hasChildNodes()
    if self.childNodes ~= nil and self.childNodes.length >= 1 then
        return true
    else
        return false
    end
end
    
--
-- HasAttributes
--
function public:hasAttributes()
    if self.attributes ~= nil and self.attributes.length > 0 then
        return true
    else
        return false
    end
end

--
-- HasAttribute
--
function public:hasAttribute(ATTR_NAME)
    local response = self.getAttribute(pAttribute)        
    if response ~= nil then
        return true
    else
        return false
    end
end

--
-- HasClass
--
function public:hasClass(CLASS_NAME)
    local classes = libxml.split( self.getAttribute("class") or "", "%s" )
    for a=1, #classes do
        if pClass == classes[a] then
            return true
        end
    end
    return false
end
    
--
-- GetElementById
--
function public:getElementById(ID)
    return libxml.dom.getElementById(self, pId)
end

--
-- GetElementsByTagName
--
function public:getElementsByTagName(TAG_NAME)
    return libxml.dom.getElementsByTagName(self, pTagName)
end
    
--
-- getElementsByClassName
--
function public:getElementsByClassName(CLASS_NAME)
    return libxml.dom.getElementsByClassName(self, pClassName)
end

return upperclass:compile(Node, {ALLOW_INSTANCE = true, ALLOW_STATIC = false, STRICT_TYPES = true})