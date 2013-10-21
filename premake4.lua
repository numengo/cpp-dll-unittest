
dofile (path.join(os.getenv("DirScriptsRoot"),"premake_common.lua"))

-- solution UnitTest++ --
solution "UnitTest"

    SolutionConfiguration()

    -- COMMON CONFIGURATION MODIFICATION - START --
    configuration {}
        -- common defines (adapt if necessary) --
       defines {
                "UNITTEST_MINGW"
               }                
       -- for shared libs, export statement
       local _exportSymbol = ""
       -- suffix to use for library versionning
       local _version = ""
       -- common libs  --
       links { 
          }
    -- COMMON CONFIGURATION MODIFICATION - END --

project "UnitTest"
    -- PROJECT MODIFICATIONS START--
    local _targetname = "UnitTest"
    -- additional defines --
    defines {_exportSymbol}
	configuration {"windows"}--
		files {"src/*.h", "src/*.cpp", "src/*.c"}
		files {"src/Win32/*.h", "src/Win32/*.cpp"}
	configuration {"linux"}
		files {"src/**.h", "src/**.cpp", "src/**.c"}
		files {"src/Posix/*.h", "src/Posix/*.cpp"}

    configuration {}
        kind "StaticLib"
        targetname(_targetname)

    AppendCommonOptions()

    sln = solution()
    local _rootdir =  path.getabsolute(".")
    for _, cfg in ipairs(sln.configurations) do
        for _, pltf in ipairs(sln.platforms) do
            local _lastdirname = getLastDirName(cfg,pltf)
            configuration {cfg, pltf}
                libdirs { convertPath(path.join(checkAndGetEnv("DirLibraryRoot"),_lastdirname))}
                targetdir(convertPath(_rootdir.."/lib/".._lastdirname))
                prebuildcommands (MKDIR..convertPath(_rootdir.."/lib/".._lastdirname))
                postbuildcommands(MKDIR..convertPath(checkAndGetEnv("DirLibraryRoot").."/".._lastdirname))
                postbuildcommands(CP..convertPath(_rootdir.."/lib/".._lastdirname.."/*".._targetname)..getStaticLibExtension().." "..convertPath(checkAndGetEnv("DirLibraryRoot").."/".._lastdirname))
        end
    end
	-- PROJECT MODIFICATIONS END--

project "test_UnitTest"
    -- PROJECT MODIFICATIONS START--
    local _targetname = "test_UnitTest"
    links {"UnitTest"}
   files {"src/tests/*"}
    -- PROJECT MODIFICATIONS END--

    AppendTestBuildOptions(_targetname.._version)
