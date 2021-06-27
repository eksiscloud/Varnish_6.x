Uses separate vcls for every backend. It should be easier to tune up needs of every backend. It just doesn't work so nicely. Main reason might be my setup where some of backends are in Apache, some are behind Nginx and some are using socket.

This setup isn't totally finished because I gave up.

== Issues ==

- call <something) doesn't work so good
- Discourse and MediaWiki must be in same vcl. If not, then only the first loaded will work
- reloading is really difficult and I didn't succeed ever

== start.cli ==

Because every main-vcl must be loaded and after that they have to be named as alias, it should do using CLI. The file start.cli will do the job, but it has to be told to Vsrnish

systemctl edit --full varnish

ExecStart=/usr/sbin/varnishd -I /etc/varnish/start.cli -P /var/run/varnish.pid -j unix,user=vcache -F -a :8080 -T localhost:6082 -f "" -S /etc/varnish/secret -s malloc,10G

Most important parts are 
-I /etc/varnish/start.cli
and
-f ""

systemctl daemon-reload

== Source ==

https://info.varnish-software.com/blog/one-vcl-per-domain