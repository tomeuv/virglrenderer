export XDG_RUNTIME_DIR=/tmp

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

export WAYLAND_DISPLAY=wayland-0
export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
export PIGLIT_DEQP_GLES2_BIN=/usr/local/VK-GL-CTS/build/modules/gles2/deqp-gles2
export PIGLIT_DEQP_GLES3_BIN=/usr/local/VK-GL-CTS/build/modules/gles3/deqp-gles3

cd /usr/local/VK-GL-CTS/build/external/openglcts/modules/
time ./glcts --deqp-case=dEQP-GLES2.capability.limits.*

time ./glcts --deqp-case=dEQP-GLES2.capability.limits.* --deqp-watchdog=enable

time ./glcts --deqp-case=dEQP-GLES2.capability.limits.* --deqp-crashhandler=enable

time ./glcts --deqp-case=dEQP-GLES2.capability.limits.* --deqp-watchdog=enable --deqp-crashhandler=enable

cd /usr/local/piglit
mkdir -p /virglrenderer/results

export PIGLIT_DEQP_EXTRA_ARGS=""
time ./piglit run -p wayland -t limits deqp_gles2 /virglrenderer/results

export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable"
time ./piglit run -p wayland -t limits deqp_gles2 /virglrenderer/results

export PIGLIT_DEQP_EXTRA_ARGS="--deqp-crashhandler=enable"
time ./piglit run -p wayland -t limits deqp_gles2 /virglrenderer/results

export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
time ./piglit run -p wayland -t limits deqp_gles2 /virglrenderer/results

#./piglit run -p wayland deqp_gles2 deqp_gles3 /virglrenderer/results
