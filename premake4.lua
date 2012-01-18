
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
	files {"src/**.h", "src/**.cpp", "src/**.c"}
	configuration {"windows"}
		excludes{"src/Posix/*"}
	configuration {"linux"}
		excludes{"src/Win32/*"}
	-- PROJECT MODIFICATIONS END--

    AppendStaticLibBuildOptions(_targetname.._version)

project "test_UnitTest"
    -- PROJECT MODIFICATIONS START--
    local _targetname = "test_UnitTest"
    links {"UnitTest"}
   files {"src/tests/*"}
    -- PROJECT MODIFICATIONS END--

    AppendTestBuildOptions(_targetname.._version)
