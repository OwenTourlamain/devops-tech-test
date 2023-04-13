import * as functions from "@google-cloud/functions-framework";
import fetch from "node-fetch";
import { PrismaClient } from "@prisma/client";

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

functions.http("ingestConsumptionData", async (_req, res) => {
  const r = await fetch(
    "https://api.carbonintensity.org.uk/intensity/2023-01-01T10:00/2023-01-01T11:00"
  );

  const response = (await r.json()) as { data: ConsumptionData };

  const prisma = new PrismaClient();

  await prisma.data.create({
    data: {
      from: response.data.from,
      to: response.data.to,
      forecast: response.data.intensity.forecast,
      actual: response.data.intensity.actual,
    },
  });

  res.send({ status: "ok", data: response.data });
});
