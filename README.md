# Master SQL for Data Analysis 🚀

Link: <a href="https://www.oreilly.com/library/view/master-sql-for/9781837638680" target="_blank">Master SQL for Data Analysis</a>

My learning for the book *Master SQL for Data Analysis* by the author Idan Gabrieli (Packt published).

The files shared in the repository are my learnings. The data files are by the author Idan Gabrieli (Packt). I have added them for anyone who wants to learn.

I liked the lessons and while learning, I thought to publish my learnings on GitHub.

The contents of the materials are:
1. Database Terminology
2. SQL - Creating Databases, Schemas, and Tables
3. SQL - Retrieving Data with Queries
4. SQL - Combining Data from Multiple Tables
5. SQL - Subqueries
6. SQL - Conditional Logic (CASE)
7. SQL - Window Functions
8. SQL - Views & Common Table Expressions (CTE)

## Instructions for Running PostgreSQL and PgAdmin on Docker

The Docker Compose file has all the settings for you to run Docker images for PostgreSQL and PgAdmin. You can configure the file as per your needs.

To build and run the containers:
```bash
docker-compose up
```

To copy the CSV file from your local machine to Docker volumes so that you can use the dataset:
```bash
docker cp ~/Downloads/credits.csv postgres:/tmp/credits.csv
```
