if [ -d "/dev/dri" ]; then
/usr/bin/weston --use-pixman --modules=systemd-notify.so
else
/usr/bin/weston --backend=headless-backend.so --use-pixman --modules=systemd-notify.so
fi
