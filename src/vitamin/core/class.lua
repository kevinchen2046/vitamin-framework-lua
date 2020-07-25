-------------------------------------
-------------------------------------
--- author:陈南
--- email:kevin-chen@foxmail.com
--- wechat:kevin_nan
--- date:2020.7.24
--- Copyright (c) 2020-present, KevinChen2046 Technology.
--- All rights reserved.
-------------------------------------
-------------------------------------

local Logger = require("src.vitamin.core.logger");
local uuid = require("uuid");
-- local __classuuid = 100000;
function __GetClassId()
    -- __classuuid = __classuuid + 1;
    -- return __classuuid;
    return uuid();
end

-- local __objectuuid = 200000;
function __GetInstanceId()
    -- __objectuuid = __objectuuid + 1;
    -- return __objectuuid;
    return uuid();
end

-- Object = {
--     __classid__ = 0
-- }
-- function Object:new(o)
--     self.__classid__ = __GetClassId();
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     return o
-- end

local __classIdMap = {};
local __classNameMap = {};
Class = {
    clone = function(object, ...)
        local ret = {}

        -- clone base class
        if type(object) == "table" then
            for k, v in pairs(object) do
                if type(v) == "table" then
                    v = Class.clone(v)
                end
                -- don't clone functions, just inherit them
                if type(v) ~= "function" then
                    -- mix in other objects.
                    ret[k] = v
                end
            end
        end
        -- set metatable to object
        setmetatable(ret, {
            __index = object
        })

        -- mix in tables
        for _, class in ipairs(arg) do
            for k, v in pairs(class) do
                if type(v) == "table" then
                    v = Class.clone(v)
                end
                -- mix in v.
                ret[k] = v
            end
        end

        return ret
    end,
    -- 定义一个类
    define = function(object)
        -- print(debug.getinfo(object).name);
        if (object.className == nil) then
            Logger.error("[class.define] className can't be nil!");
            return nil;
        end
        --Logger.info('[class.define]', object.className);
        __classNameMap[object.className] = object;
        object.__classid__ = __GetClassId();
        object.__isbase = getmetatable(object) == nil;
        __classIdMap[object.__classid__] = object;
        return object;
    end,
    -- 从类定义实例化
    new = function(object,...)
        local instance=Class.clone(object, {
            __instanceid__ = __GetInstanceId()
        })
        if(instance['constructor']~=nil)then
            instance:constructor(...);
        end
        return instance
    end,
    -- 从类定义取单例
    instance = function(nameOrObject)
        if (type(nameOrObject) == "string") then
            return __classNameMap[nameOrObject];
        end
        if (nameOrObject.__classid__ == nil) then
            return nil;
        end
        return __classIdMap[nameOrObject.__classid__];
    end,
    -- 继承
    -- base 基类
    -- object 当前类实现
    extend = function(base, object)
        if (object.className == nil) then
            Logger.error("[class.extend] className can't be nil!");
            return nil;
        end
        __classNameMap[object.className] = object;
        object.__classid__ = __GetClassId();
        __classIdMap[object.__classid__] = object;
        object.__isbase = false;
        object.__base = base;
        return Class.clone(base, object);
    end,
    -- 用限定名称反射出类定义
    getDefineByName = function(name)
        return __classNameMap[name];
    end,
    -- 取得该类的限定名称
    getQualifiedClassName = function(class)
        if (class.__classid__ == nil) then
            Logger.error("[class.getQualifiedClassName] __classid__ can't be nil,may be not a class!");
            return nil;
        end
        return __classIdMap[class.__classid__];
    end,
    -- 取得该类基类的限定名称
    getQualifiedSuperclassName = function(class)
        if (class.__classid__ == nil) then
            Logger.error("[class.getQualifiedSuperclassName] __classid__ can't be nil,may be not a class!");
            return nil;
        end
        local baseclass = class;
        while (baseclass.__isbase == false) do
            baseclass = baseclass.__base;
            if (baseclass.__classid__ == nil) then
                Logger.error("[class.getQualifiedSuperclassName] __classid__ can't be nil,may be not a class!");
                return nil;
            end
        end
        if (baseclass.__isbase == true) then
            return baseclass.className;
        end
    end,
    newByName = function(name)
        local class = Class.getDefineByName(name);
        if (class ~= nil) then
            return Class.new(class);
        end
        return nil;
    end,
    extendByName = function(name, extendobject)
        local class = Class.getDefineByName(name);
        if (class ~= nil) then
            return Class.extend(class, extendobject);
        end
        return nil;
    end,

    __getClassMap = function()
        return __classNameMap;
    end
}
return Class;
