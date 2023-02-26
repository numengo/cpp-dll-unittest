dofile (path.join(os.getenv("DIR_SCRIPTS_ROOT"),"premake5_common.lua"))

workspace "UnitTest"

    SolutionConfiguration()
    defines {
        "UNITTEST_MINGW"
    }
    local _exportSymbol = "UNITTEST_MAKE_DLL"
    links { 
    }
    
    -- PROTECTED REGION ID(UnitTest.premake.solution) ENABLED START

    -- PROTECTED REGION END


project "UnitTest"

    kind "StaticLib"
    targetname("UnitTest")
    local _targetname = "UnitTest"
    defines {_exportSymbol}
    
    -- PROTECTED REGION ID(UnitTest.premake.staticlib) ENABLED START
	configuration {"windows"}
		files {"src/*.h", "src/*.cpp", "src/*.c"}
		files {"src/Win32/*.h", "src/Win32/*.cpp"}
	configuration {"linux"}
		files {"src/*.h", "src/*.cpp", "src/*.c"}
		files {"src/Posix/*.h", "src/Posix/*.cpp"}

    FilterCommonOptions()

    sln = workspace()
    local _rootdir =  path.getabsolute(".")
    for _, cfg in ipairs(sln.configurations) do
        for _, pltf in ipairs(sln.platforms) do
            local _lastdirname = getLastDirName(cfg,pltf)
            filter {"kind:StaticLib", "configurations:"..cfg, "platforms:"..pltf}
                libdirs { convertPath(path.join(checkAndGetEnv("DIR_LIB_ROOT"),_lastdirname))}
                targetdir(convertPath(_rootdir.."/lib/".._lastdirname))
                prebuildcommands (MKDIR..convertPath(_rootdir.."/lib/".._lastdirname))
                postbuildcommands(MKDIR..convertPath(checkAndGetEnv("DIR_LIB_ROOT").."/".._lastdirname))
                postbuildcommands(CP..convertPath(_rootdir.."/lib/".._lastdirname.."/*".._targetname)..getStaticLibExtension().." "..convertPath(checkAndGetEnv("DIR_LIB_ROOT").."/".._lastdirname))
        end
    end

    -- PROTECTED REGION END


project "test_UnitTest"

    kind "ConsoleApp"
    links { "UnitTest", "NgoErr"}
    
    -- PROTECTED REGION ID(UnitTest.premake.test) ENABLED START
    defines {"NGO_ERR_USE_DYN"}
    includedirs {checkAndGetEnv("DIR_UNITTEST_ROOT").."/src"}
    files {"src/tests/*"}

    -- PROTECTED REGION END

    FilterTestBuildOptions("test_UnitTest")
