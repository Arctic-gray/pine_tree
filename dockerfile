# ������� �����
FROM debian:10

# ��������� �������� ������� � ������������
RUN apt-get update
RUN apt-get -y install cookiecutter python-setuptools dpkg-dev devscripts wget equivs 

#������ � ���������� ������ ������ ��������� 
CMD /bin/bash