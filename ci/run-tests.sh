echo "Starting weston in the host"
nohup weston --backend=headless-backend.so &
sleep 3

time dd if=/usr/bin/qemu-system-x86_64 of=/dev/null

time dd if=/usr/bin/qemu-system-x86_64 of=/dev/null

echo "Starting guest"
fakemachine -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh

