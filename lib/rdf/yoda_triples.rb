require 'rdf'

module RDF::YodaTriples
  class Writer < RDF::NTriples::Writer
    def format_triple(subject, predicate, object, options = {})
      "%s %s %s ." % [subject, object, predicate].map { |value| format_term(value, options) }
    end
  end

  class Format < RDF::Format
    content_type     'application/yoda-triples', :extension => :yodat, :alias => ['text/plain']
    content_encoding 'utf-8'

    reader { RDF::YodaTriples::Reader }
    writer { RDF::YodaTriples::Writer }

    def self.detect(sample)
      !!sample.match(%r(
        (?:(?:<[^>]*>) | (?:_:\w+))                             # Subject
        \s*
        (?:(?:<[^>]*>) | (?:_:\w+) | (?:"[^"\n]*"(?:^^|@\S+)?)) # Object
        \s*
        (?:<[^>]*>)                                             # Predicate
        \s*\.
      )x) && !(
        sample.match(%r(@(base|prefix|keywords)|\{)) ||         # Not Turtle/N3/TriG
        sample.match(%r(<(html|rdf))i)                          # Not HTML or XML
      ) && !RDF::NQuads::Format.detect(sample)
    end

    # Human readable name for this format
    def self.name; "N-Triples"; end
  end
end