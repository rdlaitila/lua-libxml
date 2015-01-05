local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local NamedNodeMap  = require(LIBXML_REQUIRE_PATH..'dom.namednodemap')
local NodeList      = require(LIBXML_REQUIRE_PATH..'dom.nodelist')

--
-- Define class
--
local Node = upperclass:define('Node')

--
-- A NamedNodeMap containing the attributes of this node
--
property : attributes { 
    NamedNodeMap(); 
    get='public'; 
    set='private' 
}

--
-- Returns the absolute base URI of a node
--
property : baseURI {
    "";
    get='public';
    set='private'
}

--
-- Returns a NodeList of child nodes for a node
--
property : childNodes { 
    NodeList(); 
    get='public'; 
    set='private' 
}

--
-- Returns the first child of a node
--
property : firstChild { 
    nil; 
    get='public'; 
    set='private';
    type='any'
}

--
-- Returns the last child of a node
--
property : lastChild { 
    nil; 
    get='public'; 
    set='private';
    type='any'
}

--
-- Returns the local part of the name of a node
--
property : localName {
    "";
    get='public';
    set='private'
}

--
-- Returns the namespace URI of a node
--
property : namespaceURI {
    "";
    get='public';
    set='private';
}

--
-- Returns the node immediately following a node
--
property : nextSibling {
    nil;
    get='public';
    set='private';
    type='any'
}

--
-- Returns the name of a node, depending on its type
--
property : nodeName { 
    ""; 
    get='public'; 
    set='private' 
}

--
-- Returns the type of a node
--
property : nodeType { 
    0; 
    get='public'; 
    set='private'
}

--
-- Sets or returns the value of a node, depending on its type
--
property : nodeValue {
    nil;
    get='public';
    set='public';
    type='any'
}

--
-- Returns the root element (document object) for a node
--
property : ownerDocument {
    nil;
    get='public';
    set='private';
    type='any'
}

--
-- Returns the parent node of a node
--
property : parentNode { 
    nil; 
    get='public'; 
    set='public';
    type='any'
}

--
-- Sets or returns the namespace prefix of a node
--
property : prefix {
    nil;
    get='public';
    set='public';
    type='any'
}

--
-- Returns the node immediately before a node
--
property : previousSibling {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Sets or returns the textual content of a node and its descendants
--
property : textContent {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Class Construct
--
function private:__construct()
    error("Method Not Yet Implimented")
end

--
-- Appends a new child node to the end of the list of children of a node
--
function public:appendChild()
    error("Method Not Yet Implimented")
end

--
-- Clones a node
--
function public:cloneNode()
    error("Method Not Yet Implimented")
end

--
-- Compares the placement of two nodes in the DOM hierarchy (document)
--
function public:compareDocumentPosition()
    error("Method Not Yet Implimented")
end

--
-- Returns a DOM object which implements the specialized APIs of the specified feature and version
--
function public:getFeature()
    error("Method Not Yet Implimented")
end

--
-- Returns the object associated to a key on a this node. The object must first have been set to this node by calling setUserData with the same key
--
function public:getUserData()
    error("Method Not Yet Implimented")
end

--
-- Returns true if the specified node has any attributes, otherwise false
--
function public:hasAttributes()
    error("Method Not Yet Implimented")
end

--
-- Returns true if the specified node has any child nodes, otherwise false
--
function public:hasChildNodes()
    error("Method Not Yet Implimented")
end

--
-- Inserts a new child node before an existing child node
--
function public:insertBefore()
    error("Method Not Yet Implimented")
end

--
-- Returns whether the specified namespaceURI is the default
--
function public:isDefaultNamespace()
    error("Method Not Yet Implimented")
end

--
-- Tests whether two nodes are equal
--
function public:isEqualNode()
    error("Method Not Yet Implimented")
end

--
-- Tests whether the two nodes are the same node
--
function public:isSameNode()
    error("Method Not Yet Implimented")
end

--
-- Tests whether the DOM implementation supports a specific feature and that the feature is supported by the specified node
--
function public:isSupported()
    error("Method Not Yet Implimented")
end

--
-- Returns the namespace URI associated with a given prefix
--
function public:lookupNamespaceURI()
    error("Method Not Yet Implimented")
end

--
-- Returns the prefix associated with a given namespace URI
--
function public:lookupPrefix()
    error("Method Not Yet Implimented")
end

--
-- Puts all Text nodes underneath a node (including attribute nodes) into a "normal" form where only structure 
-- (e.g., elements, comments, processing instructions, CDATA sections, and entity references) separates Text nodes, 
-- i.e., there are neither adjacent Text nodes nor empty Text nodes
--
function public:normalize()
    error("Method Not Yet Implimented")
end

--
-- Removes a specified child node from the current node 
--
function public:removeChild()
    error("Method Not Yet Implimented")
end

--
-- Replaces a child node with a new node
--
function public:replaceChild()
    error("Method Not Yet Implimented")
end

--
-- Associates an object to a key on a node
--
function public:setUserData()
    error("Method Not Yet Implimented")
end

--
-- Compile Class
--
return upperclass:compile(Node)