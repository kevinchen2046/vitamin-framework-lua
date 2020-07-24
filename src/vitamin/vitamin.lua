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

-- Vitamin使用注意  --
-- 1.所有静态方法访问操作符为 .
-- 2.所有实例方法访问操作符为 : ,这样访问可以传递self
-- 3.所有实例属性访问操作符仍为 .
-- 4.定义Class时,className为必须项

require('src.vitamin.core.class');
require('src.vitamin.core.array');
require('src.vitamin.core.event');
require('src.vitamin.utils.stringutil');

local _InjectTag='__Inject__';

Inject = function(className)
    return Class.getDefineByName(className);
end

Vitamin = {

    -- 视图基类
    ViewBase = Class.extend(EventEmiter,{
        className = "ViewBase",
        enter = function(...)
        end,

        exit = function()
        end
    }),

    -- 数据模型基类
    ModelBase = Class.define({
        className = "ModelBase",
        initialize = function(...)
        end,

        reset = function()
        end
    }),

    -- 命令基类
    CommandBase = Class.define({
        className = "CommandBase",
        exec = function(...)
        end
    }),

    -- 框架初始化

    initialize = function()
        local classMap = Class.__getClassMap();
        local models = {};
        local views = {};
        local cmds = {};
        -- local viewclasses=Class.new(Array);
        -- local modelclasses=Class.new(Array);
        -- local cmdclasses=Class.new(Array);

        for className, class in pairs(classMap) do
            local baseName = Class.getQualifiedSuperclassName(class);
            --Logger.log(className, baseName);
            if (baseName == "ViewBase" and className ~= 'ViewBase') then
                views[class.className] = class;
            elseif (baseName == "ModelBase" and className ~= 'ModelBase') then
                models[class.className] = {
                    initialize = false,
                    instance = class
                };
            elseif (baseName == "CommandBase" and className ~= 'CommandBase') then
                cmds[class.className] = class;
            end
        end

        while (true) do
            local allDone = true;
            for className, modelObject in pairs(models) do
                local done = true;
                for property, value in pairs(modelObject.instance) do
                    if (value == Inject) then
                        local targetName = StringUtil.firstToUpper(property);
                        if (models[targetName] == nil or models[targetName].initialize == false) then
                            done = false;
                        else
                            modelObject.instance[property] = models[targetName].instance;
                        end
                    end
                end
                if (done == true) then
                    modelObject.initialize = true;
                    modelObject.instance:initialize();
                else
                    allDone = false;
                end
            end
            if (allDone == true) then
                break
            end
        end

        for className, view in pairs(views) do
            for property, value in pairs(view) do
                if (value == Inject) then
                    local ModelClassName = StringUtil.firstToUpper(property);
                    if (models[ModelClassName] ~= nil) then
                        view[property]=models[ModelClassName].instance;
                    else
                        Logger.error("can't find model: "..ModelClassName..' in '..className);
                    end
                end
            end
        end

        for className, cmd in pairs(cmds) do
            for property, value in pairs(cmd) do
                if (value == Inject) then
                    local ModelClassName = StringUtil.firstToUpper(property);
                    if (models[ModelClassName] ~= nil) then
                        cmd[property]=models[ModelClassName].instance;
                    else
                        Logger.error("can't find model: "..ModelClassName..' in '..className);
                    end
                end
            end
        end
        Logger.line('>>Vitamin Start>>');
    end
}

return {Vitamin, Inject}
