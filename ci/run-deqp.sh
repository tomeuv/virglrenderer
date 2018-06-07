echo "Starting weston in the guest"
/usr/bin/weston --use-pixman
sleep 3

echo "Running dEQP-GLES3.*"
WAYLAND_DISPLAY=wayland-0 /usr/local/VK-GL-CTS/build/external/openglcts/modules/glcts --deqp-case=dEQP-GLES3.*
sleep 3

