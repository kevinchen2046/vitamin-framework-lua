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

StringUtil = {
    
    -- 首字母大写
    firstToUpper = function(str)
        return (str:gsub("^%l", string.upper))
    end,

    -- 首字母小写
    firstToLower = function(str)
        return (str:gsub("^%u", string.lower))
    end
}
return StringUtil;
