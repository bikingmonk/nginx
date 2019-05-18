FROM centos:centos7

COPY ./build.sh /opt

RUN chmod +x /opt/build.sh && ./opt/build.sh

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]