FROM debian

RUN mkdir /foo

COPY runtest.sh /foo
RUN chmod +x /foo/runtest.sh

WORKDIR /foo

CMD ./runtest.sh 
