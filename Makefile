# SPDX-License-Identifier: GPL-3.0-or-later
# Native C++ chronology and stable C ABI; C helpers remain C. Shared build tools from Common.
.DEFAULT_GOAL := all
CC ?= gcc
CXX ?= g++
PKG_CONFIG ?= pkg-config
BUILD_DIR ?= build
RESOURCE_NAME := Persian Solar Hijri Calendar
COMMON_DIR := common
COMMON_REVISION := 7499fb1c81d95a11a06224c9a33c19bb71bd996d
COMMON_VERSION := 1.19.80
COMMON_BUILD_DIR := $(abspath $(BUILD_DIR))/common
COMMON_ARCHIVE := $(COMMON_BUILD_DIR)/libinfiltratr-common.a
DEPENDENCIES := glib-2.0 icu-i18n
C_SOURCES := $(shell find src -type f -name '*.c' | LC_ALL=C sort)
CXX_SOURCES := $(shell find src -type f -name '*.cpp' | LC_ALL=C sort)
C_OBJECTS := $(patsubst src/%.c,$(BUILD_DIR)/obj/%.o,$(C_SOURCES))
CXX_OBJECTS := $(patsubst src/%.cpp,$(BUILD_DIR)/obj/%.o,$(CXX_SOURCES))
TARGET := $(BUILD_DIR)/$(RESOURCE_NAME).so
DEP_CFLAGS := $(shell $(PKG_CONFIG) --cflags $(DEPENDENCIES))
DEP_LIBS := $(shell $(PKG_CONFIG) --libs glib-2.0)
CPPFLAGS += -I$(COMMON_DIR)/include -Iinclude -Isrc -Isrc/support -Isrc/calendars -Isrc/calendars/engine \
    -include include/provider-config.h -DGETTEXT_PACKAGE=\"infiltrator-temporal-resources\" \
    -DU_DISABLE_RENAMING=1 -DGLIB_VERSION_MIN_REQUIRED=GLIB_VERSION_2_74 \
    -DGLIB_VERSION_MAX_ALLOWED=GLIB_VERSION_2_74
CFLAGS ?= -O2 -g
CFLAGS += -std=c11 -fPIC -fvisibility=hidden -ffunction-sections -fdata-sections \
    -Wall -Wextra -Wpedantic -Werror -Wformat=2 -Wshadow -Wstrict-prototypes \
    -Wmissing-prototypes -fstack-protector-strong -fno-common
CXXFLAGS += $(filter-out -std=c11 -Wstrict-prototypes -Wmissing-prototypes,$(CFLAGS)) -std=c++20
LDLIBS += $(DEP_LIBS) -lm -ldl -pthread
.PHONY: common-check all check audit-authorities clean release deb native-deb
common-check:
	@test -f "$(COMMON_DIR)/VERSION" || { echo "Missing Common submodule"; exit 1; }
	@grep -qx "$(COMMON_VERSION)" "$(COMMON_DIR)/VERSION" || exit 1
	@if test -e "$(COMMON_DIR)/.git"; then git -C "$(COMMON_DIR)" rev-parse HEAD | grep -qx "$(COMMON_REVISION)" || exit 1; fi
	@test ! -d include/infiltratr || { echo "Copied Common headers forbidden"; exit 1; }
$(COMMON_ARCHIVE): common-check
	@mkdir -p "$(COMMON_BUILD_DIR)"
	$(MAKE) -C "$(COMMON_DIR)" CC="$(CC)" BUILD_DIR="$(COMMON_BUILD_DIR)" CFLAGS="$(CFLAGS) -Wno-missing-profile" all
$(BUILD_DIR)/obj/%.o: src/%.c
	@mkdir -p "$(@D)"
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEP_CFLAGS) -c "$<" -o "$@"
$(BUILD_DIR)/obj/%.o: src/%.cpp
	@mkdir -p "$(@D)"
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEP_CFLAGS) -c "$<" -o "$@"
all: $(COMMON_ARCHIVE) $(C_OBJECTS) $(CXX_OBJECTS)
	@mkdir -p "$(BUILD_DIR)"
	$(CXX) -shared $(C_OBJECTS) $(CXX_OBJECTS) $(COMMON_ARCHIVE) \
	    -Wl,--version-script=exports.map -Wl,-z,defs -Wl,--gc-sections \
	    $(LDFLAGS) -o "$(TARGET)" $(LDLIBS)
check: all
	bash common/calendar-tools/check.sh "$(TARGET)"
audit-authorities: all
	bash common/calendar-tools/check.sh "$(TARGET)" --authorities
clean:
	rm -rf "$(BUILD_DIR)"
release:
	bash common/calendar-tools/build.sh release
deb:
	bash common/calendar-tools/build.sh deb --profile portable
native-deb:
	bash common/calendar-tools/build.sh deb --profile aggressive
