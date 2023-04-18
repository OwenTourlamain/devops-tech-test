I have created the terraform infrastructure that I would use for this project. Unfortunately I was unable to set up Cloud Run which would be my preferred CI solution (I believe this was due to my account being older and unable to use some of the free features). Instead I have provided a build.sh which emulates the rough CI pipeline that I would use. 

I have omitted the Database URL from .env for security reasons, ideally I'd set this up to use env vars and/or a secrets manager if needed.

To deploy this project, first put a valid database URL in .env. Then a creds.json should be placed in the repository root, with the key for a service account with the appropriate permissions.

Next run ./build.sh from the repository root. This will complete all the local build steps, then execute terraform apply. 

I have chosen to use the Cloud Functions solution as I think that containerising this project could be overkill, but would need to discuss requirements to be sure.

I have also left the HTTP endpoints secured, however this could easily be changed to a public function if needed.