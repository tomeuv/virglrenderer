systemctl start weston
sleep 3
PAGER= systemctl status weston
PAGER= journalctl -b
WAYLAND_DISPLAY=wayland-0 $ROOT_DIR/install-prefix/VK-GL-CTS/build/external/openglcts/modules/glcts --deqp-case=dEQP-GLES3.*
sleep 3

