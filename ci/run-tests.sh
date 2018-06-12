set -x

echo "Starting weston in the host"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --log weston.log &
sleep 3
cat weston.log

#DEBIAN_FRONTEND=noninteractive apt-get -y install sysstat  linux-base   linux-perf-4.16 

export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
export PIGLIT_DEQP_GLES2_BIN=/usr/local/VK-GL-CTS/modules/gles2/deqp-gles2
export PIGLIT_DEQP_GLES3_BIN=/usr/local/VK-GL-CTS/modules/gles3/deqp-gles3
cd /usr/local/piglit
mkdir -p /virglrenderer/results2

#iostat -mxzs 5 &

#time perf_4.16 record -o perf.data -- ./piglit run -j 12 -c -t color_clear_value_ -p wayland deqp_gles2 /virglrenderer/results2
#PAGER= perf_4.16 report -i ./perf.data -v --stdio | head -1000
#killall iostat


echo "Starting guest"
fakemachine -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh

