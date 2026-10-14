CXX       ?= c++
TARGET_OS ?= no-os-specified
TARGET_ARCH ?= x86_64
NATIVE_DIR := native/$(TARGET_OS)_$(TARGET_ARCH)

ifeq ($(TARGET_OS),windows)
  BINK_LIB := $(NATIVE_DIR)/bink.dll
  BINK_LINK ?=
  RUN_ENV =
else ifeq ($(TARGET_OS),darwin)
  BINK_LIB := $(NATIVE_DIR)/libbink.dylib
  BINK_LINK := $(BINK_LIB)
  RUN_ENV =
else ifeq ($(TARGET_OS),linux)
  BINK_LIB := $(NATIVE_DIR)/libbink.so
  BINK_LINK := $(BINK_LIB)
  RUN_ENV = LD_LIBRARY_PATH=$(dir $(BINK_LIB)):$${LD_LIBRARY_PATH}
else
  $(error Unsupported TARGET_OS '$(TARGET_OS)'. Set windows, darwin, or linux; e.g. `make TARGET_OS=linux`)
endif

TEST_SRC  ?= test.cpp
TEST_BIN  ?= bink.ndll
INCLUDE_DIR ?= include

.PHONY: all run clean
all: $(TEST_BIN)

$(TEST_BIN): $(TEST_SRC) $(BINK_LIB)
	$(CXX) -std=c++17 -I$(INCLUDE_DIR) -I$(NATIVE_DIR) $< $(BINK_LINK) -o $@ 

run: $(TEST_BIN)
	$(RUN_ENV) ./$(TEST_BIN)

clean:
	rm -f $(TEST_BIN)
