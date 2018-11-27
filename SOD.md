# Schema Overlays Draft (SOD)

DRAFT - Work in Progress

## Intro

This document aims to provide proposition of solution for global standardize way of data exchange.
The idea is to design minimalistic schema for data which could be used in very generic way and leverage concept of overlays to provide additional extensions and functionality.

The idea is that schema and overlays would be identify by DID and schema would be stored on the Distributed Ledger (DL) which would provide extra security and trust into the system.

## What for it could be useful?

* Verifiable Credentials (Presentation, Presentation Request, Canonicalization Function, Encoding, Schema)
* Data Vault - unify way to exchange, share and store data.
* Communication between agents
* Data normalization on global scale
*  (write your own) ...

## Requirements

The schema can:
* be signed by trusted party
* have multiple versions
* reference other schema
* be included in other schema
* use universal "standardize" atomic attributes
* ...

The schema must:
* have be identify by DID (or any unique identifier)
* have version
* have name
* be valid schema (defined by JSON Schema )
* must refer to consent receipt schema
* ...

The Overlay can:
* be attached to the schema
* be apply on top of specific (if it is referenced or any schema)
* be applied by issuer or receiver

The Overlay must:
* have be identify by DID (or any unique identifier)
* be valid schema (defined by JSON Schema)



## Reputation

We should think of how to be able to track popularity of the schema, overlays and schema elements to measure it's reputation. So community can build up overall "standards". Probably this would be tracked via resolution where network can measure the amount of hits to specific schema or overlay. Reputation should be build outside the schema and overlay. Probably as a external system. Reputation system would be very important in the process to establish overall data normalization and unify communication language.

TOOD: challenge - how to make sure that the reputation would be valid across different network?

## Predicate conditions

Allow to define overlay with simple logic to be able to apply specific predicate on any attributes.
For example:
* Are you above 18 years old? -> ( "birthdate" > 18y )
* Are you leaving in Poland? -> ( "address" include? 'Poland' )
* Are you citizen of Poland? -> ( "pesel" is present - PESEL is a national ID of each citizen )

This could be related with the work which is done in Verifiable Credential WG where ZKP allows you execute such operation.

## DID and DDOC

