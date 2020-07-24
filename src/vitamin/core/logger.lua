Logger = {

    line = function(...)
        local args = {...};
        local content = "";
        for k, v in pairs(args) do
            content = content .. tostring(v);
        end
        local total = 20;
        local len = total - string.len(content) / 2;
        local result = "";
        local i = 0;
        while (i < len) do
            result = result .. "-"
            i = i + 1;
        end
        result = result .. content;
        i = 0;
        while (i < len) do
            result = result .. "-"
            i = i + 1;
        end
        Logger.__out(result);
    end,

    log = function(...)
        Logger.__out("[LOG]", ...);
    end,

    info = function(...)
        Logger.__out("[INFO]", ...);
    end,

    warn = function(...)
        Logger.__out("[WARN]", ...);
    end,

    debug = function(...)
        Logger.__out("[DEBUG]", ...);
    end,

    error = function(...)
        Logger.__out("[ERROR]", ...);
    end,

    __out = function(...)
        local result = ""
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...); -->读取参数
            if(type(arg)=='table') then
                local table="\n { \n";
                for k,v in pairs(arg)do
                    table=table..'      '..k..":"..tostring(v)..',\n'
                end
                table=table..'  }'
                result=result..table;
            else
                result=result..' '..tostring(arg);
            end
        end
        print(result);
    end
};
return Logger;
