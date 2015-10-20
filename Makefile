TARGET = iphone:clang:latest:9.0
ARCHS = armv7 armv7s arm64 
GO_EASY_ON_ME = 1
DEBUG = 0
export ADDITIONAL_LDFLAGS = -Wl,-segalign,4000

include theos/makefiles/common.mk

TWEAK_NAME = MapsSBHidden
MapsSBHidden_FILES = Tweak.xm
MapsSBHidden_FRAMEWORK = UIKit Foundation
MapsSBHidden_CFLAGS += -DVERBOSE

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += mapssbhiddenpreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
