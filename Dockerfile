FROM node:12.16.2 as base

ENV NODE_ENV=production
EXPOSE 4567
WORKDIR /app
RUN mkdir app && chown -R node:node /app
COPY package*.json ./
USER node 
RUN npm ci && npm cache clean --force
COPY --chown=node:node . .


FROM base as dev  

ENV NODE_ENV=development
RUN npm install && npm cache clean --force   
RUN npm test
CMD [ "node", "./MessageQueue/app.js" ]


FROM dev as test

RUN npm test
RUN npm audit


FROM base as prod

RUN rm -rf ./tests 
CMD [ "node", "./MessageQueue/app.js" ]
