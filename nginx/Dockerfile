FROM openresty/openresty:alpine-fat

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-http
RUN /usr/local/openresty/luajit/bin/luarocks install lua-protobuf

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY default.conf /etc/nginx/conf.d/default.conf

COPY script.lua /etc/nginx/conf.d/script.lua

RUN mkdir -p /var/log/nginx && chmod 777 /var/log/nginx

EXPOSE 8080

CMD ["openresty", "-g", "daemon off;"]
