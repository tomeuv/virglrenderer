echo "Starting weston in the host"
nohup weston --backend=headless-backend.so &
sleep 3

echo "Starting guest"
fakemachine -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh
