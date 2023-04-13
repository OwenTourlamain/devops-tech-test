import { PrismaClient } from "@prisma/client";
import Fastify from "fastify";

const fastify = Fastify({
  logger: true,
});

fastify.get("/fetchConsumptionData", async (_req, res) => {
  const prisma = new PrismaClient();

  const data = await prisma.data.findMany();

  res.send({ status: "ok", data });
});

fastify.listen({ port: 3000 }, (err, _addr) => {
  if (err) throw err;
});
