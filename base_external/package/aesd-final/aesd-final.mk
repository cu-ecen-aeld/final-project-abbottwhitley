##############################################################
#
# AESD-FINAL
#
##############################################################

AESD_FINAL_VERSION=81ad1c9591fb3354821891d32e1a401723cb91cc
AESD_FINAL_SITE = git@github.com:cu-ecen-5013/opencv-monitoring-system.git
AESD_FINAL_SITE_METHOD = git
AESD_FINAL_GIT_SUBMODULES = YES

#AESD_FINAL_VERSION=1
#AESD_FINAL_SITE = $(TOPDIR)/../../opencv-monitoring-system
#AESD_FINAL_SITE_METHOD = local

define AESD_FINAL_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/camera_app/cpp all
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/controller_app/cpp all
endef


# TODO add your writer, finder and tester utilities/scripts to the installation steps below
define AESD_FINAL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(TOPDIR)/../base_external/rootfs_overlay/network/interfaces ${TARGET_DIR}/etc/network
	$(INSTALL) -m 0755 package/busybox/S10mdev ${TARGET_DIR}/etc/init.d/S10mdev
	$(INSTALL) -m 0755 package/busybox/mdev.conf ${TARGET_DIR}/etc/mdev.conf
	# ~~~ Camera Applications ~~~
	# Video Streaming Server (Python / HTML)
	$(INSTALL) -d 0755 $(@D)/camera_app/python/ $(TARGET_DIR)/usr/bin/opencv/camera_app/python
    $(INSTALL) -d 0755 $(@D)/camera_app/python/templates $(TARGET_DIR)/usr/bin/opencv/camera_app/python/templates
    $(INSTALL) -m 0755 $(@D)/camera_app/python/main.py $(TARGET_DIR)/usr/bin/opencv/camera_app/python
    $(INSTALL) -m 0755 $(@D)/camera_app/python/camera.py $(TARGET_DIR)/usr/bin/opencv/camera_app/python
    $(INSTALL) -m 0755 $(@D)/camera_app/python/templates/index.html $(TARGET_DIR)/usr/bin/opencv/camera_app/python/templates
    $(INSTALL) -m 0755 $(@D)/camera_app/python/pyServer-start-stop ${TARGET_DIR}/etc/init.d/S99_pyServer-start-stop

	# Video Streaming Server w/Face detection (C++)
	$(INSTALL) -d 0755 $(@D)/camera_app/cpp/ $(TARGET_DIR)/usr/bin/opencv/camera_app/cpp
	$(INSTALL) -m 0755 $(@D)/camera_app/cpp/server $(TARGET_DIR)/usr/bin/opencv/camera_app/cpp
	$(INSTALL) -m 0755 $(@D)/camera_app/cpp/opencvServer-start-stop $(TARGET_DIR)/etc/init.d/S98_opencvServer-start-stop
	# Face detection xml files
	$(INSTALL) -d 0755 $(@D)/camera_app/cpp/xml $(TARGET_DIR)/usr/bin/opencv/camera_app/cpp/xml
	$(INSTALL) -m 0755 $(@D)/camera_app/cpp/xml/* $(TARGET_DIR)/usr/bin/opencv/camera_app/cpp/xml

endef

$(eval $(generic-package))
