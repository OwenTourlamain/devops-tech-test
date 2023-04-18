#!/bin/bash

cd data
rm -r dist
npm install
npx prisma generate
npm run build
cp package.json dist/package.json
cd dist
mv fetchConsumptionDataFunction.js function.js
zip -r fetchFunction.zip package.json function.js
rm function.js
mv ingestConsumptionDataFunction.js function.js
zip -r ingestFunction.zip package.json function.js
rm *.js
rm package.json
cd ../../
terraform apply

