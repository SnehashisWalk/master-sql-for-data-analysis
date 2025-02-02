# Master SQL for Data Analysis 🚀
My learning for the book Master SQL for Data Analysis by the author Idan Gabrieli (Packt published)

The files shared in the repository are my learnings the data files are by the author Idan Gabrieli (Packt), I have added them for anyone who wants to learn.

I liked the lessons and while learning I thought to publish my learnings on GitHub.

## Instructions for running PostgreSQL and PgAdmin on Docker

The docker compose file has all the settings for you to run Docker images for PostgreSQL and PgAdmin you can configure the file as per your needs.

To build and run the containers:
```bash
docker-compose up
```

To copy the csv file from your local machine to Docker volumes so that you can use the dataset

```bash
docker cp ~/Downloads/credits.csv postgres:/tmp/credits.csv
```

