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
