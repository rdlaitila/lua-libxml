-- Load dependencies
local upperclass = require('libxml_lib_upperclass')

-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local dom = upperclass:define("dom")

--
-- DOM Parser
--
property : DOMParser { require('libxml_dom_domparser') ; get='public' ; set='nobody' }

--
-- DOM Document
--
property : Document { require('libxml_dom_document') ; get='public' ; set='nobody' }

--
-- DOM Node
--
property : Node { require('libxml_dom_node') ; get='public' ; set='nobody' }

return upperclass:compile(dom, {ALLOW_INSTANCE = false, ALLOW_STATIC = true, STRICT_TYPES = true})