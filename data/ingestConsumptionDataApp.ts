import fetch from "node-fetch";
import { PrismaClient } from "@prisma/client";
import Fastify from "fastify";

type CarbonIntensity = {
  forecast: number;
  actual: number;
  index: "low" | "moderate" | "high" | "very high";
};

type ConsumptionData = {
  from: string;
  to: string;
  intensity: CarbonIntensity;
};

const fastify = Fastify({
  logger: true,
});

fastify.get("/ingestConsumptionData", async (_req, res) => {
  const r = await fetch(
    "https://api.carbonintensity.org.uk/intensity/2023-01-01T10:00/2023-01-01T11:00"
  );

  const response = (await r.json()) as { data: ConsumptionData[] };

  console.log(response.data[0].intensity);

  const prisma = new PrismaClient();

  await prisma.data.create({
    data: {
      from: response.data[0].from,
      to: response.data[0].to,
      forecast: response.data[0].intensity.forecast,
      actual: response.data[0].intensity.actual,
    },
  });

  res.send({ status: "ok", data: response.data });
});

fastify.listen({ port: 3000 }, (err, _addr) => {
  if (err) throw err;
});