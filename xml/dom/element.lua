local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode       = require(LIBXML_REQUIRE_PATH..'dom.node')
local DOMNodeList   = require(LIBXML_REQUIRE_PATH..'dom.nodelist')
local DOMAttribute  = require(LIBXML_REQUIRE_PATH..'dom.attribute')

--
-- Define class
--
local Element = upperclass:define("DOMElement", DOMNode)

--
-- Is this element a self closing tag
--
property : isSelfClosing {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- Returns the type information associated with the element
--
property : schemaTypeInfo {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Class constructor
--
function private:__construct(TAGNAME)
    self:__constructparent(1)
    self.nodeName = utils:trim(TAGNAME)    
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'tagName' then
        return self.nodeName
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Returns the value of an attribute
--
function public:getAttribute(ATTRIBUTE_NAME)
    local attrnode = self:getAttributeNode(ATTRIBUTE_NAME)
    if attrnode ~= nil then
        return attrnode.value
    end
end

--
-- Returns the value of an attribute (with a namespace)
--
function public:getAttributeNS()
    error("Method Not Yet Implimented")
end

--
-- Returns an attribute node as an Attribute object
--
function public:getAttributeNode(ATTRIBUTE_NAME) 
    for a=1, self.attributes.length do
        if self.attributes[a].name == utils:trim(ATTRIBUTE_NAME) then
            return self.attributes[a]
        end
    end
end

--
-- Returns an attribute node (with a namespace) as an Attribute object
--
function public:getAttributeNodeNS()
    error("Method Not Yet Implimented")
end

--
-- Adds a new attribute
--
function public:setAttribute(ATTRIBUTE_NAME, ATTRIBUTE_VALUE)
    for a=1, self.attributes.length do
        if self.attributes[a].name == utils:trim(ATTRIBUTE_NAME) then
            self.attributes[a].value = ATTRIBUTE_VALUE 
            return
        end
    end
    
    local newattribute = DOMAttribute(utils:trim(ATTRIBUTE_NAME), ATTRIBUTE_VALUE)
    return self.attributes:setNamedItem(newattribute)
end

--
-- Compile class
--
return upperclass:compile(Element)