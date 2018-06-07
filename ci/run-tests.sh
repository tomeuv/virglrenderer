nohup weston --backend=headless-backend.so &
sleep 2
fakemachine -v /etc/pam.d:/etc/pam.d -v /virglrenderer:/virglrenderer sh /virglrenderer/run-deqp.sh

