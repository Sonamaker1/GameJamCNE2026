REM ~ cmd /k "C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Auxiliary\Build\vcvarsall.bat" x64

cl /LD testOld.cpp ^
  /std:c++17 ^
  /I ./include ^
  /I ./native/windows_x86_64 ^
  /Fe:../mods/BinkTest/ndlls/test-windows.dll ^
  /link ^
  /LIBPATH:native/windows_x86_64 ^
  bink.lib userenv.lib ws2_32.lib ntdll.lib
