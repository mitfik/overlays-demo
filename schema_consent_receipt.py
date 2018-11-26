# Each schema can be verified (Verifiable claims) on SSI which gives user protection against bad actor and compatibility with BIT OVERLAYS
# Date: 2018-11-26

# 1. DEFINITION OF SCHEMA

SCHEMA = {
    did: "did:sov:3214abcd",
    name: 'Demographics',
    description: "Created by Meflix",
    version: '1.0',
    # MANDATORY KEYS
    attr_names: {
      brthd: Date,
      ageic: Integer,
      ageUnit: String,
      gender: String,
      ethnicGroup: String,
      indalk: TrueClass,
      asian: TrueClass,
      race2Specific: String,
      black: TrueClass,
      island: TrueClass,
      white: TrueClass,
      raceunk: TrueClass,
    },
    consent: "did:schema:27312381238123", # reference to consent schema
    # Attributes flagged according to the Blinding Identity Taxonomy
    # by the issuer of the schema
    bit_attributes: ["brthd"],
    # OPTIONAL KEYS
    frmsrc: "DEM"
}

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

# CONSENT OVERLAY [APPLIES IF ISSUER SETS CONDITIONS OF CONSENT]
# This applies when issuer sets explicit limits of usage. Consent is not optional.

CONSENT_RECEIPT_OVERLAY = {
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

# Attributes flagged according to the Blinding Identity Taxonomy
# Can be created by community, individuals or trusted entities
# User can use multiple BIT Overlays and combine them to avoid duplicates
SENSITIVE_OVERLAY = {
  did: "did:sov:12idksjabcd",
  type: "spec/overlay/1.0/bit",
  name: "Sensitive data for private entity",
  attributes: [
      "ageic"
  ]
}

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
  },
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
