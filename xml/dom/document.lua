local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode       = require(LIBXML_REQUIRE_PATH..'dom.node')

--
-- Define class
--
local Document = upperclass:define('DOMDocument', DOMNode)

--
-- Specifies whether downloading of an XML file should be handled asynchronously or not
--
property : async {
    false;
    get='public';
    set='public';
}

--
-- Returns the Document Type Declaration associated with the document
--
property : doctype {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the root node of the document
--
property : documentElement {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Sets or returns the location of the document
--
property : documentURI {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Returns the configuration used when normalizeDocument() is invoked
--
property : domConfig {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the DOMImplementation object that handles this document
--
property : implementation {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the encoding used for the document (when parsing)
--
property : inputEncoding {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Sets or returns whether error-checking is enforced or not
--
property : strictErrorChecking {
    true;
    get='public';
    set='public';
}

--
-- Returns the XML encoding of the document
--
property : xmlEncoding {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Sets or returns whether the document is standalone
--
property : xmlStandalone {
    false;
    get='public';
    set='public';
}

--
-- Sets or returns the XML version of the document
--
property : xmlVersion {
    nil;
    get='public';
    set='public';
    type='string';
}

-- 
-- Class constructor
--
function private:__construct()    
    self:__constructparent(9)
    self.nodeName = "#document"
end

--
-- Adopts a node from another document to this document, and returns the adopted node
--
function public:adoptNode(SOURCENODE)
    error("Method Not Yet Implimented")
end

--
-- Creates an attribute node with the specified name, and returns the new Attr object
--
function public:createAttribute(NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates an attribute node with the specified name and namespace, and returns the new Attr object
--
function public:createAttributeNS(URI, NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a CDATA section node
--
function public:createCDATASection()
    error("Method Not Yet Implimented")
end

--
-- Creates a comment node
--
function public:createComment()
    error("Method Not Yet Implimented")
end

--
-- Creates an empty DocumentFragment object, and returns it
--
function public:createDocumentFragment()
    error("Method Not Yet Implimented")
end

--
-- Creates an element node
--
function public:createElement()
    error("Method Not Yet Implimented")
end

--
-- Creates an element node with a specified namespace
--
function public:createElementNS()
    error("Method Not Yet Implimented")
end

--
-- Creates an EntityReference object, and returns it
--
function public:createEntityReference(NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a ProcessingInstruction object, and returns it
--
function public:createProcessingInstruction(TARGET, DATA)
    error("Method Not Yet Implimented")
end

--
-- Creates a text node
--
function public:createTextNode()
    error("Method Not Yet Implimented")
end

--
-- Returns the element that has an ID attribute with the given value. If no such element exists, it returns null
--
function public:getElementById(ID)
    error("Method Not Yet Implimented")
end

--
-- Returns a NodeList of all elements with a specified name
--
function public:getElementsByTagName()
    error("Method Not Yet Implimented")
end

--
-- Returns a NodeList of all elements with a specified name and namespace
--
function public:getElementsByTagNameNS()
    error("Method Not Yet Implimented")
end

--
-- Imports a node from another document to this document. This method creates a new copy of the source node. If the deep parameter is set to true, it imports all children of the specified node. If set to false, it imports only the node itself. This method returns the imported node
--
function public:importNode(NODE, DEEP)
    error("Method Not Yet Implimented")
end

--
-- normalizeDocument()
--
function public:normalizeDocument()
    error("Method Not Yet Implimented")
end

--
-- Renames an element or attribute node
--
function public:renameNode()
    error("Method Not Yet Implimented")
end

--
-- Compile Class
--
return upperclass:compile(Document)