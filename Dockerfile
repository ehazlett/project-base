FROM alpine:latest
COPY build/react-base /bin/app
ADD build/public /bin/public
WORKDIR /bin
ENTRYPOINT ["/bin/app"]
EXPOSE 8080
