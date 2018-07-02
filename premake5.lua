
dofile (path.join(os.getenv("DIR_SCRIPTS_ROOT"),"premake5_common.lua"))

workspace "UnitTest" 

    SolutionConfiguration()

    -- COMMON CONFIGURATION MODIFICATION - START --
    filter {}
        defines {
                "NGOERR_USE_DYN",
                "UNITTEST_USE_DYN"
                }
       -- for shared libs, export statement
       local _exportSymbol = "UNITTEST_MAKE_DLL"
       -- suffix to use for library versionning
       local _version = ""
       -- common libs  --
       links { 
            "NgoErr"
        }

    
    -- PROTECTED REGION ID(UnitTest.premake.solution) ENABLED START
    -- Insert here user code

    -- End of user code
    -- PROTECTED REGION END

project "UnitTest"
    kind "StaticLib"
    local _targetname = "UnitTest"
    -- additional defines --
    defines {_exportSymbol}
        
    
   -- PROTECTED REGION ID(UnitTest.premake.sharedlib) ENABLED START
   -- Insert here user code
   
    files {"src/*.h", "src/*.cpp", "src/*.c"}
    if (os.istarget("windows")) then
        files {"src/Win32/*.h", "src/Win32/*.cpp"}
    else
        files {"src/Posix/*.h", "src/Posix/*.cpp"}
    end
    
    FilterCommonOptions()

    sln = solution()
    local _rootdir =  path.getabsolute(".")
    for _, cfg in ipairs(sln.configurations) do
        for _, pltf in ipairs(sln.platforms) do
            local _lastdirname = getLastDirName(cfg,pltf)
            filter {"configurations:"..cfg, "platforms:"..pltf}
                libdirs { convertPath(path.join(checkAndGetEnv("DIR_LIB_ROOT"),_lastdirname))}
                targetdir(convertPath(_rootdir.."/lib/".._lastdirname))
                prebuildcommands (MKDIR..convertPath(_rootdir.."/lib/".._lastdirname))
                postbuildcommands(MKDIR..convertPath(checkAndGetEnv("DIR_LIB_ROOT").."/".._lastdirname))
                postbuildcommands(CP..convertPath(_rootdir.."/lib/".._lastdirname.."/*".._targetname)..getStaticLibExtension().." "..convertPath(checkAndGetEnv("DIR_LIB_ROOT").."/".._lastdirname))
        end
    end    
   -- End of user code
   -- PROTECTED REGION END


project "test_UnitTest"
    PrefilterTestBuildOptions("test_UnitTest")
    links { 
        "UnitTest"
    }
 
    -- PROTECTED REGION ID(UnitTest.premake.test) ENABLED START
    -- Insert here user code
   files {"src/tests/*"}
    -- End of user code
    -- PROTECTED REGION END

    FilterTestBuildOptions("test_UnitTest")    
