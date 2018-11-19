require 'json'
require 'date'
require 'awesome_print'

# Attributes flagged according to the Blinding Identity Taxonomy
# Can be created by community, individuals or trusted entities
# User can use multiple BIT Overlays and combine them to avoid duplicates
SENSITIVE_OVERLAY = {
	did: "did:sov:12idksjabcd",
  tyee: "spec/overlay/1.0/bit",
  name: "Sensitive data for private entity",
  attributes: [
      :ageic
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

# Limit the schema to subset of attributes
# Can be created by anyone and do not required to be verify or sign by any trusted entity
# as it is applied only on top of verified schemas.
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

# Hints for the attributes and description of the attributes to help user to understand the form
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
INFORMATION_OVERLAY_PL = {
  did: "did:sov:58kosf0239",
  type: "spec/overlay/1.0/informational",
  name: "Demographics - Polish Informational",
	schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  language: "en_US",
  attr_informations: {
    brthd: 'Twoja data urodzenia',
    ageic: 'Wprowadź wiek',
    gender: 'Wybierz płeć',
    ethnicGroup: 'Wybierz grupe etniczną',
    indalk: 'Rodowity Amerykanin albo mieszkanie Alaski',
    race2Specific: 'Jeżeli jesteś Azjatą wybierz pochodzenie',
    black: 'Wybierz jeżeli jesteś czarnoskóry',
    island: 'Wybierz jeżeli jesteś Hawajczykiem albo polinezejczykiem',
    white: 'Wybierz jeżeli jesteś biały',
  },
  category_information: {race: "Wybierz wszystkie które Cię dotyczą"}
}

# Purpose: Make attributes human readable in specific language
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

LABEL_OVERLAY_PL = {
  did: "did:sov:59sdds248239",
  type: "spec/overlay/1.0/label",
  name: "Demografia - Polish Labels",
	schemaDID: "did:sov:3214abcd",
  schemaVersion: "1.0",
  language: "pl_PL",
  attr_labels: {
    brthd: 'Rok urodzenia',
    ageic: 'Wiek',
    ageu: 'Jednotka wieku',
    gender: 'Płeć',
    ethnicGroup: 'Grupa etniczna',
    indalk: 'rodowity Amerykanin lub Alaski',
    asian: 'Azjata',
    race2Specific: 'Jeśli If race is Asian, specify origin',
    black: 'Czarnoskóry',
    island: 'Hawajczyk lub polinezyjczyk',
    white: 'Biały',
    raceunk: 'Rasa nieznana'
  },
  attr_categories: {
    race: [
      :indalk, :asian, :racesp,
      :black, :island, :white, :raceunk],
  },
  category_labels: {race: "Rasa"}
}


# Each schema can be verified (Verifiable claims) on SSI which gives user protection against bad actor and compatibility with BIT OVERLAYS
SCHEMA = {
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
      raceunk: TrueClass
    },
    # Attributes flagged according to the Blinding Identity Taxonomy
    # by the issuer of the schema
    bit_attributes: [:brthd],
	  did: "did:sov:3214abcd",
    name: 'Demographics',
    description: "Created by MEDIDATA",
    version: '1.0',
    # OPTIONAL KEYS
    frmsrc: "DEM"
}


def show_overlay(overlay)
 ap JSON.parse(overlay.to_json)
end

def show_schema(schema)
  ap JSON.parse(schema.to_json)
end
def overlays
  ap " ENTRY_OVERLAY LABEL_OVERLAY INFORMATION_OVERLAY SUBSET_OVERLAY SENSITIVE_OVERLAY"
end

class Schema

  attr_accessor :schema, :entry_overlay, :label_overlay, :information_overlay, :subset_overlay

  def initialize(schema)
    @schema = schema
  end

  def is_bit?(attr)
    if @schema[:bit_attributes].include?(attr)
      return true
    else
      if @bit_overlay
        return @bit_overlay[:attributes].include?(attr)
      else
        return false
      end
    end
  end

  # TODO dynamically created methods for each key within the schema
  def attributes
    attrs = []
    if @entry_overlay
      attrs << @schema[:attr_names].keys - @entry_overlay[:conditional][:hidden_attributes].keys
    else
      attrs << @schema[:attr_names].keys
    end

    if @subset_overlay
      attrs = @subset_overlay[:attributes]
    end
    return attrs.flatten
  end

  def bit_attributes
    attributes.each do |attr|
      if is_bit?(attr)
        puts attr.to_s.red
      else
        puts attr
      end
    end; nil
  end

  def overlays
    overlays = []
    overlays << @entry_overlay[:name] if @entry_overlay
    overlays << @subset_overlay[:name] if @subset_overlay
    overlays << @label_overlay[:name] if @label_overlay
    overlays << @information_overlay[:name] if @information_overlay
    overlays << @bit_overlay[:name] if @bit_overlay
    ap overlays
  end

  def required_attributes
    if @entry_overlay
      r = []
      @entry_overlay[:conditional][:required_attributes].each { |k,v|
        if eval(v.to_s)
          r << k
        end
      }
      return r & attributes
    else
      []
    end
  end

  def remove_overlays
    @entry_overlay = nil
    @label_overlay = nil
    @information_overlay = nil
    @subset_overlay = nil
  end

  def apply_label_overlay(label_overlay)
    @label_overlay = label_overlay
  end

  def apply_sensitive_overlay(bit_overlay)
    @bit_overlay = bit_overlay
  end

  def apply_information_overlay(information_overlay)
    @information_overlay = information_overlay
  end

  def apply_subset_overlay(subset_overlay)
    @subset_overlay = subset_overlay
  end

  def apply_entry_overlay(entry_overlay)
    @entry_overlay = entry_overlay
  end

  def version
    @schema[:version]
  end

  def did
    @schema[:did]
  end

  def name
    @schema[:name]
  end

  def descritpion
    @schema[:description]
  end

  def default_values
    dv = {}
    attributes.each do |attr|
      if @entry_overlay and @entry_overlay[:default_values][attr] != nil
        dv[attr] = @entry_overlay[:default_values][attr]
      end
    end
    ap dv; nil
  end

  def attr_label(attr)
    @label_overlay[:attr_labels][attr]
  end

  def attribute_labels
    labels = {}
    attributes.each do |attr|
      if @label_overlay
        labels[attr] = @label_overlay[:attr_labels][attr]
      else
        labels[attr] = ""
      end
    end
    ap JSON.parse(labels.to_json);nil
  end

  def category_label(cat)
    @label_overlay[:category_labels][cat]
  end

  def attr_for_category(cat)
    @label_overlay[:attr_categories][cat]
  end

  def attr_information(attr)
    @information_overlay[:attr_informations][attr]
  end

  def attribute_informations
    labels = {}
    attributes.each do |attr|
      if @information_overlay
        labels[attr] = @information_overlay[:attr_informations][attr]
      else
        labels[attr] = ""
      end
    end
    ap JSON.parse(labels.to_json);nil
  end

  def category_information(cat)
    @information_overlay[:category_information][cat]
  end

  def subset_attrs
    attributes.select { |i|
      @subset_overlay[:attributes].include?(i)
    }
  end

end


# NOTICE: Below example how to use it
# schema = Schema.new(SCHEMA)
#puts schema.default_values
#puts schema.attr_label(:brthd)
#puts schema.category_label(:race)
#puts schema.attr_information(:brthd)
#puts schema.category_information(:race)
#puts schema.subset_attrs

#puts schema.attr_for_category(:race).map { |i| schema.attr_label(i) }

##
#puts SCHEMA
#puts ENTRY_OVERLAY
#puts LABEL_OVERLAY
#puts INFORMATION_OVERLAY
#puts SUBSET_OVERLAY
#puts SENSITIVE_OVERLAY
