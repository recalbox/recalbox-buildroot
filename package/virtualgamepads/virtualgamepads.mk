################################################################################
#
# VIRTUALGAMEPADS
#
################################################################################
VIRTUALGAMEPADS_VERSION = ea4257ccd434a7bfb61dc6f5a0affed23b5f5e4f
VIRTUALGAMEPADS_BRANCH = recalbox
VIRTUALGAMEPADS_SITE = $(call github,miroof,node-virtual-gamepads,$(VIRTUALGAMEPADS_BRANCH),$(VIRTUALGAMEPADS_VERSION))
VIRTUALGAMEPADS_DEPENDENCIES = nodejs

NPM = $(TARGET_CONFIGURE_OPTS) \
	LD="$(TARGET_CXX)" \
	npm_config_arch=arm \
	npm_config_target_arch=arm \
	npm_config_build_from_source=true \
	npm_config_nodedir=$(BUILD_DIR)/nodejs-$(NODEJS_VERSION) \
	$(HOST_DIR)/usr/bin/npm


define VIRTUALGAMEPADS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/node-virtual-gamepads
	cp -r $(@D)/* \
		$(TARGET_DIR)/usr/node-virtual-gamepads

	cd $(TARGET_DIR)/usr/node-virtual-gamepads && mkdir -p node_modules && \
		$(NPM) install \

endef


define VIRTUALGAMEPADS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/virtualgamepads/S92virtualgamepads $(TARGET_DIR)/etc/init.d/S92virtualgamepads
endef
$(eval $(generic-package))
