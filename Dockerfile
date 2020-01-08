FROM alpine:latest

ARG openssl_version=1.0.2u

# Install OpenSSL
RUN \
 apk --update --no-cache add build-base perl \
 && wget https://openssl.org/source/openssl-$openssl_version.tar.gz \
 && tar -xvf openssl-$openssl_version.tar.gz \
 && cd openssl-$openssl_version \
 && ./config --prefix=`pwd`/local --openssldir=/usr/lib/ssl enable-ssl2 enable-ssl3 no-shared \
 && make depend \
 && make \
 && make -i install \
 && cp local/bin/openssl /usr/local/bin/ \
 && cd .. \
 && rm -rf openssl-$openssl_version \
 && rm openssl-$openssl_version.tar.gz \
 && rm -rf "/var/cache/apk/*"

# Create and set mount volume
WORKDIR /openssl-certs
VOLUME  /openssl-certs

ENTRYPOINT ["openssl"]