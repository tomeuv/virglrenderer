systemctl start weston
sleep 3
systemctl status weston
WAYLAND_DISPLAY=wayland-0 $ROOT_DIR/install-prefix/VK-GL-CTS/build/external/openglcts/modules/glcts --deqp-case=dEQP-GLES3.*

