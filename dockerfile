# базовый образ
FROM debian:10

# установка желаемых пакетов и зависимостей
RUN apt-get update
RUN apt-get -y install cookiecutter python-setuptools dpkg-dev devscripts wget equivs 

#Доступ к выполнению команд внутри терминала 
CMD /bin/bash