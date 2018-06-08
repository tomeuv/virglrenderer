export XDG_RUNTIME_DIR=/tmp

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

cd /usr/local/piglit
mkdir -p /virglrenderer/results

WAYLAND_DISPLAY=wayland-0 ./piglit -x glx tests/deqp_gles3.py tests/opengl.py /virglrenderer/results

