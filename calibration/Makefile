BUILD_DIR=build
DIST_DIR=dist

run:
	processing-java  --sketch=`pwd` --output=`pwd`/$(BUILD_DIR) --force --run

export: export_mac export_windows

export_mac:
	processing-java  --sketch=`pwd` --output=`pwd`/$(DIST_DIR)/mac --platform=macosx --force --export

export_windows:
	processing-java  --sketch=`pwd` --output=`pwd`/$(DIST_DIR)/windows --platform=windows --force --export

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)
