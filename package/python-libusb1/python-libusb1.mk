################################################################################
#
# python-libusb1
#
################################################################################

PYTHON_LIBUSB1_VERSION = 1.6
PYTHON_LIBUSB1_SITE = $(call github,vpelletier,python-libusb1,$(PYTHON_LIBUSB1_VERSION))
PYTHON_LIBUSB1_LICENSE = GPLv2
PYTHON_LIBUSB1_LICENSE_FILES = LICENSE
PYTHON_LIBUSB1_SETUP_TYPE = setuptools
PYTHON_LIBUSB1_DEPENDENCIES = libusb

$(eval $(python-package))
