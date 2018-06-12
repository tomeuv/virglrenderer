echo "Starting weston in the host"
nohup weston --backend=headless-backend.so &
sleep 1

DEBIAN_FRONTEND=noninteractive apt-get -y install sysstat

iostat -mxzs 5 &

echo "Starting guest"
fakemachine -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh

