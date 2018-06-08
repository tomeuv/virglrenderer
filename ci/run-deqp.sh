export XDG_RUNTIME_DIR=/tmp

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

cd /usr/local/piglit
mkdir -p /virglrenderer/results

export WAYLAND_DISPLAY=wayland-0
export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
export PIGLIT_DEQP_GLES2_BIN=/usr/local/VK-GL-CTS/build/modules/gles2/deqp-gles2
export PIGLIT_DEQP_GLES3_BIN=/usr/local/VK-GL-CTS/build/modules/gles3/deqp-gles3

./piglit run -v -p wayland -x glx tests/deqp_gles2.py /virglrenderer/results
# tests/deqp_gles3.py tests/opengl.py
