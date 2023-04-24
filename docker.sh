docker network create -d bridge f1-league-admin-network

docker run -d --restart unless-stopped --network f1-league-admin-network --platform linux/amd64 \
-e POSTGRES_USER=strapi \
-e POSTGRES_PASSWORD=strapi \
-e POSTGRES_DB=f1-league-admin \
-p 5432:5432 \
-v f1-league-admin-data:/var/lib/postgresql/data/ \
--name f1-league-admin-database postgres:12.0-alpine

docker build -t f1-league-admin:latest .

docker run -it --restart unless-stopped --network f1-league-admin-network \
-e DATABASE_HOST=f1-league-admin-database \
-p 1337:1337 \
-v "$(pwd)"/config:/opt/app/config \
-v "$(pwd)"/src:/opt/app/src \
-v "$(pwd)"/package.json:/opt/package.json \
-v "$(pwd)"/package-lock.json:/opt/package-lock.json \
-v "$(pwd)"/.npmrc:/opt/.npmrc \
--name f1-league-admin f1-league-admin:latest


# run PGADMIN locally (http://localhost:85/browser/)
# docker network create -d bridge docker_default
# docker run -p 85:80 --network docker_default -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' -e 'PGADMIN_DEFAULT_PASSWORD=123456' -d dpage/pgadmin4
