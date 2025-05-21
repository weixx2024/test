
function 打开地图(file)
    map = require('资源/格式/map')(file)
    return map and true
end

function 取地表(id)
	if map then
		return map:取地表(id)
	end
end

function 取遮罩(id)
	if map then
		return map:取遮罩(id)
	end
end
