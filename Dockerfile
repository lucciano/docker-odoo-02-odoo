FROM lucciano/odoo-base:13.0-c50e5a1302a7aed277a758d97c06b7b76ea7432c
MAINTAINER Lucas Soto <lsoto@ganargan.ar>

USER root

# Create missing 'cache' folder for PyAFIPws.
RUN mkdir -p /usr/local/lib/python3.6/site-packages/pyafipws/cache
RUN chown -R odoo:odoo /usr/local/lib/python3.6/site-packages/pyafipws/cache

# Change minimum OpenSSL security level to fix current connection problems with AFIP.
RUN sed  -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/" /etc/ssl/openssl.cnf

USER odoo