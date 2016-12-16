################################################################################
#
# steamcontroller
#
################################################################################
STEAMCONTROLLER_VERSION = 99852e6114a6ccc3324efab3b65219d2f2ba6469
STEAMCONTROLLER_SITE =  $(call github,ynsta,steamcontroller,$(STEAMCONTROLLER_VERSION))

STEAMCONTROLLER_SETUP_TYPE=setuptools
STEAMCONTROLLER_LICENSE = MIT
STEAMCONTROLLER_LICENSE_FILES = LICENCE
#STEAMCONTROLLER_DEPENDENCIES = linux, udev

# Install udev rules for usb device
define STEAMCONTROLLER_POST_INSTALL_TARGET_UDEV_RULES
    $(INSTALL) -D -m 0755 package/steamcontroller/99-steam-controller.rules $(TARGET_DIR)/etc/udev/rules.d/99-steam-controller.rules
endef

# Install service
define STEAMCONTROLLER_POST_INSTALL_TARGET_SERVICE
	$(INSTALL) -m 0755 -D package/steamcontroller/S92steamcontroller $(TARGET_DIR)/etc/init.d/S92steamcontroller
endef

# Install input headers
define STEAMCONTROLLER_POST_INSTALL_INPUT_HEADERS
	$(INSTALL) -m 0755 -D $(STAGING_DIR)/usr/include/linux/input-event-codes.h $(TARGET_DIR)/usr/include/linux/input-event-codes.h
	$(INSTALL) -m 0755 -D $(STAGING_DIR)/usr/include/linux/input.h $(TARGET_DIR)/usr/include/linux/input.h
endef


STEAMCONTROLLER_POST_INSTALL_TARGET_HOOKS += STEAMCONTROLLER_POST_INSTALL_TARGET_UDEV_RULES
STEAMCONTROLLER_POST_INSTALL_TARGET_HOOKS += STEAMCONTROLLER_POST_INSTALL_TARGET_SERVICE
STEAMCONTROLLER_POST_INSTALL_TARGET_HOOKS += STEAMCONTROLLER_POST_INSTALL_INPUT_HEADERS

$(eval $(python-package))

