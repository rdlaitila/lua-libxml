local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMCDATA      = require(LIBXML_REQUIRE_PATH..'dom.cdata')

--
-- Define class
--
local Text = upperclass:define("DOMText", DOMCDATA)

--
-- Returns true if the text node contains content whitespace, otherwise it returns false
--
property : isElementContentWhitespace {
    false;
    get='public';
    set='private';
}

--
-- Returns all text of text nodes adjacent to this node, concatenated in document order
--
property : wholeText {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Class constructor
--
function private:__construct(TEXT)
    self:__constructparent(TEXT)
    self.nodeType = 3
    self.nodeName = "#text"
end

--
-- Replaces the text of this node and all adjacent text nodes with the specified text
--
function public:replaceWholeText(TEXT)
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return upperclass:compile(Text)
