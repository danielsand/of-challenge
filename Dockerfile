FROM golang:alpine as builder
RUN mkdir /build
ADD ./simple-service/ /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o simple-service .



FROM scratch
COPY --from=builder /build/simple-service /app/
WORKDIR /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 8000

CMD ["./simple-service"]
