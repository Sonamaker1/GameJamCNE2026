g++ testOld.cpp cwalk.c -shared -o ../mods/BinkTest/ndlls/test-linux.ndll \
  -I./include -fPIC -I./native/linux_x86_64 \
  -L./native/linux_x86_64 -lbink \
  -Wl,-rpath,'$ORIGIN'
