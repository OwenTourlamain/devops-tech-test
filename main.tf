terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("creds.json")

  project = "sero-test-383419"
  region  = "europe-west2"
  zone    = "europe-west2-b"
}

resource "google_storage_bucket" "fetch_bucket" {
  name     = "sero-test-bucket-fetch"
  location = "EU"
}

resource "google_storage_bucket" "ingest_bucket" {
  name     = "sero-test-bucket-ingest"
  location = "EU"
}

resource "google_storage_bucket_object" "fetch_archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.fetch_bucket.name
  source = "data/dist/fetchFunction.zip"
}

resource "google_storage_bucket_object" "ingest_archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.ingest_bucket.name
  source = "data/dist/ingestFunction.zip"
}

resource "google_cloudfunctions_function" "fetch_function" {
  name        = "sero-fetch-test"
  description = "Fetch function"
  runtime     = "nodejs16"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.fetch_bucket.name
  source_archive_object        = google_storage_bucket_object.fetch_archive.name
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "fetchConsumptionData"
}

resource "google_cloudfunctions_function" "ingest_function" {
  name        = "sero-ingest-test"
  description = "Ingest function"
  runtime     = "nodejs16"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.ingest_bucket.name
  source_archive_object        = google_storage_bucket_object.ingest_archive.name
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "ingestConsumptionData"
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "fetch_invoker" {
  project        = google_cloudfunctions_function.fetch_function.project
  region         = google_cloudfunctions_function.fetch_function.region
  cloud_function = google_cloudfunctions_function.fetch_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "user:owen.tourlamain@gmail.com"
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "ingest_invoker" {
  project        = google_cloudfunctions_function.ingest_function.project
  region         = google_cloudfunctions_function.ingest_function.region
  cloud_function = google_cloudfunctions_function.ingest_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "user:owen.tourlamain@gmail.com"
}