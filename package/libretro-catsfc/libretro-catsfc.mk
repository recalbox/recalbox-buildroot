################################################################################
#
# CATSFC
#
################################################################################
LIBRETRO_CATSFC_VERSION = a25a25f9a1327a996fe4ff37d3bfb7e3c15d174e
LIBRETRO_CATSFC_SITE = $(call github,libretro,snes9x2005,$(LIBRETRO_CATSFC_VERSION))

define LIBRETRO_CATSFC_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_BOARD)"
endef

define LIBRETRO_CATSFC_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/snes9x2005_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/catsfc_libretro.so
endef

$(eval $(generic-package))
