set -ex

#DEBIAN_FRONTEND=noninteractive apt-get -y install apitrace

echo "Starting weston in the host"
mkdir -p /etc/xdg/weston
printf "[core]\nrequire-input=false\n" > /etc/xdg/weston/weston.ini
nohup /usr/bin/openvt -c 8 -w -v -- weston --backend=drm-backend.so --log weston.log &
sleep 1
cat weston.log

echo "Starting guest"
fakemachine -v /virglrenderer:/virglrenderer sh /virglrenderer/ci/run-deqp.sh

