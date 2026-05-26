(comment) @comments

(punctuation) @attributes

(
  (assignment_lhs) @variables
  .
  (
    (punctuation) @keywords
    (#match? @keywords "^=$")
  )
)

(named_context
  (symbol)
  .
  (
    (punctuation) @keywords
    (#match? @keywords "^=$")
  )
  .
  [(symbol) (string)]
)

(chord
  .
  "<" @keywords
  ">" @keywords
  .
)

(
  (escaped_word) @types
  (#not-match? @types "^\\\\(?:include|maininput|version)$") ; This is needed for Panic Nova
)
(
  (escaped_word) @commands
  (#match? @commands "^\\\\(?:include|maininput|version)$") ; These are handled directly by LilyPond’s lexer.
)
(
  (escaped_word) @values
  (#match? @values "^\\\\(?:breve|longa|maxima)$")
)
(
  (escaped_word) @characters
  (#match? @characters "^\\\\\\^$")
)

(quoted_identifier
  "\"" @keywords
)

(
  (symbol) @keywords
  (#match? @keywords "^q$")
)

[
  (fraction)
  (decimal_number)
  (unsigned_integer)
] @numbers

(dynamic) @characters

(instrument_string_number) @characters

(
  (string
    "\"" @strings
    [
      (string_fragment)?
      (escape_sequence)? @characters
    ]
    "\"" @strings
  )
) @strings

[
  "{" "}"
  "<<" (parallel_music_separator) ">>"
  "#{" "#}"
] @keywords

(chord
  ">>" @comments
)

(embedded_scheme_prefix) @commands
