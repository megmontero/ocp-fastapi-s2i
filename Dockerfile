# fastapi-s2i
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7
ARG BUILD_DATE
LABEL maintainer="Manolo Gomez <mnlgmontero@gmail.com>" \ 
      org.label-schema.build-date=$BUILD_DATE

ENV BUILDER_VERSION 1.0
ENV PIP_CONFIG_FILE "/conf/pip.conf"
LABEL io.k8s.description="Platform for building apis with fastapi" \
      io.k8s.display-name="builder fastapi" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="fastapi,s2i,python,python3.7"


# sets io.openshift.s2i.scripts-url label that way, or update that label
LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
COPY ./s2i/bin/ /usr/libexec/s2i


RUN mkdir /.local /.cache /conf  && chmod -R 777 /usr/local /.local /.cache /app 
COPY ./start.sh /
COPY ./conf /conf/
RUN chmod -R 644  /conf && chmod 755 /start.sh /conf
EXPOSE 8080
USER 1001
CMD ["/usr/libexec/s2i/usage"]
