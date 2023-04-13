# DevOps Brief

## Objective

To develop a system for ingesting and storing National Grid consumption data every hour and providing access to the data through a public API. We expect the API to increase in load linearly over the next three years

## Requirements

- Infrastructure must be managed by Terraform
- You must use the GCP platform
- You must have Node installed on your machine

## Deliverables

- A system for ingesting National Grid consumption data every hour
- A persistent data store for storing the ingested data
- A public API for accessing the stored data (supplied)
- A deployed API and infrastructure
- Example usage of the API using CURL or Postman

## Bonus points

- Implement monitoring and logging capabilities
- CI/CD pipeline that deploys the infra and code
- Documentation on how to use the API

## Instructions

- You must setup a persistent data store and update the `.env` file in the data directory to point to your chosen data store and update the provider block and update the provider block in the schema.prisma file to be the chosen DB provider e.g. postgressql, mysql, cockroachdb
- There are two ways to ingest the data, either by a cloud function or a simple NodeJS application that could be containerized (this can be found in the `data` directory)
- There are two ways to fetch the data, either by a cloud function or a simple NodeJS application that could be containerized (this can be found in the `data` directory)
- Prisma is being used as the ORM for this project - When setting up your persistent store, you can choose from any of the supported **SQL** DB's listed on Prismas website (https://www.prisma.io/docs/reference/database-reference/supported-databases)
- When you are ready, just run `npx prisma db push` to migrate your DB schema (you can do this locally or via a CI/CD pipeline)

- To build the applications do the following
  - `cd data`
  - `npm install`
  - `npx prisma generate`
  - `npm run build`

The above commands will output the compiled code in the `dist` directory inside the `data` directory

You can then deploy the code to a cloud function or containerize it and deploy it to a container platform
