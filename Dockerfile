FROM jekyll/jekyll

ENV SITENAME = 'blog_devontaps'
COPY . .

RUN chown -R jekyll /usr/gem && \
    jekyll new ${SITENAME} && \
    cd ${SITENAME}
