---
title: Automated Discovery Of Self-Published Reports (reports.json)
abbrev: reports.json
docname: draft-dkg-reports-json-00
category: info
v: 3
ipr: trust200902
area: int
workgroup: intarea
keyword: Internet-Draft
submissionType: IETF
stand_alone: yes
pi: [toc, sortrefs, symrefs]
author:
 -
    ins: D. K. Gillmor
    name: Daniel Kahn Gillmor
    org: American Civil Liberties Union
    abbrev: ACLU
    email: dkg@fifthhorseman.net
 -
    name: Marissa Kumar Gerchick
    org: American Civil Liberties Union
    abbrev: ACLU
    email: mgerchick@aclu.org
venue:
  repo: "https://github.com/dkg/reports.json/"
  latest: "https://dkg.github.io/reports.json/"
informative:
  NYC-LL144:
    target: https://codelibrary.amlegal.com/codes/newyorkcity/latest/NYCrules/0-0-0-138391
    title: "Rules of the City of New York: Automated Employment Decision Tools"
    date: April 2023
  CO-SB26189:
    target: https://leg.colorado.gov/bills/sb26-189
    title: "Colorado Senate Bill 26-189"
    date: May 2026
  CCPA:
    target: https://cppa.ca.gov/regulations/pdf/ccpa_statute_eff_20260101.pdf
    title: "California Consumer Privacy Act Regulations"
    date: January 2026
  JV:
    target: https://github.com/santhosh-tekuri/jsonschema
    title: JSONSchema Validation using Go
    author:
      name: Santhosh Kumar Tekuri

--- abstract

This document describes a mechanism that
an organization can use to enable automatic discovery
of documents associated with regulatory compliance.
It is motivated by regulations that require, for example,
publicly accessible reports of audits of automated decision-making processes in hiring,
or reports on sustainable business practices.

--- middle

# Introduction

An increasing number of regulatory regimes require
organizations involved in certain business practices
to provide a degree of transparency
in their business operations
by posting reports in an accessible location.
For example, New York City's 2021 Local Law 144 ({{NYC-LL144}})
established auditing requirements
for employers who use automated decision-making tools
in the employment process,
but it has proved challenging
to even find these audit reports effectively
(see {{?Auditing-the-Audits=DOI.10.1145/3715275.3732004}}).

For a business that has a website,
the natural place to provide access
to the audit report is on that website.
This document describes a standard mechanism
that can be used to point to any report posted
associated with regulatory compliance.

The mechanism is a `reports.json` summary document,
found at a well-known URL,
which allows the hosting domain
to refer to specific business operations,
relevant regulatory regimes, and
their associated reports.

Adoption of this mechanism should make it easier
for businesses to comply with these requirements,
while also making it easier for
researchers, analysts, and regulators
to assess compliance and
evaluate the overall effectiveness of the regulations.

## Requirements Language

{::boilerplate bcp14-tagged}

## Terminology

- A "report" is a document
  produced by an organization or
  an independent entity commissioned by the organization
  to describe
  -- according to some kind of regulatory compliance --
  a part of the organization's business operations.

## Goals

- Provide a standardized way for
  an organization to publicize reports
  associated with given regulatory requirements.

- Provide a standardized way for
  a reviewer of reports
  associated with a regulatory requirement
  to find those reports.

## Non-Goals

Discovering a report is
merely the first step in
a process of having an effective
regulatory regime based on these self-hosted reports.
This specification is focused on
satisfying this necessary but
insufficient stage of larger work.

- This specification makes no attempt
  to describe the syntax or semantics
  of any particular report.
  The underlying assumption is
  that the reports for different regulations or compliance measures
  will have different requirements
  for content, structure, syntax, and so on.

- This specification also does not associate
  a real-world organization with a particular domain name.
  If a researcher wants to find the reports
  associated with Example Corp,
  they need to associate Example Corp with the `example.com` domain name
  independently in order to use this specification.
  Likewise, any regulation making use of this mechanism
  needs to explicitly describe the link between
  the regulated entity and the domain name or domain names
  on which it is expected to publish this summary.
  
- This specification does not describe
  a way for a casual visitor
  to a given website to find these reports.
  A regulation that requires
  easy public accessibility of a report
  may need to offer additional
  user interface or user experience guidance
  in addition to requiring the use of this mechanism.

# Locating The reports.json Summary {#location}

This specification uses
the `.well-known` URL space defined by {{!RFC8615}}.

A given domain hosts the `reports.json` summary
in `/.well-known/reports.json`
within the website operated by the organization.

If Example Corporation operates `https://example.com/`,
then the summary report would be found at
`https://example.com/.well-known/reports.json`.

# `reports.json` Structure

The object served from the URL described in {{location}}
will have `Content-Type: application/json`,
and will consist of a single dictionary object
with at least two top-level keys: `operations` and `reports`.

The overall object relationship looks like this:

{: title="Data Structure For `reports.json`"}
~~~ aasvg
{::include reports.json.ascii-art}
~~~

## `reports` Content

The `reports` member is an object where each named member is
an object with the following members:

