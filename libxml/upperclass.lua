local upperclass = {}

--
-- Define some static scope properties for use internally
--
UPPERCLASS_SCOPE_PRIVATE = 1
UPPERCLASS_SCOPE_PROTECTED = 2
UPPERCLASS_SCOPE_PUBLIC = 3
UPPERCLASS_SCOPE_NOBODY = 4

--
-- Define some member type properties for use internally
--
UPPERCLASS_MEMBER_TYPE_PROPERTY = 1
UPPERCLASS_MEMBER_TYPE_FUNCTION = 2

--
-- Upperclass Define function.
--
function upperclass:define(CLASS_NAME, PARENT)
    local classdef = {}
    local classmt = {}
    
    -- Gracefully take over globals: public, private, protected, property
    -- we will set them back to orig values after definition
    classdef.public_orig_value     = rawget(_G, "public")    
    classdef.private_orig_value    = rawget(_G, "private")
    classdef.protected_orig_value  = rawget(_G, "protected")
    classdef.property_orig_value   = rawget(_G, "property")
    
    -- Create table to hold our class implimentation
    classdef.__imp__ = {}
  
    -- Store the class name
    classdef.__imp__.name = tostring(CLASS_NAME)
  
    -- Store the class file 
    classdef.__imp__.file = debug.getinfo(2, "S").source:sub(2) 
    
    -- Create table to hold our class memebers. table KEY is member name
    -- Schema: {scope=[PUBLIC|PRIVATE|PROTECTED], type=[PROPERTY|FUNCTION], value=[DATA_OR_REFERENCE]}
    classdef.__imp__.members = {}
  
    -- Create tables to hold singlton instance values (a.k.a static class)
    classdef.__inst__ = {}
    classdef.__inst__.member_values = {}
    classdef.__inst__.isInstance = false
  
    -- Create table to hold reference to our parent class, if specified
    classdef.__parent__ = PARENT or nil
  
    -- Create table to hold references to our child classes, if this class is inherited
    classdef.__children__ = {}
  
    -- During the definition stage, the user may place property and method definitions in the following tables
    rawset(_G, "public",    {})
    rawset(_G, "private",   {})
    rawset(_G, "protected", {})
    rawset(_G, "property",  {})
    
    -- Set a reference to classdef in classmt
    classmt.classdef = classdef
    
    -- This is used to track the last property name wen using property syntax 'property : [NAME] {}'
    classmt.last_property_name = nil
    
    --
    -- Classdef Metatable __index
    --
    function classmt.__index(TABLE, KEY)        
        -- Check what kind of index we are retreiving. If property we have special actions
        if TABLE == property then
            -- Get our class definition
            local classdef = getmetatable(TABLE).classdef
            
            -- Get our implimentation table
            local imp = rawget(classdef, "__imp__")
            
            -- Get our implimentation members table
            local members = rawget(imp, "members")
            
            -- Ensure we are not redefining an existing member
            if members[KEY] ~= nil then
                error("Attempt to redefine existing member '"..KEY.."' in class '"..imp.name.."' is disallowed")
            end
            
            -- Setup our member property table. 
            members[KEY] = {
                scope_get = nil,                
                scope_set = nil,                
                value = nil,
                type = UPPERCLASS_MEMBER_TYPE_PROPERTY
            }    
            
            -- Set the last property name being defined
            classmt.last_property_name = KEY
            
            return property
        else
            return rawget(TABLE, KEY)
        end
    end
    
    --
    -- Classdef Metatable __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        -- Get our class definition
        local classdef = getmetatable(TABLE).classdef
        
        -- Get our implimentation table
        local imp = rawget(classdef, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
        
        -- Ensure we are not redefining an existing member
        if members[KEY] ~= nil then
            error("Attempt to redefine existing member '"..KEY.."' in class '"..imp.name.."' is disallowed")                
        end
                
        -- Create our members based on type and scope
        if type(VALUE) == "string" or type(VALUE) == "number" or 
           type(VALUE) == "boolean" or type(VALUE) == "table" then            
            if TABLE == rawget(_G, "public") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PUBLIC,                
                    scope_set = UPPERCLASS_SCOPE_PUBLIC,                
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_PROPERTY
                }                
            elseif TABLE == rawget(_G, "private") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PRIVATE,                    
                    scope_set = UPPERCLASS_SCOPE_PRIVATE,                    
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_PROPERTY
                }
            elseif TABLE == rawget(_G, "protected") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PROTECTED,                    
                    scope_set = UPPERCLASS_SCOPE_PROTECTED,
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_PROPERTY
                }                
            end            
        elseif type(VALUE) == "function" then            
            if TABLE == rawget(_G, "public") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PUBLIC,                    
                    scope_set = UPPERCLASS_SCOPE_NOBODY,                    
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_FUNCTION
                }                
            elseif TABLE == rawget(_G, "private") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PRIVATE,                    
                    scope_set = UPPERCLASS_SCOPE_NOBODY,                    
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_FUNCTION
                }
            elseif TABLE == rawget(_G, "protected") then
                members[KEY] = {
                    scope_get = UPPERCLASS_SCOPE_PROTECTED,                    
                    scope_set = UPPERCLASS_SCOPE_NOBODY,
                    value = VALUE,
                    type = UPPERCLASS_MEMBER_TYPE_FUNCTION
                }        
            end
        end
    end
   
    --
    -- Classdef Metamethod __call
    --
    function classmt.__call(...)
        local tables = {...}
        
        -- Get our class definition
        local classmt = getmetatable(tables[1])
        
        -- Get our implimentation table
        local imp = rawget(classmt.classdef, "__imp__")
        
        -- Get our implimentation members table
        local members = rawget(imp, "members")
        
        -- If property table length is 0, then set member values to defaults
        local proptablelen = 0
        for key, value in pairs(tables[3]) do proptablelen = proptablelen +1 end
        if proptablelen == 0 then
            members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_PUBLIC
            members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_PUBLIC
            members[classmt.last_property_name].value = nil
        else
            -- Value is first index key, otherwise nil (doesn't exist)
            members[classmt.last_property_name].value = tables[3][1] or nil
            
            -- Determine getter scope
            if tables[3].get == 'public' then
                members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_PUBLIC
            elseif tables[3].get == 'private' then
                members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_PRIVATE
            elseif tables[3].get == 'protected' then
                members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_PROTECTED
            elseif tables[3].get == 'nobody' then
                members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_NOBODY
            else
                members[classmt.last_property_name].scope_get = UPPERCLASS_SCOPE_PUBLIC
            end
            
            -- Determine setter scope
            if tables[3].set == 'public' then
                members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_PUBLIC
            elseif tables[3].set == 'private' then
                members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_PRIVATE
            elseif tables[3].set == 'protected' then
                members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_PROTECTED
            elseif tables[3].set == 'nobody' then
                members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_NOBODY
            else
                members[classmt.last_property_name].scope_set = UPPERCLASS_SCOPE_PUBLIC
            end
        end
    end
  
  
    -- Set our metatables. 
    setmetatable(classdef,  classmt)
    setmetatable(public,    classmt)
    setmetatable(private,   classmt)
    setmetatable(protected, classmt)    
    setmetatable(property,  classmt)
  
    return classdef
end

--
-- Upperclass Compile Function
--
function upperclass:compile(CLASS)      
    -- Return our stolen globals to original state
    rawset(_G, "public",    CLASS.public_orig_value)
    rawset(_G, "private",   CLASS.private_orig_value)
    rawset(_G, "protected", CLASS.protected_orig_value)
    rawset(_G, "property",  CLASS.property_orig_value)
    
    setmetatable(CLASS, nil)    
    local classmt = {}    
    
    -- If __construct was not defined, define it now
    if CLASS.__imp__.members["__construct"] == nil then
        CLASS.__imp__.members["__construct"] = {
            scope = UPPERCLASS_SCOPE_PRIVATE,                    
            value = function() end,
            type = UPPERCLASS_MEMBER_TYPE_FUNCTION
        }
    end
    
    -- If __deconstruct was not defined, define it now
    if CLASS.__imp__.members["__deconstruct"] == nil then
        CLASS.__imp__.members["__deconstruct"] = {
            scope = UPPERCLASS_SCOPE_PRIVATE,                    
            value = function() end,
            type = UPPERCLASS_MEMBER_TYPE_FUNCTION
        }
    end
    
    -- Define __constructparent() method
    CLASS.__imp__.members["__constructparent"] = {
        scope = UPPERCLASS_SCOPE_PRIVATE,
        value = function(...)
            local constructArgs = {...}
            if self.__parent__.__inst__.isInstance == false then
                self.__parent__ = self.__parent__(unpack(constructArgs))
            end
        end,
        type = UPPERCLASS_MEMBER_TYPE_FUNCTION
    }
    
    --
    -- Classdef Metamethod __call
    --
    function classmt.__call(...)        
        -- Pack args
        local arguments = {...}
        
        -- Get table argument, a.k.a 'self'
        local self = arguments[1]
        
        -- Get class implimentation
        local imp = rawget(self, "__imp__")
            
        -- Get caller function
        local caller = debug.getinfo(2).func
            
        -- Check to ensure that we are not calling from within the class itself
        for _, member in pairs(imp.members) do
            if member.value == caller then
                error("Attempt to call class instantiation from within class '"..imp.name.."' is disallowed")
            end
        end
        
        -- Define instance table to return
        local instance = {}
            
        -- Setup reference to class implimentation
        instance.__imp__ = imp
            
        -- Setup table to hold instance implimentation
        instance.__inst__ = {}
            
        -- Table to hold instance values
        instance.__inst__.member_values = {}
        
        -- Set that this is an instance
        instance.__inst__.isInstance = true
        
        -- Set parent reference
        instance.__parent__ = self.__parent__
        
        setmetatable(instance, getmetatable(self))
            
        -- Call class constructor
        local passargs = {}
        if #arguments > 1 then for a=2, #arguments do table.insert(passargs, arguments[a]) end end
        local __construct = imp.members["__construct"].value
        __construct(instance, unpack(passargs))
        
        -- Construct parent
        if instance.__parent__ ~= nil and instance.__parent__.__inst__.isInstance == false then                         
            instance.__parent__ = self.__parent__()
        end
        
        return instance   
    end
    
    --
    -- Classdef Metamethod __index
    --
    function classmt.__index(TABLE, KEY)         
        -- Ensure we return some important keys
        if KEY == "__imp__" or KEY == "__inst__" or KEY == "__parent__" then
            return rawget(TABLE, KEY)
        end
        
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)        
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Return __constructparent if coming form class __construct
        if KEY == "__constructparent" then
            return function(self, ...)
                self.__parent__ = self.__parent__(...)
            end
        end
        
        -- Holds our found value during member lookups
        local returnValue = nil
        
        -- Attempt to locate a valid member        
        if members[KEY] ~= nil then
            if members[KEY].scope_get == UPPERCLASS_SCOPE_PUBLIC then                  
                if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                    returnValue = inst.member_values[KEY]
                else -- Return value of class implimentation
                    returnValue = members[KEY].value
                end
            elseif members[KEY].scope_get == UPPERCLASS_SCOPE_PRIVATE then                
                local privatecallerfound = false
                for _, member in pairs(members) do
                    if member.type == UPPERCLASS_MEMBER_TYPE_FUNCTION then
                        if member.value == caller.func then
                            privatecallerfound = true
                            break
                        end
                    end
                end
                    
                if privatecallerfound == true then
                    if inst.member_values[KEY] ~= nil then -- If we have a stored value, return it
                        returnValue = inst.member_values[KEY]
                    else -- Return value of class implimentation
                        returnValue = members[KEY].value
                    end
                else
                    error("Attempt to access private member '".. KEY .."' from outside of class '".. imp.name .."' is disallowed")
                end                
            elseif members[KEY].scope_get == UPPERCLASS_SCOPE_PROTECTED then
                error("Attempt to access protected member is not implimented")
            end
        else
            returnValue = TABLE.__parent__[KEY]
        end    
        
        if returnValue == nil then
            error("Attempt to access non-existant member "..KEY.." within class "..imp.name)            
        end
        
        return returnValue
    end
    
    --
    -- Classdef Metamethod __newindex
    --
    function classmt.__newindex(TABLE, KEY, VALUE)
        -- Get caller function for use in private and protected lookups
        local caller = debug.getinfo(2)
        
        -- Grab reference to class instance table
        local inst = rawget(TABLE, "__inst__")
        
        -- Grab reference to class implimentation table
        local imp = rawget(TABLE, "__imp__")            
        
        -- Grab reference to class implimentation members
        local members = rawget(imp, "members")
        
        -- Set our value
        if members[KEY] ~= nil then
            -- Error if we are trying to set value of a function member
            if members[KEY].type == UPPERCLASS_MEMBER_TYPE_FUNCTION  then
                error("Attempt to set value of member function '"..KEY.."' with value '"..tostring(VALUE).."' in class '"..imp.name.."' is disallowed")        
            end
            
            -- Ensure that the inboudn value type matches the implimentation type
            if type(VALUE) ~= type(members[KEY].value) then
                error("Attmept to overwrite member property '"..KEY.."' of type '"..type(members[KEY].value).."' with type '"..type(VALUE).."' in class '"..imp.name.."' is disallowed")
            end            
            
            if members[KEY].scope_set == UPPERCLASS_SCOPE_PUBLIC then
                inst.member_values[KEY] = VALUE
            elseif members[KEY].scope_set == UPPERCLASS_SCOPE_PRIVATE then
                local privatecallerfound = false
                for _, member in pairs(members) do
                    if member.type == UPPERCLASS_MEMBER_TYPE_FUNCTION then
                        if member.value == caller.func then
                            privatecallerfound = true
                            break
                        end
                    end
                end
                
                if privatecallerfound == true then
                    inst.member_values[KEY] = VALUE                        
                else
                    error("Attempt to set private class property '"..KEY.."' from outside of class '"..imp.name.."' is disallowed")
                end            
            elseif members[KEY].scope_set == UPPERCLASS_SCOPE_PROTECTED then
                error("Attempt to set member property of type protected is not implimented")
            elseif members[KEY].scope_set == UPPERCLASS_SCOPE_NOBODY then
                error("Attempt to set member property '"..KEY.."' of scope 'nobody' in class '"..imp.name.."' is disallowed")
            end
        elseif TABLE.__parent__ ~= nil then
            TABLE.__parent__[KEY] = VALUE
        else
            error("Attempt to set non-existant member '"..KEY.."' with value '"..VALUE.."' in class '"..imp.name.."' is disallowed")
        end
    end
    
    setmetatable(CLASS, classmt)
    
    return CLASS
end

--
-- Upperclass Dump Members Function
--
function upperclass:dumpMembers(CLASS)
    if CLASS.__imp__ ~= nil then
        print("NAME", "TYPE", "SCOPE", "VALUE")
        for key, value in pairs(CLASS.__imp__.members) do            
            print(key, value.type, value.scope, value.value)
        end
    else
       error(ERRORS[1])
    end
end

return upperclass