echo "Starting weston in the host"
nohup weston --backend=headless-backend.so &
sleep 3

DEBIAN_FRONTEND=noninteractive apt-get -y install kbd

echo "Starting guest"
fakemachine -v /etc/pam.d:/etc/pam.d -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh

