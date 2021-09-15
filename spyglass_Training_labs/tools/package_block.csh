#!/bin/csh -f

mkdir -p ../spyglass/wb_subsystem_package/spyglass
cp -r ../rtl ../spyglass/wb_subsystem_package/rtl
cp ../spyglass/wb_subsystem.prj ../spyglass/wb_subsystem_package/spyglass/wb_subsystem.prj
cp -r ../spyglass/wb_subsystem/html_reports ../spyglass/wb_subsystem_package/spyglass/