To uniquely identify schema or overlay we would like to try to leverage concept of DID according to the [latest spec](https://w3c-ccg.github.io/did-spec/)(v0.11). The idea is to use new context withing DID spec.

Same as DID's schemas and overlays should be independent from the network where it could be stored. By following same rules as DID spec.

We could leverage concept of context which is defined in the [spec](https://w3c-ccg.github.io/did-spec/#ex-13-an-example-json-ld-context)

The idea would be to use dedicated context for defining schema related objects to be able to extend the Decentralized Identifiers Data Model in a permissionless and decentralized way.

Example:

    did:sov:schema:12345xcvb # Specific Schema DID

Can resolves to:

    {
      @context: ["https://schema-and-overlays.io/schema/v1"]
      "id": did:sov:schema:12345xcvb
      "proof": {
        "type": "LinkedDataSignature2015",
        "created": "2016-02-08T16:02:20Z",
        "creator": "did:example:8uQhQMGzWxR8vw5P3UWH1ja#keys-1",
        "signatureValue": "QNB13Y7Q9...1tzjn4w=="
      }
      "authentication": [{
        "type": "RsaSignatureAuthentication2018",
        "publicKey": "did:example:123456789abcdefghi#keys-1"
      }
      name: "Full Name",
      description: "Person full name",
      version: "1.0",
      attr_names: {
        "first_name": did:schel:9667,
        "middle_name": did:schel:9668,
        "last_name": did:schel:9669,
      }
    }

NOTICE:
Since we are using DID spec anything related with [Authorization or Delegation](https://w3c-ccg.github.io/did-spec/#authorization-and-delegation) is build in out of box and is on the DID method side to specify how this is done.


Example:

    did:sov:overlay:1234qwer

Can resolves to:

TODO:


## Schema Element

Schema Element represent smallest unit in schema world which is single
attribute. Schema element's are included in schema. The idea behind schema elements is to avoid duplicates on data storage side (for example decentralize global storage or Sovrin agent) and provide universal language (semantic) for SSI ecosystem to talk between networks and data providers so we could keep compatibility between them.

Example of one element:

    {
      did: "did:schel:9667",
      name: "First name",
      description: "User first name",
      version: "1.0",
    }

    {
      did: "did:schel:9668",
      name: "Middle name",
      description: "User middle name",
      version: "1.0",
    }

    {
      did: "did:schel:9669",
      name: "Last name",
      description: "User last name",
      version: "1.0",
    }

## Schema

    {
      did: "did:schema: 66789",
      name: "Full Name",
      description: "Person full name",
      version: "1.0",
      attr_names: {
        "first_name": did:schel:9667,
        "middle_name": did:schel:9668,
        "last_name": did:schel:9669,
      }
    }

    {
      did: "did:sov:1234abcd",
      name: "Demographics",
      description: "Created by MEDIDATA",
      version: "1.0",
      consent: "did:schema:27312381238123", # reference to consent schema

      bit_attributes: {
        "brthd": "sensitive"
      }
      attr_names: {
        name: did:schema:666789,
        brthd: "Date",
        ...
      }


    }

```

CONSENT_SCHEMA = {
    did: "did:schema:27312381238123",
    name: 'Consent schema for clinical trial data',
    description: "Created by Rosche",
    version: '1.0',
    # MANDATORY KEYS
    attr_names: {
      expiration: Date,           # How long consent valid for.
      limitation: Date,           # How long data is kept.
      # Different reasons may apply. For example hold information after
      # expiration in case customer returns after some months.
      dictatedBy: String,          # Who dictates the conditions of consent,
      # Issuer / Holder. Issuer if requirement or Holder if temporary.
      # Applies to expiration & limitation
      validityTTL: Integer,       # Duration proof is valid for. Value in
    }
}

```



## Overlays

 - Entry Overlay
 - Label Overlay
 - Information Overlay
 - Subset Overlay
 - Sensitive Overlay
 - Encoding Overlay
 - Format Overlay (including units)
 - Conditional Overlay
 - Consent Overlay

### Entry overlay

Include default values for attributes.

For example:
```
ENTRY_OVERLAY = {
  did: "did:sov:1234abcd",
  type: "spec/overlay/1.0/entry",
  name: "Demographics Entry",
  schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  schemaName: "Demographics",
  default_values: {
    ageUnit: ["YEAR"],
	gender: ["MALE", "FEMALE"],
	ethnicGroup: ["HISPANIC OR LATINO", "NOT HISPANIC OR LATINO", "NOT REPORTED", "UNKNOWN"],
	race2Specific: ["CHINESE", "TAIWANESE", "ASIAN INDIAN", "KOREAN", "MALAYSIAN", "VIETNAMESE", "OTHER ASIAN"]
  }
}
```
### Label Overlay

Define and label categories and add attribute labels to Schema attributes (incl. language translations)

Example:

```
LABEL_OVERLAY = {
  did: "did:sov:59248239",
  type: "spec/overlay/1.0/label",
  name: "Demographics English Labels",
  schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  schemaName: "Demographics",
  language: "en_US",
  attr_labels: {
    brthd: 'Date of Birth',
    ageic: 'Age',
    ageUnit: 'Age unit',
    gender: 'Sex',
    ethnicGroup: 'Ethnicity',
    indalk: 'American Indian or Alaska Native',
    asian: 'Asian',
    race2Specific: 'If race is Asian, specify origin',
    black: 'Black or African American',
    island: 'Native Hawaiian or Other Pacific Islander',
    white: 'White',
    raceunk: 'Race Unknown'
  },
  attr_categories: {
    race: [
      :indalk, :asian, :racesp,
      :black, :island, :white, :raceunk],
  },
  category_labels: {race: "Race"}
}

```

### Information Overlay

Add a layer of contextual information to a Schema (incl. procedural and/or legal prose) to better define it's expected use and/or associated terms.

For example:

```
INFORMATION_OVERLAY = {
  did: "did:sov:58kosf0239",
  type: "spec/overlay/1.0/informational",
  name: "Demographics English Informational",
  schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  schemaName: "Demographics",
  language: "en_US",
  attr_informations: {
    brthd: 'Fill Your Date of Birth',
    ageic: 'Fill your Age',
    gender: 'Choose your Sex',
    ethnicGroup: 'Choose your Ethnicity',
    indalk: 'Select if your are American Indian or Alaska Native',
    race2Specific: 'If race is Asian, select origin',
    black: 'Select if you are Black or African American',
    island: 'Select if you are Native Hawaiian or Other Pacific Islander',
    white: 'Select if your are White',
  },
  category_information: {race: "Select all that apply"}
}

```

### Subset Overlay

Create a Schema subset.

For example:

```
SUBSET_OVERLAY = {
	did: "did:sov:1123414abcd",
  type: "spec/overlay/1.0/subset",
	name: "Demographics - Subset overlay",
	schemaDID: "did:sov:3214abcd",
	schemaVersion: "1.0",
  attributes: [
      :brthd,
      :ageic,
      :ageu,
      :gender
  ]
}
```

### Sensitive Overlay

Flag personally identifiable information (PII) attributes that could unblind the identity of a person, an organization or a thing with reference to the Blinding Identity Taxonomy (BIT). It is applied on the receiver of identity request side. It serves as a extra protection layer for end customer.

For example:

```
SENSITIVE_OVERLAY = {
  did: "did:sov:12idksjabcd",
  tyee: "spec/overlay/1.0/sensitive",
  name: "Sensitive data for private entity",
  attributes: [
      :ageic
  ]
}

```

### Encoding Overlay

Overlay which provides you information about encoding methods used to encrypt/obscure for ZKP operation. This is strongly related with the work of Verifiable Credential WG. More info soon.

For example:

```
ENCODING_OVERLAY = {
  did: "did:sov:12ide212jabcd",
  tyee: "spec/overlay/1.0/encoding",
  name: "Encoding information for data attributes",
  attributes_encoding: [
      date: "LinkedDataSignature2015"
  ]
}
```
Encoding method could be defined using security vocabulary: https://web-payments.org/vocabs/security

### Format Overlay

Overlay which carry information about data formats of the attributes like: Text, Number etc. and the units like: m, km, pounds, EUR etc.

For example:

```
FORMAT_OVERLAY = {
  did: "did:sov:12iasc212jab5",
  tyee: "spec/overlay/1.0/format",
  name: "Format information for data attributes",
  attributes_encoding: {
      date:  {:format => "ISO8601", unit: "seconds"}
      name: {format: "String"}
      weight: {format: "Decimal", unit: "kilogram"}
  }
}
```

### Conditional Overlay

Overlay which provides simple logic for presenting the data, like hide fields if are depending on another, required fields and correlation between them.

For example:

```
CONDITIONAL_OVERLAY = {
  did: "did:sov:1234abcd73",
  type: "spec/overlay/1.0/conditional",
  name: "Demographics Entry",
  schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  schemaName: "Demographics",
  conditional: {
    # conditional logic can be applied for attributes supported syntax:
    # :attribute_name
    # OR
    # AND
    # false
    # true
    # ==
    # !=
    # >
    # <
    # <=
    # >=
    hidden_attributes: {race2Specific: ":asian == false" },
    required_attributes: { brthd: true, gender: true, ageUnit: ":ageic != nil"}
  }
}

```

### Consent Overlay

Overlay which provides consent information for given agreement. This bit is related with work done in the Consent Receipt WG within Kantara Initiative.

For example:
```
# CONSENT OVERLAY [APPLIES IF ISSUER SETS CONDITIONS OF CONSENT]
# This applies when issuer sets explicit limits of usage. Consent is not optional.

CONSENT_RECIEPT_OVERLAY = {
  did: "did:sov:5678abcd",
  type: "spec/overlay/1.0/consent_entry",
  name: "Consent receipt entry overlay for clinical trial",
  default_values: {
      expiration: "3 years",
      limitation: "2 years",
      dictatedBy: "did:sov:73jdu29d2", # DID of the issuer's/receiver
      validityTTL: "1 month"
      }
}

```

## TODO
* Overlay for Canonicalization Function - contains ordered graph-paths?
* Conversions?
* Transformation?
* inference - I am older then 18years old - can be done base on different verifiable credentials for example: passport, driving license (different types), national ID, or some bank accounts. All those should be valid in the context of overlay on top of the schema with specific predicates.
* ...

# Questions:
* How to deal with attributes units within overlays and schema?

  Probably it will be a good idea to keep the units out of schema to make generic schema for each use cases and let people decided in which units they want to get the data. For that purpose there will be needed unit overlay.

* Should overlay be independent?

 This would allow to reuse overlays and easily apply different overlays across schema. Good example could be BIT overlay or UNIT overlay. Others seems to be strongly tied to schema.

* How we should do categorization of schema?

  Categorization could be helpful in case if user don't know the name of the schema but want to see all schemas available from specific DID which are related with documents. For example schema to issue an invoice for that specific DID.

* How schema could be tied to specific DID?

  DID - identity could point out that he is using those specific schema for different purpose. So if someone want to communicate with him for example ask for data for issuing him an invoice he could always get the right schema. It could be done via DDOC itself or services within DDOC.


# TODO

Since we are operating on DID we can use DDOC to store meta information about object within DDOC. The important part is that DDOC can changed so we need to keep that in mind and somehow record specific version of the DDOC to make sure that it won't changed in the future. Since in most network implementation DDOC is stored on the DL this won't be a problem but we need to keep that in mind.
