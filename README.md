# EstateSearch

Collects orders for & generates reports on people's financial history.

## Main system

A User can define a Case, providing multiple Proof Document records. They can
order multiple Report in bundles.

## Enhanced Notification Service (ENS)

The system has a section for processing an 'ENS' product order.

A collection of FinancialInstitution (FIs) are to be sent a LegalNotice to
ask if they hold details about a person who has died (Cases::Bereavement) or has been
declared unable to manage their own finances (Cases::MentalCapacity).

There are a number of ContactMethod ('ms_graph', 'sendgrid') with a channel
('email' or 'postal') and use different APIs:
e.g. an email could be sent using ms_graph via Risq's Microsoft 365 Outlook
Exchange, or SendGrid could be used.

Each FI has a FinancialInstitutionContactMethod (FICM) for either type of
enquiry (Bereavement/MentalCapacity). This is the current way to contact them.
A new email address can be Confirmed, which sends an email message with content
specified in /app/views/legal_notice_mailer/confirm, or just put Live.

The /admin/reports/_n_/legal_notices/ screen gives an Administrator control over
sending email mailshots (via the queue). Mailshots can be performed whenever
a live FinancialInstitutionContactMethod is available for a FinancialInstitution
that have not been sent one yet. This means that a LegalNotice
sent to a non-functioning email address can be Scrapped,
the FinancialInstitutionContactMethod updated, and a mailshot carried out for
that single record.

A .csv can be generated to manually perform a bulk postal mailing via DocMail.
All live postals can then be marked as sent.

The LegalNotice presents Proof to the FinancialInstitution. These can be
images or PDFs (which will be turned into an image and embedded in the
document). Proofs are provided by the Customer and could be unusable as
provided, e.g. is a multiple page PDF with only 1 relevant page. Each Proof may
be edited to specify which page to use, or to indicate that it should not be
used at all. An Administrator may, offline, capture an image and upload that as
Proof to be used instead.

When a LegalNotice is sent to a FinancialInstitution all the contact details
are copied from the current live FinancialInstitutionContactMethod to the
LegalNotice. This then acts as an audit record as it freezes the details used.

The LegalNotice is a PrawnPdf document constructed in exactly the same way as
the main report. During development, a PrawnPdf error can hang a Rails server,
so a convenience method is provided: e.g. LegalNoticeCompiler.dev(7) generates
/app/models/legal_notice_compiler/ln7.pdf

LegalNotice aasm state is used to track the response (or lack of) from a
FinancialInstitution. Button toolbars are automatically generated from current
possible aasm Events.

LegalNotice state changes can be made via the /report/_n_/legal_notices screen
OR the FinancialInstitutions list.

If a FI asks for further action then the LegalNotice can be edited to include
a note, and a correspondence Document can be uploaded. After a match response
has been registered an email notification is sent to the customer. The
customer's Report view includes ENS notes and correspondence.

An ENS Audit Report pdf can be generated and viewed at any time to show the
current responses.

When all responses have been collected or 30 days have passed since starting
the process and Audit report can be generated. This report can be uploaded to
the Report Case to present to the lawyer inside the system.

## Development

Consider using Docker & Docker Compose. Instructions at `doc/DOCKER.md`

Otherwise, you'll want Postgres, and the following environment variables:

```
S3_BUCKET=risq-es-dev
S3_ACCESS_KEY_ID=
S3_SECRET_ACCESS_KEY=
```

optionally you can override
```
S3_REGION= (defaults to eu-west-2)
SUPPORT_EMAIL=
```

### ImageMagick 6

If you need to use ImageMagick 6:

```
gem 'rmagick', '2.15.4'
```

### Experian Integration

If you want to query Experian, you'll also need to place a `.pem` certificate
and matching private key under `secrets` with names matching
`experian_certificate.pem` and `experian_private_key.key`, then set environment
variables accordingly:

```
DELPHI_ENV=uat # or live
EXPERIAN_PRIVATE_KEY_PASSWORD=
```

### Bulk upload of Financial Institutions

FIs can be bulk uploaded via Master Financial Institution Contact List (Bereavement).csv
and Master Financial Institution Contact List (Mental Capacity).csv using
buttons of the /admin/financial_institutions/ screen.
A sample is provided at /db/Master Financial Institution Contact List (Bereavement) v.3.csv

Although you can edit an email address at any time, it would be easiest to configure
email addresses in the csv.

Google Mail allows for a '+' address on any account, e.g. my.address+any-words@gmail.com
would be sent to my.address@gmail.com
Note that the Risq Outlook Exchange server is configured to ban outbound mail
to GMail, so this won't work.

### Pairing with Microsoft 365 Outlook using Microsoft Graph

To use Exchange Server the system must be paired via Oauth and Azure.

See https://docs.microsoft.com/en-us/graph/auth/auth-concepts

* Go to https://portal.azure.com/
* 'Azure Active Directory'
* 'App Registrations'
* Add an app
* Usable by 'Accounts in the organizational directory only'
* Redirect Url to https://estatesearch.url.com/authorize
* Press 'Registration'
* 'Authentication'
* scroll down to 'Implicit grant' and set 'ID tokens' checkbox
* Live SDK support: YES (this appears to have been removed...and the question below)
* Default client type: NO (we will only use token-based permission)
* 'Grant Admin consent for RISQ'
* API permissions
** Mail.Send Application
** openid Delegated
** profile Delegated
** User.Read Delegated

* Certificates & Secrets
* + new client secret
* any name, expires never

This should result in environment variables:
```
AZURE_CLIENT_ID=
```
and
```
AZURE_CLIENT_SECRET=
```
To pair the system: a user who has Outlook permissions must visit the /authorize/
URL. They will have to provide an Outlook password or be logged in already.
This generates a token which is stored in a 'postmaster' Administrator record.

When sending an email via ms-graph the system retrieves the token stored in
the 'postmaster' Administrator record. If the token has timed-out it will
renew it (and update the postmaster).

### Pairing with SendGrid

To use SendGrid, create an account and allocate a token to the env variable:
```
SENDGRID_API_KEY=
```

### Testing

The usual: `rails test` and `rails test:system`.

Coverage is not 100%, but the suite must pass.

## Documentation

Generate an entity relationship diagram (ERD) with:
```
rails erd
```

Generate html documentation via /lib/tasks/doc.rake
```
rails rdoc
```

## Deployment

1. Tag your build: `git tag 1.2.3` and `git push --tags`
2. Build a Docker image with `docker build -t estatesearch:1.2.3 .`
3. Use the `es-infrastructure` repo to push the Docker image and deploy
