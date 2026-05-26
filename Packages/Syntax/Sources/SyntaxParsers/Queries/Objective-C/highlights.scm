;
;  highlights.scm
;  for Objective-C
;
;  CotEditor
;  https://coteditor.com
;
;  © 2026 shuang886
;

; ============================
; MARK: Start of directives inherited from C

; set defaults at first
(identifier) @variables
(field_identifier) @attributes


; MARK: Keywords
; ----------------------------

[
  "break"
  "case"
  "const"
  "continue"
  "default"
  "do"
  "else"
  "enum"
  "extern"
  "for"
  "if"
  "inline"
  "return"
  "sizeof"
  "static"
  "struct"
  "switch"
  "typedef"
  "union"
  "volatile"
  "while"
] @keywords

[
  "#define"
  "#elif"
  "#else"
  "#endif"
  "#if"
  "#ifdef"
  "#ifndef"
  "#include"
] @keywords

(preproc_directive) @keywords


; MARK: Commands
; ----------------------------

(call_expression
  function: (identifier) @commands)

(call_expression
  function: (field_expression
    field: (field_identifier) @commands))

(function_declarator
  declarator: (identifier) @commands)

(preproc_function_def
  name: (identifier) @commands)


; MARK: Types
; ----------------------------

[
  (type_identifier)
  (primitive_type)
  (sized_type_specifier)
] @types

(struct_specifier
  name: (type_identifier) @types)

(union_specifier
  name: (type_identifier) @types)

(enum_specifier
  name: (type_identifier) @types)

(type_definition
  declarator: (type_identifier) @types)


; MARK: Values
; ----------------------------

((identifier) @values
  (#match? @values "^[A-Z][A-Z\\d_]*$"))

(null) @values.builtin


; MARK: Numbers
; ----------------------------

(number_literal) @numbers


; MARK: Strings
; ----------------------------

[
  (string_literal)
  (system_lib_string)
] @strings


; MARK: Characters
; ----------------------------

(char_literal) @characters


; MARK: Comments
; ----------------------------

(comment) @comments

; MARK: End of directives inherited from C
; ============================

; Preprocs

(preproc_undef
  name: (_) @values) @keywords

; Includes

(module_import "@import" @keywords path: (identifier) @types)

((preproc_include
  _ @keywords path: (_))
  (#any-of? @keywords "#include" "#import"))

; Type Qualifiers

[
  "@optional"
  "@required"
  "__covariant"
  "__contravariant"
  (visibility_specification)
] @types

; Storageclasses

[
  "@autoreleasepool"
  "@synthesize"
  "@dynamic"
  "volatile"
  (protocol_qualifier)
] @keywords

; Keywords

[
  "@protocol"
  "@interface"
  "@implementation"
  "@compatibility_alias"
  "@property"
  "@selector"
  "@defs"
  "availability"
  "@end"
] @keywords

(class_declaration "@" @keywords "class" @keywords) ; I hate Obj-C for allowing "@ class" :)

(method_definition ["+" "-"] @keywords)
(method_declaration ["+" "-"] @keywords)

[
  "__typeof__"
  "__typeof"
  "typeof"
  "in"
] @keywords

[
  "@synchronized"
  "oneway"
] @keywords

; Exceptions

[
  "@try"
  "__try"
  "@catch"
  "__catch"
  "@finally"
  "__finally"
  "@throw"
] @keywords

; Variables

((identifier) @variables
  (#any-of? @variables "self" "super"))

; Functions & Methods

[
  "objc_bridge_related"
  "@available"
  "__builtin_available"
  "va_arg"
  "asm"
] @commands

(method_definition (identifier) @commands)

(method_declaration (identifier) @commands)

(method_identifier (identifier)? @commands ":" @commands (identifier)? @commands)

(message_expression method: (identifier) @commands)

; Constructors

((message_expression method: (identifier) @commands)
  (#eq? @commands "init"))

; Attributes

(availability_attribute_specifier 
  [
    "CF_FORMAT_FUNCTION" "NS_AVAILABLE" "__IOS_AVAILABLE" "NS_AVAILABLE_IOS"
    "API_AVAILABLE" "API_UNAVAILABLE" "API_DEPRECATED" "NS_ENUM_AVAILABLE_IOS"
    "NS_DEPRECATED_IOS" "NS_ENUM_DEPRECATED_IOS" "NS_FORMAT_FUNCTION" "DEPRECATED_MSG_ATTRIBUTE"
    "__deprecated_msg" "__deprecated_enum_msg" "NS_SWIFT_NAME" "NS_SWIFT_UNAVAILABLE"
    "NS_EXTENSION_UNAVAILABLE_IOS" "NS_CLASS_AVAILABLE_IOS" "NS_CLASS_DEPRECATED_IOS" "__OSX_AVAILABLE_STARTING"
    "NS_ROOT_CLASS" "NS_UNAVAILABLE" "NS_REQUIRES_NIL_TERMINATION" "CF_RETURNS_RETAINED"
    "CF_RETURNS_NOT_RETAINED" "DEPRECATED_ATTRIBUTE" "UI_APPEARANCE_SELECTOR" "UNAVAILABLE_ATTRIBUTE"
  ]) @attributes

; Macros

(type_qualifier
  [
    "_Complex"
    "_Nonnull"
    "_Nullable"
    "_Nullable_result"
    "_Null_unspecified"
    "__autoreleasing"
    "__block"
    "__bridge"
    "__bridge_retained"
    "__bridge_transfer"
    "__complex"
    "__kindof"
    "__nonnull"
    "__nullable"
    "__ptrauth_objc_class_ro"
    "__ptrauth_objc_isa_pointer"
    "__ptrauth_objc_super_pointer"
    "__strong"
    "__thread"
    "__unsafe_unretained"
    "__unused"
    "__weak"
  ]) @keywords

[ "__real" "__imag" ] @keywords

((call_expression function: (identifier) @keywords)
  (#eq? @keywords "testassert"))

; Types

(class_declaration (identifier) @types)

(class_interface "@interface" . (identifier) @types superclass: _? @types category: _? @types)

(class_implementation "@implementation" . (identifier) @types superclass: _? @types category: _? @types)

(protocol_forward_declaration (identifier) @types) ; @interface :(

(protocol_reference_list (identifier) @types) ; ^

[
  "BOOL"
  "IMP"
  "SEL"
  "Class"
  "id"
] @types

; Constants

(property_attribute (identifier) @values "="?)

[ "__asm" "__asm__" ] @values

; Properties

(property_implementation "@synthesize" (identifier) @attributes)

((identifier) @attributes
  (#has-ancestor? @attributes struct_declaration))

; Parameters

(method_parameter ":" @commands (identifier) @attributes)

(method_parameter declarator: (identifier) @attributes)

(parameter_declaration 
  declarator: (function_declarator 
                declarator: (parenthesized_declarator 
                              (block_pointer_declarator 
                                declarator: (identifier) @attributes))))

"..." @attributes

; Operators

[
  "^"
] @keywords

; Literals

(platform) @strings

(version_number) @strings @numbers

; Punctuation

"@" @keywords

[ "<" ">" ] @keywords
