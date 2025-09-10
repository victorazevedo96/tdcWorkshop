#Imagem Base
FROM node:22-alpine

WORKDIR /app

COPY package.json .

RUN npm install

# Copia o restante dos arquivos -> utilização do cache do docker
COPY . .

EXPOSE 8080

RUN chmod +x node_modules/.bin/*

CMD [ "npm", "run", "dev" ]