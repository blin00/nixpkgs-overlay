# chronyc chokes since chronyd restarts (dns?), so call it lots of times
for i in {1..180}; do
    sleep 1
    chronyc waitsync 1 0.1 0 1 && exit 0
done
exit 1
