# Use CentOS 7.1 as base
FROM centos:7.1.1503

# Needed to make it build
RUN yum swap -y fakesystemd systemd && \
    yum install -y systemd-devel


# Start by installing security-updates, then install the packages we need --
# MariaDB-libs, python, util stuff, gcc to be able to compile stuff. Also 
# install debugging tools (you will appreciate those when something breaks).
RUN yum makecache fast                                          && \
    yum upgrade -y						&& \
    yum update -y                                               && \
    yum install -y epel-release			&& \
    yum install -y	python 				\
			python-pip 			\
			python-virtualenv	 	\
			python-devel			\
			mariadb-devel 			\
			mariadb-libs 			\
			telnet 				\
			net-tools 			\
			iputils 			\
			hostname	        	\
		 	gcc 				\
    			glibc-devel 			\
			libgcc 				\
			libcurl-devel 			\
			openssl-devel			\
			mod_wsgi		&& \
    yum clean all

#
# Configure Apache a bit:
#
# Remove support for DAV, Lua, CGI, proxy, etc. -- we will
# never use these. 
#
# Further, disable MMAP and Sendfile support (if enabled), as 
# it is not useful (we will not be serving static files).
# 

RUN rm -f /etc/httpd/conf.d/welcome.conf									  				&& \
	rm -f /etc/httpd/conf.modules.d/00-dav.conf												&& \
	rm -f /etc/httpd/conf.modules.d/00-lua.conf												&& \
	rm -f /etc/httpd/conf.modules.d/00-proxy.conf												&& \
	rm -f /etc/httpd/conf.modules.d/01-cgi.conf												&& \
	rm -f /etc/httpd/conf.d/autoindex.conf													&& \
	rm -f /etc/httpd/conf.d/userdir.conf													&& \
	sed 's/Listen 80$/Listen 8080/' 							-i /etc/httpd/conf/httpd.conf 			&& \
	sed 's/ServerAdmin root\@localhost$/ServerAdmin admin@localhost/' 			-i /etc/httpd/conf/httpd.conf 			&& \
	sed 's/CustomLog /#CustomLog /g'							-i /etc/httpd/conf/httpd.conf			&& \
	sed 's/EnableMMAP on/EnableMMAP off/' 							-i /etc/httpd/conf/httpd.conf 			&& \
	sed 's/EnableSendfile on/EnableSendfile off/' 						-i /etc/httpd/conf/httpd.conf			&& \
	sed 's/LoadModule actions_module modules\/mod_actions.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authn_dbd_module modules\/mod_authn_dbd.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authn_dbm_module modules\/mod_authn_dbm.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authn_socache_module modules\/mod_authn_socache.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authz_dbd_module modules\/mod_authz_dbd.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authz_dbm_module modules\/mod_authz_dbm.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authz_groupfile_module modules\/mod_authz_groupfile.so//'		-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule authz_owner_module modules\/mod_authz_owner.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule autoindex_module modules\/mod_autoindex.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule cache_module modules\/mod_cache.so//'					-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule cache_disk_module modules\/mod_cache_disk.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule data_module modules\/mod_data.so//'					-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule dbd_module modules\/mod_dbd.so//'					-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule echo_module modules\/mod_echo.so//'					-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule expires_module modules\/mod_expires.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule include_module modules\/mod_include.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule logio_module modules\/mod_logio.so//'					-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule slotmem_plain_module modules\/mod_slotmem_plain.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule slotmem_shm_module modules\/mod_slotmem_shm.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule socache_dbm_module modules\/mod_socache_dbm.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule socache_memcache_module modules\/mod_socache_memcache.so//'		-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule status_module modules\/mod_status.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule substitute_module modules\/mod_substitute.so//'			-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule suexec_module modules\/mod_suexec.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule userdir_module modules\/mod_userdir.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	sed 's/LoadModule version_module modules\/mod_version.so//'				-i /etc/httpd/conf.modules.d/00-base.conf	&& \
	chown -R apache:apache /etc/httpd/logs/ /run/httpd/

# Throw in custom Apache config files
ADD docker-files/*.conf /etc/httpd/conf.d/

# Make the logs-folder mountable
VOLUME ["/etc/httpd/logs/"]

# Run as the apache-user
USER apache

# Apache will listen on this port
EXPOSE 8080

# httpd (Apache) is the entrypoint
ENTRYPOINT /usr/sbin/httpd -DFOREGROUND
