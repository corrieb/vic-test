FROM debian

RUN mkdir /foo

COPY runtest.sh /foo
RUN chmod +x /runtest.sh

WORKDIR /foo

CMD runtest.sh 
