FROM pragmaticlab/odoo-ce:11.0

# Add dependencies needed to build PyAFIPws
USER root
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    python-dev \
    swig  \
    libffi-dev  \
    libssl-dev  \
    python-m2crypto  \
    python-httplib2 \
    # pip dependencies that require build deps
    && sudo -H -u odoo pip install --user --no-cache-dir pyOpenSSL M2Crypto httplib2>=0.7 git+https://github.com/pysimplesoap/pysimplesoap@a330d9c4af1b007fe1436f979ff0b9f66613136e \
    # purge
    && apt-get purge -yqq build-essential '*-dev' make || true \
    && apt-get -yqq autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER odoo

# Add new entrypoints and configs
COPY entrypoint.d/* $RESOURCES/entrypoint.d/
COPY conf.d/* $RESOURCES/conf.d/
COPY resources/$ODOO_VERSION/* $RESOURCES/

# Aggregate new repositories of this image
RUN autoaggregate --config "$RESOURCES/repos.yml" --install --output $SOURCES/repositories
