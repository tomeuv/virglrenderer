export XDG_RUNTIME_DIR=/tmp
export LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 1

export WAYLAND_DISPLAY=wayland-0
export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
export PIGLIT_DEQP_GLES2_BIN=/usr/local/VK-GL-CTS/modules/gles2/deqp-gles2
export PIGLIT_DEQP_GLES3_BIN=/usr/local/VK-GL-CTS/modules/gles3/deqp-gles3

cd /usr/local/piglit
mkdir -p /virglrenderer/results

#iostat -mxzs 5 &

strace -fc ./piglit run -t etc2 -p wayland deqp_gles2 /virglrenderer/results

./piglit summary console /virglrenderer/results

