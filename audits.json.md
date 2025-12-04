---
title: Automated Discovery Of Audit Reports (audits.json)
abbrev: audits.json
docname: draft-dkg-audits-json-00
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
  repo: "https://github.com/dkg/audits.json/"
  latest: "https://dkg.github.io/audits.json/"
informative:
  NYC-LL144:
    target: https://codelibrary.amlegal.com/codes/newyorkcity/latest/NYCrules/0-0-0-138391
    title: "Rules of the City of New York: Automated Employment Decision Tools"
    date: April 2023
  CO-SB205:
    target: https://leg.colorado.gov/sites/default/files/2024a_205_signed.pdf
    title: "Colorado Senate Bill 24-205"
    date: May 2024
  JV:
    target: https://github.com/santhosh-tekuri/jsonschema
    title: JSONSchema Validation using Go
    author:
      name: Santhosh Kumar Tekuri

--- abstract

This document describes a mechanism that an organization can use to enable automatic discovery of documents associated with regulatory compliance.
It is motivated by regulations that require, for example, publicly accessible audits of automated decision-making processes in hiring.

--- middle

# Introduction

An increasing number of regulatory regimes require organizations involved in certain business practices to provide a degree of transparency in their business operations by posting reports of audits in an accessible location.
For example, New York City's 2021 Local Law 144 ({{NYC-LL144}}) established auditing requirements for employers who use automated decision-making tools in the employment process, but it has proved challenging to even find these audits effectively (see {{?Auditing-the-Audits=DOI.10.1145/3715275.3732004}}).

For a business that has a website, the natural place to provide access to the audit is on that website.
This document describes a standard mechanism that can be used to point to any audit posted associated with regulatory compliance.

The mechanism is an `audits.json` summary document, found at a well-known URL, which allows the hosting domain to refer to specific business operations, relevant regulatory regimes, and their associated audit reports.

Adoption of this mechanism should make it easier for businesses to comply with these requirements, while also making it easier for researchers, analysts, and regulators to assess compliance and evaluate the overall effectiveness of the regulations.

## Requirements Language

{::boilerplate bcp14-tagged}

## Terminology

- An "audit report" is a document produced by an organization or an independent entity commissioned by the organization to describe -- according to some kind of regulatory compliance -- a part of the organization's business operations.

## Goals

- Provide a standardized way for an organization to publicize audit reports associated with given regulatory requirements.

- Provide a standardized way for a reviewer of audit reports associated with a regulatory requirement to find those audit reports.

## Non-Goals

Discovering an audit report is merely the first step in a process of having an effective regulatory regime based on audits.
This specification is focused merely on this satisfying this necessary but insufficient stage of larger work.

- This specification makes no attempt to describe the syntax or semantics of any particular audit report.
  The underlying assumption is that the audit reports for different regulations or compliance measures will have different requirements for content, structure, syntax, and so on.

- This specification also does not associate a real-world organization with a particular domain name.
  If a researcher wants to find the audits associated with Example Corp, they need to associate Example Corp with the `example.com` domain name independently in order to use this specification.
  Likewise, any regulation making use of this mechanism needs to explicitly describe the link between the regulated entity and the domain name or domain names on which it is expected to publish this summary.
  
- This specification does not describe a way for a casual visitor to a given website to find these audit reports.
  A regulation that requires easy public accessibility of a report may need to offer additional user interface or user experience guidance in addition to requiring the use of this mechanism.

# Locating The audits.json Summary {#location}

This specification uses the `.well-known` URL space defined by {{!RFC8615}}.

A given domain hosts the `audits.json` summary in `/.well-known/audits.json` within the website operated by the organization.

If Example Corporation operats `https://example.com/`, then the summary report would be found at `https://example.com/.well-known/audits.json`.

# audits.json Structure

The object served from the URL described in {{location}} will have `Content-Type: application/json`, and will consist of a single dictionary object with at least two top-level keys: `operations` and `audits`.

The overall object relationship looks like this:

{: title="Data Structure For `audits.json`"}
~~~ aasvg
{::include audits.json.ascii-art}
~~~

## audits Content

The `audits` member is an object where each member is an object with:

- `title`, simple textual string describing the audit, and
- `date`, date object describing the calendar date (year, month, and day) of the audit's publication, and
- `urls`, an array of URLs that point to the relevant materials for the audit

## operations Content

The `operations` member is a list of objects, each of which describes some set of business operations, via the following members:

- `urls`, an array of URLs, each of which describes a business operation covered by this object (for example, a job listing),
- `regs`, an array of URLs, each of which refers to a piece of regulatory guidance, and
- `audits`, an array of keys which can be used to point to specific audits

# IANA Considerations

IANA should register `audits.json` in the "Well-Known URIs" registry, with the following values:

- URI suffix: `audits.json`

- Change controller: IETF (is this the right choice, if this is an informational draft?  is there a better group to control updates to this specification?)

- Specification document(s): This document

- Status: provisional (unless we see wider adoption, in which case we should ask for permanent)

- Related information: Any other examples we want to point to?

--- back

# Test Vectors

## Example audits.json

{: sourcecode-name="audits.json"}
~~~ json
{::include audits.json}
~~~

# JSON Schema For audits.json

The following JSON Schema (see {{?I-D.bhutton-json-schema-01}}) can be used to validate an `audits.json` summary file.

{: sourcecode-name="audits-schema.json"}
~~~ json
{::include audits-schema.json}
~~~

For example, you can validate this using with {{JV}}:

```
jv audits-schema.json audits.json
```

Note that JSON Schema cannot represent foreign key constraints, so the fact that each `/operations/*/audits` must reference a named member of `/audits` needs to be enforced separately.

# Examples of Regulatory Regimes

Please propose more pointers for this subsection!

- {{NYC-LL144}} established requirements for employers in New York City to publish audits of automated decision-making tools used for hiring
- Colorado's SB 205 {{CO-SB205}} requires developers of some artificial intelligence systems to publish reports about the design and deployment of such systems on their websites

## Example Regulatory Text

A regulation or law that relies on this mechanism to point toward relevant audits can cite it using text similar to the following:

> Any Covered Organization that has a public-facing website should
> publicly reference the Required Audits using
> a widely understood mechanism such as `audits.json`.
> The Required Audits associated with this act should refer to
> the act as `https://springfield.example/citycouncil/acts/2025/114`

{:numbered="false"}
# Acknowledgements

{:numbered="false" removeInRFC="true"}
# Document History

