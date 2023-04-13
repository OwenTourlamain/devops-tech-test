import * as functions from "@google-cloud/functions-framework";
import { PrismaClient } from "@prisma/client";

functions.http("fetchConsumptionData", async (_req, res) => {
  const prisma = new PrismaClient();

  const data = await prisma.data.findMany();

  res.send({ status: "ok", data });
});