- `title`, simple textual string describing the report, and
- `date`, date object describing the calendar date
  (year, month, and day) of the report's publication, and
- `urls`, an array of URLs that point to
  the relevant materials for the report

## operations Content

The `operations` member is a list of objects,
each of which describes some set of business operations,
via the following members:

- `urls`, an array of URLs,
  each of which describes a business operation
  covered by this object (for example, a job listing),
- `regs`, an array of "Regulation" objects, described in {{regulation}}.
- `reports`, an array of keys which can be used to point to
  specific reports by name

### Regulation objects {#regulation}

A Regulations object is one element in an array within an `operations` object
that indicates the range of regulations that are
relevant for the regulation and the operation.

The only required member for this object is:

- `uri`, a URI which refers to a specific piece of regulatory guidance
  (i.e., a unique identifier that is associated with the requirements that
  the operation needs to comply with).

The other defined (but not required) members are:

- `not_before`, a time marker indicating the calendar date (year, month, and day)
  when the regulation first became relevant for the operation.
- `not_after`, a time marker indicating the calendar date (year, month, and day)
  at which point the regulation is no longer relevant for the operation.

When both are present, `not_after` MUST be later than `not_before`,
but both values MAY be in the future or the past,
as a way to indicate prospective or retrospective compliance.

# IANA Considerations

IANA should register `reports.json`
in the "Well-Known URIs" registry,
with the following values:

- URI suffix: `reports.json`

- Change controller: IETF
  (is this the right choice,
  if this is an informational draft?
  is there a better group to control
  updates to this specification?)

- Specification document(s): This document

- Status: provisional (unless we see wider adoption,
  in which case we should ask for permanent)

- Related information: Any other examples we want to point to?

--- back

# Test Vectors

## Example `reports.json`

{: sourcecode-name="reports.json"}
~~~ json
{::include reports.json}
~~~

# JSON Schema For `reports.json`

The following JSON Schema
(see {{?I-D.ietf-jsonschema-json-schema}})
can be used to validate an `reports.json` summary file.

{: sourcecode-name="reports-schema.json"}
~~~ json
{::include reports-schema.json}
~~~

For example, you can validate this using with {{JV}}:

~~~
jv reports-schema.json reports.json
~~~

Note that JSON Schema
cannot represent foreign key constraints,
so the fact that each `/operations/*/reports`
must reference a named member of `/reports`
needs to be enforced separately.

# Examples of Regulatory Regimes

Please propose more pointers for this subsection!

- {{NYC-LL144}} established requirements for
  employers in New York City
  to publish reports of audits about
  automated decision-making tools used for hiring.
- Colorado's SB 289 {{CO-SB26189}} requires
  deployers of automated decision-making systems
  to provide consumers with pre-use notices
  about the design and deployment of such systems
  on their websites.
- The California Consumer Privacy Act {{CCPA}}
  requires businesses
  to create "Risk Assessment Reports"
  about their use of
  Automated Decision-Making Technology (ADMT)
  as well as pre-use notices about ADMT use
  and regular cybersecurity audits.

## Example Regulatory Text

A regulation or law
that relies on this mechanism
to point toward relevant reports
can cite it using text similar to the following:

> Any Covered Organization that has
> a public website shall
> publicly point to the Required Reports
> associated with each Covered Operation using
> a widely understood mechanism such as
> the `reports.json` specification.
> The Required Reports associated with this act
> shall refer to the act as
> `https://springfield.example/citycouncil/acts/2025/114`

(note that this text presumes that the regulation
has defined the terms
"Covered Organization",
"Covered Operation", and
"Required Reports")

# Third-party Hosting

Some entities subject to regulatory obligations
might find it challenging to host a reliably up-to-date `reports.json`
on their website.

Such an entity may want to contract with
a regulatory compliance consultancy
in order to keep this record up-to-date without
providing the consultancy write privileges for the entity's entire website,
or even for material in the website's `.well-known/` directory.

Such a consultancy might themselves have multiple clients.
The consultancy could host a repository of their clients' `reports.json` files,
for example in locations like:

    https://consultancy.example/clients/example.com/reports.json
    https://consultancy.example/clients/entity1.example/reports.json

And then ask each client to set up
a one-time HTTP 302 redirect from the appropriate location on their site, like so:

   https://example.com/.well-known/reports.json redirects to
   https://consultancy.example/clients/example.com/reports.json

and

   https://entity1.example/.well-known/reports.json redirects to
   https://consultancy.example/clients/entity1.example/reports.json

This standard should continue to meet its
goals of responsiveness and discoverability
under such a third-party-hosted arrangement.

{:numbered="false"}
# Acknowledgements

{:numbered="false" removeInRFC="true"}
# Document History

{:numbered="false" removeInRFC="true"}
## Changes between audits.json-01 and reports.json-00

- rename from `audits.json` to `reports.json`
- add date ranges for `operations`
- describe third-party hosting

{:numbered="false" removeInRFC="true"}
## Changes between audits.json-00 and audits.json-01

- added references to CCPA
- align schema test for jv CLI API 0.7
