FROM jenkinsci/jnlp-slave:latest

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

USER root

# Let's start with some basic stuff.
RUN apt-get update -qqy && apt-get install -qqy apt-transport-https ca-certificates curl lxc iptables

# Install gcloud
RUN apt-get install -y jq libapparmor-dev libseccomp-dev
RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt
RUN gcloud components install kubectl docker-credential-gcr

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
COPY wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install php and composer
RUN apt-get install -y software-properties-common
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt update
RUN apt install -y php7.1 php7.1-common php7.1-cli php7.1-fpm php7.1-curl php7.1-bcmath php7.1-gd php7.1-geoip \
    php7.1-gmp php7.1-imagick php7.1-intl php7.1-json php7.1-mbstring php7.1-memcached php7.1-mcrypt php7.1-mysql \
    php7.1-redis php7.1-opcache php-pear php7.1-pspell php7.1-soap php7.1-xml php7.1-zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]
