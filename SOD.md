# Schema Overlays Draft (SOD)

DRAFT - Work in Progress

## Intro

This document aims to provide proposition of solution for global standardize way of data exchange.
The idea is to design minimalistic schema for data which could be used in very generic way and leverage concept of overlays to provide additional extensions and functionality.

The idea is that schema and overlays would be identify by DID and schema would be stored on the Distributed Ledger (DL) which would provide extra security and trust into the system.

## Requirements

The schema can:
* be signed by trusted party
* be identify by DID
* have multiple versions
* reference other schema
* be included in other schema
* use universal "standardize" atomic attributes
* ...

The schema must:
* have unique DID
* have version
* have name
* be valid schema (defined by JSON Schema )
* ...

The Overlay can:
* be attached to the schema (TODO: not sure if this would be optional)
* ...


## Reputation

We should think of how to be able to track popularity of the schema, overlays and schema elements to measure it's reputation. So community can build up overall "standards". Probably this would be tracked via resolution where network can measure the amount of hits to specific schema or overlay. Reputation should be build outside the schema and overlay. Probably as a external system.

TOOD: challenge - how to make sure that the reputation would be valid across different network?

## Predicate conditions

Allow to define overlay with simple logic to be able to apply specific predicate on any attributes.
For example:
* Are you above 18 years old? -> ( "birthdate" > 18y )
* Are you leaving in Poland? -> ( "address" include? 'Poland' )
* Are you citizen of Poland? -> ( "pesel" is present - PESEL is a national ID of each citizen )

## DID and DDOC

To uniquely identify schema or overlay we would leverage concept of DID according to the [latest spec](https://w3c-ccg.github.io/did-spec/)(v0.11). The idea is to use context withing DID spec.

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
attribute. Schema element's are included in schema. The idea is behind schema elements is to avoid duplicates on data storage side (decentralize global storage or sovrin agent) and provide universal language (semantic) for SSI ecosystem to talk between networks and data providers so we could keep compatibility between them.

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

      bit_attributes: {
        "brthd": "sensitive"
      }
      attr_names: {
        name: did:schema:666789,
        brthd: "Date",
        ...
      }


    }


## Overlays

### Entry overlay

Include encoding
Include attribute units
Include data format


### Label Overlay

Define and label categories and add attribute labels to Schema attributes (incl. language translations)

### Information Overlay

Add a layer of contextual information to a Schema (incl. procedural and/or legal prose) to better define it's expected use and/or associated terms.

### Subset Overlay

Create a Schema subset.

### BIT Overlay

Flag personally identifiable information (PII) attributes that could unblind the identity of a person, an organization or a thing with reference to the Blinding Identity Taxonomy (BIT)

## TODO
* Conversions?
* Transformation?
* inference - I am older then 18years old - can be done base on different verifiable credentials for example: passport, driving license (different types), national ID, or some bank accounts. All those should be valid in the context of overlay on top of the schema with specific predicates.
* encoding - format vs units ... where and how to split it?
* ...

# Questions:
* How to deal with attributes units within overlays and schemas?

  Probably it will be a good idea to keep the units out of schema to make generic schemas for each use cases and let people decided in which units they want to get the data. For that purpose there will be needed unit overlay.

* Should overlay be independent?

 This would allow to reuse overlays and easily apply different overlays accross schemas. Good example could be BIT overlay or UNIT overaly. Others seems to be strongly tied to schema.

* How we should do categorisation of schemas?

  Categorisation could be helpful in case if user don't know the name of the schema but want to see all schemas available from specific DID which are related with documents. For example schema to issue an invoice for that specific DID.

* How schema could be tied to specific DID?

  DID - identity could point out that he is using those specific schemas for different purpose. So if someone want to communicate with him for example ask for data for issueing him an invoice he could always get the right schema. Could be that done via DDOC and services?


# TODO

Since we are operating on DID we can use DDOC to store meta information about object within DDOC. The important part is that DDOC can changed so we need to keep that in mind.
