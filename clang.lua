local clangArgs = {}
local output
local clang = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang.ki"
local kiwisecClang = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/kiwisec/clang"
local isCompileOnly = false

string.startsWith = function(str, substr)
    if str == nil or substr == nil then
        return nil, "the string or the sub-stirng parameter is nil"
    end
    if string.find(str, substr) ~= 1 then
        return false
    else
        return true
    end
end

string.isEmpty = function(str)
	if type(str) ~= "string" then
		return true
	end
	if str:len() == 0 then
		return true
	end
	return false
end

os.oriExecute = os.execute
os.execute = function(cmd)
	print("Clang Lua processer ==> execute:[", cmd,"]\\n")
	local ret =  os.oriExecute(cmd)
	-- print("execute out:", ret)
	return ret
end

function processClangArgs()
	print("Input command:[", table.concat(arg, " "),"]\\n")
	for k, v in ipairs(arg) do
		--print(k, v)
		if v:startsWith("-o") then
			if (v:len() == 2) then
				output = arg[k + 1]
				arg[k + 1] = ""
			elseif v:startsWith("-o%.") or v:startsWith("-o/") then
				output = v:sub(3)
			else
				clangArgs[#clangArgs + 1] = v
			end
		elseif v:startsWith("-c") then
			if (v:len() == 2) then
				isCompileOnly = true
			end
			clangArgs[#clangArgs + 1] = v
		else 
			if v ~= "" then
				clangArgs[#clangArgs + 1] = v
			end
		end
	end
end

function execClang()
	print("Clang Lua processer ==> Output:[", output,"]\\n")
	local cmdArgs = table.concat(clangArgs, " ")
	print("Clang Lua processer ==> OriCommand:[", cmdArgs,"]\\n")

	if string.isEmpty(output) then
		os.execute(table.concat({clang, cmdArgs}, " "))
		return 
	end
	if (isCompileOnly) then
		os.execute(table.concat({clang, cmdArgs, "-o"..  output, "-emit-llvm"}, " "))
		os.execute(table.concat({kiwisecClang, "-kce-bc=" .. output}, " "))
		if (os.rename(output .. ".bc", output .. ".bc")) then
			os.execute(table.concat({"rm", "-rfv", output, output .. ".bc"}, " "))
			os.rename(output .. ".o", output)
		else
			print("Clang Lua processer ==> kiwisec fail..\\n")
		end
	else 
		os.execute(table.concat({clang, cmdArgs, "-o"..  output}, " "))
	end
end

processClangArgs()
execClang()


