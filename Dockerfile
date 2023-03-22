FROM jenkins/jenkins:2.396-jdk17

# switching to root user for installation of additional apps
USER root

# INSTALLATION OF DOCKER: START
RUN apt-get update && apt-get install -qqy \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
RUN apt-get update && apt-get install -qqy docker-ce docker-ce-cli containerd.io docker-compose-plugin
# INSTALLATION OF DOCKER: END

# INSTALLATION OF MYSQL/MARIADB CLIENT: START
RUN apt-get install -qqy mariadb-client
# INSTALLATION OF MYSQL/MARIADB CLIENT: END

# INSTALLATION OF RSYNC: START
RUN apt-get install -qqy rsync sshpass
# INSTALLATION OF RSYNC: END

# INSTALLATION OF POSTGRES CLIENT: START
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -qqy postgresql-client-15
# INSTALLATION OF POSTGRES CLIENT: END

# INSTALLATION OF INFLUX CLI START
RUN mkdir -p /tmp/influx-cli/extract/
RUN curl https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.5.0-linux-amd64.tar.gz -o /tmp/influx-cli/influxdb2-client.tar.gz
RUN tar xvzf /tmp/influx-cli/influxdb2-client.tar.gz -C /tmp/influx-cli/extract/
RUN cp /tmp/influx-cli/extract/influxdb2-client-2.5.0-linux-amd64/influx /usr/local/bin/
# INSTALLATION OF INFLUX CLI END

# INSTALLATION OF LIQUIBASE CLI START
RUN mkdir -p /tmp/liquibase/extract/
RUN curl https://github.com/liquibase/liquibase/releases/latest/download/liquibase-4.20.0.tar.gz -L -o /tmp/liquibase/liquibase.tar.gz
RUN tar xvzf /tmp/liquibase/liquibase.tar.gz -C /tmp/liquibase/extract/
RUN ln -s /tmp/liquibase/extract/liquibase /usr/bin/liquibase
# INSTALLATION OF LIQUIBASE CLI END

RUN usermod -aG docker jenkins
