FROM node
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
ARG data
ENV DATA_FILE=$data
EXPOSE 3000
CMD ["node", "index.js"]
