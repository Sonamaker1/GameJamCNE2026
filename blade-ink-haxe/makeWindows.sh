g++ testOld.cpp cwalk.c -shared -o ../mods/BinkTest/ndlls/test-windows.ndll \
  -I./include -fPIC -I./native/windows_gnu_x86_64 \
  -L./native/windows_gnu_x86_64 -lbink -luserenv -lws2_32 -lntdll\
  -Wl,-rpath,'$ORIGIN'
