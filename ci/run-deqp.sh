export XDG_RUNTIME_DIR=/tmp

echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

cat weston.log

echo "Running dEQP-GLES3.*"
WAYLAND_DISPLAY=wayland-0 /usr/local/VK-GL-CTS/build/external/openglcts/modules/glcts --deqp-case=dEQP-GLES3.*
sleep 3

