export XDG_RUNTIME_DIR=/tmp

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

cd /usr/local/VK-GL-CTS/build/external/openglcts/modules

echo "Running GLES2 on GLES"
WAYLAND_DISPLAY=wayland-0 ./glcts --deqp-caselist-file=/virglrenderer/ci/deqp-gles2-gles.txt

echo "Running GLES3 on GLES"
WAYLAND_DISPLAY=wayland-0 ./glcts --deqp-caselist-file=/virglrenderer/ci/deqp-gles3-gles.txt

sleep 3

